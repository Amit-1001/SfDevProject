trigger OrderTrigger on Order (before insert, after update) {
    OrderTriggerDispatcher.dispatch(Trigger.OperationType);

}