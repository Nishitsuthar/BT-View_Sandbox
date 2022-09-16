public class PhaseDeleteAllLinesExt
{
    public Project_Phase_Plan__c pplan{get;set;}
    public String deleteWarning{get;set;}
    public Boolean deleteOK{get;set;}
    public Boolean showCancel{get;set;}
    public Boolean showClose{get;set;}
    public Set<String> deleteAllOK  = new Set<String> {'Draft', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed'};
    public PageReference currentPage = ApexPages.currentPage();
    
    public PhaseDeleteAllLinesExt(ApexPages.StandardSetController stdSetController) 
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
            pplan = [SELECT Id, Name FROM Project_Phase_Plan__c WHERE Id = :id LIMIT 1];
        }
        if (pplan == null)
        {
            ApexPages.Message noOEError = new ApexPages.Message(ApexPages.Severity.ERROR,'** ERROR - Unable to retrieve the Project Phase Plan Information');
            ApexPages.addMessage(noOEError);
            showClose = true;
            showCancel = false;         
        }
        else
        {
            
                deleteWarning = 'WARNING: You have requested the deletion of all Project Phase for Project Phase Plan ' + pplan.Name  + '<br>'+
                'Click the Continue button to confirm deletion; click the Cancel button to return to the OProject Phase Plan Without deleting the Lines';
                deleteOK = true;
          
        }
    
    }
    
    public PageReference close()
    {
       //return new PageReference('javascript:window.self.close()');
        return new PageReference('/'+pplan.Id);
    }
    
    public PageReference deleteAllLines()
    {
        List<Database.DeleteResult> drList = new List<Database.DeleteResult>();
        Boolean hasErrors = false;
        List<Project_Phase__c> linesToDelete = [SELECT Id, Project_Phase_Plan__c FROM Project_Phase__c WHERE Project_Phase_Plan__c = :pplan.Id];
        
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
                        databaseErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '*** An error occurred deleting Project Phase ID ' + 
                            String.valueOf(linesToDelete[i].id) + '; ' + err.getMessage());
                        ApexPages.addMessage(databaseErrorMsg);
                    }
                }
                i++;
            }
        }
        if (hasErrors)
        {
            deleteWarning = 'Errors occurred while trying to delete the Project Phases; click the Cancel button to return to the Order Entry Release Page';
        }
        else
        {
            deleteWarning = String.valueOf(linesToDelete.size()) + ' Project Phase were successfully deleted.<br>' +
                'Close this window and then refresh the Project Phase Plan page to see the results';
        }
        deleteOK = false;
        showClose = true;
        showCancel = false;
        
        

        return currentPage;
 
        
    }
}