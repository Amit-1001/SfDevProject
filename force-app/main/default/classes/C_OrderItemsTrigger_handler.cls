public class C_OrderItemsTrigger_handler {
	
    public static void validateStock(List<Order_Items__c> orderItems){
        
       	Set<Id> productIds = new Set<Id>();
        for(Order_Items__c orderItem: orderItems){
            if(orderItem.Product__c!=null){
                productIds.add(orderItem.Product__c); // storing reference of all product associated with orderItem
            }
        }
        System.debug('product id added');
        
       	// Search all products associated with productIds
        Map<Id,Product__c> productsMap = new Map<Id,Product__c>(
        [select Id, Name, Stock_Quantity__c, Reserved_Stock__c from Product__c where Id In: productIds]
        );
        
        System.debug(productsMap);
        
        // validate stock 
        for(Order_Items__c orderItem: orderItems){
            if(orderItem.Product__c!=null && productsMap.containsKey(orderItem.Product__c)){
                Product__c product = productsMap.get(orderItem.Product__c); // fetch product associated with orderItem
                Integer reservedStock = (Integer)(product.Reserved_Stock__c != null ? product.Reserved_Stock__c : 0); // initially reverseStock will be null to handle that case

                Integer availableQyt = (Integer)(product.Stock_Quantity__c - reservedStock); // actual available quantity
                if(availableQyt<orderItem.Quantity__c){ 
                    orderItem.addError('Not enough quantity for product:'+product.Name);
                }
            }
        }
        
    }
    
    public static void reserveStock(List<Order_Items__c> orderItems){
        Map<Id,Integer> productQytMap = new Map<Id,Integer>();
        
        for(Order_Items__c orderItem: orderItems){
            if(orderItem.Product__c!=null ){
                if(!productQytMap.containsKey(orderItem.Product__c)){
                    productQytMap.put(orderItem.Product__c,0); // initially product reserveStock is 0
                }
                productQytMap.put(orderItem.Product__c,(Integer)(productQytMap.get(orderItem.Product__c)+orderItem.Quantity__c)); //store reserve stock for each product
            }
        }
        //Update Inventory
        System.debug('Before updating inventory:'+productQytMap);
        C_OrderItemsTrigger_Inventory.reserveStock(productQytMap);
        
    }
    
    
}