@isTest
public class QuoteTriggerHandlerTest {
    public static Id quoteId;
    static void createTestData() {
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
        insert testContact;
        
        /*
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        system.debug('TEST:' + dealDeskProfileId);
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@test.com', 
                                     EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                                     TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
        
        insert dealDeskUser;

        */
        
        	User dealDeskUser =[select id,name,profile.Name from user where Profile.Name = 'Deal Desk' AND Isactive = True LIMIT 1]; 
        
            Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
            Opportunity testMOUOpportunityObj = new Opportunity();
            testMOUOpportunityObj.Name = 'testOppty';
            testMOUOpportunityObj.CloseDate = Date.today();
            testMOUOpportunityObj.StageName = 'POC Stage';
            testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
            testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
            testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        	testMOUOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
            testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
            insert testMOUOpportunityObj;
            
            Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
            Opportunity testOpportunityObj = new Opportunity();
            testOpportunityObj.Name = 'testOppty';
            testOpportunityObj.CloseDate = Date.today();
            testOpportunityObj.StageName = 'POC Stage';
            testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
            testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
            testOpportunityObj.Winning_Total_of_IGUs__c = 2;
            testOpportunityObj.AccountId = testAccount.Id;
            testOpportunityObj.IGU_Total_Amount__c = 10;
            testOpportunityObj.BOS_Total_Amount__c = 10;
            testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
            testOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
            testOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        	testOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
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
            testProductObj.Family  = 'CSS';
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
            
            Id quoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Bid Quote Record Type').getRecordTypeId();
            List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
            for(Integer i=0; i<2 ; i++) {
                SBQQ__Quote__c testQuote = new SBQQ__Quote__c();
                testQuote.RecordTypeId = quoteRecordtype;
                testQuote.Related_Opportunity__c = testOpportunityObj.Id;
                testQuote.Total_Sq_Feet__c = 10;
                testQuote.IGU_Price_Per_Sq_Ft__c = 30;
                testQuote.BOS_Price_Per_Sq_Ft__c = 50;
                testQuote.SBQQ__Account__c = testAccount.Id;
                testQuote.Bid_Status__c = 'Won Bid';
                testQuote.Exclude_Sync__c = false;
                testQuote.Quote_Plan__c = 'All In';
                testQuote.Quote_Type__c = 'All In';
                testQuote.Template_Type__c = 'Quote';
                testQuote.SBQQ__PrimaryContact__c = testContact.Id;
                testQuote.Are_you_using_Plenum__c='yes';
                quoteList.add(testQuote);
                quoteId = quoteList[0].Id;
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
            List<SBQQ__Quote__c> quoteList1=[select id,Total_IGU_s_QL__c,BOS_Total_Sq_Ft__c from SBQQ__Quote__c where id=:quoteList[0].Id ];
            system.debug('quoteList1 123>>'+quoteList1);
            
    }
    
    
    @isTest
    static void createTestData1() {
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account0';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.LastName = 'First';
        testContact.LastName = 'Last Test';
        testContact.AccountId = testAccount.Id;
        testContact.Email = 'first@last.com';
        insert testContact;
        
        /*
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@test.com', 
                                     EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                                     TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
        
        insert dealDeskUser;
        */
		User dealDeskUser =[select id,name,profile.Name from user where Profile.Name = 'Deal Desk' AND Isactive = True LIMIT 1];      
        
            Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
            Opportunity testMOUOpportunityObj = new Opportunity();
            testMOUOpportunityObj.Name = 'testOppty';
            testMOUOpportunityObj.CloseDate = Date.today();
            testMOUOpportunityObj.StageName = 'POC Stage';
            testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
            testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
            testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
        	testMOUOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
            testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
            insert testMOUOpportunityObj;
            
            Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
            Opportunity testOpportunityObj = new Opportunity();
            testOpportunityObj.Name = 'testOppty';
            testOpportunityObj.CloseDate = Date.today();
            testOpportunityObj.StageName = 'POC Stage';
            testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
            testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
            testOpportunityObj.Winning_Total_of_IGUs__c = 2;
            testOpportunityObj.AccountId = testAccount.Id;
            testOpportunityObj.IGU_Total_Amount__c = 10;
            testOpportunityObj.BOS_Total_Amount__c = 10;
            testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
            testOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
            testOpportunityObj.Design_Win_Date__c = Date.today();
			testOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
            testOpportunityObj.Lock_Total_Sales_Commission__c = FALSE ;
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
            testProductObj.Family  = 'CSS';
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
            
            
            Sales_Commission_Rate_Schedule__c testSalesRS = new Sales_Commission_Rate_Schedule__c();
            testSalesRS.Starting_Date__c = date.today();
            testSalesRS.Ending_Date__c = date.today()+1;
            testSalesRS.Description__c  = 'testSalesRS';
            testSalesRS.Active__c = TRUE;
            insert testSalesRS;
            system.debug( testSalesRS);
            
            Sales_Commission_Rate__c testSalesR = new Sales_Commission_Rate__c();
            testSalesR.Sequence__c = 1 ;
            testSalesR.From_Discount__c = 0;
            testSalesR.To_Discount__c = 1 ;
            testSalesR.Sales_Commission_Rate__c =3.00;
            testSalesR.Sales_Commission_Rate_Schedule__c = testSalesRS.Id;
            testSalesR.Active__c = TRUE;
            insert testSalesR;
            
            
            Id quoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Pricing Approval Record Type').getRecordTypeId();
            List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
            for(Integer i=0; i<1 ; i++) {
                SBQQ__Quote__c testQuote = new SBQQ__Quote__c();
                testQuote.RecordTypeId = quoteRecordtype;
                testQuote.Related_Opportunity__c = testOpportunityObj.Id;
                testQuote.Total_Sq_Feet__c = 10;
                testQuote.IGU_Price_Per_Sq_Ft__c = 30;
                testQuote.BOS_Price_Per_Sq_Ft__c = 50;
                testQuote.SBQQ__Account__c = testAccount.Id;
                testQuote.Bid_Status__c = 'Won Bid';
                testQuote.Exclude_Sync__c = false;
                testQuote.Quote_Plan__c = 'All In';
                testQuote.Quote_Type__c = 'All In';
                testQuote.Template_Type__c = 'Quote';
                testQuote.Are_you_using_Plenum__c = 'Yes';
                
                
                testQuote.SBQQ__PrimaryContact__c = testContact.Id;
                testQuote.SBQQ__Opportunity2__c = testOpportunityObj.Id;
                // testQuote.SBQQ__primary__c = False;
                testQuote.Are_you_using_Plenum__c='yes';
                quoteList.add(testQuote);
                quoteId = quoteList[0].Id;
            }
            insert quoteList; 
            
            List<SBQQ__Quote__c> quoteListUpdate = [Select Id,IGU_Price_Per_Sq_Ft__c,BOS_Price_Per_Sq_Ft__c  from SBQQ__Quote__c ];
            
            List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
            for(Integer i = 0; i<=1 ; i++) {
                SBQQ__QuoteLine__c testQuoteLineObj = new SBQQ__QuoteLine__c();
                testQuoteLineObj.SBQQ__Product__c = testProductObj.Id;
                testQuoteLineObj.SBQQ__StartDate__c = date.today();
                testQuoteLineObj.SBQQ__EndDate__c = date.today();
                testQuoteLineObj.SBQQ__Quote__c = quoteListUpdate[0].id;
                testQuoteLineObj.SBQQ__Quantity__c = 40000;
                testQuoteLineObj.Product_Family_CPQ__c = 'CSS, Software, BOS';
                testQuoteLineObj.BOS_Non_Operable__c = True;
                testQuoteLineObj.CSS_SqFt_Countable__c = True;
                testQuoteLineObj.No_of_IGU_s__c = 2;
                testQuoteLineObj.SBQQ__Optional__c  = False;
                testQuoteLineObj.SBQQ__Renewal__c = False;
                testQuoteLineObj.SBQQ__Existing__c = False;
                testQuoteLineObj.SBQQ__CarryoverLine__c= False;
                testQuoteLineObj.SBQQ__PriorQuantity__c = 0;
                testQuoteLineObj.SBQQ__Bundled__c= False;
                
                quoteLineList.add(testQuoteLineObj);
            }
            insert quoteLineList;
            
            for(SBQQ__Quote__c QtU : quoteListUpdate) {
                QtU.IGU_Price_Per_Sq_Ft__c = 60;
                QtU.BOS_Price_Per_Sq_Ft__c = 70;
                QtU.Are_you_using_Plenum__c = 'No';
                //    QtU.SBQQ__primary__c = True;
            }
            
            update quoteListUpdate; 
            for(SBQQ__Quote__c QtU1 : quoteListUpdate) {
                QtU1.IGU_Price_Per_Sq_Ft__c = 60;
                QtU1.BOS_Price_Per_Sq_Ft__c = 70;
                QtU1.Are_you_using_Plenum__c = 'No';
                QtU1.SBQQ__Opportunity2__c = null;
                //    QtU.SBQQ__primary__c = True;
            }
            
            update quoteListUpdate;
            List<SBQQ__Quote__c> quoteList1=[select id,Total_IGU_s_QL__c,BOS_Total_Sq_Ft__c from SBQQ__Quote__c where id=:quoteList[0].Id ];
            system.debug('quoteList1 123>>'+quoteList1);
        
    }
    
    
    
    static testMethod void testWinningInfoOnOppty () {
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Test.startTest();
        createTestData();
        
        Test.stopTest();
        List<Opportunity> OpportunityList = [Select Winning_Projects_Total_Sq_Ft__c,Winning_Total_of_IGUs__c,IGU_Total_Amount__c,BOS_Total_Amount__c from Opportunity where RecordTypeId =: opptyRecordtype];
        System.debug('1****'+OpportunityList[0].Winning_Projects_Total_Sq_Ft__c);
        System.debug('2****'+OpportunityList[0].Winning_Total_of_IGUs__c);
        // system.assertEquals(1600, OpportunityList[0].Winning_Projects_Total_Sq_Ft__c);
        //system.assertEquals(11000, OpportunityList[0].Winning_Total_of_IGUs__c);
    }
    
    /* static testMethod void testIguBosTotalOnOppty () {
Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
Test.startTest();
createTestData();
Test.stopTest(); 
List<Opportunity> OpportunityList = [Select IGU_Total_Amount__c,BOS_Total_Amount__c from Opportunity where RecordTypeId =: opptyRecordtype];
System.debug('3****'+OpportunityList[0].IGU_Total_Amount__c);
System.debug('4****'+OpportunityList[0].BOS_Total_Amount__c);
//system.assertEquals(30000, OpportunityList[0].IGU_Total_Amount__c);
//system.assertEquals(50000, OpportunityList[0].BOS_Total_Amount__c);
}   

public static testmethod void testQuote1(){        
account acc = new account();
acc.name = 'View Inc';
acc.BillingCountry = 'United States';
insert acc;

contact con = new contact();
con.LastName = 'Test Contact';
con.AccountId = acc.id;
con.Email = 'test_view@testview.com';
insert con;

Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@test.com', 
EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');

insert dealDeskUser;

Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
Opportunity testMOUOpportunityObj = new Opportunity();
testMOUOpportunityObj.Name = 'testOppty';
testMOUOpportunityObj.CloseDate = Date.today();
testMOUOpportunityObj.StageName = 'POC Stage';
testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
testMOUOpportunityObj.OwnerId = UserInfo.getUserId();           
insert testMOUOpportunityObj;

Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
Opportunity testOpportunityObj = new Opportunity();
testOpportunityObj.Name = 'testOppty';
testOpportunityObj.CloseDate = Date.today();
testOpportunityObj.StageName = 'POC Stage';
testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
testOpportunityObj.Winning_Total_of_IGUs__c = 2;
testOpportunityObj.AccountId = acc.Id;
testOpportunityObj.IGU_Total_Amount__c = 10;
testOpportunityObj.BOS_Total_Amount__c = 10;
testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
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
testProductObj.Family  = 'BOS';
testProductObj.BOS_Non_Operable__c = True;
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

RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];        
//list<SBQQ__Quote__c> sqll = new list<SBQQ__Quote__c>();
SBQQ__Quote__c quote=new SBQQ__Quote__c();
quote.Quote_Approval_Type__c = 'Pricing Approval'; 
quote.First_Ship_Date__c = system.today();
quote.Detailed_Summary_of_Deal__c = 'test';
quote.RecordTypeId=qrt.id;
quote.Are_you_using_Plenum__c='No';
quote.Quote_Plan__c='All In';
// quote.SBQQ__SalesRep__c='0050L0000096RtS';
quote.SBQQ__Account__c = acc.id;
quote.SBQQ__PrimaryContact__c = con.Id;
quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';    
quote.Related_Opportunity__c = testOpportunityObj.Id;
insert quote;
system.debug('^^^^^^^^^^'+quote.id);

system.debug('%%%%quote%%%%'+quote+quote.Total_IGU_s_QL__c+'999999999'+quote.BOS_Total_Sq_Ft__c);
SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
qtline.Product_Family_CPQ__c = 'BOS';
qtline.BOS_Non_Operable__c = True;
qtLine.SBQQ__Quote__c=quote.Id;
qtLine.SBQQ__Product__c = testProductObj.Id;
qtLine.No_of_IGU_s__c = 3000;
qtLine.SBQQ__Quantity__c = 20000;

insert qtLine;
}

static testMethod void testBudgetaryQuoteClone () {
Test.startTest();

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


Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Multi Project Opportunity').getRecordTypeId();
Opportunity testMOUOpportunityObj = new Opportunity();
testMOUOpportunityObj.Name = 'testOppty';
testMOUOpportunityObj.CloseDate = Date.today();
testMOUOpportunityObj.StageName = 'POC Stage';
testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
testMOUOpportunityObj.Sales_Ops_Owner__c = dealDeskUser.Id;
testMOUOpportunityObj.Sales_Director__c = UserInfo.getUserId();
testMOUOpportunityObj.OwnerId = UserInfo.getUserId();       
insert testMOUOpportunityObj;

Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
Opportunity testOpportunityObj = new Opportunity();
testOpportunityObj.Name = 'testOppty';
testOpportunityObj.CloseDate = Date.today();
testOpportunityObj.StageName = 'POC Stage';
testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
testOpportunityObj.Winning_Total_of_IGUs__c = 2;
testOpportunityObj.IGU_Total_Amount__c = 10;
testOpportunityObj.BOS_Total_Amount__c = 10;
testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;

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
testProductObj.Family  = 'BOS';
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

Id quoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Pricing Approval Record Type').getRecordTypeId();
SBQQ__Quote__c testQuote = new SBQQ__Quote__c();
testQuote.RecordTypeId = quoteRecordtype;
testQuote.Related_Opportunity__c = testOpportunityObj.Id;
testQuote.Total_Sq_Feet__c = 10;
testQuote.IGU_Price_Per_Sq_Ft__c = 30;
testQuote.BOS_Price_Per_Sq_Ft__c = 50;
testQuote.SBQQ__Account__c = testAccount.Id;
testQuote.Bid_Status__c = 'Won Bid';
testQuote.Exclude_Sync__c = false;
testQuote.Quote_Plan__c = 'All In';
testQuote.Quote_Type__c = 'All In';
testQuote.Template_Type__c = 'Quote';
testQuote.SBQQ__Opportunity2__c  = testMOUOpportunityObj.Id;
testQuote.SBQQ__PrimaryContact__c = testContact.Id;     
testQuote.Are_you_using_Plenum__c='yes';
testQuote.SBQQ__Primary__c=true;
insert testQuote; 
Test.stopTest();

SBQQ__QuoteLine__c testQuoteLineObj = new SBQQ__QuoteLine__c();
testQuoteLineObj.SBQQ__Product__c = testProductObj.Id;
testQuoteLineObj.SBQQ__StartDate__c = date.today();
testQuoteLineObj.SBQQ__EndDate__c = date.today();
testQuoteLineObj.SBQQ__Quote__c = testQuote.Id;
testQuoteLineObj.No_of_IGU_s__c = 100;
testQuoteLineObj.SBQQ__Quantity__c = 40000;
testQuoteLineObj.Product_Family_CPQ__c = 'BOS';
testQuoteLineObj.BOS_Non_Operable__c = True;

insert testQuoteLineObj;


Opportunity OpportunityRec = [Select Id,IGU_Total_Amount__c,BOS_Total_Amount__c from Opportunity where RecordTypeId =: opptyRecordtype];
OpportunityRec.MOU_Initiated__c = true;
update OpportunityRec;        

}  */
    
}