public class OrderIntegrationRollbackExt 
{ 
    
    public Order_Entry_Release__c oldOER;
    public String rollbackResults{get;set;}
    RollbackUtils ru = new RollbackUtils();
     
    public OrderIntegrationRollbackExt(ApexPages.StandardController stdController) 
    {
        oldOER = (Order_Entry_Release__c) stdController.getRecord();
        String queryString = 'SELECT Id, ' +  ru.getSelectFields('Order_Entry_Release__c') + ' FROM Order_Entry_Release__c WHERE Id = \'' + String.valueOf(oldOER.id) + '\'';
        oldOER = Database.query(queryString);    
    }
    
    public PageReference rollBackOrder() {
        if (oldOer.Status__c != 'Integration Error') {
            rollbackResults = 'Rollback Failed: You can only roll back Orders whose Status is \'Integration Error\'';
            return null;
        } 
        List<String> errorList = ru.rollbackIntegration(oldOER);
        if (errorList.size() == 0)
        {
            rollbackResults = 'Rollback Successful';
            String clearResult = ru.clearRollbacks(oldOER);
            if (clearResult != 'OK') {
                rollbackResults = rollbackResults + '; Unable to remove the Rollback records because ' + clearResult;
            }
        }
        else
        {
            rollbackResults = 'Rollback Failed:';
            for (String err : errorList)
            {
                rollbackResults = rollbackResults + ' ' + err +';';
            }
        }
        return null;
    }
    
    public PageReference ok()
    {
        return (new ApexPages.StandardController(oldOER)).view();
    }
}