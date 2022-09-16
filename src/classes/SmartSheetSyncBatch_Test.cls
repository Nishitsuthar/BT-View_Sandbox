@isTest
Private class SmartSheetSyncBatch_Test {

    static testmethod void testBatch() {
        
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
        Insert opp;      
        
        Test.startTest();
        SmartSheetSyncBatch  Batch = new SmartSheetSyncBatch();
        DataBase.executeBatch(Batch, 1);
        Test.stopTest();
        
    }
}