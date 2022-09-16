@isTest(SeeAllData=false)
public class RecentlyViewedDeleteTriggerTest {
    private static Integer nowString;
    
   
   private static void  setup() {
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         User u = new User(Alias = 'sysadmin', Email='sysadmin@view.com',
                 EmailEncodingKey='UTF-8', LastName='Admin', LanguageLocaleKey='en_US',
                 LocaleSidKey='en_US', ProfileId = p.Id,
                 FirstName = 'Sys',
                 TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuserTesting11@view.com');
         User u1 = new User(Alias = 'sydmin', Email='sadmin@view.com',
                 EmailEncodingKey='UTF-8', LastName='min', LanguageLocaleKey='en_US',
                 LocaleSidKey='en_US', ProfileId = p.Id,
                 FirstName = 'Sy',
                 TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuserTETETEET@view.com');
        
       RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Recently_Viewed'];
       
       System.runAs(u) {
		List<EC_UserData__c> userList = new List<EC_UserData__c>();
		EC_UserData__c user1=new EC_UserData__c();
        user1.Record_Id__c=rec.Id;
        user1.Url__c='/profile/'+u.Id;
        user1.User__c=u.Id;
        user1.RecordTypeId=rec.id;
       
        EC_UserData__c user2=new EC_UserData__c();
        user2.Record_Id__c=rec.Id;
        user2.Url__c='/profile/'+u.Id;
        user2.User__c=u.Id;
        user2.RecordTypeId=rec.id;
       
       EC_UserData__c user3=new EC_UserData__c();
        user3.Record_Id__c=rec.Id;
        user3.Url__c='/profile/'+u.Id;
        user3.User__c=u.Id;
        user3.RecordTypeId=rec.id;
       
       EC_UserData__c user4=new EC_UserData__c();
        user4.Record_Id__c=rec.Id;
        user4.Url__c='/profile/'+u1.Id;
        user4.User__c=u.Id;
        user4.RecordTypeId=rec.id;
       
       EC_UserData__c user5=new EC_UserData__c();
        user5.Record_Id__c=rec.Id;
        user5.Url__c='/profile/'+u1.Id;
        user5.User__c=u.Id;
        user5.RecordTypeId=rec.id;
        userList.add(user1);
        userList.add(user2);
        userList.add(user3);
        userList.add(user4);
        userList.add(user5);
        insert userList;
       }
    }
    @isTest static void test_triggerTest() {
        setup();
    }
}