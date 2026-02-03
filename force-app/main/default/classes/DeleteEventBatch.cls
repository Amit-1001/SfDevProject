public with sharing class DeleteEventBatch implements Database.Batchable<SObject>{

    // Batchable Interface Methods 

    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select Id, Name, End_Date_Time__c from Event__c where Live__c = true and End_Date_Time__c > LAST_N_MONTHS:2'; // here LAST_N_MONTHS is predefine SOQL function
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Event__c> eventList){
        if(!eventList.isEmpty()){
            List<Database.DeleteResult> deleteResults = Database.delete(eventList);
            for(Database.DeleteResult rs: deleteResults){
                if(!rs.isSuccess()){
                    List<Database.Error> errorsList = rs.getErrors();
                    String errors = String.join(errorsList, ','); // this will join all the error in Single String
                    TransactionErrorLog.handleError(errors, 'DeleteEventBatch');
                }
            }
        }
        delete eventList;
    }

    public void finish(Database.BatchableContext bc){  

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setSubject('Event Deleted');
        email.setPlainTextBody('Event Deleted Successfully');
        List<String> toAddress = new List<String>{'amitnitnaware87@gmail.com'};
        email.setToAddresses(toAddress);

        // sendEmail returns a list of results
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.Email>{ email });
        // Iterate results and capture any errors
        List<String> emailErrors = new List<String>();
        for (Messaging.SendEmailResult r : results){
            if (!r.isSuccess()) {
                for (Messaging.SendEmailError se : r.getErrors()) {
                        emailErrors.add(se.getMessage());
                }
            }
        }
            if (!emailErrors.isEmpty()) {
                TransactionErrorLog.handleError('Email send failed: ' + String.join(emailErrors, '; '), 'DeleteEventBatch');
            }
    
    }

}