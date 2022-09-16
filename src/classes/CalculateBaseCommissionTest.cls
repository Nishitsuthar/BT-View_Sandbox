@isTest
public class CalculateBaseCommissionTest {
    public static Id quoteId;
    static void createTestData() {

        Id stdPriceBookId = Test.getStandardPricebookId();
                 
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
        insert testContact;
        
        
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@test.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
        
        // ******* Begin JV - 20200107 - Create Sales Commission Rate Schedule for testing Sales Commission Code ******** 
 
        Sales_Commission_Rate_Schedule__c rateSchedule = new Sales_Commission_Rate_Schedule__c (Starting_Date__c = Date.newInstance(2020,1,1), Active__c = TRUE, Description__c = 'Test Sales Commission Rate Schedule');
        insert rateSchedule;
        
        Sales_Commission_Rate__c scr;
        List<Sales_Commission_Rate__c> scrList = new List<Sales_Commission_Rate__c>();
        List<Double> scrRates = new List<Double>{7.5, 6.0, 5.25, 4.5, 3.75};
        Double startingDiscountRate = 0.0;
        Integer scrSequence = 1;
        for(Decimal scrRate : scrRates) {
            scr = new Sales_Commission_Rate__c();
            scr.Sales_Commission_Rate_Schedule__c = rateSchedule.Id;
            scr.Sales_Commission_Rate__c = scrRate;
            scr.From_Discount__c = startingDiscountRate;
            startingDiscountRate = startingDiscountRate + 10.0;
            if (scrSequence < scrRates.size()) {
                scr.To_Discount__c = startingDiscountRate;
            }
            else {
                scr.To_Discount__c = 100.0;
            }
            scr.Active__c = TRUE;
            scr.Sequence__c = scrSequence;
            scrSequence++;   
            scrList.add(scr);       
        }  
        insert scrList;
        
        // ******* End JV - 20200107 - Create Sales Commission Rate Schedule for testing Sales Commission Code ******** 
       
        
/*        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
        insert testMOUOpportunityObj; */
         
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Opportunity testOpportunityObj = new Opportunity();
        testOpportunityObj.Name = 'testOppty';
        testOpportunityObj.CloseDate = Date.today();
        testOpportunityObj.StageName = 'POC Stage';
        testOpportunityObj.PriceBook2Id = stdPriceBookId;
        testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
        testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
        testOpportunityObj.Winning_Total_of_IGUs__c = 2;
        testOpportunityObj.AccountId = testAccount.Id;
        testOpportunityObj.IGU_Total_Amount__c = 10;
        testOpportunityObj.BOS_Total_Amount__c = 10;       
//        testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
        testOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
        testOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        testOpportunityObj.OwnerId = UserInfo.getUserId();
        insert testOpportunityObj; 
         
        
        
        SKU_Prefix_Element_Map__c eleMap;
        List<SKU_Prefix_Element_Map__c> lstEleMap = new List<SKU_Prefix_Element_Map__c>();
        List<String> eleMapName = new List<String>{'Generation', 'Laminate', 'Color', 'Shape', 'Panes'};
        
        for(Integer i = 0; i<5; i++) {
            eleMap = new SKU_Prefix_Element_Map__c();
            eleMap.Name = eleMapName[i];
            lstEleMap.add(eleMap);
        }
        insert lstEleMap;
        

        SKU_Prefix_Element_Map_Entry__c eleMapEntry;
        List<SKU_Prefix_Element_Map_Entry__c> lstEleMapEntry = new List<SKU_Prefix_Element_Map_Entry__c>();
        List<String> lstMapValue = new List<String>{
            '2', 'NO', 'CLR (CLEAR)', 'SHAPE','DOUBLE'
        };
        for(Integer i = 0; i<5; i++) {
            eleMapEntry = new SKU_Prefix_Element_Map_Entry__c();
            eleMapEntry.Name = lstMapValue[i];
            eleMapEntry.Map_to_Value__c = '0'+i;
            eleMapEntry.SKU_Prefix_Element_Map__c = lstEleMap[i].Id;
            lstEleMapEntry.add(eleMapEntry);
        }
        
        insert lstEleMapEntry;


        Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        testProductObj.BOS_Non_Operable__c = true;
        testProductObj.Family  = 'IGU';
        testProductObj.CSS_SqFt_Countable__c=true;
        testProductObj.Generation__c  = '2';
        testProductObj.Laminate__c = 'No';
        testProductObj.Panes__c = 'Double';
        testProductObj.Inboard_Lite__c = 'CLR (Clear)';
        testProductObj.Spacer__c = '1/2" 90% Argon';
        testProductObj.Inboard_Thickness__c = '6MM';
        testProductObj.Shape__c = 'Shape';
        testProductObj.Inboard_Treatment__c = 'T (Tempered)';
        testProductObj.Spacer_Type__c = 'TRISEAL FOAM';
        testProductObj.Spacer_Thickness__c = '1/2" (12.7 mm.)';
        testProductObj.Spacer_Fill__c = '90% Argon';
        testProductObj.Outboard_Lite__c = '6MM EC #2 CLR T';
        testProductObj.Edge_Black__c = 'NONE';
        testProductObj.Outboard_Treatment__c = 'T (Tempered)';
        testProductObj.Bird_Friendly__c = 'No';
        testProductObj.Pig_Tail__c = 'KEYED M8';
        testProductObj.IGU_Overall_Thickness__c = 1;
        testProductObj.Secondary_Seal_Color__c = 'Black';
        testProductObj.Secondary_Seal_Type__c = 'SI';
        insert testProductObj;
        
        PriceBookEntry pbEntry = new PriceBookEntry();
        pbEntry.IsActive = TRUE;
        pbEntry.UnitPrice = 40.00;
        pbEntry.PriceBook2Id = stdPriceBookId;
        pbEntry.Product2Id = testProductObj.Id;
        
        insert pbEntry;
               
        // ******* Begin JV - 20200107 - Create Pricing Quotes for testing Sales Commission Code ******** 
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();

        Id quoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Pricing Approval Record Type').getRecordTypeId();
        for(Integer i=0; i<1 ; i++) {
            SBQQ__Quote__c testQuote = new SBQQ__Quote__c();
            testQuote.RecordTypeId = quoteRecordtype;
            testQuote.SBQQ__Opportunity2__c = testOpportunityObj.Id;
            testQuote.Total_Sq_Feet__c = 10;
            testQuote.IGU_Price_Per_Sq_Ft__c = 30;
            testQuote.BOS_Price_Per_Sq_Ft__c = 50;
            testQuote.SBQQ__Account__c = testAccount.Id;
            testQuote.Bid_Status__c = 'Draft';
            testQuote.Exclude_Sync__c = false;
            testQuote.Quote_Plan__c = 'All In';
            testQuote.Quote_Type__c = 'All In';
            testQuote.Template_Type__c = 'Quote';
            testQuote.SBQQ__PrimaryContact__c = testContact.Id;
            testQuote.Are_you_using_Plenum__c='yes';
            testQuote.SBQQ__Primary__c = TRUE;
            quoteList.add(testQuote);
        }
        insert quoteList; 
         
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();        
        for(Integer i = 0; i<=3 ; i++) {
            SBQQ__QuoteLine__c testQuoteLineObj = new SBQQ__QuoteLine__c();
            testQuoteLineObj.SBQQ__Product__c = testProductObj.Id;
            testQuoteLineObj.SBQQ__StartDate__c = date.today();
            testQuoteLineObj.SBQQ__EndDate__c = date.today();
            testQuoteLineObj.SBQQ__Quote__c = quoteList[0].Id;
            testQuoteLineObj.No_of_IGU_s__c = 100;
            testQuoteLineObj.SBQQ__Quantity__c = 40000;
            testQuoteLineObj.Product_Family_CPQ__c = 'CSS, Software, BOS';
            testQuoteLineObj.BOS_Non_Operable__c = True;
            testQuoteLineObj.CSS_SqFt_Countable__c = True;
            quoteLineList.add(testQuoteLineObj);
        }
        insert quoteLineList; 
        
        // ********************************************************************************************        
        // ******* End JV - 20200107 - Create Pricing Quotes for testing Sales Commission Code ******** 
        // ********************************************************************************************        
        
    }
    
    static testMethod void testPricingQuote() {
        Test.startTest();
        createTestData();
        Id pricingApprovalRecordType = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Pricing Approval Record Type').getRecordTypeId();
        List<SBQQ__Quote__c> pricingApprovals = [SELECT Id, RecordTypeID, SBQQ__Opportunity2__c, SBQQ__Primary__c, SBQQ__AverageCustomerDiscount__c,Est_Total_Sales_Commission__c 
            FROM SBQQ__Quote__c WHERE RecordTypeId = :pricingApprovalRecordType];
        System.debug('Pricing Approvals: ' + String.valueOf(pricingApprovals)); 
        Opportunity qteOppty = [SELECT ID, Design_Win_Date__c, Total_Sales_Commission__c FROM Opportunity WHERE Id = :pricingApprovals[0].SBQQ__Opportunity2__c LIMIT 1];
        System.debug('Quote Oppty: ' + String.valueOf(qteOppty));
        qteOppty.Design_Win_Date__c = Date.today();
        update qteOppty;
        pricingApprovals[0].SBQQ__Primary__c = TRUE;
        update pricingApprovals[0];
        
        Test.stopTest();
    } 
 
}