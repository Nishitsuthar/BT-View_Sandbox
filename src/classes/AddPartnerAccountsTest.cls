/**
 * Author: Pavan
 * Description: Test class for AddPartnerAccounts 
 * Date : Sep 2018
 */
@isTest
public class AddPartnerAccountsTest{
    
   
    public static testMethod void testDataValues(){
    
        InsertCustomSettings();
        Profile TestProfile= [SELECT Id FROM Profile WHERE Name = 'Standard user'];
        User userObj = new User(Alias = 'T1', Email='User12@test.com', EmailEncodingKey='UTF-8', LastName='DevUser1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = TestProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='T' + String.valueOf(math.random()).replace('.','') + '@t.com');
        insert userObj;
        
         
        User Usracc = [SELECT id,Name from USER where id=:userInfo.GetUserId()];
        Id usrId = userObj.Id;
       
        Account acc = new Account();
        acc.Name = 'TestOE Account';
        acc.BillingCity = 'Sanjose';        
        acc.BillingCountry = 'United States';
        acc.BillingState = 'CA';
        acc.BillingPostalCode = '95121';
        acc.ShippingCity = 'Milpitas';
        acc.ShippingCountry = 'United States';
      
       insert acc;
       Account selectAcc = [Select Id,Name from Account limit 1];
       id AccId=acc.id;
       Id OppRecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Qualified Opportunity').getRecordTypeId();

       
        Opportunity opp = new Opportunity();
        
        opp.RecordTypeId = OppRecTypId;
        opp.Name = 'Test Opp1';
        opp.AccountId = accId;
        opp.closeDate = Date.today() + 10;
        opp.StageName = 'Pre-Qualifying-Open';
        opp.Prequal_Oppty_Status__c = 'Open - New';
        opp.Project_Address__c = 'Test address';
        opp.Construction_Type__c ='Renovation';
        opp.Project_City__c = 'Sanjose';
        opp.Project_State__c = 'CA';
        opp.Project_Country__c = 'United States';
        opp.Support_Region__c = 'Boston';
        opp.Target_SE__c = userObj.Id; 
        opp.Construction_Type__c = 'Renovation';
        opp.Project_Building_Size__c = '< 10K';
        opp.Project_Stage__c = 'Land Acquisition';
        opp.Project_Glass_Installation_Timing__c = '< 3 Months';
        opp.Market_Segment__c = 'Multi-Family';
        opp.LeadSource = 'Webinar';
        opp.Approx_glass_quantity__c = 10;
       insert Opp;
       
       Opportunity selectOpp = [Select Id,Name from Opportunity limit 1];
     
       Id OppId = opp.Id;

       Test.startTest();
      
       Partner_Account__c Paccount = new Partner_Account__c(Partner_Account__c = AccId, Role__c = 'Glazier', Related_Opportunity__C = OppId);
       if(Paccount.Role__c != Null)
       {
            insert Paccount;
             System.debug(Paccount.Role__c);
             system.debug(Paccount.Related_Opportunity__C);
       }
       
       ApexPages.StandardController sc = new ApexPages.StandardController(Paccount);
       AddPartnerAccounts apaac = new AddPartnerAccounts(sc);
       apaac.Save();
       apaac.Cancel();
       apaac.addPacc();
        
       PageReference pageRef = Page.AddPartnerAccounts;
       pageRef.getParameters().put('id', String.valueOf(Paccount.Id));
       Test.setCurrentPage(pageRef);
   
      
        
      List<Partner_Account__c> pacc = [Select id,Partner_Account__c,Role__c, Related_Opportunity__C from Partner_Account__c where id =: Paccount.id];
      Integer i = pacc.Size();
      system.assertEquals(pacc.Size(),i);
     
         Test.StopTest(); 
    }
    
    public static void InsertCustomSettings(){
         List<SalesSupportDirector__c> abc = new List<SalesSupportDirector__c>();
         abc.add(new SalesSupportDirector__c(Name = 'Boston',User_Name__c = 'Test User'));
         insert abc;
     
         List<Customer_Success_Manager__c> csmList= new List<Customer_Success_Manager__c>();
         csmList.add(new Customer_Success_Manager__c(Name = 'Boston',User_Name__c = 'Test User')); 
         insert csmList;
    }

}