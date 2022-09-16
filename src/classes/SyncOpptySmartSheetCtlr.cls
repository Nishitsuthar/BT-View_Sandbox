public with sharing class SyncOpptySmartSheetCtlr {

	Opportunity opp;

	public SyncOpptySmartSheetCtlr(ApexPages.StandardController std) {		
		opp = [SELECT Id, Smartsheet_Id__c FROM Opportunity WHERE Id = :std.getRecord().Id];
		if(opp.Smartsheet_Id__c == NULL) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter smart sheet id on opportunity to sync'));
		}
	}

	public PageReference doSync() {

		if(opp.Smartsheet_Id__c == NULL) {
			return NULL;
		}

		SmartSheetUtil.syncSmartSheetWithOpp(Long.valueOf(opp.Smartsheet_Id__c));
		return new PageReference('/' + opp.Id);
	}
}