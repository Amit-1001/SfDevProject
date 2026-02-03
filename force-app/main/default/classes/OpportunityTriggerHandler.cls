public class OpportunityTriggerHandler {
    public static void handleAfterInsert(Map<Id,Opportunity> newOpportunityRecord){
       OpportunityTriggerHelper.getSumOfClosedOpp(newOpportunityRecord);
    }
    
    public static void handlerAfterDelete(Map<Id,Opportunity> oldOpportunityRecord){
        OpportunityTriggerHelper.getSumOfClosedOpp(oldOpportunityRecord);
    }
    
    public static void handlerAfterUndelete(Map<Id,Opportunity> newOpportunityRecord){
        OpportunityTriggerHelper.getSumOfClosedOpp(newOpportunityRecord);
    }
}