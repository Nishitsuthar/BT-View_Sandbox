@isTest
public class TestFactoryProgressStatusTo
{
    static testMethod void testTFPST1()
    {
        //
        // Create the entityCounts map specifying the number of each object to be created
        //
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 3,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 2,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
            
        //
        // Create the Non-Order Entry objects
        //
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);

        //
        // Create some Order Entry Releses
        //
    
        List<Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)');
        
        //
        // Create the Order Entry Lines
        //
        Map<Id, List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oetd.oerList, 2);
        Test.startTest();
        OETestDataFactory.progressStatusTo(oetd.oelMap.keySet(), 'Shipped', oetd);
        Test.stopTest();
    }
}