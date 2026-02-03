@IsTest
public class OrderTriggerTest {
  
    @testSetup
    public static void setupData() {
        // Create Account and Contract for Order
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contract con = new Contract(
            AccountId = acc.Id,
            StartDate = Date.today(),
            ContractTerm = 12,
            Status = 'Draft'
        );
        insert con;
        
        // Create Product
        Product2 product = new Product2(
            Name = 'Dell Laptop',
            ProductCode = 'Dell0101',
            Stock__c = 100,
            IsActive = true
        );
        insert product;
        
        // Create Order
        Order ord = new Order(
            Status = 'New',
            AccountId = acc.Id,
            ContractId = con.Id,
            EffectiveDate = Date.today()
        );
        insert ord;
        
        // Create Order Line (exceeds stock to test error)
        Order_Line__c ol = new Order_Line__c(
            Name = 'Order Line 1',
            Order__c = ord.Id,
            Product__c = product.Id,
            Quantity__c = 110
        );
        insert ol;
    }
		    /*
    @IsTest
    public static void testOrderAfterUpdate_InsufficientStock() {
        // Fetch data
        Order ord = [SELECT Id, Status FROM Order LIMIT 1];
        
        // Try to mark Paid (should fail)
        ord.Status = 'Paid';
        
        try {
            Test.startTest();
            update ord;
            Test.stopTest();
            System.assert(false, 'Expected DmlException was not thrown');
        } catch (DmlException e) {
            System.assert(
                e.getDmlMessage(0).contains('Insufficient stock'),
                'Expected insufficient stock error'
            );
        }
    }
    */  
    
    @IsTest
    public static void testOrderAfterUpdate_SufficientStock() {
        // Create fresh order and order line with valid stock
        Account acc = new Account(Name = 'Test Account 2');
        insert acc;
        
        Contract con = new Contract(
            AccountId = acc.Id,
            StartDate = Date.today(),
            ContractTerm = 12,
            Status = 'Draft'
        );
        insert con;
        
        Product2 prod = [SELECT Id, Stock__c FROM Product2 LIMIT 1];
        
        Order ord = new Order(
            Status = 'New',
            AccountId = acc.Id,
            ContractId = con.Id,
            EffectiveDate = Date.today()
        );
        insert ord;
        
        Order_Line__c ol = new Order_Line__c(
            Order__c = ord.Id,
            Product__c = prod.Id,
            Quantity__c = 10
        );
        insert ol;
        
        // Act
        ord.Status = 'Paid';
        Test.startTest();
        update ord;
        Test.stopTest();
        
        // Assert
        Product2 updatedProd = [SELECT Stock__c FROM Product2 WHERE Id = :prod.Id];
        System.assertEquals(90, updatedProd.Stock__c, 'Stock should be reduced by 10');
    }
}