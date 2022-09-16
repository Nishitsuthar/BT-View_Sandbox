@isTest
public class OEDeleteAllLines_Test
{
    static testMethod void TestMethod1()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};        
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Test.stopTest();
         Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        
        PageReference testPageRef = Page.OEDeleteAllLines;
        Test.setCurrentPage(testPageRef);
        ApexPages.currentPage().getParameters().put('Id',oerList[0].Id);
              
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(oelMap.get(oerList[0].Id));
        OEDeleteAllLinesExt pageCtrlr = new OEDeleteAllLinesExt(sc);
        
        
        pageCtrlr.deleteAllLines();
        
    }   
    
    static testMethod void TestMethod2()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};        
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        
        PageReference testPageRef = Page.OEDeleteAllLines;
        Test.setCurrentPage(testPageRef);
        ApexPages.currentPage().getParameters().put('Id',oerList[0].Id);
              
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(oelMap.get(oerList[0].Id));
        OEDeleteAllLinesExt pageCtrlr = new OEDeleteAllLinesExt(sc);
        
        
        pageCtrlr.close();
        
    }   

    
    static testMethod void TestMethod3()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};        
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
       Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        
        PageReference testPageRef = Page.OEDeleteAllLines;
        Test.setCurrentPage(testPageRef);
        ApexPages.currentPage().getParameters().put('Id',null);
              
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(oelMap.get(oerList[0].Id));
        OEDeleteAllLinesExt pageCtrlr = new OEDeleteAllLinesExt(sc);
        
        
        //pageCtrlr.close();
        
    }   

    static testMethod void TestMethod4()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1}; 
         
        Test.startTest();  
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        oelMap.get(oerList[0].Id)[0].id = Id.valueOf(String.valueOf(oelMap.get(oerList[0].Id)[0].id).substring(0,17) + 'a');
        
        PageReference testPageRef = Page.OEDeleteAllLines;
        Test.setCurrentPage(testPageRef);
        ApexPages.currentPage().getParameters().put('Id',oerList[0].Id);
              
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(oelMap.get(oerList[0].Id));
        OEDeleteAllLinesExt pageCtrlr = new OEDeleteAllLinesExt(sc);
        
        
        pageCtrlr.deleteAllLines();
        
    }   
    
}