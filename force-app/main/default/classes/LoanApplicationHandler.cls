public class LoanApplicationHandler {
    
    public static void handleBeforeInsert(List<Loan_Application__c> applicationList){
        
        Set<Id>  customerIds = new Set<Id>();
        for(Loan_Application__c loanAP: applicationList){
            if(loanAP.Customer__c!=null){
                customerIds.add(loanAP.Customer__c);
            }
        }
        
        List<AggregateResult> totalLoanAmount = [
            SELECT Customer__c customerId,
                   SUM(Loan_Amount__c) totalAmount
            FROM Loan_Application__c
            WHERE Customer__c IN :customerIds
            AND Status__c IN ('Approved','Disbursed')
            GROUP BY Customer__c
        ];        
        
        Map<Id,Decimal> customerTotalAmountMap = new Map<Id,Decimal>();
        
        //Existing Loan Amount Stored in Map
        for(AggregateResult agr: totalLoanAmount){
            Decimal total = (Decimal) agr.get('totalAmount');
            Id customerId = (Id) agr.get('customerId');
           customerTotalAmountMap.put(customerId,total);
        }
        
        //Calculating current Total
        for(Loan_Application__c loanAP: applicationList){
            if(loanAP.Customer__c == null || loanAP.Loan_Amount__c == null){
                continue;
            }
             if(loanAP.Status__c!='Approved' && loanAP.Status__c!='Disbursed' ){
                continue;
            }
            
           
            
            Decimal currentTotal = customerTotalAmountMap.containsKey(loanAP.Customer__c)? customerTotalAmountMap.get(loanAP.Customer__c):0;
            currentTotal += loanAP.Loan_Amount__c;
            if(currentTotal>=1100000){
                loanAP.addError(
                'Customer total active loan amount cannot exceed ₹10,00,000.'
            );
            }
            customerTotalAmountMap.put(loanAP.Customer__c,currentTotal); // storing new added loan amount with existing
            
        }
        
        
        
    }
    
    public static void handleBeforeUpdate(Map<Id,Loan_Application__c> newMap, Map<Id,Loan_Application__c> oldMap){
        Set<Id> customerIds = new Set<Id>();
        for(Loan_Application__c loanAP: newMap.values()){
            Loan_Application__c oldAP = oldMap.get(loanAP.Id);
            
            
            // Only taking changed value
            if(loanAP.Customer__c != oldAP.Customer__c || loanAP.Loan_Amount__c != oldAP.Loan_Amount__c || loanAP.Status__c!=oldAP.Status__c){
                if(loanAP.Customer__c != null){
                    customerIds.add(loanAP.Customer__c);
                }
        
                if(oldAP.Customer__c != null){
                    customerIds.add(oldAP.Customer__c);
                }
            }
        }
        
          List<AggregateResult> totalLoanAmount = [
            SELECT Customer__c customerId,
                   SUM(Loan_Amount__c) totalAmount
            FROM Loan_Application__c
            WHERE Customer__c IN :customerIds
            AND Status__c IN ('Approved','Disbursed')
            AND Id NOT IN: newMap.keySet()
            GROUP BY Customer__c
        ];        
        
        
        // Storing Past loan amount of respective customer in Map
        Map<Id,Decimal> customerTotalAmountMap = new Map<Id,Decimal>();
        
          
        //Existing Loan Amount Stored in Map
        for(AggregateResult agr: totalLoanAmount){
            Decimal total = (Decimal) agr.get('totalAmount');
            Id customerId = (Id) agr.get('customerId');
           customerTotalAmountMap.put(customerId,total);
        }
        
        
         //Calculating current Total
        for(Loan_Application__c loanAP: newMap.values()){
            if(loanAP.Customer__c == null || loanAP.Loan_Amount__c == null){
                continue;
            }
            if(loanAP.Status__c!='Approved' && loanAP.Status__c!='Disbursed' ){
                continue;
            }
            Decimal currentTotal = customerTotalAmountMap.containsKey(loanAP.Customer__c)? customerTotalAmountMap.get(loanAP.Customer__c):0;
            currentTotal += loanAP.Loan_Amount__c;
            
                if(currentTotal > 1000000){
        
                    loanAP.addError(
                        'Customer total active loan amount cannot exceed ₹10,00,000.'
                    );
                }
            customerTotalAmountMap.put(loanAP.Customer__c,currentTotal); // storing new added loan amount with existing
            
        }

    }
    
    public static void handlerAfterInsert(Map<Id,Loan_Application__c> newMap){
        
        Set<Id> customerIds = new set<Id>();
        
        for(Loan_Application__c loanAP: newMap.values()){
            if(loanAP.Customer__c==null){
               continue;
            }
            if(loanAP.Status__c=='Rejected'){
                continue;
            }
            
            customerIds.add(loanAP.Customer__c);
        }
        
        // fetching total Amount
        List<AggregateResult> totalLoanAmount = [Select Customer__c customerId , SUM(Loan_Amount__c) totalAmount from Loan_Application__c 
                                                  where Customer__c IN:customerIds and Status__c IN('Approved','Disbursed') 
                                                  group by Customer__c];
        
        Map<Id,Decimal> customerTotalAmountMap = new Map<Id,Decimal>();
        for(AggregateResult agr: totalLoanAmount){
           Id customerId = (Id) agr.get('customerId');
           Decimal totalAmount = (Decimal) agr.get('totalAmount');
           customerTotalAmountMap.put(customerId,totalAmount);
        }
        
        
        // Using map to avoid duplicate 
        Map<Id, Customer> customersToUpdate = new Map<Id, Customer>();
        
        for(Id customerId : customerIds){
        
            customersToUpdate.put(
        
                customerId,
        
                new Customer(
        
                    Id = customerId,
        
                    Total_Exposure__c =
                        customerTotalAmountMap.containsKey(customerId)
                        ? customerTotalAmountMap.get(customerId)
                        : 0
                )
            );
        }
        
        if(!customersToUpdate.isEmpty()){
        
            update customersToUpdate.values();
        }
                
        
    }

}