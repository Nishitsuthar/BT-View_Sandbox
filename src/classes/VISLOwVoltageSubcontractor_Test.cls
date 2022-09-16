@isTest
public class VISLOwVoltageSubcontractor_Test {
    @testSetup static void setup() {
        Account account1 = new Account();
        account1.name = 'test';
        account1.buildertek__Alternate_Name__c = 'test';
        account1.buildertek__Bid_Limit__c = 89;
        account1.buildertek__Year_Established__c = '1998';
        insert account1;
        Project__c prj = new Project__c();
        prj.Account__c = account1.id; 
        insert prj;
        Reference__c ref = new Reference__c();
        ref.Account__c = account1.id;
        insert ref;
        
        buildertek__Box_Settings__c bv = new buildertek__Box_Settings__c();
        bv.name = 'BOX API';
        bv.buildertek__Client_Id__c = 'tbuhd7qwlvkob08sp3yjpphlgwnpd754';
        bv.buildertek__Client_Secret__c = 'XA9Eskirfnlqy1cMCegM52docJdODIYV';
        bv.buildertek__API_Key__c ='3WatdV5wN6sKmHWNJltkOCSLkUwfasO8';
        bv.buildertek__Enterprise_ID__c = '841079817';
        insert bv;
    }
    public static testMethod void VIS_GC_Subcontractor(){
        Account account1 = [select id,name from Account limit 1];
        List<Project__c> prj = [select id,name from Project__c limit 1];
        List<Reference__c> ref = [select id,name from Reference__c limit 1];    
        VISLOwVoltageSubcontractor_Controller.getAccount(account1.id);
        VISLOwVoltageSubcontractor_Controller.getSkillLevelPickListValuesIntoList();
         VISLOwVoltageSubcontractor_Controller.getPickListValuesIntoList();
        VISLOwVoltageSubcontractor_Controller.getSkillLevel2PickListValuesIntoList();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        Test.stopTest();
       VISLOwVoltageSubcontractor_Controller.updateAcc('{"Id":"'+account1.id+'","Name":"Goutham.BTVIEW"}','{"Id":"'+prj[0].id+'"}','{"Id":"'+prj[0].id+'"}','{"Id":"'+prj[0].id+'"}','{"Id":"'+ref[0].id+'"}','{"Id":"'+ref[0].id+'"}','{"Id":"'+ref[0].id+'"}','true',account1.id,prj[0].id,prj[0].id,prj[0].id,ref[0].id,ref[0].id,ref[0].id);
    }

}