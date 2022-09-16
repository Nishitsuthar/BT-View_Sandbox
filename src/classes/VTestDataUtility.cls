/*
        Name           : VTestDataUtility
        Author         : AV
        Reviewer       : Veltig Dev, Ashwani
        Date           : 21st April 2015
        Description    : This controller provides test data for test classes. VOpportunityProductTriggerHandlerTest
*/

public class VTestDataUtility
{
    // get test account
    public static Account getTestAccount()
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        return acc;
    }
    
    // get test Opportunity
    // @param: Id of Account
    public static Opportunity getTestOpportunity(Id accId)
    {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = accId;
        opp.Book_Date__c = date.today();
        opp.closeDate = Date.today();
        opp.StageName = 'Discovery';
        return opp;
    }
    
    // get test Product
    public static Product2 getTestProduct()
    {
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true, Family = 'Test Family',CanUseQuantitySchedule=true);
        return prod;
    }
    
    // get test PriceBook
    public static Pricebook2 getTestPriceBook()
    {
        Pricebook2 pb = new Pricebook2(Name = 'Test priceBook', IsActive = true);
        return pb;
    }
    
    // get test PricebookEntry
    // @param: Id of pricebook and product
    public static PricebookEntry getTestPricebookEntry(Id priceBookId, Id productId)
    {
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = priceBookId, product2Id = productId, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        return pbe;
    }
    
    // get test opportunitylineitem
    // @param: id of Opportunity Id and PricebookEntry ID
    public static OpportunityLineItem getTestOpportunityLineItem(Id oppId, Id priceBookEntryId)
    {
        OpportunityLineItem opli = new OpportunityLineItem(OpportunityId=oppId,pricebookentryId = priceBookEntryId, UnitPrice = 100, Quantity = 5,ServiceDate=date.today().addDays(1));
        return opli;
    }
    
    // get test opportunitylineitemshcedule
    // @param: ID of Opportunity Product record
    public static OpportunityLineItemSchedule getTestOpportunityLineItemSchedule(Id opliId)
    {
        OpportunityLineItemSchedule opliSch = new OpportunityLineItemSchedule(OpportunityLineItemId=opliId,Quantity=5,ScheduleDate=system.today(),Type='Quantity');
        return opliSch;
    }
}