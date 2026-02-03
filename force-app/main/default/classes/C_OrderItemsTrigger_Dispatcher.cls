public class C_OrderItemsTrigger_Dispatcher {
    
    public static void dispatch(System.TriggerOperation operationType){
        switch on operationType{  
            when BEFORE_INSERT{
            	C_OrderItemsTrigger_handler.validateStock(Trigger.new);
        	}
            when AFTER_INSERT{
             	C_OrderItemsTrigger_handler.reserveStock(Trigger.new);   
            }
            When BEFORE_UPDATE{
                
			}
            when AFTER_UPDATE{
                
            }
            
         }
    }

}