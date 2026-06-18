public with sharing class PaymentGatewayService {
    
    @AuraEnabled
    public static String createPaymentSession(String loanId){
        try {
            Loan_Application__c loan = [Select Id, Name, Loan_Amount__c from Loan_Application__c where Id=:loanId limit 1];
            
            // Payload
            Map<String,Object> payload = new Map<String,Object>();
            payload.put('amount',loan.Loan_Amount__c);
            payload.put('loanReference',loan.Name);
            payload.put('currency','INR');

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:RazorpayAPI');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setBody(JSON.serialize(payload));

            Http http = new Http();

            HttpResponse res = http.send(req);

            if(res.getStatusCode() == 200 || res.getStatusCode() ==201){
                Map<String,Object> responseMap =(Map<String,Object>) JSON.deserializeUntyped(res.getBody());

                return (String)'https://api.razorpay.com/';

            }

            TransactionErrorLog.handleError(res.getBody(),'Payment API Error');
            // Logging
            System.debug(
                'Payment API Error: ' +
                res.getBody()
            );

            throw new AuraHandledException(
                'Unable to create payment session.'
            );
            
        } catch (Exception e) {
            throw new AuraHandledException(
                e.getMessage()
            );
        }
    }
}