@isTest
public class OrderEntryReleaseTriggerTest {
    
    
    static testMethod void methodOneIGU()
    {
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
        System.debug(' After Account Insert SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
       Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOpptyParent';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype; 
        testMOUOpportunityObj.AccountId= acc.id;
        insert testMOUOpportunityObj;
        System.debug(' After Opp Insert SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
       Order_Entry_Release__c od = new Order_Entry_Release__c();
            od.name='s';
            od.Release_Name__c='test';
           	od.Order_Type__c='Standard';
            od.Payment_Terms__c='1% 10, Net 30';
            od.Freight__c='Billable';
            od.MES_Routing__c='MES';
            od.Opportunity__c = testMOUOpportunityObj.id;
            od.Shipping_Account__c=acc.id;
            od.Sold_to_Account__c =acc.id;
            od.Shipping_Account__c =acc.id;
            od.Billing_Account__c = acc.id;
            od.Scheduled_Ship_Date__c=system.today()+10;
        	od.RecordTypeId = '0120h000000QiWmAAK';

        insert od;
        System.debug(' After First Order  Insert SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
        Order_Entry_Release__c od2 = new Order_Entry_Release__c();
            od2.name='s';
            od2.Release_Name__c='test';
           	od2.Order_Type__c='Standard';
            od2.Payment_Terms__c='1% 10, Net 30';
            od2.Freight__c='Billable';
            od2.MES_Routing__c='MES';
            od2.Opportunity__c = testMOUOpportunityObj.id;
            od2.Shipping_Account__c=acc.id;
            od2.Sold_to_Account__c =acc.id;
            od2.Shipping_Account__c =acc.id;
            od2.Billing_Account__c = acc.id;
            od2.Scheduled_Ship_Date__c=system.today()+15;
        	od2.RecordTypeId = '0120h000000QiWlAAK';

        insert od2;
       System.debug(' After 2 nd Order Insert SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
        
        /*
        try{
            delete od;
        }
        
        catch (Exception e)
        {
            
        } */       
    }
    
    static testMethod void methodTwoIGU()
    {
        
        Profile prof = [select id from profile where name LIKE '%Deal Desk%'];
            User user = new User();
            user.firstName = 'test1';
            user.lastName = 'test2';
            user.profileId = prof.id;
            user.username = 'test@test.com';
            user.email = 'test@test.com';

          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
          Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();

       
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
       
        insert testMOUOpportunityObj;
        System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
       Order_Entry_Release__c od = new Order_Entry_Release__c();
            od.name='s';
            od.Release_Name__c='test';
            od.Order_Type__c='Standard';
            od.Payment_Terms__c='1% 10, Net 30';
            od.Freight__c='Billable';
            od.MES_Routing__c='MES';
            od.Opportunity__c = testMOUOpportunityObj.id;
            od.Shipping_Account__c=acc.id;
            od.Sold_to_Account__c =acc.id;
            od.Shipping_Account__c =acc.id;
            od.Billing_Account__c = acc.id;
            od.Scheduled_Ship_Date__c=system.today()+10;
        	od.RecordTypeId = '0120h000000QiWmAAK';
          
        insert od;
    	System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
      Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=testMOUOpportunityObj.id ,Include_Freight_rough_estimate_only__c = false, 
                                  	Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false,
                                  		Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, 
                                  			Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, 
                                  				Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, 
                                  						Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
 		Insert quote_Obj; 
 		System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
           od.Quote__c= quote_Obj.id;
           od.Scheduled_Ship_Date__c=system.today()+20;
           od.Order_Book_Date__c = system.now()+1;
           od.Extended_Price_Total__c=10000;
           od.Sales_Order_Status__c='Booked';
        update od;
        System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
    }
    
      static testMethod void methodThreeCHW()
    {
        
        Profile prof = [select id from profile where name LIKE '%Deal Desk%'];
            User user = new User();
            user.firstName = 'test1';
            user.lastName = 'test2';
            user.profileId = prof.id;
            user.username = 'test@test.com';
            user.email = 'test@test.com';

          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
          Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();

       
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
        System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
        contact c = new contact();
        c.AccountId = acc.id;
        c.LastName='Test';
        c.Salutation='Mr.';
        c.Email='test@test.com';
        insert c;
        System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
       Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOpptyParent';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype; 
        testMOUOpportunityObj.AccountId= acc.id;
        testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Ops_Owner__c =user.id; 
       
        insert testMOUOpportunityObj;
        System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
       Order_Entry_Release__c od = new Order_Entry_Release__c();
            od.name='s';
            od.Release_Name__c='test';
            od.Order_Type__c='Standard';
            od.Payment_Terms__c='1% 10, Net 30';
            od.Freight__c='Billable';
            od.MES_Routing__c='MES';
            od.Opportunity__c = testMOUOpportunityObj.id;
            od.Shipping_Account__c=acc.id;
            od.Sold_to_Account__c =acc.id;
            od.Shipping_Account__c =acc.id;
            od.Billing_Account__c = acc.id;
            od.Scheduled_Ship_Date__c=system.today()+10;
        	od.RecordTypeId = '0120h000000QiWlAAK';
          
        insert od;
    	System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
      Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=testMOUOpportunityObj.id ,Include_Freight_rough_estimate_only__c = false, 
                                  	Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false,
                                  		Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, 
                                  			Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, 
                                  				Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, 
                                  						Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
 		Insert quote_Obj; 
 		System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
           od.Quote__c= quote_Obj.id;
           od.Scheduled_Ship_Date__c=system.today()+27;
           od.Order_Book_Date__c = system.now()+12;
           od.Extended_Price_Total__c=1000;
           od.Sales_Order_Status__c='Booked';
        update od;
        System.debug('SOQL '+Limits.getQueries() + ' CPU Time '+ Limits.getCpuTime());
    }   
}