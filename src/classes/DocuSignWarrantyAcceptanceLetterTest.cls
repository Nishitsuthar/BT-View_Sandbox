@IsTest
public class DocuSignWarrantyAcceptanceLetterTest {
    /*
* setupTestdata : sets the test data
*/
    @testSetup static void setupTestdata() {
        
        Opportunity opp = new Opportunity(Name ='opptest',closedate=date.today(),stagename='Open');
        database.insert(opp);
    }
    /*
* getOpportunityTest : test the method by passing null as id
*/   
    @IsTest static void getOpportunityTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity OpportunityRecord; 
            test.starttest();
            OpportunityRecord =DocuSignWarrantyAcceptanceLetter.getOpportunity(null);
            test.stopTest();
            System.assertEquals(null,OpportunityRecord.Id, 'Should be user not queue');        
        }
    }
    /*
* getOpportunityIncorrectIdTest : test the method by passing incorrect id
*/
    @IsTest static void getOpportunityIncorrectIdTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Field Service Admin','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity OpportunityRecord; 
            test.startTest();
            OpportunityRecord = DocuSignWarrantyAcceptanceLetter.getOpportunity(u1.Id);
            test.stopTest();
            System.assertEquals(null,OpportunityRecord.Id, 'Should be user not queue');        
        }
    }
    /*
* getOpportunitySuccessTest : test the method by passing correct id
*/
    @IsTest static void getOpportunitySuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity OpportunityRecord = [select Id  from Opportunity where Name = 'opptest'];
			Opportunity caCheck;
            test.startTest();
            caCheck = DocuSignWarrantyAcceptanceLetter.getOpportunity(OpportunityRecord.Id);
            test.stoptest();
            System.assertEquals(caCheck.Id,OpportunityRecord.Id, 'Should be user not queue');        
        }
    }    
}