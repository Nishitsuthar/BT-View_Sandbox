@isTest(SeeAllData = true)
public class RollbackUtils_Test
{
    static testMethod void TestMethod1()
    {
        test.startTest();
        RollbackUtils ru = new RollbackUtils();
        
        String queryString = 'SELECT Id, ' +  ru.getSelectFields('Order_Entry_Release__c') + ' FROM Order_Entry_Release__c WHERE Status__c = \'Invoiced\' ORDER BY LastModifiedDate DESC LIMIT 1';
        Order_Entry_Release__c oer = Database.query(queryString);
        Rollback_Order_Entry_Release__c rboer = ru.createOERRollback(oer);
        queryString = 'SELECT Id,CreatedDate,' +  ru.getSelectFields('Rollback_Order_Entry_Release__c') + ' FROM Rollback_Order_Entry_Release__c WHERE Id = \'' + 
            String.valueOf(rboer.Id) + '\''; 
        rboer = Database.query(queryString);             
        System.debug('*** Test: Rollback OER: Id = ' +String.valueOf(rboer.id) + '; CreatedDate = ' + String.valueOf(rboer.CreatedDate) +  '; ' + String.valueOf(rboer));
        queryString = 'SELECT Id, ' +  ru.getSelectFields('Order_Entry_Line__c') + ' FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = \'' + oer.id + '\'';
        List<Order_Entry_Line__c> oelsForRollback = Database.query(queryString);
        List<Rollback_Order_Entry_Line__c> rboelList = ru.createOELsRollback(oelsForRollback);
        System.debug('*** Test: Rollback OEL List: ' + String.valueOf(rboelList));

        List<String> errorList = ru.rollbackIntegration(oer);
        try {
            errorList = ru.rollbackIntegration(oer);
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
        rboer.Status__c = 'Bad Status';
        update rboer;
        try {
            errorList = ru.rollbackIntegration(oer);
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
        String clearResult = ru.clearRollbacks(oer);
        try {
            errorList = ru.rollbackIntegration(oer);
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
        
        Test.stopTest();
    }
}