@isTest
public class TestOEDF
{
    static testMethod void testOEDF1()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 3,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 2,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        
        System.Debug('***  prodList  Size =  '  +  oetd.prodList.size());
        System.Debug('***  pbeToProdMap  Size =  '  +  oetd.pbeToProdMap.size());
        System.Debug('***  prodToPBEMap  Size =  '  +  oetd.prodToPBEMap.size());
        System.Debug('***  adminUserList  Size =  '  +  oetd.adminUserList.size());
        System.Debug('***  userList  Size =  '  +  oetd.userList.size());
        System.Debug('***  billToAcctList  Size =  '  +  oetd.billToAcctList.size());
        System.Debug('***  soldToAcctList  Size =  '  +  oetd.soldToAcctList.size());
        System.Debug('***  shipToAcctList  Size =  '  +  oetd.shipToAcctList.size());
        System.Debug('***  opptyAcctList  Size =  '  +  oetd.opptyAcctList.size());
        System.Debug('***  opportunityList  Size =  '  +  oetd.opportunityList.size());
        System.Debug('***  opptyMap  Size =  '  +  oetd.opptyMap.size());
        System.Debug('***  opptyIdMap  Size =  '  +  oetd.opptyIdMap.size());
        System.Debug('***  opptyProdMap  Size =  '  +  oetd.opptyProdMap.size());
        System.Debug('***  quoteList  Size =  '  +  oetd.quoteList.size());
        System.Debug('***  quoteMap  Size =  '  +  oetd.quoteMap.size());
        System.Debug('***  quoteLineMap  Size =  '  +  oetd.quoteLineMap.size());
        System.Debug('***  custPOMap  Size =  '  +  oetd.custPOMap.size());
        System.Debug('***  oerList  Size =  '  +  oetd.oerList.size());
        System.Debug('***  oelMap  Size =  '  +  oetd.oelMap.size());
        System.Debug('***  contactMap  Size =  '  +  oetd.contactMap.size());

        System.Debug('***  prodList Id =  '  +  oetd.prodList[0].Id);
        System.Debug('***  pbeToProdMap Id =  '  +  oetd.pbeToProdMap.values()[0]);
        System.Debug('***  prodToPBEMap Id =  '  +  oetd.prodToPBEMap.values()[0]);
        System.Debug('***  adminUserList Id =  '  +  oetd.adminUserList[0].Id);
        System.Debug('***  userList Id =  '  +  oetd.userList[0].Id);
        System.Debug('***  billToAcctList Id =  '  +  oetd.billToAcctList[0].Id);
        System.Debug('***  soldToAcctList Id =  '  +  oetd.soldToAcctList[0].Id);
        System.Debug('***  shipToAcctList Id =  '  +  oetd.shipToAcctList[0].Id);
        System.Debug('***  opptyAcctList Id =  '  +  oetd.opptyAcctList[0].Id);
        System.Debug('***  opportunityList Id =  '  +  oetd.opportunityList[0].Id);
        System.Debug('***  opptyMap Id =  '  +  oetd.opptyMap.values()[0][0].Id);
        System.Debug('***  opptyIdMap Id =  '  +  oetd.opptyIdMap.values()[0].Id);
        System.Debug('***  opptyProdMap Id =  '  +  oetd.opptyProdMap.values()[0][0].Id);
        System.Debug('***  quoteList Id =  '  +  oetd.quoteList[0].Id);
        System.Debug('***  quoteMap Id =  '  +  oetd.quoteMap.values()[0][0].Id);
        System.Debug('***  quoteLineMap Id =  '  +  oetd.quoteLineMap.values()[0][0].Id);
        System.Debug('***  custPOMap Id =  '  +  oetd.custPOMap.values()[0][0].Id);
        System.Debug('***  contactMap Id =  '  +  oetd.contactMap.values()[0][0].Id);

        List<Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 3, 'Imperial (US Standard)','CPQ');
        System.Debug('***  oetd.oerList  Size =  '  +  oetd.oerList.size());
        System.Debug('*** oetd.List Id =  '  +  oetd.oerList[0].Id);
        Map<Id, List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oetd.oerList, 2);
        System.Debug('***  oelMap  Size =  '  +  oetd.oelMap.size());
        System.Debug('***  oelMap Id =  '  +  oetd.oelMap.values()[0][0].Id);
    }
}