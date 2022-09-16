public class Order_Entry_BulkLoadExt 
{
    //
    // Version 8
    //  - Changes to accommodate CPQ Quote object
    //  20180530 - Changed to support both SFDC and CPQ Quote objects
    //  20180626 - CurrencyISOCode added to queries and initialized for new Order Entry Lines
    //
    // Version 7 
    //  - Changes templates to accommodate new load formats for Imperial and Metric
    //  - Adds code to catch unexpected system errors
    // Updated Date			Developer		Project 			  Tracking Id         				Requirement							
    // 07-August-2020 		Srikanth        Project Concrete	  REQ_APPROVED_TO_SHIP_VAL     		Please restrict the loader or partial loader to be used on Approved-to-ship. until we have the bandwidth to look at state transition.
    // 06-Jan-2021			Srikanth		DealDesk SOP Findinds DD_SOP_Findings_Jan_2021			DealDesk SOP Findings, restricted on Change Requested, 'Change Confirmation Requested',Pre-Release Review

    public String excelData{get;set;}
    public Set<Id> productIds = new Set<id>();
    public Order_Entry_Release__c oer{get;set;}
    public Boolean loadErrors {get;set;}
    public Boolean isCSS{get;set;}
    public list<Product2> nonIGUProductList;
    public Boolean badOERStatus {get; set;}
    public Boolean lineParseError = false;
    public Map<Id,Product2> availableProducts = new Map<Id,Product2>();
    public Map<String,Id> cssProducts = new Map<String,Id>();
    public List<SelectOption> productSelections = new List<SelectOption>();
    public List<Order_Entry_Line__c> orderEntryLines = new List<Order_Entry_Line__c>();
    public Set<Order_Entry_Line__c> orderEntryLineSet = new Set<Order_Entry_Line__c>();
    public Id recordTypeID;
    //  20180530 - Changed to support both SFDC and CPQ Quote objects
    public String quoteSource;
    public Map<Id,Id> product2QLMap = new Map<Id,Id>();
    public Map<String,Id> product2SKUMap = new  Map<String,Id>();   
    public String recordTypeName;
    public String selectedProduct{get;set;}
    public Integer startingLineNumber;
    public Decimal maxLineNumber = 0.0;
    public String errorList {get;set;}
    String titleTabs1 = '\t\t';
    String titleTabs2 = '\t\t\t\t\t\t\t\t';
    String tabs1 = '\t\t\t\t';
    String tabs2 = '\t\t\t';
    String tabsCont = '\t\t\t\t\t\t\t\t\t\t\t\t';
    String crlf = '\r\n';
    // *** Change to handle OEL Record Type
    Map<String,RecordType> rtNameMap = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap('Order_Entry_Line__c');
    //DD_SOP_Findings_Jan_2021
    Set<String> loadNotAllowed = new Set<String> {'Confirmation Pending','Pre-Release Review','Change Requested','Confirmation Requested', 'Integration Requested', 'Cancellation Requested', 
        'Cancelled', 'Change Confirmation Requested', 'Change Integration Requested', 'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested',
        'Cancellation Integration Requested', 'Cancellation Confirmed','Approved-to-Ship'};//REQ_APPROVED_TO_SHIP_VAL
    //Added by Enp
    //DD_SOP_Findings_Jan_2021
    Set<String> loadNotAllowedCSS= new Set<String> {'Confirmation Pending','Change Requested','Confirmation Requested', 'Integration Requested', 'Cancellation Requested', 
        'Cancelled', 'Approval to Ship Requested', 'Change Integration Requested', 'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested',
        'Cancellation Integration Requested', 'Cancellation Confirmed','Change Confirmation Requested','Change Confirmed','Confirmed','Shipped','Approved-to-Ship'};//REQ_APPROVED_TO_SHIP_VAL
        
    public Order_Entry_BulkLoadExt(ApexPages.StandardSetController stdSetController) 
    {
        //
        // Get the Order Release Information
        //
        badOERStatus = false;
        errorList = 'Line Number' + titleTabs1 + 'Begins with...' + titleTabs2 + 'Error Message' + crlf;
        Id id = ApexPages.CurrentPage().getParameters().get('id');
        if (id != null)
        {
            // 20180530 - Changed to support both SFDC and CPQ Quote objects
            // 20180626 - CurrencyISOCode added to queried fields
            oer = [SELECT Name, CurrencyISOCode, Opportunity__c, System_of_Measurement__c, Shipping_Account__c, Shipping_City__c, Shipping_Country__c, Shipping_Name__c, 
                Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Street_1__c, Shipping_Street_2__c, Shipping_Street_3__c, Shipping_Address__c,
                CPQ_Quote__c, Quote__c, Status__c,RecordType.name,RecordType.developername FROM Order_Entry_Release__c WHERE Id = :id LIMIT 1];
        }
        //rtNameMap = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap('Order_Entry_Line__c');
        if ((oer.RecordType.developername !=Label.CSS_Hardware && loadNotAllowed.contains(oer.Status__c)) || 
        (oer.RecordType.developername ==Label.CSS_Hardware && loadNotAllowedCSS.contains(oer.Status__c)))
        {
            badOERStatus = true;
            ApexPages.Message statusError = new ApexPages.Message(ApexPages.Severity.ERROR,'Line Item Load is not permitted when Order Entry Release Status is ' + oer.Status__c);
            ApexPages.addMessage(statusError);          
        }
        if (oer != null && !badOERStatus)
        {
            //
            // Determine the starting line number for inserted records.
            //
            // 20180626 - CurrencyISOCode added to queried fields
            orderEntryLines = [SELECT Id,loader__c,Cancellation_Reason__c,Reference_Id__c,CSS_Order_Line_ID__c,Status__c,CurrencyISOCode, Name, RecordTypeId, Unit_Area_Sq_m__c, Area_Sq_Ft__c, Base_Height_1_mm__c, Base_Height_1_decimal_in__c, Base_Height_1_in__c, Base_mm__c, 
                Base_decimal_in__c, Base_in__c, Height_mm__c, Height_decimal_in__c, Height_in__c, Line_Number__c, Mark_Ids__c, Order_Entry_Release__c, Product__c, Quantity__c, 
                Shape__c,SKU__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :oer.Id and loader__c=true and Status__c != 'Cancelled' and (NOT Status__c LIKE 'Cancel%')];
            for (Order_Entry_Line__c oel : orderEntryLines)
            {
                if(oel.Line_Number__c > maxLineNumber)
                {
                    maxLineNumber = oel.Line_Number__c;
                }
            }
            startingLineNumber = Integer.valueOf(maxLineNumber);
            //system.debug('Order Entry Lines Size = ' + String.valueOf(orderEntryLines.size()));
            //
            // Get a Map of the valid Products for the Opportunity
            //
            // 20180530 - Changed to support both SFDC and CPQ Quote objects
            //Added by ENP - START
                       
            //Added by ENP - END
                if (oer.CPQ_Quote__c != null)
                {
                    quoteSource = 'CPQ';
                    for (SBQQ__QuoteLine__c qli : [SELECT SBQQ__Product__c,SBQQ__Product__r.Product_SKU__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :oer.CPQ_Quote__c])
                    {
                        productIds.add(qli.SBQQ__Product__c);
                        product2QLMap.put(qli.SBQQ__Product__c, qli.Id);
                        product2SKUMap.put(qli.SBQQ__Product__r.Product_SKU__c,qli.id);
                    }
                }
                else
                {
                    if (oer.Quote__c != null)
                    {
                        quoteSource = 'SFDC';
                        for (QuoteLineItem qli : [SELECT Product2Id,Product2.Product_SKU__c FROM QuoteLineItem WHERE QuoteId = :oer.Quote__c])
                        {
                            productIds.add(qli.Product2Id);
                            product2QLMap.put(qli.Product2Id, qli.Id);
                            product2SKUMap.put(qli.Product2.Product_SKU__c,qli.Id);
                        }
                    }
                    else
                    {       
                            if(oer.RecordType.developername.containsIgnoreCase('IGU')){  
                                ApexPages.Message missingQuoteError = new ApexPages.Message(ApexPages.Severity.ERROR,'Order Entry Release must have either an SFDC or CPQ Quotre specified to load Order Etnry Lines');
                                ApexPages.addMessage(missingQuoteError);
                            }
                                  
                    }               
                }
                //system.debug('@@##'+product2SKUMap);
            // 20180530
            if(oer.RecordType.DeveloperName !=Label.CSS_Hardware && oer.RecordType.DeveloperName !=Label.CSS_Software){
                for (Product2 prd : [SELECT Id, Name, Product_SKU__c, ProductCode from Product2 where Id in :productIds AND Family='IGU'])
                {
                    availableProducts.put(prd.Id, prd);
                } 
     
                productSelections.clear();
                String paddedSKU;
                Boolean firstSelection = true;
                for (Product2 prod : availableProducts.values())
                {
                    paddedSKU = prod.Product_SKU__c;
                    while(paddedSKU.length() < 15)
                    {
                        paddedSKU = paddedSKU + ' ';
                    }
                    paddedSKU = paddedSKU + Prod.name;
                    productSelections.add(new SelectOption(String.valueOf(prod.Id), paddedSKU));     
                    //system.debug('SelectOption: ' + String.valueOf(prod.Id) + ' ' + paddedSKU);
                    if (firstSelection)  
                    {
                        selectedProduct = String.valueOf(prod.Id);
                        firstSelection = false;
                    }       
                }           
            }
        //Added by ENP - START
        else{        
            for (Product2 prd : [SELECT Id, Name, Product_SKU__c, ProductCode from Product2 where Family!='IGU' AND ISActive=true]){
                cssProducts.put(prd.Product_SKU__c, prd.Id);
            }                   
        }
        //Added by ENP - END
        }
        // *** Changed to handle OEL Record Type
        if (oer.System_of_Measurement__c == 'Metric'){
            recordTypeId = rtNameMap.get('IGU_Metric').Id;
            recordTypeName = 'IGU_Metric';
        }
        //Added by ENP        
        else if(oer.RecordType.DeveloperName ==Label.CSS_Software){
            recordTypeId = rtNameMap.get(Label.CSS_Software).Id;
            recordTypeName = Label.CSS_Software;
            isCSS = true; 
        }
        else if(oer.RecordType.DeveloperName ==Label.CSS_Hardware){
            recordTypeId = rtNameMap.get(Label.CSS_Hardware).Id;
            recordTypeName = Label.CSS_Hardware;
            isCSS = true;            
        }
        //Added by ENP - END 
        else{
            recordTypeId = rtNameMap.get('IGU_Imperial').Id;
            recordTypeName = 'IGU_Imperial';
        }
        
    }
    
    public List<String> getRecords(String multiRec)
    {
        //
        // Parses block text of the pasted Excel data into Strings representing individual Order Entry Lines.
        //
        Boolean withinQuote = false;
        List<String> retRows = new List<String>();
        List<Integer> xlChars = multiRec.getChars();
        List<Integer> recBuffer = new List<Integer>();
        //system.debug('@@rows'+multiRec);
        try 
        {
            for(Integer i=0; i < xlChars.size(); i++)
            {
                //system.debug('*** multiRec char[' + String.valueOf(i) + '} = ' + String.valueOf(xlChars[i]) );

                if (xlChars[i] == 34 && false)
                {
                    if (withinQuote)
                    {
                        withinQuote = false;
                    }
                    else
                    {
                        withinQuote = true;
                    }
                }
                else
                {
                    if(!withinQuote)
                    {
                        if (xlChars[i] == 13 && xlChars[i+1] == 10)
                        {
                            retRows.add(String.fromCharArray(recBuffer));
                            recBuffer.clear();
                            i++;
                        }   
                        else
                        {
                            recBuffer.add(xlChars[i]);
                        }
                    }
                    else
                    {
                        if (xlChars[i] == 9) // Single quote within field 
                        {
                            withinQuote = false;
                            recBuffer.add(9);
                        }
                    }
                }
            }
        }
        catch (Exception e)
        {
            ApexPages.Message lineParseError = new ApexPages.Message(ApexPages.Severity.ERROR,'An error occurred parsing Excel data into Order Entry Lines: ' + e.getMessage() +
                ' - check that the correct Excel columns and rows have been selected.');
            ApexPages.addMessage(lineParseError);   
            return null;
        }
        return retRows;
    }
    
    
    public List<SelectOption> getProductSelections()
    {
        return productSelections;
    }
    
    public PageReference load() 
    {
        loadErrors = false;
        String workingData = excelData;
        Map<String,String> fieldType = new Map<String, String> {'Area_Sq_Cm__c'=>'Number', 'Area_Sq_Ft__c'=>'Number', 'Base_Height_1_mm__c'=>'Number', 'Base_Height_1_decimal_in__c'=>'Number', 
            'Base_Height_1_in__c'=>'Text', 'Base_mm__c'=>'Number', 'Base_decimal_in__c'=>'Number', 'Base_in__c'=>'Text', 'Height_mm__c'=>'Number', 'Height_decimal_in__c'=>'Number', 
            'Height_in__c'=>'Text', 'Line_Number__c'=>'Number', 'Mark_Ids__c'=>'Text', 'Quantity__c'=>'Number', 'Shape__c'=>'Text', 'Non_Standard_Approval__c' => 'Checkbox'};
        Map<String,String> shapeNumberMap = new Map<String, String> {'1'=>'Trapezoid - 1', '2'=>'Trapezoid - 2', '45'=>'Triangle - 45', '46'=>'Triangle - 46', '301'=>'Trapezoid - 301', 
            '302'=>'Trapezoid - 302'};
        List<String> oelRecordColumns;
        List<String> columnMapImperial = new List<String> {'Reference_Id__c', 'Mark_Ids__c', 'Quantity__c', 'Base_in__c', '', 'Height_in__c', 'Shape__c', 'Base_Height_1_in__c', 'Non_Standard_Approval__c'};
        List<String> columnMapMetric = new List<String> {'Reference_ID__c', 'Mark_Ids__c', 'Quantity__c', 'Base_mm__c', '', 'Height_mm__c', 'Shape__c', 'Base_Height_1_mm__c', 'Non_Standard_Approval__c'};
        List<String> columnMap1 = new List<String>();
        List<String> parseErrors = new List<String>();
        //Order_Entry_Line__c newOEL;
        List<Order_Entry_Line__c> newOELList = new List<Order_Entry_Line__c>();
        List <Database.SaveResult> srList = new List<Database.SaveResult>();        
        Map<String, Order_Entry_Line__c> newSKUOELMap = new Map<String, Order_Entry_Line__c>();
        List<String> oelRecords = getRecords(workingData);
        List<OrderEntryLineWrapper> oelWrapperList = new List<OrderEntryLineWrapper>();
        OrderEntryLineWrapper oelWrapper;
        Decimal nextLineNumber = startingLineNumber;
        List<Integer> hexB = new List<Integer>();
        hexB.add(11);
        String tabSub = String.fromCharArray(hexB);
        Integer i;
        Integer lineSeq = 1;
        //Added by ENP
        String loadskustring='';// Added by ENP
        Set<string> skuSet=new Set<string>();// Added by ENP
        List<String> cSSMap = new List<String> {'SKU__c','Reference_ID__c','Quantity__c'};//Added by ENP
        Order_Entry_Line__c newOELRecord; // Added by ENP       
        Map<string,string> mapSkuFamily=new Map<string,string>();//added by enp to avoid product family
        Map<string,string> mapMarksFamily=new Map<string,string>();//added by enp to avoid product family
        Map<String, Order_Entry_Line__c> oelProductMap = new Map<String, Order_Entry_Line__c>();// Added by ENP
        Map<String, Decimal> oelOldMap = new Map<String, Decimal>();
        List <Database.UpsertResult> urList = new List<Database.UpsertResult>();
        set<string> skuRefDup=new set<string>();
        Map<string,Decimal> skuRefDupQuantityMap=new Map<string,Decimal>();
        //Added by Enp
        list<Order_Entry_Line__c> deleteLines = new list<Order_Entry_Line__c>();
        //Added by ENP - START
        for(Order_Entry_Line__c obj: orderEntryLines){      
            oelProductMap.put(obj.CSS_Order_Line_ID__c, obj); 
            oelOldMap.put(obj.CSS_Order_Line_ID__c, obj.quantity__c); 
        }
        //Added by ENP - END
        if (oelRecords == null)
        {
            return ApexPages.currentPage();
        }
        
        if (oer.System_of_Measurement__c == 'Metric')
        {
            columnMap1 = columnMapMetric;
        }        
        //Added by ENP
        else if(recordTypeName==Label.CSS_Hardware || recordTypeName==Label.CSS_Software){
            columnMap1 = cSSMap;
        }
        //Added by ENP - END
        else {
            columnMap1 = columnMapImperial;
        }        
            for (String str: oelRecords)
            {
            //system.debug('OEL Records: ' + str);
            //Added by ENP
            //loadskustring=loadskustring+str;
            ////system.debug('@@sku: ' + loadskustring);
            oelRecordColumns = str.split('\\t');
            if(oelRecordColumns.size() > 3 && !oer.RecordType.DeveloperName.contains('IGU'))
            {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'you should upload 3 columns')); 
                return null; 
            }
            // 20180530 - Changes to support both SFDC and CPQ Quote objects
            // 20180626 - CurrencyISOCode added to new fields
            Order_Entry_Line__c newOEL = new Order_Entry_Line__c (Order_Entry_Release__c = oer.Id, CurrencyISOCode = oer.CurrencyISOCode, RecordTypeId = recordTypeId, 
                Trigger_Source__c = 'Loader', Status__c = 'Draft', Use_Account_Shipping_Address__c = true, Non_Standard_Approval__c = false);      
            
            // Added by ENP - RType Check   
            if(oer.RecordType.DeveloperName.contains('IGU')){ 
                if (quoteSource == 'CPQ'){
                    newOEL.CPQ_Quote_Line__c = product2QLMap.get(Id.valueOf(selectedProduct));
                    newOEL.Product__c = selectedProduct;
                }
                else{
                    newOEL.Quote_Line_Item__c = product2QLMap.get(Id.valueOf(selectedProduct));
                    newOEL.Product__c = selectedProduct;
                }
            }           
            // 20180530
                
            parseErrors.clear();
            for(i=0; i< columnMap1.size() && i < oelRecordColumns.size(); i++)
            {
                //
                // Parse Order Entry Line string into fields and create new Order Entry Line records
                //
                oelRecordColumns[i] = oelRecordColumns[i].replaceAll(tabSub,'\t');
                //system.debug('OEL Column: ' + oelRecordColumns[i]);     
                if (columnMap1[i] != '' && columnMap1[i] != null) 
                {
                    try
                    {
                        if (columnMap1[i] == 'Shape__c')
                        {
                            if (oelRecordColumns[i] == '')
                            {
                                newOEL.put('Shape__c', 'Rectangle');
                            }
                            else
                            {
                                if (shapeNumberMap.keyset().contains(oelRecordColumns[i].trim()))
                                {
                                    newOEL.put('Shape__c', shapeNumberMap.get(oelRecordColumns[i].trim()));
                                }
                                else
                                {
                                    newOEL.put('Shape__c',oelRecordColumns[i]);
                                }
                            }
                        }
                        else
                        {
                            if (fieldType.get(columnMap1[i]) == 'Number')
                            {
                                if (oelRecordColumns[i] != null && oelRecordColumns[i] != '')
                                {
                                    try 
                                    {
                                        newOEL.put(columnMap1[i], Decimal.valueOf(oelRecordColumns[i].trim()));
                                    }
                                    catch (TypeException e)
                                    {
                                        parseErrors.add('An error occurred parsing Order Entry Line Number ' + String.valueOf(lineSeq) + ': ' + columnMap1[i] + ' "' + oelRecordColumns[i] 
                                        + '" is not numeric.');
                                    }
                                }
                                
                            }
                            else                            
                            {
                                if (fieldType.get(columnMap1[i]) == 'Checkbox')
                                {
                                    if (oelRecordColumns[i] == 'Y')
                                    {
                                        newOEL.put(columnMap1[i], true);
                                    }
                                }
                                else
                                {
                                    newOEL.put(columnMap1[i], oelRecordColumns[i]);
                                }   
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        parseErrors.add('An error occurred parsing Order Entry Line Number ' + String.valueOf(lineSeq) + ': ' + e.getMessage());
                    }
                }
            }
            // Added by ENP - START
            
            
            //system.debug('@@@@***'+cssProducts.get(newOEL.SKU__c));
            //system.debug('@@@@***'+newOEL.SKU__c);
            //Assign SF and CPQ Quote line items for CSS            
            if(oer.RecordType.DeveloperName ==Label.CSS_Hardware || oer.RecordType.DeveloperName ==Label.CSS_Software){ 
                newOEL.CSS_Order_Line_ID__c=newOEL.SKU__c+':'+newOEL.Reference_ID__c;
                loadskustring=loadskustring+newOEL.CSS_Order_Line_ID__c;
                //system.debug('@@sku: ' + loadskustring);
            
            //system.debug('@@cssorderline: ' + newOEL.CSS_Order_Line_ID__c);
                 newOEL.Product__c = cssProducts.get(newOEL.SKU__c);
                 if(quoteSource == 'CPQ'){
                     newOEL.CPQ_Quote_Line__c = product2SKUMap.get(newOEL.SKU__c);
                 }
                 else {
                     newOEL.Quote_Line_Item__c = product2SKUMap.get(newOEL.SKU__c);              
                 }
                //Check the line exists with the same product code on OER, if YES assign the exisitng line to newOEL for SW and HW.
                
                    if(oelProductMap!=null && oelProductMap.containskey(newOEL.CSS_Order_Line_ID__c) && oelProductMap.get(newOEL.CSS_Order_Line_ID__c)!=null && !oer.RecordType.DeveloperName.contains('IGU') && oelProductMap.get(newOEL.CSS_Order_Line_ID__c).Status__c!='Draft'){
                       
                        
                        //Add the Qunatity
                        if(!skuRefDupQuantityMap.containskey(newOEL.CSS_Order_Line_ID__c)){
                        //system.debug('---qold'+oelProductMap.get(newOEL.CSS_Order_Line_ID__c).Quantity__c);
                        newOELRecord = oelProductMap.get(newOEL.CSS_Order_Line_ID__c);
                        newOELRecord.Quantity__c = newOEL.Quantity__c;
                        //system.debug('---qnew'+oelProductMap.get(newOEL.CSS_Order_Line_ID__c).Quantity__c);
                        skuRefDupQuantityMap.put(newOEL.CSS_Order_Line_ID__c,newOEL.Quantity__c);
                        newOELRecord.Trigger_Source__c = 'Loader';
                        newOELRecord.loader__c=true;
                        }
                        else{
                            
                            skuRefDupQuantityMap.put(newOEL.CSS_Order_Line_ID__c,skuRefDupQuantityMap.get(newOEL.CSS_Order_Line_ID__c)+newOEL.Quantity__c);
                            //newOELRecord.Quantity__c = skuRefDupQuantityMap.get(newOEL.CSS_Order_Line_ID__c);
                        }
                        
                    }
                
                else {                
                    //Added by enp phase2
                    if(!skuRefDupQuantityMap.containskey(newOEL.CSS_Order_Line_ID__c)){
                        newOELRecord = newOEL; 
                        skuRefDupQuantityMap.put(newOEL.CSS_Order_Line_ID__c,newOEL.Quantity__c);
                    }
                    else
                    skuRefDupQuantityMap.put(newOEL.CSS_Order_Line_ID__c,skuRefDupQuantityMap.get(newOEL.CSS_Order_Line_ID__c)+newOEL.Quantity__c);
                }
                skuSet.add(newOELRecord.SKU__c);
            }
            else {
                newOELRecord = newOEL; 
            }
            // Added by ENP - END           
            // *** Change to handle OER Record Type
            //oelWrapper = new OrderEntryLineWrapper(newOEL, lineSeq, recordTypeName);
            oelWrapper = new OrderEntryLineWrapper(newOELRecord, lineSeq, recordTypeName);
            if (parseErrors.size() > 0)
            {
                loadErrors = true;
                for (String parseError : parseErrors)
                {
                    oelWrapper.addValidationError(parseError);
                }
            }
            oelWrapper.sourceString = str;
            // *** Change to handle OER Record Type
//          oelWrapper.recordType = recordTypeName;
            //system.debug('---'+oelWrapper);
            oelWrapperList.add(oelWrapper);
            lineSeq++;
        }
        //Check the line exists with the same product code on OER, If NO assign the exisitng line to newOEL status as cancelled
        if(oer.RecordType.DeveloperName ==Label.CSS_Hardware || oer.RecordType.DeveloperName ==Label.CSS_Software){
            for(Order_Entry_Line__c ol:oelProductMap.values())
            {
                if(oer.Status__c == 'Draft')
                {
                    deleteLines.add(ol);
                }
                else if(ol.loader__c && ol.CSS_Order_Line_ID__c<>null && !loadskustring.contains(ol.CSS_Order_Line_ID__c)){
                    ol.Status__c= 'Cancellation Requested';
                    ol.Integration_Action_Requested__c='Cancel';
                    ol.Trigger_Source__c= 'Loader';
                    ol.Cancellation_Reason__c='System Design Change';
                    newOELRecord=ol;
                    oelWrapper = new OrderEntryLineWrapper(newOELRecord, lineSeq, recordTypeName);                    
                    oelWrapperList.add(oelWrapper);
                    //system.debug('---c'+oelWrapper);
                    //lineSeq++;               
                }             
                //system.debug('@@oldole'+ol.Status__c);
            }               
            for(product2 pd:[select id,name,family,Product_SKU__c from product2 where Product_SKU__c in:skuSet])
            {
                if(skuSet.contains(pd.Product_SKU__c))
                mapSkuFamily.put(pd.Product_SKU__c,pd.family);
            }
        }
        for(OrderEntryLineWrapper oelw : oelWrapperList)    
        {
            if (oelw.oel.quantity__c == null || oelw.oel.quantity__c <= 0)  
            {
                oelw.addValidationError('Quantity must be > 0');
                loadErrors = true;
            }
            if(recordTypeName.contains('IGU')){ // Added by ENP
                Boolean dimensionError = Order_Entry_Trigger_Helper_2.validateDimensions(oelw);
                Boolean factoryError = false;            
                if (!oelw.oel.Non_Standard_Approval__c){               
                    factoryError = Order_Entry_Trigger_Helper_2.validateFactory(oelw, availableProducts.get(oelw.oel.Product__c));
                }              
                if (dimensionError || factoryError){
                    loadErrors = true;
                }
            }
            if(!recordTypeName.containsIgnoreCase('IGU'))
            {
                if(oelw.oel.Reference_Id__c == null || oelw.oel.Reference_Id__c == ''){
                    oelw.addValidationError('Customer Reference Id is required');
                    loadErrors = true;
                }
                /*if(oelw.oel.Customer_Reference_Description__c == null || oelw.oel.Customer_Reference_Description__c == ''){
                    oelw.addValidationError('Customer Reference description is required');
                    loadErrors = true;
                }*/
                if(oelw.oel.SKU__c == null || oelw.oel.SKU__c == ''){
                    oelw.addValidationError('Product SKU is required');
                    loadErrors = true;
                }
                
            }
            //*****COMMENTING THIS LINE AS PART OF BOS REFERENCE UPDATES WITH CSS
            //if(recordTypeName == Label.CSS_Hardware && !mapSkuFamily.isEmpty() && mapSkuFamily.containskey(oelw.oel.sku__c) && mapSkuFamily.get(oelw.oel.sku__c)!= 'BOS')
            if(recordTypeName == Label.CSS_Hardware && !mapSkuFamily.isEmpty() && mapSkuFamily.containskey(oelw.oel.sku__c) && mapSkuFamily.get(oelw.oel.sku__c)!= 'CSS')
            {
                oelw.addValidationError('Please load Control Hardware products');
                loadErrors = true;
            }           
            if(recordTypeName == Label.CSS_Software && !mapSkuFamily.isEmpty() && mapSkuFamily.containskey(oelw.oel.sku__c) && 
                !(mapSkuFamily.get(oelw.oel.sku__c) == 'Service' || mapSkuFamily.get(oelw.oel.sku__c) == 'Software' ))
            {
                oelw.addValidationError('Please load Software service products');
                loadErrors = true;
            }
            if(skuRefDupQuantityMap.containskey(oelw.oel.CSS_Order_Line_ID__c) && skuRefDupQuantityMap.get(oelw.oel.CSS_Order_Line_ID__c) != oelw.oel.quantity__c){
                //oelw.addValidationError('Please load unique products and References');
                //loadErrors = true;
                oelw.oel.quantity__c = skuRefDupQuantityMap.get(oelw.oel.CSS_Order_Line_ID__c) ;
            }
            else
            skuRefDup.add(oelw.oel.CSS_Order_Line_ID__c);
        }   
        if (!loadErrors)
        {
            //system.debug('@@###'+oelWrapperList);
            for (OrderEntryLineWrapper oelw : oelWrapperList)
            {    
                if(recordTypeName.contains('IGU')){
                    newOELList.add(oelw.oel);
                }
                else{
                    //system.debug('@@###'+oelw.oel);
                    //orderEntryLineSet.add(oelw.oel);
                    //newOELList.addAll(orderEntryLineSet);
                    //orderEntryLineSet.clear();
                     //system.debug('@@quan'+oelOldMap.get(oelw.oel.CSS_Order_Line_ID__c) +'--'+oelw.oel.quantity__c);
                    if(!(!oelOldMap.isEmpty() && oelOldMap.containsKey(oelw.oel.CSS_Order_Line_ID__c) && 
                       oelOldMap.get(oelw.oel.CSS_Order_Line_ID__c) == oelw.oel.quantity__c && oelw.oel.Status__c != 'Cancellation Requested' && oer.Status__c != 'Draft'))
                   {
                        oelw.oel.loader__c=true;                                  
                        //system.debug('@@ifin'+oelw.oel);
                        
                        newSKUOELMap.put(oelw.oel.CSS_Order_Line_ID__c,oelw.oel);      
                   }
                         
                    
                }
            }
            system.debug('@@###'+newSKUOELMap.size());
           /* if(!recordTypeName.contains('IGU')){        
                for(Order_Entry_Line__c obj : newOELList){
                   //Added by enp for cancel requirement
                   
                   
                    obj.loader__c=true;                                  
                    //system.debug('@@ifin'+obj);
                    
                    newSKUOELMap.put(obj.CSS_Order_Line_ID__c,obj);      
                   
                            
                                                    
                }
                //system.debug('#########'+newSKUOELMap);
            } */
            if(!deleteLines.isEmpty())
            Delete deleteLines;
            System.savePoint savepoint = Database.setSavePoint();
            if(!recordTypeName.contains('IGU') && !newSKUOELMap.isEmpty()){
                urList = Database.upsert(newSKUOELMap.values(),false);
            }
            else {
                srList = Database.insert(newOELList,false);
            }
            //
            // Handle any insert errors
            //
            i = 0;
            for (Database.SaveResult saver : srList)
            {                       
                if(!saver.isSuccess()) 
                {
                    for (Database.Error dbe : saver.getErrors()){
                        oelWrapperList[i].addValidationError(dbe.getMessage());
                        //system.debug('*** Error - Insert failed for Order Entry Line Number ' + String.valueOf(newOELList[i].Line_Number__c) + ' ' + dbe.getMessage());
                    }
                    oelWrapperList[i].hasErrors = true;
                    loadErrors = true;
                }
                i++;                        
            }
            for (Database.UpsertResult saver : urList) 
            {                       
                if(!saver.isSuccess()) 
                {
                    for (Database.Error dbe : saver.getErrors()){
                        oelWrapperList[i].addValidationError(dbe.getMessage());
                        //system.debug('*** Error - Insert failed for Order Entry Line Number ' + String.valueOf(newOELList[i].Line_Number__c) + ' ' + dbe.getMessage());
                    }
                    oelWrapperList[i].hasErrors = true;
                    loadErrors = true;
                }
                i++;                        
            }           
            if (loadErrors) 
            {
                Database.rollback(savepoint);
            }                                                   
        }
        if (loadErrors)
        {
            Integer j = 1;
            for (OrderEntryLineWrapper oelw : oelWrapperList)
            {
                if (oelw.hasErrors)
                {
                    for (i=0; i < oelw.validationErrors.size(); i++) 
                    {
                        
                        if (i == 0 && oelRecords.size()>=j)
                        {
                            
                            errorList = errorList + String.valueOf(j) + tabs1 + oelRecords[j-1].mid(1,26).replace('\t',' ') + '...' + tabs2 + oelw.validationErrors[i] + crlf;
                        }
                        else
                        {
                            errorList = errorList + tabsCont + oelw.validationErrors[i] + crlf;
                        }
                    }
                }
                j++;                
            }                       
            return ApexPages.currentPage();
        }
        else
        {
            PageReference redirectSuccess = new ApexPages.StandardController(oer).view();
            return (redirectSuccess);
        }
    }
        
    public PageReference cancel() 
    {
        PageReference cancellation = new ApexPages.StandardController(oer).view();
        return (cancellation);
    }

}