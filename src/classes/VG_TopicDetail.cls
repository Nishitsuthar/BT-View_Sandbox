public class VG_TopicDetail {

      @AuraEnabled
    public static Topic getKnowledgeArticleInfo(Id recordIds)
    {
            Topic ArticleVersionInfo = [SELECT Id, Name, Description FROM Topic
                                                           WHERE Id  =:recordIds];
        return ArticleVersionInfo;
    }
    
    @AuraEnabled
    public static List<Topic> getTopicHierarchy(Id recordIds) {
        string commId = [Select Id from Network where Name = 'My View'].Id;
        
        List<String> allParentId = new String[2];
        String parentId = '';
        //fetch direct parent of the topic
        ConnectApi.ManagedTopicCollection mtCollection = ConnectAPI.ManagedTopics.getManagedTopics(commId, ConnectApi.ManagedTopicType.Navigational, new List<Id> {recordIds}, 1);
        for(ConnectApi.ManagedTopic mtopic : mtCollection.managedTopics) {
            
            //if parent exist fetch hierarchy
            if (mtopic.parent != null) {
                parentId = mtopic.parent.id;
                System.debug('parentId'+mtopic.parent.id);
                allParentId.add(0, parentId);
            }
        }
        
        // grab hierarchy of 3 parents
        for (Integer i=0; i<2; i++) {
            if (String.isNotBlank(parentId)) {
                ConnectApi.ManagedTopic parentTopic = ConnectApi.ManagedTopics.getManagedTopic(commId, parentId);
                System.debug('parentTopic'+parentTopic);
                if (parentTopic.parent != null) {
                    System.debug('parentId in loop'+i+parentTopic.parent.id);
                    parentId = parentTopic.parent.id;
                    allParentId.add(0, parentId);
                } else {
                	 parentId = '';           
                }
            }    
        }
        
        List<Topic> allCombinedTopic = new List<Topic>();
        allCombinedTopic.addAll(fetchTopicDetails(allParentId, commId));
        allCombinedTopic.add([SELECT Id, Name FROM Topic WHERE Id  =:recordIds]);
        System.debug('allCombinedTopic'+allCombinedTopic);
        
        return allCombinedTopic;
    }
    
    //@param: managed topic Id
    @AuraEnabled
    public static List<Topic> fetchTopicDetails(List<String> allParentIds, String commId) {
        List<Topic> allHierarchyTopic = new List<Topic>();
        
        System.debug('allParentIds'+allParentIds);
        for (String eachManagedTopicId : allParentIds) {
            if (String.isNotBlank(eachManagedTopicId)) {
                ConnectAPI.ManagedTopic TopicDetail = ConnectAPI.ManagedTopics.getManagedTopic(commId, eachManagedTopicId);
                connectAPI.Topic tp = TopicDetail.topic;
                Topic eachTopic = new Topic();
                eachTopic.Id = tp.id;
                eachTopic.Name = tp.name;
                allHierarchyTopic.add(eachTopic);
            }
        }
        
        return allHierarchyTopic;
    }
    
}