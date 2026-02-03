public with sharing class CustomSearchController {
    public CustomSearchController() {

    }

    /* AuraEnabled makes it available for LWC */
    @AuraEnabled
    public static String searchRecords(String objName, String fieldName, String searchKey){
        String searchKeyword = searchKey + '*';
        String returningQuery = objName+' ( Id, '+fieldName+')';
        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 2000'; // SOSL
        List<List<SObject>>  searchResults = Search.query(query);
        return JSON.serialize(searchResults);
    }
}