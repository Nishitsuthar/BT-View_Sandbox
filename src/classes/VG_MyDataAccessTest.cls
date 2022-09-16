@isTest(SeeAllData=false)
public class VG_MyDataAccessTest {
    private static Integer nowString;
    
    private static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'sysadmin', Email='sysadmin@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Admin', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          FirstName = 'Sys',
                          TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuser@testorg.com');
        User u1 = new User(Alias = 'sydmin', Email='sadmin@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='min', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           FirstName = 'Sy',
                           TimeZoneSidKey='America/Los_Angeles', UserName='sysadminus@testorg.com');
        
        RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Recently_Viewed'];
        List<EC_UserData__c> userList = new List<EC_UserData__c>();
        EC_UserData__c user1=new EC_UserData__c();
        user1.Record_Id__c=rec.Id;
        user1.Url__c='/profile/'+u1.Id;
        user1.User__c=u.Id;
        user1.RecordTypeId=rec.id;
        userList.add(user1);
        
        EC_UserData__c user2=new EC_UserData__c();
        user2.Record_Id__c=rec.Id;
        user2.Url__c='/profile/'+u1.Id;
        user2.User__c=u1.Id;
        user2.RecordTypeId=rec.id;
        userList.add(user2);
        insert userList;
        
        
    }
    @isTest static void test_getByDynamic() {
        setup();
        Test.startTest();
        List<String> recordTypes = new List<String>();
        Set<String> additionalFieldSet=new Set<String>();
        List<EC_UserData__c>ecl=VG_MyDataAccess.getByDynamic(recordTypes,'','',1,'',additionalFieldSet);
        Test.stopTest(); 
    }
    @isTest static void test_getByDynamic_data() {
        setup();
        Test.startTest();
        List<String> recordTypes = new List<String>{'Recently_Viewed'};
            Set<String> additionalFieldSet=new Set<String>();
        List<EC_UserData__c>ecl=VG_MyDataAccess.getByDynamic(recordTypes,'','',1,'',additionalFieldSet);
        Test.stopTest(); 
    }
    
    @isTest static void test_getUserDataByRecordTypeIdUrlUser() {
        setup();
        Test.startTest();
        List<EC_UserData__c>ecl=VG_MyDataAccess.getUserDataByRecordTypeIdUrlUser('Recently_Viewed','0050L000007afCBQAY','/profile/0050L000007afCBQAY','005e0000004lNOHAA2');
        Test.stopTest(); 
    }
    
    @isTest static void test_insertUserData() {
        RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Recently_Viewed'];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'sysadmin1', Email='sysadmi1n@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='A1dmin', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          FirstName = 'Sys',
                          TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuser1@testorg.com');
        List<EC_UserData__c> userList = new List<EC_UserData__c>();
        EC_UserData__c user2=new EC_UserData__c();
        user2.Record_Id__c=rec.Id;
        user2.Url__c='/profile/'+u.Id;
        user2.User__c=u.Id;
        user2.RecordTypeId=rec.id;
        userList.add(user2);
        Test.startTest();
        Set<String> fieldSet=new Set<String>{'id'};
            VG_MyDataAccess.insertUserData(fieldSet,userList);
        Test.stopTest();
    }
    
    @isTest static void test_updateUserData() {
        RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Recently_Viewed'];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'sysadmin1', Email='sysadmi1n@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='A1dmin', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          FirstName = 'Sys',
                          TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuser1@testorg.com');
        List<EC_UserData__c> userList = new List<EC_UserData__c>();
        EC_UserData__c user2=new EC_UserData__c();
        user2.Record_Id__c=rec.Id;
        user2.Url__c='/profile/'+u.Id;
        user2.User__c=u.Id;
        user2.RecordTypeId=rec.id;
        userList.add(user2);
        insert userList;
        Test.startTest();
        Set<String> fieldSet=new Set<String>{'id'};
            VG_MyDataAccess.updateUserData(fieldSet,userList);
        Test.stopTest();
    }
    
}