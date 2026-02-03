public with sharing class PaymentHandler {
    @AuraEnabled
    public static void processPaymentResult(Id quoteId, String transactionId, String status, Decimal amount, String gatewayResponse) {
        Quote__c q = [SELECT Id, Opportunity__c FROM Quote__c WHERE Id=:quoteId LIMIT 1];
        New_Payment__c p = new New_Payment__c(
            Quote__c=q.Id,
            Amount__c=amount,
            Status__c=status,
            Transaction_Id__c=transactionId,
            Gateway_Response__c=gatewayResponse
        );
        insert p;

        if (status=='Success') {
            Order o = new Order();
            o.AccountId = [SELECT AccountId FROM Opportunity WHERE Id=:q.Opportunity__c].AccountId;
            o.EffectiveDate = Date.today();
            o.Status='Activated';
            insert o;

            New_Invoice__c inv = new New_Invoice__c(Order__c=o.Id, Amount__c=amount, Status__c='Paid');
            insert inv;

            q.Status__c='Paid';
            update q;
        }
    }
}