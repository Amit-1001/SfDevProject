public class ContactTriggerDispatcher {
    
    public static void dispatch(System.TriggerOperation operationType){
        switch on operationType{
            when AFTER_INSERT{
                ContactTriggerHandler.handleAfterInsert((Map<Id,Contact>)Trigger.newMap); // type reference is important here
                
            }
            
            when AFTER_UPDATE{
                ContactTriggerHandler.handlerAfterUpdate((Map<Id,Contact>) Trigger.newMap ,(Map<Id,Contact>) Trigger.oldMap);
            }
            When AFTER_DELETE{
                ContactTriggerHandler.handlerAfterDelete((Map<Id,Contact>) Trigger.oldMap);
            }
            
            When AFTER_UNDELETE{
               ContactTriggerHandler.handleAfterUndelete((Map<Id,Contact>)Trigger.newMap); // type reference is important here

            }
        }
    }

}