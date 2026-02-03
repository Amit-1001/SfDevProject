public with sharing class EventAttendeeTriggerHandlerV1 {
    public static void sendEmailNotification(List<Event_Attendee__c> eventAttendeelist) {

        // Storing respective Ids of attendee and eventIds
        Set<Id> attendeeIds = new Set<Id>();
        Set<Id> eventIds = new Set<Id>();

        for(Event_Attendee__c ea:eventAttendeelist){
            if(ea.Attendee__c !=null && ea.Event__c !=null){
                attendeeIds.add(ea.Attendee__c);
                eventIds.add(ea.Event__c);
            }
        }
        // fetching respective Attendee records
        Map<Id,Attendee__c> attendeeMap = new Map<Id,Attendee__c>(
            [select Id, Name, Email__c from Attendee__c where ID IN: attendeeIds]
        );
        

    
        // fetching respective Event records
        Map<Id,Event__c> eventMap = new Map<Id,Event__c>(
            [Select Id, Name__c, Start_DateTime__c, Event_Organizer__c , Event_Organizer__r.Name,
                                                                Location__c , Location__r.Name, Location__r.City__c,
                                                                Location__r.State__c, Location__r.Country__c,
                                                                Location__r.Postal_Code__c, Location__r.Street__c
                                                                FROM Event__c where ID IN: eventIds]
        );

        // sending email to attendee
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        for(Event_Attendee__c ea:eventAttendeelist){
            Attendee__c att = attendeeMap.get(ea.Attendee__c);
            Event__c evt = eventMap.get(ea.Event__c);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setSubject('Pass for the '+evt.Name__c);
            List<String> toAddress = new List<String>();
            toAddress.add(att.Email__c);
            mail.setToAddresses( toAddress );
            mail.setSenderDisplayName(evt.Event_Organizer__r.Name);
            

            String locaton = 'https://www.google.com/maps/place/'+evt.Location__r.Street__c+' '+evt.Location__r.City__c+' '
                +evt.Location__r.State__c+' '+
                evt.Location__r.Country__c+' '+evt.Location__r.Postal_Code__c;

            String hrefForLocation = '<a href="'+locaton+'"'+'target="_blank">Here</a>';

            String emailBody = 'Dear '+ att.Name + ',<br/><br/>'+
                'Thank you for registering for '+evt.Name__c+' which will be Organized on '+
                evt.Start_DateTime__c+' & will be held in '+evt.Location__r.Name
                +'.<br/>We are excited to have you,'+ 
                'see you in the event. <br/>'+
                'Find the Google Map Location for the Event '+hrefForLocation+'.<br/><br/><br/>'+
                'Thanks,<br/>'+evt.Event_Organizer__r.Name;
            
            mail.setHtmlBody(emailBody);
            emailList.add(mail);
        

        }
    

    try{
            
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(emailList, false); 
            for(Messaging.SendEmailResult email : results){
                if(!email.isSuccess()){
                    List<Messaging.SendEmailError> errors = email.getErrors();
                    String serializedErrors = (errors == null || errors.isEmpty()) ? '[]' : JSON.serialize(errors);
                    TransactionErrorLog.handleError(serializedErrors, 'EventAttendeeTriggerHandlerV1');
                }
            }  
        }catch(System.Exception ex){
            TransactionErrorLog.handleException(ex, 'EventAttendeeTriggerHandlerV1');
    }
}

}
