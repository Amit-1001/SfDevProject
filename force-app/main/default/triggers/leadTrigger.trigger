trigger leadTrigger on Lead (before insert,after insert, after update) {
    
    leadTriggerDispatcher.dispatch(Trigger.OperationType);

}