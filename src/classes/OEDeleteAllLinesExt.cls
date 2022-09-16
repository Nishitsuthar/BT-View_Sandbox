public class OEDeleteAllLinesExt
{
    public Order_Entry_Release__c oer{get;set;}
    public String deleteWarning{get;set;}
    public Boolean deleteOK{get;set;}
    public Boolean showCancel{get;set;}
    public Boolean showClose{get;set;}
    public Set<String> deleteAllOK  = new Set<String> {'Draft', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed'};
    public PageReference currentPage = ApexPages.currentPage();
    
    public OEDeleteAllLinesExt(ApexPages.StandardSetController stdSetController) 
    {
        //
        // Get the Order Release Information
        //
        deleteOK = false;
        showCancel = true;
        showClose = false;
        Id id = ApexPages.CurrentPage().getParameters().get('id');
        if (id != null)
        {
            System.debug('OER ID = ' + String.valueOf(id));
            oer = [SELECT Id, Name, Release_Name__c, Status__c FROM Order_Entry_Release__c WHERE Id = :id LIMIT 1];
        }
        if (oer == null)
        {
            ApexPages.Message noOEError = new ApexPages.Message(ApexPages.Severity.ERROR,'** ERROR - Unable to retrieve the Order Entry Release Information');
            ApexPages.addMessage(noOEError);
            showClose = true;
            showCancel = false;         
        }
        else
        {
            if (deleteAllOK.contains(oer.Status__c))
            {
                deleteWarning = 'WARNING: You have requested the deletion of all Order Entry Lines for Order Entry Release Id ' + oer.Name + ' - ' + oer.Release_Name__c + '<br>'+
                'Click the Continue button to confirm deletion; click the Cancel button to return to the Order Entry Releae Without deleting the Lines';
                deleteOK = true;
            }
            else
            {
                deleteWarning = 'Error: Order Entry Lines may not be deleted when Order Entry Release Status is ' + oer.Status__c;
                showClose = true;
                showCancel = false;         
                
            }
        }
    
    }
    
    public PageReference close()
    {
       //return new PageReference('javascript:window.self.close()');
       return new PageReference('/'+oer.Id);
    }
    
    public PageReference deleteAllLines()
    {
        List<Database.DeleteResult> drList = new List<Database.DeleteResult>();
        Boolean hasErrors = false;
        List<Order_Entry_Line__c> linesToDelete = [SELECT Id, Order_Entry_Release__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :oer.Id];
        
        if (linesToDelete.size() > 0)
        {
            ApexPages.Message databaseErrorMsg;
            drList = Database.delete(linesToDelete, true);
            Integer i = 0;      

            for(Database.DeleteResult dr : drList) 
            {
                if (!dr.isSuccess())
                {
                    hasErrors = true;
                    for(Database.Error err : dr.getErrors()) 
                    {
                        databaseErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '*** An error occurred deleting Order Entry Line ID ' + 
                            String.valueOf(linesToDelete[i].id) + '; ' + err.getMessage());
                        ApexPages.addMessage(databaseErrorMsg);
                    }
                }
                i++;
            }
        }
        if (hasErrors)
        {
            deleteWarning = 'Errors occurred while trying to delete the order entry lines; click the Cancel button to return to the Order Entry Release Page';
        }
        else
        {
            deleteWarning = String.valueOf(linesToDelete.size()) + ' Order Entry Lines were successfully deleted.<br>' +
                'Close this window and then refresh the Order Entry Release page to see the results';
        }
        deleteOK = false;
        showClose = true;
        showCancel = false;
        
        

        return currentPage;
 
        
    }
}