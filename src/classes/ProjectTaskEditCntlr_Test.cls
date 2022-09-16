@isTest
Private class ProjectTaskEditCntlr_Test{
    
    @isTest Static Void testProjecttaskEditCntlr(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias ='st', Email='standarduser412@gmail.com',LastName='Testing1',ProfileId = p.Id,UserName='standarduser142@gmail.com',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8', 
                          LanguageLocaleKey = 'en_US');
        Insert u;
        User u2 = new User(Alias = 'Ad', Email='adminUser226@gmail.com',LastName='Testing',ProfileId = p.Id,UserName='adminUser252@gmail.com',
                           TimeZoneSidKey = 'America/Los_Angeles',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US');
        Insert u2;
		System.runAs(u)
        {
          Smartsheet_Config__c settings = new Smartsheet_Config__c();
        
        settings.Name = 'Test Smart Sheet Settings';
        settings.Access_Token__c= 't100ees07y527ta8a1n5xy48we';
        settings.API_Base_URL__c ='https://api.smartsheet.com';
        settings.API_Version__c = '2.0';
        settings.Authorize_URL__c = 'https://www.smartsheet.com/b/authorize';
        settings.Redirect_URL__c = 'https://login.salesforce.com/apex/SmartsheetDemoPage';
        settings.Scope__c= 'READ_SHEETS,WRITE_SHEETS,CREATE_SHEETS';
        settings.Sync_Job_Time_Interval__c = 5;
        
        Insert settings;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.Id;
        opp.Book_Date__c = date.today();
        opp.closeDate = Date.today();
        opp.StageName = 'Discovery';
        opp.Smartsheet_Id__c ='8366092692285316' ;
        opp.SmartSheet_Url__c = 'https://api.smartsheet.com/sheets/8366092692285316' ;
        opp.Smartsheet_percent_complete_col_Index__c = '123456';
        opp.Smartsheet_Comments_Col_Index__c = '87654';
        Insert opp;  

        opp = [SELECT Id, Smartsheet_percent_complete_col_Index__c FROM Opportunity WHERE Id = :opp.Id];   
        
        List<Project_Milestones__c> ProjectMilestonesList = new List<Project_Milestones__c>();
        Project_Milestones__c pM_Rec = new Project_Milestones__c();
        pM_Rec.Assigned_To_email__c = u.Email;
        pM_Rec.Comments__c = 'sedrfyguhijok';
        pM_Rec.Deadline__c = date.today();
        pM_Rec.Duration__c = '2';
        pM_Rec.End_Date__c = Date.today();
        pM_Rec.External_ID__c = '8765432';
        pM_Rec.Is_Active__c = True;
        pM_Rec.Opportunity__c = opp.Id;
        
        Insert pM_Rec;
        
        
        Project_Tasks__c projectTask = new Project_Tasks__c();
        projectTask.Assigned_To_Email__c = pM_Rec.Assigned_To_email__c;
        projectTask.Comments__c= 'fcgvhbjn';
        projectTask.Deadline__c= date.today();
        projectTask.Duration__c = '3';
        projectTask.End_Date__c =date.today();
        projectTask.External_ID__c='234567';
        projectTask.Is_Active__c=pM_Rec.Is_Active__c;
        projectTask.Project_Milestones__c=pM_Rec.Id;
        projectTask.Task_Name__c ='TestProject Task';
        projectTask.Percent_Complete__c = 1;
        Insert projectTask;

        PageReference pageRef = Page.Project_Task_Update;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(projectTask);
        ProjectTaskEditCtrl testAccPlan = new ProjectTaskEditCtrl(sc);
        testAccPlan.prjTask.Percent_Complete__c = 10;
        testAccPlan.prjTask.Comments__c = 'sample testing';
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        Test.startTest();
        testAccPlan.saveProjectTask();  
        Test.stopTest();  
        }
        
    }
    
}