@isTest
public class VG_UserDataServiceTest {
    
    @isTest static void retrieveRecentlyViewedTest(){
        RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Recently_Viewed'];
        EC_UserData__c userData = new EC_UserData__c();
        userData.Record_Id__c = rec.Id;
        userData.Type__c = 'User';
        userData.Url__c = 'profile/';
        userData.Title__c = 'Profile';
        userData.User__c = UserInfo.getUserId();
        insert userData;
        Test.startTest();
        VG_UserDataService.retrieveRecentlyViewed(5); 
       // VG_UserDataService.retrieveAndMarkAllAlertsRead();
       // VG_UserDataService.markAllAlertsRead(new list<Id>{userData.Id},true);
        Test.stopTest();
    }
     @isTest static void saveRecentlyViewedTest(){
         
        RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Recently_Viewed'];
           EC_UserData__c userData = new EC_UserData__c();
         userData.RecordTypeId =rec.Id;
        userData.Record_Id__c = rec.Id;
        userData.Type__c = 'User';
        userData.Url__c = 'profile/';
        userData.Title__c = 'Profile';
        userData.User__c = UserInfo.getUserId();
        insert userData;
        Test.startTest();
     // VG_UserDataService.retrieveAlerts(3);
        VG_UserDataService.saveRecentlyViewed('Recently_Viewed', rec.Id,'profile/', 'User', 'Profile');
		Test.stopTest();
    }
}