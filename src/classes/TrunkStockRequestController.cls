public without sharing class TrunkStockRequestController {
    
    private static final Integer SEARCH_RESULTS_LIMIT = 100;    
    @AuraEnabled 
    public static List<NewFSEProducts> getProducts()
    {
        List<Trunk_New_FSE_Products__c> productSkuForNewTrunk = Trunk_New_FSE_Products__c.getall().values();
        Map<String,Decimal> prodMapTrunk = new Map<String,Decimal>();
        for(Trunk_New_FSE_Products__c pr : productSkuForNewTrunk)
        {
            prodMapTrunk.put(pr.Product_SKU__c, pr.Quantity__c); 
        }
        
        List<NewFSEProducts> newProdWrapper = new List<NewFSEProducts>();
        List<String> prodCode = new List<String>{'380-101509-04','380-101509-05','380-101509-11'};
            List<Product2> retProd = [Select id,Name,Product_SKU__c,Family,ProductCode,CurrencyIsoCode from Product2 where ProductCode IN: prodMapTrunk.keySet()];
        for(Product2 pr : retProd)
        {
            NewFSEProducts newProdWrapper1 = new NewFSEProducts();
            newProdWrapper1.prName = pr.Name;
            newProdWrapper1.prSku = pr.Product_SKU__c;
            newProdWrapper1.prfamily = pr.Family;
            newProdWrapper1.prCode = pr.ProductCode;
            newProdWrapper1.prCurrency = pr.CurrencyIsoCode;
            newProdWrapper1.prQuantity = prodMapTrunk.get(pr.Product_SKU__c);
            newProdWrapper.add(newProdWrapper1);
            
        }
        System.debug('Products New FSE '+ retProd);
        return newProdWrapper;
    }
    
    public class NewFSEProducts 
    {
        @AuraEnabled public string prName {get;set;}
        @AuraEnabled public string prSku {get;set;}
        @AuraEnabled public string prfamily {get;set;}
        @AuraEnabled public string prCode {get;set;}
        @AuraEnabled public string prCurrency {get;set;}
        @AuraEnabled public decimal prQuantity {get;set;}
        
        
    }
    
    @AuraEnabled
    public static ServiceResource getServiceRecource(String srId)
    {
        ServiceResource srList = new ServiceResource ();
        srList = [Select id,LocationId,Location.Name, ResourceType,IsActive,Shipping_Street_1__c,Shipping_Street_2__c,Shipping_City__c,Shipping_State_Province__c,Shipping_Country__c,
                  	Shipping_Postal_Code__c,Shipping_Contact_Name__c,Shipping_Contact_Number__c from ServiceResource where IsActive = True AND ID =:srId];
       		
        	
        if(srList != null)
            return srList;
        else 
            return null;
    }
    
    @AuraEnabled
    public static boolean getServiceRecourceSelfOrOther(String srId)
    {
        system.debug('self or other '+ srId);
        boolean selfOrOther;
        ServiceResource srList = new ServiceResource ();
        srList = [Select id,LocationId, Location.Name, ResourceType,IsActive,RelatedRecordId from ServiceResource where IsActive = True AND ID =:srId];
        Id currUserId = UserInfo.getUserId();
       	
        if(currUserId == srList.RelatedRecordId)
            selfOrOther = True;
        else 
            selfOrOther = False;
        
        return selfOrOther;
    }
    
    @AuraEnabled
    public static void createNewFseParts(String srId, String trunkId,String reqDate,String street,String city, String state, String postcode, 
                                         String country, String shippingConName, String shippingConPhone)
    {
        List<Trunk_New_FSE_Products__c> productSkuForNewTrunk = Trunk_New_FSE_Products__c.getall().values();
        Map<String,Decimal> prodMapTrunk = new Map<String,Decimal>();
        for(Trunk_New_FSE_Products__c pr : productSkuForNewTrunk)
        {
            prodMapTrunk.put(pr.Product_SKU__c, pr.Quantity__c); 
        }
        
        system.debug('SR ID '+srId);
        ServiceResource serRes = new ServiceResource();
        serRes = [select id,LocationId,Location.Name,isactive,ResourceType,RelatedRecordId from ServiceResource where id =:srId AND isActive = True];
        
        
        if(trunkId == '' || trunkId == null)
        {
            trunkId = serRes.LocationId;
        }
        
        List<Product2> prodForNewFSE = new List<Product2>();
        prodForNewFSE = [Select id,Name,Product_SKU__c,Family,ProductCode,CurrencyIsoCode from Product2 where ProductCode IN: prodMapTrunk.keySet() AND IsActive = True];
        Opportunity opp = [Select id,Opportunity_ID__c,Name from Opportunity where id='0060h00001AgjZmAAJ'];
        Account acc = [Select id from Account where id='0010h00001dIfq0AAC'];
        System.debug('New FSE Prod '+prodForNewFSE);
        
        // Insert Product Request
        ProductRequest prnew = new ProductRequest();
        prnew.OwnerId= serRes.RelatedRecordId;
        prnew.DestinationLocationId = trunkId;
        //prnew.Status = 'Draft';
        prnew.ShipmentType = 'Rush';
        prnew.NeedByDate = date.valueOf(reqDate);
        prnew.ShipToStreet = street;
        prnew.ShipToCity = city;
        prnew.ShipToState = state;
        prnew.ShipToCountry = country;
        prnew.ShipToPostalCode = postcode;
        prnew.Service_Resource__c = serRes.id;
        prnew.Status='Order Processing';
        prnew.Type__c='Control Hardware';
        
        INSERT prnew;
        
        ProductRequest getPrNum = [Select id,ProductRequestNumber FROM ProductRequest WHERE Id=:prnew.Id];
        
        // Insert Product Request Line Item
        List<ProductRequestLineItem> prLineInsert = new List<ProductRequestLineItem>();
        List<ProductTransfer> ptLineInsert = new List<ProductTransfer>();
        
        for(Product2 prIn : prodForNewFSE)
        {
            ProductRequestLineItem prli = new ProductRequestLineItem();
            prli.ParentId = prnew.Id;
            prli.Status ='Submitted';
            prli.Product2Id = prIn.Id; 
            prli.QuantityRequested = prodMapTrunk.get(prIn.Product_SKU__c);
            prli.NeedByDate = date.valueOf(reqDate);
            prli.DestinationLocationId = trunkId;
            prli.ShipToStreet = street;
            prli.ShipToCity = city;
            prli.ShipToState = state;
            prli.ShipToCountry = country;
            prli.ShipToPostalCode = postcode;
            prli.ShipmentType = 'Rush';
            //prli.QuantityUnitOfMeasure = 'Each';
            prLineInsert.add(prli);
        }
        
        INSERT prLineInsert;
        
        Map<Id,ProductRequestLineItem> mapProReqLineItemOel = new Map<Id,ProductRequestLineItem>();
        List<ProductRequestLineItem> insertedPrli = new List<ProductRequestLineItem>();
        insertedPrli = [Select id,ParentId,Parent.ProductRequestNumber,ProductRequestLineItemNumber,Product2Id,Product2.Product_SKU__c 
                        from ProductRequestLineItem WHERE ParentId =:prnew.Id];
        for(ProductRequestLineItem prl : insertedPrli)
        {
            mapProReqLineItemOel.put(prl.Product2Id,prl);
        }
        
        // Insert Product Transfers
        for(ProductRequestLineItem plTrn : prLineInsert)
        {
            System.debug(' Product SKU '+plTrn.Product2.Product_SKU__c);
            ProductTransfer prt = new ProductTransfer();
            prt.ProductRequestLineItemId = plTrn.Id;
            prt.Product2Id = plTrn.Product2Id;
            prt.QuantitySent = plTrn.QuantityRequested;
            prt.QuantityReceived = NULL;
            prt.QuantityUnitOfMeasure = '';
            prt.DestinationLocationId = trunkId;
            prt.ReceivedById = serRes.RelatedRecordId;
            ptLineInsert.add(prt);
        }
        
        INSERT ptLineInsert; 
        
        
        // Insert Order Entry Release
        Integer counter = 0;
        Order_Entry_Release__c newOerPartReq = new Order_Entry_Release__c();
        newOerPartReq.Opportunity__c = opp.Id;
        newOerPartReq.Order_Type__c ='View Internal';
        
        if(shippingConName != null && shippingConName != '')
        	newOerPartReq.Shipping_Contact_Name__c = shippingConName;
        if(shippingConPhone != null && shippingConPhone != '')
        	newOerPartReq.Shipping_Contact_Number__c = shippingConPhone;
        //newOerPartReq.Project_ID__c = opp.Opportunity_ID__c;
        newOerPartReq.Freight__c = 'Non-Billable';
        newOerPartReq.Shipping_Account__c = acc.Id;
        newOerPartReq.Billing_Account__c = acc.Id;
        newOerPartReq.Sold_to_Account__c = acc.Id;
        newOerPartReq.RecordTypeId = '0120h000000QiWlAAK';
        newOerPartReq.Release_Name__c = serRes.Location.Name+ ' - '+'Onboarding';   //Parts Request for '+opp.Name;
        newOerPartReq.Request_Date__c = date.valueOf(reqDate);
        newOerPartReq.Requestor__c = serRes.RelatedRecordId;//UserInfo.getUserId();
        newOerPartReq.Auto_Book_Order__c = True;
        newOerPartReq.Shipping_Street_1__c = street;
        newOerPartReq.Shipping_City__c = city;
        newOerPartReq.Shipping_State_Province__c = state;
        newOerPartReq.Shipping_Country__c = country;
        newOerPartReq.Shipping_Postal_Code__c = postcode;
        newOerPartReq.Sales_Executive__c = '0050L000008ZJKcQAO';
        newOerPartReq.Project_Manager__c = '0050L000008ZJKcQAO';
        newOerPartReq.Shipping_Name__c = 'View Control HW Spare Parts Inventory';
        newOerPartReq.Deliver_To_Street_1__c = street;
        newOerPartReq.Deliver_To_City__c = city;
        newOerPartReq.Deliver_To_State_Province__c = state;
        newOerPartReq.Deliver_To_Country__c = country;
        newOerPartReq.Deliver_To_Postal_Code__c = postcode;
        newOerPartReq.Deliver_To_Account__c = acc.id;
        newOerPartReq.Deliver_To_Name__c ='View Control HW Spare Parts Inventory';
       //Integer oppNumber = Integer.valueOf(opp.Opportunity_ID__c);
        newOerPartReq.Name = formatName(opp.Id,counter);
        
        
        if(Date.today().daysBetween(newOerPartReq.Request_Date__c) > 5) {
            newOerPartReq.Scheduled_Ship_Date__c = newOerPartReq.Request_Date__c.addDays(-5);
        } else {
            newOerPartReq.Scheduled_Ship_Date__c = Date.today();
        }
        newOerPartReq.Promised_Date__c = newOerPartReq.Request_Date__c;
        
        INSERT newOerPartReq;
        system.debug('OER Insert '+newOerPartReq);
        
        
        // Insert Order Entry Lines
        List<Order_Entry_Line__c> oelInsert = new List<Order_Entry_Line__c>();
        for(Product2 prIn : prodForNewFSE)
        {
            String uniqueProductRequestLineItemForOel;
            System.debug('Prod *** '+prIn);
            Order_Entry_Line__c oel = new Order_Entry_Line__c();
            oel.Product__c = prIn.Id;
            oel.Quantity__c = prodMapTrunk.get(prIn.Product_SKU__c);
            //oel.Deliver_To_Account__c = acc.Id;
            oel.RecordTypeId = '0120h000000QiWjAAK';
            oel.Reference_ID__c = newOerPartReq.Name;
            oel.SKU__c = prIn.Product_SKU__c; 
            oel.Order_Entry_Release__c = newOerPartReq.Id;
            oel.Reference_ID__c = getPrNum.ProductRequestNumber;
            oel.Customer_Reference_Description__c = 'Parts Request - '+ getPrNum.ProductRequestNumber; // need to query on the Product Request Number to populate
            oel.Request_Date__c = date.valueOf(reqDate);
            oel.Shipping_Account__c = acc.Id;
            oel.Shipping_Street_1__c = street;
            oel.Shipping_City__c = city;
            oel.Shipping_State_Province__c = state;
            oel.Shipping_Country__c = country;
            oel.Shipping_Postal_Code__c = postcode;
            oel.Shipping_Name__c = 'View Control HW Spare Parts Inventory';
            oel.Deliver_To_Account__c = acc.Id;
            oel.Deliver_To_Name__c = 'View Control HW Spare Parts Inventory';
            oel.Deliver_To_Street_1__c = street;                                
            oel.Deliver_To_City__c = city;
            oel.Deliver_To_State_Province__c = state;
            oel.Deliver_To_Country__c = country;
            oel.Deliver_To_Postal_Code__c = postcode;
            if(mapProReqLineItemOel.containsKey(prIn.Id))
            {
                oel.Trunk_Product_Request_Line_Item__c = mapProReqLineItemOel.get(prIn.Id).id;  
            }
            
            
            if(Date.today().daysBetween(oel.Request_Date__c) > 5) {
                oel.Scheduled_Ship_Date__c = oel.Request_Date__c.addDays(-5);
            } else {
                oel.Scheduled_Ship_Date__c = Date.today();
            }
            oel.Promised_Date__c = oel.Request_Date__c;
            
            oelInsert.add(oel);
        }
        
        INSERT oelInsert;
        
        ProductRequest ptOer = new ProductRequest();
        ptOer = [Select id,Order_Entry_Release__c From ProductRequest WHERE Id =:prnew.Id ];
        ptOer.Order_Entry_Release__c = newOerPartReq.Id;
        UPDATE ptOer;
    }
    
    @AuraEnabled
    public static void createPreEmptiveParts(String srId, String trunkId,String reqDate,String street,String city, String state, 
                                             String postcode, String country, List<ProductRequest> preEmpSelected, String shippingConName, String shippingConPhone)
    {
        System.debug('Selected Pre Emp list '+preEmpSelected);
        Map<Id,ProductRequest> preStockReq = new Map<Id,ProductRequest>();
        
        for(ProductRequest pr : preEmpSelected)
        {
            //System.debug('Product ID '+pr.Product__c + ' Quantity '+pr.Quantity__c+' Desc '+pr.Description);
            preStockReq.put(pr.Product__c,pr);
            
        }
        
        system.debug('SR ID '+srId);
       
        ServiceResource serRes = new ServiceResource();
        serRes = [select id,LocationId,Location.Name,isactive,ResourceType,RelatedRecordId from ServiceResource where id =:srId AND isActive = True];
        
        
        if(trunkId == '' || trunkId == null)
        {
            trunkId = serRes.LocationId;
        }
        
        List<Product2> prodForNewFSE = new List<Product2>();
        prodForNewFSE = [Select id,Name,Product_SKU__c,Family,ProductCode,CurrencyIsoCode from Product2 where ID IN: preStockReq.keySet()];
        Opportunity opp = [Select id,Opportunity_ID__c,Name from Opportunity where id='0060h00001AgjZmAAJ'];
        Account acc = [Select id from Account where id='0010h00001dIfq0AAC'];
        System.debug('New FSE Prod '+prodForNewFSE);
        
        // Insert Product Request
        ProductRequest prnew = new ProductRequest();
        prnew.OwnerId= serRes.RelatedRecordId;
        prnew.DestinationLocationId = trunkId;
       // prnew.Status = 'Draft';
        prnew.ShipmentType = 'Rush';
        prnew.NeedByDate = date.valueOf(reqDate);
        prnew.ShipToStreet = street;
        prnew.ShipToCity = city;
        prnew.ShipToState = state;
        prnew.ShipToCountry = country;
        prnew.ShipToPostalCode = postcode;
        prnew.Service_Resource__c = serRes.id;
        prnew.Status='Order Processing';
        prnew.Type__c='Control Hardware';
        
        INSERT prnew;
        
        ProductRequest getPrNum = [Select id,ProductRequestNumber FROM ProductRequest WHERE Id=:prnew.Id];
        
        // Insert Product Request Line Item
        List<ProductRequestLineItem> prLineInsert = new List<ProductRequestLineItem>();
        List<ProductTransfer> ptLineInsert = new List<ProductTransfer>();
        
        for(Product2 prIn : prodForNewFSE)
        {
            ProductRequestLineItem prli = new ProductRequestLineItem();
            prli.ParentId = prnew.Id;
            prli.Status ='Submitted';
            prli.Product2Id = prIn.Id; 
            prli.QuantityRequested = preStockReq.get(prIn.Id).Quantity__c;
            prli.NeedByDate = date.valueOf(reqDate);
            prli.DestinationLocationId = trunkId;
            prli.ShipToStreet = street;
            prli.ShipToCity = city;
            prli.ShipToState = state;
            prli.ShipToCountry = country;
            prli.ShipToPostalCode = postcode;
            prli.ShipmentType = 'Rush';
            prli.Description = preStockReq.get(prIn.Id).Description; 
            //prli.QuantityUnitOfMeasure = 'Each';
            prLineInsert.add(prli);
        }
        
        INSERT prLineInsert;
        
        Map<Id,ProductRequestLineItem> mapProReqLineItemOel = new Map<Id,ProductRequestLineItem>();
        List<ProductRequestLineItem> insertedPrli = new List<ProductRequestLineItem>();
        insertedPrli = [Select id,ParentId,Parent.ProductRequestNumber,ProductRequestLineItemNumber,Product2Id,Product2.Product_SKU__c 
                        from ProductRequestLineItem WHERE ParentId =:prnew.Id];
        for(ProductRequestLineItem prl : insertedPrli)
        {
            mapProReqLineItemOel.put(prl.Product2Id,prl);
        }
        
        // Insert Product Transfers
        for(ProductRequestLineItem plTrn : prLineInsert)
        {
            System.debug(' Product SKU '+plTrn.Product2.Product_SKU__c);
            ProductTransfer prt = new ProductTransfer();
            prt.ProductRequestLineItemId = plTrn.Id;
            prt.Product2Id = plTrn.Product2Id;
            prt.QuantitySent = plTrn.QuantityRequested;
            prt.QuantityReceived = NULL;
            prt.QuantityUnitOfMeasure = '';
            prt.DestinationLocationId = trunkId;
            prt.ReceivedById = serRes.RelatedRecordId;
            ptLineInsert.add(prt);
        }
        
        INSERT ptLineInsert; 
        
        
        // Insert Order Entry Release
        Integer counter = 0;
        Order_Entry_Release__c newOerPartReq = new Order_Entry_Release__c();
        newOerPartReq.Opportunity__c = opp.Id;
        newOerPartReq.Order_Type__c ='View Internal';
        
        if(shippingConName != null && shippingConName != '')
        	newOerPartReq.Shipping_Contact_Name__c = shippingConName;
        if(shippingConPhone != null && shippingConPhone != '')
        	newOerPartReq.Shipping_Contact_Number__c = shippingConPhone;
        
        //newOerPartReq.Project_ID__c = opp.Opportunity_ID__c;
        newOerPartReq.Freight__c = 'Non-Billable';
        newOerPartReq.Shipping_Account__c = acc.Id;
        newOerPartReq.Billing_Account__c = acc.Id;
        newOerPartReq.Sold_to_Account__c = acc.Id;
        newOerPartReq.RecordTypeId = '0120h000000QiWlAAK';
        newOerPartReq.Release_Name__c = serRes.Location.Name+ ' - '+'Pre-Emptive'; //'Parts Request for '+opp.Name;
        newOerPartReq.Request_Date__c = date.valueOf(reqDate);
        newOerPartReq.Requestor__c = serRes.RelatedRecordId; //UserInfo.getUserId();
        newOerPartReq.Auto_Book_Order__c = True;
        newOerPartReq.Shipping_Street_1__c = street;
        newOerPartReq.Shipping_City__c = city;
        newOerPartReq.Shipping_State_Province__c = state;
        newOerPartReq.Shipping_Country__c = country;
        newOerPartReq.Shipping_Postal_Code__c = postcode;
        newOerPartReq.Sales_Executive__c = '0050L000008ZJKcQAO';
        newOerPartReq.Project_Manager__c = '0050L000008ZJKcQAO';
        newOerPartReq.Shipping_Name__c = 'View Control HW Spare Parts Inventory';
        newOerPartReq.Deliver_To_Street_1__c = street;
        newOerPartReq.Deliver_To_City__c = city;
        newOerPartReq.Deliver_To_State_Province__c = state;
        newOerPartReq.Deliver_To_Country__c = country;
        newOerPartReq.Deliver_To_Postal_Code__c = postcode;
        newOerPartReq.Deliver_To_Account__c = acc.id;
        newOerPartReq.Deliver_To_Name__c ='View Control HW Spare Parts Inventory';
        //Integer oppNumber = Integer.valueOf(opp.Opportunity_ID__c);
        newOerPartReq.Name = formatName(opp.Id,counter);
        
        
        if(Date.today().daysBetween(newOerPartReq.Request_Date__c) > 5) {             newOerPartReq.Scheduled_Ship_Date__c = newOerPartReq.Request_Date__c.addDays(-5);
        } else {
            newOerPartReq.Scheduled_Ship_Date__c = Date.today();
        }
        newOerPartReq.Promised_Date__c = newOerPartReq.Request_Date__c;
        
        INSERT newOerPartReq;
        system.debug('OER Insert '+newOerPartReq);
        
        
        // Insert Order Entry Lines
        List<Order_Entry_Line__c> oelInsert = new List<Order_Entry_Line__c>();
        for(Product2 prIn : prodForNewFSE)
        {
            String uniqueProductRequestLineItemForOel;
            System.debug('Prod *** '+prIn);
            Order_Entry_Line__c oel = new Order_Entry_Line__c();
            oel.Product__c = prIn.Id;
            oel.Quantity__c = preStockReq.get(prIn.Id).Quantity__c;
            //oel.Deliver_To_Account__c = acc.Id;
            oel.RecordTypeId = '0120h000000QiWjAAK';
            oel.Reference_ID__c = newOerPartReq.Name;
            oel.SKU__c = prIn.Product_SKU__c; 
            oel.Order_Entry_Release__c = newOerPartReq.Id;
            oel.Reference_ID__c = getPrNum.ProductRequestNumber;
            oel.Customer_Reference_Description__c = 'Parts Request - '+ getPrNum.ProductRequestNumber; // need to query on the Product Request Number to populate
            oel.Request_Date__c = date.valueOf(reqDate);
            oel.Shipping_Account__c = acc.Id;
            oel.Shipping_Street_1__c = street;
            oel.Shipping_City__c = city;
            oel.Shipping_State_Province__c = state;
            oel.Shipping_Country__c = country;
            oel.Shipping_Postal_Code__c = postcode;
            oel.Shipping_Name__c = 'View Control HW Spare Parts Inventory';
            oel.Deliver_To_Account__c = acc.Id;
            oel.Deliver_To_Name__c = 'View Control HW Spare Parts Inventory';
            oel.Deliver_To_Street_1__c = street;                                
            oel.Deliver_To_City__c = city;
            oel.Deliver_To_State_Province__c = state;
            oel.Deliver_To_Country__c = country;
            oel.Deliver_To_Postal_Code__c = postcode;
            if(mapProReqLineItemOel.containsKey(prIn.Id))
            {
                oel.Trunk_Product_Request_Line_Item__c = mapProReqLineItemOel.get(prIn.Id).id;  
            }
            
            
            if(Date.today().daysBetween(oel.Request_Date__c) > 5) {                oel.Scheduled_Ship_Date__c = oel.Request_Date__c.addDays(-5);
            } else {
                oel.Scheduled_Ship_Date__c = Date.today();
            }
            oel.Promised_Date__c = oel.Request_Date__c;
            
            oelInsert.add(oel);
        }
        
        INSERT oelInsert;
        
        ProductRequest ptOer = new ProductRequest();
        ptOer = [Select id,Order_Entry_Release__c From ProductRequest WHERE Id =:prnew.Id ];
        ptOer.Order_Entry_Release__c = newOerPartReq.Id;
        UPDATE ptOer;
    }

    public static String formatName(Id oppRecId, Integer counter){
        Integer maxOERNumber = 0;
        Integer oerNum;
        String oerNumStr;
        Opportunity oppRec = [SELECT Id,Opportunity_Id__c FROM Opportunity WHERE Id =: oppRecId];
        for (Order_Entry_Release__c oer : [SELECT Id, CurrencyISOCode, name, Release_Name__c FROM Order_Entry_Release__c 
                                           WHERE Opportunity__c = : oppRec.Id])
        {
            
            oerNumStr = oer.Name.SubStringAfterLast('-');
            System.debug('196 '+oerNumStr);
            if (oerNumStr != null)
            { 
                oerNum = Integer.valueOf(oerNumStr);
                if (oerNum > maxOERNumber) maxOERNumber = oerNum;
            }
        }
        System.debug('203 '+oerNumStr);
        maxOERNumber++;
        maxOERNumber+= counter;
        oerNumStr = String.valueOf(maxOERNumber);
        if (oerNumStr.length() == 1)
        {
            oerNumStr= '00' + oerNumStr;
            System.debug('210 '+oerNumStr);
        }
        else
        {
            if (oerNumStr.length() == 2)
            {
                oerNumStr = '0' + oerNumStr;
            }
        }
        return oppRec.Opportunity_Id__c + '-' + oerNumStr;
    }
    
   /* 
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' LIMIT 49999';
            } else {
                query += ' WHERE '+filterField+
                    ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
            }
            for(SObject s : Database.query(query)) {                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    } 
    
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
   */
    
    //Method to call google API and fetch the address recommendations 
    @AuraEnabled
    public static String getAddressSet(String SearchText){
        String APIKey = 'AIzaSyBwHJ6HCVZDB8nfdiq3EXuoQm76IlzdYKM';
        String result = null;
        system.debug('SearchText is ' + SearchText);
        try{
            if(SearchText != null){
                String APIUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + + EncodingUtil.urlEncode( SearchText, 'UTF-8' ) + '&key=' + APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                    System.debug('Result of Google Address '+result);
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
        }
        return result;
    }
    
    //Method to call google API and fetch the address details by addressID 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String PlaceID){
        String APIKey = 'AIzaSyBwHJ6HCVZDB8nfdiq3EXuoQm76IlzdYKM';
        String result = null;
        system.debug('SearchText is ' + PlaceID);
        try{
            if(PlaceID != null){
                String APIUrl = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=' + PlaceId.replace(' ', '%20') + '&key=' + APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                    System.debug('Result of Google Address '+result);
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
        }
        return result;
    }
    
    /*
    @AuraEnabled(cacheable=true)
    public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val, 
                                  Integer lim,String fld_API_Search,String searchText ){
                                      
                                      //searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
                                      String sText;
                                      sText= searchText.replaceAll( '\\s+', '');                                    
                                      searchText = '%' + sText + '%';                                      
                                      System.debug(' Search Text '+searchText);
                                      String productFamily ='CSS'; */
                                      
                                                                              /*  
                                        String query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                                        ' FROM '+objectName+
                                        ' WHERE '+fld_API_Search+' LIKE '+searchText+
                                        ' LIMIT '+lim;
                                        */
    /*
                                      List<Product2> listOfProducts = [ SELECT ID, Name, Product_SKU__c, ProductCode, Family,Description, 
                                                                       (SELECT ID, UnitPrice FROM PriceBookEntries WHERE PriceBook2Id != NULL AND  IsActive = true  LIMIT 1 ) 
                                                                       FROM Product2  WHERE IsActive = true AND
                                                                       Family = : productFamily
                                                                       AND
                                                                       (
                                                                           Name LIKE : searchText
                                                                           OR
                                                                           Product_SKU__c LIKE : searchText
                                                                           OR
                                                                           ProductCode LIKE : searchText
                                                                           OR
                                                                           Description LIKE : searchText
                                                                       ) AND 
                                                                       Id IN (SELECT Product2Id FROM PricebookEntry)
                                                                       ORDER BY Name LIMIT : lim
                                                                      ];
                                      //  List<sObject> sobjList = Database.query(query);
                                      List<ResultWrapper> lstRet = new List<ResultWrapper>();
                                      System.debug('@@@@@ PR List '+listOfProducts);
                                      for(Product2 s : listOfProducts){
                                          ResultWrapper obj = new ResultWrapper();
                                          obj.objName = objectName;
                                          obj.text = String.valueOf(s.Name) ;
                                          obj.val = String.valueOf(s.Id)  ;
                                          lstRet.add(obj);
                                      } 
                                      return JSON.serialize(lstRet);
                                  }
    
    public class ResultWrapper{
        @AuraEnabled public String objName {get;set;}
        @AuraEnabled public String text{get;set;}
        @AuraEnabled public String val{get;set;}
    }
*/
   
    /*
    @AuraEnabled 
    public static String searchProductRecords( String searchKeyword, String opportunityPricebook2Id, String productFamily, String currencyIsoCode ) {
        
        System.debug( 'searchRecords-searchKeyword:-\n' + searchKeyword );
        System.debug( 'searchRecords-opportunityPricebook2Id:-\n' + opportunityPricebook2Id );
        
        IssueManagementCtrl.Response response = new IssueManagementCtrl.Response();
        if( String.isBlank( searchKeyword ) || String.isBlank( opportunityPricebook2Id ) || String.isBlank( productFamily ) ) {
            response.setStatus( false, System.Label.Search_Keyword_Missing );
        }
        else {
            searchKeyword = '%' + searchKeyword + '%';
            System.debug( 'After searchKeyword:-\n' + searchKeyword );
            
            try {
                List<Product2> listOfProducts = [ SELECT ID, Name, Product_SKU__c, ProductCode, Family, 
                                                  (
                                                   SELECT ID, UnitPrice
                                                   FROM PriceBookEntries
                                                   WHERE 
                                                   PriceBook2Id = :opportunityPricebook2Id
                                                    AND
                                                   CurrencyIsoCode =: currencyIsoCode
                                                    AND
                                                   IsActive = true
                                                   LIMIT 1
                                                  )
                                                  FROM Product2 
                                                  WHERE
                                                  IsActive = true
                                                    AND
                                                  Family = : productFamily
                                                    AND
                                                  (
                                                    Name LIKE : searchKeyword
                                                    OR
                                                    Product_SKU__c LIKE : searchKeyword
                                                    OR
                                                    ProductCode LIKE : searchKeyword
                                                    OR
                                                    Description LIKE : searchKeyword
                                                  )
                                                  ORDER BY Name LIMIT : SEARCH_RESULTS_LIMIT
                                                ];
                System.debug( 'searchProductRecords-listOfProducts:-\n' + JSON.serialize( listOfProducts ) );
                for( Product2 recordProduct : listOfProducts ) {
                    
                    if( !recordProduct.PriceBookEntries.isEmpty() ) {
                        Decimal listPrice;
                        if( !recordProduct.PriceBookEntries.isEmpty() ) {
                            listPrice = recordProduct.PriceBookEntries.get( 0 ).UnitPrice;
                        }
                        
                        String strListPrice;
                        if( listPrice != null ) {
                            strListPrice = currencyIsoCode + ' ' + listPrice.setScale( 2 );
                        }
                        
                        response.listOfSearchedResults.add
                                                       ( 
                                                        new IssueManagementCtrl.SearchResultWrapper
                                                        (
                                                         recordProduct,
                                                         strListPrice                                                
                                                        )
                                                       );
                    }
                }
                if( response.listOfSearchedResults.isEmpty() ) {
                    response.setStatus( false, System.Label.Products_Not_Found );
                }
                else {
                    response.setStatus( true, '' );
                }
            }
            catch( Exception e ) {
                System.debug( 'Exception in searchProductRecords:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Error_Getting_Products + e.getMessage() );
            }
        }
        System.debug( 'searchRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    } */    
}