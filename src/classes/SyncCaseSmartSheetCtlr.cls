public with sharing class SyncCaseSmartSheetCtlr {

  Case objCase;

  public SyncCaseSmartSheetCtlr (ApexPages.StandardController std) {    
    objCase = [SELECT Id, Smartsheet_Id__c FROM Case WHERE Id = :std.getRecord().Id];
    if(objCase.Smartsheet_Id__c == NULL) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter smart sheet id on Case to sync'));
    }
  }

  public PageReference doSync() {

    if(objCase.Smartsheet_Id__c == NULL) {
      return NULL;
    }

    SmartSheetUtil.syncSmartSheetWithOpp(Long.valueOf(objCase.Smartsheet_Id__c));
    return new PageReference('/' + objCase.Id);
  }
}