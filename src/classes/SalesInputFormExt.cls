public class SalesInputFormExt {
    Public Subscription_Pricing_Request__c spr{get;set;}
    Public Boolean HVACSaving{get;set;}
    Public Boolean ShadingSaving{get;set;}
    Public Map<String,String> dependentMap{get;set;}
    public String picklistFieldValue {get;set;} 
    public String depPicklistApiNames {get;set;}
    public String apiName {get;set;} 
    public String oppId {get;set;} 
    public SalesInputFormExt(ApexPages.StandardController stdController) 
    {  oppId=  ApexPages.CurrentPage().getparameters().get('oppId');
     
     HVACSaving=true;
     ShadingSaving=true;
     dependentMap=new Map<String,String>();
     spr= new Subscription_Pricing_Request__c();
     if(oppId!=null){
         Opportunity OppRec=[select id,Glass_Quantity__c, Total_Number_of_IGU__c,Support_Region__c from opportunity where id=:oppId];
         spr.Opportunity_Name__c=OppRec.id;
         spr.Glass_SqFt__c=OppRec.Glass_Quantity__c;
         spr.of_IGUs__c=OppRec.Total_Number_of_IGU__c;
         spr.Region__c=OppRec.Support_Region__c;
         apiName='Region__c';
         depPicklistApiNames='Glazing_labor_premium_sf__c,LVE_labor_premium_sf__c';
     }
     List<Dependent__mdt> dependentPicklists= [select id,Controlling_field_API_Name__c,Controlling_field_Value__c,Dependent_field_value__c,Dependent_field_API_Name__c from Dependent__mdt where Object_Name_for_Dependent_Picklist__c='Subscription_Pricing_Request__c'];
     for(Dependent__mdt dep:dependentPicklists)
     {
         dependentMap.put(dep.Controlling_field_API_Name__c+dep.Controlling_field_Value__c+dep.Dependent_field_API_Name__c,dep.Dependent_field_value__c);
     }
     picklistOnChange();
     spr.Baseline_Glass_Makeup__c='SB70XL_Air_Clr';
     apiName='Baseline_Glass_Makeup__c';
     depPicklistApiNames='Baseline_IGU_Price_Glass_SqFt__c';
     picklistOnChange();
    }
    public void picklistOnChange(){
        
        String [] depPicklists=depPicklistApiNames.split(',');
        for(String dep:depPicklists ){
            if(dependentMap!=null && dependentMap.containsKey(apiName+spr.get(apiName)+dep)){
                if(dependentMap.get(apiName+spr.get(apiName)+dep)!=null)
                    spr.put(dep,decimal.valueof(dependentMap.get(apiName+spr.get(apiName)+dep)));
                else
                    spr.put(dep,dependentMap.get(apiName+spr.get(apiName)+dep));   
            }
        }
    }
    public void makeHVACDefaultfields(){
        if(HVACSaving){
            spr.Window_Type__c=null;
            spr.Baseline_Glass_Makeup__c=null;
            spr.HVAC_System_Type__c=null;
            spr.HVAC_Pricing_ton__c=null;
        }else{
            spr.HVAC_Downsizing_Savings_Glass_SF__c=null;
        }
        
    }
    public void makeShadingDefaultfields(){
        if(HVACSaving){
            spr.Internal_Shading__c=null;
            spr.Internal_Shading_of_Vision__c=null;
            spr.External_Shading__c=null;
            spr.External_Shading_Quantity_lf__c=null;
            spr.Internal_Shading_Price_sf__c=null;
            spr.External_Shading_Price_lf__c=null;
        }else{
            spr.Shading_Savings_Glass_SF__c=null;
        }
        
    }
    public Pagereference cancel(){
        return new Pagereference('/'+oppId);
    }
    public Pagereference save(){
        insert spr;
        return new Pagereference('/'+oppId);
    }
}