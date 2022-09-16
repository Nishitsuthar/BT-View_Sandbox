@isTest
public class UpdateScheduleControllerTest
{
    
    
    @isTest
    public static void unitTest()
    {
        UpdateScheduleController.decommissionMilestone();
    }
    
}

/*
    static testMethod void test_UpdateScheduleController(){
        
        Opportunity opp = new Opportunity(
                                            CloseDate = Date.Today(), 
                                            Name = 'Opp-0100438691', 
                                            StageName = 'Pending',
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
        
        Milestone1_Project__c proj = new Milestone1_Project__c();
        proj.Name = 'test project';
        proj.Status__c   =   'Active';
        proj.Kickoff__c  =   Date.today().addDays(-14);
        proj.Deadline__c =   Date.today().addDays(14);
        insert proj;
        
        Milestone1_Milestone__c rec = new Milestone1_Milestone__c();
        rec.Opportunity__c = opp.Id;
        rec.Type__c='IGU Ship Phase';
        rec.Quantity__c = 1;
        rec.Phase__c = 4;
        rec.Name = proj.Name + '' + Datetime.now().getTime();
        rec.Project__c = proj.id;
        rec.Complete__c = false; //getRandomBool(.25);
        rec.Kickoff__c = proj.Kickoff__c;
        rec.Deadline__c = proj.Deadline__c;
        rec.Description__c = 'Description for ' + rec.Name;
        rec.Expense_Budget__c = Math.floor(Math.random() * 50000 * 100) / 100;
        rec.Hours_Budget__c = Math.floor(Math.random() * 500 * 100) / 100;
        insert rec;
        
        ApexPages.CurrentPage().getparameters().put('id', opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        UpdateScheduleController sic = new UpdateScheduleController(sc);
        
        Test.startTest();
        sic.updateSchedule();
        Test.stopTest();
    }
    
    //Added by ENP - START
    static testMethod void test_UpdateSchedule(){
        
            Opportunity opp = new Opportunity(
                                            CloseDate = Date.Today(), 
                                            Name = 'Opp-0100438691', 
                                            StageName = 'Pending',
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
        
        Milestone1_Project__c proj = new Milestone1_Project__c();
        proj.Name = 'test project';
        proj.Status__c   =   'Active';
        proj.Kickoff__c  =   Date.today().addDays(-14);
        proj.Deadline__c =   Date.today().addDays(14);
        insert proj;
        
        Milestone1_Milestone__c rec = new Milestone1_Milestone__c();
        rec.Opportunity__c = opp.Id;
        rec.Type__c='IGU Ship Phase';
        rec.Quantity__c = 1;
        rec.Phase__c = 4;
        rec.Name = proj.Name + '' + Datetime.now().getTime();
        rec.Project__c = proj.id;
        rec.Complete__c = false; //getRandomBool(.25);
        rec.Kickoff__c = proj.Kickoff__c;
        rec.Deadline__c = null;
        rec.Description__c = 'Description for ' + rec.Name;
        rec.Expense_Budget__c = Math.floor(Math.random() * 50000 * 100) / 100;
        rec.Hours_Budget__c = Math.floor(Math.random() * 500 * 100) / 100;
        insert rec;
        
        ApexPages.CurrentPage().getparameters().put('id', opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        UpdateScheduleController sic = new UpdateScheduleController(sc);
        
        Test.startTest();
        sic.updateSchedule();
        Test.stopTest();
        
    }   
    //Added by ENP - END
    //*/