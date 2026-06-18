public with sharing class CaseHelper {
    @AuraEnabled(cacheable=true)
    public static List<Case> getAllCases(){
        try {
            
            List<Case> caseList = [Select Id,CaseNumber,Priority,Origin, Status from Case where Status!='Closed' limit 10];
            if(!caseList.isEmpty()){
                return caseList;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
        }
        return null;
    }

    @AuraEnabled
    public static String closeCase(String recordId){
        try {
            Case tempCase = [Select Id, Status from Case where Id=:recordId limit 1];
            if(tempCase.Status=='Closed'){
                throw new AuraHandledException('Case is already in Closed Status!');
            }
            tempCase.Status = 'Closed';
                update tempCase;
                return 'Case closed Successfully!';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String escalateCase(String recordId){
        try {
            Case tempCase = [Select Id, Priority from Case where Id =: recordId limit 1];
            if(tempCase.Priority=='High'){
                throw new AuraHandledException('Case is already Escalated and Prioirty is "High"!');
            }
            tempCase.Priority = 'High';
            update tempCase;
            return 'Case has been Escalated and Priority is Changed to High!';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> getPaginatedCases(Integer pageSize, Integer pageNumber){
        // server side pagination
        try {
            Integer offsetValue =

            (pageNumber - 1)
            * pageSize;

            return [

                SELECT
                    Id,CaseNumber,Priority,Origin, Status
                FROM Case
                WHERE Status!='Closed'

                ORDER BY CreatedDate DESC

                LIMIT :pageSize

                OFFSET :offsetValue
            ];

        } catch (Exception e) {
            throw new AuraHandledException('Exception occured:'+e);
            
        }


    }


}