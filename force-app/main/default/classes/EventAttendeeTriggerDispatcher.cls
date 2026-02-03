public with sharing class EventAttendeeTriggerDispatcher {
    public static void dispatch(System.TriggerOperation operationType) {
        switch on operationType {
            when BEFORE_INSERT {
                // No-op for BEFORE_INSERT currently
            }
            when AFTER_INSERT {
                // Call correct handler signature
                EventAttendeeTriggerHandlerV1.sendEmailNotification((List<Event_Attendee__c>) Trigger.new);
            }
            when BEFORE_UPDATE {
                // No-op for BEFORE_UPDATE currently
            }
            when AFTER_UPDATE {
                // No-op for AFTER_UPDATE currently
            }
        }
    }
}
