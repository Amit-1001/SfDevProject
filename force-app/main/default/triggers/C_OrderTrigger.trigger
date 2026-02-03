trigger C_OrderTrigger on Order__c (before insert, after insert, before update, after update) {
    
    C_OrderTrigger_Dispatcher.dispatch(Trigger.OperationType);

}