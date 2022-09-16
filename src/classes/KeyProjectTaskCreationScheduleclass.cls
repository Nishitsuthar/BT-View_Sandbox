global class KeyProjectTaskCreationScheduleclass implements Schedulable {
    
    /*public static String cron = '0 0 9 * * ? *'; 
    
    global static String scheduleMe() {
        KeyProjectTaskCreationScheduleclass SC = new KeyProjectTaskCreationScheduleclass(); 
        return System.schedule('My batch Job', cron, SC);
    }*/
    
    global void execute(SchedulableContext sc) {
        
        KeyProjectTaskCreationBatch b1 = new KeyProjectTaskCreationBatch();
        ID batchprocessid = Database.executeBatch(b1);           
    }
}