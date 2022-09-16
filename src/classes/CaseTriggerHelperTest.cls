@IsTest
private class CaseTriggerHelperTest {
    /*
* setupTestdata : sets the test data
*/
    @testSetup static void setupTestdata() {
        
        Opportunity opp = new Opportunity(Name ='opptest',closedate=date.today(),stagename='Invoiced',Approved_Win__c=true);
        Opportunity opp1 = new Opportunity(Name ='opptest11',BOX_Folder_Id__c='111',closedate=date.today(),stagename='Open');

        database.insert(new list<Opportunity>{opp,opp1});
    } 
    /*
* createCaseBOX : test the method by passing null as id
*/   
    @IsTest static void createCaseBOX(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();

            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId);            
            test.starttest();
            database.insert(caseRecord);
            test.stopTest();
            Case caCheck = [SELECT Id,BOX_Folder_Id__c FROM Case WHERE Id = :caseRecord.Id];
            System.assertEquals(null,caCheck.BOX_Folder_Id__c, 'Case Box Folder Id should be null');    
        }
    }
    @IsTest static void checkCaseForBoxFolderCreationCatch(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();

            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId);             
            database.insert(caseRecord);
            test.starttest();
            CaseTriggerHelper.checkCaseForBoxFolderCreation([select id from case limit 1],null);
            test.stoptest();
        }
    }
    @IsTest static void testProcessCaseApproval(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Process').getRecordTypeId();

            Case caseRecord = new Case(Subject='Test',recordtypeId=devRecordTypeId,
            type='TVIS Change',Zones_Affected__c='test',Custom_TVIS_Level__c=1); 
            
            test.starttest();
            database.insert(caseRecord);
            test.stopTest();
        }
    }
    @IsTest static void createCaseBOXWithOppFolder(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity opp = [select name  from Opportunity where name = 'opptest11']; 
            Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();
            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId);            
            test.starttest();
            database.insert(caseRecord);
            test.stopTest();
            Case caCheck = [SELECT Id,BOX_Folder_Id__c FROM Case WHERE Id = :caseRecord.Id];
        }
    }    
    @IsTest static void createCaseBOXSuccess(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity opp = [select name  from Opportunity where name = 'opptest']; 
            Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();
            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId); 
            test.starttest();
            database.insert(caseRecord);
            test.stopTest();    
        }
    }    
    @IsTest static void updateCaseBOXSuccess(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity opp = [select name  from Opportunity where name = 'opptest']; 

            Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();
            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId);             
            database.insert(caseRecord);
            test.starttest();
            caseRecord.Opportunity__c =opp.id;
            database.update(caseRecord);
            database.delete(caseRecord);
            test.stopTest();
   
        }
    }
    @IsTest static void updateCaseBOXWithOppFolder(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity opp = [select name  from Opportunity where name = 'opptest11']; 
            Id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Generic_Defect_Issue').getRecordTypeId();

            Case caseRecord = new Case(Subject='Test',recordtypeid=recordtypeId); 
            database.insert(caseRecord);
            test.starttest();
            caseRecord.Opportunity__c =opp.id;
            database.update(caseRecord);
            test.stopTest();
 
        }
    }
}