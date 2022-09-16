@isTest(SeeAllData=false)

public class VG_AccessControllerTest {
 @isTest 
    static void Test_AccessController() { 
        try{
            Test.startTest();  
            // String objName, String operationType, Set<String> fieldNames
            VG_AccessController.getInstance().returnNoPermissionFieldsNameList('User', 'Read', new Set<String>{'Name'});
            VG_AccessController.getInstance().returnNoPermissionFieldsNameList('User', 'Upsert', new Set<String>{'Name'});
            VG_AccessController.getInstance().returnNoPermissionFieldsNameList('User', 'Insert', new Set<String>{'Name'});
            VG_AccessController.getInstance().returnNoPermissionFieldsNameList('User', 'Delete', new Set<String>{'Department'});
            VG_AccessController.getInstance().returnNoPermissionFieldsNameList('User', 'Update', new Set<String>{'Name'});
            Test.stopTest();
        }
        catch(exception e){
            
        }
    }
}