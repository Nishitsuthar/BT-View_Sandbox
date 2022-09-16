@isTest(seeAllData=false)
global class SmartSheetUtil_Test {
    @TestSetup static void setupData() {
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
        
        Id CaseRecTypId = [select id from RecordType where name='Product Issue'].id;
        
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
                          Priority = 'P3');
        Insert c;
        
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
    }
    
    @isTest static void testOpportunityResponse() {
        Map<String,String> httpMap = New Map<String,String>();
        httpMap.put('StringParam1', 'StringParam1');
        httpMap.put('StringParam2','StringParam2');
        
        
        HttpClient clientHttp = New HttpClient('https://login.salesforce.com/apex/SmartsheetDemoPage');
        clientHttp.buildEntityBody(httpMap);
        clientHttp.buildUri('https://login.salesforce.com/apex/SmartsheetDemoPage');
        
        SmartSheetUtil.validationContext = 'OpportunityTesting';
        
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        
        long sheetId =long.valueOf('8366092692285316');
        Test.startTest();
        SmartSheetUtil.syncSmartSheetWithOpp(sheetId);
        
        SmartSheetUtil.validationContext = 'Sample_Test_RemovingStardDate';
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        SmartSheetUtil.syncSmartSheetWithOpp(sheetId);
        Test.stopTest(); 
        
        
    }
    
    @isTest static void testCaseResponse() {
        List<ID> ProjectMilestonesIds = new List<ID>();
        List<Project_Milestones__c> ProjectMilestonesList = [SELECT Id,Name,Opportunity__c,Percent_Complete__c,Start_Date__c,Assigned_To_email__c FROM Project_Milestones__c];
        system.debug('ListofProject milestones'+ProjectMilestonesList );
        for(Project_Milestones__c pms :ProjectMilestonesList ){
            ProjectMilestonesIds.add(pms.ID);
            pms.Percent_Complete__c = 0.45;
        }
        update ProjectMilestonesList;
        
    
        long sheetId =long.valueOf('767597613475716');
        
        SmartSheetUtil.validationContext = 'CaseTesting';
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        
        Test.startTest();
        SmartSheetUtil.syncSmartSheetWithOpp(sheetId);
        SmartSheetUtil.syncProjectTasksAsync(ProjectMilestonesIds);
        Test.stopTest(); 
        
    }
    @isTest static void testOppFailResponce() {
       
        SmartSheetUtil.logSmartsheetException('Error Message', long.valueOf('3456789098'), 'mileStone_TaskName', long.valueOf('8765334'), long.valueOf('9876543'));
        
        SmartSheetUtil.validationContext = 'Sample_Test_EmailOppResponse';
        
        long sheetId =long.valueOf('8366092692285316');
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        
        Test.startTest();
        SmartSheetUtil.syncSmartSheetWithOpp(sheetId);
        Test.stopTest(); 
        
        
    }
    
    
    @isTest static void testCaseFailResponse() {
        List<SmartSheet.Column> ListSmartsheetcolumn = new List<SmartSheet.Column>();
        List<SmartSheet.Row> listSmartSheetRows = new List<SmartSheet.Row>();
        list<SmartSheet.Cell> listsmartSHeetCells = new List<SmartSheet.cell>();
        
        Smartsheet.Column smartcolumns = new Smartsheet.Column();
        smartcolumns.id = 23456;
        smartcolumns.index = 2;
        smartcolumns.title = 'Opportunity ID';
        smartcolumns.type = 'testType';
        smartcolumns.symbol = 'testsymbol';
        smartcolumns.options = new list<string>{'testoption1'};
            smartcolumns.primary = true;
        ListSmartsheetcolumn.add(smartcolumns);
        smartcolumns.getId();
        smartcolumns.getIndex();
        smartcolumns.getPrimary();
        smartcolumns.getTitle();
        smartcolumns.getType();
        smartcolumns.setTitle('Opportunity ID');
        smartcolumns.setType('testType');
        
        SmartSheet.Cell smartSheetCell = new SmartSheet.Cell();
        smartSheetCell.type = 'Sample Type';
        smartSheetCell.value = 'sample id';
        smartSheetCell.displayValue = 'Sample Displayvalue';
        smartSheetCell.columnId = 23456;
        smartSheetCell.rowId = 7654332;
        smartSheetCell.link = 'sampleLink';
        smartSheetCell.strict = false;
        listsmartSHeetCells.add(smartSheetCell);
        
        smartSheetCell.getColumnId();
        smartSheetCell.getDisplayValue();
        smartSheetCell.getRowId();
        smartSheetCell.getStrict();
        smartSheetCell.getType();
        smartSheetCell.getValue();
        smartSheetCell.setColumnId(23456);
        smartSheetCell.setRowId(7654332);
        smartSheetCell.setStrict(false);
        smartSheetCell.setType('Sample Type');
        smartSheetCell.setValue( 'sample id');
        
        Smartsheet.Row smartSheetRow = new Smartsheet.Row();
        smartSheetRow.id = 7654332;
        smartSheetRow.sheetId = 2345675;
        smartSheetRow.rowNumber = 85268990;
        smartSheetRow.siblingId = 37919754;
        smartSheetRow.parentId = 7654332;
        smartSheetRow.expanded = true;
        smartSheetRow.version = 2;
        smartSheetRow.cells = listsmartSHeetCells;
        smartSheetRow.createdAt = 'sample createdat';
        smartSheetRow.modifiedAt = 'sample modifiedat';
        listSmartSheetRows.add(smartSheetRow);
        
        smartSheetRow.getId();
        smartSheetRow.getRowNumber();
        smartSheetRow.getSheetId();
        smartSheetRow.getVersion();
        smartSheetRow.setCells(listsmartSHeetCells);
        smartSheetRow.setId(85268990);
        smartSheetRow.setRowNumber(85268990);
        smartSheetRow.setSheetId(2345675);
        
        
        SmartSheet.Source smartsheetSource = new SmartSheet.Source();
        smartsheetSource.id = 456789;
        smartsheetSource.type = 'sample Type';
        
        
        Smartsheet.sheet sheetvariable = new smartsheet.sheet();
        
        sheetvariable.getId();
        sheetvariable.getcolumns();
        sheetvariable.getName();
        sheetvariable.getRows();
        sheetvariable.setColumns(ListSmartsheetcolumn);
        sheetvariable.getAccessLevel();
        sheetvariable.setId(2345675);
        sheetvariable.setName('testname');
        sheetvariable.setRows(listSmartSheetRows);
        
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Sample_Test_CaseFailResponse');
        mock.setHeader('Content-Type', 'application/json');
        mock.setStatusCode(200);
        mock.setStatus('Success');
        
        long sheetId =long.valueOf('767597613475716');
        
        SmartSheetUtil.validationContext = 'CaseFailTesting';
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        
        Test.startTest();
        SmartSheetUtil.syncSmartSheetWithOpp(sheetId);
        Test.stopTest(); 
        
    }
    
    
    @isTest static void testBatchClass(){
        
        Test.startTest();
        SmartSheetSyncBatch  Batch = new SmartSheetSyncBatch();
        DataBase.executeBatch(Batch, 1);
        Test.stopTest();
    }
    
    @isTest static void testschedule() {
        
        SmartSheetSyncJob sh1 = new SmartSheetSyncJob();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Check', sch, sh1); 
        
    }
    
    @isTest Static Void testProj_Service_Miles_Task_triggers(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
        
        System.runAs(dealDeskUser) {
            User u = new User(Alias ='st', Email='standarduserfd@gmail.com',LastName='Testing1',ProfileId = p.Id,UserName='standarduser78@gmail.com',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8', 
                          LanguageLocaleKey = 'en_US');
        Insert u;
        User u2 = new User(Alias = 'Ad', Email='adminUsergmi@gmail.com',LastName='Testing',ProfileId = p.Id,UserName='adminUser87@gmail.com',
                           TimeZoneSidKey = 'America/Los_Angeles',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US');
        Insert u2;
        
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
        
        //TestProjectManagerMilestoneTrigger
        
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
        
        ProjectMilestonesList.add(pM_Rec);
        
        Project_Milestones__c pM_Rec1 = new Project_Milestones__c();
        pM_Rec1.Assigned_To_email__c = 'testEmail@gmail.com';
        pM_Rec1.Comments__c = 'sedrfyguhijok';
        pM_Rec1.Deadline__c = date.today();
        pM_Rec1.Duration__c = '2';
        pM_Rec1.End_Date__c = Date.today();
        pM_Rec1.External_ID__c = '8765';
        pM_Rec1.Is_Active__c = True;
        pM_Rec1.Opportunity__c = opp.Id;
        ProjectMilestonesList.add(pM_Rec1);
        
        Insert ProjectMilestonesList;
        
        
        //List<Project_Tasks__c> projectTasksList = new List<Project_Tasks__c>();
        
        //for(Project_Milestones__c  Pm_Recs : ProjectMilestonesList){
        Project_Tasks__c projectTask = new Project_Tasks__c();
        projectTask.Assigned_To_Email__c = ProjectMilestonesList[0].Assigned_To_email__c;
        projectTask.Comments__c= 'fcgvhbjn';
        projectTask.Deadline__c= date.today();
        projectTask.Duration__c = '3';
        projectTask.End_Date__c =date.today();
        projectTask.External_ID__c='234567';
        projectTask.Is_Active__c=ProjectMilestonesList[0].Is_Active__c;
        projectTask.Project_Milestones__c=ProjectMilestonesList[0].Id;
        projectTask.Task_Name__c ='TestProject Task';
        projectTask.Percent_Complete__c = 1;
        //projectTasksList.add(projectTask);
        
        
        //}
        // Insert projectTasksList;
        
        List<Project_Tasks__c> listprojecttasks = [select id,Assigned_To_email__c,Is_Active__c,Old_Milestone_Id__c,Project_Milestones__c from Project_Tasks__c];
        for(Project_Tasks__c projectTasks : listprojecttasks){
            projectTasks.Is_Active__c = false;
            projectTasks.Assigned_To_Email__c = 'sample@gmail.com';
            projectTasks.Old_Milestone_Id__c = projectTasks.Project_Milestones__c;
            projectTasks.Project_Milestones__c = null;
            
        }
        update listprojecttasks;
        
        //TestServiceTaskTrigger
        
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
        
        /*List<Service_Project_Tasks__c> ListServiceTask = [select id,Assigned_To_email__c,Is_Active__c,Milestone_Reference_Id__c,Service_Project_Milestones__c from Service_Project_Tasks__c];
        for(Service_Project_Tasks__c SerTaskRec : ListServiceTask){
            SerTaskRec.Is_Active__c = false;
            SerTaskRec.Assigned_To_Email__c = 'sample@gmail.com';
            SerTaskRec.Milestone_Reference_Id__c = SerTaskRec.Service_Project_Milestones__c;
            SerTaskRec.Service_Project_Milestones__c = null;
            
        }
        update ListServiceTask;*/
        
        }
   
    }
    @isTest static void testSyncSmartSheets(){
        DateTime testingDate = system.now();
        String Modifiedsince = String.valueOf(2);
        Integer pageNumber = 1;
        
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());      
        Test.startTest();
        SmartSheetUtil.syncSmartSheets(testingDate);
        Test.stopTest();
    }
    
}