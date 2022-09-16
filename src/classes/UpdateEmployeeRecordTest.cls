@isTest
public class UpdateEmployeeRecordTest {
    @isTest
    static void testmethod1()
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
     
       SmartSheet_Exceptions__c exp = new SmartSheet_Exceptions__c();
        exp.Employee_Id__c  ='34564';
        exp.Employee_Email_Id__c='test21111@view.com';
        exp.Department__c='Business Development (8620)';
        exp.Physical_Location__c='	Atlanta';
        exp.Supervisor_Id__c='';
        exp.Hire_Date__c= system.today()-10;
        exp.Latest_Rejoin_Date__c = system.today()-2;
        insert exp;
        
        UpdateEmployeeRecord ups = new UpdateEmployeeRecord();
        UpdateEmployeeRecord.updateEmployeeDetails(exp.id);
        
    }
    
    

}