public with sharing class LoanApplicationHelper {
    public LoanApplicationHelper() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Loan_Application__c> getAllLoans(){
        List<Loan_Application__c> loans = [Select Id, Name, Loan_Amount__c, Status__c,Customer__r.Name from Loan_Application__c limit 20];

        if(loans == null && loans.isEmpty()){
            throw new AuraHandledException('No loan found!');
        }

        return loans;
    }

    @AuraEnabled(cacheable=true)
    public static Loan_Application__c getLoanApplicationByName(String recordId){
        return [SELECT Id, Name, Loan_Amount__c,Status__c,Customer__r.Name FROM Loan_Application__c WHERE Id =:recordId LIMIT 1];
    }

    @AuraEnabled
    public static String updateLoanStatus(String recordId){
        try{
            Loan_Application__c loan = [SELECT Id, Status__c FROM Loan_Application__c WHERE ID =:recordId LIMIT 1];
            
            if(loan.Status__c == 'Approved'){
            throw new AuraHandledException('Loan is already approved');
            }
                    
            loan.Status__c = 'Approved';
            update loan;
            return 'Loan Approved!';
                    
        }
    catch(Exception e){
        throw new AuraHandledException(e.getMessage());
    }
    }

    @AuraEnabled(cacheable=true)
    public static List<Loan_Application__c> getPendingLoans(){
        
        try {
            List<Loan_Application__c> loanList = [SELECT Id, Name , Customer__r.Name , Loan_Amount__c,Status__c FROM Loan_Application__c WHERE Status__c =: 'Pending' limit 20];
            if(!loanList.isEmpty()){
                return loanList;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return null;
    }

    @AuraEnabled
    public static String approveLoan(String recordId){
        try {
            Loan_Application__c loanAP = [SELECT Id, Status__c from Loan_Application__c WHERE Id =: recordId limit 1];

            if(loanAP!=null){
                if(loanAP.Status__c != 'Pending'){
                    throw new AuraHandledException('Loan Application should be in Pendding State!');
                }
                else{
                    loanAP.Status__c = 'Approved';
                    update loanAP;
                    return 'Loan Approved Successfully!';
                }
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    throw new AuraHandledException('Unexpected Error');
    }

    @AuraEnabled
    public static String rejectLoan(String recordId){
        try {
            Loan_Application__c loanAP = [SELECT Id, Status__c from Loan_Application__c WHERE Id =: recordId limit 1];

            if(loanAP!=null){
                if(loanAP.Status__c != 'Pending'){
                    throw new AuraHandledException('Loan Application should be in Pendding State!');
                }
                else{
                    loanAP.Status__c = 'Rejected';
                    update loanAP;
                    return 'Loan Reject Successfully!';
                }
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    throw new AuraHandledException('Unexpected Error');
    }


    @AuraEnabled
    public static String updateLoan(List<Loan_Application__c> loanList){
        try {
            if(!loanList.isEmpty()){
            update loanList;
            return 'Loan updated Successfully!';
        }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
        }
        return 'Something went wrong!';
        
    }


    @AuraEnabled(cacheable=true)
    public static List<Loan_Application__c> searchLoanByName(String name){
        try {

            // if search box empty
            if(String.isBlank(name)){

                return [

                    SELECT
                        Id,
                        Name,
                        Loan_Amount__c,
                        Status__c,
                        Customer__r.Name

                    FROM Loan_Application__c

                    LIMIT 50
                ];
            }

            String searchKey =
                '%' + name + '%';

            List<Loan_Application__c> loanList = [

                SELECT
                    Id,
                    Name,
                    Loan_Amount__c,
                    Status__c,
                    Customer__r.Name

                FROM Loan_Application__c

                WHERE

                    Name LIKE :searchKey

                    OR

                    Customer__r.Name LIKE :searchKey

                LIMIT 50
            ];

            return loanList;

        }

        catch(Exception e){

            throw new AuraHandledException(
                e.getMessage()
            );
        }

    }

    // Server side pagination
    @AuraEnabled(cacheable=true)
    public static List<Loan_Application__c> getPaginatedLoans(Integer pageSize, Integer pageNumber){

        try {

            Integer offsetValue = (pageNumber-1) * pageSize;

            return [
                SELECT Id, Name , Customer__r.Name , Loan_Amount__c, Status__c
                FROM Loan_Application__c
                ORDER BY CreatedDate DESC
                LIMIT:pageSize
                OFFSET:offsetValue
            ];
            
        } catch (Exception e) {
            throw new AuraHandledException('exception'+e.getMessage());
        }

    }





}