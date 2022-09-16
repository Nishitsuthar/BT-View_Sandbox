@isTest
public class Order_Entry_Release_BU_AU_Test2PC {

    

    @testSetup
  Static void dataSetUpIgu()
                {
                    List<SKU_Prefix_Element_Map__c> spemList = new List<SKU_Prefix_Element_Map__c>();
                    List<SKU_Prefix_Element_Map_Entry__c> spemeList = new List<SKU_Prefix_Element_Map_Entry__c>();
                    Map<String,String> spemeMap = new Map<String, String>();
                    List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
                    Map<Id,Id> pbIdMap = new Map<Id,Id>();
                    List<Account> insertAccts = new List<Account>();
                    Map<String, RecordType> oelRecordTypeMap = new Map<String, RecordType>(); // Map form OEL RecordType Developer_Name to RecordType 
                    Map<String, RecordType> oerRecordTypeMap = new Map<String, RecordType>();
                    List<Product2> prodList = new List<Product2>();
                    List<Account> billToAcctList = new List<Account>(); // List of BillTo Accounts
                    List<Account> soldToAcctList = new List<Account>(); // List of SoldTo Accounts
                    List<Account> shipToAcctList = new List<Account>(); // List of ShipTo Accounts
                    List<Account> opptyAcctList = new List<Account>();
                    
                     Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        			update standardPricebook;

        			// Create the SKU Prefix Element Map
        Map <String, Map<String,String>> skuPrefixMaps = new Map<String, Map<String,String>> 
        {
            'Laminate' => new Map<String,String> {'NO' => '0', '.060 PVB' => '1', '.090 SGP' => '1', '.030 PVB' => '1', '.090 PVB' => '1', '.060 SGP' => '1', '.180 SGP' => '1'},
            'Generation' => new Map<String,String> {'1' => '1', '2' => '2', '3' => '3'}, 
            'Color' => new Map<String,String> {'CLR (CLEAR)' => '1', 'AZU (AZURIA)' => '3', 
                'PAC (PACIFICA)' => '4', 'SBL (SOLAR BLUE)' => '2', 'SGY (SOLAR GRAY)' => '6', 'CGY (CRYSTAL GRAY)' => '7', 
                'LOW-E SN68' => '8', 'LOW-E I89' => '9',  'LOW-E SN78-65' => 'A'}, 
            'Panes' => new Map<String,String> {'DOUBLE' => '2', 'TRIPLE' => '3'}, 
            'Shape' => new Map<String,String> {'RECTANGLE' => '1', 'SHAPE' => '2'}
        };



        for (String spm : skuPrefixMaps.KeySet())
        { 
            spemList.add(new SKU_Prefix_Element_Map__c(Name = spm));
        }
        insert spemList;


        for (SKU_Prefix_Element_Map__c spem : spemList)
        {
            spemeMap = skuPrefixMaps.get(spem.Name);
            for (String fromValue : spemeMap.keySet())
            {
                spemeList.add(new SKU_Prefix_Element_Map_Entry__c(SKU_Prefix_Element_Map__c = spem.Id, Name = fromValue, Map_to_Value__c = spemeMap.get(fromValue)));
            }
        }
        insert spemeList;

	System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());

        // Record Type Id
        for (RecordType rt : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND (SObjectType = 'Order_Entry_Line__c' OR SObjectType = 'Order_Entry_Release__c')])
        {
            if (rt.SObjectType == 'Order_Entry_Line__c')
            {
                oelRecordTypeMap.put(rt.DeveloperName, rt);
            }
            else
            {
                oerRecordTypeMap.put(rt.DeveloperName, rt);            
            }
        }


        // Create Product 

        Product2 newProduct;
            
            List<String> genList = new List<String>(skuPrefixMaps.get('Generation').keySet());
            List<String> shapeList = new List<String>(skuPrefixMaps.get('Shape').keySet());
            List<String> paneList = new List<String>(skuPrefixMaps.get('Panes').keySet());
            List<String> colorList = new List<String>(skuPrefixMaps.get('Color').keySet());
            List<String> lamiList = new List<String>(skuPrefixMaps.get('Laminate').keySet());
            Map<Id, Id> pbeToProdMap = new  Map<Id, Id>();  // Map from PriceBookEntry Id to Product Id
    		Map<Id, Id> prodToPBEMap = new  Map<Id, Id>();
            Integer genListSize = genList.size();
            Integer shapeListSize = shapeList.size();
            Integer paneListSize = paneList.size();
            Integer colorListSize = colorList.size();
            Integer lamiListSize = lamiList.size();
            String productCode;
            String generation;          
            String shape;
            String panes;
            String color;
            String lamination;

            for (Integer i = 1; i <= 1; i++)
            {               
                generation = genList[XMath.getRandomInt(genListSize)];
                panes = paneList[XMath.getRandomInt(paneListSize)];
                color = colorList[XMath.getRandomInt(colorListSize)];
                lamination = lamiList[XMath.getRandomInt(lamiListSize)];
                shape = shapeList[XMath.getRandomInt(shapeListSize)];
                productCode = '9' + String.valueOf(XMath.getRandomInt(100)) + '-' + String.valueOf(XMath.getRandomInt(100000));
                
                
                newProduct = new Product2(Name = 'Product' + String.valueOf(i), Generation__c = generation, Shape__c = shape, Inboard_Lite__c = color,
                    Panes__c = panes, Laminate__c = lamination, IsActive = true, ProductCode = productCode, Family = 'IGU', IGU_Overall_ThickNess__c = 1.0000,
                    Bird_Friendly__c = 'No', Edge_Black__c = 'None', Inboard_Laminate_Specifications__c ='6MM CLR AN / 0.060 PVB / 6MM CLR T', SBQQ__IncludeInMaintenance__c = true,
                    Inboard_Treatment__c = 'T (Tempered)', Inboard_Thickness__c = '6 MM', Outboard_Lite__c = '6MM EC #2 CLR T', Outboard_Treatment__c = 'T (Tempered)', 
                    Pig_Tail__c = 'KEYED M8', Spacer__c = '1/2 90% Argon', Spacer_Fill__c = '90% Argon', Spacer_Thickness__c = '1/2" (12.7 mm.)', Spacer_Type__c = 'TRISEAL FOAM',
                    Secondary_Seal_Color__c = 'Black', Secondary_Seal_Type__c = 'SI' ); 
                if (panes == 'TRIPLE')
                {
                    newProduct.Middle_Lite__c = 'CLEAR';
                    newProduct.Middle_Lite_Thickness__c = '6MM';
                    newProduct.Middle_Lite_Treatment__c = 'T (Tempered)';
                    newProduct.Spacer_2_Fill__c = '90% Argon';
                    newProduct.Spacer_2_Thickness__c = '1/2" (12.7 mm.)';
                } 
                ProdList.add(newProduct);                          
            }
            insert ProdList;
			System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());

            ProdList = [SELECT Id,Product_SKU__c, Name, Generation__c, Shape__c, Inboard_Lite__c, Laminate__c, ProductCode, Family FROM Product2];
            
            for (Product2 prod : ProdList)
            {
                Decimal price = XMath.getRandomInt(1000) * 0.1;
                pbeList.Add(new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = prod.Id, UnitPrice = price, isActive = true));
            }
            insert pbeList;
                    
             System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
            for(PriceBookEntry pbe : pbeList)
            {
                pbeToProdMap.put(pbe.id, pbe.Product2Id);
                prodToPBEMap.put(pbe.product2Id, pbe.Id);
            }



            // Create Account 

            List<Account> acctList = new List<Account>();

            	// Account
            	acctList.add(new Account (Name = 'Bill to Account ', BillingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Billing St.', 
                    BillingCity = 'Billing City ', BillingState = 'CA', BillingPostalCode = String.valueOf(XMath.getRandomInt(10000)), 
                    BillingCountry = 'United States', ShippingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                    ShippingPostalCode = String.valueOf(XMath.getRandomInt(100000)), ShippingCountry = 'United States', Contract_Signed__c = false, 
                    Oracle_Customer_Number__c = String.valueOf(XMath.getRandomInt(10000))));

            	// Sold to Account 
            	acctList.add(new Account (Name = 'Sold to Account ', BillingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Billing St.', 
                    BillingCity = 'Billing City ', BillingState = 'CA', BillingPostalCode = String.valueOf(XMath.getRandomInt(10000)), 
                    BillingCountry = 'United States', ShippingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                    ShippingPostalCode = String.valueOf(XMath.getRandomInt(100000)), ShippingCountry = 'United States', Contract_Signed__c = false, 
                    Oracle_Customer_Number__c = String.valueOf(XMath.getRandomInt(10000))));

            	// Ship to Account
            	acctList.add(new Account (Name = 'Ship to Account ', BillingStreet = String.valueOf(XMath.getRandomInt(1000)) +  ' Billing St.', 
                BillingCity = 'Billing City ', BillingState = 'CA', BillingPostalCode = String.valueOf(XMath.getRandomInt(10000)), 
                BillingCountry = 'United States', ShippingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                ShippingPostalCode = String.valueOf(XMath.getRandomInt(100000)), ShippingCountry = 'United States', Contract_Signed__c = false, 
                Oracle_Customer_Number__c = String.valueOf(XMath.getRandomInt(10000))));


            	// Opp Account

            	acctList.add(new Account (Name = 'Opportunity Account ', BillingStreet = String.valueOf(XMath.getRandomInt(1000)) +  ' Opportunity St.', 
                    BillingCity = 'Billing City ', BillingState = 'CA', BillingPostalCode = String.valueOf(XMath.getRandomInt(10000)), 
                    BillingCountry = 'United States', ShippingStreet = String.valueOf(XMath.getRandomInt(1000)) +  'Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                    ShippingPostalCode = String.valueOf(XMath.getRandomInt(100000)), ShippingCountry = 'United States', Contract_Signed__c = false, 
                    Oracle_Customer_Number__c = String.valueOf(XMath.getRandomInt(10000))));


                insert acctList;
					System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
                for(Account acct : acctList)
        {
            if (acct.Name.contains('Bill to'))
            {
                billToAcctList.add(acct);
            }
            else
                {
                if (acct.Name.contains('Sold to'))
                {
                    soldToAcctList.add(acct);
                }
                else
                {
                    if (acct.Name.contains('Ship to'))
                    {
                        shipToAcctList.add(acct);
                    }
                    else
                    {           
                        opptyAcctList.add(acct);                                       
                    }                       
                }
            }
        }

        // Create Contact 
		
        Contact contactsForAcct = new Contact(LastName = acctList[0].Name + '-' + 'Contact One',
        									Email='test@gmail.com',Phone = '1234567890', AccountId = acctList[0].Id);
         Test.startTest();
        insert contactsForAcct;
				System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());	
		// Create Opportunity 
		
		List<String> regionList = new List<String> {'Atlanta/Carolinas', 'Bay Area', 'Boston', 'Chicago', 'Dallas', 'Denver', 'Florida', 'Hawaii', 'Houston', 
            'International', 'Los Angeles/SoCal', 'Memphis/Mid-South', 'New York', 'Portland/Seattle', 'Toronto', 'Vancouver', 'Washington DC'};
        Map<String, RecordType> opptyRTMap = new Map<String, RecordType>();

            for (RecordType ort : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'Opportunity'])
            {
                opptyRTMap.put(ort.DeveloperName, ort);
            }
	Id opptyRecTypeId = opptyRTMap.get('MOU_Single_Opportunity').Id;
            Opportunity opptysForAcct = new Opportunity(Name = 'Opportunity Test', PriceBook2Id = standardPriceBook.Id,
                        AccountId = acctList[0].Id, RecordTypeID = opptyRecTypeId, StageName = 'Bid/Quote', Request_Won_Verification__c = true, 
                        Closed_Won_Justification__c ='Justification', CloseDate = System.today() + 45, Market_Segment__c = 'Commercial',
                        Market_Sub_Segment__c='Owner', Basis_of_Design__c = 'View', Opportunity_Type__c = 'Pipeline', Construction_Type__c = 'New Construction',
                        Install_Type__c = 'Sales', Project_Address__c = acctList[0].BillingStreet, Project_City__c = acctList[0].BillingCity, Project_State__c = acctList[0].BillingState,
                        Requested_Ship_Date_First_Shipment__c = System.Today() + 90, Support_Region__c = 'Bay Area',Regional_Vice_President__c = '005E0000007Nik3');
                    
                    
                    System.debug('After Start Test Data set up CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
            insert opptysForAcct;
					//Test.StopTest();
            // Cutomer Purchase Order 
            Customer_Purchase_Order__c cPOsForOppty = new Customer_Purchase_Order__c(Name = 'PO-' + String.valueOf(XMath.getRandomInt(100000)), 
                                                                 Opportunity__c = opptysForAcct.Id, Billing_Account__c = acctList[0].Id,
                        Shipping_Account__c = acctList[0].Id, Name__c = 'Customer Purchase Order ' );

            insert cPOsForOppty;

		System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
            Decimal discount;
            discount = XMath.getRandomInt(25)/100.0;
            // Opportunity Line Items
            OpportunityLineItem olisForOppty = new OpportunityLineItem(Product2Id = ProdList[0].id,Quantity = 2, ServiceDate = System.today() + 80, 
                    UnitPrice = 10.0, OpportunityId = opptysForAcct.Id, Discount = discount);

            insert olisForOppty;
                    System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
				Test.StopTest();
                    System.debug('After stop test data setup CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
            //Create Standard SFDC Quotes
            List<Quote> sfdcQuotesToInsert = new List<Quote>();
            List<Quote> quotesForOppty =  new List<Quote>();

            // Quote 1
            quotesForOppty.add(new Quote(Name = 'Quote 2' , OpportunityId = opptysForAcct.Id, PriceBook2Id = standardPriceBook.Id, 
                        ExpirationDate = System.today() + 60, Quote_Type__c = 'All-In'));

            // Quote 2
            quotesForOppty.add(new Quote(Name = 'Quote 2' , OpportunityId = opptysForAcct.Id, PriceBook2Id = standardPriceBook.Id, 
                        ExpirationDate = System.today() + 60, Quote_Type__c = 'All-In'));

            insert quotesForOppty;

            // SFDX Quote lines
            List<QuoteLineItem> qlisForQuote = new List<QuoteLineItem>();

            OpportunityLineItem getOppLines = [Select id,Product2Id,Quantity,ServiceDate,UnitPrice,OpportunityId,Discount FROM 
            										OpportunityLineItem WHERE Id=: olisForOppty.Id];

            qlisForQuote.add (new QuoteLineItem(QuoteId = quotesForOppty[0].Id, Description = 'Quote Line Item 1 ', 
                    PriceBookEntryId = prodToPBEMap.get(getOppLines.Product2Id), Quantity = getOppLines.Quantity, OpportunityLineItemId = getOppLines.Id, 
                    Discount = getOppLines.Discount, UnitPrice = getOppLines.UnitPrice, Product2Id = getOppLines.Product2Id));

            qlisForQuote.add (new QuoteLineItem(QuoteId = quotesForOppty[1].Id, Description = 'Quote Line Item 2', 
                    PriceBookEntryId = prodToPBEMap.get(getOppLines.Product2Id), Quantity = getOppLines.Quantity, OpportunityLineItemId = getOppLines.Id, 
                    Discount = getOppLines.Discount, UnitPrice = getOppLines.UnitPrice, Product2Id = getOppLines.Product2Id));

            insert qlisForQuote;

			System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
            // Create CPQ Quote Objects
            List<SBQQ__Quote__c> quotesForOpptyCPQ =  new List<SBQQ__Quote__c>();
            RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND 
            					SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];

            quotesForOpptyCPQ.add(new SBQQ__Quote__c(RecordTypeId = qrt.Id, SBQQ__Opportunity2__c = opptysForAcct.Id, Related_Opportunity__c = opptysForAcct.Id, SBQQ__Pricebook__c = standardPriceBook.Id, 
                        SBQQ__ExpirationDate__c = System.today() + 60, Quote_Plan__c = 'All In', Quote_Type__c = 'All In',SBQQ__PrimaryContact__c=contactsForAcct.Id));


            quotesForOpptyCPQ.add(new SBQQ__Quote__c(RecordTypeId = qrt.Id, SBQQ__Opportunity2__c = opptysForAcct.Id, Related_Opportunity__c = opptysForAcct.Id, SBQQ__Pricebook__c = standardPriceBook.Id, 
                        SBQQ__ExpirationDate__c = System.today() + 60, Quote_Plan__c = 'All In', Quote_Type__c = 'All In',SBQQ__PrimaryContact__c=contactsForAcct.Id));


            insert quotesForOpptyCPQ;

			System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
            // Create CPQ Quotes Lines
            List<SBQQ__QuoteLine__c> qlisForQuoteCPQ = new List<SBQQ__QuoteLine__c>();

            qlisForQuoteCPQ.add (new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotesForOpptyCPQ[0].Id, 
                    SBQQ__Quantity__c = getOppLines.Quantity,
                    SBQQ__Discount__c = getOppLines.Discount, SBQQ__CustomerPrice__c = getOppLines.UnitPrice, SBQQ__Product__c = getOppLines.Product2Id));

            qlisForQuoteCPQ.add (new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotesForOpptyCPQ[1].Id, 
                    SBQQ__Quantity__c = getOppLines.Quantity,
                    SBQQ__Discount__c = getOppLines.Discount, SBQQ__CustomerPrice__c = getOppLines.UnitPrice, SBQQ__Product__c = getOppLines.Product2Id));

            insert qlisForQuoteCPQ;
                   
			System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());

                   // Order Entry Release Create Quote__c 

               Order_Entry_Release__c newOER = new Order_Entry_Release__c(Name = 'Order Entry Test Release- 1', Opportunity__c = opptysForAcct.id, Order_Entry_Release_Date__c = System.today(),Deposit_Amount__c = 200, 
                Request_Date__c = System.today() + 90, Sold_to_Account__c = acctList[1].Id, Sold_To_Street_1__c = soldToAcctList.get(0).BillingStreet, Sold_to_City__c = soldToAcctList.get(0).BillingCity,
                Sold_To_Postal_Code__c = soldToAcctList.get(0).BillingPostalCode, Sold_To_State_Province__c = soldToAcctList.get(0).BillingState, Sold_to_Country__c = soldToAcctList.get(0).BillingCountry, 
                Shipping_Account__c = shipToAcctList.get(0).Id, Shipping_Street_1__c = shipToAcctList.get(0).ShippingStreet, Shipping_City__c = shipToAcctList.get(0).ShippingCity, Shipping_Name__c = shipToAcctList.get(0).name,
                Shipping_Postal_Code__c = shipToAcctList.get(0).ShippingPostalCode, Shipping_State_Province__c = shipToAcctList.get(0).ShippingState, Shipping_Country__c = shipToAcctList.get(0).ShippingCountry,
                Billing_Account__c = billToAcctList.get(0).Id, Billing_Street_1__c = billToAcctList.get(0).BillingStreet, Billing_City__c = billToAcctList.get(0).BillingCity, Shipping_Container__c = 'Wood Crate',
                Billing_Postal_Code__c = billToAcctList.get(0).BillingPostalCode, Billing_State_Province__c = billToAcctList.get(0).BillingState, Billing_Country__c = billToAcctList.get(0).BillingCountry, 
                System_of_Measurement__c = 'Imperial (US Standard)', Status__c = 'Draft', Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', Freight__c = 'Billable',Packing_Instructions__c = 'Test Pack IGU',
                Release_Name__c = 'Order Entry Release Name 1' , Billing_Contact__c = contactsForAcct.Id, Sold_To_Contact__c = contactsForAcct.Id, Payment_Terms__c = '30 NET', CPQ_Quote__c = quotesForOpptyCPQ[0].Id ,
                Scheduled_Ship_Date__c = System.today() + 25, Promised_Date__c = System.today() + 20, Shipping_Contact__c = contactsForAcct.Id, RecordTypeId = oerRecordTypeMap.get('IGU').Id,
                First_Scheduled_Ship_Date__c = null,First_Promised_Date__c = null,First_Request_Ship_Date__c = null,Customer_Confirmation_Signed__c = True); 



               insert newOER;
				System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
               // Create OEL Lines
               Order_Entry_Line__c newOEL = new Order_Entry_Line__c(Order_Entry_Release__c = newOER.Id, Quantity__c = 15, Base_In__c = '15', Height_In__c = '15',CPQ_Quote_Line__c = qlisForQuoteCPQ[0].Id,
                            Base_Height_1_In__c = '', Shape__c = 'Rectangle', RecordTypeId = oelRecordTypeMap.get('IGU_Imperial').Id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', Product__c = ProdList[0].Id, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-3', Shipping_Name__c = shipToAcctList.get(0).name, Shipping_Street_1__c = shipToAcctList.get(0).ShippingStreet, 
                            Shipping_Account__c = shipToAcctList.get(0).Id, Shipping_City__c = shipToAcctList.get(0).ShippingCity, Shipping_Postal_Code__c = shipToAcctList.get(0).ShippingPostalCode,
                            Shipping_State_Province__c = shipToAcctList.get(0).ShippingState, Shipping_Country__c = shipToAcctList.get(0).ShippingCountry, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Scheduled_Ship_Date__c = System.today() + 20, Promised_Date__c = System.today() + 25,
                            Request_Date__c = System.today() + 30);

               insert newOEL;
				System.debug('Data set up ENDS CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
                }
    
    static testmethod void IgumethodOne()
    {
        System.debug(' In method One');
        
        System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
        Test.StartTest();
        		
			Order_Entry_Release__c oerIgu = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c,Request_Date__c, Sold_to_Account__c, 
                                             Sold_To_Street_1__c, Sold_to_City__c,Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c,Deposit_Amount__c, 
                    						 Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,Shipping_Postal_Code__c,First_Promised_Date__c,First_Request_Ship_Date__c,
                                             Shipping_State_Province__c, Shipping_Country__c,Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    						 Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    						 Release_Name__c,First_Scheduled_Ship_Date__c,Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c,Packing_Instructions__c, 
                                             Customer_Confirmation_Signed__c FROM Order_Entry_Release__c];
        
        	Order_Entry_Line__c oelIgu = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c FROM Order_Entry_Line__c];
        System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
        // test
        //  test2
		//System.debug('  OEL Method One '+oerIgu);
        	List<Account> allInsAcc = [Select id,BillingAddress,ShippingAddress FROM Account];	
									oerIgu.Trigger_Source__c = 'UI';
        							oerIgu.Shipping_Street_1__c  = 'Test OER BM';
        							oerIgu.Billing_Account__c  = allInsAcc[2].Id;
        							oerIgu.Sold_to_Account__c = allInsAcc[2].Id;
        							oerIgu.Request_Date__c  = System.today() + 45;
        							oerIgu.Promised_Date__c  = System.today() + 25;
        							oerIgu.Scheduled_Ship_Date__c  = System.today() + 50;
        							oerIgu.Packing_Instructions__c = 'IGU Method One ';
        							oerIgu.Deposit_Amount__c = 500;
        							oerIgu.First_Promised_Date__c = null;
        							oerIgu.First_Request_Ship_Date__c  = null;
        							oerIgu.First_Scheduled_Ship_Date__c = null;
        							oerIgu.Status__c = 'Pre-Release Review';
        						System.debug(' 9966 - 378 '+ oerIgu.Status__c);
        							UPDATE oerIgu;
        							
        							oerIgu.Status__c = 'Confirmation Pending';
        						System.debug(' 9966 - 382 '+ oerIgu.Status__c );
        							UPDATE oerIgu;
        							
        							
        					try
                            {	
                                test.isRunningTest();
                                   
                                   oerIgu.CPQ_Quote__c = null;
                                   oerIgu.Quote__c = null;
                                   UPDATE oerIgu;
                                 	
                            }
        						catch(DmlException ex)
                                { }
		System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
        Test.StopTest();
        	
        	
    }
    
    
    static testmethod void IgumethodTwo()
    {
        
        System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
        Test.startTest();
			Order_Entry_Release__c oerIgu = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c,Request_Date__c, Sold_to_Account__c, 
                                             Sold_To_Street_1__c, Sold_to_City__c,Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c,Deposit_Amount__c, 
                    						 Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,Shipping_Postal_Code__c,
                                             Shipping_State_Province__c, Shipping_Country__c,Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    						 Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    						 Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c,Packing_Instructions__c,Customer_Confirmation_Signed__c 
                                             FROM Order_Entry_Release__c];
			
        	Order_Entry_Line__c oelIgu = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c FROM Order_Entry_Line__c];
        
        System.debug('  OEL Method TWO '+oerIgu);
        							List<Quote> createQuote = [Select id from Quote];
        							List<SBQQ__Quote__c> createdSBQQuote = [Select id from SBQQ__Quote__c];
        					try
                            {	
                                test.isRunningTest();
                                   
                                   oerIgu.CPQ_Quote__c = Null;
                                   oerIgu.Quote__c = createQuote[0].Id;
                                   UPDATE oerIgu;
                                System.debug('CPU Time '+Limits.getCpuTime() + ' SOQL '+Limits.getQueries());
                                Test.StopTest();

                                	
                                 	
                            }
        						catch(DmlException ex)
                                { }
        	
    }
}