@isTest
private class TestCreateSubCaseController{
   
   //this method covers the class CreateSubCaseController
   static testMethod void unitTest1(){
      
      SalesSupportDirector__c ssd = new SalesSupportDirector__c(Name = 'Chicago1', User_Name__c = 'Mike Lane');
      Insert ssd;
       
      Account testAcc = new Account(Name = 'Test Acc');
      insert testAcc;
      
      Contact testCon = new Contact(LastName = 'Acontact', FirstName = 'Test', AccountId = testAcc.Id);
      insert testCon;
      
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
       User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
      
      Opportunity testOpp = new Opportunity();
    /*   Opportunity testOpp = new Opportunity(Name = 'Test Pre-Oppty', StageName = 'Pre-Qualifying-Open',Prequal_Oppty_Status__c = 'Open - New', CloseDate = system.today() + 5, 
                                             AccountId = testAcc.Id, Support_Region__c = 'Chicago', Target_SE__c = u.Id, 
                                             Project_City__c = 'Test City', Construction_Type__c = 'Renovation', Project_Building_Size__c = '< 10K',
                                             Approx_glass_quantity__c = 10.0, Project_Stage__c = 'On Hold', 
                                             Project_Glass_Installation_Timing__c = '< 3 Months', Market_Segment__c = 'Education', LeadSource = 'Inbound Call');
       insert testOpp; */
       
       Case testCase = new Case(Subject = 'Test', ContactId = testCon.Id, Status = 'New', Est_Cmpl_Date__c = system.today(),
                                Description = 'This is a test.',Priority = 'P3', AccountId = testAcc.Id, Opportunity__c = testOpp.Id);
       insert testCase;
           
      ApexPages.StandardController controller = new ApexPages.StandardController (testCase);
      CreateSubCaseController ctrl = new  CreateSubCaseController(controller);
      
      ctrl.getTypeList();
      ctrl.selectedId = '012E0000000seQ0';
      ctrl.onSelectRecType();
      
      CreateSubCaseController ctrl2 = new  CreateSubCaseController(controller);
      
      ctrl2.getTypeList();
      ctrl2.selectedId = '0120L0000009730';
      ctrl2.onSelectRecType();
      
      CreateSubCaseController ctrl3 = new  CreateSubCaseController(controller);
      
      ctrl3.getTypeList();
      ctrl3.selectedId = '012E0000000oR5Z';
      ctrl3.onSelectRecType();
   }
   
   //this method covers the before insert scenario of the CaseTrigger
   static testMethod void unitTest2(){
      Case testCase1 = new Case(Subject = 'Test', Status = 'New', Est_Cmpl_Date__c = system.today(),
                                Description = 'This is a test',Priority = 'P3', RecordTypeId = '0120L0000009730');
      insert testCase1;
      
      Case testCase2 = new Case(Subject = 'Test2', Status = 'New', Est_Cmpl_Date__c = system.today(),
                                Description = 'This is a test',Priority = 'P3', RecordTypeId = '012E0000000seQ0');
      insert testCase2;
      
      Case testCase3 = new Case(Subject = 'Test2', Status = 'New', Est_Cmpl_Date__c = system.today(),
                                Description = 'This is a test',Priority = 'P3', RecordTypeId = '012E0000000oR5Z');
      insert testCase3;
   }
   static testMethod void TestCase(){ 
 List<SalesSupportDirector__c> abc = new List<SalesSupportDirector__c>();
    abc.add(new SalesSupportDirector__c(Name = 'Atlanta/Carolinas',User_Name__c = 'Brian Horton'));
    abc.add(new SalesSupportDirector__c(Name = 'Bay Area',User_Name__c = 'Namrata Vora'));
    abc.add(new SalesSupportDirector__c(Name = 'Chicago',User_Name__c = 'Mike Lane'));
    abc.add(new SalesSupportDirector__c(Name = 'Dallas',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'New York',User_Name__c = 'Brian Klansky'));
    abc.add(new SalesSupportDirector__c(Name = 'Hawaii',User_Name__c = 'Lance Murata'));
    abc.add(new SalesSupportDirector__c(Name = 'Houston',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'International',User_Name__c = 'Erich Klawuhn'));
    abc.add(new SalesSupportDirector__c(Name = 'Pacific Northwest',User_Name__c = 'Brad Baker'));
    abc.add(new SalesSupportDirector__c(Name = 'Memphis/Mid-South',User_Name__c = 'Brian Horton'));
    abc.add(new SalesSupportDirector__c(Name = 'Boston',User_Name__c = 'Test User'));
    abc.add(new SalesSupportDirector__c(Name = 'Florida',User_Name__c = 'Florida User'));
    abc.add(new SalesSupportDirector__c(Name = 'Toronto',User_Name__c = 'Toronto User'));
    abc.add(new SalesSupportDirector__c(Name = 'Vancouver',User_Name__c = 'Vancouver User'));
     abc.add(new SalesSupportDirector__c(Name = 'Washington DC',User_Name__c = 'Washington DC User'));
    //Vancouver Washington DC
    insert abc;
     List<Customer_Success_Manager__c> csmList= new List<Customer_Success_Manager__c>();
     csmList.add(new Customer_Success_Manager__c(Name = 'Atlanta/Carolinas',User_Name__c = 'Brian Horton'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Bay Area',User_Name__c = 'Namrata Vora'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Chicago',User_Name__c = 'Mike Lane'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Dallas',User_Name__c = 'Mahesh Tharoor'));
    csmList.add(new Customer_Success_Manager__c(Name = 'New York',User_Name__c = 'Brian Klansky'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Hawaii',User_Name__c = 'Lance Murata'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Houston',User_Name__c = 'Mahesh Tharoor'));
    csmList.add(new Customer_Success_Manager__c(Name = 'International',User_Name__c = 'Erich Klawuhn'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Pacific Northwest',User_Name__c = 'Brad Baker'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Memphis/Mid-South',User_Name__c = 'Brian Horton'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Boston',User_Name__c = 'Test User'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Florida',User_Name__c = 'Florida User'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Toronto',User_Name__c = 'Toronto User'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Vancouver',User_Name__c = 'Vancouver User'));
     csmList.add(new Customer_Success_Manager__c(Name = 'Washington DC',User_Name__c = 'Washington DC User'));
     
       insert csmList;
       id intelliCaseRecID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Intelligence Case').getRecordTypeId();
         id fieldServiceRecid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Field Service Support Case').getRecordTypeId();
   // Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
    Id OppRecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
   // Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;
   // Id locRecTypId = [select id from RecordType where name='location'].id;
    //Id locRecTypId = Schema.SObjectType.SVMXC__Site__c.getRecordTypeInfosByName().get('Standard Location').getRecordTypeId();
  //  Id CaseRecTypId = [select id from RecordType where name='Support Case'].id;
   Id CaseRecTypId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Engineering Case').getRecordTypeId();
    Id dealDeskId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Deal Desk Support').getRecordTypeId();
   //Deal Desk Support
   Campaign cam=VTestDataUtility_OE.getTestCampaign();
   insert cam;
   Account acc= VTestDataUtility_OE.getTestAccount();
   insert acc;
    Id AccId =acc.id;// [select Id from Account limit 1].id;
    Id CampId = cam.id;//[select Id from Campaign limit 1].id;
   
    //SVMXC__Site__c    
    Contact con = new Contact(LastName ='test', AccountId = AccId );
    insert con;
    Id ContId =con.id;// [select Id from Contact limit 1].id;
    Opportunity opp1 = new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp8',AccountId=AccId ,StageName='Discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Install_Status__c='Service',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5));
    insert opp1;
    
   /// SVMXC__Site__c loc1 = new SVMXC__Site__c(Name ='Testloc8',SVMXC__Account__c=AccId,Location_Status__c='Service',SVMXC__Street__c='Test street',SVMXC__City__c='Sunnyvale',SVMXC__Country__c='United States',SVMXC__Zip__c='95132');
   // insert loc1;
    
    Opportunity opp2 = new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp9',AccountId=AccId ,StageName='Discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Install_Status__c='Service',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5));
    insert opp2;
    
    List<Case> cs = new List<Case>();
               cs.Add(New Case(RecordTypeId=intelliCaseRecID,Opportunity__c=opp1.Id,Contact = con, Subject='test', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test', Origin= 'Email'));
               cs.Add(New Case(RecordTypeId=CaseRecTypId,Opportunity__c=opp1.Id,Contact= con,Subject='test1', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test1', Origin= 'Email'));
               cs.Add(New Case(RecordTypeId=fieldServiceRecid,Opportunity__c=opp1.Id,Contact= con, Subject='test2', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test2', Origin= 'Email'));
               cs.Add(New Case(RecordTypeId=fieldServiceRecid,Opportunity__c=opp1.Id,Contact= con, Subject='test3', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test3', Origin= 'Email'));
                
              // cs.Add(New Case(RecordTypeId=CaseRecTypId,SVMXC__Site__c=Loc1.Id,Contact= con,Subject='test4', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test4', Origin= 'Email'));               
     insert cs;
    for(Case c : cs){
        c.Opportunity__c = opp2.Id;
      //  c.SVMXC__Site__c = loc1.Id;
    }
    update cs;
    AggregateResult[] groupedResults = [SELECT COUNT(Id), Opportunity__c FROM Case where Opportunity__c =:opp1.id GROUP BY Opportunity__c];
 //   AggregateResult[] groupedResults2 = [SELECT COUNT(Id), SVMXC__Site__c FROM Case where SVMXC__Site__c =:loc1.id GROUP BY SVMXC__Site__c];
    delete cs;
}
}