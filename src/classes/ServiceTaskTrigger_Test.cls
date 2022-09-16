@isTest
Private class ServiceTaskTrigger_Test {
    @isTest Static Void testServiceTaskTrigger(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias ='st', Email='standarduser1233@gmail.com',LastName='Testing1',ProfileId = p.Id,UserName='standarduser1212@gmail.com',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8', 
                          LanguageLocaleKey = 'en_US');
        Insert u;
        User u2 = new User(Alias = 'Ad', Email='adminUser56@gmail.com',LastName='Testing',ProfileId = p.Id,UserName='adminUser66@gmail.com',
                           TimeZoneSidKey = 'America/Los_Angeles',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US');
        Insert u2;
        
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
                           Priority = 'P3');
        Insert c; 
        
         List<Service_Project_Milestones__c> ServiceProjectMilList = new List<Service_Project_Milestones__c>();
        Service_Project_Milestones__c sP_M_Rec = new Service_Project_Milestones__c();
        sP_M_Rec.Assigned_To_email__c = u.Email;
        sP_M_Rec.Comments__c = 'test Case Comment';
        sP_M_Rec.Deadline__c = date.today();
        sP_M_Rec.Duration__c = '2';
        sP_M_Rec.End_Date__c = Date.today();
        sP_M_Rec.External_ID__c = '87654323';
        sP_M_Rec.Is_Active__c = True;
        sP_M_Rec.Case__c = c.Id;
        
        ServiceProjectMilList.add(sP_M_Rec);
        
        Service_Project_Milestones__c sP_M_Rec1 = new Service_Project_Milestones__c();
        sP_M_Rec1.Assigned_To_email__c = 'testcaseEmail@gmail.com';
        sP_M_Rec1.Comments__c = 'test Case2 Comment';
        sP_M_Rec1.Deadline__c = date.today();
        sP_M_Rec1.Duration__c = '2';
        sP_M_Rec1.End_Date__c = Date.today();
        sP_M_Rec1.External_ID__c = '765432';
        sP_M_Rec1.Is_Active__c = True;
        sP_M_Rec1.Case__c = c.Id;
        ServiceProjectMilList.add(sP_M_Rec1);
        
        Insert ServiceProjectMilList;
        
        
        List<Service_Project_Tasks__c> serviceTasksList = new List<Service_Project_Tasks__c>();
        
        //for(Service_Project_Milestones__c  ServiceTask_Recs : ServiceProjectMilList){
            
            Service_Project_Tasks__c ServiceTaskRec = new Service_Project_Tasks__c();
            
            ServiceTaskRec.Assigned_To_Email__c = ServiceProjectMilList[0].Assigned_To_email__c;
            ServiceTaskRec.Comments__c= 'Test Case Comment';
            ServiceTaskRec.Deadline__c= date.today();
            ServiceTaskRec.Duration__c = '3';
            ServiceTaskRec.End_Date__c =date.today();
            ServiceTaskRec.External_ID__c='234567';
            ServiceTaskRec.Is_Active__c=ServiceProjectMilList[0].Is_Active__c;
            ServiceTaskRec.Service_Project_Milestones__c=ServiceProjectMilList[0].Id;
            ServiceTaskRec.Task_Name__c ='Test Service task';
            ServiceTaskRec.Percent_Complete__c = 1;
            serviceTasksList.add(ServiceTaskRec);
        //}
        Insert serviceTasksList;
        
        List<Service_Project_Tasks__c> ListServiceTask = [select id,Assigned_To_email__c,Is_Active__c,Milestone_Reference_Id__c,Service_Project_Milestones__c from Service_Project_Tasks__c];
        for(Service_Project_Tasks__c SerTaskRec : ListServiceTask){
            SerTaskRec.Is_Active__c = false;
            SerTaskRec.Assigned_To_Email__c = 'sample@gmail.com';
            SerTaskRec.Milestone_Reference_Id__c = SerTaskRec.Service_Project_Milestones__c;
            SerTaskRec.Service_Project_Milestones__c = null;
            
        }
       // update ListServiceTask;

    }        
}
}