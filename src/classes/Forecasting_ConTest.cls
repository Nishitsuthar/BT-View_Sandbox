@isTest(seeAllData = true)
private class Forecasting_ConTest{
    static testMethod void test_Forecasting_Con(){
               Opportunity opp = new Opportunity(
                                            CloseDate = Date.Today(), 
                                            Name = 'Opp-0100438691', 
                                            StageName = 'Discovery',
                                            TotalOpportunityQuantity = 1
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
        newOppLineItemSchedule.ScheduleDate = System.Today();
        insert newOppLineItemSchedule;
                
        Test.startTest();
           Forecasting_Con obj = new Forecasting_Con();
           Forecasting_Con.getData(
                       new List<String>{'Discovery'},
                       new List<String>{'High'},
                       1,
                       '2014',
                       'Month',
                       1
                       );
           Forecasting_Con.getData(
                       new List<String>{'Discovery'},
                       new List<String>{'High'},
                       1,
                       '2014',
                       'Quarter',
                       1
                       );
           obj.getYears();
           obj.getQuarters();
           obj.getMonths();
           obj.getRangePeriods();
           obj.getOppStages();
           obj.getStatuses();

        Test.stopTest();
    }
}