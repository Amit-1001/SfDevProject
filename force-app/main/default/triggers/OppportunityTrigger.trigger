trigger OppportunityTrigger on Opportunity (before update,after insert, after update, after delete, after undelete) {
    
    OpportunityTriggerDispatcher.dispatch(Trigger.OperationType);

}