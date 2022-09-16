@IsTest
public class CreateOracleCustomerTest {
    /*
    * getAccountDataIncorrectIdTest : sets the test data
    */
    @testSetup static void setupTestdata() {
        Account newAccount = new Account();
        newAccount.Name = 'Unittest';
        database.insert(newAccount); 
        
        Account accountCreated = [select name  from Account where name = 'Unittest']; 
        System.assertEquals(accountCreated.name, 'Unittest');
    }
    /*
    * getAccountDataTest : test the method by passing null as id
    */   
    @IsTest static void getAccountDataTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Account accountCreated = [select name  from Account where name = 'Unittest']; 
            test.starttest();
            Account returnResult = CreateOracleCustomer.getAccountData(null);
            CreateOracleCustomer.getProfileData();
            test.stopTest();
            system.assertEquals(null, returnResult.id);
        }
    }
    /*
    * getAccountDataIncorrectIdTest : test the method by passing incorrect id
    */
    @IsTest static void getAccountDataIncorrectIdTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Field Service Admin','atestOwner2@test.demo');
        System.runAs(u1) {
            Account accountCreated = [select name  from Account where name = 'Unittest']; 
            test.startTest();
            Account returnResult = CreateOracleCustomer.getAccountData(userinfo.getUserId());
            test.stopTest();
            system.assertEquals(null, returnResult.Id);
        }
    }
    /*
    * getAccountDataSucessTest : test the method by passing correct id
    */
    @IsTest static void getAccountDataSucessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
            System.runAs(u1) {
            Account accountCreated = [select name  from Account where name = 'Unittest']; 
            test.starttest();
            Account returnResult = CreateOracleCustomer.getAccountData(accountCreated.Id);
            test.stoptest();
            system.assertEquals(accountCreated.Id, returnResult.Id);
        }
    }    
    /*
    * saveDetailsErrorTest : test the method by passing null
    */
    @IsTest static void saveDetailsErrorTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
            System.runAs(u1) {
            Account accountCreated = [select name  from Account where name = 'Unittest']; 
            test.startTest();
                Boolean returnResult =CreateOracleCustomer.saveDetails(null);
            test.stopTest();
            system.assertEquals(false, returnResult);
        }
    }
    /*
    * saveDetailsSuccessTest : test the method by passing correct account
    */
    @IsTest static void saveDetailsSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Account accountCreated = [select name  from Account where name = 'Unittest']; 
            Boolean returnResult;
            test.startTest();
            returnResult = CreateOracleCustomer.saveDetails(accountCreated);
            test.stopTest();
            system.assertEquals(true, returnResult);
        }
    }
}