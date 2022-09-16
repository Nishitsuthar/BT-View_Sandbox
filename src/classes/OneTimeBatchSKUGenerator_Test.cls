@isTest
public class OneTimeBatchSKUGenerator_Test
{
    static testMethod void TestMethod1()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 50,     
            'OpptyAccts' => 0, 'BillToAccts' => 0, 'ShipToAccts' => 0, 'SoldToAccts' => 0, 'ContactsPerAcct' => 0, 'OpptysPerOpptyAcct' => 0,
            'QuotesPerOppty' => 0, 'CPOsPerOppty' => 0};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        for (Product2 prod : oetd.prodList)
        {
            prod.family = 'IGU';
        }
        update oetd.prodList;
        Test.startTest();
        OneTimeBatchSKUGenerator otbsg = new OneTimeBatchSKUGenerator();
        Database.executeBatch(otbsg);
        Test.stopTest();

        
    }
}