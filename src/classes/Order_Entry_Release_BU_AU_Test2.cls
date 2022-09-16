@isTest
public class Order_Entry_Release_BU_AU_Test2
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
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
                      System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Software);
        
                     System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
        
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
       // testRel.Shipping_Account__c=acc.id;
       // testRel.Billing_Account__c=acc.id;
       // testRel.Sold_to_Account__c=acc.id;
        update testRel;
                      System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Promised_Date__c , Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
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
        update testRel;    
        
                      System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
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
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        update testOEL;        
                        System.debug(' CPU Time ' +Limits.getCpuTime());
                         System.debug(' SOQL Query ' +Limits.getQueries());
  
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
        /*
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1]; */
                             
           // testRel.Status__c='Planned';
            testRel .Integration_Status__c='Complete';
            testRel .Trigger_Source__c='Integration';
            update testRel;     
            
                         System.debug(' CPU Time ' +Limits.getCpuTime());
                         System.debug(' SOQL Query ' +Limits.getQueries());
             
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, Sales_Order_Status__c,
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1]; 
        /*
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1]; */
                             
            testRel.Status__c='Planned';
            testRel .Sales_Order_Status__c='Booked';
            testRel .Trigger_Source__c='Integration';
            update testRel;    
            
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, Sales_Order_Status__c,
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];  
        /*
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1]; */
            
            testRel.Status__c='Booked';                 
            testRel .Sales_Order_Status__c='Closed';
            testRel .Trigger_Source__c='Integration';
            update testRel;    

                      System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, Sales_Order_Status__c,
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1]; 
        /*
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1]; */
                             
            testRel .Sales_Order_Status__c='Cancelled';
            testRel .Trigger_Source__c='Integration';
            update testRel; 
          
                      System.debug(' CPU Time ' +Limits.getCpuTime());
                      System.debug(' SOQL Query ' +Limits.getQueries());
    }

     
     static testMethod void testMethodNine()
    {
 
         Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 2,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
                System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
                      
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
        Test.startTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Software);
        System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
        
        
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Software);
        System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        Order_Entry_Line__c testOEL;
        Boolean passedTest;
        Account acc = new Account(name='SFO International Airport');
     // 
     //  Account acc = [select id,name from Account where name='SFO International Airport'];  
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
       // testRel.Shipping_Account__c=acc.id;
       // testRel.Billing_Account__c=acc.id;
        testRel.Sold_to_Account__c=acc.id;
        update testRel;
        System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
     //  
     Account acc2 = new Account(name='1 Hotels');     
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Promised_Date__c , Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
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
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        testRel.Scheduled_Ship_Date__c=System.today();
        testRel.Request_Date__c=System.today();
        testRel.Promised_Date__c =System.today();
        
        testRel.Sold_To_Street_1__c= '1140 Avenue of the Americas 5th Floor';
        testRel.Sold_To_Postal_Code__c= '10036';
        testRel.Sold_To_State_Province__c= 'NY';
        testRel.Sold_to_Country__c= 'UNITED STATES';
        testRel.Sold_to_Account__c=acc2.id;
        testRel.Trigger_Source__c = null;
        update testRel;    
        System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
       
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
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        update testOEL;        
      System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
      
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
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
                             
           // testRel.Status__c='Planned';
            testRel .Integration_Status__c='Complete';
            testRel .Trigger_Source__c='Integration';
            update testRel;     
           System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries()); 
            
               //
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, Sales_Order_Status__c,
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];  
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
                             
            testRel.Status__c='Planned';
            testRel .Sales_Order_Status__c='Booked';
            testRel .Trigger_Source__c=null;
            update testRel;    
            System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
          
        //
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, Sales_Order_Status__c,
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];  
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
            
            testRel.Status__c='Booked';                 
            testRel .Sales_Order_Status__c='Closed';
            testRel .Trigger_Source__c=null;
            update testRel;  
        System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
        Test.stopTest();

    }

        static testMethod void testMethodTen()
     {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 2,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();
         System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
          Test.stopTest();
         System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
         System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
       
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        Order_Entry_Line__c testOEL;
        Boolean passedTest;
        Account acc = new Account(name='SFO International Airport');
     //   
        testRel = oerList[0];
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c, CurrencyISOCOde,             
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
        testRel.Sold_to_Account__c=acc.id;
        update testRel;
     System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
     // 
     Account acc2 = new Account(name='1 Hotels');      
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,CurrencyISOCOde,              
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
      //   testRel.Scheduled_Ship_Date__c=system.today();
      //  testRel.Request_Date__c=null;
      //  testRel.Promised_Date__c=null;
      //    testRel.Trigger_Source__c=null;
        testRel.Sold_to_Account__c=acc2.id;
        update testRel;   
         System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
       
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
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        update testOEL;        
      System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
      
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,CurrencyISOCOde,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,Promised_Date__c,
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
        
        testRel.Status__c='Confirmation Requested';
       // testRel.Promised_Date__c=System.today();
            update testRel;
            System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
       //
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Promised_Date__c,First_Promised_Date__c,
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
        
        testRel.Status__c='Confirmed';
       // testReL.Trigger_Source__c=null;
       // testRel.Promised_Date__c=System.today()+7;
       // testRel.First_Promised_Date__c=null;
        update testRel;   
          System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());  
       //
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,Promised_Date__c,
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
        
        testRel.Status__c='Approval to Ship Requested';
            update testRel;               
        System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
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
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        update testOEL;
       System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
            testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,Promised_Date__c,
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
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
            
        testRel.Sales_Order_Status__c = 'Booked';
        testRel.Status__c='Approval to Ship Requested';
        testReL.Trigger_Source__c=null;
        update testRel; 
       System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
       
        //testRel.Status__c='Approved-to-Ship';   
     
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
            
        testRel.Sales_Order_Status__c = 'Booked';
        testRel.Status__c='Approval to Ship Requested';
        testReL.Trigger_Source__c='Integration';
        update testRel;
         System.debug(' CPU Time ' +Limits.getCpuTime() + ' SOQL Query ' +Limits.getQueries());
    }
     
     static testMethod void testMethodEleven()
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
  }