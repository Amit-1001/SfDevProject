public class leadTriggerHandler {
     public static void handleAfter(List<Lead> leads) {
        List<Lead> toConvert = new List<Lead>();
        for (Lead l : leads) {
            if (l.Convert_to_Opportunity__c && !l.IsConverted) { // is lead is not converted yet then store it in list
                toConvert.add(l);
            }
        }
        if (!toConvert.isEmpty()) convertLeads(toConvert); // calling convertor
    }

    private static void convertLeads(List<Lead> leads) {
        List<Database.LeadConvert> conversions = new List<Database.LeadConvert>();
        for (Lead l : leads) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.Id);
            lc.setDoNotCreateOpportunity(false);
            lc.setOwnerId(RoundRobin.getNextUserId());
            conversions.add(lc);
        }
        Database.convertLead(conversions, true);
    }

}