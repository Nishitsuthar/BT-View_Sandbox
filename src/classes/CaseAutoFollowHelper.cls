public without sharing class CaseAutoFollowHelper {

    public static void autofollowCase(Id caseId, Id memberId) {
        
        String sObjName = memberId.getSObjectType().getDescribe().getName();
        if(sObjName == 'User'){
            List<EntitySubscription> existingRecord = new List<EntitySubscription>();
            existingRecord=[select id from EntitySubscription where ParentId=:caseId and SubscriberId=:memberId LIMIT 1];
            if(existingRecord.isEmpty()){
                EntitySubscription es = new EntitySubscription();
                es.ParentId = caseId;
                es.SubscriberId = memberId;
                database.insert(es);
            }
        }
    } 
}