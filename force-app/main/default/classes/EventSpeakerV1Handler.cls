public with sharing class EventSpeakerV1Handler {
    public static void handleDuplicateSpeaker(List<EventSpeakers__c> eventSpeakers) {

        Set<Id> eventId = new Set<Id>();
        Set<Id> speakerId = new Set<Id>();

        // get Event Id and Speaker Id
        for(EventSpeakers__c es : eventSpeakers){
            if(es.Event__c!=null && es.Speaker__c!=null){
                eventId.add(es.Event__c);
                speakerId.add(es.Speaker__c);
            }
        }

        // get all event Id and Start time from EventId
        Map<Id,Datetime> requestedEvents = new Map<Id,Datetime>();
        List<Event__c> releatedEvent = [Select Id, Start_DateTime__c from Event__c where Id IN: eventId];

        for(Event__c e: releatedEvent){
            requestedEvents.put(e.Id, e.Start_DateTime__c);
        }

        // get all event speaker from Speaker Id along with EventId , Speaker Id and Event Start time
        List<EventSpeakers__c> eventSpeakersList = [Select Id, Event__c, Speaker__c, Event__r.Start_DateTime__c from EventSpeakers__c where Speaker__c IN: speakerId];

        for (EventSpeakers__c es : eventSpeakers) { // traversing over current EventSpeaker (passed into handler)
            Datetime bookingTime = requestedEvents.get(es.Event__c); // get start date time of current event
            if (bookingTime == null) {
                continue; // event not found in map, skip to avoid NPE
            }
            for (EventSpeakers__c es1 : eventSpeakersList) { // iterate stored EventSpeaker list
                if (es.Speaker__c == es1.Speaker__c && es1.Event__r.Start_DateTime__c == bookingTime) {
                    es.Speaker__c.addError('Speaker already booked for this event');
                }
            }
        }
    }
}
