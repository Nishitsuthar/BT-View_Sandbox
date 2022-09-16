public class CSS_Phase_MassUpdateController {
    public String planId{get;set;}
    public Project_Phase__c phase{get;set;}
    public List<Project_Phase__c> getPhases{get;set;} 
    public list<wrapperPhase> lstphaseWrapper{get;set;}
    public CSS_Phase_MassUpdateController(ApexPages.StandardSetController controller) {
        lstphaseWrapper = new List<wrapperPhase>();
        phase=new Project_Phase__c();
        planId = ApexPages.currentPage().getParameters().get('id');
        getPhases = [SELECT Id,Name,Customer_Reference_id__c,Phase_Description__c,Project_Phase_Plan__c,Customer_Reference_Status__c FROM Project_Phase__c 
                    where Project_Phase_Plan__c =: planId];
        
        for(Project_Phase__c ph:getPhases)
        {
            lstphaseWrapper.add( new wrapperPhase(ph));
        }
    }
     public PageReference massUpdate()
    {
        boolean isselect=false;
        List<Project_Phase__c> updatedphases =new List<Project_Phase__c>();     
        for(wrapperPhase wph: lstphaseWrapper) {
            if(wph.selected == true) {
                isselect=true;
                if(wph.phase.Customer_Reference_Status__c ==null || (phase.Customer_Reference_Status__c !=null && wph.phase.Customer_Reference_Status__c !=null && wph.phase.Customer_Reference_Status__c != phase.Customer_Reference_Status__c)){
                wph.phase.Customer_Reference_Status__c = phase.Customer_Reference_Status__c;
                updatedphases.add(wph.phase);
                }
            }
        }
        if(isselect == false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You must select at least one phase'));
            return null;
        }
       
        try{
            if(!updatedphases.isEmpty())
            update updatedphases;
             PageReference pg=new PageReference('/'+planId);
            return pg;
        }
        catch(DMLException de) {
            ApexPages.addMessages(de);
            return NULL;
        }
    }
     public class wrapperPhase{
        public boolean selected{get;set;}
        public Project_Phase__c phase{get;set;}
        public wrapperPhase(Project_Phase__c phase)
        {
            this.phase=phase;
            this.selected=false;
        }
    }

}