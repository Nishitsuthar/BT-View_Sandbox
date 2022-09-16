@isTest
public class Order_Entry_Release_BU_AU_Test1
{
    // Changes to support BOTH CQP and SFDC Quotes
    // Changes for directly setting status
    // Split of methods reduce number of SELECTs using direct status setting
    //
    
     
     static testMethod void testMethodOne()
    {
        //
        // Test Normal Order Entry Release Status Workflow Sequence - Draft to Pre-Production
        //
        System.debug('No.Of Queries Fired#'+Limits.getQueries());
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
            System.debug('   SOQL LIMITS '+Limits.getQueries());
            OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
            
            System.debug('   SOQL LIMITS '+Limits.getQueries());
            List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
            System.debug('   SOQL LIMITS '+Limits.getQueries());
        
         Test.startTest();          
         Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 2);
         
                    
            OETestDataFactory.progressStatusTo(oetd.oelMap.keySet(), 'Pre-Production', oetd); 
           
        System.debug('   SOQL LIMITS - Inside Start Method One '+Limits.getQueries());
        
        Test.stopTest();
    }
    
 	static testMethod void testMethodTwo()
    {
        
        // Test Normal Order Entry Release Status Workflow Sequence - Pre-Production to Shipped
       
       
         Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
       
            OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts); 
       	System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
            List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
            System.debug('   After release Created SOQL LIMITS '+Limits.getQueries());
        
             
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        Test.startTest();
            Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 2);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL Limits Start Method Two '+ Limits.getQueries());
        
         
        System.debug(' CUP time Start Test '+ Limits.getCpuTime()+ ' SOQL Limits Start Method Two - '+ Limits.getQueries());
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        updatedOELs.clear();
       
        for (Order_Entry_Release__c oer : oerList)
        {
            oer.Status__c = 'Pre-Production';
            oer.Trigger_Source__c = 'Test Data Setup';
            for (Order_Entry_Line__c oel : oelMap.get(oer.id))
            {
                oel.Status__c = 'Pre-Production';
                oel.Trigger_Source__c = 'Test Data Setup';
                updatedOELs.add(oel);
            }
        }
            
        update oerList;
        
        update updatedOELs;     
        
       	System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());      
            OETestDataFactory.progressStatusTo(oetd.oelMap.keySet(), 'Shipped', oetd);
        
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        Test.stopTest();

       
        
    }
    
    static testMethod void testMethodThree()
    {
        // Tests:
        //  - Pre-Integration OER level Cancellation
        //  - Prevention of changes when in Confirmation Requested Status
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};  
                
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug('   SOQL LIMITS '+Limits.getQueries());
                
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        Test.startTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 2, 'Imperial (US Standard)','CPQ');
        System.debug('   SOQL LIMITS '+Limits.getQueries());
       // Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL Limits Start Method Three - '+ Limits.getQueries());
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Boolean passedTest = false;     
        Order_Entry_Release__c testRel;
        Set<Id> progIds = new Set<Id>();
        
        
        testRel = oetd.oerList[0];      
        testRel.Status__c = 'Cancellation Requested';
        testRel.Cancellation_Reason__c = 'Customer Requested';      
        testRel.Trigger_Source__c = 'UI';
        update testRel; 
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                    FROM Order_Entry_Release__c WHERE Id = :testRel.Id];        
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c  
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.assertEquals('Cancelled', testRel.Status__c);
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            System.assertEquals('Cancelled', oel.Status__c);
        }       
        testRel = oetd.oerList[1];      
        progIds.add(testRel.Id);        
        OETestDataFactory.progressStatusTo(progIds, 'Confirmation Requested', oetd);
        progIds.clear();
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                    FROM Order_Entry_Release__c WHERE Id = :testRel.Id];        
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c  
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.assertEquals('Confirmation Requested', testRel.Status__c);
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            System.assertEquals('Confirmation Requested', oel.Status__c);
        }
        
        String savePI = testRel.Packing_Instructions__c;
        testRel.Packing_Instructions__c = 'Changed Packing_Instructions';       
        passedTest = false;
        testRel.Trigger_Source__c = 'UI';
        try
        {
            update testRel;
            System.debug('   SOQL LIMITS '+Limits.getQueries());
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Changes to field values are not permitted when Release Status is');
        }
        System.assert(passedTest);  
        testRel.Packing_Instructions__c = savePI;       
        testRel.Status__c = 'Cancellation Requested';
        testRel.Cancellation_Reason__c = 'Customer Requested';
        testRel.Trigger_Source__c = 'UI';
        
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Changing Status') && ex.getMessage().contains('is not allowed');
        }
        System.assert(passedTest);  
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        Test.stopTest();
       
    }

     static testMethod void testMethodFour()
    {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
        oetd.initOERStatus = 'In Production';
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 2, 'Imperial (US Standard)','CPQ');
        //Test.stopTest();
        
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL Limits Start Method Four - '+ Limits.getQueries());
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Boolean passedTest = false;     
        Order_Entry_Release__c testRel;
        Set<Id> updOELIds =new Set<Id>();
        
        System.Debug('*** Updated OEL = ' + String.valueOF(oelMap.get(oerList[0].id)[0]));
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :oetd.oerList[0].Id];    
        System.debug('** After OEL Status Update, testRel = ' + String.ValueOf(testRel));

        testRel = oetd.oerList[0];
        testRel.Status__c = 'Change Confirmation Requested';
        testRel.Trigger_Source__c = 'UI';
        update testRel;
        testRel.Status__c = 'Change Confirmed';
        testRel.Trigger_Source__c = 'UI';
        update testRel;
        testRel.Status__c = 'Change Integration Requested';
        testRel.Integration_Scope__c = 'Release and Line Items';
        testRel.Integration_Action_Requested__c = 'Update';
        testRel.Trigger_Source__c = 'UI';
        
        testRel.Trigger_Source__c = 'UI';
        update testRel;
        testRel.Trigger_Source__c = 'Integration';
        testRel.Integration_Status__c = 'Complete';
        update TestRel;
        
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
                testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After OER Integration Complete, testRel = ' + String.ValueOf(testRel));

        testRel.Trigger_Source__c = 'UI';       
        
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c   
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            oel.Trigger_Source__c = 'Integration';
            oel.Integration_Status__c = 'Complete';
        }
        update updatedOELs;
        
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c   
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.debug('** After OEL Status Update: ' + String.valueOf(updatedOELs[0]));
        
        System.debug('**** Limit: Queries before start of testMethod4 = ' + String.valueof(Limits.getQueries()));
        System.assertEquals('In Production', testRel.Status__c);
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            System.assertEquals('Pre-Production', oel.Status__c);
        }
        testRel.Status__c = 'Cancellation Requested';
        testRel.Cancellation_Reason__c = 'Customer Requested';
        testRel.Trigger_Source__c = 'UI';
        passedTest = true;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug('*** Update to Cancellation Requested failed: ' + ex.getMessage());
            passedTest = false;
        }
        System.assert(passedTest);  
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, 
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                    FROM Order_Entry_Release__c WHERE Id = :testRel.Id];        
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c   
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.assertEquals('Cancellation Confirmation Pending', testRel.Status__c);
        System.assertEquals('Pre-Production', testRel.Pre_Cancellation_Status__c);
        System.assertEquals('Customer Requested', testRel.Cancellation_Reason__c);
                
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            System.assertEquals('Cancellation Confirmation Pending', oel.Status__c);
            System.assertEquals('Customer Requested', oel.Cancellation_Reason__c);
        }       
        passedTest = true;
        
        testRel.Status__c = 'Cancellation Confirmation Requested';
        testRel.Trigger_Source__c = 'UI';
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug('*** Update to Cancellation Confirmation Requested failed: ' + ex.getMessage());
            passedTest = false;
        }
        System.assert(passedTest);  
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                    FROM Order_Entry_Release__c WHERE Id = :testRel.Id];        
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c  
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.assertEquals('Cancellation Confirmation Requested', testRel.Status__c);              
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            System.assertEquals('Cancellation Confirmation Requested', oel.Status__c);
        }

        testRel.Status__c = 'Cancellation Confirmed';
        testRel.Trigger_Source__c = 'UI';

        passedTest = true;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug('*** Update to Cancellation Confirmed failed: ' + ex.getMessage());
            passedTest = false;
        }
        System.assert(passedTest);  

       testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                    FROM Order_Entry_Release__c WHERE Id = :testRel.Id];        
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c  
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.assertEquals('Cancellation Confirmed', testRel.Status__c);               
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            System.assertEquals('Cancellation Confirmed', oel.Status__c);
        }


        testRel.Status__c = 'Cancellation Integration Requested';
        testRel.Trigger_Source__c = 'UI';

        passedTest = true;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug('*** Update to Cancellation Integration Requested failed: ' + ex.getMessage());
            passedTest = false;
        }
        
        System.debug('   SOQL LIMITS '+Limits.getQueries());
       Test.stopTest();
    }  
    
     static testMethod void testMethodFive()
    {
        //******************************************************************************************************
        //  Tests:
        //  - Quantity changes in Production not allow
        //  - Change to OEL Shipping Account
        //  - OER Hold Requested
        //      - Hold Reason required
        // - OER Hold Release Requested

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 2};
       
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','SFDC');
        //Test.stopTest();
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        Test.startTest(); 
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL Limits Start Method Five - '+ Limits.getQueries());
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);        
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        System.debug('   SOQL LIMITS '+Limits.getQueries());
         //Test.startTest();
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        Boolean passedTest = false;     
        Order_Entry_Release__c testRel;
        Set<Id> updOELIds =new Set<Id>();

        updatedOELs.clear();
        // Set status directly to 'In Production'
         
         System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL Limits '+ Limits.getQueries());
        for (Order_Entry_Release__c oer : oerList)
        {
            oer.Status__c = 'In Production';
            oer.Trigger_Source__c = 'Test Data Setup';
            for (Order_Entry_Line__c oel : oelMap.get(oer.id))
            {
                oel.Status__c = 'In Production';
                oel.Trigger_Source__c = 'Test Data Setup';
                updatedOELs.add(oel);
            }
        }       
        update oerList;     
        update updatedOELs;

        System.debug('   SOQL LIMITS '+Limits.getQueries());
        System.Debug('*** Updated OEL = ' + String.valueOF(oelMap.get(oerList[0].id)[0]));

        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :oetd.oerList[0].id];    
        
       
        //Test.startTest();


        //
        // Test OER Hold
        //
        
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** Begginning Hold Testing, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c   
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];


        System.debug('** Beginning Hold Testing : ' + String.valueOf(updatedOELs[0]));
        
        testRel.Status__c = 'Hold Requested';
        testRel.Trigger_Source__c = 'UI';
        passedTest = true;
        try
        {
            update testRel;
        }
        //
        // Test Hold Reason required
        //
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest =  ex.getMessage().contains('You must enter a hold reason');
        }
        System.Assert(passedTest);
        testRel.Hold_Reason__c = 'Customer Requested';
        testRel.Trigger_Source__c = 'UI';
        passedTest = true;
        try
        {
            update testRel;
            
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        System.Assert(passedTest);
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        //
        // Release and Lines updated to Hold Requested
        //
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After Hold Requested Update, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c, Integration_Action_Requested__c    
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.debug('** After OER Hold Requested Update, OEL: ' + String.valueOf(updatedOELs[0]));

        //
        // Simulate Integration Hold Requested
        //
        testRel.Trigger_Source__c = 'UI';
        testRel.Status__c = 'Change Integration Requested';
        testRel.Integration_Scope__c = 'Release and Line Items';
        testRel.Integration_Action_Requested__c = 'Hold';
        passedTest = true;
        try
        
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        System.Assert(passedTest);
       System.debug('   SOQL LIMITS '+Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, Pre_Hold_Status__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After OER Hold Integration Requested, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c, Pre_Hold_Status__c, Integration_Action_Requested__c    
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.debug('** After OER Hold Integration Requested, OEL: ' + String.valueOf(updatedOELs[0]));

        //
        // Simulate Line Integration Complete
        //
                
        for(Order_Entry_Line__c oel: updatedOELs)
        {
            oel.Trigger_Source__c = 'Integration';
            oel.Integration_Status__c = 'Complete';
        }
        
        passedTest = true;
        try     
        {
            update updatedOELs;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }       
        System.Assert(passedTest);
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, Pre_Hold_Status__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After OEL Integration Complete, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c, Pre_Hold_Status__c, Integration_Action_Requested__c    
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.debug('** After OEL Status Update: ' + String.valueOf(updatedOELs[0]));

        //
        // Simulate Release Integration Complete

        testRel.Trigger_Source__c = 'Integration';
        testRel.Integration_Status__c = 'Complete';
        passedTest = true;
        try     
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }       
        System.Assert(passedTest);
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, Pre_Hold_Status__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After OER Integration Complete, testRel = ' + String.ValueOf(testRel));

        //
        // Hold process complete: Release and Line is Hold
        //
        
        //
        // Simulate Hold Release Process
        //


        //
        // Update Release Status to 'Hold Release Requested'
        //
        String checkPreholdStatus = testRel.Pre_Hold_Status__c;
        testRel.Status__c = 'Hold Release Requested';
        testRel.Trigger_Source__c = 'UI';
        passedTest = true;

        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        System.Assert(passedTest);
        

        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After OER Integration Complete, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c, Integration_Action_Requested__c    
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.debug('** After OEL Status Update: ' + String.valueOf(updatedOELs[0]));

        testRel.Status__c = 'Change Integration Requested';
        testRel.Integration_Scope__c = 'Release and Line Items';
        testRel.Integration_Action_Requested__c = 'Hold Release';
        passedTest = true;
        try
        
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        System.Assert(passedTest);


        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, Pre_Hold_Status__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After OER Integration Complete, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c, Pre_Hold_Status__c, Integration_Action_Requested__c    
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.debug('** After OEL Status Update: ' + String.valueOf(updatedOELs[0]));

        //
        // Simulate Line Integration Complete Event
        //
        
        for(Order_Entry_Line__c oel: updatedOELs)
        {
            oel.Trigger_Source__c = 'Integration';
            oel.Integration_Status__c = 'Complete';
        }
        
        passedTest = true;
        try     
        {
            update updatedOELs;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }       
        System.Assert(passedTest);
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        //
        // Simulation Release Integration Complete Event
        //
                
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, Pre_Hold_Status__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After OER Integration Complete, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c, Pre_Hold_Status__c, Integration_Action_Requested__c    
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.debug('** After OEL Status Update: ' + String.valueOf(updatedOELs[0]));

        testRel.Trigger_Source__c = 'Integration';
        testRel.Integration_Status__c = 'Complete';
        passedTest = true;
        try     
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        Test.stopTest();
    } 
	
     static testMethod void testMethodSix()
    {
        //******************************************************************************************************
        //  Tests:
        //  - Quantity changes in Production not allowed
        //  - Change to OEL Shipping Account
      
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 2, 'Imperial (US Standard)','SFDC');
       	Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
         System.debug('   SOQL LIMITS '+Limits.getQueries());
        
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        
        Boolean passedTest = false;     
        Order_Entry_Release__c testRel;
        Set<Id> updOELIds =new Set<Id>();

        updatedOELs.clear();
        // Set status directly to 'In Production'
        //
        for (Order_Entry_Release__c oer : oerList)
        {
            oer.Status__c = 'In Production';
            oer.Trigger_Source__c = 'Test Data Setup';
            for (Order_Entry_Line__c oel : oelMap.get(oer.id))
            {
                oel.Status__c = 'In Production';
                oel.Trigger_Source__c = 'Test Data Setup';
                updatedOELs.add(oel);
            }
        }       
        update oerList;     
        update updatedOELs;
		
        
         System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL Limits Start Method Four - '+ Limits.getQueries());
         System.debug('   SOQL LIMITS '+Limits.getQueries());
        System.Debug('*** Updated OEL = ' + String.valueOF(oelMap.get(oerList[0].id)[0]));

        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :oetd.oerList[0].id];    
        
       
        //Test.startTest();
        
        System.debug('**** Limit: Queries before start of testMethod5 = ' + String.valueof(Limits.getQueries()));
        System.assertEquals('In Production', testRel.Status__c);
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            System.assertEquals('In Production', oel.Status__c);
        }
        //
        // Test Changes to OEL Quantity
        //
        Order_Entry_Line__c updatedOEL = updatedOELs[0];
        Decimal oldQuantity = updatedOEL.Quantity__c;
        updatedOEL.Quantity__c = updatedOEL.Quantity__c + 5;
        updatedOEL.Trigger_Source__c = 'UI';
        passedTest = false;
        try
        {
            update updatedOEL;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Quantity changes are not allowed when Status is In Production');
        }
        //System.assert(passedTest);  
        updatedOEL.Quantity__c = oldQuantity;
        updatedOEL.Trigger_Source__c = 'UI';
        //
        // Test changes to OEL Shipping Account
        //
        for(Account acct : oetd.shipToAcctList)
        {
            if (acct.Id != updatedOEL.Shipping_Account__c)
            {
                updatedOEL.Shipping_Account__c = acct.Id;
            }
        }
        passedTest = true;
        try
        {
            update updatedOEL;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        System.Assert(passedTest);

        //
        // Request Integration for Address changes
        //
        testRel.Status__c = 'Change Integration Requested';
        testRel.Integration_Scope__c = 'Release and Line Items';
        testRel.Integration_Action_Requested__c = 'Hold';
        testRel.Trigger_Source__c = 'UI';
        passedTest = true;
        try
        
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        

        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, Pre_Hold_Status__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After Address Change Integration Requested, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c, Pre_Hold_Status__c, Integration_Action_Requested__c    
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.debug('** After - Address Change Integration Requested, OEL Status Update: ' + String.valueOf(updatedOELs[0]));

        //
        // Simulate Line Integration Complete
        //
                
        for(Order_Entry_Line__c oel: updatedOELs)
        {
            oel.Trigger_Source__c = 'Integration';
            oel.Integration_Status__c = 'Complete';
        }
        
        passedTest = true;
       
        try     
        {
            update updatedOELs;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }       
         System.debug('   SOQL LIMITS '+Limits.getQueries());

        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c, Scheduled_Ship_Date__c,              
                Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c, Integration_Action_Requested__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Pre_Change_Status__c,
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c, Integration_Scope__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, Pre_Hold_Status__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c, Pre_Cancellation_Status__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, Cancellation_Reason__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Shipping_Address__c, Billing_Address__c, Sold_To_Address__c, Packing_Instructions__c 
                FROM Order_Entry_Release__c WHERE Id = :testRel.Id];    
        System.debug('** After OEL Address Change Integration Complete, testRel = ' + String.ValueOf(testRel));

        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Pre_Change_Status__c,
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Cancellation_Reason__c, Pre_Hold_Status__c, Integration_Action_Requested__c    
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];
        System.debug('** After OEL Integration Complete Status Update: ' + String.valueOf(updatedOELs[0]));

        //
        // Simulate Release Integration Complete

        testRel.Trigger_Source__c = 'Integration';
        testRel.Integration_Status__c = 'Complete';
        passedTest = true;
        try     
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }  
             
         System.debug('   SOQL LIMITS '+Limits.getQueries());
     	 
        Test.stopTest();
    }
 
    static testMethod void testMethodSeven()
    {
        //******************************************************************************************************
        //  Tests:
        //  - Quote Error Conditions: Both CPQ and SFDC Quote null, both CPQ and SFDC Quote non-Null, Change from SFDC to CPQ Quote, Change from CPQ to SFDC Quote
        //  - Test error for field change during Integration
        //  
       
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 2, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        //Test.stopTest();
        Test.startTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 2, 'Imperial (US Standard)','CPQ');
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        //Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);  
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
         System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL Limits Start Method Seven - '+ Limits.getQueries());
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();        
        Boolean passedTest = false;     
        Order_Entry_Release__c testRel;
        Set<Id> updOELIds =new Set<Id>();

        //OETestDataFactory.progressStatusTo(oetd.oelMap.keySet(), 'Pre-Release Review', oetd);       
        
        testRel = oetd.oerList[0];
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        //test.startTest();     
        //
        // Test for both CPQ and SFDC quote = null
        //
        System.debug('testRel'+ testRel.CPQ_Quote__c);
        Id saveQuoteId = testRel.CPQ_Quote__c;
        testRel.CPQ_Quote__c = null;
        System.debug('testRel'+ testRel.CPQ_Quote__c);           
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug('**********'+ex.getMessage());
            passedTest = ex.getMessage().contains('CPQ Quote and SFDC Quote may not both be null.');
        }
        System.assert(passedTest);  
        
        //
        // Test for both CPQ and SFDC quote present
        //
        testRel.CPQ_Quote__c = saveQuoteId;
        testRel.Quote__c = oetd.quoteList[0].id;
                    
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Order Entry Release may not have both CPQ and SFDC Quotes.');
        }
        System.assert(passedTest);  
        System.debug('   SOQL LIMITS '+Limits.getQueries());
       
        //
        // Test for changing from one Quote CPQ to SFDC
        //
        
        testRel.CPQ_Quote__c = null;
        testRel.Quote__c = oetd.quoteList[0].id;
                    
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Once an Order Entry Release has been created, it the Quote Source may not be changed from CPQ to SFDC');
        }
        System.assert(passedTest);  

        Order_Entry_Release__c newOER = testRel;
        
        newOER.id = null;

        newOER.Quote__c =  oetd.quoteMap.get(newOER.Opportunity__c)[0].id;
        newOER.CPQ_Quote__c = null;
        insert newOER;
        
        newOER.Quote__c = null;
        newOER.CPQ_Quote__c = oetd.CPQ_quoteMap.get(newOer.Opportunity__c)[0].id;
        
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Once an Order Entry Release has been created, it the Quote Source may not be changed from SFDC to CPQ');
        }
        System.assert(passedTest);  

        //
        // Test field changes not allowed during integration.
        //
        testRel = oetd.oerList[0];
        testRel.Trigger_Source__c = 'Test Data Setup';
        testRel.Integration_Status__c = 'In Process';
        update testRel;
        testRel.Trigger_Source__c = 'UI';
        Date prevReqDate = testRel.Request_Date__c;
        testRel.Request_Date__c = System.today() + 25;
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Update is not permitted while integration is in process');
        }
       // System.assert(passedTest); 
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        //
        // Test for Billing Account with No Valid Address
        //        
        testRel.Request_Date__c = prevReqDate;
        testRel.Integration_Status__c = 'Complete';
        testRel.Trigger_Source__c = 'Test Data Setup';
        update testRel;
        
        Account newBillingAccount;
        for (Account acct : oetd.billToAcctList)
        {
            if(acct.id != testRel.Billing_Account__c)
            {
                newBillingAccount = acct;
                break;
            }
        }
        /*
        Account saveNewBillingAcct = newBillingAccount;
        newBillingAccount.BillingStreet = null;
        newBillingAccount.BillingCity = null;       
        newBillingAccount.ShippingStreet = null;
        newBillingAccount.ShippingCity = null;  
        update newBillingAccount; */
        testRel.Billing_Account__c = newBillingAccount.id;
        testRel.Trigger_Source__c = 'UI';   
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Billing Account has no valid addresses.');
        }
        //System.assert(passedTest); 

        testRel.Request_Date__c = prevReqDate;
        testRel.Integration_Status__c = 'Complete';
        testRel.Trigger_Source__c = 'Test Data Setup';
        update testRel;
        

        //
        // Test for Sold-to Account with No Valid Address
        //        
        testRel = oetd.oerList[0];
        Id saveSoldToAccount = testRel.Sold_To_Account__c;
        Account newSoldToAccount;
        for (Account acct : oetd.shipToAcctList)
        {
            if(acct.id != testRel.Sold_To_Account__c)
            {
                newSoldToAccount = acct;
                break;
            }
        }
        
        testRel.Sold_to_Account__c = newSoldToAccount.id;
        testRel.Trigger_Source__c = 'UI';   
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Sold-to Account has no valid address.');
        }
        //System.assert(passedTest);         
       // update saveNewSoldToAccount;
        testRel.Sold_To_Account__c = saveSoldToAccount;
        
        
        //
        // Test for null Sold-to Account
        //
        
        testRel = oetd.oerList[0];
        testRel.Sold_to_Account__c = null;
        testRel.Trigger_Source__c = 'UI';   
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Sold-to Account is a required field; it may not be null.');
        }
        //System.assert(passedTest);         
        testRel.Sold_To_Account__c = saveSoldToAccount;
        
        //
        // Test new fields; Freight, Payment Terms, Deposit, Shipping Container
        //
        testRel=oetd.oerList[0];
        testRel.Deposit_Amount__c = 1000000.00 * Math.random();
        testRel.Shipping_Container__c = 'A-Frame';
        testRel.Freight__c = 'Non-Billable';
        testRel.Payment_Terms__c = '90 NET';
        
        passedTest = true;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        //System.assert(passedTest);    
        //
        // Test for change when Status prohibits
        //    
        testRel.Trigger_Source__c = 'Test Data Setup';
        testRel.Status__c = 'Confirmation Requested';
        update testRel;
        testRel.Trigger_Source__c = 'UI';
        testRel.Request_Date__c = System.today() + 25;
        passedTest = false;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Changes to field values are not permitted when Release Status is');
        }
        //System.assert(passedTest);    
        testRel.Trigger_Source__c = 'Test Data Setup';
        testRel.Status__c = 'Pre-Release Review';
        testRel.Request_Date__c = System.today();
        update testRel;
        testRel.Trigger_Source__c = 'UI';
        //
        // Simultaneous Cancellation and Change not permitted
        //
        testRel.Status__c = 'Cancellation Requested';
        testRel.Request_Date__c = System.today() + 17;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Changes to other field values are not allowed during the cancellation process');
        }
        //System.assert(passedTest); 
        testRel.Status__c = 'Pre-Release Review';
        testRel.Request_Date__c = System.today();   
        //
        // Simultaneous Hold and Change not permitted
        //
        testRel.Status__c = 'Hold Requested';
        testRel.Request_Date__c = System.today() + 17;
        try
        {
            update testRel;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = ex.getMessage().contains('Changes to other field values are not allowed during the hold process');
        }
        //System.assert(passedTest); 
        testRel.Status__c = 'Pre-Release Review';
        testRel.Request_Date__c = System.today();   
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        test.stopTest();      
    }
}