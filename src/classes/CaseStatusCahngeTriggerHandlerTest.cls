@IsTest
public class CaseStatusCahngeTriggerHandlerTest {
    
    @testSetup static void setupTestdata() {
        
        Case newCase = new Case();
        newCase.Subject = 'Unittest';
        newCase.Status = 'New';
        newCase.Priority = 'P3';
        insert newCase; 
        
        Case testCase = [select Subject, Status from Case where Subject = 'Unittest']; 
        System.assertEquals(testCase.Subject, 'Unittest');
    }
    
    
    
    @IsTest static void testOnAfterInsert(){
        try{
            Case[] testCase = [select Subject, CaseNumber, Status, Owner.Name from Case where Subject = 'Unittest'];
            CaseStatusChangeTriggerHandler.OnAfterInsert(testCase);
            
            Case_Status_Change__c[] caseStatusChange = [select Name from Case_Status_Change__c where Case__r.Id =:testCase[0].Id];
            
            System.assertEquals(caseStatusChange[0].Name, testCase[0].CaseNumber + ' status: New');
        }
        catch(Exception e){
        }
        
    }
    
    
    @IsTest static void testOnAfterUpdate(){
        try{
            Map<Id, Case> oldObjectMap = new Map<Id, Case>();
            
            Case testCase = new Case(Subject = 'Unittest',Status = 'New');
            database.insert(testCase);
            
            testCase.Status = 'Escalated';
            database.update(testCase);
            
            Case_Status_Change__c[] caseStatusChange = [select Name from Case_Status_Change__c where Case__r.Id=:testCase.Id and Change_Time__c = null];
        }
        catch(Exception e){
        }
        
    }
    
    /**
*Tests if the user does not have access to Case and Case_Status_Change__c objects
*/
    @IsTest static void testAccessible1(){
        
        User u = getUser('Finance','atest5@test.demo');
        
        System.runAs(u) {
            try {
                testOnAfterInsert();
            }
            catch (QueryException e) {
                System.assertEquals(e.getMessage(), 'Insufficient access to Case or User objects');         
            }   
        }
        
    }
    
    @IsTest static void testAccessible2(){
        
        User u = getUser('Finance','atest1@test.demo');
        
        System.runAs(u) {
            try {
                testOnAfterUpdate();
            }
            catch (QueryException e) {
                System.assertEquals(true,e.getMessage().contains('Insufficient access to Case Status Change or business hours objects'));         
            }   
        }
    }
    
    @IsTest static void testCreatable(){
        
        User u = getUser('Finance','atest2@test.demo');
        
        System.runAs(u) {
            try {
                testOnAfterInsert();
            }
            catch (DmlException e) {
                System.assertEquals(e.getMessage(), 'Insufficient permissions to create Case Status Change');         
            }    
        }
        
        System.runAs(u) {
            try {
                testOnAfterUpdate();
            }
            catch (DmlException e) {
                System.assertEquals(true,e.getMessage().contains('Insufficient permissions to create Case Status Change'));         
            }    
        }     
    }
    
    @IsTest static void testUpdatable(){
        
        User u = getUser('System Administrator','atest3@test.demo');
        
        System.runAs(u) {
            try {
                testOnAfterUpdate();
            }
            catch (DmlException e) {
                System.assertEquals(false,e.getMessage().contains('Insufficient permissions to update Case Status Change'));         
            }
            
        }      
    }
    @IsTest static void testOnAfterUpdateOwner(){
        User u = getUser('System Administrator','atestOwner1@test.demo');
        User u1 = getUser('System Administrator','atestOwner2@test.demo');
        database.insert(u1);
        Map<Id, Case> oldObjectMap = new Map<Id, Case>();
        system.runAs(u){
            Case testCase = new Case(Subject = 'Unittest',Status = 'New',Priority = 'P3');
            database.insert(testCase);
            group gp = new group(name='test', Type='Queue');
            insert gp;
            QueuesObject testQueue = new QueueSObject(QueueID = gp.id, SObjectType = 'Case');
            insert testQueue;
            testCase.Status = 'Escalated';
            testCase.ownerId=u1.id;
            database.update(testCase);
            testCase.ownerId=gp.Id;
            database.update(testCase);
            testCase.ownerId=u1.id;
            database.update(testCase);
            testCase.Status = 'Closed';
            database.update(testCase);
            
        }
        
    }    
    public static User getUser(String profileName,String userName) {
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName limit 1];
        
        String testemail = 'atest@test.demo';
        User pu = new User(profileId = p.Id, username = userName, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname');
        
        return pu;
        
        
    }
    
}