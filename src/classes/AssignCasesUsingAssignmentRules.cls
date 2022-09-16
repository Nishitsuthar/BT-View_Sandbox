public class AssignCasesUsingAssignmentRules {
    @InvocableMethod
    public static void assignCases(List<Id> caseIds){
        try{
            if(!caseIds.isEmpty()){
                List<Case> listCasesToUpdate = new List<Case>();
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true;          
                for(Case c : [select id from Case where id in :caseIds limit 200]){
                    c.setOptions(dmo);
                    listCasesToUpdate.add(c);
                }
                if(!listCasesToUpdate.isEmpty()){
                    update listCasesToUpdate;
                }
            }
        }
        catch(Exception e){
        }
        
    }
}