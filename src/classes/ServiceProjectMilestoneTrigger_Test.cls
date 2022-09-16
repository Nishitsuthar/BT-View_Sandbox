@isTest
public class ServiceProjectMilestoneTrigger_Test {
    @testSetup static void setup() {
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias ='st', Email='standuser' + String.valueOf(DateTime.now().getTime()) + '@gmail.com',LastName='Testing1',ProfileId = p.Id,UserName= 'standuser' + String.valueOf(DateTime.now().getTime()) + '@gmail.com',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8', 
                          LanguageLocaleKey = 'en_US');
        Insert u;
        User u2 = new User(Alias = 'Ad', Email='admin2' +  + String.valueOf(DateTime.now().getTime()) + '@gmail.com',LastName='Testing',ProfileId = p.Id,UserName='admin2' + 'standuser' + String.valueOf(DateTime.now().getTime()) + '@gmail.com',
                           TimeZoneSidKey = 'America/Los_Angeles',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US');
        Insert u2;
        
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
                           Smartsheet_Comments_Col_Index__c = '22233');
        Insert c; 
        
       
        
    }
    @isTest Static Void testAssignToEmail(){
        List<User> u = [select Id, Email from User];
        Case c = [Select Id from Case Limit 1];
        List<Service_Project_Milestones__c> ServiceProjectMilList = new List<Service_Project_Milestones__c>();
        Service_Project_Milestones__c sP_M_Rec = new Service_Project_Milestones__c();
        sP_M_Rec.Assigned_To_email__c = u[0].Email;
        sP_M_Rec.Comments__c = 'test Case Comment';
        sP_M_Rec.Deadline__c = date.today();
        sP_M_Rec.Duration__c = '2d';
        sP_M_Rec.End_Date__c = Date.today();
        sP_M_Rec.External_ID__c = '87654323';
        sP_M_Rec.Is_Active__c = True;
        sP_M_Rec.Case__c = c.Id;
        
        Insert sP_M_Rec;
         
       // List<Service_Project_Tasks__c> serviceTasksList = new List<Service_Project_Tasks__c>();
        
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
        Insert ServiceTaskRec;
       // serviceTasksList.add(ServiceTaskRec);
        
        //Insert ServiceTaskRec;
        
        sP_M_Rec.Assigned_To_Email__c = u[1].Email;
        update sP_M_Rec;
        ServiceTaskRec.Assigned_To_Email__c = sP_M_Rec.Assigned_To_Email__c;
        update ServiceTaskRec;
        
        
        Delete sP_M_Rec;
    }
}