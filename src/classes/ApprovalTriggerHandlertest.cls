@isTest
private class  ApprovalTriggerHandlertest {
static testMethod void approvalTest() {
     Profile adminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     
        User adminUser = new User(Alias = 'Userdels', Email='User.admin@test.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = adminProfile.id, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='User.admintat@testat.com');
                    
        insert adminUser;
     
     Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@test.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L12346.com');
                    
        insert dealDeskUser;
     System.runAs(adminUser){
          Test.startTest();
         
         
      
         
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
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;
         Id quoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Bid Quote Record Type').getRecordTypeId();

          SBQQ__Quote__c testQuote = new SBQQ__Quote__c();
            testQuote.RecordTypeId = quoteRecordtype;
            testQuote.Related_Opportunity__c = testMOUOpportunityObj.Id;
            testQuote.Total_Sq_Feet__c = 10;
            testQuote.IGU_Price_Per_Sq_Ft__c = 30;
            testQuote.BOS_Price_Per_Sq_Ft__c = 50;
            testQuote.SBQQ__Account__c = testAccount.Id;
            testQuote.Bid_Status__c = 'Won Bid';
            testQuote.Exclude_Sync__c = false;
            testQuote.Quote_Plan__c = 'All In';
            testQuote.Quote_Type__c = 'All In';
            //testQuote.Template_Type__c = 'BUDGET';
            testQuote.SBQQ__PrimaryContact__c = testContact.Id;
            testQuote.Are_you_using_Plenum__c='yes';
         
         insert testQuote;
        sbaa__Approval__c approval= new sbaa__Approval__c();
        approval.sbaa__Status__c='Requested';
         approval.Quote__c=testQuote.id;
         approval.sbaa__ApprovalStep__c=1;
         approval.sbaa__RecordField__c='test';
         insert approval;
         try {
             
            // QuoteCloneUtility utility = new QuoteCloneUtility();
            //utility.cloneQuote(testQuote.id, true);
         } catch(System.AuraHandledException e) {
             system.assertEquals(e.getMessage(), 'Script-thrown exception');
         }            
         Test.stopTest();
         
     }
     
    }
}