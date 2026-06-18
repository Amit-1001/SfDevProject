public with sharing class AccountLWCHelper {
    public AccountLWCHelper() {

    }

    @AuraEnabled(cacheable=true)
    public static Account getAccountById(String recordId){
        List<Account> accountList = [Select Id , Name , Active__c from Account where Id =: recordId LIMIT 1];
        try {
            if (!accountList.isEmpty()) {
                return accountList[0];
        } else {
            // Throw a custom exception that LWC can catch and display
            throw new AuraHandledException('No Account found with ID: ' + recordId);
        }
        }catch (Exception e) {
            // Wrap any other system errors
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled 
    public static String deactivateAccount(String recordId){
        List<Account> accountList = [Select Id , Name , Active__c from Account where Id =: recordId LIMIT 1 FOR UPDATE ];
        try {
            if (!accountList.isEmpty()) {
                Account account = accountList[0];

                if(account.Active__c == 'No'){
                    throw new AuraHandledException('Account is already in InActive state!');
                    
                }else{
                    account.Active__c = 'No';
                    update account;
                    return 'Account Status Updated Successfully!';
                }
        } else {
            // Throw a custom exception that LWC can catch and display
            throw new AuraHandledException('No Account found with ID: ' + recordId);
        }
    }catch (Exception e) {
        // Wrap any other system errors
        throw new AuraHandledException(e.getMessage());
    }
        
    }

    @AuraEnabled(cacheable = true)
    public static List<Account> getAllAccounts(){

        return [SELECT Id, Name, Active__c FROM Account limit 5];

    }
}