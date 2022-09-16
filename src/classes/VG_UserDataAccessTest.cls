@isTest(SeeAllData=false)
public class VG_UserDataAccessTest {
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
    @isTest static void Test_getMapByIds() { 
        setup();
        User user3 = VG_TestDataUtils.createUser();
        user3.Username= 'johny' + nowString + '.whites@view.com';
        user3.FirstName = 'Johny' + nowString;
        user3.LastName = 'Whites';
        user3.Employee_Department__c = 'Sales';
        user3.City = 'Santa Clara';
        insert user3;
        List<Id> recordIds=new List<String>{user3.Id};
            Test.startTest();  
        Map<Id, SObject>usr= VG_UserDataAccess.getMapByIds(recordIds);
        LIST<String>usr3= VG_UserDataAccess.getRoles();
        LIST<String>usr1= VG_UserDataAccess.getLocations();
        LIST<String>usr2= VG_UserDataAccess.getDepartments();
        string us=VG_UserDataAccess.getUserInfo();
        Test.stopTest();
    }
    
    @isTest static void Test_getDetailsById() { 
        setup();
        User user3 = VG_TestDataUtils.createUser();
        user3.Username= 'johny' + nowString + '.whites@view.com';
        user3.FirstName = 'Johny' + nowString;
        user3.LastName = 'Whites';
        user3.Employee_Department__c = 'Sales';
        user3.City = 'Santa Clara';
        insert user3;
        List<Id> recordIds=new List<String>{user3.Id};
            Test.startTest();  
        LIST<User>usr= VG_UserDataAccess.getDetailsById(recordIds);
        Test.stopTest();
    }
    
    @isTest static void Test_getDetailsByManagers() { 
        setup();
        User user3 = VG_TestDataUtils.createUser();
        user3.Username= 'johny' + nowString + '.whites@view.com';
        user3.FirstName = 'Johny' + nowString;
        user3.LastName = 'Whites';
        user3.Employee_Department__c = 'Sales';
        user3.City = 'Santa Clara';
        insert user3;
        List<Id> recordIds=new List<String>{user3.Id};
            Test.startTest();  
        LIST<User>usr= VG_UserDataAccess.getDetailsByManagers(recordIds);
        Test.stopTest();
    }
    @isTest static void test_searchUsersByFilters() {
        setup();
        
        Test.startTest();
        List<String> departments = new List<String>();
        List<String> locations = new List<String>();
        List<String> roles = new List<String>();
        List<User> users = VG_UserDataAccess.searchUsersByFilters('Johny', departments, locations, 'FirstName','ASC',roles,10);
        Test.stopTest();
    }
    
    @isTest static void test_searchUsersByFilters_withValues() {
        setup();
        
        Test.startTest();
        List<String> departments = new List<String>{'All'};
            List<String> locations = new List<String>{'Global'};
                List<String> roles = new List<String>{'All'};
                    List<User> users = VG_UserDataAccess.searchUsersByFilters('Johny', departments, locations, 'FirstName','ASC',roles,10);
        Test.stopTest();
    }
    static testmethod void navigations(){
        VG_UserDataAccess.getPrefix();
        VG_UserDataAccess.getDepartmentNavigations();
    }
}