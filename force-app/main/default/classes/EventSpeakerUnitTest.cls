/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EventSpeakerUnitTest {

    @TestSetup
    static void setupData() {
        // Create a Speaker (Contact) and two Events with same Start time and one with different time
        Speaker__c speaker = new Speaker__c(Name= 'Test Speaker',Phone__c='1234567890',Email__c ='test@gmail.com');
        insert speaker;

        //Create a Event Organizer
        Event_Organizer__c eventOrganizer = new Event_Organizer__c(Name = 'Test Event Organizer', Phone__c = '1234', Email__c = 'test@gmail.com');
        insert eventOrganizer;

        // Common start time for duplicate scenario - align to the start of the next hour
        Datetime nowDt = Datetime.now().addDays(1);
        Date d = nowDt.date();
        Time t = nowDt.time();
        Integer startHour = t.hour() + 1; // next whole hour
        if (startHour >= 24) {
            d = d.addDays(1);
            startHour = 0;
        }
        Datetime commonStart = Datetime.newInstance(d, Time.newInstance(startHour, 0, 0, 0));

        Event__c eventA = new Event__c(Name__c = 'Event A', Start_DateTime__c = commonStart,Max_Seats__c = 20,Event_Organizer__c = eventOrganizer.Id,	Live__c =true);
        Event__c eventB = new Event__c(Name__c = 'Event B', Start_DateTime__c = commonStart, Max_Seats__c = 20,Event_Organizer__c = eventOrganizer.Id, Live__c =true);
        Event__c eventC = new Event__c(Name__c = 'Event C', Start_DateTime__c = commonStart.addHours(2),Max_Seats__c=10,Event_Organizer__c = eventOrganizer.Id, Live__c =true);
        insert new List<Event__c>{ eventA, eventB, eventC };

        // Seed an existing EventSpeakers__c to simulate a prior booking (speaker booked on eventA at commonStart)
        EventSpeakers__c existingBooking = new EventSpeakers__c(
            Event__c = eventA.Id,
            Speaker__c = speaker.Id
        );
        insert existingBooking;

        // Store Ids via a static container records if needed later (we can query them in tests as well)
    }

    @isTest
    static void shouldPreventDuplicateSpeakerOnSameStartTime_BeforeInsert() {
        // Arrange
        Speaker__c spk = [SELECT Id FROM Speaker__c LIMIT 1];
        // Get event with same start as existing booking and an event with different start
        List<Event__c> events = [
            SELECT Id, Start_DateTime__c
            FROM Event__c
            ORDER BY Start_DateTime__c ASC
            LIMIT 3
        ];
        // Identify events by time: first two share same time per setup
        Event__c sameTimeEvent = events[1]; // eventB has same start as eventA
        Event__c differentTimeEvent = events[2]; // eventC has different start

        // Build two EventSpeakers: one should error (duplicate time), one should pass
        EventSpeakers__c dup = new EventSpeakers__c(Event__c = sameTimeEvent.Id, Speaker__c = spk.Id);
        EventSpeakers__c ok = new EventSpeakers__c(Event__c = differentTimeEvent.Id, Speaker__c = spk.Id);

        Test.startTest();
        Database.SaveResult[] results = Database.insert(new List<EventSpeakers__c>{ dup, ok }, false);
        Test.stopTest();

        // Assert
        System.assertEquals(2, results.size(), 'Two save results expected');
        // First should be error with our message
        System.assertEquals(false, results[0].isSuccess(), 'Duplicate should fail');
        System.assert(results[0].getErrors().size() > 0, 'Duplicate should have errors');
        System.assert(
            String.valueOf(results[0].getErrors()[0].getMessage()).contains('Speaker already booked for this event'),
            'Error message should indicate duplicate booking'
        );

        // Second should succeed
        System.assertEquals(true, results[1].isSuccess(), 'Different time booking should succeed');
    }

    @isTest
    static void shouldPreventDuplicateSpeakerOnSameStartTime_BeforeUpdate() {
        // Arrange: insert a valid new booking for different time, then update it to collide with existing
        Speaker__c spk = [SELECT Id FROM Speaker__c LIMIT 1];

        // Query the three events prepared in setup
        List<Event__c> events = [
            SELECT Id, Start_DateTime__c
            FROM Event__c
            ORDER BY Start_DateTime__c ASC
            LIMIT 3
        ];
        Event__c baseSameTime = events[0]; // eventA (already has a booking)
        Event__c sameTimeEvent = events[1]; // eventB shares the same start
        Event__c differentTimeEvent = events[2]; // eventC different start

        // Create a booking on different time (eventC) - should insert successfully
        EventSpeakers__c moveToConflict = new EventSpeakers__c(Event__c = differentTimeEvent.Id, Speaker__c = spk.Id);
        insert moveToConflict;

        // Act: attempt to update to same time as existing booking (baseSameTime or sameTimeEvent)
        moveToConflict.Event__r = sameTimeEvent;

        Test.startTest();
        Database.SaveResult updResult = Database.update(moveToConflict, false);
        Test.stopTest();

        // Assert: update should fail due to duplicate at same start time
        System.assertEquals(false, updResult.isSuccess(), 'Update causing time conflict should fail');
        System.assert(updResult.getErrors().size() > 0, 'Update should have an error');
        System.assert(
            String.valueOf(updResult.getErrors()[0].getMessage()).contains('Speaker already booked for this event'),
            'Error message should indicate duplicate booking on update'
        );
    }
}
