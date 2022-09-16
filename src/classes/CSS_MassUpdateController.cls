public class CSS_MassUpdateController{

    public List<Order_Entry_Line__c> getOrdLineItm{get;set;} 
    public String oerId{get;set;}
    public String varSearch{get;set;}
    public list<wrapperLine> lstlineWrapper{get;set;}
    public boolean isshowEdit{get;set;}
    public boolean isshowprocess{get;set;}
    public boolean isError{get;set;}
    public String quantity{get;set;}
    public List<Order_Entry_Line__c> selectedlines;
    public Order_Entry_Line__c oel1{get;set;}    
    public List<SelectOption> referenceSelections{get;set;}
    public String selectedReferece{get;set;}
    public Set<String> refIdSet= new set<String>();
     public String ReleaseID{get;set;} 
     public boolean isCancelled{get;set;}
      public boolean isHold{get;set;}
      public Order_Entry_Release__c oer;
   public String CustomerRefDesc{get;set;}
    public CSS_MassUpdateController(ApexPages.StandardSetController stdSetController) {    
            System.debug(ApexPages.currentPage().getParameters().get('id'));
            oerId = ApexPages.currentPage().getParameters().get('id');
            oer = [select id,Name,status__c from Order_Entry_Release__c where Id =:oerId];
            lstlineWrapper=new list<wrapperLine>();
            referenceSelections = new List<SelectOption>();
            isshowEdit=false;
            oel1=new Order_Entry_Line__c(); 
            getOrdLineItm = [select id,name,Line_Number__c,Quantity__c,Quantity_Change_Reason__c,Hold_Reason__c ,Status__c,Customer_Reference_Description__c,Cancellation_Reason__c,SKU__c ,Reference_ID__c,Integration_Action_Requested__c,Trigger_Source__c,
                                Request_Date__c,Promised_Date__c,Scheduled_Ship_Date__c,Order_Entry_Release__r.Name FROM Order_Entry_Line__c WHERE Order_Entry_Release__r.Id=:oerId];
            referenceSelections.add(new SelectOption('--None--','--None--'));
            for(Order_Entry_Line__c  ol:getOrdLineItm)
            {
                if(ol.Reference_ID__c!=null && ol.Reference_ID__c!='' && !refIdSet.contains(ol.Reference_ID__c)){
                    refIdSet.add(ol.Reference_ID__c);                    
                    referenceSelections.add(new SelectOption(ol.Reference_ID__c,ol.Reference_ID__c));
                }
                   
            }
    }
    
    
    
    Public void GetOrdLineItmMethod(){
        System.debug(oerId); 
        if(!lstlineWrapper.isEmpty())
        lstlineWrapper.clear();       
        
        for(Order_Entry_Line__c  ol:getOrdLineItm)
        {
            //if(ol.Status__c.containsIgnoreCase()){
            system.debug('**********'+ol.status__c);
           
            if(ol.status__c!= null && !label.MassUpdateNotAllowedLines.containsIgnoreCase(ol.status__c) && (ol.Reference_ID__c == selectedReferece)){
                ReleaseID=ol.Order_Entry_Release__r.Name;
                CustomerRefDesc=ol.Customer_Reference_Description__c;
                //oel1.Order_Entry_Release__r.Name=ol.Order_Entry_Release__r.Name;
                lstlineWrapper.add(new wrapperLine(ol));
            }
        }
        isshowprocess=true;
        isshowEdit=true;
    }
   
    public PageReference massUpdate()
    {
        selectedlines =new List<Order_Entry_Line__c>();     
        for(wrapperLine woel: lstlineWrapper) {
            if(woel.selected == true) {
                
                if(label.MassUpdateAllowStatus.containsIgnoreCase(woel.oel.status__c))
                {
                    if(oel1.Customer_Reference_Description__c!=null)
                    woel.oel.Customer_Reference_Description__c=oel1.Customer_Reference_Description__c;
                    if(oel1.Request_Date__c!=null)
                    woel.oel.Request_Date__c=oel1.Request_Date__c;
                    if(oel1.Promised_Date__c!=null)
                    woel.oel.Promised_Date__c=oel1.Promised_Date__c;
                    if(oel1.Scheduled_Ship_Date__c!=null)
                    woel.oel.Scheduled_Ship_Date__c=oel1.Scheduled_Ship_Date__c;
                    
                    if(quantity!='' && quantity!=null){
                        
                        if(oel1.Quantity_Change_Reason__c ==null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Provide Quantity Change Reason'));
                            return null;
                        }
                        woel.oel.Quantity__c=Integer.valueOf(quantity);
                    }
                    
                    if(oel1.Quantity_Change_Reason__c !=null)
                    woel.oel.Quantity_Change_Reason__c =oel1.Quantity_Change_Reason__c ;
                    woel.oel.Trigger_Source__c= 'UI';
                    //woel.oel.Integration_Action_Requested__c='Update';
                    selectedlines.add(woel.oel);
                    system.debug('@@@@qu'+woel.oel.Quantity__c);
                    if(isCancelled)
                    {
                       
                        if(oel1.Cancellation_Reason__c != null){
                        woel.oel.Status__c= 'Cancellation Requested';
                        woel.oel.Integration_Action_Requested__c='Cancel';
                        woel.oel.Cancellation_Reason__c =oel1.Cancellation_Reason__c;
                        }
                        else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You must enter a cancellation reason'));
                            return null;
                        }
                    }
                    if(isHold)
                    {                       
                        if(oel1.Hold_Reason__c != null && oel1.Hold_Reason__c != '--None--'){
                        woel.oel.Status__c= 'Hold Requested';
                        woel.oel.Integration_Action_Requested__c='Hold';
                        woel.oel.Hold_Reason__c =oel1.Hold_Reason__c;
                        }
                        else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You must select a hold reason'));
                            return null;
                        }
                    }
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Mass update is not allowed in this Order Header status '+woel.oel.status__c));
                    return null;

                }
            }
        }
        try{
        if(selectedlines.size()>0)
        update selectedlines;
        
        
        PageReference pg=new PageReference('/'+oerId);
        return pg;
        }
        catch(DMLException de) {
            ApexPages.addMessages(de);
            return NULL;
        }
    }
    public PageReference massCancel()
    {
        selectedlines =new List<Order_Entry_Line__c>();     
        for(wrapperLine woel: lstlineWrapper) {
            if(woel.selected == true) {
                
                if(label.MassUpdateAllowStatus.containsIgnoreCase(woel.oel.status__c))
                {
                    
                    woel.oel.Status__c= 'Cancellation Requested';
                    woel.oel.Integration_Action_Requested__c='Cancel';
                    woel.oel.Trigger_Source__c= 'UI';
                    selectedlines.add(woel.oel);
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Cancellation of Order Line is not allowed in this Order Line status: '+woel.oel.status__c));
                     return null;

                }
            }
        }
        
       try{
        if(selectedlines.size()>0)
        update selectedlines;
                
       
        
        
         PageReference pg=new PageReference('/'+oerId);
        return pg;
        }
        catch(DMLException de) {
            ApexPages.addMessages(de);
            return NULL;
        }
    }
    public PageReference HeaderChk()
    {
        if(!label.MassUpdateAllowStatus.containsIgnoreCase(oer.status__c))
        {
            isError = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Mass update is not allowed in this Order Header status '+oer.status__c));
            return null;
        }
        return null;
    }
    public class wrapperLine{
        public boolean selected{get;set;}
        public Order_Entry_Line__c oel{get;set;}
        public wrapperLine(Order_Entry_Line__c oel)
        {
            this.oel=oel;
            this.selected=false;
        }
    }
}