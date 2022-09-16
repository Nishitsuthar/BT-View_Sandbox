@isTest 
public class LogIssuesCmpController_test {
  
     
    static testMethod void testmethod1()
    {  
         Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
        insert testContact;
          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
         testMOUOpportunityObj.AccountId=testAccount.Id;
       // testMOUOpportunityObj.Sales_Ops_Owner__c = UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;
        
        Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();

            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId); 
       
       
     LogIssuesCmpController.getLogIssueDetails(caseRecord.Id);
        
}  
   
    static testMethod void testmethod2()
    {  
        
            string caseRecord = ' '; 
       
       
     LogIssuesCmpController.getLogIssueDetails(caseRecord);
        
}
    static testMethod void testmethod3()
    {  
         Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
        insert testContact;
          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
         testMOUOpportunityObj.AccountId=testAccount.Id;
       // testMOUOpportunityObj.Sales_Ops_Owner__c = UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;
        
        Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();

            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId); 
       
       
   //  LogIssuesCmpController.initializeDefaultStates(caseRecord.Id);
        
}  
  static testMethod void testmethod4()
    {  
         Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
        insert testContact;
          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
         testMOUOpportunityObj.AccountId=testAccount.Id;
       // testMOUOpportunityObj.Sales_Ops_Owner__c = UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;
        
        Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();

            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId); 
       
       
  //   LogIssuesCmpController.fetchInitialRecords(caseRecord.Id);
        
}

}