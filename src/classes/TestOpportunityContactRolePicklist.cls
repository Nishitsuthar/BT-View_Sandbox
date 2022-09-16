@isTest
public class TestOpportunityContactRolePicklist {

     @testsetup
    static void OpportunityContactRolePicklist(){
        Account testAcc = new Account(Name = 'Issue1 Account');
        insert testAcc;
        
        Contact testCon = new Contact(LastName='test issue contact',
                                      AccountId=testAcc.Id,
                                      Email='testissuecon1@gmail.com',
                                      Phone='040-12345',
                                      MailingStreet='854 Oakland Ave.',
                                      MailingCity='Los Angeles',
                                      MailingState='CA',
                                      MailingPostalCode='90004',
                                      MailingCountry='US'
                                     );
        insert testCon;
        
        Pricebook2 standardPricebook = new Pricebook2(
    			Id = Test.getStandardPricebookId(),
    			IsActive = true
		);
		Update standardPricebook;        
        Opportunity testOpp = new Opportunity(Name='Issue Opp',
                                              AccountId=testAcc.Id,
                                              ContactId =testCon.Id,
                                              Support_Region__c='Dallas',
                                              StageName = 'Value Prop.',
                                              PriceBook2Id=standardPricebook.Id,
                                              CloseDate= System.today(),
                                              LeadSource='Database'
                                             );
        insert testOpp;
}
    @isTest
    public static void testgetOpportunityContactRoles(){
        Account acc=[select Id,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id]; 
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        opportunityContactRolePicklist oppconrolepicklist = new opportunityContactRolePicklist ();
        opportunityContactRolePicklist.getOpportunityContactRoles(opp.Id);
    }
}