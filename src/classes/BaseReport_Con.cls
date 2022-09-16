public class BaseReport_Con {

    public Opportunity opp { get ; set ;}
    
    public BaseReport_Con(){
        opp = new Opportunity();
    }
    
    @RemoteAction
    public static List<DateWrapper> getOppData(String owner,List<String> stages,List<String> statuses,String od1, String od2){
        Date odt1 = OpportunityTracking_Con.parseDate(od1);
        Date odt2 = OpportunityTracking_Con.parseDate(od2);
        String dateFilter = getScheduleDateFilter(odt1,odt2);
        
        System.Debug('*****dateFilter***'+od1);
        
        Map<Date,DateWrapper> dateWrappersMap = new Map<Date,DateWrapper>();
       
        String query = 'SELECT '+
                           'Id,'+
                           'OpportunityLineItem.Opportunity.Name,'+
                           'OpportunityLineItem.OpportunityId,'+
                           'OpportunityLineItem.Opportunity.Forecast_Status__c,'+
                           'OpportunityLineItem.Opportunity.Probability,'+
                           'OpportunityLineItem.Opportunity.Owner.Name,'+
                           'OpportunityLineItem.Opportunity.LastModifiedDate,'+
                           'OpportunityLineItem.Opportunity.LastActivityDate,'+
                           'OpportunityLineItem.TotalPrice,'+
                           'ScheduleDate,'+
                           'Revenue '+
                       'FROM '+
                          'OpportunityLineItemSchedule '+   
                       'WHERE '+
                                        'OpportunityLineItem.Opportunity.StageName IN:stages '+
                                        'AND OpportunityLineItem.Opportunity.Forecast_Status__c IN:statuses '+
                                        (String.isNotBlank(owner) ? 'AND OpportunityLineItem.Opportunity.OwnerId =:owner ' : '')+
                                        dateFilter +
                                        'ORDER BY '+
                                        'ScheduleDate';

       System.Debug('*********query****'+query);
       for(OpportunityLineItemSchedule sch:Database.query(query)){
           if(!dateWrappersMap.containsKey(sch.ScheduleDate.toStartOfMonth())){
               dateWrappersMap.put(sch.ScheduleDate.toStartOfMonth(),new DateWrapper(sch.ScheduleDate.toStartOfMonth()));
           }
           DateWrapper dWrap = dateWrappersMap.get(sch.ScheduleDate.toStartOfMonth());
           Boolean isFound = false;
           for(OppNameWrapper oWrap:dWrap.oppNameWrappers){
               if(sch.OpportunityLineItem.Opportunity.Name == oWrap.opp.Name){
                   isFound = true;
                   oWrap.totalPrice = oWrap.totalPrice + sch.revenue;
                   oWrap.oppSchedule.add(sch);
                   break;
               }
           }
           if(!isFound){
               Opportunity opp = new Opportunity (
                                                       Name = sch.OpportunityLineItem.Opportunity.Name,
                                                       Forecast_Status__c = sch.OpportunityLineItem.Opportunity.Forecast_Status__c 
                                                 );
               OppNameWrapper oWrap = new OppNameWrapper(opp,sch.revenue);
               oWrap.oppSchedule.add(sch);
               dWrap.oppNameWrappers.add(oWrap);
               
           }
           dWrap.grandTotal = dWrap.grandTotal+sch.Revenue;
          
       }
       return dateWrappersMap.values();
    }
    
    public List<SelectOption> getOppStages(){
        List<SelectOption> selectOptions = new List<SelectOption>();
        for(Schema.PicklistEntry ple :Opportunity.StageName.getDescribe().getPicklistValues()){
            selectOptions.add(new SelectOption(ple.getValue(),ple.getLabel()));
        }
        
        return selectOptions;
    }
    
     public List<SelectOption> getStatuses(){
        List<SelectOption> selectOptions = new List<SelectOption>();
        for(Schema.PicklistEntry ple :Opportunity.Forecast_Status__c.getDescribe().getPicklistValues()){
            selectOptions.add(new SelectOption(ple.getValue(),ple.getLabel()));
        }
        
        return selectOptions;
    }
    
    public class DateWrapper{
        public Date scheduleDate;
        public Decimal grandTotal;
        public List<OppNameWrapper> oppNameWrappers;
        public DateWrapper(Date scheduleDate){
            this.scheduleDate = scheduleDate;
            this.grandTotal = 0;
            oppNameWrappers = new List<OppNameWrapper>();
        }
    }
    
    public class OppNameWrapper{
        public String oppName;
        public Opportunity opp;
        public Decimal totalPrice;
        public Decimal totalHighPrice;
        public Decimal totalLowPrice;
        public List<OpportunityLineItemSchedule> oppSchedule;
        public OppNameWrapper(Opportunity opp,Decimal totalPrice){
            this.opp = opp;
            this.totalPrice = totalPrice;
            oppSchedule = new List<OpportunityLineItemSchedule>();
        }
    }
    
    private static string getScheduleDateFilter(Datetime odt1,Datetime odt2){
        String dateFilter = '';
        if(odt1 != NULL){
            dateFilter = ' AND ScheduleDate >= :odt1';
        }
        
        if(odt2 != NULL){
            dateFilter = dateFilter + ' AND ScheduleDate <= :odt2 ';
        }
        
        return dateFilter;
    }
    
}