/*
        Name           : VOpportunityProductTriggerHandlerTest
        Author         : AV
        Reviewer       : Veltig Dev, Ashwani
        Date           : 21st April 2015
        Description    : Test class of VOpportunityProductTriggerHandlerTest
*/

@isTest
public class VOpportunityProductTriggerHandlerTest
{
    // test method
    @isTest
    private static void test()
    {
        // Create test Account
        Account acc = VTestDataUtility.getTestAccount();
        insert acc;
        
        // Create test Opportunity
        Opportunity opp = VTestDataUtility.getTestOpportunity(acc.Id);
        insert opp;

        // Create test Product
        Product2 prod = VTestDataUtility.getTestProduct();
        insert prod;
        
        // Create test Pricebook
        Pricebook2 pb = VTestDataUtility.getTestPriceBook();
        insert pb;
        
        // Create test PricebookEntry
        PricebookEntry pbe = VTestDataUtility.getTestPricebookEntry(Test.getStandardPricebookId(), prod.Id);
        insert pbe;
        
        // Create test OpportunityLineItem
        OpportunityLineItem opli = VTestDataUtility.getTestOpportunityLineItem(opp.Id,pbe.Id);
        insert opli;
        
        // Create test OpportunityLineItemSchedule
        OpportunityLineItemSchedule opliSch = VTestDataUtility.getTestOpportunityLineItemSchedule(opli.Id);
        insert opliSch;
        
        // update service date
        opli.ServiceDate = date.today().addDays(2);
        update opli;
        
        List<OpportunityLineItemSchedule> listOpliSche = [select Id,ScheduleDate from OpportunityLineItemSchedule];
        
        // assert
        system.assertEquals(listOpliSche[0].ScheduleDate,opli.ServiceDate);
    }
}