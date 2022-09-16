@isTest(SeeAllData=false)
public class VG_SettingsTest {
   
        @isTest static void test_VG_SettingsTest() {
            EC_Settings__c ec=new EC_Settings__c();
            ec.name='DefaultLocation';
            ec.Type__c='type';
            insert ec;
              Test.startTest();
            Map<String, List<EC_Settings__c>> getSettingsByType1=VG_Settings.getSettingsByType('type','');
             Map<String, List<EC_Settings__c>> getSettingsByType2=VG_Settings.getSettingsByType('name','Text1__c');
             Test.stopTest();
        }
}