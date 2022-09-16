@isTest
Public class CloneOrderWithLinesTest{
  
 Static testMethod void testmethodClone(){   
   
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
        'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
        'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        Test.stopTest();
        
        PageReference testPageRef = Page.OEDeleteAllLines;
        //PageReference testPageRef = Page.CSS_MassUpdate;
        Test.setCurrentPage(testPageRef);
        ApexPages.currentPage().getParameters().put('Id',oerList[0].Id);
        Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0);  
        //ApexPages.StandardController  sc = new ApexPages.StandardController();
        CloneOrderWithLines pf = new CloneOrderWithLines(new ApexPages.StandardController (oerList[0]));
        pf.CloneOER();
    }
}