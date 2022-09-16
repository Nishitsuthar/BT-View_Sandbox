@isTest
public class Order_Entry_Line_BD_AD_Test
{
    static testMethod void TestMethod1()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 2, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 1};    
        Test.startTest();        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
         Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 3);
        
        delete oelMap.get(oerList[0].id)[2];
       
    }
}