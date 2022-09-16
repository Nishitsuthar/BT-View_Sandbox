public class VG_Article_Categories {
    @AuraEnabled
    public static List<ConnectApi.Topic> getNavigationTopics(){
        string commId = [Select Id from Network where Name = 'My View'].Id;
        ConnectApi.ManagedTopicCollection mtCollection = ConnectAPI.ManagedTopics.getManagedTopics(commId, ConnectApi.ManagedTopicType.Navigational);
        List<ConnectApi.Topic> topicList = new List<ConnectApi.Topic>();
        for(ConnectApi.ManagedTopic mtopic : mtCollection.managedTopics)
        {
            topicList.add(mtopic.topic);
        }
        return topicList;
    }
}