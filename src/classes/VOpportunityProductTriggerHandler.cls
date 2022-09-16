/*
        Name           : VOpportunityProductTriggerHandler
        Author         : AV
        Reviewer       : Veltig Dev, Ashwani
        Date           : 21st April 2015
        Description    : This controller update schedule date of OpportunityProduct's schedule
*/

public class VOpportunityProductTriggerHandler
{
    // this method update schedule date of OpportunityProduct's schedule
    // @param: newMap: Map of OpportunityLineItem's Id and OpportunityLineItem's Instance of record before update
    // @param: oldMap: Map of OpportunityLineItem's Id and OpportunityLineItem's Instance of record after update
    public static void onAfterUpdate(Map<Id,OpportunityLineItem> newMap, Map<Id,OpportunityLineItem> oldMap)
    {
        // fetch those lineitem ids who changed the ServiceDate
        Set<Id> oppLineItemIds = new Set<Id>();
        for(OpportunityLineItem opli : newMap.values())
        {
            if(opli.ServiceDate != null && opli.ServiceDate != oldMap.get(opli.Id).ServiceDate)
            {
                oppLineItemIds.add(opli.Id);
            }
        }
        
        if(oppLineItemIds.size() > 0)
        {
            List<OpportunityLineItemSchedule> listSchedule = new List<OpportunityLineItemSchedule>();
            for(OpportunityLineItem opli : [select id,ServiceDate,(Select Id,ScheduleDate From OpportunityLineItemSchedules order by ScheduleDate) from OpportunityLineItem where id in :oppLineItemids])
            {
                if(opli.OpportunityLineItemSchedules != null && opli.OpportunityLineItemSchedules.size() > 0)
                {
                    Date startDate = opli.ServiceDate;
                    for(OpportunityLineItemSchedule oppSch : opli.OpportunityLineItemSchedules)
                    {
                        oppSch.ScheduleDate = startDate;
                        startDate = startDate.addMonths(1);
                        listSchedule.add(oppSch);
                    }
                }
            }
            
            // update schedule
            if(listSchedule.size() > 0)
            {
                update listSchedule;
            }
        }
    }
}