trigger EventAttendeeTriggerV1 on Event_Attendee__c (before insert,after insert) {

    EventAttendeeTriggerDispatcher.dispatch(Trigger.OperationType);

}