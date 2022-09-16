public class VG_TopicAssignmentClass {
    public List<String> listOfTopics {get; set;}
    public List<String> AllAssociatedTopics {get;set;}
    public String ChoosenTopic {get;set;}
    public String recordId;
 
    public VG_TopicAssignmentClass() {
        listOfTopics = new List<String>();
        for (Topic a: [SELECT Id, Name FROM Topic]) {
            listOfTopics.add(a.Name);
        }
        
        recordId = ApexPages.currentPage().getParameters().get('Id');
        fetchAssociatedTopics();
    }
    
    public PageReference AssociateTopic() {
        //Fetch Network Details
        Network networkId = [Select Id From Network where Name = 'My View'];
        
        //Find if a topic Exist
        List<Topic> fetchTopic = [SELECT Id, Name FROM Topic WHERE Name = :ChoosenTopic AND NetworkId != null];
        List<TopicAssignment> assignment = new List<TopicAssignment>();
        Id topicId = null;
        
        //if topic exist
        if (fetchTopic.size() > 0) {
            topicId = fetchTopic[0].Id;
            
           assignment = [SELECT Id FROM TopicAssignment WHERE TopicId IN :fetchTopic AND EntityId = :recordId];
        } else {
            //create new topic if doesn't exist
            Topic tpc = new Topic();
            tpc.Name = ChoosenTopic;
            tpc.NetworkId = networkId.Id;
            insert tpc;
            topicId = tpc.Id;
        }
        
        //Check if assignment already exist with the same Topic
        if (assignment.size() > 0) {
            //do nothing
        } else {
            //Create Topic Assignment
            
            if (!test.isRunningTest()) {
                ConnectApi.Topics.assignTopic(networkId.Id, recordId, topicId);
            }
            
            fetchAssociatedTopics();
        }
        
        return null;
    }
    
    public void fetchAssociatedTopics() {
        AllAssociatedTopics = new List<String>();
        
        for (TopicAssignment assign : [SELECT Id, EntityId, TopicId, Topic.Name FROM TopicAssignment WHERE EntityId = :recordId]) {
            AllAssociatedTopics.add(assign.Topic.Name);
        }
        
        ChoosenTopic = '';
    }
}