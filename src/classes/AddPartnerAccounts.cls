Public class AddPartnerAccounts
//with sharing
{
    String OppId;
    
    Public AddPartnerAccounts(ApexPages.Standardcontroller controller)
    {
    
        Partner_Account__c record = (Partner_Account__c)controller.getRecord();
        Id parentId = record.Related_Opportunity__c;
        OppId = parentId;
        
       // OppId = ApexPages.currentPage().getParameters().get('CF00N0L000006AxkF_lkid');
        paList = new List<Partner_Account__c>();
        
       for(integer i=0;i<3;i++)
       { 
            if(PaList != Null)
            {
                Partner_Account__c paObj = New Partner_Account__c();
                paObj.Related_Opportunity__c = oppId;
                PaList.add(paObj);
            
            }
        }
        
     }
        public List<Partner_Account__c> paList {get;set;}
       
              
        public void addPacc()
        
        {
            if(PaList != Null)
            {
                Partner_Account__c paObj = New Partner_Account__c();
                paObj.Related_Opportunity__c = oppId;
                PaList.add(paObj);
           
            }
          
        }
        public PageReference Save()
        {
            
            List<Partner_Account__c> paInsert = new List<Partner_Account__c>();
            boolean hasnorole = false;
            boolean hasnaccount = false;
            If(PaList != Null)
            {
                for(Partner_Account__c pc : PaList )
                {
                   if(pc.Partner_Account__c != Null){
                       hasnaccount= true;
                   }
                   if(pc.Role__c == null && pc.Partner_Account__c != Null){
                       hasnorole = true;
                       break;
                   }   
                    if(pc.Partner_Account__c != Null && pc.Role__c != Null)
                    {
                        paInsert.add(pc);
                    }
                }
                if(!hasnaccount){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter Account/Role.'));
                    return null;
                }
                else if(hasnorole){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter Role.'));
                    return null;
                }   
                else{
                    if(painsert != null && painsert.size()>0)
                    insert painsert;
                }   
            }
         
            return new PageReference('/'+OppId);
        }
        public PageReference Cancel()
        {
             return new PageReference('/'+OppId);
        }
        
}