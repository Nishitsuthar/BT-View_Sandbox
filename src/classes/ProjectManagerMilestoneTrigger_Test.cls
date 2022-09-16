@isTest
Private class ProjectManagerMilestoneTrigger_Test {
    
    @isTest Static Void insertMilestones(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias ='st', Email='standarduser122@gmail.com',LastName='Testing1',ProfileId = p.Id,UserName='standarduser121@gmail.com',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8', 
                          LanguageLocaleKey = 'en_US');
        Insert u;
        User u2 = new User(Alias = 'Ad', Email='adminUser222@gmail.com',LastName='Testing',ProfileId = p.Id,UserName='adminUser522@gmail.com',
                           TimeZoneSidKey = 'America/Los_Angeles',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US');
        Insert u2;
        
         User enpUser = new User(Alias = 'enp', Email='enp@gmail.com',firstName = 'ENP', LastName='Team',ProfileId = p.Id,UserName='enpteam@gmail.com',
                           TimeZoneSidKey = 'America/Los_Angeles',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US');
        Insert enpUser;
        
        System.runAs(u)
        {
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
        opp.Project_Manager__c = u2.id;
        opp.CSM_Project_Manager__c = u.Id;
        Insert opp;      
        
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
        
        insert pM_Rec;
        //ProjectMilestonesList.add(pM_Rec);
        User enpuserRec = [select Name,Email,Id from User where id=:enpUser.Id Limit 1];
        Project_Milestones__c pM_Rec1 = new Project_Milestones__c();
        //pM_Rec1.Assigned_To_email__c = enpuserRec.Email;
        pM_Rec1.Comments__c = 'sedrfyguhijok';
        pM_Rec1.Deadline__c = date.today();
        pM_Rec1.Duration__c = '2';
        pM_Rec1.End_Date__c = Date.today();
        pM_Rec1.External_ID__c = '8765';
        pM_Rec1.Is_Active__c = True;
        pM_Rec1.Opportunity__c = opp.Id;
        //pM_Rec1.OwnerId = enpuserRec.Id;
         ProjectMilestonesList.add(pM_Rec1);
        
        Insert ProjectMilestonesList;
       
      
            Project_Tasks__c projectTask = new Project_Tasks__c();
            projectTask.Assigned_To_Email__c = pM_Rec.Assigned_To_email__c;
            projectTask.Comments__c= 'fcgvhbjn';
            projectTask.Deadline__c= date.today();
            projectTask.Duration__c = '3';
            projectTask.End_Date__c =date.today();
            projectTask.External_ID__c='234567';
            projectTask.Is_Active__c= pM_Rec.Is_Active__c;
            projectTask.Project_Milestones__c= pM_Rec.Id;
            projectTask.Task_Name__c ='TestProject Task';
            projectTask.Percent_Complete__c = 1;
           Insert projectTask;
        
        Test.startTest();
       
        List<Project_Milestones__c> updateAssignedTo = [Select Id,Assigned_To_email__c, Name from Project_Milestones__c where  Assigned_To_email__c != Null ];
        for(Project_Milestones__c milestones :updateAssignedTo){
            milestones.Assigned_To_email__c = u2.Email;
        }
        update updateAssignedTo;
        
       
        
        projectTask.Is_Active__c = false;
        projectTask.Assigned_To_Email__c = 'SampleEmail@gmail.com';
        projectTask.Old_Milestone_Id__c = projectTask.Project_Milestones__c;
        projectTask.Project_Milestones__c = null;
        projectTask.Percent_Complete__c = 1;
        update projectTask;
        
      
        PageReference pageRef = Page.Project_Task_Update;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(projectTask);
        ProjectTaskEditCtrl testAccPlan = new ProjectTaskEditCtrl(sc);
        testAccPlan.saveProjectTask();	
        
        Project_Tasks__c projectTasktodelete = new Project_Tasks__c();
            projectTasktodelete.Assigned_To_Email__c = pM_Rec.Assigned_To_email__c;
            projectTasktodelete.Comments__c= 'sample comment';
            projectTasktodelete.Deadline__c= date.today();
            projectTasktodelete.Duration__c = '3';
            projectTasktodelete.End_Date__c =date.today();
            projectTasktodelete.External_ID__c='23456733';
            projectTasktodelete.Is_Active__c= pM_Rec.Is_Active__c;
            projectTasktodelete.Project_Milestones__c= pM_Rec.Id;
            projectTasktodelete.Task_Name__c ='Project Task Testing';
            projectTasktodelete.Percent_Complete__c = 3;
           Insert projectTasktodelete;
        List<Project_Milestones__c> deletemilestone = [Select Id, Name from Project_Milestones__c ];
        //system.debug('milestonerec'+deletemilestone);
      	delete deletemilestone;
        Test.stopTest();  
        }
        
    }
    
}