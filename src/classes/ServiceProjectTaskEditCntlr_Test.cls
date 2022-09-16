@isTest
public class ServiceProjectTaskEditCntlr_Test {
    @testSetup static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias ='st', Email='standarduser32@gmail.com',LastName='Testing1',ProfileId = p.Id,UserName='standarduserv12@gmail.com',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8', 
                          LanguageLocaleKey = 'en_US');
        Insert u;
        User u2 = new User(Alias = 'Ad', Email='adminUserr22@gmail.com',LastName='Testing',ProfileId = p.Id,UserName='adminUser822@gmail.com',
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
            Insert opp;      
            
            Id CaseRecTypId = [select id from RecordType where name='Support Case'].id;
            
            Contact con = new Contact(LastName ='test', AccountId = acc.Id );
            insert con;
            
            Case c =  New Case(RecordTypeId=CaseRecTypId,
                               Opportunity__c=opp.Id,
                               Subject='test',
                               Contact = con,
                               Status ='New', 
                               
                               Est_Cmpl_Date__c= Date.today().addDays(5), 
                               Description = 'Test', 
                               Origin= 'Email',
                               Smartsheet_Id__c = '767597613475716',
                               Smartsheet_percent_complete_col_Index__c = '3456789',
                               Smartsheet_End_Date_Col_Index__c = '23546',
                               Smartsheet_Start_Date_Col_Index__c = '35364',
                               Smartsheet_Duration_Col_Index__c = '24325',
                               Smartsheet_Comments_Col_Index__c = '22233',
                               Priority = 'P3');
            Insert c; 
            
            List<Service_Project_Milestones__c> ServiceProjectMilList = new List<Service_Project_Milestones__c>();
            Service_Project_Milestones__c sP_M_Rec = new Service_Project_Milestones__c();
            sP_M_Rec.Assigned_To_email__c = u.Email;
            sP_M_Rec.Comments__c = 'test Case Comment';
            sP_M_Rec.Deadline__c = date.today();
            sP_M_Rec.Duration__c = '2d';
            sP_M_Rec.End_Date__c = Date.today();
            sP_M_Rec.External_ID__c = '87654323';
            sP_M_Rec.Is_Active__c = True;
            sP_M_Rec.Case__c = c.Id;
            
            Insert sP_M_Rec;
            
        }
        
    }
    @isTest Static Void testServiceTaskEditCntlr(){
        Service_Project_Milestones__c sP_M_Rec = [select Assigned_To_email__c, Id, Is_Active__c from Service_Project_Milestones__c Limit 1 ];
        
        
        List<Service_Project_Tasks__c> serviceTasksList = new List<Service_Project_Tasks__c>();
        
        //for(Service_Project_Milestones__c  ServiceTask_Recs : ServiceProjectMilList){
        
        Service_Project_Tasks__c ServiceTaskRec = new Service_Project_Tasks__c();
        
        ServiceTaskRec.Assigned_To_Email__c = sP_M_Rec.Assigned_To_email__c;
        ServiceTaskRec.Comments__c= 'Test Case Comment';
        ServiceTaskRec.Deadline__c= date.today();
        ServiceTaskRec.Duration__c = '3d';
        ServiceTaskRec.End_Date__c =date.today();
        ServiceTaskRec.External_ID__c='234567';
        ServiceTaskRec.Is_Active__c=sP_M_Rec.Is_Active__c;
        ServiceTaskRec.Service_Project_Milestones__c=sP_M_Rec.Id;
        ServiceTaskRec.Task_Name__c ='Test Service task';
        ServiceTaskRec.Percent_Complete__c = 1;
        serviceTasksList.add(ServiceTaskRec);
        //}
        Insert ServiceTaskRec;
        
        
        
        PageReference pageRef = Page.Service_Project_Task_Update;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(ServiceTaskRec);
        ServiceProjectTaskEditCtrl testAccPlan = new ServiceProjectTaskEditCtrl(sc);
        testAccPlan.sPTask.Percent_Complete__c = 1;
        testAccPlan.sPTask.Start_Date__c = date.today();
        //testAccPlan.sPTask.End_Date__c = date.today();
        testAccPlan.sPTask.Duration__c = '3d';
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        Test.startTest();
        testAccPlan.saveServiceProjectTask();  
        Test.stopTest();
        
    }
    
    @isTest Static Void testServiceTaskEditCntlr2(){
        Service_Project_Milestones__c sP_M_Rec = [select Assigned_To_email__c, Id, Is_Active__c from Service_Project_Milestones__c Limit 1 ];
        List<Service_Project_Tasks__c> serviceTasksList = new List<Service_Project_Tasks__c>();
        
        Service_Project_Tasks__c ServiceTaskRec = new Service_Project_Tasks__c();
        
        ServiceTaskRec.Assigned_To_Email__c = sP_M_Rec.Assigned_To_email__c;
        ServiceTaskRec.Comments__c= 'Test Case Comment';
        ServiceTaskRec.Deadline__c= date.today();
        ServiceTaskRec.Duration__c = '3';
        ServiceTaskRec.End_Date__c =date.today();
        ServiceTaskRec.External_ID__c='234567';
        ServiceTaskRec.Is_Active__c=sP_M_Rec.Is_Active__c;
        ServiceTaskRec.Service_Project_Milestones__c=sP_M_Rec.Id;
        ServiceTaskRec.Task_Name__c ='Test Service task';
        ServiceTaskRec.Percent_Complete__c = 1;
        serviceTasksList.add(ServiceTaskRec);
        //}
        Insert ServiceTaskRec;
        
        
        PageReference pageRef = Page.Service_Project_Task_Update;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(ServiceTaskRec);
        ServiceProjectTaskEditCtrl testAccPlan = new ServiceProjectTaskEditCtrl(sc);
        testAccPlan.sPTask.Percent_Complete__c = 0.54;
        testAccPlan.sPTask.Start_Date__c = date.today().addDays(4);
        //testAccPlan.sPTask.End_Date__c = date.today().addDays(3);
        testAccPlan.sPTask.Duration__c = '5d';
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        Test.startTest();
        testAccPlan.saveServiceProjectTask();  
        Test.stopTest();
        
    }
    @isTest Static Void testFailureCase(){
        Service_Project_Milestones__c sP_M_Rec = [select Assigned_To_email__c, Id, Is_Active__c from Service_Project_Milestones__c Limit 1 ];
        List<Service_Project_Tasks__c> serviceTasksList = new List<Service_Project_Tasks__c>();
        
        Service_Project_Tasks__c ServiceTaskRec = new Service_Project_Tasks__c();
        
        ServiceTaskRec.Assigned_To_Email__c = sP_M_Rec.Assigned_To_email__c;
        ServiceTaskRec.Comments__c= 'Test Case Comment';
        ServiceTaskRec.Deadline__c= date.today();
        ServiceTaskRec.Duration__c = '3';
        ServiceTaskRec.End_Date__c =date.today();
        ServiceTaskRec.External_ID__c='234567';
        ServiceTaskRec.Is_Active__c=sP_M_Rec.Is_Active__c;
        ServiceTaskRec.Service_Project_Milestones__c=sP_M_Rec.Id;
        ServiceTaskRec.Task_Name__c ='Test Service task';
        ServiceTaskRec.Percent_Complete__c = 1;
        serviceTasksList.add(ServiceTaskRec);
        //}
        Insert ServiceTaskRec;
        
        
        PageReference pageRef = Page.Service_Project_Task_Update;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(ServiceTaskRec);
        ServiceProjectTaskEditCtrl testAccPlan = new ServiceProjectTaskEditCtrl(sc);
        /*testAccPlan.sPTask.Percent_Complete__c = 0.54;
testAccPlan.sPTask.Start_Date__c = date.today().addDays(4);
//testAccPlan.sPTask.End_Date__c = date.today().addDays(3);
testAccPlan.sPTask.Duration__c = '5d';*/
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        Test.startTest();
        testAccPlan.saveServiceProjectTask();  
        Test.stopTest();
        
    }
    @isTest Static Void updateDurationTest(){
        Service_Project_Milestones__c sP_M_Rec = [select Assigned_To_email__c, Id, Is_Active__c from Service_Project_Milestones__c Limit 1 ];
        List<Service_Project_Tasks__c> serviceTasksList = new List<Service_Project_Tasks__c>();
        
        Service_Project_Tasks__c ServiceTaskRec = new Service_Project_Tasks__c();
        
        ServiceTaskRec.Assigned_To_Email__c = sP_M_Rec.Assigned_To_email__c;
        ServiceTaskRec.Comments__c= 'Test Case Comment';
        ServiceTaskRec.Deadline__c= date.today();
        ServiceTaskRec.Duration__c = '3';
        ServiceTaskRec.End_Date__c =date.today();
        ServiceTaskRec.External_ID__c='234567';
        ServiceTaskRec.Is_Active__c=sP_M_Rec.Is_Active__c;
        ServiceTaskRec.Service_Project_Milestones__c=sP_M_Rec.Id;
        ServiceTaskRec.Task_Name__c ='Test Service task';
        ServiceTaskRec.Percent_Complete__c = 1;
        serviceTasksList.add(ServiceTaskRec);
        //}
        Insert ServiceTaskRec;
        
        
        PageReference pageRef = Page.Service_Project_Task_Update;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(ServiceTaskRec);
        ServiceProjectTaskEditCtrl testAccPlan = new ServiceProjectTaskEditCtrl(sc);
        //testAccPlan.sPTask.Percent_Complete__c = 0.54;
        //testAccPlan.sPTask.Start_Date__c = date.today().addDays(4);
        //testAccPlan.sPTask.End_Date__c = date.today().addDays(3);
        testAccPlan.sPTask.Duration__c = '7d';
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        Test.startTest();
        testAccPlan.saveServiceProjectTask();  
        Test.stopTest();
        
    }
}