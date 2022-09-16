@isTest(SeeAllData=False)
public class DatesTriggerTest {
  
    @isTest(SeeAllData=False)
    static void testclass()
    {
         
      List<User> uLst = new List<User>();  
        User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Intranet Basic Profile'].Id,
     LastName = 'last',
     Email = 'test@view.com',
     Username = 'test21qw123@view.com',
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     IsActive = true,
     Employee_ID__c = '98787'
   //  UserRoleId = r.Id
);
        uLst.add(u);
         User u2 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Intranet Basic Profile'].Id,
     LastName = 'second',
     Email = 'test21111@view.com',
     Username = 'test21111@view.com',
     CompanyName = 'TEST2',
     Title = 'title2',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     IsActive = false,
     Employee_ID__c = '34564'
   //  UserRoleId = r.Id
);
         uLst.add(u2);
        
         User u3 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Intranet Basic Profile'].Id,
     LastName = 'Third',
     Email = 'test312121@view.com',
     Username = 'test312211@view.com',
     CompanyName = 'TEST2',
     Title = 'title2',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     IsActive = true
   //  UserRoleId = r.Id
);
         //uLst.add(u3);
        insert uLst;
 User testUsr;
        User testUsr1;
  List<Profile> ProfileId1;      
ProfileId1 = [SELECT Id FROM Profile WHERE Name = 'Standard Platform User' LIMIT 1];
 testUsr = [SELECT Id, ProfileId, IsActive FROM user WHERE  Employee_ID__c = '98787' LIMIT 1];
     testUsr.ProfileId = ProfileId1[0].Id;
     testUsr.IsActive = False; 
        update testUsr;
  testUsr1 = [SELECT Id, ProfileId, IsActive FROM user WHERE  Employee_ID__c = '34564' LIMIT 1];
     testUsr1.IsActive = true; 
        update testUsr1;      
                    
             
}
}