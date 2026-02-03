trigger EventSpeakerTriggerV1 on EventSpeakers__c (before insert,before update) {

    EventSpeakersV1Dispatcher.dispatch(Trigger.OperationType);


}