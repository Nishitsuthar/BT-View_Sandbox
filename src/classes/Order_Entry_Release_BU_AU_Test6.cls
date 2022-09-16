@isTest
public class Order_Entry_Release_BU_AU_Test6
{
    // v.2 - Changes for CPQ Quote object
    //
    // Test Functionality after inception
    //
    
    static testMethod void testMethodEight()
    {
 
         Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 2,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        

                      System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
        
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Software);
        
                     System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Software);
                    System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
         
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        Order_Entry_Line__c testOEL;
        Boolean passedTest;
        
        testRel = oerList[0];
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
          
        testRel.Status__c='Draft';
        testRel .Customer_P_O_Number__c = null;
       // testRel.Shipping_Account__c=acc.id;
       // testRel.Billing_Account__c=acc.id;
       // testRel.Sold_to_Account__c=acc.id;
        update testRel;
                      System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
        
                         Customer_Purchase_Order__c CPO = new Customer_Purchase_Order__c(Name__c = 'Name__c756',Opportunity__c=testRel.Opportunity__c);
            database.insert(CPO);
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Promised_Date__c , Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c,Customer_P_O_Number__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        /*
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1]; */
        
        testRel.Status__c='Integration Requested';
        testRel.Scheduled_Ship_Date__c=System.today();
        testRel.Request_Date__c=System.today();
        testRel.Promised_Date__c =System.today();
        testRel .Trigger_Source__c='UI';
        update testRel;    
        
                      System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
     /*   testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
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
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        update testOEL;        
                        System.debug(' CPU Time ' +Limits.getCpuTime());
                         System.debug(' SOQL Query ' +Limits.getQueries());*/
  
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, Customer_P_O_Number__c,
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1]; 
      
        
            try {   
                    testRel .Customer_P_O_Number__c = CPO.Id;
                     update testRel;                                                                                                 
                  }
                    catch(DmlException ex)
                     { }
        
                 
            
                         System.debug(' CPU Time ' +Limits.getCpuTime());
                         System.debug(' SOQL Query ' +Limits.getQueries());
             
      Test.stopTest();
    }

  static testMethod void testMethod_CHWFullTest()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 2};
            
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
                OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
                   // Test.startTest();
                List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
            //Test.stopTest();
            Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
            System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
              Test.startTest();
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
            List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
            Order_Entry_Release__c testRel;
            list<Order_Entry_Line__c> testOEL;
            Boolean passedTest; 
          account acc = new account();
                   acc.name = 'View Inc';
         acc.BillingStreet ='1482 Cliveden Ave.' ;
         acc.BillingCity ='Delta' ;
         acc.BillingState = 'British Columbia';
         acc.BillingPostalCode ='V3M 6K2' ;
        acc.BillingCountry = 'Canada';
        acc.Oracle_Customer_Number__c   ='3591';
        insert acc;
         
         
         
            testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c,
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
            Billing_Account__c, Freight__c,Payment_Terms__c,Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
                    Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
                Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
            Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
            Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
            Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
            Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
        Test.stopTest();
                          try
                            {   
                                test.isRunningTest();
                                
                                 testRel.Billing_Account__c= acc.Id;
                                 testRel.Sold_to_Account__c= acc.Id; 
                                  testRel.Billing_Street_1__c = 'testsssssstreet ';
                                   testRel.Shipping_Street_1__c = 'testsssssstreet';
                                       testRel.Sold_To_Street_1__c = 'testsssssstreet';
                                 testRel.Freight__c = 'Non-Billable';
                                 testRel.Payment_Terms__c = 'IMMEDIATE';
                                 testRel.Trigger_Source__c = 'UI';
                                  update testRel;
                                    
                                                                     
                            }
                                catch(DmlException ex)
                                { }

         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());         
             
    } 
static testMethod void testMethod_CHWFullTest1a()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 2};
            
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
                OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
                   
                List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
                    System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
            //Test.stopTest();
            Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
            System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
               Test.startTest();
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
            List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
            Order_Entry_Release__c testRel;
            list<Order_Entry_Line__c> testOEL;
            Boolean passedTest; 
          account acc = new account();
                   acc.name = 'View Inc';
         acc.BillingStreet ='1482 Cliveden Ave.' ;
         acc.BillingCity ='Delta' ;
         acc.BillingState = 'British Columbia';
         acc.BillingPostalCode ='V3M 6K2' ;
        acc.BillingCountry = 'Canada';
        acc.Oracle_Customer_Number__c   ='3591';
        insert acc;
         
         
         
            testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c,
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
            Billing_Account__c, Freight__c,Payment_Terms__c,Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
                    Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
                Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
            Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
            Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
            Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
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
                oel.Quantity_Shipped__c = oel.Quantity__c;
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
            Billing_Account__c,Freight__c,Payment_Terms__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c,Sales_Order_Status__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c,Quantity_Shipped__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id ];
        
        System.assertEquals(testRel.status__c,'Shipped');
        System.assertEquals(testOEL[0].status__c,'Shipped');
   Test.stopTest();  
                          try
                            {   
                                test.isRunningTest();
                                
                                 testRel.Billing_Account__c= acc.Id;
                                 testRel.Sold_to_Account__c= acc.Id; 
                                  testRel.Billing_Street_1__c = 'testsssssstreet ';
                                   testRel.Shipping_Street_1__c = 'testsssssstreet';
                                       testRel.Sold_To_Street_1__c = 'testsssssstreet';
                                 testRel.Freight__c = 'Non-Billable';
                                 testRel.Payment_Terms__c = 'IMMEDIATE';
                                 testRel.Trigger_Source__c = 'UI';
                                  update testRel;
                                    
                                                                     
                            }
                                catch(DmlException ex)
                                { }

         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());         
              
    } 

  }