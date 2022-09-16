/*************************/
	// Name 			: ProductClassification_Test
	// Description		: This Test Class is used to cover the code for Trigger(ProductClassification)
	// Autour			: UgaDurga Prasad
/*************************/
@isTest
public class ProductClassification_Test {
    static testMethod void ProductClassification_TestMethod() {
        // Create test Account
        Account acc = VTestDataUtility.getTestAccount();
        insert acc;
        
        // Create test Opportunity
        Opportunity opp = VTestDataUtility.getTestOpportunity(acc.Id);
        insert opp;
        
        // Create test Products
        Product2 prod = VTestDataUtility.getTestProduct();
        prod.Product_Business_Type__c = 'Smart Glass';
        insert prod;
        
        Product2 prod2 = VTestDataUtility.getTestProduct();
        prod2.Product_Business_Type__c = 'Smart Building Platform';
        prod2.Name = 'Test Product2';
        insert prod2;
        
        Product2 prod3 = VTestDataUtility.getTestProduct();
        prod3.Product_Business_Type__c = 'Compute';
        prod3.Name = 'Test Product3';
        insert prod3;
        
        // Create test Pricebook
        Pricebook2 pb = VTestDataUtility.getTestPriceBook();
        insert pb;
        
        // Create test PricebookEntries
        PricebookEntry pbe = VTestDataUtility.getTestPricebookEntry(Test.getStandardPricebookId(), prod.Id);
        insert pbe;
        
        PricebookEntry pbe2 = VTestDataUtility.getTestPricebookEntry(Test.getStandardPricebookId(), prod2.Id);
        insert pbe2;
        
        PricebookEntry pbe3 = VTestDataUtility.getTestPricebookEntry(Test.getStandardPricebookId(), prod3.Id);
        insert pbe3;
        
        // Create test OpportunityLineItems
        Test.startTest();
        OpportunityLineItem opli = VTestDataUtility.getTestOpportunityLineItem(opp.Id,pbe.Id);
        insert opli;
        RecursionControl.isRecursive = False;
        
        OpportunityLineItem opli2 = VTestDataUtility.getTestOpportunityLineItem(opp.Id,pbe2.Id);
        insert opli2;
        RecursionControl.isRecursive = False;
        
        OpportunityLineItem opli3 = VTestDataUtility.getTestOpportunityLineItem(opp.Id,pbe3.Id);
        insert opli3;
        RecursionControl.isRecursive = False;
        
        Delete opli;
        RecursionControl.isDeleteRecursive = False;
        
        update opli2;
        RecursionControl.isRecursive = False;
        Test.stopTest();
    }
}