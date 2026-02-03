public class AccountTriggerHelper {
    public static void updateAccountIndustry(List<Account> accountList){
           if (accountList == null) return;
         for (Account acc : accountList) {
            if (acc.Industry == null) {
                //acc.Industry = 'Other';
            }
        }
    }
    
    public static void duplicateCheck(List<Account> accountList){
        
        List<String> accountNames = new List<String>();
        List<String> accountRatings = new List<String>();
        
        for(Account acc: accountList){
            accountNames.add(acc.Name); // here we are storing all name in list 
            accountRatings.add(acc.Rating);
        }
        
        List<Account> existingAccount = [Select Id, Name, Rating from Account where Name IN: accountNames  and Rating IN: accountRatings
                                        And ID Not IN: accountList limit 50000]; // here In is used for collections
        								// ID not in accountList will checking ID is not equal to Id of accountList record
        
        for(Account acc: accountList){
			System.debug(acc.Name);
            System.debug(acc.Rating);
            //List<Account> foundAccount = [Select Id, Name From Account 
              //                            where Name =: acc.Name and Rating =: acc.Rating limit 1]; // we are executing query on existing account to check duplicate
            // this SOQL won't work for afterUpdate and also querying in for loop allow only 104 data to get feched to over this we have to use List these are Governer rules
            /*
            if(accountList!=null && foundAccount.size()>0){
                acc.addError('Duplicate Name and Rating Found'); // addError method is used to show error message
                acc.Name.addError('Duplicate name!'); // this is field specific error message
                acc.Rating.addError('Duplicate rating!');
            }*/ 
            
            for(Account existingAcc: existingAccount){
                if(acc.Name == existingAcc.Name && acc.Rating == existingAcc.Rating){
                     acc.addError('Duplicate Name and Rating Found'); // addError method is used to show error message
                        acc.Name.addError('Duplicate name!'); // this is field specific error message
                        acc.Rating.addError('Duplicate rating!');
                }
            }
        }
    }
    
    public static void  CreateTaskOnAccount(List<Account> accountList){ // accountList will have all Id :- Trigger.New
           if (accountList == null) return;
        
        
        List<Task> tasksToInsert = new List<Task>();
        List<Messaging.SingleEmailMessage> emailMessage = new List<Messaging.SingleEmailMessage>(); // storing email in list of Messaging.SingleEmailMessage
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        // here are quring all information from accountList Id 
        List<Account> newAccountList = [Select Id, Name, Phone, Industry, OwnerId, Owner.Name, Owner.Email from Account where Id In: accountList];
        
        for(Account acc: newAccountList){
            if( acc.Phone == null && acc.Industry==null){
                Task newTask = new Task();
                newTask.Subject = 'The phone and Industry is blank';
                newTask.Description = 'Please work with Account owner and get the details.';
                newTask.Status = 'Not Started';
                newTask.Priority = 'High';
                newTask.ActivityDate = System.today().addDays(7);
                newTask.WhatId = acc.Id;
                newTask.OwnerId = acc.OwnerId;
                tasksToInsert.add(newTask);
              
                
                email.setSubject('The phone number and Industry are blanked!');
                String emailDraft = 'Dear '+acc.Owner.Name+'<br/>';
                emailDraft+= 'A new account :'+acc.Name+' has been created but important information about phone and idustry is missing<br/><br/>';
                emailDraft+= 'Please try to collect information and update ASAP!<br/>';
                emailDraft+='Thanks and Regards';
                emailDraft+='Salesforce';
                    
               // email.setPlainTextBody(emailDraft);
                email.setHtmlBody(emailDraft);
                
                List<String> toAddress = new List<String>();
                toAddress.add(acc.OwnerId); // here ownerId will have email associated with Owner
                // Note that Account is child of Owner class so accountList will have data related to created account only, Note its related Objects
                // Lead/contact/user - to send email  we either need email or ownerId.
                email.setToAddresses(toAddress);
                
                List<String> bccAddress = new List<String>();
                bccAddress.add('amitnitnaware87@gmail.com');
                email.setBccAddresses(bccAddress);
                
                emailMessage.add(email);
                
                
            }
        }
        /*
       
        for (Account acc : accountList) {
            Task t = new Task();
            t.Subject = 'Created Task from Trigger';
            t.Description = 'Create Task from Apex Trigger';
            t.Status = 'Not Started';
            t.Priority = 'High';
            t.ActivityDate = System.today().addDays(7);
            t.WhatId = acc.Id;
            t.OwnerId = acc.OwnerId;

            tasksToInsert.add(t);
        }
		
        */
        
        // Insert all tasks at once
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    
        // this is good practice to send email at once, in loop we can only send 10 emails
        List<Messaging.sendEmailResult> emailResult = Messaging.sendEmail(emailMessage,false); // this is not good practice to use sendEmail in loop
                
                for(Messaging.sendEmailResult sr: emailResult){
                    if(sr.isSuccess()){
                        System.debug('Email Sent Successfully!');
                    }else{
                        List<Messaging.SendEmailError> error = sr.getErrors(); // to get error in email
                        System.debug(error); // this error will only show if there is error from salesforce side 
                    }
                }
        
    }
    
   

}