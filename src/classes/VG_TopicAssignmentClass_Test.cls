@isTest
public class VG_TopicAssignmentClass_Test {

    @isTest
    public static void testTopicAssignment() {
        Knowledge_Article__kav ka=new Knowledge_Article__kav();
        ka.Title='training ';
        ka.Summary='test knowledge article';
        ka.UrlName='url';
		ka.language='en_US';
        insert ka;
        
        Pagereference pg = new Pagereference('/apex/VG_TopicsAssignment?Id='+ka.Id);
        Test.setCurrentpage(pg);
        
        VG_TopicAssignmentClass assign = new VG_TopicAssignmentClass();
        
        Topic newTopic = new Topic(Name='newArticleTopic'); 
  		insert newTopic;
        
        assign.ChoosenTopic = 'newArticleTopic';
        assign.AssociateTopic();
        
        assign.ChoosenTopic = 'newArticleTopic2';
        assign.AssociateTopic();
    }
}