@isTest
public class OETestDataFactory
{
    // Version 4:
    // - Adds OER RecordType handling to v.3
    // Version 3:
    //  - Modification to support CPQ Quote objects
    //  - Additional fields added to Product generation to satisfy Validation Rules
    //  - Modified to support both CPQ and SFDC Quote objects
    //

    public static Boolean associateOELsToQLs = TRUE;
    public static OETestData CreateNonOrderData(Map<String,Integer> entityCounts)
    {
        OETestData oetd = new OETestData();
        List<SKU_Prefix_Element_Map__c> spemList = new List<SKU_Prefix_Element_Map__c>();
        List<SKU_Prefix_Element_Map_Entry__c> spemeList = new List<SKU_Prefix_Element_Map_Entry__c>();
        Map<String,String> spemeMap = new Map<String, String>();
        List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
        Map<Id,Id> pbIdMap = new Map<Id,Id>();
        List<Account> insertAccts = new List<Account>();
       

        Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
        System.Debug('*** Entity Counts:');
        for (String key : entityCounts.keySet())
        {
            System.debug('    ' + key + ' = ' + entityCounts.get(key));
        }
        //
        // Create the SKU Prefix Element Map
        //
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
         System.debug('  First Start debug CPU Time '+Limits.getCpuTime());
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        //
        //  Create Users
        //
       
	
		System.runAs(new User(id = UserInfo.getUserId()))  
        {
        if ((entityCounts.get('Users') != null && entityCounts.get('Users') > 0) || (entityCounts.get('AdminUsers') != null && entityCounts.get('AdminUsers') > 0))
        {                           
            Id adminProfileId = [SELECT Id, Name from Profile WHERE Name = 'System Administrator' LIMIT 1 ].Id;
            Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
                System.debug('*** AdminUsers = ' + String.valueOf(entityCounts.get('AdminUsers')));
            if(entityCounts.get('AdminUsers') != null && entityCounts.get('AdminUsers') > 0)
            {
                for(Integer i = 0; i < entityCounts.get('AdminUsers'); i++)
                {
                    oetd.adminUserList.add(new User(Alias = 'Adm' + String.valueOf(i + 1), Email='AdminUser' + String.valueOf(i + 1) + '@view.com', 
                    EmailEncodingKey='UTF-8', LastName='AdminUser'+ String.valueOf(i + 1), LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = adminProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com'));
                }
            }
            insert oetd.adminUserList;
            System.debug('*** Users = ' + String.valueOf(entityCounts.get('Users')));
             System.debug('  First Start debug CPU Time '+Limits.getCpuTime());
            System.debug('   SOQL LIMITS '+Limits.getQueries());
            
            if(entityCounts.get('Users') != null && entityCounts.get('Users') > 0 && dealDeskProfileId != null)
            {
                User newUser;
                for(Integer i = 0; i < entityCounts.get('Users'); i++)
                {
                    oetd.userList.add(new User(Alias = 'User' + String.valueOf(i + 1), Email='User' + String.valueOf(i + 1) + '@view.com', 
                    EmailEncodingKey='UTF-8', LastName='User' + String.valueOf(i + 1), LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com'));
                }
            }
            if (oetd.userList.size() > 0)
            {
                insert oetd.userList;
            }
        }               
    }
        //
        // Get IGU Record Types
        //
        
        // JV 20181003 - Changes to handle OER Record Types - Modified the following select to retreive both Releae and Line RecordTypes
        for (RecordType rt : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND (SObjectType = 'Order_Entry_Line__c' OR SObjectType = 'Order_Entry_Release__c')])
        {
            if (rt.SObjectType == 'Order_Entry_Line__c')
            {
                oetd.oelRecordTypeMap.put(rt.DeveloperName, rt);
            }
            else
            {
                oetd.oerRecordTypeMap.put(rt.DeveloperName, rt);            
            }
        }
        System.debug('**** Limit: Queries Before Products Created = '+ String.valueof(Limits.getQueries()));
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
        //
        // Create Products
        //
        
        if (entityCounts.get('Products') != null && entityCounts.get('Products') > 0) 
        {
            Product2 newProduct;
            
            List<String> genList = new List<String>(skuPrefixMaps.get('Generation').keySet());
            List<String> shapeList = new List<String>(skuPrefixMaps.get('Shape').keySet());
            List<String> paneList = new List<String>(skuPrefixMaps.get('Panes').keySet());
            List<String> colorList = new List<String>(skuPrefixMaps.get('Color').keySet());
            List<String> lamiList = new List<String>(skuPrefixMaps.get('Laminate').keySet());
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

            for (Integer i = 1; i <= entityCounts.get('Products'); i++)
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
                oetd.ProdList.add(newProduct);                          
            }
            insert oetd.ProdList;
            
             System.debug('  First Start debug CPU Time '+Limits.getCpuTime());
            System.debug('   SOQL LIMITS '+Limits.getQueries());
            
            oetd.prodList = [SELECT Id, Product_SKU__c, Name, Generation__c, Shape__c, Inboard_Lite__c, Laminate__c, ProductCode, Family FROM Product2];
            
            for (Product2 prod : oetd.prodList)
            {
                Decimal price = XMath.getRandomInt(1000) * 0.1;
                pbeList.Add(new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = prod.Id, UnitPrice = price, isActive = true));
            }
            insert pbeList;
            for(PriceBookEntry pbe : pbeList)
            {
                oetd.pbeToProdMap.put(pbe.id, pbe.Product2Id);
                oetd.prodToPBEMap.put(pbe.product2Id, pbe.Id);
            }
        }
        System.debug('**** Limit: Queries After Products Created = '+ String.valueof(Limits.getQueries()));
        System.debug('   SOQL LIMITS '+Limits.getQueries());
            
        //
        // Create Accounts
        //
        List<Account> acctList = new List<Account>();

        if (entityCounts.get('BillToAccts') != null && entityCounts.get('BillToAccts') > 0)
        {
            for (Integer i = 1; i <= entityCounts.get('BillToAccts'); i++)
            {
                acctList.add(new Account (Name = 'Bill to Account ' + String.ValueOf(i), BillingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Billing St.', 
                    BillingCity = 'Billing City ' + String.valueOf(i), BillingState = 'CA', BillingPostalCode = String.valueOf(XMath.getRandomInt(10000)), 
                    BillingCountry = 'United States', ShippingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                    ShippingPostalCode = String.valueOf(XMath.getRandomInt(100000)), ShippingCountry = 'United States', Contract_Signed__c = false, 
                    Oracle_Customer_Number__c = String.valueOf(XMath.getRandomInt(10000))));                    
            }
        }
        if (entityCounts.get('SoldToAccts') != null && entityCounts.get('SoldToAccts') > 0)
        {
            for (Integer i = 1; i <= entityCounts.get('SoldToAccts'); i++)
            {
                acctList.add(new Account (Name = 'Sold to Account ' + String.ValueOf(i), BillingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Billing St.', 
                    BillingCity = 'Billing City ' + String.valueOf(i), BillingState = 'CA', BillingPostalCode = String.valueOf(XMath.getRandomInt(10000)), 
                    BillingCountry = 'United States', ShippingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                    ShippingPostalCode = String.valueOf(XMath.getRandomInt(100000)), ShippingCountry = 'United States', Contract_Signed__c = false, 
                    Oracle_Customer_Number__c = String.valueOf(XMath.getRandomInt(10000))));                    
            }
        }
        if (entityCounts.get('ShipToAccts') != null && entityCounts.get('ShipToAccts') > 0)
        {
            for (Integer i = 1; i <= entityCounts.get('ShipToAccts'); i++)
            {
                acctList.add(new Account (Name = 'Ship to Account ' + String.ValueOf(i), BillingStreet = String.valueOf(XMath.getRandomInt(1000)) +  ' Billing St.', 
                BillingCity = 'Billing City ' + String.valueOf(i), BillingState = 'CA', BillingPostalCode = String.valueOf(XMath.getRandomInt(10000)), 
                BillingCountry = 'United States', ShippingStreet = String.valueOf(XMath.getRandomInt(1000)) + ' Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                ShippingPostalCode = String.valueOf(XMath.getRandomInt(100000)), ShippingCountry = 'United States', Contract_Signed__c = false, 
                Oracle_Customer_Number__c = String.valueOf(XMath.getRandomInt(10000))));                    
            }
        }
        if (entityCounts.get('OpptyAccts') != null && entityCounts.get('OpptyAccts') > 0)
        {
            for (Integer i = 1; i <= entityCounts.get('OpptyAccts'); i++)
            {
                acctList.add(new Account (Name = 'Opportunity Account ' + String.ValueOf(i), BillingStreet = String.valueOf(XMath.getRandomInt(1000)) +  ' Opportunity St.', 
                    BillingCity = 'Billing City ' + String.valueOf(i), BillingState = 'CA', BillingPostalCode = String.valueOf(XMath.getRandomInt(10000)), 
                    BillingCountry = 'United States', ShippingStreet = String.valueOf(XMath.getRandomInt(1000)) +  'Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                    ShippingPostalCode = String.valueOf(XMath.getRandomInt(100000)), ShippingCountry = 'United States', Contract_Signed__c = false, 
                    Oracle_Customer_Number__c = String.valueOf(XMath.getRandomInt(10000))));                    
            }
        }
        
        insert acctList;
        System.debug('**** Limit: Accounts Created = '+ String.valueof(Limits.getQueries()));
         System.debug('  First Start debug CPU Time '+Limits.getCpuTime());
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
        for(Account acct : acctList)
        {
            if (acct.Name.contains('Bill to'))
            {
                oetd.billToAcctList.add(acct);
            }
            else
                {
                if (acct.Name.contains('Sold to'))
                {
                    oetd.soldToAcctList.add(acct);
                }
                else
                {
                    if (acct.Name.contains('Ship to'))
                    {
                        oetd.shipToAcctList.add(acct);
                    }
                    else
                    {           
                        oetd.opptyAcctList.add(acct);                                       
                    }                       
                }
            }
        }
        //
        // Create Contacts for Account
        //
        List<Contact> contactsToInsert = new List<Contact>();
        if (entityCounts.get('ContactsPerAcct') != null && entityCounts.get('ContactsPerAcct') > 0)
        {
            for (Account acct : acctList)
            {
                List<Contact> contactsForAcct = new List<Contact>();
                for (Integer i = 0; i < acctList.size(); i++)
                {               
                    contactsForAcct.add(new Contact(LastName = acct.Name + '-' + 'Contact ' + String.valueOf(i + 1),Email='test@gmail.com',Phone = '1234567890', AccountId = acct.Id));
                }
                oetd.contactMap.put(acct.Id, contactsForAcct);
                contactsToInsert.addAll(contactsForAcct); 
            }
        }
        insert contactsToInsert;
        
        System.debug('**** Limit: Queries After Accounts and Contacts Created = '+ String.valueof(Limits.getQueries()));
         System.debug('  First Start debug CPU Time '+Limits.getCpuTime());
        System.debug('   SOQL LIMITS '+Limits.getQueries());

        //
        // Create Opportunities
        //
        if (entityCounts.get('OpptysPerOpptyAcct') != null && entityCounts.get('OpptysPerOpptyAcct') > 0)
        {
            Map<String, RecordType> opptyRTMap = new Map<String, RecordType>();
            List<String> regionList = new List<String> {'Atlanta/Carolinas', 'Bay Area', 'Boston', 'Chicago', 'Dallas', 'Denver', 'Florida', 'Hawaii', 'Houston', 
            'International', 'Los Angeles/SoCal', 'Memphis/Mid-South', 'New York', 'Portland/Seattle', 'Toronto', 'Vancouver', 'Washington DC'};
            List<SalesSupportDirector__c> ssdList = new List<SalesSupportDirector__c>();
            List <Customer_Success_Manager__c> csmList = new List <Customer_Success_Manager__c>();
            for (String reg : regionList)
            {
                ssdList.add(new SalesSupportDirector__c(Name = reg, User_Name__c = reg + ' Sales Support Director'));
                csmList.add(new Customer_Success_Manager__c(Name = reg, User_Name__c = reg + ' Customer Success Manager'));
            }
            insert ssdList;
            insert csmList;
            for (RecordType ort : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'Opportunity'])
            {
                opptyRTMap.put(ort.DeveloperName, ort);
            }
            String acctSeqNum;
            String regionName;
            Id opptyRecTypeId = opptyRTMap.get('MOU_Single_Opportunity').Id;
            List<Opportunity> opptysToInsert = new List<Opportunity>();
            for (Account acct : oetd.opptyAcctList)
            {
                List<Opportunity> opptysForAcct = new List<Opportunity>();
                acctSeqNum = acct.Name.subStringAfterLast(' ');
                for(Integer i = 1; i <= oetd.opptyAcctList.size(); i++)
                {                   
                    regionName = regionList[XMath.getRandomInt(regionList.size())];
                    opptysForAcct.add(new Opportunity(Name = 'Opportunity' + ' ' + acctSeqNum + String.valueOf(i), PriceBook2Id = standardPriceBook.Id,
                        AccountId = acct.Id, RecordTypeID = opptyRecTypeId, StageName = 'Bid/Quote', Request_Won_Verification__c = true, 
                        Closed_Won_Justification__c ='Justification', CloseDate = System.today() + 45, Market_Segment__c = 'Commercial',
                        Market_Sub_Segment__c='Owner', Basis_of_Design__c = 'View', Opportunity_Type__c = 'Pipeline', Construction_Type__c = 'New Construction',
                        Install_Type__c = 'Sales', Project_Address__c = acct.BillingStreet, Project_City__c = acct.BillingCity, Project_State__c = acct.BillingState,
                        Requested_Ship_Date_First_Shipment__c = System.Today() + 90, Support_Region__c = regionName,Regional_Vice_President__c ='005E0000007Nik3'));
                }
                oetd.opptyMap.put(acct.Id, opptysForAcct);
                oetd.opportunityList.addAll(opptysForAcct);
                opptysToInsert.addAll(opptysForAcct);
            }
            insert opptysToInsert;
            for (Opportunity ofa : opptysToInsert)
            {
                oetd.opptyIdMap.put(ofa.Id, ofa);
            }

        }
        System.debug('**** Limit: Queries After Opportunities Created = '+ String.valueof(Limits.getQueries()));
         System.debug('  First Start debug CPU Time '+Limits.getCpuTime());
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        //
        // Create Customer Purchase Orders
        //
        if (entityCounts.get('CPOsPerOppty') != null && entityCounts.get('CPOsPerOppty') > 0)
        {
            Account cpoBillToAccount;
            Account cpoShipToAccount;
            List<Customer_Purchase_Order__c> cPOsToInsert = new List<Customer_Purchase_Order__c>();
            String cpoOpptySeqNum;
            
            for (Opportunity oppty : oetd.opportunityList)
            {
                List<Customer_Purchase_Order__c> cPOsForOppty = new List<Customer_Purchase_Order__c>();
                cpoOpptySeqNum = oppty.Name.subStringAfterLast(' ');
                for(Integer i = 1; i <= entityCounts.get('CPOsPerOppty'); i++)
                {
                    cpoBillToAccount = oetd.billToAcctList[XMath.getRandomInt(oetd.BillToAcctList.size())];
                    cpoShipToAccount = oetd.shipToAcctList[XMath.getRandomInt(oetd.shipToAcctList.size())];
                    cPOsForOppty.add(new Customer_Purchase_Order__c(Name = 'PO-' + String.valueOf(XMath.getRandomInt(100000)), Opportunity__c = oppty.Id, Billing_Account__c = cpoBillToAccount.Id,
                        Shipping_Account__c = cpoShipToAccount.Id, Name__c = 'Customer Purchase Order ' + cpoOpptySeqNum + String.valueOf(i)));
                }
                oetd.custPOMap.put(oppty.Id, cPOsForOppty);
                cPOsToInsert.addAll(cPOsForOppty);                      
            }
            insert cPOsToInsert;
        }       
        //
        // Create Opportunity Line Items            
        //
        String opptySeqNum; 
        Decimal listPrice;
        Decimal unitPrice;
        Decimal discount;
        Decimal totalPrice;
        Integer quantity;
        List<OpportunityLineItem> olisToInsert = new List<OpportunityLineItem>();
        for (Opportunity oppty : oetd.opportunityList)
        {
            List<OpportunityLineItem> olisForOppty = new List<OpportunityLineItem>();
            opptySeqNum = oppty.Name.subStringAfterLast(' ');
            listPrice = XMath.getRandomInt(5000)/100.0;
            if (listPrice == 0.0) listPrice = 1.0;
            unitPrice = listPrice * 0.85;
            if (unitPrice == 0.0) unitPrice = 1.0;
            quantity = XMath.getRandomInt(25);
            if (quantity == 0) quantity = 1;
            discount = XMath.getRandomInt(25)/100.0;
            for (Product2 prod : oetd.prodList)
            {
                olisForOppty.add(new OpportunityLineItem(Product2Id = prod.Id, Quantity = quantity, ServiceDate = System.today() + 180, 
                    UnitPrice = unitPrice, OpportunityId = oppty.Id, Discount = discount));
            }   
            olisToInsert.addAll(olisForOppty);
            oetd.opptyProdMap.put(oppty.Id, olisForOppty);                          
        }
        insert olisToInsert;
        System.debug('**** Limit: Queries After Oppty Lines Created = '+ String.valueof(Limits.getQueries()));
         System.debug('  First Start debug CPU Time '+Limits.getCpuTime());
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
    
        //
        // Create Standard SFDC Quotes
        //
        List<Quote> sfdcQuotesToInsert = new List<Quote>();         
        if (entityCounts.get('QuotesPerOppty') != null && entityCounts.get('QuotesPerOppty') > 0)
        {
            for (Opportunity oppty : oetd.opportunityList)
            {
                List<Quote> quotesForOppty =  new List<Quote>();
                System.debug('**** Creating Quotes for Opportunity ' + String.valueOf(oppty.Id));
                opptySeqNum = oppty.Name.subStringAfterLast(' ');
                for (Integer i = 0; i < entityCounts.get('QuotesPerOppty'); i++)  //starting from zero to create two sfdc quotes START - EPN
                {
                    System.debug('**** Created Quotes for Opportunity ' + String.valueOf(oppty.Id));                    
                    quotesForOppty.add(new Quote(Name = 'Quote ' + opptySeqNum + String.valueOf(i), OpportunityId = oppty.Id, PriceBook2Id = standardPriceBook.Id, 
                        ExpirationDate = System.today() + 60, Quote_Type__c = 'All-In'));
                }
                oetd.quoteList.addAll(quotesForOppty);
                oetd.quoteMap.put(oppty.Id, quotesForOppty);
                sfdcQuotesToInsert.addAll(quotesForOppty);
            }
            
            insert sfdcQuotesToInsert;
        }
        System.debug('  Quote CPU Time '+Limits.getCpuTime());
        //
        // Create Standard Quotes SFDC Lines
        //
        
        List<QuoteLineItem> sfdcQLIsToInsert = new List<QuoteLineItem>();
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        String quoteSeqNum;
        for (Quote qte : oetd.quoteList)
        {
            List<QuoteLineItem> qlisForQuote = new List<QuoteLineItem>();
            quoteSeqNum = qte.Name.subStringAfterLast(' ');
            oliList = oetd.opptyProdMap.get(qte.OpportunityId);
            OpportunityLineItem oli;
            for(Integer i = 0; i < oliList.size(); i++)
            {
                oli = oliList[i];
                qlisForQuote.add (new QuoteLineItem(QuoteId = qte.Id, Description = 'Quote Line Item ' + quoteSeqNum + String.valueOf(i + 1), 
                    PriceBookEntryId = oetd.prodToPBEMap.get(oli.Product2Id), Quantity = oli.Quantity, OpportunityLineItemId = oli.Id, 
                    Discount = oli.Discount, UnitPrice = oli.UnitPrice, Product2Id = oli.Product2Id));                  
            }
            oetd.quoteLineMap.put(qte.Id,qlisForQuote);
            sfdcQLIsToInsert.addAll(qlisForQuote);
        }               
        insert sfdcQLIsToInsert; 
        System.debug('  Quote Line CPU Time '+Limits.getCpuTime());
        System.debug('   SOQL LIMITS '+Limits.getQueries());
      
        //
        // Create CPQ Quote Objects
        //
       
        List<SBQQ__Quote__c> cpqQuotesToInsert = new List<SBQQ__Quote__c>();
        RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];
        System.debug('  Quote Line CPU Time RecTypeQuery '+Limits.getCpuTime());
        if (entityCounts.get('QuotesPerOppty') != null && entityCounts.get('QuotesPerOppty') > 0)
        {
            for (Opportunity oppty : oetd.opportunityList)
            {
                List<SBQQ__Quote__c> quotesForOppty =  new List<SBQQ__Quote__c>();
                System.debug('**** Creating Quotes for Opportunity ' + String.valueOf(oppty.Id));
                opptySeqNum = oppty.Name.subStringAfterLast(' ');
                for (Integer i = 0; i < entityCounts.get('QuotesPerOppty'); i++)  //starting from zero by EPN - Sajid
                {
                    System.debug('**** Created Quotes for Opportunity ' + String.valueOf(oppty.Id));                    
                    quotesForOppty.add(new SBQQ__Quote__c(RecordTypeId = qrt.Id, SBQQ__Opportunity2__c = oppty.Id, Related_Opportunity__c = oppty.Id, SBQQ__Pricebook__c = standardPriceBook.Id, 
                        SBQQ__ExpirationDate__c = System.today() + 60, Quote_Plan__c = 'All In', Quote_Type__c = 'All In',SBQQ__PrimaryContact__c=contactsToInsert[0].Id));
                }
                oetd.CPQ_quoteList.addAll(quotesForOppty);
                oetd.CPQ_quoteMap.put(oppty.Id, quotesForOppty);
                cpqQuotesToInsert.addAll(quotesForOppty);
            }           
            System.debug('  Quote CPU Time Before cpqQuoteInsert '+Limits.getCpuTime());
            insert cpqQuotesToInsert;
            System.debug('  SBQQ Quote CPU Time '+Limits.getCpuTime());
            System.debug('   SOQL LIMITS '+Limits.getQueries());
            for (SBQQ__Quote__c qte: cpqQuotesToInsert)
            {
                System.debug('**** Inserted Quote: ' + String.valueOf(qte));
            }
        }
        //
        // Create CPQ Quotes Lines
        //
        
        List<SBQQ__QuoteLine__c> cpqQLIsToInsert = new List<SBQQ__QuoteLine__c>();
        for (SBQQ__Quote__c qte : oetd.CPQ_quoteList)
        {
            List<SBQQ__QuoteLine__c> qlisForQuote = new List<SBQQ__QuoteLine__c>();
            oliList = oetd.opptyProdMap.get(qte.SBQQ__Opportunity2__c);
            OpportunityLineItem oli;
            for(Integer i = 0; i < oliList.size(); i++)
            {
                oli = oliList[i];
                qlisForQuote.add (new SBQQ__QuoteLine__c(SBQQ__Quote__c = qte.Id, 
                    SBQQ__Quantity__c = oli.Quantity,
                    SBQQ__Discount__c = oli.Discount, SBQQ__CustomerPrice__c = oli.UnitPrice, SBQQ__Product__c = oli.Product2Id));                  
            }
            oetd.CPQ_quoteLineMap.put(qte.Id,qlisForQuote);
            cpqQLIsToInsert.addAll(qlisForQuote);
        }   
        System.debug('  Quote Line CPU Time Before cpqQLTsInsert '+Limits.getCpuTime());
        insert cpqQLIsToInsert;        
        System.debug('  SBQQ Quote Line CPU Time '+Limits.getCpuTime());
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        
       
        
        
        System.debug('**** Limit: Queries Quotes and Lines Created = '+ String.valueof(Limits.getQueries()));
        System.debug('  CPU Time '+Limits.getCpuTime());
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        return oetd;
    }  //  End of CreateOEData method
    
     public static List<Order_Entry_Release__c> createOEReleases(OETestData oetd, Integer numberOfReleases, String systemOfMeasurement)
    {
        return createOEReleases(oetd, numberOfReleases, systemOfMeasurement, 'CPQ', 'IGU'); 
       
    }
    public static List<Order_Entry_Release__c> createOEReleases(OETestData oetd, Integer numberOfReleases, String systemOfMeasurement, String quoteSource)
    {
        return createOEReleases(oetd, numberOfReleases, systemOfMeasurement, quoteSource, 'IGU'); 
        
    }
    
    //Added by ENP - START - Sajid
    public static List<Order_Entry_Release__c> createOEReleases_CH(OETestData oetd, Integer numberOfReleases, String systemOfMeasurement, String quoteSource)
    {
        return createOEReleases(oetd, numberOfReleases, systemOfMeasurement, quoteSource, Label.CSS_Hardware);
        
    }
    //Added by ENP - END    

    //Added by ENP - START - Sajid
    public static List<Order_Entry_Release__c> createOEReleases_SW(OETestData oetd, Integer numberOfReleases, String systemOfMeasurement, String quoteSource)
    {
        return createOEReleases(oetd, numberOfReleases, systemOfMeasurement, quoteSource, Label.CSS_Software); 
    }
    //Added by ENP - END      
    
    public static List<Order_Entry_Release__c> createOEReleases(OETestData oetd, Integer numberOfReleases, String systemOfMeasurement, String quoteSource, String recordTypeDevName) 
    {
        List<Order_Entry_Release__c> oersToInsert = new List<Order_Entry_Release__c>();
        Account billToAccount;
        Account shipToAccount;
        Account soldToAccount;
        Contact billingContact;
        Contact shippingContact;
        Contact soldToContact;
        Opportunity oppty;
        Id opptyId;
        Customer_Purchase_Order__c cpo;
        QuoteWrapper qw;
        Quote SFDCQte = null;
        Order_Entry_Release__c newOER;
        for (Id qmKey : oetd.quoteMap.keySet())
        {
            System.debug('**** quoteMap Opportunity Id = ' + qmKey );
            for (SBQQ__Quote__c qml : oetd.CPQ_QuoteMap.get(qmKey))
            {
                System.debug('    **Quote for Opportuntiy Id ' + qmkey + ': ' + String.valueOf(qml));
            }
        }           
    
        for (Integer i = 1; i <= numberOfReleases; i++)
        {
            soldToAccount = oetd.soldToAcctList[XMath.getRandomInt(oetd.soldToAcctList.size())];
            billToAccount = oetd.billToAcctList[XMath.getRandomInt(oetd.billToAcctList.size())];
            shipToAccount = oetd.shipToAcctList[XMath.getRandomInt(oetd.shipToAcctList.size())];
            soldToContact = oetd.contactMap.get(soldToAccount.id)[XMath.getRandomInt(oetd.contactMap.get(soldToAccount.id).size())];
            shippingContact = oetd.contactMap.get(shipToAccount.id)[XMath.getRandomInt(oetd.contactMap.get(shipToAccount.id).size())];
            billingContact = oetd.contactMap.get(billToAccount.id)[XMath.getRandomInt(oetd.contactMap.get(billToAccount.id).size())];
            oppty = oetd.opportunityList[XMath.getRandomInt(oetd.opportunityList.size())];
            opptyId = oppty.Id;  
            
            if (quoteSource == 'CPQ')
            {
                qw = new QuoteWrapper(oetd.CPQ_quoteMap.get(opptyId)[XMath.getRandomInt(oetd.CPQ_quoteMap.get(opptyId).size())]);
            }
            else 
            {
                qw = new QuoteWrapper(oetd.quoteMap.get(opptyId)[XMath.getRandomInt(oetd.quoteMap.get(opptyId).size())]);
            }
  				System.debug('**** Limit: Insert OERS '+Limits.getQueries());
            	System.debug('   CPU Time '+Limits.getCpuTime());
            	System.debug('   SOQL LIMITS '+Limits.getQueries());
            
            cpo = oetd.custPOMap.get(opptyId)[XMath.getRandomInt(oetd.custPOMap.get(opptyId).size())];
            // JV 20171106 hyphen substituted for space in Name
            // JV 20180213 Added Promised Date, Scheduled Ship Date
            // JV 20180607 Added Payment Terms  Shipping Container, Freight
            System.debug('===============================******->'+oetd.oerRecordTypeMap.get(recordTypeDevName)+',Id:'+oetd.oerRecordTypeMap.get(recordTypeDevName).Id);
            newOER = new Order_Entry_Release__c(Name = 'Order Entry Test Release-' + String.valueOf(i), Opportunity__c = opptyId, Order_Entry_Release_Date__c = System.today(),Order_Type__c = 'Standard',
                Request_Date__c = System.today() + 90, Sold_to_Account__c = soldToAccount.Id, Sold_To_Street_1__c = soldToAccount.BillingStreet, Sold_to_City__c = soldToAccount.BillingCity,
                Sold_To_Postal_Code__c = soldToAccount.BillingPostalCode, Sold_To_State_Province__c = soldToAccount.BillingState, Sold_to_Country__c = soldToAccount.BillingCountry, 
                Shipping_Account__c = shipToAccount.Id, Shipping_Street_1__c = shipToAccount.ShippingStreet, Shipping_City__c = shipToAccount.ShippingCity, Shipping_Name__c = shipToAccount.name,
                Shipping_Postal_Code__c = shipToAccount.ShippingPostalCode, Shipping_State_Province__c = shipToAccount.ShippingState, Shipping_Country__c = shipToAccount.ShippingCountry,
                Billing_Account__c = billToAccount.Id, Billing_Street_1__c = billToAccount.BillingStreet, Billing_City__c = billToAccount.BillingCity, Shipping_Container__c = 'Wood Crate',
                Billing_Postal_Code__c = billToAccount.BillingPostalCode, Billing_State_Province__c = billToAccount.BillingState, Billing_Country__c = billToAccount.BillingCountry, 
                System_of_Measurement__c = systemOfMeasurement, Status__c = oetd.initOERStatus, Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', Freight__c = 'Billable',
                Release_Name__c = 'Order Entry Release Name ' + String.valueOf(i), Billing_Contact__c = billingContact.Id, Sold_To_Contact__c = soldToContact.Id, Payment_Terms__c = '30 NET',
                Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255, Shipping_Contact__c = shippingContact.Id, RecordTypeId = oetd.oerRecordTypeMap.get(recordTypeDevName).Id);
            
            if(associateOELsToQLs) {
                if (quoteSource == 'CPQ')
                {
                    newOER.CPQ_Quote__c = qw.quoteId;
                }
                else
                {
                    newOER.Quote__c = qw.quoteId;
                } 
            }
            oersToInsert.add(newOER);
        }
        for (Order_Entry_Release__c oer: oersToInsert)
        {
            System.debug('**** OER to Insert: ' + String.valueOf(oer)); 
        }
        
			System.debug('**** Limit: Insert OERS '+Limits.getQueries());
        	System.debug('   SOQL LIMITS '+Limits.getQueries());
        insert oersToInsert;
        	System.debug('   SOQL LIMITS '+Limits.getQueries());
        	System.debug('   CPU Time '+Limits.getCpuTime());
        
        for (Order_Entry_Release__c oer: oersToInsert)
        {
            oetd.oerList.add(oer);
        }
        System.debug('   SOQL LIMITS '+Limits.getQueries());
        System.debug('   CPU Time '+Limits.getCpuTime());
        return oersToInsert;
        
    } 
    
    public static List<Order_Entry_Release__c> createReleasesForQuote(OETestData oetd, Id quoteId, Integer numberOfReleases)
    {
        List<Order_Entry_Release__c> oersToInsert = new List<Order_Entry_Release__c>();
        return oersToInsert;
    } 
    
    
    
    
    public static Map<Id,List<Order_Entry_Line__c>> createOELines(OETestData oetd, List<Order_Entry_Release__c> oerList, Integer linesPerQuoteLine)
    {
        return createOELines(oetd, oerList, linesPerQuoteLine, 'IGU_Imperial'); 
    }
    
    public static Map<Id,List<Order_Entry_Line__c>> createOELines(OETestData oetd, List<Order_Entry_Release__c> oerList, Integer linesPerQuoteLine, String recordTypeDevName)
    {
        
        Map<String,Map<String, String>> dimensionsForShapeImp = new Map<String,Map<String, String>> 
            {'Rectangle' => new Map<String, String> {'Base' =>'65', 'Height' =>'88 3/16'},
             'Triangle - 45' => new Map<String, String> {'Base' =>'32 1/8', 'Height' =>'40 11/16'},
             'Triangle - 46' => new Map<String, String> {'Base' =>'65 1/2', 'Height' =>'48 13/16'},
             'Trapezoid - 1' => new Map<String, String> {'Base' =>'65 3/8', 'Height' =>'48 13/16', 'BaseHeight1' => '40 1/4'},
             'Trapezoid - 2' => new Map<String, String> {'Base' =>'73 3/16', 'Height' =>'66 5/16', 'BaseHeight1' => '64 3/4'},
             'Trapezoid - 301' => new Map<String, String> {'Base' =>'56 5/8', 'Height' =>'66 5/16', 'BaseHeight1' => '55 7/8'},
            'Trapezoid - 302' => new Map<String, String> {'Base' =>'36 15/16', 'Height' =>'48', 'BaseHeight1' => '33 1/16'}};
        List<String> shapeList = new List<String> {'Rectangle', 'Triangle - 45', 'Triangle - 46', 'Trapezoid - 1', 'Trapezoid - 2', 'Trapezoid - 301', 'Trapezoid - 302'};

        List<Order_Entry_Line__c> oelsToInsert = new List<Order_Entry_Line__c>();
        Map<Id, List<Order_Entry_Line__c>> retOELMap = new Map<Id, List<Order_Entry_Line__c>>();
        List<SBQQ__QuoteLine__c> qliList;
        Order_Entry_Line__c newOEL;
        
        if(true)
        {
            Integer oelQuantity;
            String oelShape;
            String oelBase;
            String oelHeight;
            String oelBaseHeight;
            for (Order_Entry_Release__c oer : oerList)
            {
                List<Order_Entry_Line__c> oelsForOER = new List<Order_Entry_Line__c>(); 
                List<QuoteLineWrapper> qlwList = new List<QuoteLineWrapper>();
                if (oer.CPQ_Quote__c != null)
                {
                    for (SBQQ__QuoteLine__c qli : oetd.CPQ_quoteLineMap.get(oer.CPQ_Quote__c))
                    {
                        qlwList.add(new QuoteLineWrapper(qli));
                    }
                }
                else
                {
                    for (QuoteLineItem qli : oetd.quoteLineMap.get(oer.Quote__c))
                    {
                        qlwList.add(new QuoteLineWrapper(qli));
                    }
                }
                    
                for(QuoteLineWrapper qlw : qlwList)
                {
                    
                    for (Integer i = 1; i <= linesPerQuoteLine; i++)
                    {
                        oelShape = shapeList[XMath.getRandomInt(shapeList.size())];
                        oelBase = dimensionsForShapeImp.get(oelShape).get('Base');
                        oelHeight = dimensionsForShapeImp.get(oelShape).get('Height');
                        if (oelShape.contains('Trapezoid'))
                        {
                            oelBaseHeight = dimensionsForShapeImp.get(oelShape).get('BaseHeight1');
                        }
                        else
                        {
                            oelBaseHeight = '';
                        }
                        oelQuantity = XMath.getRandomInt(20);
                        if (oelQuantity == 0) oelQuantity = 1;
                        
                        //Added by ENP - Start   Modifying recordtype map to get recordtypeid as per recordtypeDevName in parameter passed IGU_Imperial
                        // JV - 20180213 Added Promised Date
                        newOEL = (new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase, Height_In__c = oelHeight,
                            Base_Height_1_In__c = oelBaseHeight, Shape__c = oelShape, RecordTypeId = oetd.oelRecordTypeMap.get(recordTypeDevName).Id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', Product__c = qlw.productId, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = oer.Shipping_Name__c, Shipping_Street_1__c = oer.Shipping_Street_1__c, 
                            Shipping_Account__c = oer.Shipping_Account__c, Shipping_City__c = oer.Shipping_City__c, Shipping_Postal_Code__c = oer.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = oer.Shipping_State_Province__c, Shipping_Country__c = oer.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = i, Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 90));
                        //if(associateOELsToQLs) {
                            if (oer.CPQ_Quote__c != null)
                            {                 
                                newOEL.CPQ_Quote_Line__c = qlw.quoteLineId;
                            }
                            else
                            {
                                newOEL.Quote_Line_Item__c = qlw.quoteLineId;
                            }
                        //}                            
                        oelsForOER.add(newOEL);                 
                    }
                    
                }
                oelsToInsert.addAll(oelsForOER);
            }
            insert oelsToInsert;
            for (Order_Entry_Line__c oel :oelsToInsert)
            {
                if (!oetd.oelMap.containsKey(oel.Order_Entry_Release__c))
                {
                    oetd.oelMap.put(oel.Order_Entry_Release__c , new List<Order_Entry_Line__c>());
                }
                oetd.oelMap.get(oel.Order_Entry_Release__c).add(oel);
                
                if (!retOELMap.containsKey(oel.Order_Entry_Release__c))
                {
                    retOELMap.put(oel.Order_Entry_Release__c , new List<Order_Entry_Line__c>());
                }
                retOELMap.get(oel.Order_Entry_Release__c).add(oel);
            }

        }
        else
        {
            // Code for metric
        }
       
		 System.debug('   SOQL LIMITS '+Limits.getQueries());
         System.debug('   CPU Time '+Limits.getCpuTime());
        return (retOELMap);
    }   
    
    public static void progressStatusTo(Set<Id> oerIdSet, String toStatus, OETestData oetd)
    {
        Map<String, Integer>  statusNumber = new Map<String, Integer> {'Draft' => 1, 'Pre-Release Review' => 2, 'Confirmation Pending' => 3, 'Confirmation Requested' => 4, 'Confirmed' => 5,
        'Integration Requested' => 6, 'Pre-Production' => 7, 'In Production' => 8, 'Partially Shipped' => 9, 'Shipped' => 10};
        Integer toStatusNum = statusNumber.get(toStatus);
        Map <Id, Order_Entry_Line__c> oelsToUpdate = new Map<Id, Order_Entry_Line__c>();        // Global list of OEL to update
        Map <Id, Order_Entry_Release__c> oersToUpdate = new Map<Id, Order_Entry_Release__c>();  // Global list of OER to update
        List<Order_Entry_Line__c> localOELList = new List<Order_Entry_Line__c>();
        
        Set<Id> updatedOERIds = new Set<Id>();
        Set<Id> updatedOELIds = new Set<Id>();
        System.Debug('toStatus = ' + String.valueOf(toStatus));
        for (Order_Entry_Release__c oer : oetd.oerList)
        {
            if (oerIdSet.contains(oer.Id) && statusNumber.get(oer.Status__c) < toStatusNum)
            {
                System.Debug ('**** At Entry OER Id = ' + String.valueOf(oer.Id) + '; Status = ' + oer.Status__c);
                oersToUpdate.put(oer.Id, oer);
                for (Order_Entry_Line__c oel : oetd.oelMap.get(oer.Id))
                {                   
                    oelsToUpdate.put(oel.Id, oel);
                }
            }
        }       
                                
        for (Integer statusNum = 2; statusNum <= toStatusNum;  statusNum++)
        {   
            updatedOERIds.clear();
            updatedOELIds.clear();
            
            //
            // Set status to 'Pre-Release Review'   
            //

            if (statusNum == 2)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 1)
                    {
                        System.debug('in Pre-Release Review');
                        oer.Trigger_Source__c = 'UI';
                        oer.Status__c = 'Pre-Release Review';
                        updatedOERIds.add(oer.Id);
                    }
                }
                update oersToUpdate.values();
                // JV 20180213 Added Promised Date, Scheduled Ship Date
                for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c, Shipping_Contact__c    
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                }
               System.debug('   SOQL LIMITS '+Limits.getQueries());
        	   System.debug('   CPU Time '+Limits.getCpuTime());
                
                
            } // End of "Pre-Release Review" processing
            

            //
            // Set status to "Confirmation Pending" 
            //
            if (statusNum == 3)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 2)
                    {
                        System.debug('Confirmation Pending');
                        oer.Trigger_Source__c = 'UI';
                        oer.Status__c = 'Confirmation Pending';
                        updatedOERIds.add(oer.Id);
                    }
                }
                update oersToUpdate.values();
                // JV 20180213 Added Promised Date, Scheduled Ship Date
               for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c 
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
            
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                }
               System.debug('   SOQL LIMITS '+Limits.getQueries());
        	   System.debug('   CPU Time '+Limits.getCpuTime());	
                
                
            } // End of "Confirmation Pending" processing
            
            //
            // Set status to 'Confirmation Requested'   
            //
            if (statusNum == 4)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 3)
                    {
                        System.debug('Confirmation Requested');
                        oer.Trigger_Source__c = 'UI';
                        oer.Status__c = 'Confirmation Requested';
                        updatedOERIds.add(oer.Id);
                    }
                }
                update oersToUpdate.values();
                // JV 20180213 Added Promised Date, Scheduled Ship Date
                for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c,Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c 
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
            
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                }
                
               System.debug('   SOQL LIMITS '+Limits.getQueries());
        System.debug('   CPU Time '+Limits.getCpuTime());
                
            } // End of "Confirmation Requested" processing
            
            //
            // Set status to "Confirmed"
            //
            if (statusNum == 5)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 4)
                    {
                        oer.Trigger_Source__c = 'UI';
                        oer.Status__c = 'Confirmed';
                        updatedOERIds.add(oer.Id);
                    }
                }
                update oersToUpdate.values();
                // JV 20180213 Added Promised Date, Scheduled Ship Date
                for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c 
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
            
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                }
                System.debug('   SOQL LIMITS '+Limits.getQueries());
        System.debug('   CPU Time '+Limits.getCpuTime());
                
                
            } // End of "Confimed" processing
            
            //
            // Set status to "Integration Requested";   
            //
            if (statusNum == 6)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 5)
                    {
                        oer.Trigger_Source__c = 'UI';
                        oer.Status__c = 'Integration Requested';
                        updatedOERIds.add(oer.Id);
                    }
                }
                update oersToUpdate.values();

                // JV 20180213 Added Promised Date, Scheduled Ship Date
                for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c     
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
            
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                }
                
               System.debug('   SOQL LIMITS '+Limits.getQueries());
        	   System.debug('   CPU Time '+Limits.getCpuTime());
                
            } // End of "Integration Requested" processing
            
            //
            // Set status to "Pre-Production"   
            //
            if (statusNum == 7)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 6)
                    {
                        oer.Integration_Status__c = 'Complete';
                        oer.Trigger_Source__c = 'Integration';
                        updatedOERIds.add(oer.Id);
                    }
                }
                update oersToUpdate.values();

                localOELList.clear();
                for (Id oerID : updatedOERIds)
                {
                    for (Order_Entry_Line__c oel : oelsToUpdate.values())
                    {
                        if (oel.Order_Entry_Release__c == oerId)
                        {
                            oel.Integration_Status__c = 'Complete';
                            oel.Trigger_Source__c = 'Integration';
                            localOELList.add(oel);
                        }
                    }
                }
                update localOELList;    
                // JV 20180213 Added Promised Date, Scheduled Ship Date
                
                for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c 
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
            
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                }
                System.debug('   SOQL LIMITS '+Limits.getQueries());
        		System.debug('   CPU Time '+Limits.getCpuTime());
                
                
            } // End of "Pre-Production" processing
            
            //
            // Set status to "In Production"    
            //
            if (statusNum == 8)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 7)
                    {
                        updatedOERIds.add(oer.Id);
                    }
                }
                
                localOELList.clear();
                for (Order_Entry_Line__c oel : oelsToupdate.values())
                {
                    if (updatedOERIds.contains(oel.Order_Entry_Release__c))
                    {
                        oel.Work_Order_Status__c = 'Released';
                        oel.Trigger_Source__c = 'Integration';
                        localOELList.add(oel);
                    }
                }

                update localOELList;    
                
                // JV 20180213 Added Promised Date, Scheduled Ship Date
                for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c 
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
            
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                }
                System.debug('   SOQL LIMITS '+Limits.getQueries());
        System.debug('   CPU Time '+Limits.getCpuTime());
                
                
            } // End of "In Production" processing
            
            //
                
            //
            // Set status to "Partially Shipped"    
            //
            if (statusNum == 9)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 8)
                    {
                        updatedOERIds.add(oer.Id);
                    }
                }
                
                localOELList.clear();
                for (Order_Entry_Line__c oel : oelsToUpdate.values())
                {
                    if (updatedOERIds.contains(oel.Order_Entry_Release__c))
                    {
                        if (oel.Quantity__c > 1)
                        {
                            oel.Quantity_Shipped__c = oel.Quantity__c - 1;
                        }
                        else
                        {
                            oel.Quantity_Shipped__c = 1;
                        }
                        localOELList.add(oel);  
                    }               
                }
                update localOELList;    
                
             // JV 20180213 Added Promised Date, Scheduled Ship Date
               for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c 
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
            
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                }
                System.debug('   SOQL LIMITS '+Limits.getQueries());
        	    System.debug('   CPU Time '+Limits.getCpuTime());
                                
            } // End of "Partially Shipped" processing
            
            //
            // Set status to "Shipped"  
            //
            if (statusNum == 10)
            {
                for(Order_Entry_Release__c oer : oersToUpdate.values())
                {
                    if(statusNumber.get(oer.Status__c) == 9)
                    {
                        updatedOERIds.add(oer.Id);
                    }
                }
                
                localOELList.clear();
                for (Order_Entry_Line__c oel : oelsToUpdate.values())
                {
                    if (updatedOERIds.contains(oel.Order_Entry_Release__c))
                    {
                        oel.Quantity_Shipped__c = oel.Quantity__c;
                        oel.Trigger_Source__c = 'Integration';
                        localOELList.add(oel);
                    }
                }
                update localOELList;    
               /* 
                // JV 20180213 Added Promised Date, Scheduled Ship Date
                for (Order_Entry_Release__c oerUpd : [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,                   
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c 
                    FROM Order_Entry_Release__c WHERE Id IN :updatedOERIds])
                {
                    oersToUpdate.put(oerUpd.Id, oerUpd);
                }           
            
                // JV - 20180213 Added Request Date, Scheduled Ship Date, Promised Date to fields retrieved
                for (Order_Entry_Line__c oelUpd : [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c,
                    Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :updatedOERIds])
                {
                    oelsToUpdate.put(oelUpd.id, oelUpd);
                } 
*/
                System.debug('   SOQL LIMITS '+Limits.getQueries());
        		System.debug('   CPU Time '+Limits.getCpuTime());
                                
            } // End of "Shipped" processing
            System.Debug('*** After Iteration for Status Number ' + String.valueOF(statusNum) + ' OERs Status:');
            oetd.oerList = oersToUpdate.values();
            for (Order_Entry_Release__c oer : oersToUpdate.values())
            {
                List<Order_Entry_Line__c> oelsForOER = new List<Order_Entry_Line__c>();
                for (Order_Entry_Line__c oel : oelsToUpdate.values())
                {
                    if (oel.Order_Entry_Release__c == oer.Id)
                    {
                        
                        oelsforOER.add(oel);
                    }
                }
                oetd.oelMap.put(oer.ID, oelsForOER);
            }
            for (Order_Entry_Release__c oer : oetd.oerList)
            {
                if (updatedOERIds.contains(oer.Id))
                {
                    System.Debug('*** For oer ID ' + String.valueOf(oer.ID) + ' Status = ' + oer.Status__c);
                    
                    for (Order_Entry_Line__c oel : oetd.oelMap.get(oer.id))
                    {
                        System.Debug('    *** For oel ID ' + String.valueOf(oel.ID) + ' Status = ' + oel.Status__c);
                    }
                }
            }
            
                

        } // End of For Each Status Loop
        return;
    } 
    
}