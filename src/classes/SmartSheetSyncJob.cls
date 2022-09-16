global class SmartSheetSyncJob implements Schedulable {
	global void execute(SchedulableContext sc) {

		Smartsheet_Config__c config = Smartsheet_Config__c.getOrgDefaults();
		if(config != NULL && config.Sync_Job_Time_Interval__c > 0) {
			Datetime sheetsUpdatedSince = System.now().addMinutes(Integer.valueOf(-3 * config.Sync_Job_Time_Interval__c));
			SmartSheetUtil.syncSmartSheets(sheetsUpdatedSince);
		}
		//Schedule next job
		scheduleNextRun();
	}

	 public static void scheduleNextRun() {
        // start keepalive again after next time interval
        Smartsheet_Config__c config = Smartsheet_Config__c.getOrgDefaults();
        Datetime sysTime = System.now().addMinutes( Integer.valueOf( config.Sync_Job_Time_Interval__c) );      
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule( 'Smartsheet Sync Job - ' + sysTime, chronExpression, new SmartSheetSyncJob() );
    }
}