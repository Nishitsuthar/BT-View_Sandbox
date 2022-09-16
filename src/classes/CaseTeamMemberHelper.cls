public class CaseTeamMemberHelper {
    @auraEnabled
    public static List<CaseTeamMember> getCaseTeamMembers(String caseId){
        List<CaseTeamMember> listCaseTeamMember = new List<CaseTeamMember>();
        try{
            if(caseId != null){
                listCaseTeamMember =[select id,ParentId,Member.Name,TeamRole.AccessLevel, TeamRole.Name 
                                     from CaseTeamMember where  ParentId = : caseId];
            }
        }
        catch(Exception e){}
        return listCaseTeamMember;
    }
    
    @AuraEnabled
    public static Map<Id,CaseTeamRole> getCaseTeamRoles() {
        Map<Id,CaseTeamRole> roleDetail = new Map<Id,CaseTeamRole>();
        roleDetail = new Map<Id,CaseTeamRole>([select id,name from CaseTeamRole ]);
        return roleDetail;
    }
    @AuraEnabled
    public static CaseTeamMember createCaseTeamMembers(Id caseId,Id memberId,Id roleId) {
        CaseTeamMember cst = new CaseTeamMember();
        try{
            if(caseId != null && memberId!= null && roleId != null){
                cst.ParentId = caseId;
                cst.MemberId = memberId;
                cst.TeamRoleId = roleId;
                
                Database.SaveResult sr=  database.insert(cst);
                
                if (sr.isSuccess()){
                    CaseAutoFollowHelper.autoFollowCase(caseId, memberId);
                }
            }
            
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }   
        return cst;
    }
    @AuraEnabled
    public static void deleteCaseTeamRecords(List<String> recordToDelete){
        try{
            if(!recordToDelete.IsEmpty()){
                List<CaseTeamMember> listCaseTeamToDelete = new List<CaseTeamMember>();
                listCaseTeamToDelete = [select id from CaseTeamMember where id in :recordToDelete ];
                database.delete(listCaseTeamToDelete);  
            }
         
        }
        catch(Exception e){
        throw new AuraHandledException(e.getMessage());
        }
    }
}