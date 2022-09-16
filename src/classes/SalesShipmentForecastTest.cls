@isTest
Public class SalesShipmentForecastTest{   
    
 
 Static testMethod void testmethod1(){
     
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
        insert testContact;
        
        
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
        
        
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;
        Sales_Shipment_Forecast__c sf1= new Sales_Shipment_Forecast__c();
        sf1.Opportunity__c = testMOUOpportunityObj.Id;
        sf1.First_Request_Date_CSS__c= system.today();
        sf1.First_Request_Date_IGU__c= system.today();
        sf1.Groundbreaking_Date__c= system.today();
        insert sf1;
        Sales_Shipment_Forecast__c sf= new Sales_Shipment_Forecast__c();
        sf.Opportunity__c = testMOUOpportunityObj.Id;
        sf.First_Request_Date_CSS__c= system.today();
        sf.First_Request_Date_IGU__c= system.today();
         sf.Groundbreaking_Date__c= system.today();
         
         Sales_Shipment_Forecast__c sf2= new Sales_Shipment_Forecast__c();
        sf2.Opportunity__c = testMOUOpportunityObj.Id;
        sf2.First_Request_Date_CSS__c= system.today();
        sf2.First_Request_Date_IGU__c= system.today();
         sf2.Groundbreaking_Date__c= system.today();
      
       
        
        List<Sales_Shipment_Forecast__c> sfs=new List<Sales_Shipment_Forecast__c>();
        sfs.add(sf);
        //To Cover forecast class
        ApexPages.StandardsetController sc = new ApexPages.StandardsetController(sfs);
         ApexPages.currentPage().getParameters().put('Id',testMOUOpportunityObj.Id);
        //ApexPages.CurrentPage().getParameters().put('Id',sf.Id);
        SalesShipmentForecastExt sfext = new SalesShipmentForecastExt(sc);
        SalesShipmentForecastExt sfext1 = new SalesShipmentForecastExt(sc);
        sfext1.ssf=sf2;
        sfext.ssf=sf;
        sfext.Save();
        sfext.populateRequetDate();
        sfext.populateRequetCSSDate();
        sfext1.continueLines();
        
       
       
    }
    Static testMethod void testmethod2(){
     
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
        insert testContact;
        
        
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
        
        
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj;
       
        Sales_Shipment_Forecast__c sf= new Sales_Shipment_Forecast__c();
        sf.Opportunity__c = testMOUOpportunityObj.Id;
        sf.First_Request_Date_CSS__c= system.today();
        sf.First_Request_Date_IGU__c= system.today();
        sf.Groundbreaking_Date__c= system.today();
        insert sf;
        Sales_Shipment_Forecast_Line__c sfl= new Sales_Shipment_Forecast_Line__c();
        sfl.Sales_Shipment_Forecast__c = sf.Id;
        sfl.Product_Family__c ='IGU';
        sfl.Request_Date__c = system.today();
        sfl.Shipment_Percentage__c=20;
        insert sfl;
        Sales_Shipment_Forecast_Line__c sfl2= new Sales_Shipment_Forecast_Line__c();
        sfl2.Sales_Shipment_Forecast__c = sf.Id;
        sfl2.Product_Family__c ='IGU';
        sfl2.Request_Date__c = system.today();
        sfl2.Shipment_Percentage__c=80;
        Sales_Shipment_Forecast_Line__c sfl3= new Sales_Shipment_Forecast_Line__c();
        sfl3.Sales_Shipment_Forecast__c = sf.Id;
        sfl3.Product_Family__c ='IGU';
        sfl3.Request_Date__c = system.today().adddays(2);
        sfl3.Shipment_Percentage__c=20;
        
        List<Sales_Shipment_Forecast_Line__c> sfls=new List<Sales_Shipment_Forecast_Line__c>();
        sfls.add(sfl);
         List<Sales_Shipment_Forecast_Line__c> sfls2=new List<Sales_Shipment_Forecast_Line__c>();
        sfls2.add(sfl2);
        sfls2.add(sfl3);
        ApexPages.StandardsetController sc1 = new ApexPages.StandardsetController(sfls);
       
        ApexPages.CurrentPage().getParameters().put('Id',sf.Id);
        SalesShipmentForeCastLineExt sflext = new SalesShipmentForeCastLineExt(sc1);
        
       
        //sflext.sflines=sfls2;
        sflext.isError=false; 
        
        sflext.addRows();
        sflext.addSFLine();
    
        sflext.save();
        
        sflext.getItems();
        sflext.populateAmount();
        sflext.saveAndContinue();
        sflext.deleteRow();
        sflext.getInsertOptions();
        sflext.getFrequnceOptions();
        sflext.noofShipments=3;
        sflext.calculateLines();
        sflext.showInsertLinesOptions();
        SalesShipmentForeCastLineExt sflext1 = new SalesShipmentForeCastLineExt(sc1);
        sflext1.ProductFamily = 'IGU';
        sflext1.sflines=sfls2;
        system.debug('@@testsf'+sfls2);
        sflext1.populateAmount();
        sflext1.createSF();
        sflext1.save();
        sflext1.addSFLine();
        sflext1.cancel();
            sflext.insertOption='Manual';
        sflext.ProductFamily='IGU';
        sflext.addSFLine();
        sflext.showInsertLinesOptions();
        sflext.reclculateAmountandSftfromOpty(null,null);
       
    }
}