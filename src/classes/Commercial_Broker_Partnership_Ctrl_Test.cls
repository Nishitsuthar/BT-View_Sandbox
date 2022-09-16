// Updated Date         Developer       Project             Tracking Id                         		Requirement                         
// 25-Jan-2021          Srikanth        Commercial Broker   COMMERCIAL_BROKER_TEAM_MEMBER_IN_OPPTY    	When Commercial Broker Partnership record is created, create  team members in Oppty with users in Newmark Partners profile 

@isTest
public class Commercial_Broker_Partnership_Ctrl_Test {
	@testSetup
    static void createTestData() {
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();

        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOpptyParent';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;   
        insert testMOUOpportunityObj;
        
        List<Opportunity> projectList = new List<Opportunity>();
        for(Integer i=0; i<2; i++) {
            Opportunity testOpportunityObj = new Opportunity();
            testOpportunityObj.Name = 'testOppty';
            testOpportunityObj.CloseDate = Date.today();
            testOpportunityObj.StageName = 'POC Stage';
            testOpportunityObj.RecordTypeId = opptyProjectRecordtype;   
            testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
            testOpportunityObj.Winning_Total_of_IGUs__c = 2;
            testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
            projectList.add(testOpportunityObj);
        }
        insert projectList;
        
    }
    static testMethod void testCommercialBrokerTeamMemberCreationonOppty () {
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Test.startTest();
        Account acc = new Account();
        acc.Name='test';
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
		createTestData();
		Id opptyMOURecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Multi Project Opportunity').getRecordTypeId();

		List<Opportunity> projectOpportunity = [Select IGU_P_O__c,BOS_P_O__c,Ground_Breaking_Confirmed__c,Winning_Projects_Total_Sq_Ft__c,First_Request_Date_IGU__c,Approved_Win__c,	TotalOpportunityQuantity,StageName,Winning_Total_of_IGUs__c from Opportunity];

        system.debug('projectOpportunity'+projectOpportunity); 
        system.debug('TESTING:');
        Commercial_Broker_Partnership__c cbp = new Commercial_Broker_Partnership__c();
		cbp.Opportunity_Name__c = projectOpportunity[0].id;
		cbp.Client_Account__c = acc.Id;
		cbp.Named_Key_Accounts__c = acc.Id;
		
        insert cbp;
        Test.stopTest();
    }
}