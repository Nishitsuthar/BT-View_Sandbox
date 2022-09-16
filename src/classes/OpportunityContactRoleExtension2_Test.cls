@isTest(seeAllData=true)
private class OpportunityContactRoleExtension2_Test{

    static testMethod void opptTest2(){
        Case c = [select Id from case where Opportunity__c!= null limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        OpportunityContactRoleExtension2 oppCon = new OpportunityContactRoleExtension2(sc);
    }
    /*
  static testMethod void caseContactRoleExtension2_Test (){
   Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
       User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
  
  
  Account testAcc = new Account(Name = 'Test Acc');
      insert testAcc; 
      
      Contact testCon = new Contact(LastName = 'Acontact', FirstName = 'Test', AccountId = testAcc.Id);
      insert testCon;
      
      Opportunity testOpp = new Opportunity(Name = 'Test Pre-Oppty', StageName = 'Pre-Qualifying-Open',Prequal_Oppty_Status__c = 'Open - New', CloseDate = system.today() + 5, 
                                             AccountId = testAcc.Id, Support_Region__c = 'Chicago', Target_SE__c = u.Id, 
                                             Project_City__c = 'Test City', Construction_Type__c = 'Renovation', Project_Building_Size__c = '< 10K',
                                             Approx_glass_quantity__c = 10.0, Project_Stage__c = 'On Hold', 
                                             Project_Glass_Installation_Timing__c = '< 3 Months', Market_Segment__c = 'Education', LeadSource = 'Inbound Call'); 
       test.startTest();
      
  
       
      /*Opportunity testOpp = new Opportunity(Name = 'Test Pre-Oppty', StageName = 'Pre-Qualifying-Open',Prequal_Oppty_Status__c = 'Open - New', CloseDate = system.today() + 5, 
                                             AccountId = testAcc.Id, Support_Region__c = 'Chicago', Target_SE__c = u.Id, 
                                             Project_City__c = 'Test City', Construction_Type__c = 'Renovation', Project_Building_Size__c = '< 10K',
                                             Approx_glass_quantity__c = 10.0, Project_Stage__c = 'On Hold', 
                                             Project_Glass_Installation_Timing__c = '< 3 Months', Market_Segment__c = 'Education', LeadSource = 'Inbound Call');
       insert testOpp; */
       /*
        Case testCase = new Case(Subject = 'Test', ContactId = testCon.Id, Status = 'New', Case_Type__c = 'Dispatch', Est_Cmpl_Date__c = system.today(),
                                Description = 'This is a test.', AccountId = testAcc.Id, Opportunity__c = testOpp.Id);
   
     // TestData.objRTypeMap.put('Case','012E00000001fgdIAA');
    //TestData.CreateData(ObjectName,Cascade,useAlreadyCreatedObj)
   
      // insert testCase;
  
    //TestData.CreateData(ObjectName,Cascade,useAlreadyCreatedObj)
  //  OpportunityContactRole opportunitycontactrole_Obj = new OpportunityContactRole(Name = 'Test', Email = 'test@test.com', IsPrimary = false);
 //  Insert opportunitycontactrole_Obj ; 
  //  List<Contact> contact = (List<Contact>)tgen.TestData.CreateDataList('Contact', false, 7);
 //  Insert contact;
    test.stopTest();
  }
*/
}