@isTest
Public class ProjectPhaseBU_AUTest{   
    
 
 Static testMethod void testmethod1(){
     
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
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
         
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Opportunity testOpportunityObj = new Opportunity();
        testOpportunityObj.Name = 'testOppty';
        testOpportunityObj.CloseDate = Date.today();
        testOpportunityObj.StageName = 'POC Stage';
        testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
        testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
        testOpportunityObj.Winning_Total_of_IGUs__c = 2;
        testOpportunityObj.AccountId = testAccount.Id;
        testOpportunityObj.IGU_Total_Amount__c = 10;
        testOpportunityObj.BOS_Total_Amount__c = 10;
        testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
        testOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testOpportunityObj.OwnerId = UserInfo.getUserId();
        insert testOpportunityObj;
        
        Project_Phase_Plan__c pplan = new Project_Phase_Plan__c();
        pplan.Status__c='New';
        pplan.Opportunity__c = testMOUOpportunityObj.Id;
        insert pplan;
        
        List<Project_Phase__c> phase = new List<Project_Phase__c>();  
        Project_Phase__c p = new Project_Phase__c();
        p.Project_Phase_Plan__c = pplan.Id;
        p.Customer_reference_Id__c = '12345';
        p.Phase_Description__c = 'testtt';
        p.Approx_Phase_Date__c = system.today();
        p.Trade__c = 'Glazier';
        p.Project_Phase__c = 5;
        
        
        insert p;
        system.assert(p.Id != null);
        system.debug('@@pid'+p.Id);
        
        //Create OEL and OER's
       Test.startTest();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Order_Entry_Line__c testOEL;
        Order_Entry_Release__c testOER = oetd.oerList[0];
        
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        testOEL = [SELECT Id,Order_Entry_Release__c,Customer_Reference_Description__c,Reference_ID__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testOER.Id LIMIT 1];
        testOEL.Reference_ID__c='12345';
         testOEL.Customer_Reference_Description__c ='testtt';
        update testOEL;
        //insert junc
        Phase_Order_Line__c pho = new Phase_Order_Line__c();
       
        pho.Project_Phase__c = p.Id;
        pho.Order_Entry_Line__c = testOEL.Id;
        insert pho;
         
       p.Phase_Description__c = 'test222';
        p.Reason_of_Change__c = 'Added trade';
        p.Source_of_Change__c = 'Internal - SD';
        
        update p;
        
        Project_Phase__c p1 = new Project_Phase__c();
       
        p1.Project_Phase_Plan__c = pplan.Id;
        p1.Customer_reference_Id__c = '124567';
        p1.Phase_Description__c = 'test222';
        p1.Approx_Phase_Date__c = system.today();
        p1.Trade__c = 'Glazier';
        p1.Project_Phase__c = 5;
        //p.Opportunity__c= testOpportunityObj.Id;
        try{
        insert p1;
        }
        Catch(exception e)
        {
        }
        p1.Phase_Description__c = 'test333';
        insert p1;
        Map<Id, Order_Entry_Line__c> newOELMap = new Map<Id, Order_Entry_Line__c>();
        newOELMap.put(testOEL.Id,testOEL);
        OrderEntryLineTriggerHandler.processProjectPhase(newOELMap);
        try{
            p1.Phase_Description__c = 'hello';
            update p1;
        }
        Catch(exception e)
        {
        }
    }
}