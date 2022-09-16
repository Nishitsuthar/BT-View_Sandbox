@IsTest
private class AssignedResourcesHelperTest{
    /*
    * setupTestdata : sets the test data
    */
    @testSetup static void setupTestdata(){
        
        Account newCase = new Account(name = 'Unittest');
        database.insert(newCase);
        
            Case caseRecord = new Case(Subject='Test'); 
            insert caseRecord;
        
        Id devRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Service').getRecordTypeId();

        WorkOrder issue= new WorkOrder(accountid = newCase.id,recordtypeid =devRecordTypeId,subject = 'Testing',caseId=caseRecord.Id);
        database.insert(issue);

        
        ServiceAppointment ifm= new ServiceAppointment(Work_Order__c = issue.id,ParentRecordId=issue.id,
                                                        EarliestStartTime = DateTime.now(),DueDate = DateTime.now());
        database.insert(ifm);
    }

    @IsTest static void getAssignedResourcesTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            List<AssignedResource> OpportunityRecord; 
            test.starttest();
            OpportunityRecord =AssignedResourcesHelper.getAssignedResources(null);
            test.stopTest();
            System.assertEquals(true,OpportunityRecord.isEmpty());        
        }
    }
    @IsTest static void getAssignedResourcesSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            List<AssignedResource> OpportunityRecord; 
            WorkOrder wo = [select id from WorkOrder ];
            test.starttest();
            OpportunityRecord =AssignedResourcesHelper.getAssignedResources(wo.Id);
            test.stopTest();
            System.assertEquals(true,OpportunityRecord.isEmpty());        
        }
    }
    @IsTest static void getFieldSetMemberSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            List<AssignedResourcesHelper.FieldSetMemberWrapperClass> OpportunityRecord; 
            test.starttest();
            OpportunityRecord =AssignedResourcesHelper.getFieldSetMember('AssignedResource','Assigned_Resources');
            test.stopTest();
            System.assertEquals(false,OpportunityRecord.isEmpty());        
        }
    }
    @IsTest static void getFieldSetMemberErrorTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            List<AssignedResourcesHelper.FieldSetMemberWrapperClass> OpportunityRecord; 
            test.starttest();
            OpportunityRecord =AssignedResourcesHelper.getFieldSetMember(null,null);
            test.stopTest();
            System.assertEquals(true,OpportunityRecord.isEmpty());        
        }
    }
}