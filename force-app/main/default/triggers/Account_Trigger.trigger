trigger Account_Trigger on Account (before insert, before update, after insert) {
    AccountTriggerDispatcher.runDispatcher(Trigger.OperationType); // this will have all trigger event
}