public with sharing class AccountContactExt {
    public Account acc { get; private set; } // getter and setter privete set means on VF page we can not modify acc
    private Id accId;
    public List<Contact> contactList {get; private set;}
    public AccountContactExt(ApexPages.StandardController controller) {
        this.accId = controller.getId();
        loadAccount();
        loadContact();

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This is a test message'));

    }

    private void loadAccount(){
        acc = [SELECT Id, Name, Industry, Phone from Account where Id =: accId limit 1];
    }

    private void loadContact(){
        contactList = [ SELECT Id, FirstName, LastName, Email, Phone
            FROM Contact
            WHERE AccountId = :accId
            ORDER BY CreatedDate DESC];
    }
}