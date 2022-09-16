/*
Name : MilestoneUtils 
Author : Magnet360
*/
public class MilestoneUtils {
    /*
    completeMilestone : completes case milestone
    parameters : caseIds : case for which milestone should be completed
                complDate : Completion date for milestone   
    */
    public static void completeMilestone(List<Id> caseIds, 
                                         DateTime complDate) {
        try{
            List<CaseMilestone> cmsToUpdate = new List<CaseMilestone>();
            if(!caseIds.IsEmpty()){
                cmsToUpdate = [select Id, completionDate
                               from CaseMilestone cm
                               where caseId in :caseIds
                               and completionDate = null 
                               limit 400];
                if (!cmsToUpdate.isEmpty()){
                    for (CaseMilestone cm : cmsToUpdate){
                        cm.completionDate = complDate;
                    }
                    database.update(cmsToUpdate);
                }
            }
        }
        Catch(exception e){
            e.getStackTraceString();
        }
    }
}