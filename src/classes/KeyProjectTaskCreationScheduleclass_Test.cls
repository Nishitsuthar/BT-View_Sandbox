@isTest
global class KeyProjectTaskCreationScheduleclass_Test {

    @isTest static void testschedule() {
     
        KeyProjectTaskCreationScheduleclass sh1 = new KeyProjectTaskCreationScheduleclass();
        String sch = '0 0 4 * * ?'; 
        system.schedule('Test Check', sch, sh1); 
    }   
}