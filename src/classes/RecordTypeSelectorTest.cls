@IsTest
/*
 * RecordTypeSelectorTest : Test class to test coverage of class RecordTypeSelector
 */
private class RecordTypeSelectorTest {
    /*
    * setupTestdata : sets the test data
    */
    @testSetup static void setupTestdata() {
        Account acc = VTestDataUtility.getTestAccount();
        database.insert(acc);
                
        Case caseRecord = new Case(Subject='Test'); 
        database.insert(caseRecord);
               
        Opportunity opp = VTestDataUtility.getTestOpportunity(acc.Id);
        database.insert(opp);
        
        Building__c Building = new Building__c(name='test');
        database.insert(Building);
        
        Building_Account__c ba = new Building_Account__c(Opportunity__c = opp.id,Account__c = acc.Id,Building__c=Building.id);
        database.insert(ba);
        
        WorkOrder issue= new WorkOrder(accountid = acc.id,subject = 'Testing');
        database.insert(issue);    
    }
    /*
    * fetchRecordTypeValuesCatchTest : test the method by passing null as id
    */   
    @IsTest static void fetchRecordTypeValuesCatchTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            Map<Id, String> recordTypeDetails; 
            test.starttest();
            recordTypeDetails =RecordTypeSelector.fetchRecordTypeValues(null,'');
            test.stopTest();
            System.assertEquals(null,recordTypeDetails);        
        }
    }
    /*
    * fetchRecordTypeValuesTest : test the method by passing correct value
    */
    @IsTest static void fetchRecordTypeValuesTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Field Service Admin','atestOwner2@test.demo');
        System.runAs(u1) {
            Map<Id, String> recordTypeDetails; 
            test.startTest();
            recordTypeDetails = RecordTypeSelector.fetchRecordTypeValues('Case',Label.DefaultCaseRecordType);
            test.stopTest();
            System.assertNotEquals(null,recordTypeDetails);        
        }
    }
    
     @IsTest static void fetchRecordTypeValuesTest2(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Field Service Admin','atestOwner2@test.demo');
        System.runAs(u1) {
            Map<Id, String> recordTypeDetails; 
            test.startTest();
            recordTypeDetails = RecordTypeSelector.fetchRecordTypeValuesforcustomersite('Case',Label.DefaultCaseRecordType);
            test.stopTest();
            System.assertNotEquals(null,recordTypeDetails);        
        }
    }
    /*
    * getOpportunitySuccessTest : test the method by passing correct id
    */
    @IsTest static void getOpportunitySuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity OpportunityRecord = [select Id  from Opportunity limit 1];
            Opportunity caCheck;
            test.startTest();
            caCheck = RecordTypeSelector.getOpportunityDetail(OpportunityRecord.Id);
            test.stoptest();
            System.assertEquals(caCheck.Id,OpportunityRecord.Id);        
        }
    }    
    /*
    * getOpportunityInCorrectIdTest : test the method by passing correct id
    */
    @IsTest static void getOpportunityInCorrectIdTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Opportunity OpportunityRecord;
            test.startTest();
            OpportunityRecord = RecordTypeSelector.getOpportunityDetail(u1.Id);
            test.stoptest();
            System.assertEquals(null,OpportunityRecord.Id);        
        }
    }
    /*
    * getIssueDetailTest : test the method by passing correct id
    */
    @IsTest static void getIssueDetailTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            WorkOrder workOrderRec;
            test.startTest();
            workOrderRec = RecordTypeSelector.getIssueDetail(u1.Id);
            test.stoptest();
            System.assertEquals(null,workOrderRec.Id);        
        }
    }    
    /*
    * getIssueDetailSuccessTest : test the method by passing correct id
    */
    @IsTest static void getIssueDetailSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            WorkOrder workOrder = [select Id  from WorkOrder limit 1];
            workOrder  caCheck;
            test.startTest();
            caCheck = RecordTypeSelector.getIssueDetail(workOrder.Id);
            test.stoptest();
            System.assertEquals(caCheck.Id,workOrder.Id);        
        }
    }        
    /*
    * getCustomerSiteDetailTest : test the method by passing correct id
    */
    @IsTest static void getCustomerSiteDetailTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Building_Account__c ba;
            test.startTest();
            ba= RecordTypeSelector.getCustomerSiteDetail(u1.Id);
            test.stoptest();
            System.assertEquals(null,ba.Id);        
        }
    }    
    /*
    * getCustomerSiteDetailSuccessTest : test the method by passing correct id
    */
    @IsTest static void getCustomerSiteDetailSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Building_Account__c ba = [select Id  from Building_Account__c limit 1];
            Building_Account__c  caCheck;
            test.startTest();
            caCheck = RecordTypeSelector.getCustomerSiteDetail(ba.Id);
            test.stoptest();
            System.assertEquals(caCheck.Id,ba.Id);        
        }
    }    
        /*
    * getIssueDetailSuccessTest : test the method by passing correct id
    */
    @IsTest static void getCaseDetailForIssue(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            WorkOrder workOrder = [select Id  from WorkOrder limit 1];
            workOrder  caCheck;
            test.startTest();
            caCheck = RecordTypeSelector.getIssueDetail(workOrder.Id);
            test.stoptest();
            System.assertEquals(caCheck.Id,workOrder.Id);        
        }
    }        
    /*
    * getCaseDetailForIssueTest: test the method by passing correct id
    */
    @IsTest static void getCaseDetailForIssueTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Case ba;
            test.startTest();
            ba= RecordTypeSelector.getCaseDetailForIssue(u1.Id);
            test.stoptest();
            System.assertEquals(null,ba.Id);        
        }
    }    
    /*
    * getCaseDetailForIssueSuccessTest : test the method by passing correct id
    */
    @IsTest static void getCaseDetailForIssueSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Case caseRec = [select Id  from Case limit 1];
            Case caCheck;
            test.startTest();
            caCheck = RecordTypeSelector.getCaseDetailForIssue(caseRec.Id);
            test.stoptest();
            System.assertEquals(caCheck.Id,caseRec.Id);        
        }
    }   
}