public class ContentVersionHandler {
    /*
		Develope solution that whenever file is inserted under Task, Event, Case then same file should linked with related AccountId

	*/
    public static void contentVersionHandlerAfterInsert(List<ContentVersion> contentVersion){
        
         // Step 1: Get ContentVersions and ContentDocumentIds
         // 
        if(contentVersion==null){
            return;
        }
        
        Set<Id> contentVersionIds = new Set<Id>();
        for (ContentVersion cv : contentVersion) {
            contentVersionIds.add(cv.Id);
        }
        // Whenever file is created its content version gets created and mostly ContentDocumentLink will have sObject where file is linked 
        // ContentVersion is child of ContentDocument that why we are fetching all required data form child upfront
        
        List<ContentVersion> contentVersionList = [
            SELECT Id, Title, VersionData, ContentDocumentId, PathOnClient, Origin 
            FROM ContentVersion 
            WHERE Id IN :contentVersionIds
        ];
        
        Set<Id> contentDocumentId = new Set<Id>();
        for (ContentVersion cv : contentVersionList) {
            if(cv.ContentDocumentId!=null){
            	contentDocumentId.add(cv.ContentDocumentId);
            }
        }
        
        
        // Now fetch all contentDocumentLink from contentDocumentId
        System.debug('ContentDocumentId'+contentDocumentId);
        List<ContentDocumentLink> contentDocumentLink = [Select Id, LinkedEntityId, ContentDocumentId 
                                                         from ContentDocumentLink where ContentDocumentId In: contentDocumentId];
        System.debug('ContentDocumentLink'+contentDocumentLink);
        
        
        Set<Id> taskId  = new Set<Id>();
		Set<Id> eventId  = new Set<Id>();
        Set<Id> caseId  = new Set<Id>();
        
        // storing Id of taskId, eventId, caseId
        for(ContentDocumentLink documentLink: contentDocumentLink){
            String sObjectName = documentLink.LinkedEntityId.getSObjectType().getDescribe().getName(); // API
            if(sObjectName == 'Task'){
                // here we are storing id of sObject having linkedEntityId
                taskId.add(documentLink.LinkedEntityId);
            }
            else if(sObjectName == 'Event'){
                eventId.add(documentLink.LinkedEntityId);
            }
            else if(sObjectName == 'Case'){
                caseId.add(documentLink.LinkedEntityId);
            }
        }
        Map<Id,Id> caseToAccountMap = new Map<Id,Id>();
        if(caseId.isEmpty() == false){
            // Now fetch AccountId from  case so we can link file to Account
            // We use WhatId in systems like Salesforce to link an activity (like a task or event) 
            // to a non-human business record, such as an Account, Opportunity, or Case. This is crucial for tracking the context of interactions and providing valuable insights into sales progress and customer service issues. 
            // While WhoId links to a person (Contact or Lead), WhatId provides the specific business-related "what" the activity is about
            List<Case> caseList =[Select Id, AccountId from Case where Id In: caseId and AccountId !=null ];
            /*
             * // this logic fails when we update version of same file it will give duplication error.
            for(ContentDocumentLink documentLink: contentDocumentLink){
               String sObjectName = documentLink.LinkedEntityId.getSObjectType().getDescribe().getName();
                if(sObjectName == 'Case'){
                    for(Case c : caseList){
                        if(c.Id == documentLink.LinkedEntityId){ // this is required , it will make sure we update file to current SObject's related account
                            ContentDocumentLink clonedLink = documentLink.clone(false, false,false,false); // cloning whole documentLink object
                    		clonedLink.LinkedEntityId  = c.AccountId; // current related AccountId 
                            contentDocumentLinkToInsert.add(clonedLink);
                        }
                    }
                }
            } */
            
            
            for(Case c: caseList){
                caseToAccountMap.put(c.Id,c.AccountId);
            }
        }
        
        
        // New LinkTOInsert
        List<ContentDocumentLink> contentDocumentLinkToInsert = new List<ContentDocumentLink>();
        for(ContentDocumentLink CL: contentDocumentLink){
            String SObjectName = CL.LinkedEntityId.getSObjectType().getDescribe().getName();
            
            if(SObjectName == 'Case' && caseToAccountMap.containsKey(CL.LinkedEntityId)){
                Id accountId = caseToAccountMap.get(CL.LinkedEntityId);
                Id contentDocId = CL.ContentDocumentId;
                
                // here we checking if ContentDocumentId is aleardy present for accountId if exit then no need to insert that document 
                // This scenario will only happen when user try to upload version of same document.
                Boolean alreadyExist = false;
                for(ContentDocumentLink linkExist: contentDocumentLink){
                    if(linkExist.ContentDocumentId == contentDocId && linkExist.LinkedEntityId == accountId){
                        alreadyExist = true;
                        break;
                    }
                }
                
                if(!alreadyExist){
                    ContentDocumentLink cloneLink = CL.clone(false,false,false,false);
                    cloneLink.LinkedEntityId = accountId;
                    contentDocumentLinkToInsert.add(cloneLink);
                }
                
            }
        }

        System.debug('contentDocumentLinkToInsert'+contentDocumentLinkToInsert);
       if (!contentDocumentLinkToInsert.isEmpty()) {
            try {
                insert contentDocumentLinkToInsert;
            } catch (DmlException e) {
                System.debug('Skipped duplicate ContentDocumentLink insert: ' + e.getMessage());
            }
        }
       
    }

}