@isTest
public class InsertPartnerAccountsForOpportunityTest {
    @isTest
    static void Testmethod1()
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
        insert opc;
       
    }

}