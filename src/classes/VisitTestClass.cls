@isTest
public class VisitTestClass {

    static testMethod void creatingVisit()
    {
       SalesSupportDirector__c ssd = new SalesSupportDirector__c(Name = 'Chicago', User_Name__c = 'Mike Lane');
       SalesSupportDirector__c ssd1 = new SalesSupportDirector__c(Name = 'Washington DC', User_Name__c = 'Kelly Whittingham');
       Customer_Success_Manager__c abc = new Customer_Success_Manager__c(Name = 'Chicago', User_Name__c = 'Becky Ohlin');
       Customer_Success_Manager__c abc2 = new Customer_Success_Manager__c(Name = 'Washington DC', User_Name__c = 'Becky Ohlin');
       
       insert ssd;
       insert ssd1;
       insert abc;
       insert abc2;
        Account testAcc = new Account(Name = 'Test Acc');
       insert testAcc;
       
       //Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
       Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;
       
       Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
       User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
      
       Opportunity testOpp = new Opportunity(Name = 'Test Oppty', StageName = 'Pre-Qualifying-Open', CloseDate = system.today(), 
                                             AccountId = testAcc.Id, Support_Region__c = 'Chicago', Target_SE__c = u.Id,Project_Country__c='US',
                                             Project_City__c = 'San Francisco',Project_State__c='CA', Construction_Type__c = 'Renovation', Project_Building_Size__c = '< 10K',
                                             Approx_glass_quantity__c = 10.0, Project_Stage__c = 'Conceptual Planning', 
                                             Project_Glass_Installation_Timing__c = '< 3 Months', Market_Segment__c = 'Education', LeadSource = 'Database');
       insert testOpp;
        
        Opportunity testOpp2 = new Opportunity(Name = 'Test Oppty2', StageName = 'Pre-Qualifying-Open', CloseDate = system.today(), 
                                             AccountId = testAcc.Id, Support_Region__c = 'Chicago', Target_SE__c = u.Id,Project_Country__c='US',
                                             Project_City__c = 'San Francisco',Project_State__c='CA', Construction_Type__c = 'Renovation', Project_Building_Size__c = '< 10K',
                                             Approx_glass_quantity__c = 10.0, Project_Stage__c = 'Conceptual Planning', 
                                             Project_Glass_Installation_Timing__c = '< 3 Months', Market_Segment__c = 'Education', LeadSource = 'Database');
        
        insert testOpp2;
        
        Opportunity testOpp3 = new Opportunity(Name = 'Test Oppty3', StageName = 'Pre-Qualifying-Open', CloseDate = system.today(), 
                                             AccountId = testAcc.Id, Support_Region__c = 'Chicago', Target_SE__c = u.Id,Project_Country__c='US',
                                             Project_City__c = 'San Francisco',Project_State__c='CA', Construction_Type__c = 'Renovation', Project_Building_Size__c = '< 10K',
                                             Approx_glass_quantity__c = 10.0, Project_Stage__c = 'Conceptual Planning', 
                                             Project_Glass_Installation_Timing__c = '< 3 Months', Market_Segment__c = 'Education', LeadSource = 'Database');
        
        insert testOpp3;
       List<Visit_Request__c> visits = new List<Visit_Request__c>();
        
       Date closeDate = Date.today();
       // '0120L000000NPyA',
       id recId=Schema.SObjectType.Visit_Request__c.getRecordTypeInfosByName().get('HQ Visit Request (New)').getRecordTypeId();
       Visit_Request__c visit1 = new Visit_Request__c(
       RecordTypeId = recId ,
       Related_Opportunity__c = testOpp.Id,
       Requested_Visit_Date__c = closeDate,
       View_Inc_Point_of_Contact__c = u.id,
       Visitor_Partner_Role__c = 'Architect',
       Main_Visiting_Company__c = testAcc.Id,
       Number_of_Guests__c = 12,
       Visit_Purpose__c = 'Other',
       Visit_Objectives__c = 'Meet with executive team',
       Status__c = 'Draft',
       Site_to_Visit_2__c = testOpp2.Id,
       Site_to_Visit_3__c = testOpp3.Id,
       Site_to_Visit__c=testOpp.id,
       Executive_Required__c = 'Brandon Tinianov');
      //RecordTypeId
       insert visit1;
      
     //  Opportunity opp = [SELECT Id, Name, AccountId, Visit_Request_Count__c FROM Opportunity where id = :testOpp.Id];
      // System.assertEquals(0, opp.Visit_Request_Count__c);              
       
      // Helperclass.firstRun = true;
       visit1.status__c='Approved';
        visit1.Site_to_Visit__c=null;
       visit1.Site_to_Visit_2__c = testOpp2.Id;
       try{
       update visit1;
       }Catch(Exception ex){}
        
     //  Opportunity opp1 = [SELECT Id, Name, AccountId, Visit_Request_Count__c FROM Opportunity where id = :visit1.Site_to_Visit_2__c];
      // System.assertEquals(2, opp1.Visit_Request_Count__c);
        
       //visit1.Site_to_Visit_2__c = null;
       //update visit1;
       
     //  Opportunity opp3 = [SELECT Id, Name, AccountId, Visit_Request_Count__c FROM Opportunity where id = :testOpp3.Id];
       //System.assertEquals(2, opp3.Visit_Request_Count__c);
       
     //  update visit1;
       
     //  Helperclass.firstRun = true;
       
     //  delete visit1;
        
     //  Helperclass.firstRun = false;
      
    }
}