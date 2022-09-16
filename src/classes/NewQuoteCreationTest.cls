@isTest
public class NewQuoteCreationTest {
 /*
    * getAccountDataIncorrectIdTest : sets the test data
    */
    @testSetup static void setupTestdata() {
        Account newAccount = new Account();
        newAccount.Name = 'Unittest';
        database.insert(newAccount); 
        
        Account accountCreated = [select name  from Account where name = 'Unittest']; 
        System.assertEquals(accountCreated.name, 'Unittest');
        
        Opportunity opp = new Opportunity(Name ='opptest',closedate=date.today(),stagename='Open');
        database.insert(opp);
        
       	//Case related test data.
       	Contact c = new Contact(AccountId = newAccount.Id, LastName = 'TestBidQuoteLastName');
        database.insert(c);
        
        Case caseRec = new Case(Subject = 'Bid Quote for Case test', Opportunity__c = opp.Id, Partner_Contact__c = c.Id, Quote_Plan__c = 'All In', Quote_Type__c = 'All In', Template_Type__c = 'Budget');
        database.insert(caseRec);
    }
    /*
    * getLayoutStructure : test the method by passing null as id
    */   
    @IsTest static void getLayoutStructureTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            Map<String,List<NewQuoteCreation.layoutDetail>> mapLayoutBySection = new map<String,List<NewQuoteCreation.layoutDetail>>();
            test.starttest();
                mapLayoutBySection = NewQuoteCreation.getPageLayoutStructure(u1.Id,'test','','');
            test.stopTest();
            system.assertEquals(true, mapLayoutBySection.IsEmpty());
        }
  }
    /*
    * getLayoutStructureTestIncorrectIdTest : test the method by passing incorrect id
    */
    @IsTest static void getLayoutStructureTestIncorrectIdTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Field Service Admin','atestOwner2@test.demo');
        System.runAs(u1) {
            Map<String,List<NewQuoteCreation.layoutDetail>> mapLayouts = new map<String,List<NewQuoteCreation.layoutDetail>>();
            test.startTest();
            mapLayouts = NewQuoteCreation.getPageLayoutStructure(userinfo.getUserId(),'Budgetary_Estimate','SBQQ__Quote__c-Bid Quote Layout','SBQQ__Quote__c');
            test.stopTest();
            system.assertEquals(false, mapLayouts.IsEmpty());
        }
    }
    /*
    * getLayoutStructureSuccessTest : test the method by passing correct id
    */
    @IsTest static void getLayoutStructureSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
            System.runAs(u1) {
            Opportunity opp = [select name  from Opportunity where name = 'opptest']; 
            Map<String,List<NewQuoteCreation.layoutDetail>> mapLayouts = new map<String,List<NewQuoteCreation.layoutDetail>>();
            test.startTest();
            mapLayouts = NewQuoteCreation.getPageLayoutStructure(opp.id,'Pricing_Quote','SBQQ__Quote__c-Pricing Approval Layout','SBQQ__Quote__c');
            test.stoptest();
            system.assertEquals(false, mapLayouts.IsEmpty());
        }
    }    
        /*
    * getLayoutStructureSuccessTest : test the method by passing correct id
    */
    @IsTest static void getLayoutStructureBidQuoteSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
            System.runAs(u1) {
            Opportunity opp = [select name  from Opportunity where name = 'opptest']; 
            Map<String,List<NewQuoteCreation.layoutDetail>> mapLayouts = new map<String,List<NewQuoteCreation.layoutDetail>>();
            test.startTest();
            mapLayouts = NewQuoteCreation.getPageLayoutStructure(opp.id,'Budgetary_Estimate','SBQQ__Quote__c-Bid Quote Layout','SBQQ__Quote__c');
            test.stoptest();
            system.assertEquals(false, mapLayouts.IsEmpty());
        }
    }  
    /*
     * testBidQuoteForCaseSuccess : test the method by passing case id.
    */
    @isTest static void testBidQuoteForCaseSuccess(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            Case caseRec = [SELECT Id FROM Case WHERE Subject = 'Bid Quote for Case test' LIMIT 1];
            Map<String,List<NewQuoteCreation.layoutDetail>> mapLayouts = new map<String,List<NewQuoteCreation.layoutDetail>>();
            test.startTest();
            mapLayouts = NewQuoteCreation.getPageLayoutStructure(caseRec.id,'Budgetary_Estimate','SBQQ__Quote__c-Bid Quote Layout','SBQQ__Quote__c');
            test.stoptest();
            system.assertEquals(false, mapLayouts.IsEmpty());
       }
    }
    
}