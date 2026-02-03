@isTest
public with sharing class DeleteEventBatchTest {

    public DeleteEventBatchTest() {

    }

    @TestSetup
    static void makeData(){

        List<Event__c> eventList = new List<Event__c>();
        Event_Organizer__c  org = new Event_Organizer__c (
            Name = 'Amit Singh',
            Phone__c = '9807654321',
            Email__c = 'sfdcpanther@gmail.com.dev1',
            Alternative_Phone__c  = '9807654321',
            Alternative_Email__c ='sfdcpanther@gmail.com.dev1'
        );
        insert org;

        // Create 200 events
        for(Integer i=0;i<200;i++){
            Event__c event = new Event__c(
            Name__c = 'MAX FIT Campaign #'+i,
            Event_Organizer__c  = org.Id,
            Event_Type__c = 'Virtual',
            Frequency__c  = 'Weekly',
            Max_Seats__c  = 199,
            Recurring__c = true,
            Live__c = true,
            Start_DateTime__c = System.now().addMonths(-4),
            End_Date_Time__c  = System.now().addDays(3).addMonths(-4)
        );
        eventList.add(event);
        }

        }

    @isTest
    public static void testDeleteEventBatch(){
        Test.startTest();
        Database.executeBatch(new DeleteEventBatch(),250);
        Test.stopTest();
    }
        
    
}