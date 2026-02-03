public with sharing class StripeService {
    @AuraEnabled
    public static String createPaymentIntent(Decimal amount, String curr) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:StripeAPI/v1/payment_intents'); // Setup callout:StripeAPI name in salesforce this has to be API name from strip
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        String body = 'amount=' + String.valueOf((Integer)(amount*100)) + '&currency=' + EncodingUtil.urlEncode(curr,'UTF-8');
        req.setBody(body);
        Http h = new Http();
        HttpResponse res = h.send(req);

        if (res.getStatusCode()>=200 && res.getStatusCode()<300) {
            Map<String,Object> m = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            return (String)m.get('client_secret');
        } else {
            throw new CalloutException('Stripe error: '+res.getBody());
        }
    }
}