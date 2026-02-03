@IsTest
public class C_OrderItemsTriggerTest {
    
      @testSetup
    public static void setupData(){
         Id onlineOrderRTId = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('Online Order').getRecordTypeId();
         System.debug(onlineOrderRTId);
        
         Order__c ord1 = new Order__c(
        	Name = 'Order 1',
       		Order_Channel__c = 'Online',
            Order_Status__c = 'Draft',
            Payment_Status__c = 'Pending',
            Payment_Mode__c = 'UPI',
            RecordTypeId = onlineOrderRTId // Correctly sets the record type
        );
        insert ord1;
        
        // Product with enough stock for a successful insert
        Product__c product1 = new Product__c(
            Name = 'TestProduct',
            Reserved_Stock__c = 0,
            Stock_Quantity__c = 10
        );
        insert product1;
    }
    
    @IsTest
    public static void validateStockTest_PositiveCase(){
        
        Order__c ord1 = [SELECT Id FROM Order__c LIMIT 1];
        Product__c prd1 = [SELECT Id FROM Product__c LIMIT 1];
        
        Test.startTest();
        Order_Items__c item1 = new Order_Items__c(
            Order__c  = ord1.Id,
            Product__c  = prd1.Id,
            Quantity__c = 5
        );
        insert item1;
        Test.stopTest();
        
        // Assert that the insert was successful
        System.assertNotEquals(null, item1.Id, 'Item should have been inserted successfully.');
        
        // Assert that the stock was correctly reserved/updated
        Product__c updatedPrd = [SELECT Reserved_Stock__c, Stock_Quantity__c FROM Product__c WHERE Id = :prd1.Id];
        System.assertEquals(5, updatedPrd.Reserved_Stock__c, 'Reserved stock should be 5 after insert.');
    }

}