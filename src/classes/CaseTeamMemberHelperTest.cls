@IsTest
private class CaseTeamMemberHelperTest {
    @testSetup static void setupTestdata(){
            CaseTeamRole ctr = new CaseTeamRole(name='test',AccessLevel='Edit');
            database.insert(ctr);
    }
    @IsTest static void createProductsConsumedTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) { 
            test.startTest();
            CaseTeamMemberHelper.getCaseTeamMembers(userinfo.getUserId());
            test.stopTest();
        }
    }
    @IsTest static void getCaseTeamRolesTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) { 
            test.startTest();
            CaseTeamMemberHelper.getCaseTeamRoles();
            test.stopTest();
        }
    }
    @IsTest static void createCaseTeamMembersTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) { 
            test.startTest();
            CaseTeamMemberHelper.createCaseTeamMembers(null,null,null);
            test.stopTest();
        }
    }    
    @IsTest static void deleteCaseTeamRecordsTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) { 
            test.startTest();
            try{
                CaseTeamMemberHelper.deleteCaseTeamRecords(null);
            }
            catch(Exception e){
            }
            test.stopTest();
        }
    }
    @IsTest static void createCaseTeamMembersErrorTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) { 
            Case newCase = new Case(Subject = 'Unittest',Status = 'New');
            database.insert(newCase);
            test.startTest();
            try{
            CaseTeamMemberHelper.createCaseTeamMembers(newCase.Id,newCase.Id,newCase.Id);
            }
            catch(exception e){}
            test.stopTest();
        }
    }
    @IsTest static void createCaseTeamMembersSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        User u2 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner@test.demo');
        database.insert(u2);
        System.runAs(u1) { 
            Case newCase = new Case(Subject = 'Unittest',Status = 'New');
            database.insert(newCase);
            CaseTeamRole ctr =[select id from CaseTeamRole where name='test' limit 1]; 
            test.startTest();
            CaseTeamMemberHelper.createCaseTeamMembers(newCase.Id,u2.Id,ctr.Id);
            test.stopTest();
        }
    }
    @IsTest static void deleteCaseTeamRecordsSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        User u2 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner@test.demo');
        database.insert(u2);
        System.runAs(u1) { 
            Case newCase = new Case(Subject = 'Unittest',Status = 'New');
            database.insert(newCase);
            CaseTeamRole ctr =[select id from CaseTeamRole where name='test' limit 1]; 
            CaseTeamMember ctm = new CaseTeamMember(ParentId = newCase.Id,MemberId=u2.Id,TeamRoleId=ctr.Id);
            database.insert(ctm);
            test.startTest();
            CaseTeamMemberHelper.deleteCaseTeamRecords(new List<String>{ctm.Id});

            test.stopTest();
        }
    }
    
}