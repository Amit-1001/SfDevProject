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

    public static void restrictOppModify(Map<Id,Opportunity> newOpp, Map<Id,Opportunity> oldOppMap){

        Id profileId = UserInfo.getProfileId();

        Profile currentUserProfile = [Select Id, Name from Profile where Id =: profileId limit 1];

        Boolean isAdmin = (currentUserProfile.Name == 'System Administrator');

        Id currentUserId = UserInfo.getCurrentUvid();

        for(Opportunity opp: newOpp.values()){
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            if(oldOpp.OwnerId != currentUserId && !isAdmin){
                opp.addError('Only the Opportunity Owner and System Administrators are allowed to modify this record.');
            }
        }
    }
}