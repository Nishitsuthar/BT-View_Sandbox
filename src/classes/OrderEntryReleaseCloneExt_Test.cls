@isTest
public class OrderEntryReleaseCloneExt_Test
{
    static testMethod void TestMethod1()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1}; 
        Test.startTest();
            OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
            List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ', Label.CSS_Hardware);
            //Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Test.stopTest();
        PageReference testPageRef = Page.OERCloneAndEdit;
        Test.setCurrentPage(testPageRef);
        ApexPages.currentPage().getParameters().put('Id',oerList[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(oerList[0]);
        OrderEntryReleaseCloneExt pageCtrlr = new OrderEntryReleaseCloneExt(sc);
        pageCtrlr.cloneOER();        
    }
    
    static testMethod void TestMethod2()
    {
        // Test changes to Order Entry Release Edit Extension
        //
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 2, 'Imperial (US Standard)','CPQ');
        Test.stopTest();
        
        PageReference testPageRef = Page.OrderEntryReleaseEdit;
        Test.setCurrentPage(testPageRef);
        ApexPages.currentPage().getParameters().put('Id',oerList[0].Id);
        ApexPages.currentPage().getParameters().put('isClone','true');
        ApexPages.currentPage().getParameters().put('clonedId',oerList[1].Id);
              
        ApexPages.StandardController sc = new ApexPages.StandardController(oerList[0]);
        OrderEntryReleaseEditExt pageCtrlr = new OrderEntryReleaseEditExt(sc);
        
        
        pageCtrlr.cancel();
        //Test.stopTest();
    }   
    
    
    
}