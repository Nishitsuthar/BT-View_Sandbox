@isTest(SeeAllData=false)
public class VG_RecordTypeDataAccessTest {
 @isTest 
    static void Test_getRecordTypeByDeveloperNameAndType() { 
     Test.startTest();  
   //(List<String> developerNames, List<String> objectTypes)
        VG_RecordTypeDataAccess.getRecordTypeByDeveloperNameAndType(new List<String>{'Recently_Viewed'}, new List<String>{'EC_UserData__c'});
        VG_RecordTypeDataAccess.getRecordTypeByDeveloperNameTypeActive(new List<String>{'Recently_Viewed'}, new List<String>{'EC_UserData__c'},true);
        Test.stopTest();
    }
}