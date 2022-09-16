public with sharing class AddProjectPhases {   

    String ProjectPhasePlanId = '';
    Pagereference pageRef;
    public Integer startingLineNumber = 1;
    public Decimal maxLineNumber = 0.0;
    public String OpportunityId;
    public String customerRefString;
    public List<Project_Phase__c> listprojphase {get; set;}
    public list<Project_Phase__c> finalListprojphase = new list<Project_Phase__c>();
    public String pPlanid{get;set;}
    List<Project_Phase__c> projectPhases = new List<Project_Phase__c>();
    List<Project_Phase_Plan__c> projectPhaseLines = new List<Project_Phase_Plan__c>();     

    public AddProjectPhases(ApexPages.StandardSetController controller) {
        ProjectPhasePlanId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('@@id'+ApexPages.currentPage().getParameters().get('Id'));
        Project_Phase__c projphaseobj;
            listprojphase = new List<Project_Phase__c>();
            for(Integer i=1; i<=3; i++){            
                projphaseobj = new Project_Phase__c();
                projphaseobj.Project_Phase_Plan__c  =ProjectPhasePlanId;
                listprojphase.add(projphaseobj);
            }
        pPlanid = ApexPages.CurrentPage().getParameters().get('id');        
        projectPhaseLines = [SELECT Id,Name,Opportunity__c, Opportunity__r.Opportunity_ID__c       
                                    FROM Project_Phase_Plan__c WHERE Id= :pPlanid];        
        projectPhases = [SELECT Trade__c, Approx_Phase_Date__c, Phase_Description__c,Project_Phase_Plan__c, Phase_Line_Number__c, 
                                    Project_Phase_Plan__r.Opportunity__r.Id, Customer_reference_Id__c        
                                    FROM Project_Phase__c WHERE Project_Phase_Plan__c = :pPlanid];
        for (Project_Phase__c ppl : projectPhases){
            if(ppl.Phase_Line_Number__c > maxLineNumber){
                maxLineNumber = ppl.Phase_Line_Number__c;
            }
        }
        startingLineNumber = Integer.valueOf(maxLineNumber)+1;
        OpportunityId =  projectPhaseLines[0].Opportunity__r.Opportunity_ID__c;
    }
     public void addProjPhase() {
         Project_Phase__c projectPhase = new Project_Phase__c();
         projectPhase.Project_Phase_Plan__c = ProjectPhasePlanId;
         listprojphase.add(projectPhase);
     }
     public PageReference saveProjPhase(){
         set<string> crds =new set<string>();
         finalListprojphase.clear();
         crds.clear();
        system.debug('@@id'+ProjectPhasePlanId);   
        for(Project_Phase__c obj: listprojphase){ 
            if(obj.Trade__c == null && obj.Project_Phase__c ==null && obj.Phase_Description__c == null && obj.Approx_Phase_Date__c == null)
            continue;
            if(crds.contains(obj.Phase_Description__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Customer reference description should be unique'));
            return null;
            }
            if(obj.Trade__c == null || obj.Project_Phase__c ==null || obj.Phase_Description__c == null || obj.Approx_Phase_Date__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please fill all columns in row'));
                return null;
            }
            crds.add(obj.Phase_Description__c);     
            customerRefString ='';            
            if(obj.Trade__c!= null)
            customerRefString  = (obj.Trade__c.subString(0,2)).toUpperCase();
            if(Integer.Valueof(obj.Project_Phase__c)<10){
                customerRefString  = customerRefString +'-'+'0'+obj.Project_Phase__c;
                //customerRefString  = customerRefString +'0'+obj.Project_Phase__c;
            }
            else{
                customerRefString  = customerRefString +'-'+obj.Project_Phase__c;
                //customerRefString  = customerRefString+obj.Project_Phase__c;               
            }            
            string Planname=projectPhaseLines[0].Name.substring(3);
            if(startingLineNumber<10){
                obj.Customer_reference_Id__c  = customerRefString+'0'+startingLineNumber + '-' + Planname + '-' + OpportunityId;
                
            }
            else {
                obj.Customer_reference_Id__c  = customerRefString+startingLineNumber + '-' + Planname + '-' + OpportunityId;
                            
            }
            obj.Phase_Line_Number__c = startingLineNumber;            
            finalListprojphase.add(obj);
            startingLineNumber++;
        }
         try{
             if(!finalListprojphase.isEmpty())
             insert finalListprojphase;
              pageRef = NEW PageReference('/'+ProjectPhasePlanId);                      
             return pageRef;
         }
         catch(DMLException de) {
            ApexPages.addMessages(de);
            return NULL;
        }
        
     } 
   
}