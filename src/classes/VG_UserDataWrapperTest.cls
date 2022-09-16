@isTest(SeeAllData=false)
public class VG_UserDataWrapperTest {
 @isTest 
    static void Test_VG_UserDataWrapper() { 
       Test.startTest();  
       // VG_UserDataWrapper(SObject record, EC_UserData__c userData)
          List<VG_UserDataWrapper> ecContentWrapperNewList = new List<VG_UserDataWrapper>();
		SObject temp;
        EC_UserData__c content =new EC_UserData__c();
    VG_UserDataWrapper wrapper=    new VG_UserDataWrapper(temp,content);
        Test.stopTest();
    }
}