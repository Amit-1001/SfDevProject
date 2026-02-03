public class ContentVersionDispatcher {
    
    public static void dispatch(System.TriggerOperation operationType){
        switch on operationType{
            when AFTER_INSERT{
                System.Debug('Trigger Activated');
                ContentVersionHandler.contentVersionHandlerAfterInsert(Trigger.new);
            }
        }
    }

}