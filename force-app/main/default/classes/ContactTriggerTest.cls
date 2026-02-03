@IsTest
public class ContactTriggerTest {
    
    @testSetup
    public static void testData(){
    
    }
    
    
    @IsTest
    public static void afterInsertTest(){
       
       Account acc1 = new Account(Name = 'Test');
       insert acc1;
        Contact cont1 = new Contact();
        cont1.LastName = 'TestContact';
        cont1.AccountId = acc1.Id;
        
     	Test.startTest();
        insert cont1;
        Test.stopTest();
        
        
    }
   
    @IsTest
    public static void afterDelete(){
        Account acc = new Account(Name = 'Delete Test Account');
        insert acc;
        
        Contact cont = new Contact(
            LastName = 'ToDelete',
            Email = 'delete@test.com',
            AccountId = acc.Id
        );
        insert cont;
        
        // Delete contact (fires AFTER_DELETE)
        Test.startTest();
        delete cont;
        Test.stopTest();
        
        Account accCheck = [SELECT Id, Number_of_contacts__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, accCheck.Number_of_contacts__c, 'Account should have 0 contacts after delete');
    }

}