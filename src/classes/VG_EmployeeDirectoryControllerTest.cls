@isTest(SeeAllData=false)
public class VG_EmployeeDirectoryControllerTest {
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

		VG_EmployeeDirectoryController.SelectOption newOption = new VG_EmployeeDirectoryController.SelectOption('name', 'name', true);
		
	}

	@isTest static void test_getSortOptions() {
		setup();

		Test.startTest();
			String jsonString = VG_EmployeeDirectoryController.getSortOptions();

			System.assertNotEquals(null, jsonString);
		Test.stopTest();
	}

	@isTest static void test_getUsers_Search_Firstname() {
		setup();

		Test.startTest();
			List<String> departments = new List<String>();
			List<String> locations = new List<String>();
        	List<String> roles = new List<String>();
        
			Map<String,List<User>> users = VG_EmployeeDirectoryController.getAllUsers(nowString+'', departments, locations, false, 'FirstName', 'ASC',roles);
			System.assertNotEquals(null, users);
			System.assertEquals(3, users.size());
		Test.stopTest();
	}

	@isTest static void test_getUsers_Search_Firstname_Dept() {
		setup();

		Test.startTest();
			List<String> departments = new List<String>{'Sales'};
			List<String> locations = new List<String>();
        	List<String> roles = new List<String>();
			Map<String,List<User>> users = VG_EmployeeDirectoryController.getAllUsers(nowString+'', departments, locations, true, 'FirstName', 'ASC',roles);
			System.assertNotEquals(null, users);
		Test.stopTest();
	}

	@isTest static void test_getUsers_Search_Firstname_Location() {
		setup();

		Test.startTest();
        	List<String> roles = new List<String>();
			List<String> departments = new List<String>();
			List<String> locations = new List<String>{'Los Angeles'};
			Map<String,List<User>> users = VG_EmployeeDirectoryController.getAllUsers(nowString+'', departments, locations, false, '', '',roles);
			System.assertNotEquals(null, users);
		Test.stopTest();
	}

	@isTest static void test_getUsers_Search_Firstname_Dept_Location() {
		setup();

		Test.startTest();
        	List<String> roles = new List<String>();
			List<String> departments = new List<String>{'Sales'};
			List<String> locations = new List<String>{'Los Angeles'};
			Map<String,List<User>> users = VG_EmployeeDirectoryController.getAllUsers(nowString+'', departments, locations, false, '', '',roles);
			System.assertNotEquals(null, users);
		Test.stopTest();
	}

	@isTest static void test_getUsers_Search_Dept() {
		setup();

		Test.startTest();
        	List<String> roles = new List<String>();
			List<String> departments = new List<String>{'Sales'};
			List<String> locations = new List<String>();
			Map<String,List<User>> users = VG_EmployeeDirectoryController.getAllUsers('', departments, locations, false, '', '',roles);
			System.assertNotEquals(null, users);
		Test.stopTest();
	}

	@isTest static void test_getUsers_Search_Location() {
		setup();

		Test.startTest();
        	List<String> roles = new List<String>();
			List<String> departments = new List<String>();
			List<String> locations = new List<String>{'Los Angeles'};
			Map<String,List<User>> users = VG_EmployeeDirectoryController.getAllUsers('', departments, locations, false, '', '',roles);
			System.assertNotEquals(null, users);
		Test.stopTest();
	}

	@isTest static void test_getUsers_Search_Dept_Location() {
		setup();

		Test.startTest();
        	List<String> roles = new List<String>();
			List<String> departments = new List<String>{'Sales'};
			List<String> locations = new List<String>{'Los Angeles'};
			Map<String,List<User>> users = VG_EmployeeDirectoryController.getAllUsers('', departments, locations, false, '', '',roles);
        	VG_EmployeeDirectoryController.getAllFilters();
        	VG_EmployeeDirectoryController.getDepartments();
        	VG_EmployeeDirectoryController.getTestUsers();
			System.assertNotEquals(null, users);
		Test.stopTest();
	}

}