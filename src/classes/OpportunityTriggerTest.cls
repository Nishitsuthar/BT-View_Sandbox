@isTest(seeAllData =false)
public class OpportunityTriggerTest {
    //class for mock response
     Public with sharing class UploadFileMock implements HTTPCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/JSON');
            List<String> str = new  List<String>{'location'};
                String s = JSON.serialize(str);
            res.setBody(s);
            res.setStatusCode(201);
            return res;
        }
     }
    public static testmethod void PopulateSalesDirector() {
        
        User usr=[SELECT id,Name from USER where id=:userInfo.GetUserId()];//VTestDataUtility_OE.getUser();
        //insert usr;
      // Id OppRecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Open-Qualified').getRecordTypeId();
       Id OppRecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId(); //Added by NN
        Campaign Camp = getTestCampaign();
        InsertCustomSettings();
        Account acc=VTestDataUtility_OE.getTestAccount();
       insert acc;
       id AccId=acc.id;
       
       
     
        List<Opportunity> OppList = new List<Opportunity>();
        //OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp-milestone',AccountId=AccId ,StageName='Closed: Won',CampaignId=Camp.Id,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Project_Manager__c = DirName_Id.get(salesDirectors.get('Atlanta/Carolinas').User_Name__c),Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp1',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp2',AccountId=AccId,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Bay Area',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp3',AccountId=AccId,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Boston',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp4',AccountId=AccId,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Chicago',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp5',AccountId=AccId,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Dallas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp6',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Denver',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp7',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Florida',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp8',AccountId=AccId,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Hawaii',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp9',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Houston',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp10',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='International',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp11',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Los Angeles/SoCal',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp12',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Memphis/Mid-South',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp13',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='New York',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp14',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Phoenix/Vegas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp15',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Portland/Seattle',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp16',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Toronto',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp17',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Vancouver',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp18',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Target_SE__c =usr.id,Basis_of_Design__c='View',Support_Region__c='Washington DC',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        insert OppList; // hit the trigger

        //Coverage for Probability trigger
        Opportunity oppProbability = new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp1',Target_SE__c =usr.id,Project_Address__c='Washington DC' ,Project_State__c='New Yark',Project_Zip_Code__c='100231',AccountId=AccId ,StageName='discovery',CampaignId=Camp.Id,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5));
        insert oppProbability;
        oppProbability.StageName = oppProbability.StageName;
        update oppProbability;
        oppProbability.StageName = 'Bid/Quote';
        oppProbability.Project_Country__c = 'United States';
        update oppProbability;
      
        //Coverage for Google map VF page controller
       // OpportunityProjectsController opc = new OpportunityProjectsController();
       // opc.getProjectAddressList();
       
       
       for(Integer i=1; i<=9; i++){
        OpportunityProjectsController opc = new OpportunityProjectsController();
        opc.Quantity = String.valueOf(i);
        opc.installStatus='On Track';
        opc.installStatus='Service';
        opc.installStatus='On Hold';
        opc.installType='Demo';
        opc.installType='Sales';
        opc.installType='Mockup';
        opc.installType='Infill';
        opc.MarketSegment ='Commercial';
        opc.SupportRegion='Boston';
        List<Opportunity> opp1 = opc.getProjectAddressList();
        }

      for(Integer j=1; j<=9; j++){
        OpportunityProjectsController opc1 = new OpportunityProjectsController();
        opc1.Quantity = String.valueOf(j);
        opc1.installStatus='On Track';  //Active
        opc1.installStatus='Service';
        opc1.installStatus='On Hold';
        opc1.installType='Demo';
        opc1.installType='Sales';
        opc1.installType='Mockup';
        opc1.installType='Infill';
        opc1.MarketSegment ='Commercial';
        opc1.SupportRegion='Boston';
        opc1.Stage='Project Won';
        List<Opportunity> opp2 = opc1.getProjectAddressList();
        }

        
        //Coverage for Opportunity Geocode Address class
        
        OpportunityGeocodeAddress.DoAddressGeocode(oppProbability.Id);
        test.startTest();
        OpportunityGeocodeAddress.geocodeAddress(oppProbability.Id);
        
        Test.setMock(HTTPCalloutMock.Class,new UploadFileMock());
        test.stopTest();
        
      
      
    }
     public static Campaign getTestCampaign ()
    {
     Campaign camp1 = new Campaign(Name = 'Test Campaign 1', IsActive = True);
     return camp1;
     }
     public static void InsertCustomSettings(){
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
    }
    
}