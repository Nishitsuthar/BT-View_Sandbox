@isTest(SeeAllData = true)
public class OrderIntegrationRollbackExt_Test
{
    static testMethod void TestMethod1()
    {
        RollbackUtils ru = new RollbackUtils();
        String queryString = 'SELECT Id, ' +  ru.getSelectFields('Order_Entry_Release__c') + ' FROM Order_Entry_Release__c WHERE Status__c = \'Draft\' ORDER BY LastModifiedDate DESC LIMIT 1';
        Order_Entry_Release__c oer = Database.query(queryString);
        Rollback_Order_Entry_Release__c rboer = ru.createOERRollback(oer);
        queryString = 'SELECT Id, ' +  ru.getSelectFields('Order_Entry_Line__c') + ' FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = \'' + String.valueOf(oer.ID) + '\'';           
        List<Order_Entry_Line__c> oelList = Database.query(queryString);
        List<Rollback_Order_Entry_Line__c> rboelList = ru.createOELsRollback(oelList);
        PageReference testPageRef = Page.Order_Integration_Rollback;
        Test.setCurrentPage(testPageRef);
        ApexPages.currentPage().getParameters().put('Id',oer.Id);
              
        ApexPages.StandardController sc = new ApexPages.StandardController(oer);
        OrderIntegrationRollbackExt pageCtrlr = new OrderIntegrationRollbackExt(sc);
        
        Test.startTest();
        pageCtrlr.rollbackOrder();
        oer.Trigger_Source__c = 'Integration';
        oer.Status__c = 'Integration Error';
        update oer;
        queryString = 'SELECT Id, ' +  ru.getSelectFields('Order_Entry_Release__c') + ' FROM Order_Entry_Release__c WHERE id = \'' + String.valueOf(oer.ID) +'\'';
        oer = Database.query(queryString);       
        sc = new ApexPages.StandardController(oer);
        pageCtrlr = new OrderIntegrationRollbackExt(sc);

        pageCtrlr.rollbackOrder();
        pageCtrlr.ok();
        pageCtrlr.rollbackOrder();
        Test.stopTest();
    }
}