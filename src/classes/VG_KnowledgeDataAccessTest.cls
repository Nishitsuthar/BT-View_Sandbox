@isTest(SeeAllData=false)
public class VG_KnowledgeDataAccessTest {
        @isTest static void test_getKnowledgeArticleByNumber() {
           
            Knowledge_Article__kav ka=new Knowledge_Article__kav();
            ka.Title='training ';
            ka.Summary='test knowledge article';
            ka.UrlName='url';
			ka.language='en_US';
            insert ka;
            List<Id> MapByArticles=new List<Id>();
            List<Id> MapByArticles1=new List<Id>{ka.id};
                List<SObject> partialResult=new List<SObject>();
            Set<String> selectFields=new Set<String>{'language'};
            Test.startTest();
            List<String> articleNumbers = new List<String>{'000001049'} ;    
            List<SObject> allArticle=VG_KnowledgeDataAccess.getKnowledgeArticleByNumber(articleNumbers);
            List<SObject> ArticleByUserName =VG_KnowledgeDataAccess.getArticlesByUrlName('url','en_US');
            List<SObject> ArticlesByLanguage=VG_KnowledgeDataAccess.getArticlesByLanguageAndType('language','en_US','');
            //List<SObject> KnowledgeArticleVersion=VG_KnowledgeDataAccess.findKnowledgeArticleVersion('training','Limit 7','id,title ','WHERE Language=\'en_US\' ');
            VG_KnowledgeDataAccess.findKnowledgeArticleVersion('training','LIMIT 7', 'id,title ', 'WHERE Language=\'en_US\' ');
            List<SObject> getArticleVersionsFromTopics=VG_KnowledgeDataAccess.getArticleVersionsFromTopics('training','id,title',partialResult);
            List<SObject> ArticleTypeByArticle=VG_KnowledgeDataAccess.getArticleTypeByArticleNumbers('','Knowledge_Article');
            Knowledge_Article__kav articleid=VG_KnowledgeDataAccess.getKnowledgeArticleInfo(ka.id);
            Knowledge_Article__kav articleid1=VG_KnowledgeDataAccess.getQandAKnowledgeArticleInfo(ka.id);
            Map<Id, SObject> getMapByArticles=VG_KnowledgeDataAccess.getMapByArticles(MapByArticles1);
             Map<Id, SObject> getMapByArticles1=VG_KnowledgeDataAccess.getMapByArticles(MapByArticles);
            Map<Id, SObject> ArticleVersionMapByIds=VG_KnowledgeDataAccess.getKnowledgeArticleVersionMapByIds(MapByArticles);
            List<SObject> ArticleTypeVersion=VG_KnowledgeDataAccess.getArticleTypeVersion('en_US',ka.id,'Knowledge_Article__kav','select id ',selectFields);
            
            Test.stopTest();
    }
}