@isTest(seealldata=true)
public class TestCreateQuoteCtrl {
    private static TestMethod void testCreateQuote(){
        
        Account acc = new Account(
            Name = 'TestAccount'
        );
        insert acc;
        
        Contact con = new Contact(LastName = 'Test Con', AccountId = acc.id);
        insert con;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opp', 
            StageName = 'Qualified',
            CloseDate = System.today(),
            AccountId = acc.id
        );
        insert opp;
        
        Product2 newProd = new Product2(Name = 'test product', family = 'test family',isActive = true);
        insert newProd;
        
        PriceBookEntry pbe = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id = [select id from PriceBook2 where isStandard = true].Id,
            Product2Id = newProd.Id,
            isActive = true
        );
        insert pbe;
        
        opp.PriceBook2Id = pbe.PriceBook2Id;
        update opp;
        
        /*PricebookEntry pbe = [Select p.Pricebook2Id, p.Id, p.UnitPrice From PricebookEntry p 
                                where p.Pricebook2.IsActive = true 
                                and p.IsActive = true
                                limit 1];*/
        
        OpportunityLineItem pli = new OpportunityLineItem(UnitPrice = pbe.UnitPrice, Quantity = 1, 
            PricebookEntryId = pbe.id, OpportunityId = opp.Id); 
        insert pli;
        
        opp.StageName = 'Closed Won';
        //update opp;
        
        OpportunityLineItem pli1 = new OpportunityLineItem(UnitPrice = pbe.UnitPrice, Quantity = 1, 
            PricebookEntryId = pbe.id, OpportunityId = opp.Id); 
        insert pli1;
        
        ApexPages.currentPage().getParameters().put('oppid', opp.id);
        CreateQuoteCtrl ctrl = new CreateQuoteCtrl();
        ctrl.qtRec.Quote_Type__c = 'Glass';
        ctrl.selCont = con.id;
        ctrl.rowToRemove = 0;
        ctrl.doSave();
        ctrl.filterProducts();
        ctrl.addNewRowToList();
        ctrl.removeRowFromList();
        ctrl.backToOpp();
        ctrl.onChangeProd();
        ctrl.queryContOptions();
        
        ApexPages.currentPage().getParameters().put('oPB', pbe.PriceBook2Id);
        LookupPopupController obj = new LookupPopupController();
    }
}