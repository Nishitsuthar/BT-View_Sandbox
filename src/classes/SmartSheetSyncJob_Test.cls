@isTest
global class SmartSheetSyncJob_Test {
    
    @TestSetup static void setupData() {
        
        Smartsheet_Config__c settings = new Smartsheet_Config__c();
        
        settings.Name = 'Test Smart Sheet Settings';
        settings.Access_Token__c= 't100ees07y527ta8a1n5xy48we';
        settings.API_Base_URL__c ='https://api.smartsheet.com';
        settings.API_Version__c = '2.0';
        settings.Authorize_URL__c = 'https://www.smartsheet.com/b/authorize';
        settings.Redirect_URL__c = 'https://login.salesforce.com/apex/SmartsheetDemoPage';
        settings.Scope__c= 'READ_SHEETS,WRITE_SHEETS,CREATE_SHEETS';
        settings.Sync_Job_Time_Interval__c = 5;
        
        Insert settings;
    }
    
  @isTest static void testschedule() {
     
      
        
        SmartSheetSyncJob sh1 = new SmartSheetSyncJob();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Check', sch, sh1); 
        
    }
    
}