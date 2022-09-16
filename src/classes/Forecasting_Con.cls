/*
* # instead of milestone we are showing all the opplineitem schedule isnside a particular opp
* # opp distribution is done based on opplineitem schedule schedule date 
* # so a opp can appear twice or more based on revenue date on opp line item schedule
*
*/



public class Forecasting_Con {
    public String rangeType {get ; set ;}
    
    private static final Map<Integer,String> MONTH_TO_NAME = new Map<Integer,String>{
                                                                                          1=>'January',
                                                                                          2=>'February',
                                                                                          3=>'March',
                                                                                          4=>'April',
                                                                                          5=>'May',
                                                                                          6=>'June',
                                                                                          7=>'July',
                                                                                          8=>'August',
                                                                                          9=>'September',
                                                                                          10=>'October',
                                                                                          11=>'November',
                                                                                          12=>'December'
                                                                                      };
                                                                              
    @RemoteAction @ReadOnly
    public static List<DurationDataWrapper> getData(List<String> oppStages,List<String> forecastStatuses,Integer rangeQuarter,String rangeYear,String rangeType,Integer rangeLength){
      //String frstDateOfYear = ''
      String query = ' SELECT '+
                            'EndDate, '+
                            'StartDate, '+
                            'Type, '+
                            'Number '+
                        'FROM '+
                            'Period '+
                        'WHERE '+
                            'Number =:rangeQuarter '+
                            'AND '+
                            'type = \'Quarter\' '+
                            'AND '+
                            'StartDate >= LAST_N_FISCAL_YEARS:'+rangeYear;
      List<Period> lst1 = Database.query(query);                
      Date startDate = lst1[0].StartDate;
      query = ' SELECT '+
                    'EndDate, '+
                    'StartDate, '+
                    'Type, '+
                    'Number '+
                'FROM '+
                    'Period '+
                'WHERE '+
                    'type =:rangeType '+
                    'AND '+
                    'StartDate >=:startDate'+                
                ' ORDER BY StartDate '+
                ' LIMIT '+rangeLength;
      System.debug(query);
      List<Period> lst2 = Database.query(query);  
      
      
      Map<String,DurationDataWrapper> DurationDataWrapperMap = initDistribution(rangeType,rangeLength,lst2);
      List<OpportunityLineItemSchedule> OpportunityLineItemSchedules = getOpportunityLineItemSchedules(oppStages,forecastStatuses,lst2[0].StartDate,lst2[lst2.size()-1].EndDate); 
      if(rangeType == 'Quarter'){
          Map<String,String> dateToQuarterMap = new Map<String,String>();
          
          for(Period p:lst2){ 
                Date startDateTemp = p.StartDate;
                dateToQuarterMap.put(startDateTemp.month() + ' ' +startDateTemp.year(),p.Number+' '+startDateTemp.year());
                dateToQuarterMap.put(startDateTemp.addMonths(1).month() + ' ' +startDateTemp.addMonths(1).year(),p.Number+' '+startDateTemp.addMonths(1).year());
                dateToQuarterMap.put(startDateTemp.addMonths(2).month() + ' ' +startDateTemp.addMonths(2).year(),p.Number+' '+startDateTemp.addMonths(2).year());
            }
            System.debug('###########'+dateToQuarterMap);
            
            System.debug('###########'+DurationDataWrapperMap.keyset());   
            for(OpportunityLineItemSchedule olis : OpportunityLineItemSchedules){
                String quarterNum = dateToQuarterMap.get(olis.ScheduleDate.month()+' '+olis.ScheduleDate.year());
                System.debug(quarterNum);
                DurationDataWrapperMap.get(quarterNum).add(olis);             
            }
      }
      else{
          for(OpportunityLineItemSchedule olis : OpportunityLineItemSchedules){                
              DurationDataWrapperMap.get(olis.ScheduleDate.month()+' '+olis.ScheduleDate.year()).add(olis);
          }
      }
      
      List<DurationDataWrapper> DurationDataWrapperList = DurationDataWrapperMap.values();
      DurationDataWrapperList.sort();
      return DurationDataWrapperList;
    }      
    
    public class DurationDataWrapper implements Comparable{
        public Double total;
        public Double quantityTotal;
        public Date compareDate;
        public String durationName;
        public List<OpportunityWrapper> OpportunityWrappers;
        //just for data caching wont appear in remote data
        private Transient Map<Id,OpportunityWrapper> OpportunityWrapperMap;
        
        public void add(OpportunityLineItemSchedule olis){
            if(OpportunityWrapperMap.get(olis.OpportunityLineItem.Opportunity.Id)== NULL){
                OpportunityWrapperMap.put(olis.OpportunityLineItem.Opportunity.Id,new OpportunityWrapper(olis));
            }
            else{
                OpportunityWrapperMap.get(olis.OpportunityLineItem.Opportunity.Id).add(olis);
            }
            this.quantityTotal= this.quantityTotal+ replaceNullWithZero(olis.quantity);
            this.total = this.total + replaceNullWithZero(olis.Revenue);
            
            OpportunityWrappers = OpportunityWrapperMap.values();
        }
        
        public Integer compareTo(Object other) {
            Date otherCompareDate = other != null ? ((DurationDataWrapper) other).compareDate : System.today();
            return otherCompareDate.daysBetween(this.compareDate);
        }
        
        public DurationDataWrapper(Date compareDate){
            this.total = 0;
            this.quantityTotal = 0;
            this.compareDate = compareDate;
            this.OpportunityWrappers = new List<OpportunityWrapper>();
            this.OpportunityWrapperMap = new Map<Id,OpportunityWrapper>();
        }
    }
    
    
    public class OpportunityWrapper{
        public Opportunity opp;
        public List<OpportunityLineItemSchedule> OpportunityLineItemSchedules;
        
        public void add(OpportunityLineItemSchedule olis){
            OpportunityLineItemSchedules.add(olis);
        }
        
        public OpportunityWrapper(OpportunityLineItemSchedule olis){
            OpportunityLineItemSchedules = new List<OpportunityLineItemSchedule>{olis};
            opp = olis.OpportunityLineItem.Opportunity;
        }
    }
    
    
    
    
    private static List<OpportunityLineItemSchedule> getOpportunityLineItemSchedules(List<String> oppStages,List<String> forecastStatuses,Date startDate,Date endDate){
        
        String query = 'SELECT Id,Quantity, Revenue,OpportunityLineItem.Opportunity.Id,ScheduleDate,OpportunityLineItem.Opportunity.Name '+
                       'FROM OpportunityLineItemSchedule '+
                       'WHERE ScheduleDate >=:startDate '+
                       'AND ScheduleDate <=:endDate '+
                       'AND OpportunityLineItem.Opportunity.StageName IN:oppStages '+
                       'AND OpportunityLineItem.Opportunity.Forecast_Status__c IN:forecastStatuses';
        return Database.query(query);
    }
    
    /*private static List<Period> getPeriods(){
        return [
                    SELECT 
                        EndDate,
                        StartDate, 
                        Type, 
                        Number 
                    FROM 
                        Period 
                    WHERE 
                        type = 'Quarter' 
                        AND 
                        StartDate = THIS_FISCAL_YEAR
                  ];
    }*/
    
    private static Map<String,DurationDataWrapper> initDistribution(String rangeType,Integer rangeLength,List<Period> periods){
        Map<String,DurationDataWrapper> DurationDataWrapperMap = new Map<String,DurationDataWrapper>();
        System.debug('XXXXXXX'+rangeType);
        if(rangeType == 'Quarter'){              
            for(Integer i = 1; i <= periods.size() ; i ++){
                Period p = periods[i - 1];
                DurationDataWrapper wrapObj = new DurationDataWrapper(p.StartDate);
                wrapObj.durationName =  'Q'+p.Number +' '+p.StartDate.year();
                DurationDataWrapperMap.put(p.Number+' '+p.StartDate.year(),wrapObj);
            }
        }else{
            for(Integer i = 1; i <= periods.size() ; i ++){
                Period p = periods[i - 1];
                DurationDataWrapper wrapObj = new DurationDataWrapper(p.StartDate);
                wrapObj.durationName = MONTH_TO_NAME.get(p.StartDate.month()) + ' '+p.StartDate.year(); 
                DurationDataWrapperMap.put(p.StartDate.month()+' '+p.StartDate.year(),wrapObj);
            }
        }
        
        return DurationDataWrapperMap;
    }
    
    private static Decimal replaceNullWithZero(Decimal val){
        return val == NULL ? 0 : val;
    }
    
    
    
    public List<SelectOption> getYears(){
        List<SelectOption> options = new List<SelectOption>();
        List<Period> periods = [SELECT 
                                    EndDate,
                                    StartDate, 
                                    Type, 
                                    Number 
                                FROM 
                                    Period 
                                WHERE 
                                    type = 'Year' 
                                    AND 
                                    StartDate = THIS_FISCAL_YEAR];
        if(!periods.isEmpty()){
            Period p = periods[0];
            Integer strtDateyr = p.StartDate.year();
            Integer endDateyr = p.EndDate.year();
            if(strtDateyr == endDateyr ){
                for(Integer i=0;i<10;i++){
                    options.add(new SelectOption(''+i,''+(strtDateyr-i)));
                }
            }else{
                Integer nxtYear = endDateyr+1;
                for(Integer i=0;i<10;i++){
                    options.add(new SelectOption(''+i,''+(nxtYear-i-1)+'-'+(nxtYear-i)));
                }
            }
           
        }
        return options;
    }
    
    public List<SelectOption> getQuarters(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'FQ1'));
        options.add(new SelectOption('2', 'FQ2'));
        options.add(new SelectOption('3', 'FQ3'));
        options.add(new SelectOption('4', 'FQ4'));
        return options;
    }
    
    public List<SelectOption> getMonths(){
        List<SelectOption> options = new List<SelectOption>();
        for(Integer s : MONTH_TO_NAME.keySet()){
          options.add(new SelectOption(String.valueOf(s),MONTH_TO_NAME.get(s)));
        }       
        return options;
    }
    
    public List<SelectOption> getRangePeriods(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', '1 period'));
        options.add(new SelectOption('2', '2 periods'));
        options.add(new SelectOption('3', '3 periods'));
        options.add(new SelectOption('4', '4 periods'));
        options.add(new SelectOption('5', '5 periods'));
        options.add(new SelectOption('6', '6 periods'));
        return options;
    }
    
    
    public List<SelectOption> getOppStages(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getStatuses(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Forecast_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
}