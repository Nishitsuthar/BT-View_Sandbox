@isTest
public class UpdateliteIDonAssetTest {
    @isTest
    static void StringformatchangerTest () {
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
        Product2 testPro = new Product2(Name = 'ASSY',
                                        IsActive = true, 
                                        Family='CSS',
                                        CurrencyIsoCode='USD',
                                        Product_SKU__c='test',
                                        ProductCode='testc'
                                        
                                       );
        insert testPro; 
        

    Asset testAsset = new Asset(Name='test Asset',
                                     AccountId=testAcc.Id,
                                     ContactId=testCon.Id,
                                     SerialNumber='10203`58`71`17`0',
                                     Product2Id = testPro.Id,
                                     Opportunity__c=testOpp.Id);
        insert testAsset;
        }
    
}