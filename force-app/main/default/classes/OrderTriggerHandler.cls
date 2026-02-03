public class OrderTriggerHandler {
    
    public static void orderAfterUpdate(List<Order> orders, Map<Id,Order> orderMap){
        Set<Id> orderId = new Set<Id>();
        
        for(Order o: orders){
            if(o.Id!=null && o.Status == 'Paid'){
                orderId.add(o.Id);
            }
        }
        
        List<Order_Line__c> orderLine = new List<Order_Line__c>();
        
        orderLine = [SELECT Id, Product__c, Quantity__c FROM Order_Line__c WHERE Order__c IN :orderId ]; // storing orderline with ID, Product, and Quantity
        
        
          // Calculate total quantity per product
        Map<Id, Decimal> productStockChanges = new Map<Id, Decimal>();
        for (Order_Line__c ol : orderLine) {
            Decimal qty = productStockChanges.containsKey(ol.Product__c) ? productStockChanges.get(ol.Product__c) : 0;
            productStockChanges.put(ol.Product__c, qty + ol.Quantity__c);
        }
        
        List<Product2> productToChange = [Select Id, Stock__c from Product2 where Id IN: productStockChanges.keySet() FOR UPDATE]; // storing products where we have to update stocks
        
        Map<Id, Product2> productsToUpdate = new Map<Id,Product2>(productToChange); // it will have ID and Products mapping
        
        
        // Step 5: Check stock availability
      Boolean hasError = false;

        for (Order_Line__c ol : orderLine) {
            Product2 product = productsToUpdate.get(ol.Product__c);
            if (product.Stock__c < ol.Quantity__c) {
                orderMap.get(ol.Order__c).addError(
                    'Cannot mark order as Paid. Insufficient stock for product: ' + product.Name
                );
                hasError = true;
            }
        }
        
        if (hasError) return;
        
        // Step 6: Deduct the stock
        for (Id productId : productsToUpdate.keySet()) {
            Product2 prod = productsToUpdate.get(productId);
            prod.Stock__c -= productStockChanges.get(productId);
        }
        
        update  productToChange;
        
        
        
    }

}