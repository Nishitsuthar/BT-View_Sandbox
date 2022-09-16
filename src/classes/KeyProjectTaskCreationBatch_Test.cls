@isTest
global class KeyProjectTaskCreationBatch_Test {

    static testmethod void testBatch() {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
               
        /*Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.Id;
        opp.Book_Date__c = Date.today();
        opp.closeDate = Date.today().addDays(25);
        opp.StageName = 'Discovery';
        opp.Key_Project_Region__c = true;
       
        Insert opp;  */
        
        Opportunity[] oppList = new Opportunity[4];
        Opportunity oppBoth = new Opportunity(Name='Test Opp Both',AccountId = acc.Id, Book_Date__c= Date.today(), 
                                             closeDate = Date.today().addDays(25), StageName = 'Discovery',
                                             Key_Project_HQ__c = true, Key_Project_Region__c=true);
        oppList[0]=oppBoth;
        Opportunity oppOnlyRegion = new Opportunity(Name='Test Opp Region',AccountId = acc.Id, Book_Date__c= Date.today(), 
                                             closeDate = Date.today().addDays(25), StageName = 'Discovery',
                                             Key_Project_Region__c=true);
        oppList[1]= oppOnlyRegion;
        Opportunity oppOnlyHQ = new Opportunity(Name='Test Opp HQ',AccountId = acc.Id, Book_Date__c= Date.today(), 
                                             closeDate = Date.today().addDays(25), StageName = 'Discovery',
                                             Key_Project_HQ__c = true);
        
        oppList[2] = oppOnlyHQ;
        
         Opportunity oppOnlyHQ1 = new Opportunity(Name='Test Opp HQ',AccountId = acc.Id, Book_Date__c= Date.today(), 
                                             closeDate = Date.today().addDays(25), StageName = 'Invoiced',Approved_Win__c=True,
                                             Key_Project_HQ__c = true,First_Request_Date_IGU__c=Date.today());
        
        oppList[3] = oppOnlyHQ1;
        database.insert(oppList);
        
        Test.startTest();
        KeyProjectTaskCreationBatch Batch = new KeyProjectTaskCreationBatch();
        DataBase.executeBatch(Batch);
        Test.stopTest();
        
    }
}