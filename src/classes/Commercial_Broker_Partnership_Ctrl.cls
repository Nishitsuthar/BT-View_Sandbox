// Updated Date         Developer       Project             Tracking Id                         		Requirement                         
// 25-Jan-2021          Srikanth        Commercial Broker   COMMERCIAL_BROKER_TEAM_MEMBER_IN_OPPTY    	When Commercial Broker Partnership record is created, create  team members in Oppty with users in Newmark Partners profile 

public class Commercial_Broker_Partnership_Ctrl {

    public static void invokeOpptyTeamMemberCreation(List<Commercial_Broker_Partnership__c> CBPartners){
        Set<Id> opptyIDs = new set<Id>();
        Map<Id, User> newMarkUsers = new Map<Id, User>([select id from user where profile.name = 'Newmark Partners' and isActive = true]);
        if (newMarkUsers.size() > 0){
            for(Commercial_Broker_Partnership__c cbp : CBPartners)
            {
                if (!opptyIDs.contains(cbp.Opportunity_Name__c) ){
                    opptyIDs.add(cbp.Opportunity_Name__c);
                }
            }
            system.debug('newMArkUSers:' + newMarkUsers.keySet() );
            createOpptyTeamMembers(newMarkUsers.keySet() ,opptyIDs);
        }
    }
    public static void createOpptyTeamMembers(Set<Id> userIDs, Set<Id> opptyIDs){
        List<OpportunityTeamMember> insertOpptyTeamMembers = new List<OpportunityTeamMember>();
        Boolean userExists = false;
        Map<Id,Opportunity> OpptyIdTeam = new Map<Id, Opportunity>([select id, (select id, OpportunityId, UserId from OpportunityTeamMembers) from Opportunity where Id in: opptyIDs]);
        system.debug('userIDs: ' + userIDs);
        system.debug('opptyIDs: ' + opptyIDs);
        system.debug('OpptyIdTeam: ' + OpptyIdTeam);
        for (String opptyid: opptyIDs){
            for (Id UId: userIDs){
                userExists = false;
                for (OpportunityTeamMember otm: OpptyIdTeam.get(opptyid).OpportunityTeamMembers){
                    if (otm.UserId == UId)
                	    userExists = true;
                }
                if (!userExists){
                   	OpportunityTeamMember OM = new OpportunityTeamMember(OpportunityId=opptyid,UserId = UId, TeamMemberRole = Label.Default_Commercial_Broker_Partnership_Role, OpportunityAccessLevel='Edit' );
                    insertOpptyTeamMembers.add(OM);
                    system.debug('OM: ' + OM);
                }      
            }                
        }
        system.debug('insertOpptyTeamMembers: ' + insertOpptyTeamMembers);
        if (insertOpptyTeamMembers.size() > 0){
            insert insertOpptyTeamMembers;
        }
    }
}