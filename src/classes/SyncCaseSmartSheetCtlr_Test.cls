@isTest
public class SyncCaseSmartSheetCtlr_Test {
    
    @isTest Static Void testSyncCaseSmartSheetCntlr(){
        
        
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
        
        Id CaseRecTypId = [select id from RecordType where name='Support Case'].id;
        
        Contact con = new Contact(LastName ='test', AccountId = acc.Id );
        insert con;
        
        Case c =  New Case(RecordTypeId=CaseRecTypId,
                           Opportunity__c=opp.Id,
                           Subject='test',
                           Contact = con,
                           Status ='New', 
                           
                           Est_Cmpl_Date__c= Date.today().addDays(5), 
                           Description = 'Test', 
                           Origin= 'Email',
                           Smartsheet_Id__c = '767597613475716');
        Insert c;
        
        
        PageReference pageRef = Page.SyncCaseSmartSheet;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        SyncCaseSmartSheetCtlr testAccPlan = new SyncCaseSmartSheetCtlr(sc);
        testAccPlan.doSync();   
    }
    @isTest Static Void testSyncCaseSmartSheetCntlr2(){
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
        
        
        Contact con = new Contact(LastName ='test', AccountId = acc.Id );
        insert con;
        Id CaseRecTypId = [select id from RecordType where name='Support Case'].id;
        Case c =  New Case(RecordTypeId=CaseRecTypId,
                           Opportunity__c=opp.Id,
                           Subject='test11',
                           Contact = con,
                           Status ='New', 
                           
                           Est_Cmpl_Date__c= Date.today().addDays(5), 
                           Description = 'Test22', 
                           Origin= 'Email');
        Insert c;
        
        
        
        PageReference pageRef = Page.SyncCaseSmartSheet;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        SyncCaseSmartSheetCtlr testAccPlan = new SyncCaseSmartSheetCtlr(sc);
        testAccPlan.doSync();
        
    }
}