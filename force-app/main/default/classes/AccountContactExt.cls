public with sharing class AccountContactExt {
    public Account acc { get; private set; } // getter and setter privete set means on VF page we can not modify acc
    private Id accId;
    public List<Contact> contactList {get; private set;}

    public Contact newContact{get; set;}
    

    public AccountContactExt(ApexPages.StandardController controller) {
        this.accId = controller.getId();
        loadAccount();
        loadContact();

        newContact = new Contact(AccountId = accId);

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

    // save contact logic
    public void saveContact(){
        try {
            
        if(String.isEmpty(newContact.FirstName) || String.isEmpty(newContact.LastName)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'First Name and Last Name are required'));
            return;
        }
        if(!String.isEmpty(newContact.Email) && !newContact.Email.contains('@')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email is not valid'));
            return;
        }

        // check if user has permision to create contact
        if(!Schema.sObjectType.Contact.isCreateable()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have permission to create contact'));
            return;
        }
            // Contact created
            insert newContact;

            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.CONFIRM, 'Contact created successfully'
            ));

            
            // Reset form & refresh list
            newContact = new Contact(AccountId = accId);
            loadContact();

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, e.getMessage()
            ));
            TransactionErrorLog.handleException(e, 'AccountContactExt.saveContact');
            
        }

    }
}