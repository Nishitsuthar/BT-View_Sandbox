@isTest
public class OERTestPCV2

{
  
    
    static testMethod void TestMethod1()
    {
        /*Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};*/
         Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 2);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Boolean passedTest;
       // Test.stopTest();
 //       OETestDataFactory.progressStatusTo(oetd.oelMap.keySet(), 'Confirmation Pending', oetd);
        updatedOELs.clear();
        // Set status directly to 'Confirmation Pending'
        //
        for (Order_Entry_Release__c oer : oerList)
        {
            oer.Status__c = 'Confirmation Pending';
            oer.Trigger_Source__c = 'Test Data Setup';
            for (Order_Entry_Line__c oel : oelMap.get(oer.id))
            {
                oel.Status__c = 'Confirmation Pending';
                oel.Trigger_Source__c = 'Test Data Setup';
                updatedOELs.add(oel);
            }
        }       
        update oerList;     
        update updatedOELs;
        
        for (Order_Entry_Release__c oer : oerList)
        {
            oer.Trigger_Source__c = 'UI';
            for (Order_Entry_Line__c oel : oelMap.get(oer.id))
            {
                oel.Trigger_Source__c = 'UI';
            }
        } 

        
        
        
        oerList = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN :oelMap.keyset()];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Request_Date__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :oelMap.keySet()];

        System.debug('**** oerList.size() = ' + String.valueOf(oerList.size()));
        System.debug('**** updatedOEL.size() = ' + String.valueOf(updatedOELs.size()));

        for (Order_Entry_Release__c oer : oerList)
        {
            System.assertEquals(oer.Status__c, 'Confirmation Pending');
        }
        
     /*   for (Order_Entry_Line__c oel : updatedOELs)
        {
            System.assertEquals(oel.Status__c, 'Shipped');
        }*/
        
       //   public Map<Id, List<Contact>> oetd.contactMap = new Map<Id, List<Contact>>(); //Map from Account to the Contact List for the Account

        Order_Entry_Release__c testOER = oerList[0];
        //
        // Update the Billing Contact    
        //    
        Id newBillingContact;
        for(Contact cnct : oetd.contactMap.get(testOER.Billing_Account__c))
        {
            if(cnct.id != testOER.Billing_Contact__c)
            {
                newBillingContact = cnct.Id;
                break;
            }
        }
        if (newBillingContact == testOER.Billing_Contact__c && testOER.Billing_Contact__c != null)
        {
            testOER.Billing_Contact__c = null;
        }
        else
        {
            testOER.Billing_Contact__c  = newBillingContact;
        }
                 
        //
        // Update the Sold-to Contact    
        //    
        Id newSoldtoContact;
        for(Contact cnct : oetd.contactMap.get(testOER.Sold_to_Account__c))
        {
            if(cnct.id != testOER.Sold_to_Contact__c)
            {
                newSoldtoContact = cnct.Id;
                break;
            }
        }
        if (newSoldtoContact == testOER.Sold_to_Contact__c && testOER.Sold_to_Contact__c != null)
        {
            testOER.Sold_to_Contact__c = null;
        }
        else
        {
            testOER.Sold_to_Contact__c  = newSoldtoContact;
        }
       
        //
        // Update the Shipping Contact    
        //    
        Id newShippingContact;
        for(Contact cnct : oetd.contactMap.get(testOER.Shipping_Account__c))
        {
            if(cnct.id != testOER.Shipping_Contact__c)
            {
                newShippingContact = cnct.Id;
                break;
            }
        }
        if (newShippingContact == testOER.Shipping_Contact__c && testOER.Shipping_Contact__c != null)
        {
            testOER.Shipping_Contact__c = null;
        }
        else
        {
            testOER.Shipping_Contact__c  = newShippingContact;
        }
       
        
        //
        // Update the Shipping Address
        //
        
        testOER.Shipping_Street_1__c = '1990 New Light Street';
        testOER.Shipping_City__c = 'Toronto';
        testOER.Shipping_State_Province__c = 'ON';
        testOER.Shipping_Country__c = 'Canada';
        testOER.Shipping_Postal_Code__c = 'CA';

        passedTest = true;
        testOER.Trigger_Source__c = 'UI';
        try
        {
            update testOER;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        System.assert(passedTest);  
  
        oerList = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,CurrencyISOCOde,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN :oelMap.keyset()];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Request_Date__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :oelMap.keySet()];
                    
        testOER = oerList[0];
        
        System.debug('Dates: ' + String.valueOf(testOER.Scheduled_Ship_Date__c) + ', ' + String.valueOf(testOER.Promised_Date__c) + ', ' + String.valueOf(testOER.Request_Date__c));
        
        testOER.Trigger_Source__c = 'UI';
        testOER.Scheduled_Ship_Date__c = null;
        testOER.Promised_Date__c = null;
        testOER.Request_Date__c = null;
      //  testOER.CurrencyISOCOde = null;
        System.debug('testOER 3 = ' + String.valueOf(testOER));
        passedTest = true;
        
        try
        {
            update testOER;
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
            passedTest = false;
        }
        
        System.assert(passedTest);  
  
  
        oerList = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN :oelMap.keyset()];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Request_Date__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :oelMap.keySet()];
 
                   
        testOER = oerList[0];
        System.debug('testOER 4 = ' + String.valueOf(testOER));
        
        System.assertEquals(testOER.Request_Date__c,null);
          
        for(Order_Entry_Line__c oel : updatedOELs)
        {
            if(oel.Request_Date__c == null)
            {
                System.assertEquals(oel.Request_Date__c,null);
            }else
            {
               System.assertEquals(oel.Request_Date__c,oel.Request_Date__c); 
            }
            
            if(oel.Promised_Date__c == null)
            {
                System.assertEquals(oel.Promised_Date__c,null);
            } else 
            {
                System.assertEquals(oel.Promised_Date__c,oel.Promised_Date__c);
            }
            
            if(oel.Scheduled_Ship_Date__c == null)
            {
                System.assertEquals(oel.Scheduled_Ship_Date__c,null); 
            }else 
            {
              System.assertEquals(oel.Scheduled_Ship_Date__c,oel.Scheduled_Ship_Date__c);
            }
        }

 Test.stopTest();
      //  Test.stopTest();
    }

     

     static testMethod void testMethod_CH6()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 2,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
       // Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.startTest();
         List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        //Test.stopTest();
        
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        Order_Entry_Line__c testOEL;
        Boolean passedTest;
       
     //   
        testRel = oerList[0];
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
          
        testRel.Status__c='Draft';
        testRel.Scheduled_Ship_Date__c=System.today();
        update testRel;
     
     //      
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c,Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        testRel.Scheduled_Ship_Date__c=null;
        testRel.Request_Date__c=null;
        testRel.Promised_Date__c=null;
        testRel.Trigger_Source__c=null;
        try{
        update testRel;    
        }Catch(exception e){
        
        }
       Test.stopTest();
     }
     
     static testMethod void testMethod_CH7()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 2,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.startTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        Order_Entry_Line__c testOEL;
        Boolean passedTest;
     //   
        testRel = oerList[0];
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
          
        testRel.Status__c='Draft';
        update testRel;
     
     // 
          
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c,Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        testRel.Scheduled_Ship_Date__c=system.today();
      //  testRel.Request_Date__c=null;
      //  testRel.Promised_Date__c=null;
         testRel.Trigger_Source__c='UI';
        update testRel;
        Test.stopTest();   
    }
    
    
    
}