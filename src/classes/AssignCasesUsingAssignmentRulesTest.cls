@IsTest
public class AssignCasesUsingAssignmentRulesTest {
    /*
* setupTestdata : sets the test data
*/
    @testSetup static void setupTestdata() {
        
        Case caseRec = new Case(Subject ='caseTest');
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = false;        
        caseRec.setOptions(dmo);
        database.insert(caseRec);
    }
    /*
* assignCasesTest : test the method by passing null as id
*/   
    @IsTest static void assignCasesTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            Case caseRecord = [select Id  from Case where subject = 'caseTest']; 
            test.starttest();
            AssignCasesUsingAssignmentRules.assignCases(null);
            test.stopTest();
            Case caCheck = [SELECT Id, OwnerId FROM Case WHERE Id = :caseRecord.Id];
            String ownerid = String.valueOF(caCheck.OwnerId);
            System.assertNotEquals(true,ownerid.Startswith('00G'), 'Should be user not queue');        
        }
    }
    /*
* assignCasesIncorrectIdTest : test the method by passing incorrect id
*/
    @IsTest static void assignCasesIncorrectIdTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Field Service Admin','atestOwner2@test.demo');
        System.runAs(u1) {
            Case caseRecord = [select Id  from Case where subject = 'caseTest']; 
            test.startTest();
            AssignCasesUsingAssignmentRules.assignCases(new List<ID>{u1.Id});
            test.stopTest();
            Case caCheck = [SELECT Id, OwnerId FROM Case WHERE Id = :caseRecord.Id];
            String ownerid = String.valueOF(caCheck.OwnerId);
            System.assertNotEquals(true,ownerid.Startswith('00G'), 'Should be user not queue');        
        }
    }
    /*
* assignCasesSuccessTest : test the method by passing correct id
*/
    @IsTest static void assignCasesSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Case caseRecord = [select Id  from Case where subject = 'caseTest']; 
            test.startTest();
            AssignCasesUsingAssignmentRules.assignCases(new List<ID>{caseRecord.Id});
            test.stoptest();
            Case caCheck = [SELECT Id, OwnerId FROM Case WHERE Id = :caseRecord.Id];
            String ownerid = String.valueOF(caCheck.OwnerId);
            System.assertEquals(true,ownerid.Startswith('00G'), 'Should be the queue not the user');            
        }
    }    
}