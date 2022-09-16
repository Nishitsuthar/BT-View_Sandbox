public without sharing class DeleteEntitySubscriptions {
    
     // Delete Entity Subscriptions when a case status is moved to Closed/Spam
    public static void deleteEntitySubscriptionsCase(List<Case> esToDel, Map<Id,Case> oldCases)
    {
        Set<id> subToDel = new Set<id>();
        for(Case ca : esToDel)
        {
            case oldCase = oldCases.get(ca.Id);
            if((oldCase.Status != 'Closed' && ca.Status == 'Closed') || (oldCase.Status != 'Spam' && ca.Status == 'Spam'))
            {
                subToDel.add(ca.Id);
            }
        }
       
        String cUser = UserInfo.getUserId();
 
            if (subToDel.Size() > 0){
                List<EntitySubscription> subWithCases = [Select id,ParentId,Subscriber.Name from EntitySubscription where ParentId IN:subToDel];// and subscriberId !=: cUser LIMIT 50];
                System.debug('subWithCases:' + subWithCases);
                if(!subWithCases.isEmpty())
                {
                    DELETE subWithCases;
                }
            }

    }
    

}