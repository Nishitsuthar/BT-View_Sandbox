@isTest
public class createMilestoneTest{
    
    
     @isTest
    public static void unitTest1()
    {
       System.debug(' Dummy test ');
    }

    /*
    static testMethod void test_createMilestone(){
    
        Milestone_Config__c config = new Milestone_Config__c(
                                                                Name = 'test milestone',
                                                                Type__c='test'
                                                            );
        insert config;
        Test.startTest();
            Opportunity opp = new Opportunity(
                                                CloseDate = Date.Today(), 
                                                Name = 'Opp-0100438691', 
                                                StageName = 'Booked'
                                            );
            insert opp;
        Test.stopTest();
    }
*/
}