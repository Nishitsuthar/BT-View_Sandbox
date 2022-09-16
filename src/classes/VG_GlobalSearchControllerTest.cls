@isTest(SeeAllData=false)
public class VG_GlobalSearchControllerTest {
    
    @isTest static void test_searchArticle() {
        Test.startTest();
        List<SObject> recs = VG_GlobalSearchController.searchArticle('EC_Content__c','3');
        List<user> rec = VG_GlobalSearchController.searchPeople('EC_Content__c','3');
        List<SObject> records = VG_GlobalSearchController.searchAnnouncements('EC_Content__c','3');
        List<Event> record = VG_GlobalSearchController.getEventsBySearchTerm('EC_Content__c',1);
        Test.stopTest();
    }
}