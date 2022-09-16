@isTest
public class SalesInputFormExtTest {
    Static testMethod void testmethod1(){
         Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;
         Subscription_Pricing_Request__c sfls=new Subscription_Pricing_Request__c();
       
        ApexPages.StandardController sc = new ApexPages.StandardController(sfls);
        ApexPages.CurrentPage().getParameters().put('oppId',testMOUOpportunityObj.Id);
         SalesInputFormExt salesinput= new SalesInputFormExt(sc);
        salesinput.makeHVACDefaultfields();
        salesinput.makeShadingDefaultfields();
        salesinput.cancel();
        salesinput.save();
        
        
    }
}