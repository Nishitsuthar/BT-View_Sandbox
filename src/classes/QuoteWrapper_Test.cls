@isTest
public class QuoteWrapper_Test
{
    static testMethod void TestMethod1()
    {
        /*Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 3,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 2,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};*/        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 2);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        QuoteLineItem testQLI;
        SBQQ__QuoteLine__c testCPQQLI;
        QuoteLineWrapper testQLW;
        
        
        for (Quote qte : oetd.quoteList)
        {
            QuoteWrapper qw = new QuoteWrapper(qte);
            for(QuoteLineItem qli: oetd.quoteLineMap.get(qw.quoteId))
            {
                qw.addQuoteLineItem(qli);
                testQLI = qw.getQuoteLine(qli.product2Id);
                testQLW = qw.getQuoteLineWrapper(qli.product2ID);
            }
        }
        for (SBQQ__Quote__c qte : oetd.CPQ_quoteList)
        {
            QuoteWrapper qw = new QuoteWrapper(qte);
            for(SBQQ__QuoteLine__c qli: oetd.CPQ_quoteLineMap.get(qw.quoteId))
            {
                qw.addQuoteLineItem(qli);
                testCPQQLI = qw.getCPQQuoteLine(qli.SBQQ__Product__c);
                testQLW = qw.getQuoteLineWrapper(qli.SBQQ__Product__c);
            }
        }
        
            
        
    }
}