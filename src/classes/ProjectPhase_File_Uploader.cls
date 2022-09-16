public class ProjectPhase_File_Uploader
{
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    List<Project_Phase__c> recstoupload;
    List<Project_Phase__c> projectPhases = new List<Project_Phase__c>();
    List<Project_Phase_Plan__c> projectPhaseLines = new List<Project_Phase_Plan__c>();
    public String pPlanid{get;set;}
    public Integer startingLineNumber = 1;
    public Decimal maxLineNumber = 0.0;
    public String OpportunityId;
    public String customerRefString;
    public ProjectPhase_File_Uploader(ApexPages.StandardSetController controller) {
    
        pPlanid = ApexPages.CurrentPage().getParameters().get('id');
        
        projectPhaseLines = [SELECT Id,Name,Opportunity__c,  Opportunity__r.Opportunity_ID__c       
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
    public Pagereference ReadFile()
    {
        try{
            nameFile=contentFile.toString();
            //nameFile= EncodingUtil.base64Encode(contentFile);

        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please upload a valid CSV UTF-8 Format document');
            ApexPages.addMessage(myMsg); 
            return null;   
        }
        //nameFile=EncodingUtil.base64Encod(contentFile);
        filelines = nameFile.split('\n');
        System.debug('filelines##'+filelines);
        recstoupload = new List<Project_Phase__c>();
        set<string> crds =new set<string>();
        for (Integer i=1;i<filelines.size();i++)
        {
            customerRefString ='';            
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(','); 
            //Added by enp-narasimha
            if(inputvalues[0] == '' || inputvalues[1] == '' || inputvalues[2] == '' || inputvalues[3] == '')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please ensure all columns should values'));
                return null;
            }
            if(crds.contains(inputvalues[3])){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Customer reference description should be unique'));
            return null;
            }
            crds.add(inputvalues[3]);
            //end by enp       
            Project_Phase__c p = new Project_Phase__c();
            p.Phase_Line_Number__c = startingLineNumber;
            System.debug('#########'+inputvalues[0]);
            System.debug('#########'+inputvalues[1]);
            System.debug('#########'+inputvalues[2]);
            System.debug('#########'+inputvalues[3]);
            customerRefString  = (inputvalues[1].subString(0,2)).toUpperCase();
            System.debug('#########customerRefString'+customerRefString);
            if(Integer.Valueof(inputvalues[0])<10){
                customerRefString  = customerRefString +'-'+'0'+inputvalues[0];
                //customerRefString  = customerRefString +'0'+inputvalues[0];
            }
            else{
                customerRefString  = customerRefString +'-'+inputvalues[0];
                //customerRefString  = customerRefString +inputvalues[0];               
            }
            p.Project_Phase__c = Integer.Valueof(inputvalues[0]);     
            p.Trade__c = inputvalues[1];
            p.Approx_Phase_Date__c = date.parse(inputvalues[2]);
            p.Phase_Description__c = inputvalues[3];
            //p.Customer_Reference_id__c = inputvalues[4];
             string Planname=projectPhaseLines[0].Name.substring(3);
            if(startingLineNumber<10){
                p.Customer_reference_Id__c  = customerRefString+'0'+startingLineNumber + '-' + Planname + '-' + OpportunityId;
                //p.Customer_reference_Id__c  = customerRefString+'0'+startingLineNumber + OpportunityId;
            }
            else {
                p.Customer_reference_Id__c  = customerRefString+startingLineNumber + '-' + Planname + '-' + OpportunityId;
                //p.Customer_reference_Id__c  = customerRefString+startingLineNumber+OpportunityId;            
            }            
            p.Project_Phase_Plan__c = pPlanid;
            recstoupload.add(p);
            startingLineNumber++;
        }
        try{
            if(!recstoupload.isEmpty())
            insert recstoupload;
            PageReference pg=new PageReference('/'+pPlanid);
            return pg;   
        }
        catch (DMLException de)
        {
            system.debug('@@dml'+de);
            //ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
             ApexPages.addMessages(de);
            return null;
        }    
            
    }
    public PageReference cancel() 
    {
        
       PageReference pg=new PageReference('/'+pPlanid);
            return pg;
    }
    /*public List<Project_Phase__c> getuploadedProjectPhases()
    {
        if (recstoupload!= NULL)
            if (recstoupload.size() > 0)
                return recstoupload;
            else
                return null;                    
        else
            return null;
    }*/            

}