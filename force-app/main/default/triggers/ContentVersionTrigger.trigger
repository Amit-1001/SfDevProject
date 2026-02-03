trigger ContentVersionTrigger on ContentVersion (after insert) {
    ContentVersionDispatcher.dispatch(Trigger.operationType);
}