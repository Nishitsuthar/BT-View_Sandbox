@isTest
public class Order_Entry_Line_BU_AU_Test
{
  
 
    static testMethod void testMethod_CHWFullTest()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 2};
            
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
                OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
                     
                List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
            Test.startTest();
            Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
            System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
             //  Test.startTest();
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
            List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
            Order_Entry_Release__c testRel;
            list<Order_Entry_Line__c> testOEL;
            Boolean passedTest;    
            testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :oerList[0].Id LIMIT 1];             
           testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                        RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                        Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                        Use_Account_Shipping_Address__c,Installation_Type__c,Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                        WHERE Order_Entry_Release__c = :testRel.Id];
        
            System.assertEquals(testRel.status__c,'Draft');
            System.assertEquals(testOEL[0].status__c,'Draft'); 
            
             
            
            testRel.Status__c='Integration Requested';
            testRel.Trigger_Source__c = 'UI';
            update testRel;
       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        
       
        
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
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];              
        
        
        for(Order_Entry_Line__c oel:testOEL){
            oel.Integration_Status__c='Complete';
            oel.Trigger_Source__c='Integration';
            oel.Quantity__c=7;
        }
        update testOEL;
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());   
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id ];
                     
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
                    
            
            
        
            System.assertEquals(testOEL[0].status__c,'Planned'); 
            System.assertEquals(testRel.status__c,'Planned');
            
           /* testRel.Trigger_Source__c = 'Integration';
            testRel.Integration_Status__c = 'Complete';
            update testRel;*/
                
            
        
            testRel.Status__c='Confirmation Requested';
            testRel.Trigger_Source__c = 'UI';
            update testRel;

       
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
                        RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                        Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                        Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                        WHERE Order_Entry_Release__c = :testRel.Id];
                        
            System.assertEquals(testRel.status__c,'Confirmation Requested');
            System.assertEquals(testOEL[0].status__c,'Confirmation Requested');    
        
            testRel.Status__c='Confirmed';
            testRel.Trigger_Source__c = 'UI';
            update testRel;   
            System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
      
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
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
                    
        System.assertEquals(testRel.status__c,'Confirmed');
        System.assertEquals(testOEL[0].status__c,'Confirmed');
        
        testRel.Status__c='Approval to Ship Requested';
        update testRel;               

      System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
                    
        System.assertEquals(testRel.status__c,'Approval to Ship Requested');
        System.assertEquals(testOEL[0].status__c,'Approval to Ship Requested');
        
        for(Order_Entry_Line__c oel:testOEL){
            oel.Integration_Status__c='Complete';
            oel.Trigger_Source__c='Integration';
            oel.Sales_Order_Line_Status__c='Awaiting Shipment';
        }
       
        //testOEL.Status__c = 'Approval to Ship Requested';
        //testOEL.Sales_Order_Line_Status__c='Awaiting Shipment';
        update testOEL;
        System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.assertEquals(testRel.status__c,'Approved-to-Ship');
        System.assertEquals(testOEL[0].status__c,'Approved-to-Ship');  
        
        for(Order_Entry_Line__c oel:testOEL){
            if(oel.Quantity__c>0){          
                oel.Quantity_Shipped__c = oel.Quantity__c-2;
                oel.Trigger_Source__c = 'Integration';
            }
        }
        
        update testOEL;
        System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c,Quantity_Shipped__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id ];
        
        System.assertEquals(testRel.status__c,'Partially Shipped');
        System.assertEquals(testOEL[0].status__c,'Partially Shipped');
        //covering validation
        integer i=0;
        for(Order_Entry_Line__c oel:testOEL){
            if(oel.Quantity__c>0){          
                if(i==0)
                oel.Quantity__c = oel.Quantity__c+5;
                if(i==1 && oel.Quantity_Shipped__c > 1)
                oel.Quantity__c = oel.Quantity_Shipped__c-1;
                i++;
                oel.Trigger_Source__c = 'UI';
                oel.Scheduled_Ship_Date__c = system.today().addDays(3);
            }
        }
         boolean isError=false;
         try{
            update testOEL;
         }
         catch(exception e)
         {
            isError=true;
         }
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         system.assert(isError);
         for(Order_Entry_Line__c oel:testOEL){
            if(oel.Quantity__c>0){          
                oel.Quantity_Shipped__c = oel.Quantity__c;
                oel.Trigger_Source__c = 'Integration';
            }
        }
        try{
        update testOEL;
        }
        catch(exception e)
        {
        }
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());         
        Test.stopTest();       
    }
        
    static testMethod void testMethod_SWFullTest()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 2};
        
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Software);
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         Test.startTest(); 
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Software);
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        list<Order_Entry_Line__c> testOEL;
        Boolean passedTest;
 
     
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :oerList[0].Id LIMIT 1];    
     
         
        testRel.Status__c='Integration Requested';
        testRel.Trigger_Source__c = 'UI';
        update testRel;
      System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
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
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];              
        
        
        for(Order_Entry_Line__c oel:testOEL){
            oel.Integration_Status__c='Complete';
            oel.Trigger_Source__c='Integration';
        }
        update testOEL;
        System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
       
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id ];
                     
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
                    
            
            
        
            System.assertEquals(testOEL[0].status__c,'Planned'); 
            System.assertEquals(testRel.status__c,'Planned');
            
           /* testRel.Trigger_Source__c = 'Integration';
            testRel.Integration_Status__c = 'Complete';
            update testRel;*/
                
            
           for(Order_Entry_Line__c oel:testOEL){
            oel.Sales_Order_Line_Status__c='Booked';
            oel.Trigger_Source__c = 'Integration';
            oel.Integration_Status__c = 'Complete';
        }
        update testOEL;
        System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
       
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
                        RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                        Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                        Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                        WHERE Order_Entry_Release__c = :testRel.Id];
                        
            System.assertEquals(testRel.status__c,'Booked');
            System.assertEquals(testOEL[0].status__c,'Booked');    
        
        for(Order_Entry_Line__c oel:testOEL){
            oel.Sales_Order_Line_Status__c='Closed';
            oel.Trigger_Source__c = 'Integration';
            oel.Integration_Status__c = 'Complete';
             
        }
        update testOEL;
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
       Test.stopTest();                 
    }
  
     static testMethod void testMethod_CHWFullTest1()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
      
         List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware); 
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        Test.startTest();
         Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        
          
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        list<Order_Entry_Line__c> testOEL;
        Boolean passedTest;
 
     
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :oerList[0].Id LIMIT 1];    
     
            
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c,Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.assertEquals(testRel.status__c,'Draft');
        System.assertEquals(testOEL[0].status__c,'Draft'); 
      
        testRel.Status__c='Integration Requested';
        testRel.Trigger_Source__c = 'UI';
        update testRel;
       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
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
                    WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.assertEquals(testRel.status__c,'Integration Requested');
        System.assertEquals(testOEL[0].status__c,'Integration Requested');
        
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
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];              
        
        
        for(Order_Entry_Line__c oel:testOEL){
            oel.Integration_Status__c='Complete';
            oel.Trigger_Source__c='Integration';
        }
        update testOEL;
       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id ];
                     
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
                    

            testRel.Status__c='Confirmation Requested';
            testRel.Trigger_Source__c = 'UI';
            update testRel;

       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
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
                        RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                        Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                        Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                        WHERE Order_Entry_Release__c = :testRel.Id];
                        
            System.assertEquals(testRel.status__c,'Confirmation Requested');
            System.assertEquals(testOEL[0].status__c,'Confirmation Requested');    
        
            testRel.Status__c='Confirmed';
            testRel.Trigger_Source__c = 'UI';
            update testRel;   
                System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         
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
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
                    
        System.assertEquals(testRel.status__c,'Confirmed');
        System.assertEquals(testOEL[0].status__c,'Confirmed');
        
        testRel.Status__c='Approval to Ship Requested';
        update testRel;               

       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
                    
        System.assertEquals(testRel.status__c,'Approval to Ship Requested');
        System.assertEquals(testOEL[0].status__c,'Approval to Ship Requested');
        
        for(Order_Entry_Line__c oel:testOEL){
            oel.Integration_Status__c='Complete';
            oel.Trigger_Source__c='Integration';
            oel.Sales_Order_Line_Status__c='Awaiting Shipment';
        }
       
        //testOEL.Status__c = 'Approval to Ship Requested';
        //testOEL.Sales_Order_Line_Status__c='Awaiting Shipment';
        update testOEL;
        System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.assertEquals(testRel.status__c,'Approved-to-Ship');
        System.assertEquals(testOEL[0].status__c,'Approved-to-Ship'); 
         Test.stopTest();
       boolean isError=false;
       try{
           for(Order_Entry_Line__c oel:testOEL){
                oel.Scheduled_Ship_Date__c = system.today().addDays(3);
                oel.Trigger_Source__c='UI';
                
                
            }
            update testOEL;
        }
        catch(exception e)
        {
            isError=true;
        }
       
        for(Order_Entry_Line__c oel:testOEL){
                oel.Scheduled_Ship_Date__c = system.today().addDays(3);
                oel.Trigger_Source__c='Integration';
                
        }
        update testOEL;
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
        
        
        for(Order_Entry_Line__c oel:testOEL){
                oel.Promised_Date__c = system.today().addDays(3);
                oel.Scheduled_Ship_Date__c = system.today().addDays(5);
                oel.Request_Date__c = system.today().addDays(5);
                oel.Quantity__c=oel.Quantity__c-1;
                oel.Trigger_Source__c='UI';
                oel.Customer_Reference_Description__c='test2';
                
        }
        try{
        update testOEL;
        }
        catch(exception e)
        {
        }
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         
    }
 
     static testMethod void testMethod_CHWFullTestchange()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
            System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
                OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
                List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
            System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         Test.startTest();
            Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
            
            List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
            Order_Entry_Release__c testRel;
            list<Order_Entry_Line__c> testOEL;
            Boolean passedTest;    
            testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c, Billing_Street_1__c, Billing_City__c,
                Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :oerList[0].Id LIMIT 1];             
           testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                        RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                        Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                        Use_Account_Shipping_Address__c,Installation_Type__c,Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                        WHERE Order_Entry_Release__c = :testRel.Id];
        
            System.assertEquals(testRel.status__c,'Draft');
            System.assertEquals(testOEL[0].status__c,'Draft'); 
            
             
               
            
            testRel.Status__c='Integration Requested';
            testRel.Trigger_Source__c = 'UI';
            update testRel;
      
        System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
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
                    WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.assertEquals(testRel.status__c,'Integration Requested');
        System.assertEquals(testOEL[0].status__c,'Integration Requested');
        
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
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id];              
        
        
        for(Order_Entry_Line__c oel:testOEL){
            oel.Integration_Status__c='Complete';
            oel.Trigger_Source__c='Integration';
            oel.Quantity__c=7;
        }
        update testOEL;
          System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());  
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id ];
                     
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
                    
            
            
        
            System.assertEquals(testOEL[0].status__c,'Planned'); 
            System.assertEquals(testRel.status__c,'Planned');
            
           /* testRel.Trigger_Source__c = 'Integration';
            testRel.Integration_Status__c = 'Complete';
            update testRel;*/
                
           // testRel.Status__c='HOLD';
        
            testRel.Status__c='Confirmation Requested';
            testRel.Trigger_Source__c = 'UI';
            update testRel;

       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
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
                        RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c,Quote_Line_Item__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                        Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                        Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                        WHERE Order_Entry_Release__c = :testRel.Id];
                        
            System.assertEquals(testRel.status__c,'Confirmation Requested');
            System.assertEquals(testOEL[0].status__c,'Confirmation Requested');    
            system.debug('quote=='+ testOEL[0].CPQ_Quote_Line__c + testOEL[0].Quote_Line_Item__c);
            testOEL[0].CPQ_Quote_Line__c = null;
            testOEL[0].Quote_Line_Item__c = oetd.quoteLineMap.get(oetd.quoteList[0].Id)[0].id;
            
        // testOEL[0].Status__c = 'Change Confirmation Requested';
            update testOEL[0];
            system.debug('quote=='+ testOEL[0].CPQ_Quote_Line__c + testOEL[0].Quote_Line_Item__c);
        /*   // testOEL[0].Status__c = 'Hold';
          //update testOEL[0];
            testRel.Status__c='Confirmed';
            testRel.Trigger_Source__c = 'UI';
         try{
             update testRel;
         } catch(DmlException e) {
             
         }

               
            
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
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
                    
       // System.assertEquals(testRel.status__c,'Confirmation Requested');
       // System.assertEquals(testOEL[0].status__c,'Confirmed');
        
        testRel.Status__c='Approval to Ship Requested';
         try{
             update testRel;
         } catch(DmlException e) {
             
         }

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
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
                    
        System.assertEquals(testRel.status__c,'Approval to Ship Requested');
        System.assertEquals(testOEL[0].status__c,'Approval to Ship Requested');
        
        for(Order_Entry_Line__c oel:testOEL){
            oel.Integration_Status__c='Complete';
            oel.Trigger_Source__c='Integration';
            oel.Sales_Order_Line_Status__c='Awaiting Shipment';
        }
       
        //testOEL.Status__c = 'Approval to Ship Requested';
        //testOEL.Sales_Order_Line_Status__c='Awaiting Shipment';
       
          try{
             update testOEL;
         } catch(DmlException e) {
             
         }
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.assertEquals(testRel.status__c,'Approved-to-Ship');
        System.assertEquals(testOEL[0].status__c,'Approved-to-Ship');  */
       
        for(Order_Entry_Line__c oel:testOEL){
            if(oel.Quantity__c>0){          
                oel.Quantity_Shipped__c = oel.Quantity__c-2;
                oel.Trigger_Source__c = 'Integration';
            }
        }
        try {

                update testOEL;
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
        }
         Test.stopTest();  
System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
       // Order_Entry_Line_BU_AU.fakeMethod();
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c,Quantity_Shipped__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id ];
        
        System.assertEquals(testRel.status__c,'Partially Shipped');
        System.assertEquals(testOEL[0].status__c,'Partially Shipped');
        //covering validation
        integer i=0;
        for(Order_Entry_Line__c oel:testOEL){
            if(oel.Quantity__c>0){          
                if(i==0)
                oel.Quantity__c = oel.Quantity__c+5;
                if(i==1 && oel.Quantity_Shipped__c > 1)
                oel.Quantity__c = oel.Quantity_Shipped__c-1;
                i++;
                oel.Trigger_Source__c = 'UI';
                oel.Scheduled_Ship_Date__c = system.today().addDays(3);
            }
        }
         boolean isError=false;
         try{
            update testOEL;
         }
         catch(exception e)
         {
            isError=true;
         }
         system.assert(isError);
         for(Order_Entry_Line__c oel:testOEL){
            if(oel.Quantity__c>0){          
                oel.Quantity_Shipped__c = oel.Quantity__c;
                oel.Trigger_Source__c = 'Integration';
            }
        }
        try{
        update testOEL;
        }
        catch(exception e)
        {
        }          
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
              
    }

    
}