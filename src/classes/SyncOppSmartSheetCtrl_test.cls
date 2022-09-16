@isTest
public class SyncOppSmartSheetCtrl_test {
    
    @isTest Static Void testSyncOppSmartSheetCntlr(){
        
        
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
        
        
        
        
        PageReference pageRef = Page.SyncOpptySmartSheet;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        SyncOpptySmartSheetCtlr testAccPlan = new SyncOpptySmartSheetCtlr(sc);
        testAccPlan.doSync();	
    }
    @isTest Static Void testSyncOppSmartSheetCntlr2(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = acc.Id;
        opp.Book_Date__c = date.today();
        opp.closeDate = Date.today();
        opp.StageName = 'Discovery';
        Insert opp;      
        
       
       PageReference pageRef = Page.SyncOpptySmartSheet;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        SyncOpptySmartSheetCtlr testAccPlan = new SyncOpptySmartSheetCtlr(sc);
        testAccPlan.doSync();
        
    }
}