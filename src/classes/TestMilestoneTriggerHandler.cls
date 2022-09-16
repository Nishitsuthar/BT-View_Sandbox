@isTest
public class TestMilestoneTriggerHandler{

    @isTest
    public static void unitTest()
    {
        MilestoneTriggerHandler.decommissionMilestone();
        MSOpptyUpdtTriggerHelper.decommissionMiletwo();
    }

/*
    //this method covers the class MilestoneTriggerHandler
    static testMethod void unitTest(){
       Test.startTest();
       //Creating an Opportunity
       List<SalesSupportDirector__c> ssDList= new  List<SalesSupportDirector__c>();
        List<Customer_Success_Manager__c > csmList= new  List<Customer_Success_Manager__c >();
       SalesSupportDirector__c ssd = new SalesSupportDirector__c(Name = 'Chicago', User_Name__c = 'Mike Lane');
       SalesSupportDirector__c ssd1 = new SalesSupportDirector__c(Name = 'Washington DC', User_Name__c = 'Kelly Whittingham');
       Customer_Success_Manager__c abc = new Customer_Success_Manager__c(Name = 'Chicago', User_Name__c = 'Becky Ohlin');
       Customer_Success_Manager__c abc2 = new Customer_Success_Manager__c(Name = 'Washington DC', User_Name__c = 'Becky Ohlin');
       ssDList.add(ssd);
       ssDList.add(ssd1);
       csmList.add(abc);
       csmList.add(abc2);
       insert ssDList;
       insert csmList;
       //insert ssd;
      // insert ssd1;
       //insert abc;
      // insert abc2;
       
       
       Account testAcc = new Account(Name = 'Test Acc');
       insert testAcc;
       
       //Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
       Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;      
       
      // Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
       List<Opportunity > oppList = new List<Opportunity>();
      
       Opportunity testOpp = new Opportunity(Name = 'Test Oppty', StageName = 'Pre-Qualifying-Open', CloseDate = system.today(), 
                                             AccountId = testAcc.Id, Support_Region__c = 'Chicago', Target_SE__c = u.Id,Project_Country__c='US',
                                             Project_City__c = 'San Francisco',Project_State__c='CA', Construction_Type__c = 'Renovation', Project_Building_Size__c = '< 10K',
                                             Approx_glass_quantity__c = 10.0, Project_Stage__c = 'Conceptual Planning', 
                                           Project_Glass_Installation_Timing__c = '< 3 Months', Market_Segment__c = 'Education', LeadSource = 'Database');
       //insert testOpp;
        oppList.add(testOpp); 
       Opportunity testOpp2 = new Opportunity(Name = 'Test Oppty', StageName = 'Pre-Qualifying-Open', CloseDate = system.today(), 
                                             AccountId = testAcc.Id, Support_Region__c = 'Washington DC', Target_SE__c = u.Id, Project_Country__c='US',
                                             Project_City__c = 'San Francisco',Project_State__c='CA', Construction_Type__c = 'Renovation', Project_Building_Size__c = '< 10K',
                                             Approx_glass_quantity__c = 10.0, Project_Stage__c = 'Conceptual Planning', 
                                             Project_Glass_Installation_Timing__c = '< 3 Months', Market_Segment__c = 'Education', LeadSource = 'Database');
       //insert testOpp2;
        oppList.add(testOpp2); 
        insert oppList;
       
       /*
        List<Opportunity> testOpp= new List<Opportunity>{};
        for(Integer j = 0; j < 100; j++){
            Opportunity Oppobj1 =  new Opportunity(RecordTypeId = OppRecTypId,Name = 'Test Prequal22' + j,AccountId = testAcc.Id,
                                  StageName = 'Closed: Won',
                                  Request_Won_Verification__c = true,
                                  Closed_Won_Justification__c ='test',
                                  Approved_Win__c = true,                                            
                                  CloseDate = System.today() + 20,
                                  Market_Segment__c = 'Commercial',
                                  Market_Sub_Segment__c='Owner',
                                  Basis_of_Design__c = 'View',
                                  Opportunity_Type__c = 'Priority',
                                  Construction_Type__c = 'New Construction',
                                  Install_Type__c = 'Sales',
                                  Project_City__c = 'San Francisco',
                                  Project_State__c='CA',
                                  Support_Region__c='Atlanta/Carolinas');
        }
        */
        //Insert testOpp;
      
        
        /*
        List<CSM_Milestone__c > csm1 = New List<CSM_Milestone__c > {}; 
       csm1.Add(New CSM_Milestone__c ( Name = 'Attend Sales to Ops Turnover MTG', Opportunity__c = testOpp.Id));
       csm1.Add(New CSM_Milestone__c ( Name = 'Meet with PM to get customer details', Opportunity__c = testOpp.Id));
       csm1.Add(New CSM_Milestone__c ( Name = 'Initial POC training on product and controls', Opportunity__c = testOpp.Id));
       csm1.Add(New CSM_Milestone__c ( Name = 'Initial engagement with customer', Opportunity__c = testOpp.Id));
       csm1.Add(New CSM_Milestone__c ( Name = 'BOS Design Check', Opportunity__c = testOpp.Id));
       csm1.Add(New CSM_Milestone__c ( Name = 'Architectural Zoning', Opportunity__c = testOpp.Id));
        csm1.Add(New CSM_Milestone__c ( Name = 'BOS Commissioning', Opportunity__c = testOpp.Id));
        csm1.Add(New CSM_Milestone__c ( Name = 'Intelligence Commissioning', Opportunity__c = testOpp.Id));
        csm1.Add(New CSM_Milestone__c ( Name = 'Occupant Engagement', Opportunity__c = testOpp.Id));
        csm1.Add(New CSM_Milestone__c ( Name = 'Training and initial verbal feedback', Opportunity__c = testOpp.Id));
        csm1.Add(New CSM_Milestone__c ( Name = 'Resolve occupant issues', Opportunity__c = testOpp.Id));
        csm1.Add(New CSM_Milestone__c ( Name = 'Final feedback survey', Opportunity__c = testOpp.Id));
        
       insert csm1;
      /* 
       List<Milestone1_Milestone__c> milestone1  = New List<Milestone1_Milestone__c> {};     
       milestone1.Add(New Milestone1_Milestone__c( Name = 'Sales to Ops Turnover', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       milestone1.Add(New Milestone1_Milestone__c(Name = 'Occupancy', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       milestone1.Add(New Milestone1_Milestone__c(Name = 'IGU Ship', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       milestone1.Add(New Milestone1_Milestone__c(Name = 'BOS Ship', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       milestone1.Add(New Milestone1_Milestone__c(Name = 'BOS Commissioning', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       milestone1.Add(New Milestone1_Milestone__c(Name = 'Intelligence Commissioning', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       milestone1.Add(New Milestone1_Milestone__c(Name = 'Architectural Zoning', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       milestone1.Add(New Milestone1_Milestone__c(Name = 'Preliminary BOS Design', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       milestone1.Add(New Milestone1_Milestone__c(Name = 'Project Kickoff Meeting', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id));
       insert milestone1;
       */
      /* Milestone1_Milestone__c milestone1 = new Milestone1_Milestone__c(Name = 'Occupancy', Deadline__c = system.today() + 3, Opportunity__c = testOpp.Id);
       insert milestone1;
       
       system.assertEquals(milestone1.Deadline__c);
       
       
       Milestone1_Milestone__c milestone1 = new Milestone1_Milestone__c(Name = 'IGU SHIP 1', Deadline__c = system.today(), Opportunity__c = testOpp.Id);
       insert milestone1;
       
       Milestone1_Milestone__c milestone2 = new Milestone1_Milestone__c(Name = 'IGU SHip 2', Deadline__c = system.today().addMonths(-1), Opportunity__c = testOpp.Id);
       insert milestone2;
       */
      
      /* CSM_Milestone__c csm1 = new CSM_Milestone__c(Name = 'Customer Kick off Meeting', Opportunity__c = testOpp.Id);
       insert csm1;
       
        CSM_Milestone__c csm1 = new CSM_Milestone__c(Name = 'Attend Sales to Ops Turnover MTG', Opportunity__c = testOpp.Id);
       insert csm1;
       */
       
       //CSM_Milestone__c testcsm = [ Select Id, Start_Date__c, PM_Milestone__c, Completion_Date__c From CSM_Milestone__c Where Id = :csm1[0].Id ];
      // System.debug('*****'+testcsm.Completion_Date__c);
      // system.assertEquals(testcsm.Start_Date__c , milestone1[0].Deadline__c);
       //system.assertEquals(testcsm.Completion_Date__c , milestone1[0].Deadline__c);
      // system.assertEquals(testcsm.PM_Milestone__c , milestone1[0].Id);
       
       // CSM_Milestone__c testcsm11 = [ Select Id, Start_Date__c,  Completion_Date__c From CSM_Milestone__c Where Id = :csm1[8].Id ];
   //    system.assertEquals(testcsm11.Completion_Date__c , milestone1[1].Deadline__c.addDays(7));
   //    system.assertEquals(testcsm11.PM_Milestone__c , milestone1[1].Id);
        
       //CSM_Milestone__c testcsm12 = [ Select Id, Start_Date__c, Completion_Date__c From CSM_Milestone__c Where Id = :csm1[11].Id ];
    //   system.assertEquals(testcsm12.Completion_Date__c , milestone1[1].Deadline__c.addDays(60));
     //  system.assertEquals(testcsm12.PM_Milestone__c , milestone1[1].Id);
        
     //  milestone1[1].Deadline__c = system.today().addMonths(-2);
     //  milestone1[8].Deadline__c = system.today().addMonths(-1);
      // update milestone1[1];
       //update milestone1[8];
        
       
       
     /*  //System.debug(milestone1[0].Deadline__c);
       CSM_Milestone__c testcsm2 = [ Select Id, Start_Date__c, PM_Milestone__c, Completion_Date__c,PM_Milestone__r.Name From CSM_Milestone__c Where Id = :csm1[2].Id ];
      // system.assertEquals(testcsm2.Completion_Date__c , milestone1[1].Deadline__c);
      // system.assertEquals(testcsm2.PM_Milestone__c , milestone1[1].Id);
       
         CSM_Milestone__c testcsm3 = [ Select Id, Start_Date__c, PM_Milestone__c, Completion_Date__c,PM_Milestone__r.Name From CSM_Milestone__c Where Id = :csm1[1].Id ];
     //  system.assertEquals(testcsm3.Completion_Date__c , milestone1[8].Deadline__c);
     //  system.assertEquals(testcsm3.PM_Milestone__c , milestone1[8].Id);
        
         CSM_Milestone__c testcsm4 = [ Select Id, Start_Date__c, PM_Milestone__c, Completion_Date__c,PM_Milestone__r.Name From CSM_Milestone__c Where Id = :csm1[3].Id ];
      // system.assertEquals(testcsm4.Completion_Date__c , milestone1[2].Deadline__c);
       //system.assertEquals(testcsm4.PM_Milestone__c , milestone1[2].Id);
        
         CSM_Milestone__c testcsm5 = [ Select Id, Start_Date__c, PM_Milestone__c, Completion_Date__c,PM_Milestone__r.Name From CSM_Milestone__c Where Id = :csm1[8].Id ];
       //system.assertEquals(testcsm5.Completion_Date__c , milestone1[1].Deadline__c.addDays(7));
      // system.assertEquals(testcsm5.PM_Milestone__c , milestone1[1].Id);
        
         CSM_Milestone__c testcsm6 = [ Select Id, Start_Date__c, PM_Milestone__c, Completion_Date__c,PM_Milestone__r.Name From CSM_Milestone__c Where Id = :csm1[11].Id ];
      // system.assertEquals(testcsm6.Completion_Date__c , milestone1[1].Deadline__c.addDays(60));
      // system.assertEquals(testcsm6.PM_Milestone__c , milestone1[1].Id);
      // 
      
      
      System.assertEquals(null, MilestoneTriggerHandler.getCSMNameForMileStoneLogic('Mname'));
      System.assertEquals(null, MilestoneTriggerHandler.getKeyValueForQuery('csmname'));
      System.assertEquals(null, MilestoneTriggerHandler.getTypeFromMileStoneName('csmname'));
       */
       
       
       //MilestoneTriggerHandler msg = new MilestoneTriggerHandler();
        //msg.setKickoffDateMethod(csm1);
        //Test.StopTest();
        
    }