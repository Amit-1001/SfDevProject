public class C_OrderItemsTrigger_Inventory {
    
    public static void reserveStock(Map<Id,Integer> productQytMap){
        List<Product__c> products = [select Id, Reserved_Stock__c from Product__c where Id In:productQytMap.keySet()]; // retrive all products associated with Id
        
        for(Product__c product : products){
            if(product.Reserved_Stock__c == null) {
                product.Reserved_Stock__c = 0;
            }
            Integer currReserved = (Integer)(productQytMap.get(product.Id) == null ? 0: productQytMap.get(product.Id));
            product.Reserved_Stock__c += currReserved; // updating reserve stock value
        }
        System.debug('After updating inventory:'+productQytMap);
        update products; // updating products
    }

}