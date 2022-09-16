@isTest 
public class VG_UserHierarchyWrapperTest {

 @isTest 
    static void Test_UserHierarchyWrapper() { 
       Test.startTest();  
       // VG_UserHierarchyWrapper(User mUsr, User usr, List<User> subordinates)
          List<user> userList = new List<user>();
		user temp=new user();
        user temp1=new user();
      
    VG_UserHierarchyWrapper wrapper=    new VG_UserHierarchyWrapper(temp,temp1,userList);
        Test.stopTest();
    }
}