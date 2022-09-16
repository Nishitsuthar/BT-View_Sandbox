@isTest
Private class ProjectsUpdatesMigaration_Test {

    @isTest Static Void testProjectUpdateMigration(){
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
        opp.Weekly_Updates__c = 'Test Weekly update';
        opp.Project_Update__c = 'Test Project update';
        Insert opp;      
        
        Test.startTest();
        ProjectsUpdatesMigaration  Batch = new ProjectsUpdatesMigaration();
        DataBase.executeBatch(Batch, 1);
        Test.stopTest();
    }
}