@isTest
public class VG_OrgChartUtilsCtrlTest {
    public static testmethod void testgetParent_SubOrdinateUsers(){		
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User manager = new User(Alias = 'sysadmin', Email='sysadmin@view.com',
				 EmailEncodingKey='UTF-8', LastName='Smith', FirstName='John', LanguageLocaleKey='en_US',
				 LocaleSidKey='en_US', ProfileId = p.Id, Phone='1234567890',Department='Sales', City='Atlanta',  
				 TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuse1@testorg.com', Title ='CEO');
		insert manager;
		List<Id> magId=new List<Id>();
        magId.add(manager.Id);
		User emp = new User(Alias = 'sysadmin', Email='sysadmin@view.com',
				 EmailEncodingKey='UTF-8', LastName='Smith', FirstName='Jim', LanguageLocaleKey='en_US',
				 LocaleSidKey='en_US', ProfileId = p.Id, ManagerId=manager.Id, Phone='1234567890',Department='Sales', City='Atlanta',  
				 TimeZoneSidKey='America/Los_Angeles', UserName='jim1@testorg.com', Title ='Director');
		insert emp;

		Test.startTest();
      // Map<Id, SObject> temp= VG_UserDataAccess.getMapByIds(magId);
		String managerResult = VG_OrgChartUtilsCtrl.getParent_SubOrdinateUsers(manager.Id);
        String userId = '';
        String result = VG_OrgChartUtilsCtrl.getParent_SubOrdinateUsers(userId);
        System.assertNotEquals(null, managerResult);
        System.assertNotEquals(null, result);
		Test.stopTest();
	}

}