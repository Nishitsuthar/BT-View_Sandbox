@isTest(SeeAllData=False)
public class UserUpdateAPITest {
    
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
     IsActive = true,
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
        List<processhremployeedataparserctrl.data> dLst = new List<processhremployeedataparserctrl.data>();
        processhremployeedataparserctrl.data userjson = new processhremployeedataparserctrl.data();
          userjson.EMPLOYEE_NUMBER = uLst[0].Employee_ID__c;
          userjson.SUPERVISOR_ID = uLst[1].Id;
        userjson.LAST_NAME = 'First';
            
        
        userjson.ZIP='123456';
         dLst.add(userjson);
        processhremployeedataparserctrl.data userjson2 = new processhremployeedataparserctrl.data();
        userjson2.EMPLOYEE_NUMBER = uLst[1].Employee_ID__c;
        userjson2.EMAIL_ADDRESS = uLst[1].Email;
        userjson2.SUPERVISOR_ID = uLst[0].Id;
        userjson2.LAST_NAME = 'Second';
        userjson2.ZIP='123456';
        
        processhremployeedataparserctrl.data userjson3 = new processhremployeedataparserctrl.data();
        userjson3.EMPLOYEE_NUMBER = '4563';
        userjson3.EMAIL_ADDRESS = 'test.test@test.com';
        userjson3.SUPERVISOR_ID = uLst[1].Id;
         userjson3.LAST_NAME = 'Third';
        userjson3.ZIP='123456';
        
        system.debug('===='+uLst[0]+'===='+uLst[1]);
        dLst.add(userjson2);
        dLst.add(userjson3);
        processhremployeedataparserctrl.Processhremployeedataparser p = new processhremployeedataparserctrl.Processhremployeedataparser();
        p.data = dLst;
        String myJSON = JSON.serialize(p);
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://salesforce.com/services/apexrest/UserUpdateAPI';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(myJSON);
		
       RestContext.request = request;
        
		 string accObj = UserUpdateAPI.doPost();
        
        test.startTest();
            
        DeactivateOrFreezeUsers sh1 = new DeactivateOrFreezeUsers();

         String sch = '0 0 23 * * ?'; system.schedule('Deactivate Or Freeze Users', sch, sh1);  
        
            test.stopTest();

        
    }

}