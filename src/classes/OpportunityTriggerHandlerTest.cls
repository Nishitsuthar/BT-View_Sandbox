@isTest
public class OpportunityTriggerHandlerTest {
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
    static testMethod void testWinningInfoOnOppty () {
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Test.startTest();
            createTestData();
        Test.stopTest();
        List<Opportunity> MOUOpportunity = [Select Winning_Projects_Total_Sq_Ft__c,Winning_Total_of_IGUs__c from Opportunity where RecordTypeId =: opptyRecordtype];
        system.assertEquals(20, MOUOpportunity[0].Winning_Projects_Total_Sq_Ft__c);
        system.assertEquals(4, MOUOpportunity[0].Winning_Total_of_IGUs__c);
    }
    static testMethod void testWinningInfoOnOpptyForProjectOnly () {
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Test.startTest();
            createTestData();
            List<Opportunity> projectOpportunity = [Select Winning_Projects_Total_Sq_Ft__c,Winning_Total_of_IGUs__c from Opportunity where RecordTypeId =: opptyRecordtype];
            Id opptyMOURecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Multi Project Opportunity').getRecordTypeId();
            projectOpportunity[0].RecordTypeId = opptyMOURecordtype;
            update projectOpportunity[0];
        Test.stopTest();
        Id opptyMOUSingleRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        List<Opportunity> MOUOpportunity = [Select Winning_Projects_Total_Sq_Ft__c,Winning_Total_of_IGUs__c from Opportunity where RecordTypeId =: opptyMOUSingleRecordtype];
        system.assertEquals(10, MOUOpportunity[0].Winning_Projects_Total_Sq_Ft__c);
        system.assertEquals(2, MOUOpportunity[0].Winning_Total_of_IGUs__c);
    }
    
    static testMethod void testWinningInfoOnOpptyForProjectOnly1 () {
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Test.startTest();
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
            createTestData();
          Id opptyMOURecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Multi Project Opportunity').getRecordTypeId();
       List<Opportunity> projectOpportunity = [Select IGU_P_O__c,BOS_P_O__c,Ground_Breaking_Confirmed__c,Winning_Projects_Total_Sq_Ft__c,First_Request_Date_IGU__c,Approved_Win__c,	TotalOpportunityQuantity,StageName,Winning_Total_of_IGUs__c from Opportunity];

        system.debug('projectOpportunity'+projectOpportunity); 
        
        Order_Entry_Release__c od = new Order_Entry_Release__c();
        od.name='s';
        od.Release_Name__c='test';
           od.Order_Type__c='Standard';
            od.Payment_Terms__c='1% 10, Net 30';
            od.Freight__c='Billable';
            od.MES_Routing__c='MES';
            od.Opportunity__c = projectOpportunity[0].id;
            od.Shipping_Account__c=acc.id;
            od.Sold_to_Account__c =acc.id;
            od.Shipping_Account__c =acc.id;
            od.Billing_Account__c = acc.id;
            od.Scheduled_Ship_Date__c=system.today()+10;

        insert od;
        
        
      //  Id opptyMOURecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Multi Project Opportunity').getRecordTypeId();
            projectOpportunity[0].RecordTypeId = opptyMOURecordtype;
        	projectOpportunity[0].TotalOpportunityQuantity=10;
         projectOpportunity[0].StageName='Closed: Won';
        projectOpportunity[0].Approved_Win__c=True;
        projectOpportunity[0].First_Request_Date_IGU__c =system.today();
        projectOpportunity[0].Ground_Breaking_Confirmed__c='Confirmed';
        //projectOpportunity[0].Ground_Breaking_Confirmed__c=True;
            projectOpportunity[0].BOS_P_O__c=100;
            projectOpportunity[0].IGU_P_O__c=100;
        OpportunityTriggerHandlerCtrl.isUpdateDWSSWRecords = false;
            update projectOpportunity[0];
        Test.stopTest();
     //   Id opptyMOUSingleRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
       // List<Opportunity> MOUOpportunity = [Select Winning_Projects_Total_Sq_Ft__c,Winning_Total_of_IGUs__c from Opportunity where RecordTypeId =: opptyMOUSingleRecordtype];
        //system.assertEquals(10, MOUOpportunity[0].Winning_Projects_Total_Sq_Ft__c);
        //system.assertEquals(2, MOUOpportunity[0].Winning_Total_of_IGUs__c);
    }
}