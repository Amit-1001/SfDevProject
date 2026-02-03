public class OrderTriggerDispatcher {
    
    public static void dispatch(System.TriggerOperation operationType){
        switch on operationType{
            when AFTER_INSERT{
                //OrderTriggerHandler.orderAfterUpdate(Trigger.New);
            }
            
            when AFTER_UPDATE{
                OrderTriggerHandler.orderAfterUpdate((List<Order>)Trigger.New, (Map<Id, Order>)Trigger.newMap);
            }
            When AFTER_DELETE{
            }
            
            When AFTER_UNDELETE{

            }
        }
    }

}