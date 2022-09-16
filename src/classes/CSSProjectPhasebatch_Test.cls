@istest
public class CSSProjectPhasebatch_Test{
    Static testMethod void testmethod1(){
       
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@view.com';
        insert testContact;
        
        
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
        
        
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;   
        
        
        Project_Phase_Plan__c pplan = new Project_Phase_Plan__c();
        pplan.Status__c='New';
        pplan.Opportunity__c = testMOUOpportunityObj.Id;
        insert pplan;
        List<Project_Phase__c> phase = new List<Project_Phase__c>();  
        Project_Phase__c p = new Project_Phase__c();
        p.Phase_Description__c= 'Test';
        p.Project_Phase_Plan__c = pplan.Id;
        p.Trade__c='LVE';
        p.Project_Phase__c=5;
        p.Customer_reference_Id__c = 'abcd';
        
        phase.add(p);
        insert phase;
        
        //Create OEL and OER's
        List<Order_Entry_Line__c> listOEL = new List<Order_Entry_Line__c>();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
        Test.startTest();
            Map<String,Order_Entry_Line__c> oelProcessMap = new Map<String,Order_Entry_Line__c>();        
            OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
            List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
            Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        Test.stopTest();
        for(Order_Entry_Line__c obj : oelMap.values()[0]){          
            obj.Reference_ID__c = 'abcd';
            listOEL.add(obj);
        }
        //update listOEL;*/
        for(Order_Entry_Line__c obj : listOEL){
            oelProcessMap.put('abcd',obj);         
        }
        CSSProjectPhasebatch ppBatch = new CSSProjectPhasebatch (oelProcessMap);
        //Status = 'Submitted';
        //ppBatch.opptyList = 'SELECT id,Customer_reference_Id__c,Status__c,Order_Entry_Release__c FROM Project_Phase__c where Customer_reference_Id__c !=null';
        Database.executebatch(ppBatch);        
    }
    Static testMethod void testmethod2(){
       
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@view.com';
        insert testContact;
        
        
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
        
        
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;   
        
        
        Project_Phase_Plan__c pplan = new Project_Phase_Plan__c();
        pplan.Status__c='New';
        pplan.Opportunity__c = testMOUOpportunityObj.Id;
        insert pplan;
        List<Project_Phase__c> phase = new List<Project_Phase__c>();  
        Project_Phase__c p = new Project_Phase__c();
        p.Phase_Description__c= 'Test';
        p.Project_Phase_Plan__c = pplan.Id;
        p.Trade__c='LVE';
        p.Project_Phase__c=5;
        p.Customer_reference_Id__c = 'abcd';
        
        phase.add(p);
        insert phase;
        
        //Create OEL and OER's
        List<Order_Entry_Line__c> listOEL = new List<Order_Entry_Line__c>();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
        Test.startTest();
            Map<String,Order_Entry_Line__c> oelProcessMap = new Map<String,Order_Entry_Line__c>();        
            OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
            List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
            Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        Test.stopTest();
        for(Order_Entry_Line__c obj : oelMap.values()[0]){          
            obj.Reference_ID__c = 'abcd';
            listOEL.add(obj);
        }
        update listOEL;
        for(Order_Entry_Line__c obj : listOEL){
            oelProcessMap.put('abcd',obj);         
        }
        CSS_Project_Phase_Schedule testsche = new CSS_Project_Phase_Schedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );        
    }
    Static testMethod void testmethod3(){
       
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@view.com';
        insert testContact;
        
        
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
        
        
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;   
        
        
        Project_Phase_Plan__c pplan = new Project_Phase_Plan__c();
        pplan.Status__c='New';
        pplan.Opportunity__c = testMOUOpportunityObj.Id;
        insert pplan;
        List<Project_Phase__c> phase = new List<Project_Phase__c>();  
        Project_Phase__c p = new Project_Phase__c();
        p.Phase_Description__c= 'Test';
        p.Project_Phase_Plan__c = pplan.Id;
        p.Trade__c='LVE';
        p.Project_Phase__c=5;
        p.Customer_reference_Id__c = 'abcd';
        
        phase.add(p);
        insert phase;
        
        //Create OEL and OER's
        List<Order_Entry_Line__c> listOEL = new List<Order_Entry_Line__c>();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
        Test.startTest();
            Map<String,Order_Entry_Line__c> oelProcessMap = new Map<String,Order_Entry_Line__c>();        
            OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
            List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
            Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 2,Label.CSS_Hardware);
        Test.stopTest();
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        Order_Entry_Line__c testOEL;   
        for(Order_Entry_Line__c obj : oelMap.values()[0]){          
            obj.Reference_ID__c = 'abcd';
            listOEL.add(obj);
        }
        update listOEL; 
        
        testRel = oerList[0];
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
        //testRel.Sold_to_Account__c=acc2.id;
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
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c,First_Scheduled_Ship_Date__c,
                     First_Request_Ship_Date__c,First_Promised_Date__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        update testOEL; 
        
            
        for(Order_Entry_Line__c obj : listOEL){
            oelProcessMap.put('abcd',obj);         
        }
        CSS_Project_Phase_Schedule testsche = new CSS_Project_Phase_Schedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );        
    }

}