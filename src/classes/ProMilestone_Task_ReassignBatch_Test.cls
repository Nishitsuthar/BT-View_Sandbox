@isTest
public class ProMilestone_Task_ReassignBatch_Test {

	@testSetup static void setUpData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias ='st', Email='Projectmanager34@gmail.com',LastName='Testing1',ProfileId = p.Id,UserName='Projectmanager34@gmail.com',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8', 
                          LanguageLocaleKey = 'en_US');
        Insert u;
        User u2 = new User(Alias = 'Ad', Email='customsucess@gmail.com',LastName='Testing',ProfileId = p.Id,UserName='customsucess@gmail.com',
                           TimeZoneSidKey = 'America/Los_Angeles',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US');
        Insert u2;
        
         User InsertenpUser = new User(Alias = 'enp', Email='enp@gmail.com',firstName = 'JD', LastName='Admin',ProfileId = p.Id,UserName='enpteam@gmail.com',
                           TimeZoneSidKey = 'America/Los_Angeles',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US');
        Insert InsertenpUser;
        
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
        }
           
    }
    @isTest static void testpmmilestoneBatch(){
        User enpUser = [select id, Name, Email from user where Email = 'enp@gmail.com' limit 1];
        opportunity opp = [select Id,Project_Manager__c,CSM_Project_Manager__c from Opportunity limit 1];
        
        List<Project_Milestones__c> ProjectMilestonesList = new List<Project_Milestones__c>();
        
        Project_Milestones__c pM_Rec = new Project_Milestones__c();
        pM_Rec.Assigned_To_email__c = enpUser.Email;
        pM_Rec.Comments__c = 'sedrfyguhijok';
        pM_Rec.Deadline__c = date.today();
        pM_Rec.Duration__c = '2';
        pM_Rec.End_Date__c = Date.today();
        pM_Rec.External_ID__c = '8765432';
        pM_Rec.Is_Active__c = True;
        pM_Rec.Opportunity__c = opp.Id;
        pM_Rec.OwnerId = enpUser.Id;
        
        ProjectMilestonesList.add(pM_Rec);
        
        
        Project_Milestones__c pM_Rec1 = new Project_Milestones__c();
        pM_Rec1.Assigned_To_email__c = enpUser.Email;
        pM_Rec1.Comments__c = 'sedrfyguhijok';
        pM_Rec1.Deadline__c = date.today();
        pM_Rec1.Duration__c = '2';
        pM_Rec1.End_Date__c = Date.today();
        pM_Rec1.External_ID__c = '8765';
        pM_Rec1.Is_Active__c = True;
        pM_Rec1.Opportunity__c = opp.Id;
        pM_Rec1.OwnerId = enpUser.Id;
        ProjectMilestonesList.add(pM_Rec1);
        
        Insert ProjectMilestonesList;
       
    
            Project_Tasks__c projectTask = new Project_Tasks__c();
            projectTask.Assigned_To_Email__c = enpUser.Email ;
            projectTask.Comments__c= 'fcgvhbjn';
            projectTask.Deadline__c= date.today();
            projectTask.Duration__c = '3';
            projectTask.End_Date__c =date.today();
            projectTask.External_ID__c='234567';
            projectTask.Is_Active__c= pM_Rec.Is_Active__c;
            projectTask.Project_Milestones__c= pM_Rec.Id;
            projectTask.Task_Name__c ='TestProject Task';
            projectTask.Percent_Complete__c = 1;
        	projectTask.OwnerId = enpUser.Id;
           Insert projectTask;
		
       
        Test.startTest();
       
        ProMileStone_Task_ReassignBatch pm_Batch = new ProMileStone_Task_ReassignBatch();
        Database.executeBatch(pm_Batch);
    	
        ProTask_OwnerRessignBatch pm_Task_Batch = new ProTask_OwnerRessignBatch();
        Database.executeBatch(pm_Task_Batch);
        Test.stopTest();
    }
       
    @isTest static void testwithoutEmailrecords(){
        User enpUser = [select id, Name, Email from user where Email = 'enp@gmail.com' limit 1];
        opportunity opp = [select Id,Project_Manager__c,CSM_Project_Manager__c from Opportunity limit 1];
        
        List<Project_Milestones__c> ProjectMilestonesList = new List<Project_Milestones__c>();
        
        Project_Milestones__c pM_RecwithoutEmail = new Project_Milestones__c();
       // pM_RecwithoutEmail.Assigned_To_email__c = enpUser.Email;
        pM_RecwithoutEmail.Comments__c = 'sedrfyguhijok';
        pM_RecwithoutEmail.Deadline__c = date.today();
        pM_RecwithoutEmail.Duration__c = '2';
        pM_RecwithoutEmail.End_Date__c = Date.today();
        pM_RecwithoutEmail.External_ID__c = '12345';
        pM_RecwithoutEmail.Is_Active__c = True;
        pM_RecwithoutEmail.Opportunity__c = opp.Id;
        pM_RecwithoutEmail.Functional_Responsibility__c = 'PM';
        pM_RecwithoutEmail.OwnerId = enpUser.Id;
        
        ProjectMilestonesList.add(pM_RecwithoutEmail);
        
        
        Project_Milestones__c pM_RecwithoutEmail2 = new Project_Milestones__c();
        //pM_RecwithoutEmail2.Assigned_To_email__c = enpUser.Email;
        pM_RecwithoutEmail2.Comments__c = 'sedrfyguhijok';
        pM_RecwithoutEmail2.Deadline__c = date.today();
        pM_RecwithoutEmail2.Duration__c = '2';
        pM_RecwithoutEmail2.End_Date__c = Date.today();
        pM_RecwithoutEmail2.External_ID__c = '55444';
        pM_RecwithoutEmail2.Is_Active__c = True;
        pM_RecwithoutEmail2.Opportunity__c = opp.Id;
        pM_RecwithoutEmail2.Functional_Responsibility__c = 'CSM';
        pM_RecwithoutEmail2.OwnerId = enpUser.Id;
        ProjectMilestonesList.add(pM_RecwithoutEmail2);
        
        Project_Milestones__c pM_RecwithoutEmail3 = new Project_Milestones__c();
        //pM_RecwithoutEmail2.Assigned_To_email__c = enpUser.Email;
        pM_RecwithoutEmail3.Comments__c = 'sedrfyguhijok';
        pM_RecwithoutEmail3.Deadline__c = date.today();
        pM_RecwithoutEmail3.Duration__c = '2';
        pM_RecwithoutEmail3.End_Date__c = Date.today();
        pM_RecwithoutEmail3.External_ID__c = '9889';
        pM_RecwithoutEmail3.Is_Active__c = True;
        pM_RecwithoutEmail3.Opportunity__c = opp.Id;
        pM_RecwithoutEmail3.Functional_Responsibility__c = 'Customer Support';
        pM_RecwithoutEmail3.OwnerId = enpUser.Id;
        ProjectMilestonesList.add(pM_RecwithoutEmail3);
        
         Project_Milestones__c pM_RecwithoutEmail4 = new Project_Milestones__c();
        //pM_RecwithoutEmail2.Assigned_To_email__c = enpUser.Email;
        pM_RecwithoutEmail4.Comments__c = 'sedrfyguhijok';
        pM_RecwithoutEmail4.Deadline__c = date.today();
        pM_RecwithoutEmail4.Duration__c = '2';
        pM_RecwithoutEmail4.End_Date__c = Date.today();
        pM_RecwithoutEmail4.External_ID__c = '998877';
        pM_RecwithoutEmail4.Is_Active__c = True;
        pM_RecwithoutEmail4.Opportunity__c = opp.Id;
        //pM_RecwithoutEmail4.Functional_Responsibility__c = 'CSM';
        pM_RecwithoutEmail4.OwnerId = enpUser.Id;
        ProjectMilestonesList.add(pM_RecwithoutEmail4);
        
        Insert ProjectMilestonesList;
       
    List<Project_Tasks__c> ProtaskList = new List<Project_Tasks__c>();
            Project_Tasks__c projectTask = new Project_Tasks__c();
            //projectTask.Assigned_To_Email__c = enpUser.Email ;
            projectTask.Comments__c= 'fcgvhbjn';
            projectTask.Deadline__c= date.today();
            projectTask.Duration__c = '3';
            projectTask.End_Date__c =date.today();
            projectTask.External_ID__c='778866';
            projectTask.Is_Active__c= ProjectMilestonesList[0].Is_Active__c;
            projectTask.Project_Milestones__c= ProjectMilestonesList[0].Id;
            projectTask.Task_Name__c ='TestProject Task';
            projectTask.Percent_Complete__c = 1;
        	projectTask.Functional_Responsibility__c = 'PM';
        	projectTask.OwnerId = enpUser.Id;
           proTaskList.add(projectTask);
        
         Project_Tasks__c projectTask2 = new Project_Tasks__c();
            //projectTask2.Assigned_To_Email__c = enpUser.Email ;
            projectTask2.Comments__c= 'fcgvhbjn';
            projectTask2.Deadline__c= date.today();
            projectTask2.Duration__c = '3';
            projectTask2.End_Date__c =date.today();
            projectTask2.External_ID__c='654322';
            projectTask2.Is_Active__c= ProjectMilestonesList[0].Is_Active__c;
            projectTask2.Project_Milestones__c= ProjectMilestonesList[0].Id;
            projectTask2.Task_Name__c ='TestProject Task';
            projectTask2.Percent_Complete__c = 1;
        	projectTask2.Functional_Responsibility__c = 'CSM';
        	projectTask2.OwnerId = enpUser.Id;
           proTaskList.add(projectTask2);
        
         Project_Tasks__c projectTask3 = new Project_Tasks__c();
            //projectTask3.Assigned_To_Email__c = enpUser.Email ;
            projectTask3.Comments__c= 'fcgvhbjn';
            projectTask3.Deadline__c= date.today();
            projectTask3.Duration__c = '3';
            projectTask3.End_Date__c =date.today();
            projectTask3.External_ID__c='49876';
            projectTask3.Is_Active__c= ProjectMilestonesList[0].Is_Active__c;
            projectTask3.Project_Milestones__c= ProjectMilestonesList[0].Id;
            projectTask3.Task_Name__c ='TestProject Task';
            projectTask3.Percent_Complete__c = 1;
        	projectTask3.Functional_Responsibility__c = 'Customer Support';
        	projectTask3.OwnerId = enpUser.Id;
           proTaskList.add(projectTask3);
        
         Project_Tasks__c projectTask4 = new Project_Tasks__c();
            //projectTask.Assigned_To_Email__c = enpUser.Email ;
            projectTask4.Comments__c= 'fcgvhbjn';
            projectTask4.Deadline__c= date.today();
            projectTask4.Duration__c = '3';
            projectTask4.End_Date__c =date.today();
            projectTask4.External_ID__c='559933';
            projectTask4.Is_Active__c= ProjectMilestonesList[0].Is_Active__c;
            projectTask4.Project_Milestones__c= ProjectMilestonesList[0].Id;
            projectTask4.Task_Name__c ='TestProject Task';
            projectTask4.Percent_Complete__c = 1;
        	projectTask4.OwnerId = enpUser.Id;
           
        proTaskList.add(projectTask4);
		Insert proTaskList;
          
		
        Test.startTest();
       
        ProMileStone_Task_ReassignBatch pm_Batch = new ProMileStone_Task_ReassignBatch();
        Database.executeBatch(pm_Batch);
    	
        ProTask_OwnerRessignBatch pm_Task_Batch = new ProTask_OwnerRessignBatch();
        Database.executeBatch(pm_Task_Batch);
        Test.stopTest();
    }
    
    
}