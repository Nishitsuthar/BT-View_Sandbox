@isTest(seeAllData = true)
private class BaseReport_ConTest{
    static testMethod void test_BaseReport_Con(){
       //Added by ENP - Added Forecast_Status__c in query filter
               Opportunity opp = new Opportunity(
                                            CloseDate = Date.Today()+4, 
                                            Name = 'Opp-0100438691', 
                                            StageName = 'Discovery',
                                            TotalOpportunityQuantity = 1,
                                            Forecast_Status__c='High'
                                        );
        insert opp;

        Pricebook2 pb= [SELECT id FROM Pricebook2 WHERE isStandard=true LIMIT 1]; 
        
        Product2 prod = new Product2(
                                        Name = 'Anti-infectives 2007', 
                                        Family = 'Best Practices', 
                                        IsActive = true,
                                        CanUseQuantitySchedule = true,
                                        CanUseRevenueSchedule = true
                                    );
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
                                                            Pricebook2Id = pb.Id, 
                                                            Product2Id = prod.Id, 
                                                            UnitPrice = 10000, 
                                                            IsActive = true
                                                          );
        insert pbe;
        
        List<opportunitylineitem> oppLineItemLst = new List<opportunitylineitem>();
        oppLineItemLst.add(new opportunitylineitem(
                                                    UnitPrice = 10000.00, 
                                                    Quantity = 10,
                                                    opportunityid = opp.id, 
                                                    pricebookEntryId = PBE.id,
                                                    ServiceDate = Date.Today()
                                                   ));
        insert oppLineItemLst;
        
        OpportunityLineItemSchedule newOppLineItemSchedule = new OpportunityLineItemSchedule();
        newOppLineItemSchedule.OpportunityLineItemId = oppLineItemLst[0].Id;
        newOppLineItemSchedule.Revenue = 0;
        newOppLineItemSchedule.Quantity = 1;
        newOppLineItemSchedule.Type = 'Both';
        newOppLineItemSchedule.ScheduleDate = System.Today()+5;
        insert newOppLineItemSchedule;
                
        Test.startTest();
           BaseReport_Con obj = new BaseReport_Con();
           obj.getOppStages();
           obj.getStatuses();
           BaseReport_Con.getOppData('',new List<String>{'Discovery'},new List<String>{'High'},null,null); //Added by ENP- Passed null value in first parameter.    
        Test.stopTest();
  
    }
    
    //Added by ENP - START
    /*    
    static testMethod void testDate_BaseReport_Con(){
        BaseReport_Con.getScheduleDateFilter(System.Today()+7, System.Today()+3);
    } */
}