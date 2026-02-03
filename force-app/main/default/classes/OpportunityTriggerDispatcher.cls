public class OpportunityTriggerDispatcher {
    
    public static void dispatch(System.TriggerOperation operationType){
        switch on operationType{
            when AFTER_INSERT{
                OpportunityTriggerHandler.handleAfterInsert((Map<Id,Opportunity>)Trigger.newMap);
            }
            when AFTER_UPDATE{
                
            }
            when AFTER_DELETE{
                OpportunityTriggerHandler.handlerAfterDelete((Map<Id,Opportunity>) Trigger.oldMap);
            }
            When AFTER_UNDELETE{
                OpportunityTriggerHandler.handlerAfterUndelete((Map<Id,Opportunity>)Trigger.newMap);
            }
        }
    }

}