public class ContactTriggerHelper {
    public static void countContact(Map<Id,Contact> newRecordMap){
         
        Set<Id> accountIdsSet = new Set<Id>();
        
        for(Contact con: newRecordMap.values()){
            if(con.AccountId != null){ // check if contact is related to Account
                accountIdsSet.add(con.AccountId);
            }
        }
        /* Solution 1 : Inner Query
        List<Account> accountList = new List<Account>();
        accountList = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE ID IN: accountIdsSet];
        // here we are fetching all contacts related to Account
        // issue with this inner query is it can only fetch upto 50k data at time.
        for(Account acc: accountList){
            List<Contact> contList = acc.Contacts; // list of contact associated with acc
            if(contList!=null){
				Integer size = contList.size();
                acc.Number_of_contacts__c = size; // updating count of Contact on Account detail page
            }
            
        }
        update accountList; // updating Account record this is required if we are updating record
      	*/
        
        // Solution 2
        // Use Aggregate function like SUM, MIN, MAX, COUNT
		List<AggregateResult> aggregateList = [Select count(Id) totalCount, AccountId from Contact where AccountId IN: accountIdsSet group by AccountId];
        // here we are fetching contact for only IDs which are not null and grouping them based on AccountID
       
        System.debug(aggregateList); 
        // AggregateResult:{expr0=3, AccountId=001gL00000DeLsfQAF} here expre0 is count of Id and AccountId = ID of current account if we add another colum in SOQL then it will give exper1 = Value
    	// Aggregate function is given as expr0 , expr1 ...
    	// if we give any alias then it will show alias name
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