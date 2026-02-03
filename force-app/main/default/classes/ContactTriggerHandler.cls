public class ContactTriggerHandler {
    
    /*Contact Roll up summery  */
    public static void handleAfterInsert(Map<Id,Contact> newRecordMap){
        ContactTriggerHelper.countContact(newRecordMap);
        
        Set<Id> accountId = new Set<Id>();
        for(Contact cont : newRecordMap.values()){ // storing Account id 
            if(cont.AccountId!=null){
                accountId.add(cont.AccountId);
            }
        }
        
        List<Opportunity> opportunityUpdateInfo = new List<Opportunity>();
        
        opportunityUpdateInfo = [Select Id, AccountId, Account.Name, Account.Industry, Account.Rating from Opportunity where AccountId In: accountId];
        for(Opportunity opp: opportunityUpdateInfo){
           opp.AccountId = opp.Account.Name;
            opp.Account_Industry__c = opp.Account.Industry;
            opp.Account_Phone__c = opp.Account.Phone;
            opp.Account_Rating__c = opp.Account.Rating; 
        }
       update as user opportunityUpdateInfo; // update as user is kind of safer way that just update opportunityUpdateInfo
    }
    
    public static void handleAfterUndelete(Map<Id,Contact> newRecordMap){
        ContactTriggerHelper.countContact(newRecordMap);

    }
    
    public static void handlerAfterDelete(Map<Id, Contact> oldRecordMap){
        ContactTriggerHelper.countContact(oldRecordMap);
    }
    
    public static void handlerAfterUpdate(Map<Id,Contact> newRecordMap,Map<Id,Contact> oldRecordMap){
         Set<Id> accountIdsSet = new Set<Id>();
        
        for(Contact  newRecord:newRecordMap.values()){
            Contact oldRecord = oldRecordMap.get(newRecord.AccountId);
            if(oldRecord.AccountId != newRecord.AccountId){ // if there is change in account id then store both old and new record
                accountIdsSet.add(oldRecord.AccountId); // storing id of old record
                accountIdsSet.add(newRecord.AccountId); // storing id of new record
            }
        }   
        List<AggregateResult> aggregateList = new List<AggregateResult>();
        aggregateList = [Select count(id) totalCount, AccountId from Contact where AccountId IN: accountIdsSet group by AccountId];
        
        List<Account> accountListUpdated = new List<Account>();
        for(AggregateResult agr: aggregateList){
            Integer totalCount = (Integer)agr.get('totalCount');
            String AccountId = (String)agr.get('AccountId');
            
            Account acc = new Account();
            acc.Id = AccountId;
            acc.Number_of_contacts__c = totalCount;
            accountListUpdated.add(acc);
        }
    	
        update accountListUpdated;
    }

}