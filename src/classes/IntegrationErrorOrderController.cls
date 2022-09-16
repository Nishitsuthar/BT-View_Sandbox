public with sharing class IntegrationErrorOrderController {
    public String oerId{get;set;}
    Public Order_Entry_Release__c oer;
    
    public IntegrationErrorOrderController(ApexPages.StandardController controller) {
        
         oerId = ApexPages.currentPage().getParameters().get('id');
         oer=[select Id,name,RecordTypeId,Integration_Status__c,Sales_Order_Status__c,Integration_Action_Requested__c,Pre_Change_Status__c,Status__c From Order_Entry_Release__c where Id =: oerId];
    }
    
    public PageReference setHeaderStatus()
    {
        Map<ID,Schema.RecordTypeInfo> oerRecordTypeMapSchema = Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosById();
        if(oer.Status__c != 'Integration Error')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Header Status not in Integration Error'));
            return null;
        }
        oer.Trigger_Source__c = 'UI';
        if(oer.Sales_Order_Status__c == 'Entered' || oer.Sales_Order_Status__c == 'Booked'|| oer.Pre_Change_Status__c !=null) {
            oer.Status__c = 'Change Requested';
            //oer.Integration_Status__c='';
                        
        }
        else{
            if(!oerRecordTypeMapSchema.get(oer.RecordTypeID).getDeveloperName().contains('IGU')){
                oer.Status__c = 'Draft';
                //oer.Integration_Status__c='';
                //oer.Integration_Action_Requested__c='';
            }
            else
            {
                oer.Status__c = 'Confirmed';
                //oer.Integration_Status__c='';
            }
            
        
        }
        try{
            update oer;
        }
         catch(DMLException de) {
            ApexPages.addMessages(de);
            return NULL;
        }
        PageReference pg=new PageReference('/'+oerId);
        return pg;
       
    }
    
}