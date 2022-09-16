public class Case_Quote_Order_Util {

    //This method updates status of product requests realted to order entry releases.
    public static void setRelatedPRsToFulFillStatus(Set<Id> OERIds) {
        //Query Product Requests related to Orders.
        List<ProductRequest> productRequestsUpdated = new List<ProductRequest>();
        for(ProductRequest eachPR : [SELECT Id, Status FROM ProductRequest WHERE Order_Entry_Release__c IN :OERIds]) {
            eachPR.Status = 'Order Shipped';
            productRequestsUpdated.add(eachPR);
        }
        if(productRequestsUpdated.size() > 0) {
            update productRequestsUpdated;
        }
        Case_Quote_Order_Util.setRelatedIssuesToFulFilledStatusManualissue(OERIds);
    }
    //This method updates status of issues related to order entry releases.
 /*   public static void setRelatedIssuesToFulFilledStatus(Set<Id> PRIds) {
        //Query Issues related to Product Request.
        List<Issue__c> issuesUpdated = new List<Issue__c>();
        system.debug('PRIds'+PRIds);
        
        for(Issue__c eachIssue : [SELECT Id, Issue_Status__c FROM Issue__c WHERE Product_Request__c IN :PRIds]) {
            system.debug('issue rec'+eachIssue);
            eachIssue.Issue_Status__c = 'Fulfilled';
            issuesUpdated.add(eachIssue);
        }
        system.debug('eachIssue'+issuesUpdated);
        if(issuesUpdated.size() > 0) {
            update issuesUpdated;
        }
    } */  
    
     public static void setRelatedIssuesToFulFilledStatusManualissue(set<id> ordis)
    {
        //List<Issue__c> issuesUpdated1 = [SELECT Id, Issue_Status__c,Order_Entry_Release__c,Product_Request__c,Name FROM Issue__c ];
       
        List<Issue__c> issuesUpdated = [SELECT Id, Issue_Status__c FROM Issue__c WHERE Order_Entry_Release__c IN :ordis];
        system.debug('ordis'+ordis);
        system.debug('issuesUpdated'+issuesUpdated);
        system.debug('issuesUpdated'+issuesUpdated.size());
       // system.debug('issuesUpdated1'+issuesUpdated1);
       // System.assertEquals(null,issuesUpdated1[0].Order_Entry_Release__c);        
		List<Issue__c> issuesUpdated1 = new List<Issue__c>();

        for(Issue__c eachIssue : issuesUpdated) {
            system.debug('issue rec'+eachIssue);
            if (eachIssue.Issue_Status__c != 'Resolved'){
                eachIssue.Issue_Status__c = 'Order Shipped';
            	issuesUpdated1.add(eachIssue);
            }
        }
        system.debug('eachIssue'+issuesUpdated1);
        if(issuesUpdated.size() > 0) {
            update issuesUpdated1;
        }
    }
}