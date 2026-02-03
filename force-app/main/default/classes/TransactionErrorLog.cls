public class TransactionErrorLog {
    public static void handleException(System.Exception ex, String processName){
        	List<System_Events__c> eventList = new List<System_Events__c>();
        	
            System_Events__c event = new System_Events__c(Log_Details__c = ex.getStackTraceString()+'<br/>'+'Message is :'+ex.getMessage()+ex.getCause()+ex.getTypeName()+ex.getLineNumber(),
													Local_Date_Time__c= System.now(),Name = processName);
			eventList.add(event);
            insert eventList;
        
        
    }

    public static void handleError(String Error, String processName){
        	List<System_Events__c> eventList = new List<System_Events__c>();
        	
            System_Events__c event = new System_Events__c(Log_Details__c = 'Message is :'+Error,
													Local_Date_Time__c= System.now(),Name = processName);
			eventList.add(event);
            insert eventList;
        
        
    }

}