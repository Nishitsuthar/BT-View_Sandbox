@isTest
public class OrderEntryReleaseWrapper_Test
{
    static testMethod void TestMethod1()
    {
        /*Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 3,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 2,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};*/
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 3);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        
        
        Order_Entry_Release__c testRel = oetd.oerList[0];
         testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c,                 
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_Street_2__c, Shipping_Street_3__c,Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, Quote_Line_Item__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];

        OrderEntryReleaseWrapper testOERW = new OrderEntryReleaseWrapper(testRel);
        testRel = testOERW.oer;
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            testOERW.addOrderEntryLine(oel);
        }
        
        for (Account acct : oetd.shipToAcctList)
        {
            if (acct.ID != testRel.Shipping_Account__c)
            {
                testRel.Shipping_Account__c = acct.ID;
            }
        }
        
        System.assert(testOERW.allLinesPreConfirmation());
        System.assert(testOERW.allLinesPreConfirmation());
        
        testOERW.copyShippingInfoToLines(true);
        
        testOERW.setLineFields('Release Date', System.Today() + 35);
        testOERW.setLineFields('Committed Date', System.Today() + 87);
    
        testOERW.setLineFields('Status', 'Pre-Production');
        testOERW.setLineFields('Integration Status', 'Requested');
        testOERW.setLineFields('Trigger Source', 'Release');
        
        String newStatus = testOERW.getNewStatus();
        System.assertEquals('Pre-Production', newStatus);
        testOERW.oer.Status__c = newStatus;
        testOERW.setLineFields('Status','In Production');
        newStatus = testOERW.getNewStatus();
        System.assertEquals('In Production', newStatus);
        testOERW.oer.Status__c = newStatus;
        
        List <OrderEntryLineWrapper> oelwList = testOERW.oelwList;
        oelwList[0].oel.Status__c = 'Cancelled';
        oelwList[1].oel.Status__c = 'Partially Shipped';
        oelwList[2].oel.Status__c = 'Shipped';
        newStatus = testOERW.getNewStatus();
        System.assertEquals('Partially Shipped', newStatus);
        testOERW.oer.Status__c = newStatus;
        
        testOERW.setIntegrationScope('Release');
        System.assertEquals('Release', testOERW.oer.Integration_Scope__c);

        testOERW.setIntegrationScope('Line Items');
        System.assertEquals('Release and Line Items', testOERW.oer.Integration_Scope__c);
    }
    
    //Added by ENP - START - Sajid
      static testMethod void testMethod_IGU()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ', 'IGU');
        Test.stopTest();

        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 3, 'IGU_Imperial');
            }
    //Added by ENP - END 
    
    //Added by ENP - START - Sajid
    static testMethod void testMethod_CH()
    {
        /*Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 3,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 2,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};*/
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 3, Label.CSS_Hardware);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        
        
        Order_Entry_Release__c testRel = oetd.oerList[0];
         testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c,                 
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_Street_2__c, Shipping_Street_3__c,Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, Quote_Line_Item__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];

        OrderEntryReleaseWrapper testOERW = new OrderEntryReleaseWrapper(testRel);
        testRel = testOERW.oer;
        for (Order_Entry_Line__c oel : updatedOELs)
        {
            testOERW.addOrderEntryLine(oel);
        }
        
        for (Account acct : oetd.shipToAcctList)
        {
            if (acct.ID != testRel.Shipping_Account__c)
            {
                testRel.Shipping_Account__c = acct.ID;
            }
        }
        
        System.assert(testOERW.allLinesPreConfirmation());
        System.assert(testOERW.allLinesPreConfirmation());
        
        testOERW.copyShippingInfoToLines(true);
        
        testOERW.setLineFields('Release Date', System.Today() + 35);
        testOERW.setLineFields('Committed Date', System.Today() + 87);
    
        testOERW.setLineFields('Status', 'Integration Requested');
        testOERW.setLineFields('Integration Status', 'Requested');
        testOERW.setLineFields('Trigger Source', 'Line');
        
        String newStatus = testOERW.getNewStatus();
        
        testOERW.oer.Status__c = newStatus;
        testOERW.setLineFields('Status','Change Requested');
        newStatus = testOERW.getNewStatus();
        
        testOERW.oer.Status__c = newStatus;
        
        List <OrderEntryLineWrapper> oelwList = testOERW.oelwList;
        oelwList[0].oel.Status__c = 'Change Requested';
        oelwList[1].oel.Status__c = 'Change Requested';
        
        newStatus = testOERW.getNewStatus();
        
        testOERW.oer.Status__c = newStatus;
        
        testOERW.setIntegrationScope('Release and Line Items');
        
        List <OrderEntryLineWrapper> oelwList1 = testOERW.oelwList;
        oelwList1[0].oel.Status__c = 'Planned';
        oelwList1[1].oel.Status__c = 'Planned';
        oelwList1[2].oel.Status__c = 'Planned';
        newStatus = testOERW.getNewStatus();
        
        testOERW.oer.Status__c = newStatus;
        
        testOERW.setIntegrationScope('Release and Line Items');
        List <OrderEntryLineWrapper> oelwList2 = testOERW.oelwList;
        oelwList2[0].oel.Status__c = 'Planned';
        Boolean isChecked = testOERW.allLinesPreIntegration();
        
    }
    //Added by ENP - END    
}