/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CaseTriggerTest {


    @TestSetup
    public static void setupData(){
        Account account = new Account(Name='Test Account');
        insert account;



        List<Case> caseList = new List<Case>();

        for(Integer i=0; i<300; i++){
            Case caseObj = new Case(AccountId = account.Id, Status = 'New', Subject = 'Test Case:'+i, Origin = 'Email');
            //insert caseObj;
            caseList.add(caseObj);
        }

        Test.startTest();
        insert caseList;
        Test.stopTest();

        

    }

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
    }


    @isTest
    static void afterInsertCase(){
        Account account = [SELECT Id, Number_of_Cases__c FROM Account WHERE Name = 'Test Account' LIMIT 1];

        List<Case> caseList = [SELECT Id, Status, Subject, Origin FROM Case WHERE AccountId =: account.Id];
        System.debug('caseList Size:'+caseList.size());
        System.Assert.areEqual(300, account.Number_of_Cases__c);
    }
}