@isTest
Public class ProjectPhase_File_UploaderTest{   
    
 
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
        p.Phase_Description__c= 'Test';
        p.Project_Phase_Plan__c = pplan.Id;
        //p.Opportunity__c= testOpportunityObj.Id;
        phase.add(p);
        insert phase;
           
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(phase);
        ApexPages.CurrentPage().getParameters().put('id',pplan.Id);
        ProjectPhase_File_Uploader pf = new ProjectPhase_File_Uploader(sc);

        pf.ReadFile();
    }
    
    Static testMethod void testmethod2(){   
        
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
        pplan.Opportunity__c= testMOUOpportunityObj.Id;
        insert pplan;
        
        List<Project_Phase__c> phase = new List<Project_Phase__c>();  
        Project_Phase__c p = new Project_Phase__c();
        p.Phase_Description__c= 'Test';
        p.Project_Phase_Plan__c = pplan.Id;
        //p.Opportunity__c= testOpportunityObj.Id;
        phase.add(p);
        insert phase;
        
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(phase);
        ApexPages.CurrentPage().getParameters().put('id',pplan.Id);
        ProjectPhase_File_Uploader pf = new ProjectPhase_File_Uploader(sc);
        
        pf.nameFile = '';
        pf.ReadFile();      
    }
    
    Static testMethod void testmethod3(){   
       
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
        pplan.Opportunity__c= testMOUOpportunityObj.Id;
        insert pplan;
        
        List<Project_Phase__c> phase = new List<Project_Phase__c>();  
        Project_Phase__c p = new Project_Phase__c();
        p.Phase_Description__c= 'Test';
        p.Project_Phase_Plan__c = pplan.Id;
        //p.Opportunity__c= testOpportunityObj.Id;
        phase.add(p);
        insert phase;
           
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(phase);
        ApexPages.CurrentPage().getParameters().put('id',pplan.Id);
        ProjectPhase_File_Uploader pf = new ProjectPhase_File_Uploader(sc);
        
        
        PageReference pageRef = Page.ProjectPhase_File_Uploader; // VF page Name
        Test.setCurrentPage(pageRef);
       // pageRef.getParameters().put('id', phase[0].Id);
        ApexPages.CurrentPage().getParameters().put('id', pplan.Id);
        
        String body = '11,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP2.1 \n';
               body += '15,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '20,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
        //pf.nameFile = 'Unit Test Attachment';
        pf.contentFile = Blob.valueOf(body);
        try{
        pf.ReadFile();     
        }catch(Exception ex){}
    }
    
    Static testMethod void testmethod4(){   
       
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
        pplan.Opportunity__c= testMOUOpportunityObj.Id;
        insert pplan;
        
        List<Project_Phase__c> phase = new List<Project_Phase__c>();  
        Project_Phase__c p = new Project_Phase__c();
        p.Phase_Description__c= 'Test';
        p.Project_Phase_Plan__c = pplan.Id;
        //p.Opportunity__c= testOpportunityObj.Id;
        phase.add(p);
        insert phase;
           
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(phase);
        ApexPages.CurrentPage().getParameters().put('id',pplan.Id);
        ProjectPhase_File_Uploader pf = new ProjectPhase_File_Uploader(sc);
        
        
        PageReference pageRef = Page.ProjectPhase_File_Uploader; // VF page Name
        Test.setCurrentPage(pageRef);
       // pageRef.getParameters().put('id', phase[0].Id);
        ApexPages.CurrentPage().getParameters().put('id', pplan.Id);
        
        String body = '1,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP2.1 \n';
               body += '2,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
               body += '3,Glazier,12/12/2017,Glazier Methodist IGU East Faade CP3.1 \n' ;
        //pf.nameFile = 'Unit Test Attachment';
        pf.contentFile = Blob.valueOf(body);
        try{
        pf.ReadFile();     
        }catch(Exception ex){}
    }
}