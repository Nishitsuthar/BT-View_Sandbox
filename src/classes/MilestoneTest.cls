/**
* This class contains unit tests for validating the behavior of Apex class MilestoneUtils 
*/
@isTest
private class MilestoneTest {
    /*
    TestCompleteMilestoneCatch : covers catch block for completeMilestone method
    */
    static testMethod void TestCompleteMilestoneCatch(){
       MilestoneUtils.completeMilestone(null,null);
    }
    /*
    TestCompleteMilestoneCatch : covers block for closeMilestonewhenCaseIsClosed method
    */
    static testMethod void closeMilestonewhenCaseIsClosedTest(){
       CaseTriggerHelper.closeMilestonewhenCaseIsClosed(null,null);
    }   
    /*
    testCompleteMilestoneViaCase : covers completeMilestone method
    */    
    static testMethod void testCompleteMilestoneViaCase(){
        
        Account busAcc = new Account(Name = 'TestForMS', phone='4567890999');
        insert busAcc;
        
        Contact cont = new Contact(FirstName = 'Test', LastName = 'LastName', phone='4567890999', accountid = busAcc.id);
        insert(cont);
        
        
        Entitlement entl = new entitlement(name='Test Entilement',accountid=busAcc.id,type='Gateway Support', 
        StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
        insert entl;
        
        String entlId;
        List<SlaProcess> lstEntitlementProcess = [SELECT Id, Name FROM SlaProcess WHERE Name='Gold Support' and IsActive = true LIMIT 1];
        if(lstEntitlementProcess!= null && lstEntitlementProcess.size()>0){
            entl.SlaProcessId = lstEntitlementProcess[0].id;
            update entl;        
        }
        
        
        if (entl != null){
            entlId = entl.Id; 
        }   
        List<Case> cases = new List<Case>{};
        for(Integer i = 0; i < 3; i++){
            Case c = new Case(Subject = 'Test Case ' + i);
            cases.add(c);
            if (entlId != null){
                c = new Case(Subject = 'Test Case with Entitlement ', AccountId = busAcc.id, ContactId = cont.id, 
                EntitlementId=entl.id, slaStartDate=system.now());
                cases.add(c);
            }
        }
        database.insert(cases);

        cases.get(0).Status = 'Closed';
        cases.get(2).Status = 'Closed';
        
        database.update(cases);
    }
}