public with sharing class CaseTriggerHandler {
    public CaseTriggerHandler() {

    }

    public static void handleAfterInsert(Map<Id,Case> newRecordMap){
        Set<Id> accountIds = new Set<Id>();
        try {
                if (newRecordMap == null) {
                    throw new NullPointerException();
                }
            } catch (Exception e) {
                TransactionErrorLog.handleException(e, 'Case_Trigger_Handler');
                return;
            }

        // storing account id present in case
        for(Case c : newRecordMap.values()){ 
            if(c.AccountId!=null){
                accountIds.add(c.AccountId);

            }
        }

        // Method 1: fetch all cases from Account here we are using inner query as we are getting data from Parent to child

        List<Account> accountList = [SELECT Id, (SELECT Id FROM Cases) FROM Account WHERE Id IN: accountIds];
        List<Account> accountToUpdate = new List<Account>();

        

        for(Account acc: accountList){
            if(acc.Cases.size()>0){
                Account accTemp = new Account();
                accTemp.Id = acc.Id;
                accTemp.Number_of_Cases__c = (acc.Cases.size()>=0?acc.Cases.size():0);
                accountToUpdate.add(accTemp);
            }
        }


    Database.SaveResult[] results = Database.update(accountToUpdate,false);
    for(Database.SaveResult sr: results){
            if(!sr.isSuccess()){

                String er = sr.getErrors().toString();
                TransactionErrorLog.handleError(er, 'Case_Trigger_Handler');
            }
        }
    }
}