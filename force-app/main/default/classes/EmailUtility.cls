public class EmailUtility {
    public static void sendMail(){
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        List<String> toAddress = new List<String>();
        toAddress.add('amit.nitnaware03@gmail.com');
        
        List<String> bccAddress = new List<String>();
        bccAddress.add('amitnitnaware87@gmail.com');
        
        
		email.setSubject('This is test email');
		email.setToAddresses(toAddress);        
        email.setBccAddresses(bccAddress);
        
        email.setPlainTextBody('Hello, This is test email!');
        
        List<Messaging.SingleEmailMessage> emailMessage = new List<Messaging.SingleEmailMessage>(); // storing email in list of Messaging.SingleEmailMessage
        emailMessage.add(email);
        
        //To get Result we use Messaging.SendEmailResult;
        List<Messaging.SendEmailResult> emailResult =  Messaging.SendEmail(emailMessage,false); // sendEmail(email,allOrNothing);
        
        for(Messaging.SendEmailResult sr: emailResult){
            if(sr.isSuccess()){
                System.debug('Email Sent Successfully!');
            }else{
                List<Messaging.SendEmailError> error = sr.getErrors(); // to get error in email
                System.debug(error); // this error will only show if there is error from salesforce side 
            }
        }
        
    }

}