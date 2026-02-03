public with sharing class QuoteController {
    @AuraEnabled(cacheable=false)
    public static Quote__c createDraftQuote(Id opportunityId, List<QuoteLineInput> lines) {
        Quote__c q = new Quote__c(Opportunity__c=opportunityId, Status__c='Draft', Total_Amount__c=0);
        insert q;
        Decimal total = 0;
        List<QuoteLine__c> qlines = new List<QuoteLine__c>();
        for (QuoteLineInput li : lines) {
            QuoteLine__c ql = new QuoteLine__c(
                Quote__c=q.Id,
                Products__c=li.productId,
                Quantity__c=li.quantity,
                Unit_Price__c=li.unitPrice,
                Discount__c=li.discount
            );
            ql.Line_Total__c = (li.quantity*li.unitPrice)*(1-(li.discount/100));
            total += ql.Line_Total__c;
            qlines.add(ql);
        }
        insert qlines;
        q.Total_Amount__c = total;
        update q;
        return q;
    }

    public class QuoteLineInput {
        @AuraEnabled public Id productId;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal unitPrice;
        @AuraEnabled public Decimal discount;
    }
}