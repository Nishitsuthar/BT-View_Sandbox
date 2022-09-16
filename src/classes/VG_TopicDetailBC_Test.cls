@Istest(SeeAllData=true)
public class VG_TopicDetailBC_Test {
    
    public static testmethod void sitelayouttest(){
        Topic Ssec=new Topic();
        Ssec.name='Product';
        Insert Ssec;
        VG_TopicDetail.getKnowledgeArticleInfo(Ssec.Id);
        VG_TopicDetail.getTopicHierarchy([SELECT Id FROM Topic WHERE NetworkId != null AND ManagedTopicType = :String.valueOf(ConnectApi.ManagedTopicType.Navigational) LIMIT 1].Id);
    	VG_KnowledgeDataAccess.getKnowledgeArticleInfoWithParent([SELECT Id FROM Knowledge_Article__kav LIMIT 1].Id);
    }
}