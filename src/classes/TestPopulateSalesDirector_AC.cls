@isTest(seeAllData =true)
public class TestPopulateSalesDirector_AC {
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
        Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
        Id AccId = [select Id from Account limit 1].id;
        Id CampId = [select Id from Campaign limit 1].id;
        Map<String,SalesSupportDirector__c> salesDirectors = SalesSupportDirector__c.getAll();
        List<String> AllSalesDirectors =new List<String>();
        for(String sd : salesDirectors.keyset())
        {
            AllSalesDirectors.add(salesDirectors.get(sd).User_Name__c);
        }
        List<User> SalesDireUsers =[select id,name from user where Name IN: AllSalesDirectors];
        Map<String,Id> DirName_Id = new Map<String,ID>();
        for(User u : SalesDireUsers )
        {
            DirName_Id.put(u.Name,u.Id);
        }
//mile stone
//Milestone_Config__c config = new Milestone_Config__c(Name = 'test milestone',Type__c='test');
//insert config;

        List<Opportunity> OppList = new List<Opportunity>();
        //OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp-milestone',AccountId=AccId ,StageName='Closed: Won',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Project_Manager__c = DirName_Id.get(salesDirectors.get('Atlanta/Carolinas').User_Name__c),Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp1',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp2',AccountId=AccId,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Bay Area',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp3',AccountId=AccId,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Boston',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp4',AccountId=AccId,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Chicago',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp5',AccountId=AccId,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Dallas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp6',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Denver',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp7',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Florida',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp8',AccountId=AccId,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Hawaii',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp9',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Houston',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp10',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='International',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp11',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Los Angeles/SoCal',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp12',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Memphis/Mid-South',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp13',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='New York',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp14',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Phoenix/Vegas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp15',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Portland/Seattle',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp16',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Toronto',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp17',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Vancouver',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        OppList.add(new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp18',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Washington DC',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5)));
        insert OppList; // hit the trigger

        //Coverage for Probability trigger
        Opportunity oppProbability = new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp1',Project_Address__c='Washington DC' ,Project_State__c='New Yark',Project_Zip_Code__c='100231',AccountId=AccId ,StageName='discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5));
        insert oppProbability;
        oppProbability.StageName = oppProbability.StageName;
        update oppProbability;
        oppProbability.StageName = 'Bid/Quote';
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
        
      /*  public static testMethod void unitTest1()
       //  {
        
         RecordType preQualRecType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Pre_Qualified_Opportunity'];
         
          Profile salesDevProfile = [SELECT Id FROM Profile WHERE Name = 'Sales Development'];
        User  salesDevUser= new User(Alias = 'sdUser', Email='SDUser12@test.com', EmailEncodingKey='UTF-8', LastName='SaleDevUser1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = salesDevProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
        insert salesDevUser;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User  standardUser= new User(Alias = 'stdUser', Email='StandardUser12@test.com', EmailEncodingKey='UTF-8', LastName='StdUser1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = standardProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
        insert standardUser;

        
        Account testAcct1;
        Account testAcct2;
        Opportunity testOppty1;
        Opportunity testOppty2;
        Opportunity checkOppty;
        test.startTest();
        System.RunAs(salesDevUser)
        {
            testAcct1 = new Account(Name='Oppty Set SDO Trigger Test Account 1');
            insert testAcct1;
            testOppty1 = new Opportunity(Name='Test SDO Opportunity 1', RecordTypeId = preQualRecType.Id, AccountId = testAcct1.Id, StageName = 'Pre-Qualifying-Open', Support_Region__c = 'Bay Area', CloseDate = System.today() + 60,
                Market_Segment__c = 'Commercial', Basis_of_Design__c = 'View', Opportunity_Type__c = 'Opportunity', Construction_Type__c = 'New Construction', Install_Type__c = 'Sales',
                Project_City__c = 'San Francisco');
            insert testOppty1;
        }
        checkOppty = [SELECT Id, Inside_Sales_Owner__c from Opportunity WHERE ID = :testOppty1.Id LIMIT 1];
        System.assertEquals(checkOppty.Inside_Sales_Owner__c,salesDevUser.Id);
        
        System.RunAs(standardUser)
        {
            testAcct2 = new Account(Name='Oppty Set SDO Trigger Test Account 2');
            insert testAcct2;
            testOppty2 = new Opportunity(Name='Test SDO Opportunity 2', RecordTypeId = preQualRecType.Id, AccountId = testAcct2.Id, StageName = 'Pre-Qualifying-Open', Support_Region__c = 'Bay Area', CloseDate = System.today() + 60,
                Market_Segment__c = 'Commercial', Basis_of_Design__c = 'View', Opportunity_Type__c = 'Opportunity', Construction_Type__c = 'New Construction', Install_Type__c = 'Sales',
                Project_City__c = 'San Francisco');
            insert testOppty2;
        }
        checkOppty = [SELECT Id, Inside_Sales_Owner__c from Opportunity WHERE ID = :testOppty2.Id LIMIT 1];
        System.assertEquals(checkOppty.Inside_Sales_Owner__c,null);
        
        test.stopTest();
        
 // } */
       /* 
        // Check that the trigger properly set the Sales Director UserId field:
        List<Opportunity> Opp = [select Support_Region__c,Sales_Director__c from Opportunity where id IN:OppList];  
        for(Opportunity resultop : Opp)
        {
            if (resultop.Support_Region__c == 'Atlanta/Carolinas')  {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Bay Area') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Boston') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Chicago') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Dallas') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Denver') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Florida') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Hawaii') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Houston') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'International') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Los Angeles/SoCal') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Memphis/Mid-South') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'New York') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Phoenix/Vegas') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Portland/Seattle') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Toronto') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Vancouver') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
            else if (resultop.Support_Region__c == 'Washington DC') {System.assertEquals( DirName_Id.get(salesDirectors.get(resultop.Support_Region__c).User_Name__c),resultop.Sales_Director__c);}
        } */
    }
    
}