@isTest
private class OpportunityTracking_ConTest{
    static testMethod void test_OpportunityTracking_Con(){
        Opportunity opp = new Opportunity(
                                            CloseDate = Date.Today(), 
                                            Name = 'Opp-0100438691', 
                                            StageName = 'Pending',
                                            Glass_Price__c = 5,
                                            TotalOpportunityQuantity = 1
                                        );
        insert opp;
        
        ApexPages.CurrentPage().getparameters().put('id', opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityTracking_Con sic = new OpportunityTracking_Con(sc);
        
        Test.startTest();
           // sic.getMilestoneTypes();
            sic.getOppStages();
            OpportunityTracking_Con.getOpportunityData(new List<String>{''},
                                                       new List<String>{''},
                                                       String.valueOf(Date.Today()),
                                                       String.valueOf(Date.Today()),
                                                       '',
                                                       '',
                                                       String.valueOf(Date.Today()),
                                                       String.valueOf(Date.Today()));
        Test.stopTest();
    }
}