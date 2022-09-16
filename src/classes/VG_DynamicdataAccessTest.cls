@isTest(SeeAllData=false)
public class VG_DynamicdataAccessTest {
    
    @isTest static void test_searchUsersByFilters() {
        Test.startTest();
        List<SObject> recs = VG_DynamicdataAccess.getAllRecords('EC_Content__c','Name','Name');
        List<SObject> rec = VG_DynamicdataAccess.getRecordsBySearch('EC_Content__c','Name','Name','search');
        List<SObject> records = VG_DynamicdataAccess.getRecordsByGlobalSearch('EC_Content__c','Name','Name','search');
        Test.stopTest();
    }
    
    @isTest static void test_searchUsersByFilters_user() {
        Test.startTest();
        List<SObject> records = VG_DynamicdataAccess.getRecordsByGlobalSearch('user','Name','Name','search');
        Test.stopTest();
    }
}