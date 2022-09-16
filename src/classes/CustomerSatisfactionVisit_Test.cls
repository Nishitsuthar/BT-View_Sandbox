@isTest
public class CustomerSatisfactionVisit_Test{
    static testMethod void testCSVTestClone () {
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
        
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@test.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
                
        
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Multi Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();       
        insert testMOUOpportunityObj;
        
        list<Customer_Satisfaction_Visit__c> csvList= new list<Customer_Satisfaction_Visit__c>();
        
        for(Integer i=0; i<10 ; i++) {
            Customer_Satisfaction_Visit__c testCSV = new Customer_Satisfaction_Visit__c();
            testCSV.Visit_Date__c = date.today()+i;
            testCSV.Related_Opportunity__c = testMOUOpportunityObj.Id;
            testCSV.Purpose_of_Visit__c = 'Quality Issue';
            testCSV.Primary_Contact__c = testContact.Id;
            testCSV.Customer_Satisfaction_Status__c = 'Delighted';
            testCSV.Customer_Sentiment_Value__c = '9';
            testCSV.Visit_Summary__c = 'latest visit'+i;
            csvList.add(testCSV);
        }
        insert csvList;
        
        Opportunity opp = [Select Id, Customer_Satisfaction_Visit__r.Visit_Summary__c from Opportunity where Customer_Satisfaction_Visit__c!=null];
        
        System.assertEquals(opp.Customer_Satisfaction_Visit__r.Visit_Summary__c, 'latest visit9');
        
        Test.stopTest();
    }
}