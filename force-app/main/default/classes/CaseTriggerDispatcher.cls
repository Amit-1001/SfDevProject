public with sharing class CaseTriggerDispatcher {
    public CaseTriggerDispatcher() {

    }

    public static void dispatch(System.TriggerOperation operationType){
        switch on operationType{
            when AFTER_INSERT{
                CaseTriggerHandler.handleAfterInsert((Map<Id,Case>)Trigger.newMap);
            }
        }
    }
}