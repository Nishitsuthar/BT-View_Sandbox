public class OpportunityTracking_Con {

    public OpportunityTracking_Con(ApexPages.StandardController controller) {

    }


    @RemoteAction @ReadOnly
    public static List<Opportunity> getOpportunityData(List<String> oppStages,List<String> milesStoneTypes,String od1,String od2,String od3,String od4,String md3,String md4){
        Date odt1 = parseDate(od1);
        Date odt2 = parseDate(od2);
       // String oppDateFilter = getOppDateFilter(odt1,odt2);
        
        String oppProjectFilter = getOppProjectFilter(od3,od4);
        
        Date mdt3 = parseDate(md3);
        Date mdt4 = parseDate(md4);
        String milestoneShip_DateFilter = getMilestoneShipDateFilter(mdt3,mdt4);
        //Ship_Date_Calc__c,
        String queryStr = 'SELECT Id,Name,Project_Update__c,'
                           +'(SELECT Name, Id, Quantity__c,Phase__c,Owner.Name,Type__c,Ship_date__c,Kickoff__c,Deadline__c,Duration__c,Description__c,CreatedDate FROM Milestones__r WHERE Type__c IN:milesStoneTypes '+milestoneShip_DateFilter+' ORDER BY Phase__c )'
                           +' FROM Opportunity WHERE StageName IN:oppStages '+oppProjectFilter; //+oppDateFilter
       System.Debug('**oppStages******'+oppStages);
       System.Debug('********'+queryStr);                   
       return Database.query(queryStr);
    }
    /*
    private static string getOppDateFilter(Datetime odt1,Datetime odt2){
        String dateFilter = '';
        if(odt1 != NULL){
            dateFilter = 'AND Ship_Date_Calc__c >= :odt1';
        }
        
        if(odt2 != NULL){
            dateFilter = dateFilter + ' AND Ship_Date_Calc__c <= :odt2';
        }
        
        return dateFilter;
    } */
    
     private static string getMilestoneShipDateFilter(Datetime mdt3,Datetime mdt4){
        String dateFilter = '';
        if(mdt3 != NULL){
            dateFilter = ' AND Ship_Date__c >= :mdt3';
        }
        
        if(mdt4 != NULL){
            dateFilter = dateFilter + ' AND Ship_Date__c <= :mdt4';
        }
        
        return dateFilter;
    }
    
    private static string getOppProjectFilter(String projectName,String projectManager){
        String projectFilter='';
        System.Debug('-------------projectManager--------------'+projectManager);
        if(projectName!= NULL && projectName!=''){
            projectFilter = ' AND Project_Name__c = :projectName';
        }
        
        if(projectManager!= NULL && projectManager!=''){
            projectFilter = projectFilter + ' AND Project_Manager__c = \''+projectManager+'\'';
        }
        
        return projectFilter ;
    }
    
   /* 
    public List<SelectOption> getMilestoneTypes(){
        List<SelectOption> selectOptions = new List<SelectOption>();
        for(Schema.PicklistEntry ple :Milestone1_Milestone__c.Type__c.getDescribe().getPicklistValues()){
            selectOptions.add(new SelectOption(ple.getValue(),ple.getLabel()));
        }
        
        return selectOptions;
    }
*/
    
    public List<SelectOption> getOppStages(){
        List<SelectOption> selectOptions = new List<SelectOption>();
        for(Schema.PicklistEntry ple :Opportunity.StageName.getDescribe().getPicklistValues()){
            selectOptions.add(new SelectOption(ple.getValue(),ple.getLabel()));
        }
        
        return selectOptions;
    }
    
     public static Date parseDate(String dtStr){
        Date dt;
        if(!String.isBlank(dtStr)){
            List<String> dtList = dtStr.split('/');
            if(dtList.size() == 3){
                dt = Date.newInstance(Integer.valueOf(dtList[2]), Integer.valueOf(dtList[0]), Integer.valueOf(dtList[1]));
            }
        }
        return dt;
    }
}