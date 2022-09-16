@isTest(SeeAllData=false)
public class VG_SearchServiceTest {
    private static Integer nowString;  
    @isTest static void test_searchArticle() {
        Test.startTest();
        List<SObject> allArticle=new List<SObject>();
        List<SObject> recs = VG_SearchService.searchArticles('EC_Content__c','3',1);
        List<SObject> ak=VG_SearchService.retrieveArticleTypes(allArticle);
        List<SObject> article=VG_SearchService.queryAllArticles('eng','allArticle');
         List<SObject> articlequ=VG_SearchService.queryArticles('training','en_US','',2);
        String rec = VG_SearchService.getSearchArticleTypes('Knowledge_Article');
      
        Test.stopTest();
    }
    
    @isTest static void test_searchArticle1() {
        Test.startTest();
        List<SObject> allArticle=new List<SObject>();
        User user2 = VG_TestDataUtils.createUser();
        user2.Username= 'john' + nowString + '.doe@view.com';
        user2.FirstName = 'John' + nowString;
        user2.LastName = 'Doe';
        user2.Employee_Department__c = 'Marketing';
        user2.City = 'Los Polos';
        allArticle.add(user2);
        insert allArticle;
        List<SObject> ak=VG_SearchService.retrieveArticleTypes(allArticle);
        Test.stopTest();
    }
}