@isTest(SeeAllData=false)
private class RequestForSupportFlowExtensionTest{
    
    static testmethod void validateStandardController(){
        
            Account testAccount = new Account(Name='Test Company Name123');
           
            insert testAccount;
            
         
            Case cs = new Case();
            cs.Request_Date__c=Date.ValueOf(System.Now());
            cs.Support_Region__c='Bay Area';
            cs.Quote_Plan__c = 'All In';
            cs.Quote_Type__c = 'All In';
            cs.Template_Type__c='Quote';
            cs.OwnerId = userinfo.getUserId();
            cs.AccountId=testAccount.id;
            cs.Total_Glass_Area_SQFT__c = 500.00;
            cs.Number_of_IGU_s__c = 100.00;
            cs.Deal_Desk_analyst__c = '005E0000007tPIo';
            cs.RecordTypeId = '0120h000000YOKA';
            cs.Status = 'Open';

            insert cs;
            ApexPages.StandardController sc = new ApexPages.StandardController(cs);
            RequestForSupportFlowExtension testCase = new RequestForSupportFlowExtension(sc);
        
            PageReference pageRef = Page.RequestforSupport;
            pageRef.getParameters().put('rfs', id.valueOf(cs.Id));
       
            testCase.getFinishPageRef();
       
            Test.setCurrentPage(pageRef);
           
            
            
            
      }

}