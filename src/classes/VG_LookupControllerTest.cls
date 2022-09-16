@isTest
public class VG_LookupControllerTest {
    private static Integer nowString;
private static void setup() {
		List<User> userList = new List<User>();
		Datetime now = System.now();
		nowString = now.millisecondGMT();
		User user1 = VG_TestDataUtils.createUser();
		user1.Username= 'john' + nowString + '.smith@view.com';
		user1.FirstName = 'John' + nowString;
		user1.LastName = 'Smith';
		user1.Employee_Department__c = 'Human Resource';
		user1.City = 'Los Angeles';
		userList.add(user1);

		User user2 = VG_TestDataUtils.createUser();
		user2.Username= 'john' + nowString + '.doe@view.com';
		user2.FirstName = 'John' + nowString;
		user2.LastName = 'Doe';
		user2.Employee_Department__c = 'Marketing';
		user2.City = 'Los Polos';
		userList.add(user2);

		User user3 = VG_TestDataUtils.createUser();
		user3.Username= 'john' + nowString + '.white@view.com';
		user3.FirstName = 'John' + nowString;
		user3.LastName = 'White';
		user3.Employee_Department__c = 'Sales';
		user3.City = 'Santa Clara';
		userList.add(user3);

		insert userList;

		
	}
    @isTest static void test_getSortOptions() {
		setup();
		Test.startTest();
			 VG_LookupController.searchRecords('User','Name','J',false,'Name');
         VG_LookupController.searchRecords('User','Name','J',true,'Name');
			//VG_LookupController.getPrefix();
			//System.assertNotEquals(null, jsonString);
		Test.stopTest();
	}
}