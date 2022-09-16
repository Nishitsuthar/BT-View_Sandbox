public class AssignedResourceTriggerHandler {
 public static Boolean isFirstTime = true;
    public static void followRecord(List<AssignedResource> assignRecords){
        system.debug('AssignRecords '+ assignRecords);       
        List<EntitySubscription> entitySubToBeInsert = new List<EntitySubscription>();
      	Map<Id, Set<Id>> map_PRId_ESIds = new Map<Id, Set<Id>>();
        Set<Id> parentRecordIds = new Set<Id>();
        for(AssignedResource assRec : assignRecords ){
            parentRecordIds.add(assRec.ServiceAppointment.ParentRecordId);  
        }
        for(EntitySubscription existingSubs : [SELECT parentId, subscriberid FROM EntitySubscription WHERE parentId IN :parentRecordIds]) {
            if(map_PRId_ESIds.containsKey(existingSubs.parentId)) {
        		map_PRId_ESIds.get(existingSubs.parentId).add(existingSubs.subscriberid);
            }else {
                map_PRId_ESIds.put(existingSubs.parentId, new Set<Id>{existingSubs.subscriberid});
            }
        }
        for(AssignedResource assRec : assignRecords ){
            if(map_PRId_ESIds.containsKey(assRec.ServiceAppointment.ParentRecordId) && !map_PRId_ESIds.get(assRec.ServiceAppointment.ParentRecordId).contains(assRec.ServiceResource.RelatedRecordId)) {
                EntitySubscription follow = new EntitySubscription(parentId = assRec.ServiceAppointment.ParentRecordId, subscriberid =assRec.ServiceResource.RelatedRecordId);
                entitySubToBeInsert.add(follow);
            }
        }
        system.debug('entitySubToBeInsert  '+entitySubToBeInsert);
        if(!entitySubToBeInsert.isEmpty())
        {
            insert entitySubToBeInsert;
        }
        
    }
}