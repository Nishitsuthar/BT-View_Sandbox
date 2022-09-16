public class OrderEntryLineNewExt 
{ 
    //
    // Version 4 - Changed to support BOTH SFDC and CPQ Quotes
    // 20180626 - Added CurrencyISOCode support
    //
    //
    // Version 3 - Adds Initialization for Promised Date
    // 06-Jan-2021			Srikanth		DealDesk SOP Findinds DD_SOP_Findings_Jan_2021			DealDesk SOP Findings, restricted for Pre-Release Review and through LAbel restricted for CHW Change Integration Requested
    public Order_Entry_Line__c oel {get; set;}
    public List<Order_Entry_Line__c> orderEntryLines = new List<Order_Entry_Line__c>();
    public Order_Entry_Release__c oer;
    public String recordTypeName {get; set;}
    public Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>();
    public Boolean isIGUMetric {get; set;}
    public Boolean isIGUImperial {get; set;}
    public Boolean isIGU {get; set;}
    //Added by - ENP Solutionz
    public Boolean isCSSHardware {get; set;}
    public Boolean isCSSSWService {get; set;}
    public Boolean isCSS {get; set;}
    public list<String> productFamilyList= new list<String>();
    public Boolean badOERStatus {get; set;}
    public String developerName;
    public Boolean enablePicklist {get; set;}
    //END by - ENP Solutionz
    
    public List<SelectOption> productSelections = new List<SelectOption>();
    public String selectedProduct{get;set;}
    public Map<Id,Product2> availableProducts = new Map<Id,Product2>();
    public Map<Id,Id> product2QLMap = new Map<Id,Id>();
    public Set<Id> productIds = new Set<id>();
    public Id firstProductId;
    public String paddedSKU;
    public String quoteSource;
    public Boolean enableCH {get; set;}
    public Boolean enableSS {get; set;}

    
    public OrderEntryLineNewExt(ApexPages.StandardController stdController) 
    {
        for (RecordType rt : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE SObjectType = 'Order_Entry_Line__c'])
        {
            recordTypeMap.put(rt.Id, rt);
        }
        oel = (Order_Entry_Line__c) stdController.getRecord();
        enableCH=false;
        enableSS=false;
        isIGUMetric = false;
        isIGUImperial = false;
        //Added by - ENP Solutionz
        isCSSHardware = false;
        isCSSSWService = false;
        isCSS = false; 
        ////END - ENP Solutionz
        System.debug('OEL Record Type =' + String.valueOf(ApexPages.currentPage().getParameters().get('RecordType')));
        System.debug('Record Type Developer Name = ' + recordTypeMap.get(ApexPages.currentPage().getParameters().get('RecordType')).DeveloperName);
        Id oelRecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        oel.RecordTypeID = oelRecordTypeId;
        recordTypeName = recordTypeMap.get(oelRecordTypeId).Name;
        developerName = recordTypeMap.get(oelRecordTypeId).DeveloperName;
        
        if (developerName == 'IGU_Imperial'){
            isIGUImperial = true;
            //Added by - ENP Solutionz
            productFamilyList.add('IGU');
        }
        else if (developerName == 'IGU_Metric'){
            isIGUMetric = true;
            //Added by - ENP Solutionz
            productFamilyList.add('IGU');           
        }
        else if (developerName == 'IGU'){
                //Added by - ENP Solutionz
                productFamilyList.add('IGU');           
        }
        //Added by - ENP Solutionz
        else if (developerName == Label.CSS_Hardware){
                isCSSHardware = true;
                productFamilyList.add('CSS');
           
        }
        else if (developerName == Label.CSS_Software){
                isCSSSWService = true;
                productFamilyList.add('Software');
                productFamilyList.add('Service');           
        }
        isCSS = isCSSSWService || isCSSHardware;
        //END - ENP Solutionz
        isIGU = isIGUImperial || isIGUMetric;       
        // JV - 20180308 Added Promised_Date__c to selected fields
        // Version 4 - Changed to support BOTH SFDC and CPQ Quotes
        // 20180626 - Added CurrencyISOCode to retrieved fields
        oer = [SELECT Status__c,Name, Opportunity__c,recordType.DeveloperName, System_of_Measurement__c, Shipping_Account__c, Shipping_City__c, Shipping_Country__c, Shipping_Name__c, CurrencyISOCode,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Street_1__c, Shipping_Street_2__c, Shipping_Street_3__c, Shipping_Address__c,
            Request_Date__c, CPQ_Quote__c ,Scheduled_Ship_Date__c, Promised_Date__c, Quote__c,recordType.Name FROM Order_Entry_Release__c WHERE Id = :oel.Order_Entry_Release__c LIMIT 1];
        //DD_SOP_Findings_Jan_2021
        if (oer.RecordType.Name.containsIgnoreCase('Control') && Label.LineVFNotAllowed.containsIgnoreCase(oer.status__c) ||
            (oer.recordType.DeveloperName.contains('IGU') && oer.Status__c == 'Pre-Release Review'  ))
        {
            badOERStatus = true;
            ApexPages.Message statusError = new ApexPages.Message(ApexPages.Severity.ERROR,'Inserting a Line Item is not permitted when Order Entry Release Status is ' + oer.Status__c);
            ApexPages.addMessage(statusError);          
        }
        Decimal maxOrderEntryLine = 0.0;
        // 20180626 - Added CurrencyISOCode to retrieved fields
        for (Order_Entry_Line__c exOel : [SELECT Id, CurrencyISOCode, Line_Number__c FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = :oel.Order_Entry_Release__c])
        {
            if (exOel.Line_Number__c > maxOrderEntryLine)
            {
                maxOrderEntryLine = exOel.Line_Number__c;
            }
        }
        // 20180626 - Default to CurrencyISOCode of Header
        oel.CurrencyISOCode = oer.CurrencyISOCode; 
        oel.Line_Number__c = maxOrderEntryLine + 1;
        oel.Trigger_Source__c = 'UI';
        oel.Status__c = 'Draft';
        oel.Request_Date__c = oer.Request_Date__c;
        oel.Scheduled_Ship_Date__c = oer.Scheduled_Ship_Date__c;
        // JV - 20180308 - Added the following line
        oel.Promised_Date__c = oer.Promised_Date__c;
        
        oel.Use_Account_Shipping_Address__c = true;
        oel.Shipping_Account__c = oer.Shipping_Account__c;
        oel.Shipping_Address__c = oer.Shipping_Address__c;
        oel.Shipping_City__c = oer.Shipping_City__c;
        oel.Shipping_Country__c = oer.Shipping_Country__c;
        oel.Shipping_Name__c = oer.Shipping_Name__c;
        oel.Shipping_Postal_Code__c = oer.Shipping_Postal_Code__c;
        oel.Shipping_State_Province__c = oer.Shipping_State_Province__c;
        oel.Shipping_Street_1__c = oer.Shipping_Street_1__c;
        oel.Shipping_Street_2__c = oer.Shipping_Street_2__c;
        oel.Shipping_Street_3__c = oer.Shipping_Street_3__c;

        Integer i =0;
        
        // Version 4 - Changed to support BOTH SFDC and CPQ Quotes
        
        if (oer.Quote__c != null)
        {
            quoteSource = 'SFDC';
            // 20180626 - Added CurrencyISOCode to retrieved fields
            for (QuoteLineItem qli : [SELECT CurrencyISOCode, Product2Id FROM QuoteLineItem WHERE QuoteId = :oer.Quote__c])
            {
                if (i == 0)
                {
                    firstProductId = qli.Product2Id;
                }
                productIds.add(qli.Product2Id);
                product2QLMap.put(qli.Product2Id, qli.Id);  
                i++;            
            }
        }
        
        else
        {
            if (oer.CPQ_Quote__c != null)
            {
                quoteSource = 'CPQ';
                // 20180626 - Added CurrencyISOCode to retrieved fields
                for (SBQQ__QuoteLine__c qli : [SELECT CurrencyISOCode, SBQQ__Product__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :oer.CPQ_Quote__c])
                {
                    if (i == 0)
                    {
                        firstProductId = qli.SBQQ__Product__c;
                    }
                    productIds.add(qli.SBQQ__Product__c);
                    product2QLMap.put(qli.SBQQ__Product__c, qli.Id);  
                    i++;            
                }
            }           
        }
        if (oer.Quote__c == null && oer.CPQ_Quote__c == null){
            enablePicklist=false;
            if(developerName == Label.CSS_Hardware){
                enableCH=true;               
            }else if(developerName == Label.CSS_Software){
                enableSS=true;             
            }
        }else{
            enablePicklist=true;
            if(developerName == Label.CSS_Hardware){
                enableCH=true;               
            }else if(developerName == Label.CSS_Software){
                enableSS=true;             
            }
        }
        
        //Added additional filter product family - ENP Solutionz
        for (Product2 prd : [SELECT Id, Name, Product_SKU__c, ProductCode from Product2 where Id in :productIds AND Family in:productFamilyList])
        {
            availableProducts.put(prd.Id, prd);
        }  
        productSelections.add(new SelectOption('--None--','--None--'));
        for (Product2 prod : availableProducts.values())
        {
            if(prod.Product_SKU__c<>null){
                paddedSKU = prod.Product_SKU__c;
                while(paddedSKU.length() < 16)
                {
                    paddedSKU = paddedSKU + ' ';
                }
                paddedSKU = paddedSKU + Prod.name;
                productSelections.add(new SelectOption(String.valueOf(prod.Id), paddedSKU));     
                System.debug('SelectOption: ' + String.valueOf(prod.Id) + ' ' + paddedSKU);
            }         
        }              
    
    }
    //Added by - ENP Solutionz
    public list <SelectOption> getHeaderStatusList() {
        list <SelectOption> hStatus = new list <SelectOption>();
        //StateTransitionMap obj = StateTransitionMap();
        system.debug('@@@@oel.Status__c'+oel.Status__c);
        system.debug('@@@@developerName'+developerName);
        if(oel.status__c==null) 
            oel.status__c='Draft';
        hStatus = StateTransitionMap.getOELStatusSelections(oel.Status__c, developerName);
        system.debug('@@@@'+hStatus);
        return hStatus;      
    }

    public PageReference Save()
    {
        //Added by - ENP Solutionz
        System.debug('@@@##$$'+developerName);
        System.debug('@@@##$$'+oer.recordType.DeveloperName);
        if(developerName == Label.CSS_Software || developerName == Label.CSS_Hardware || developerName.contains('IGU')){          
            if((oer.recordType.DeveloperName!=developerName && !oer.recordType.DeveloperName.contains('IGU'))
                ||(developerName.contains('IGU') && !oer.recordType.DeveloperName.contains('IGU'))
                ||(!developerName.contains('IGU') && oer.recordType.DeveloperName.contains('IGU'))){                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Order Line\'s record type has to be the same as Order Header\'s record type'));
                return null;
            }            
        }
        
        //END - ENP Solutionz
        
        Database.SaveResult sr;
        if (selectedProduct == null && oel.Control_Hardware_Product__c == null && oel.Software_Product__c == null)
        {
            oel.Product__c = firstProductId;
        }
        else
        {
            if(String.valueOf(selectedProduct)!='--None--')
            oel.Product__c = String.valueOf(selectedProduct);
        }
        List<String> productIdList=new List<String>();
         if (selectedProduct == null || String.valueOf(selectedProduct) =='--None--'){
             if(enableCH){
                 oel.Product__c=oel.Control_Hardware_Product__c;
                 productIdList.add(oel.Control_Hardware_Product__c);
             }else if(enableSS){
                 System.debug('In enableCSS'+oel.Software_Product__c);
                 oel.Product__c=oel.Software_Product__c;
                 productIdList.add(oel.Software_Product__c);
             }
         }
        system.debug('@@@@'+productIdList);
        Map<String,String> productSKUMap=new Map<String,String>();
        for (Product2 prd : [SELECT Id, Name, Product_SKU__c, ProductCode from Product2 where Id in :productIdList])
        {
            productSKUMap.put(prd.Id, prd.Product_SKU__c);
        }
        System.debug('####'+productSKUMap); 
        if(enableCH){
            if(oel.Control_Hardware_Product__c!=null)
                oel.SKU__c=productSKUMap.get(oel.Control_Hardware_Product__c);
        }else if(enableSS){
            if(oel.Software_Product__c!=null)
                oel.SKU__c=productSKUMap.get(oel.Software_Product__c);
        }
        if(String.valueOf(selectedProduct)=='--None--'){
            selectedProduct=null;
        }
        if((oel.Control_Hardware_Product__c!=null && String.valueOf(selectedProduct)!=null)||(oel.Software_Product__c!=null && String.valueOf(selectedProduct)!=null)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, 'Both Product Fields cannot be selected at a time' ));
            return null;
        }
        
        
        if(quoteSource == 'SFDC'){
            oel.Quote_Line_Item__c = product2QLMap.get(oel.Product__c);
        }
        else{
            oel.CPQ_Quote_Line__c = product2QLMap.get(oel.Product__c);          
        }
        sr = Database.insert(oel,false);
        if (sr.isSuccess())
        {
            PageReference redirectSuccess = new ApexPages.StandardController(oer).view();   
            return (redirectSuccess);
        }
        else
        {
            for (Database.Error err : sr.getErrors())
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, err.getMessage() ));
            }
            return null;
        }

    }
    
    public List<SelectOption> getProductSelections()
    {
        return productSelections;
    }

    public pageReference updateShippingInfo()
    {
        return null;
    }

    
}