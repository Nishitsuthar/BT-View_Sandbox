@isTest
public class IssueContactControllerTest {
    
    
    
     static testMethod void TestMethod1()
    {
          Profile prof = [select id from profile where name LIKE '%Deal Desk%'];
User user = new User();
user.firstName = 'test1';
user.lastName = 'test2';
user.profileId = prof.id;
 user.username = 'test@test.com';
user.email = 'test@test.com';
//insert user;
        
          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();

       list<Account> acclst = new list<Account>();
        list<contact> clst = new list<contact>();
        list<Opportunity> opplst = new list<Opportunity>();
        list<OpportunityContactRole> oppclst = new list<OpportunityContactRole>();
        
        
        Account acc = new Account();
        acc.Name='test';
       // acc.BillingAddress
        acc.BillingCity='Livermore';
        acc.BillingCountry='USA';
        acc.BillingPostalCode='94550';
        acc.BillingState='CA';
        acc.BillingStreet='6400 Brisa Street';
        acc.Oracle_Customer_Number__c ='123';
         acc.ShippingCity='Livermore';
        acc.ShippingCountry='USA';
        acc.ShippingPostalCode='94550';
        acc.ShippingState='CA';
        acc.ShippingStreet='6400 Brisa Street';
        insert acc;
        
        contact c = new contact();
        c.AccountId = acc.id;
        c.LastName='Test';
        c.Salutation='Mr.';
        c.Email='test@test.com';
        insert c;
        
       Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOpptyParent';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype; 
        testMOUOpportunityObj.AccountId= acc.id;
        testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Ops_Owner__c =user.id;
        testMOUOpportunityObj.Total_Building_Sqft__c = 400000;
       // testMOUOpportunityObj.pri
        insert testMOUOpportunityObj;
        
        
        ContactRoleMapping__c cr = new ContactRoleMapping__c();
        cr.Contact_Role__c ='Broker';
        cr.Name='Broker';
        cr.Partner_Account__c= 'Real Estate Services';
        insert cr;
        
        OpportunityContactRole opc = new OpportunityContactRole();
        opc.ContactId = c.id;
        opc.Role = 'Broker';
        opc.OpportunityId = testMOUOpportunityObj.id;
        //opc.Opportunity.Total_Building_Sqft__c = 400000;
        insert opc;
        
        IssueContactController icc = new IssueContactController();
        IssueContactController.tableLvlRecds icc1 = new IssueContactController.tableLvlRecds();
        IssueContactController.wrapperData icc2 = new IssueContactController.wrapperData();
        IssueContactController.wrapperData.fetchcontactsDetails(c.id);
        IssueContactController.wrapperData.fetchpartaccountsDetails(acc.id);
        IssueContactController.wrapperData.fetchaccountsDetails(acc.id);
        IssueContactController.wrapperData.filteraccountsDetails(acc.id,'','','','');
        IssueContactController.wrapperData.filtercontatcsDetails(c.id,'','','');
        IssueContactController.wrapperData.filterpartDetails(acc.id,'','','','');
        LookUpController lc = new LookUpController();
        LookUpController.fetchContact('test');
       LookUpController.fetchAccounts('test'); 
      }

}