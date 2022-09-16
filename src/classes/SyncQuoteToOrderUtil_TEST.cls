// 06-Jan-2021			Srikanth		DealDesk SOP Findinds DD_SOP_Findings_Jan_2021			DealDesk SOP Findings
@isTest
private class SyncQuoteToOrderUtil_TEST {
    
    /*
    @testSetup
    private static void createTestData() {

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 2,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};

        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases_CH(oetd, 1, '','CPQ');
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
 
    } */  


    @isTest
    private static void testCase1() {

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};

        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases_CH(oetd, 1, '','CPQ');
		        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);

        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];


        ApexPages.currentPage().getParameters().put('id', String.valueOf(quote.Id));
        Apexpages.StandardController sc = new Apexpages.StandardController(quote);
        RefreshRelatedOrderInfoController ctlr = new RefreshRelatedOrderInfoController(sc);
        ctlr.syncQuoteWithOrders();
        Test.stopTest();

    } 

    @isTest
    private static void testCase2() {

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};

        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases_CH(oetd, 1, '','CPQ');
		        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);

        Quote quote = [SELECT Id FROM Quote LIMIT 1];

        ApexPages.currentPage().getParameters().put('id', String.valueOf(quote.Id));
        Apexpages.StandardController sc = new Apexpages.StandardController(quote);
        RefreshRelatedOrderInfoController ctlr = new RefreshRelatedOrderInfoController(sc);
        ctlr.syncQuoteWithOrders();
        Test.stopTest();

    } 

    @isTest
    private static void testCase3() {

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};

        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases_CH(oetd, 1, '','CPQ');
		        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);

        Quote quote = [SELECT Id FROM Quote LIMIT 1];

        Order_Entry_Release__c oer = [SELECT Id FROM Order_Entry_Release__c WHERE CPQ_Quote__c != NULL LIMIT 1];

        ApexPages.currentPage().getParameters().put('id', String.valueOf(oer.Id));
        Apexpages.StandardController sc = new Apexpages.StandardController(oer);
        RefreshQuoteRefController ctlr = new RefreshQuoteRefController(sc);
        ctlr.syncOrderWithQuote();
        ctlr.backToOERPage();
        Test.stopTest();

    }

    @isTest
    private static void testCase4() {

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};

        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases_CH(oetd, 1, '','CPQ');
		        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);

        Quote quote = [SELECT Id FROM Quote LIMIT 1];
        Order_Entry_Release__c oer = [SELECT Id, CPQ_Quote__c, Quote__c FROM Order_Entry_Release__c LIMIT 1];

        oer.CPQ_Quote__c = NULL;
        oer.Quote__c = quote.Id;
        update oer;

        ApexPages.currentPage().getParameters().put('id', String.valueOf(oer.Id));
        Apexpages.StandardController sc = new Apexpages.StandardController(oer);
        RefreshQuoteRefController ctlr = new RefreshQuoteRefController(sc);
        ctlr.syncOrderWithQuote();
        ctlr.backToOERPage();
        Test.stopTest();

    }

    @isTest
    private static void testCase5() {

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
    
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);

        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases_CH(oetd, 1, '','');
		        Test.startTest();
        OETestDataFactory.associateOELsToQLs = FALSE;
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1, 'Control_Hardware');


        Order_Entry_Release__c oer = [SELECT Id, CPQ_Quote__c, Quote__c, (SELECT Id, Product__c, CPQ_Quote_Line__c FROM Order_Entry_Lines__r) FROM Order_Entry_Release__c WHERE Quote__c != NULL LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', String.valueOf(oer.Id));
        Apexpages.StandardController sc = new Apexpages.StandardController(oer);
        RefreshQuoteRefController ctlr = new RefreshQuoteRefController(sc);
        ctlr.syncOrderWithQuote();
        ctlr.backToOERPage();
        Test.stopTest();

    }

    @isTest
    private static void testCase6() {

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
    
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);

        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases_CH(oetd, 1, '','');
		        Test.startTest();
        OETestDataFactory.associateOELsToQLs = FALSE;
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1, 'Control_Hardware');

        Order_Entry_Release__c oer = [SELECT Id, CPQ_Quote__c, Quote__c, (SELECT Id, Product__c, CPQ_Quote_Line__c FROM Order_Entry_Lines__r) FROM Order_Entry_Release__c WHERE Quote__c != NULL LIMIT 1];
        QuoteLineItem qlItem = [SELECT Id FROM QuoteLineItem WHERE QuoteId = :oer.Quote__c LIMIT 1];
        delete qlItem;


        ApexPages.currentPage().getParameters().put('id', String.valueOf(oer.Id));
        Apexpages.StandardController sc = new Apexpages.StandardController(oer);
        RefreshQuoteRefController ctlr = new RefreshQuoteRefController(sc);
        ctlr.syncOrderWithQuote();
        ctlr.backToOERPage();
        Test.stopTest();

    }
	
	

}