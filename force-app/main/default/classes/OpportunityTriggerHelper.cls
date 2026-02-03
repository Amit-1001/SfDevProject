public class OpportunityTriggerHelper {
    
    public static void getSumOfClosedOpp(Map<Id,Opportunity> newOpportunityRecord){
         Set<Id> opportunityIdsSet = new Set<Id>();
        for(Opportunity opp: newOpportunityRecord.Values()){
            if(opp.AccountId!=null){ // if oppotunity is related to any Account then store its id
                opportunityIdsSet.add(opp.AccountId);
                System.debug(opp.AccountId);
            }
        }
        
        List<AggregateResult> aggregateList = new List<AggregateResult>();
       // Select Sum(Amount) closed_amount, AccountId from Opportunity where StageName IN('Closed Won', 'Closed Lost') group by AccountId
       
       aggregateList = [Select Sum(Amount) ClosedOppSum, AccountId from Opportunity where AccountId IN:opportunityIdsSet and StageName IN('Closed Won', 'Closed Lost') group by AccountId];
    
      List<Account> accountUpdatedList = new List<Account>();
        
        for(AggregateResult agr: aggregateList){
            Decimal sum = (Decimal)agr.get('ClosedOppSum');
            String AccountId = (String)agr.get('AccountId');
            
            Account newAccount = new Account();
            newAccount.Sum_of_closed_opportunity_Amount__c = sum;
            newAccount.Id = AccountId;
            accountUpdatedList.add(newAccount);
        }
        update accountUpdatedList;
    }

}