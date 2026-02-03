trigger OppportunityTrigger on Opportunity (after insert, after update, after delete, after undelete) {
    
    OpportunityTriggerDispatcher.dispatch(Trigger.OperationType);

}