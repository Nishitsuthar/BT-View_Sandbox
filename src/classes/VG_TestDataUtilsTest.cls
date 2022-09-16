@isTest(SeeAllData=false)
public class VG_TestDataUtilsTest {
   
        @isTest static void test_TestDataUtilsTest() {
             Account ac=new Account();
    ac.Name='VGAccount';
    INSERT ac;
             Test.startTest();
             User u= VG_TestDataUtils.createUser();
           /* Account a=VG_TestDataUtils.createAccount();
            task t=VG_TestDataUtils.createTask();
            Contact c=VG_TestDataUtils.createContact(ac.id);
            List<EC_Settings__c> createECSettings1=VG_TestDataUtils.createECSettings();
            List<EC_UserData__c> getUserData1=VG_TestDataUtils.getUserData();
            Event e=VG_TestDataUtils.createEvent('Company');
            CollaborationGroup co= VG_TestDataUtils.createCollaborationGroup();*/
             Test.stopTest();
        }
}