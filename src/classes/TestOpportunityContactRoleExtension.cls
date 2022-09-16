@isTest 
public class TestOpportunityContactRoleExtension{ 

static testMethod void TestClass(){ 

Opportunity c = new Opportunity(); 

ApexPages.StandardController sc = new ApexPages.standardController(c); 

OpportunityContactRoleExtension obj = new OpportunityContactRoleExtension(sc); 
} 
}