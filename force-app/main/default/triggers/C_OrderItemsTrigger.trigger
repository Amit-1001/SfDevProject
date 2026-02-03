trigger C_OrderItemsTrigger on Order_Items__c (before insert,After insert, before update, after update,before delete, after delete) {
    
    C_OrderItemsTrigger_Dispatcher.dispatch(Trigger.OperationType);

}