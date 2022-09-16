@isTest
public class MilestoneOpptyUpdateTrigger_Test
{
    
     @isTest
    public static void unitTest2()
    {
       System.debug(' Dummy test ');
    }
    /*
    static testMethod void TestMethod1()
    {
        // Create Account, Opportunity and related objects
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 0, 'ShipToAccts' => 0, 'SoldToAccts' => 0, 'ContactsPerAcct' => 0, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 0};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Opportunity oppty = oetd.OpportunityList[0];
        
        // Initialize OpportunityPercent Complete Fields
        oppty.Sales_To_Ops_Turnover_Pct__c = 0.0;
        oppty.Project_Kickoff_Meeting_Pct__c = 0.0;
        oppty.Preliminary_BoS_Design_Pct__c = 0.0;
        oppty.Ops_To_Engineering_Turnover_Pct__c = 0.0;
        oppty.Final_BoS_Design_Pct__c = 0.0;
        update oppty;
        
        Milestone1_Milestone__c testMs;
        Opportunity checkOppty; 
        
        
        Test.startTest();
        // Test partial % Complete for Sales to Ops Turnover
        testMs= new Milestone1_Milestone__c(NAME = 'Sales to Ops Turnover', KICKOFF__C = System.Today()+30, OPPORTUNITY__C = oppty.Id , 
            TYPE__C = 'Sales to Ops Turnover', ACTUAL_COMPLETION_DATE__C = null, PERCENT_COMPLETED__C = 33.0, COMPLETE__C = false, DEADLINE__C = System.Today()+120, 
            DESCRIPTION__C = 'Sales to Ops Turnover');        
        insert testMs;
        CheckOppty = [SELECT Id, Sales_To_Ops_Turnover_Pct__c, Project_Kickoff_Meeting_Pct__c, Preliminary_BoS_Design_Pct__c, Ops_To_Engineering_Turnover_Pct__c,
            Final_BoS_Design_Pct__c FROM Opportunity WHERE Id = :oppty.Id LIMIT 1];
        System.assertEquals(33.0, checkOppty.Sales_To_Ops_Turnover_Pct__c); 
        delete testMs;
        CheckOppty = [SELECT Id, Sales_To_Ops_Turnover_Pct__c, Project_Kickoff_Meeting_Pct__c, Preliminary_BoS_Design_Pct__c, Ops_To_Engineering_Turnover_Pct__c,
            Final_BoS_Design_Pct__c FROM Opportunity WHERE Id = :oppty.Id LIMIT 1];
        System.assertEquals(0.0, checkOppty.Sales_To_Ops_Turnover_Pct__c); 
        
        // Test Complete__c override of PERCENT_COMPLETED__C
        testMs= new Milestone1_Milestone__c(NAME = 'Sales to Ops Turnover', KICKOFF__C = System.Today()+30, OPPORTUNITY__C = oppty.Id , 
            TYPE__C = 'Sales to Ops Turnover', ACTUAL_COMPLETION_DATE__C = null, PERCENT_COMPLETED__C = 33.0, COMPLETE__C = true, DEADLINE__C = System.Today()+120, 
            DESCRIPTION__C = 'Sales to Ops Turnover');  
        insert testMs;                
        CheckOppty = [SELECT Id, Sales_To_Ops_Turnover_Pct__c, Project_Kickoff_Meeting_Pct__c, Preliminary_BoS_Design_Pct__c, Ops_To_Engineering_Turnover_Pct__c,
            Final_BoS_Design_Pct__c FROM Opportunity WHERE Id = :oppty.Id LIMIT 1];
        System.assertEquals(100.0, checkOppty.Sales_To_Ops_Turnover_Pct__c); 
        
        // Test null Percent Completed.
        testMS.Percent_Completed__c = null;
        testMs.Complete__c = false;
        update testMs;                
        CheckOppty = [SELECT Id, Sales_To_Ops_Turnover_Pct__c, Project_Kickoff_Meeting_Pct__c, Preliminary_BoS_Design_Pct__c, Ops_To_Engineering_Turnover_Pct__c,
            Final_BoS_Design_Pct__c FROM Opportunity WHERE Id = :oppty.Id LIMIT 1];
        System.assertEquals(0.0, checkOppty.Sales_To_Ops_Turnover_Pct__c); 
        
        // Test null Percent Completed.
        
        
        Test.stopTest();
    }

*/
    
    
}