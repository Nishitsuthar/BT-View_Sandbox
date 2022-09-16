public class DocuSignWarrantyAcceptanceLetter {
    @auraEnabled
    public static Opportunity getOpportunity(Id recordId){
        Opportunity opportunityRecord = new Opportunity();
        try{
            opportunityRecord = [select id,PM_Email__c,Project_Manager__r.Name
                                 from Opportunity 
                                 where Id=:recordId];  
        }
        catch(Exception e){
        }
        return  opportunityRecord; 
    }
}