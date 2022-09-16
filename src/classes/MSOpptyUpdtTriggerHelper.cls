public class MSOpptyUpdtTriggerHelper
{
    
    public static void decommissionMiletwo(){
			
    }
    /*
    static Map<String,String> msTypeToFieldNameMap = new Map<String,String> 
    {
        'Sales to Ops Turnover'=>'Sales_To_Ops_Turnover_Pct__c',
        'Project Kickoff Meeting'=>'Project_Kickoff_Meeting_Pct__c',
        'Preliminary BOS Design'=>'Preliminary_BoS_Design_Pct__c',
        //'Ops to Engineering Turnover'=>'Ops_To_Engineering_Turnover_Pct__c',
        'Ops to Engineering Turnover'=>'Ops_To_Engineering_Turnover_Pct__c',
        'Final BOS Design'=>'Final_BoS_Design_Pct__c'
    };

    static Decimal pctComplete;
    
    static public void processUpsert(Milestone1_Milestone__c ms, Opportunity oppty)
    {
        if(ms.Type__c != null && msTypeToFieldNameMap.containsKey(ms.Type__c))
        {
            opptyFieldName = msTypeToFieldNameMap.get(ms.Type__c);
            if(ms.Complete__c)
            {
                pctComplete = 100.0;
            }
            else
            {
                if (ms.Percent_Completed__c != null)
                {
                    pctComplete = ms.Percent_Completed__c;
                }
                else
                {
                    pctComplete = 0.0;
                }
            }
            Decimal oldPct = (Decimal) oppty.put(opptyFieldName, pctComplete);
        }
    }
    
    static public void processDelete(Milestone1_Milestone__c ms, Opportunity oppty)
    {
        if(ms.Type__c != null && msTypeToFieldNameMap.containsKey(ms.Type__c))
        {
            opptyFieldName = msTypeToFieldNameMap.get(ms.Type__c);
            Decimal oldPct = (Decimal) oppty.put(opptyFieldName, 0.0);
        }
        
    } 
*/
    
}