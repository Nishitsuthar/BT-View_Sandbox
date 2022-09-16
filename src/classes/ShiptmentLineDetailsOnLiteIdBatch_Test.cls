@istest
public class ShiptmentLineDetailsOnLiteIdBatch_Test {
    
    
    @testSetup static void testDataSetUpOne()
    {
    
        Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'System Administrator' LIMIT 1 ].Id;
        user DDUser = [Select id from user where Name = 'Cecily Castaneda' LIMIT 1];
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                                     EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                                     TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
        
        insert dealDeskUser;
        
        System.runAs ( dealDeskUser ) {
            
            
            Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
            Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
            
            
            Account acc = new Account();
            acc.Name='test';
            acc.BillingCity='Livermore';
            acc.BillingCountry='USA';
            acc.BillingPostalCode='94550';
            acc.BillingState='CA';
            acc.BillingStreet='6400 Brisa Street';
            acc.Oracle_Customer_Number__c ='123';
            acc.ShippingCity='Livermore';
            acc.ShippingCountry='USA';
            acc.ShippingPostalCode='94550';
            acc.ShippingState='CA';
            acc.ShippingStreet='6400 Brisa Street';
            insert acc;
            
            contact c = new contact();
            c.AccountId = acc.id;
            c.LastName='Test';
            c.Salutation='Mr.';
            c.Email='test@test.com';
            insert c;
            
            Opportunity testMOUOpportunityObj = new Opportunity();
            testMOUOpportunityObj.Name = 'testOpptyParent';
            testMOUOpportunityObj.CloseDate = Date.today();
            testMOUOpportunityObj.StageName = 'POC Stage';
            testMOUOpportunityObj.RecordTypeId = opptyRecordtype; 
            testMOUOpportunityObj.AccountId= acc.id;
            testMOUOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
            testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
            testMOUOpportunityObj.Sales_Ops_Owner__c =DDUser.Id;
            insert testMOUOpportunityObj;
            Product2 testProductObj = new Product2();
            testProductObj.Name = 'Test Product';
            
            
            testProductObj.Family  = 'CSS';
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
            
            SBQQ__Quote__c quote=new SBQQ__Quote__c();
            quote.Quote_Approval_Type__c = 'Pricing Approval'; 
            quote.First_Ship_Date__c = system.today();
            quote.Detailed_Summary_of_Deal__c = 'test';
            quote.RecordTypeId= '0120h000000YOJuAAO';
            quote.Are_you_using_Plenum__c='No';
            //quote.Quote_Plan__c='All In';
            quote.SBQQ__Account__c = acc.id;
            quote.SBQQ__PrimaryContact__c = c.Id;
            quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
            quote.Related_Opportunity__c = testMOUOpportunityObj.Id;
            insert quote;
           
            SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
            qtline.Product_Family_CPQ__c = 'CSS';
            qtline.BOS_Non_Operable__c = True;
            qtLine.SBQQ__Quote__c=quote.Id;
            qtLine.SBQQ__Product__c = testProductObj.Id;
            qtLine.No_of_IGU_s__c = 3000;
            qtLine.SBQQ__Quantity__c = 20000;
            qtLine.SBQQ__CustomerPrice__c=5.03;
            insert qtLine;
            
            recordtype OERrecid = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Release__c' and DeveloperName =: Label.CSS_Hardware limit 1];
            recordtype OELrecid1 = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Line__c' and DeveloperName =: Label.CSS_Hardware limit 1];
            
            Order_Entry_Release__c od = new Order_Entry_Release__c( Name = '9992323-00',Status__c = 'Draft', Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id ,
                                                                   Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.', 
                                                                   Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6',recordtypeid = OERrecid.id,
                                                                   Shipping_State_Province__c = 'BC', CPQ_Quote__c = quote.id, Shipping_Country__c = 'CANADA',Opportunity__c=testMOUOpportunityObj.id,Release_Name__c='test12311',
                                                                   Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255,
                                                                   Request_Date__c = System.today() + 90);
            
            insert od; 
           
            /*
            Test.startTest();
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
            
            test.stopTest();
            
            List<Product2> productsample = NEW List<Product2>();
            SBQQ__Quote__c sb = new SBQQ__Quote__c();
            sb.SBQQ__Status__c = 'Active';
            sb.Quote_Name__c='ss';
            sb.Quote_Approval_Type__c='Pricing Approval';
            sb.Are_you_using_Plenum__c='Yes';
            sb.Shipping_Included__c ='No';
            sb.Detailed_Summary_of_Deal__c='test';
            sb.SBQQ__Account__c=acc.id;
            sb.SBQQ__PrimaryContact__c=c.id;
            //  insert sb;
            //  
           */
            Order_Entry_Line__c odl = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 55, Base_In__c = ' ', Height_In__c = ' ',
                                                              Base_Height_1_In__c = ' ', Shape__c = ' ', recordtypeid = OELrecid1.id, Status__c = 'Draft', 
                                                              Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                                                              Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                                                              String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                                                              Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                                                              Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                                                              Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1,
                                                              Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255,
                                                              Request_Date__c = System.today() + 90);
            insert odl; 
            
            Order_Entry_Line__c od2 = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 55, Base_In__c = ' ', Height_In__c = ' ',
                                                              Base_Height_1_In__c = ' ', Shape__c = ' ', recordtypeid = OELrecid1.id, Status__c = 'Draft', 
                                                              Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                                                              Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                                                              String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                                                              Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                                                              Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                                                              Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1,
                                                              Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 20,
                                                              Request_Date__c = System.today() + 90);
            insert od2; 
            
            Order_Entry_Line__c od3 = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 60, Base_In__c = ' ', Height_In__c = ' ',
                                                              Base_Height_1_In__c = ' ', Shape__c = ' ', recordtypeid = OELrecid1.id, Status__c = 'Draft', 
                                                              Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                                                              Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                                                              String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                                                              Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                                                              Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                                                              Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1,
                                                              Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 20,
                                                              Request_Date__c = System.today() + 90);
            insert od3;  
            
           
            odl = [Select id,Name,Quantity__c,Scheduled_Ship_Date__c,Request_Date__c,Promised_Date__c FROM Order_Entry_Line__c WHERE Id=: odl.Id];
            od2 = [Select id,Name,Quantity__c,Scheduled_Ship_Date__c,Request_Date__c,Promised_Date__c FROM Order_Entry_Line__c WHERE Id=: od2.Id];
     
            
            Map<String, Shipment_Line__c> oelRefFromShiLine = new Map<String, Shipment_Line__c>();
            Set<Id> shipmentDelNo = new Set<Id>();
            set<string> oelidfur = new set<string>();
            List<Order_Entry_Line_Shipment__c> updateOldOelf = new List<Order_Entry_Line_Shipment__c>();
            Map<String,Shipment_Line__c> shipDateAndTrackingNum = new Map<String,Shipment_Line__c>();
           
            // Shipment and Shipment Line Insert
            Shipment__c shIn = new Shipment__c();
            shIn.Delivery_Number__c = '1223344';
            shIn.Product_Family__c = 'IGU';
            shIn.CurrencyIsoCode = 'USD';
            shIn.OwnerId = UserInfo.getUserId();
            //shIn.Name = 'Sh-112233';
            insert shIn;
            
            List<Shipment_Line__c> shLineMul = new List<Shipment_Line__c>();
            for(Integer i = 0; i < 6; i++)
            {
                Shipment_Line__c shLine = new Shipment_Line__c();
                shLine.Shipment__c = shIn.Id;
                shLine.Ordered_Quantity__c = 5;
                shLine.Shipped_Quantity__c = 5;
                shLine.Shipment_Line_External_Reference__c = '1234566'+i;
                shLine.Order_Entry_Line__c = odl.Name;
                shLine.Tracking_Number__c = 'test123';
                shLineMul.add(shLine);
            }
            insert shLineMul;
            
            test.startTest();  
       List<Shipment_Line__c> getShipLines = [Select id,Shipment_Line_External_Reference__c,Shipment__r.Ship_Date__c,
                                                                         Shipment__r.Delivery_Number__c,Order_Entry_Line__c from Shipment_Line__c];
            //for()
       
        Product2 pd=VTestDataUtility_OE.getTestProduct();
        pd.name='productWithProductItem';
        Product2 pd1=VTestDataUtility_OE.getTestProduct();
        database.insert(new List<Product2>{pd,pd1});
        
         Schema.Location lc = new Schema.Location(name='test',IsInventoryLocation=true);
        database.insert(lc);
        
            
        productitem pi = new productitem(Product2Id = pd.Id,QuantityOnHand=5,locationid =lc.id);
        insert pi; 
        Test.stopTest();
            
        Asset assetRec = new Asset(Name = '21137`791`71`17`0', AccountId = acc.Id, SerialNumber = '21137`791`71`17`0', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
            
        List<Lite_Id__c> newLiteId = new List<Lite_Id__c>();
            
            newLiteId.add(new Lite_id__c(Lite_Id__c='21137`791`71`17`0',Shipment_Line_Reference__c='12345661',Asset_Created__c='Initial'));
            newLiteId.add(new Lite_id__c(Lite_Id__c='21138`791`71`17`0',Shipment_Line_Reference__c='12345662',Asset_Created__c='Initial'));
            newLiteId.add(new Lite_id__c(Lite_Id__c='21139`791`71`17`0',Shipment_Line_Reference__c='',Asset_Created__c='Initial'));
            newLiteId.add(new Lite_id__c(Lite_Id__c='21137`791`71`17`0',Shipment_Line_Reference__c='12345666',Asset_Created__c='Initial'));
            insert newLiteId;
          
        List<Lite_Id__c> newLiteIdTwo = new List<Lite_Id__c>();
            
            newLiteIdTwo.add(new Lite_id__c(Lite_Id__c='21137`791`71`17`0',Shipment_Line_Reference__c='12345661',Asset_Created__c='No'));
            newLiteIdTwo.add(new Lite_id__c(Lite_Id__c='21138`791`71`17`0',Shipment_Line_Reference__c='12345662',Asset_Created__c='No'));
            newLiteIdTwo.add(new Lite_id__c(Lite_Id__c='21139`791`71`17`0',Shipment_Line_Reference__c='',Asset_Created__c='No'));
            newLiteIdTwo.add(new Lite_id__c(Lite_Id__c='21137`791`71`17`0',Shipment_Line_Reference__c='12345666',Asset_Created__c='No'));
            insert newLiteIdTwo;
		
        }
    }
    
    static testmethod void methodOne()
    {
		test.startTest();
        	ShiptmentLineDetailsOnLiteIdBatch AssetCreation = new ShiptmentLineDetailsOnLiteIdBatch();
				Database.executeBatch(AssetCreation);
        test.stopTest();
    }
    
    static testmethod void methodTwo()
    {
		test.startTest();
        	CreateAssetFromLite AssetCreationTwo = new CreateAssetFromLite();
				Database.executeBatch(AssetCreationTwo);
        test.stopTest();
    }
/*
    @testSetup static void testDataSetUp() 
    {
        Account account_Obj = new Account(Name = 'Name419', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', ShippingStreet = 'Sierra brooks', ShippingCity = 'Sanjose', ShippingState = 'CA', ShippingPostalCode = '95132', ShippingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
        Insert account_Obj;
        Id AccId = [select Id from Account limit 1].id; 
        // Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
        Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;
        //Id ProductId = [Select Id from Product2 limit 1].id;
        //Id quote_Obj = [Select Id from Quote Where Id = Opportunity.Id limit 1].id;
        
        
        Opportunity opportunity_Obj = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Test Prequal22',AccountId = account_Obj.id,
                                                      StageName = 'Bid/Quote',
                                                      Request_Won_Verification__c = true,
                                                      Closed_Won_Justification__c ='test',
                                                      CloseDate = System.today(),
                                                      TotalOpportunityQuantity = 80,
                                                      Market_Segment__c = 'Commercial',
                                                      Market_Sub_Segment__c='Owner',
                                                      Basis_of_Design__c = 'View',
                                                      Opportunity_Type__c = 'Priority',
                                                      Construction_Type__c = 'New Construction',
                                                      Install_Type__c = 'Sales',
                                                      Project_City__c = 'San Francisco',
                                                      Project_State__c='CA',
                                                      Requested_Ship_Date_First_Shipment__c = System.today() + 180,
                                                      Book_Date__c = System.today(),                                             
                                                      // JV - 20180205 Added line for new required field
                                                      Promised_Any_Customer__c = 'No',
                                                      Support_Region__c='Atlanta/Carolinas',
                                                      CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId);
        insert opportunity_Obj; 
        
        Product2 pd=VTestDataUtility_OE.getTestProduct();
        pd.name='productWithProductItem';
        Product2 pd1=VTestDataUtility_OE.getTestProduct();
        database.insert(new List<Product2>{pd,pd1});
        
         Schema.Location lc = new Schema.Location(name='test',IsInventoryLocation=true);
        database.insert(lc);
        
        productitem pi = new productitem(Product2Id = pd.Id,QuantityOnHand=5,locationid =lc.id);
        insert pi;
        
        Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = AccId, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
        
         Order_Entry_Release__c oer = new Order_Entry_Release__c(Name='ssss',Order_Type__c='Standard',Payment_Terms__c='IMMEDIATE',Opportunity__c=opportunity_Obj.Id,MES_Routing__c='MES',Shipping_Account__c=AccId);
  			insert oer;
        
       	 Order_Entry_Line__c  orl = new Order_Entry_Line__c(Quantity__c=10,Order_Entry_Release__c=oer.id,Shipment_Date__c=system.today(),Status__c='Draft');
        	insert orl;
        
        
        
    }
*/
}