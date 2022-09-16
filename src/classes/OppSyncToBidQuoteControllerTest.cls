@isTest
private class OppSyncToBidQuoteControllerTest
{

    static testMethod void syncCalculations()
    {
        Account acc= new Account();
        acc.Name = 'TestAccount';
        Insert acc;

        Contact contact = new Contact();
        contact.accountId= acc.Id;
        contact.Email = 'test@abc.com';
        contact.LastName = 'TestContact';
        Insert contact;

        //Product2 objProduct2 = new Product2();
        //objProduct2.Name = 'testProduct';
        //objProduct2.family= 'none';
        //objProduct2.IsActive = true;
        //objProduct2.Panes__c = 'Triple';
        //objProduct2.Coating_Surface__c = 'None';
        //objProduct2.CurrencyIsoCode = 'USD';
        //insert objProduct2;
        
        Product2 objProduct2 = new Product2();
        objProduct2.Name = 'Test Product';
        //******COMMENTING THIS AS PART OF BOS REFERENCE CHANGES
        //objProduct2.Family  = 'BOS';
        objProduct2.Family  = 'CSS';
        objProduct2.Generation__c  = '2';
        objProduct2.Laminate__c = 'No';
        objProduct2.Panes__c = 'Double';
        objProduct2.Inboard_Lite__c = 'CLR (Clear)';
        objProduct2.Spacer__c = '1/2" 90% Argon';
        objProduct2.Inboard_Thickness__c = '6MM';
        objProduct2.Shape__c = 'Shape';
        objProduct2.Inboard_Treatment__c = 'T (Tempered)';
        objProduct2.Spacer_Type__c = 'TRISEAL FOAM';
        objProduct2.Spacer_Thickness__c = '1/2" (12.7 mm.)';
        objProduct2.Spacer_Fill__c = '90% Argon';
        objProduct2.Outboard_Lite__c = '6MM EC #2 CLR T';
        objProduct2.Edge_Black__c = 'NONE';
        objProduct2.Outboard_Treatment__c = 'T (Tempered)';
        objProduct2.Bird_Friendly__c = 'No';
        objProduct2.Pig_Tail__c = 'KEYED M8';
        objProduct2.IGU_Overall_Thickness__c = 1;
        insert objProduct2;
        

        PricebookEntry pb = new PricebookEntry();
        pb.IsActive = true;
        pb.Pricebook2Id = Test.getStandardPricebookId();
        pb.Product2Id = objProduct2.Id;
        pb.UnitPrice = 10;
        Insert pb; 

        Opportunity op = new Opportunity();
        op.Name = 'TestOpp';
        op.StageName = 'Qualification';
        op.CloseDate = Date.today();
        op.AccountId = acc.Id;
        op.Pricebook2Id  = Test.getStandardPricebookId();
        op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Insert op;

        OpportunityLineItem opItem = new OpportunityLineItem();
        opItem.Product2Id = objProduct2.Id;
        opItem.OpportunityId = op.Id;
        opItem.Quantity = 4; 
        opItem.Discount = 0;
        opItem.TotalPrice = 40;

        OpportunityLineItem opItem2 = new OpportunityLineItem();
        opItem2.Product2Id = objProduct2.Id;
        opItem2.OpportunityId = op.Id;
        opItem2.Quantity = 4; 
        opItem2.Discount = 0;
        opItem2.TotalPrice = 40;
        database.insert(new List<OpportunityLineItem>{opItem,opItem2});

        
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        //Id QuoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Bid Quote Record Type').getRecordTypeId();
        //quote.RecordTypeId = QuoteRecordtype;
        quote.SBQQ__Account__c = acc.Id;
        quote.SBQQ__PrimaryContact__c = contact.Id;
        quote.Related_Opportunity__c = op.Id;
        quote.SBQQ__Opportunity2__c = op.Id;
        quote.Quote_Plan__c = 'All In';
        quote.Quote_Type__c = 'All In';
        quote.Template_Type__c = 'Quote';


        SBQQ__Quote__c quote3 = new SBQQ__Quote__c();
        //Id QuoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Bid Quote Record Type').getRecordTypeId();
        //quote.RecordTypeId = QuoteRecordtype;
        quote3.SBQQ__Account__c = acc.Id;
        quote3.SBQQ__PrimaryContact__c = contact.Id;
        quote3.Related_Opportunity__c = op.Id;
        quote3.SBQQ__Opportunity2__c = op.Id;
        quote3.Quote_Plan__c = 'All In';
        quote3.Quote_Type__c = 'All In';
        quote3.Template_Type__c = 'Quote';



        SBQQ__Quote__c quote2 = new SBQQ__Quote__c();
        Id QuoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Bid Quote Record Type').getRecordTypeId();
        quote2.SBQQ__Account__c = acc.Id;
        quote2.RecordTypeId = QuoteRecordtype;
        quote2.SBQQ__PrimaryContact__c = contact.Id;
        quote2.Related_Opportunity__c = op.Id;
        quote2.SBQQ__Opportunity2__c = op.Id;
        quote2.Quote_Plan__c = 'All In';
        quote2.Quote_Type__c = 'All In';
        quote2.Template_Type__c = 'Quote';

        test.starttest();
        database.insert(new List<SBQQ__Quote__c>{quote,quote3,quote2});
        test.stopTest();

    }
}