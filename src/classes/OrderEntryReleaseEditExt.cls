public class OrderEntryReleaseEditExt 
{ 
    // Version 4.3 includes
    //    - Fix for bug causing duplicate Order Entry Release Names
    //    - 20180621 - Added code to initialize CurrencyISOCode
    //    - 20180621 - Added code to fix bug with Cancellation while creating new record
    // Version 4.2 included: 
    //    - code to support cloning the Release
    //    - addition of BillingPostalCode to address fields
    //    - address hack to get around deployment spurious error on Account.ShippingAddress
    //
    public Opportunity oppty;
    List<Customer_Purchase_Order__c> cPOList = new List<Customer_Purchase_Order__c>();
    public List<Order_Entry_Release__c> existingOERList = new List<Order_Entry_Release__c>();
    public Order_Entry_Release__c oer{get;set;}
    public Boolean newRecord = false;
    public Boolean isClone = false;
    public String clonedID;
    public String developerName;
    //public String recordTypeName {get; set;}
    public final String recordTypeName{get; private set;}
    public Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>();
    public Boolean isCSSHardware {get; set;}
    public Boolean isCSSSWService {get; set;}
    public Boolean isCSS {get; set;}
    public Id oerRecordTypeId;
    
    
    
    public OrderEntryReleaseEditExt(ApexPages.StandardController stdController) 
    {
        //Added by ENP Solutionz - START
        for (RecordType rt : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE SObjectType = 'Order_Entry_Release__c']){
            recordTypeMap.put(rt.Id, rt);
        }
        //Added by ENP Solutionz - END
        
        oer = (Order_Entry_Release__c) stdController.getRecord();
        system.debug('@@@'+oer);
        //Added by ENP Solutionz - START
        isCSSHardware = false;
        isCSSSWService = false;
        isCSS = false;        
        
        
        if(oer.id==null){
            oerRecordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
        }
        else {        
            oerRecordTypeId=oer.RecordTypeId;        
        }
        oer.RecordTypeID = oerRecordTypeId;
        recordTypeName = recordTypeMap.get(oerRecordTypeId).Name;
        developerName = recordTypeMap.get(oerRecordTypeId).DeveloperName;
        if(oer.id != NULL && oer.MES_Routing__c == NULL)
            oer.MES_Routing__c = 'POP';
        system.debug('@@@@developerName'+developerName);
        if (developerName == Label.CSS_Hardware)
        {
            isCSSHardware = true;                       
        }
        else if (developerName == Label.CSS_Software){
                isCSSSWService = true;                
        }
        system.debug('@@@@isCSSHardware'+isCSSHardware);
        system.debug('@@@@isCSSSWService'+isCSSSWService);
        
        isCSS = isCSSSWService || isCSSHardware ;
        
        //End Here - ENP Solutionz
        
        // JV - 20171102 The following if... statement was added to support the clone function
        if (ApexPages.currentPage().getParameters().containsKey('isClone') && 
            ApexPages.currentPage().getParameters().get('isClone') == 'true')
        {
            isClone = true;
            clonedId = ApexPages.currentPage().getParameters().get('clonedId');
        }
        oppty = [SELECT Id, CurrencyISOCode, Name, OwnerId, Project_Manager__c, Opportunity_Id__c FROM Opportunity where Id = :oer.Opportunity__c];
        if (oer.Name == null)
        {
            newRecord = true;  oer.Name = formatName();
            oer.Project_Manager__c = oppty.Project_Manager__c;                  
            oer.Sales_Executive__c = oppty.OwnerId;
            oer.CurrencyISOCode = oppty.CurrencyISOCode;             
        }
        if (oer.Release_Name__c == null)
        {
            oer.Release_Name__c = 'My release name';
        }
        oer.Trigger_Source__c = 'UI';   
    }
    
    public list <SelectOption> getHeaderStatusList() {
        list <SelectOption> hStatus = new list <SelectOption>();
        //StateTransitionMap obj = StateTransitionMap();
        system.debug('@@@@oer.Status__c'+oer.Status__c);
        system.debug('@@@@developerName'+developerName);
        if(oer.status__c==null || isClone) {
            oer.status__c='Draft';
            hStatus.add(new SelectOption('Draft','Draft'));
        }
        else
        hStatus = StateTransitionMap.getOERStatusSelections(oer.Status__c, developerName);
        system.debug('@@@@'+hStatus);
        return hStatus;      
    }
    
    
    
    // JV - 20180306 - Replaced the formatName method to correct problem creating duplicate Names
    //      when intervening Releases have been deleted
    //
    public String formatName()
    {
        Integer maxOERNumber = 0;
        Integer oerNum;
        String oerNumStr;

        for (Order_Entry_Release__c oer : [SELECT Id, CurrencyISOCode, name, Release_Name__c FROM Order_Entry_Release__c 
            WHERE Opportunity__c = :oer.Opportunity__c])
        {
            oerNumStr = oer.Name.SubStringAfterLast('-');
            if (oerNumStr != null)
            { 
                oerNum = Integer.valueOf(oerNumStr);
                if (oerNum > maxOERNumber) maxOERNumber = oerNum;
            }
        }
        maxOERNumber++;
        oerNumStr = String.valueOf(maxOERNumber);
        if (oerNumStr.length() == 1)
        {
            oerNumStr= '00' + oerNumStr;
        }
        else
        {
            if (oerNumStr.length() == 2)
            {
                oerNumStr = '0' + oerNumStr;
            }
        }
        return oppty.Opportunity_Id__c + '-' + oerNumStr;

    }
    
    
    public PageReference updateShippingAddress()
    {
        // Address hack
        AddressLines addrLines = new AddressLines();

        if (oer.Shipping_Account__c == null)
        {
            system.debug('@@ship'+oer.Shipping_Account__c);
            oer.Shipping_Address__c = null;
        }
        else
        { 
            // Address Hack - Using Address component field instead of address
            system.debug('@@shipelse'+oer.Shipping_Account__c);
            Account shippingAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ShippingStreet, ShippingCity,
                ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Id = :oer.Shipping_Account__c LIMIT 1];

            if (shippingAccount.ShippingStreet != null || shippingAccount.ShippingCity != null)
            {
                addrLines.name = shippingAccount.Name;
                addrLines.street1 = shippingAccount.ShippingStreet;
                addrLines.city = shippingAccount.ShippingCity;
                addrLines.stateProvince = shippingAccount.ShippingState;
                addrLines.postalCode = shippingAccount.ShippingPostalCode;
                addrLines.country = shippingAccount.ShippingCountry;
            }
            else
            {
                if (shippingAccount.BillingCity != null || shippingAccount.BillingStreet != null)
                {
                    addrLines.name = shippingAccount.Name;
                    addrLines.street1 = shippingAccount.BillingStreet;
                    addrLines.city = shippingAccount.ShippingCity;
                    addrLines.stateProvince = shippingAccount.BillingState;
                    addrLines.postalCode = shippingAccount.BillingPostalCode;
                    addrLines.country = shippingAccount.BillingCountry;                       
                }
                else
                {
                    addrLines = null;
                    oer.Shipping_Address__c = null;
                }
            } // End of Address Hack

         
            if (addrLines != null) 
            {
                oer.Shipping_Name__c = addrLines.Name;
                oer.Shipping_Street_1__c = addrLines.street1;
                oer.Shipping_Street_2__c = addrLines.street2;
                oer.Shipping_Street_3__c = addrLines.street3;
                oer.Shipping_City__c = addrLines.city;
                oer.Shipping_State_Province__c = addrLines.stateProvince;
                oer.Shipping_Postal_Code__c = addrLines.postalCode;
                oer.Shipping_Country__c = AddressUtils.getStandardName(addrLines.Country);
            }
        }
        return null;
    }

    public PageReference updateBillingAddress()
    {
        return null;
    }
    
    public PageReference cancel()
    {
        // JV - 20171102 This method was added to support the clone function
   
        if (isClone)
        {
            delete oer;
            return new PageReference ('/' + clonedId);
        }
        // JV - 20180621 Added the following statement to correct problem with 
        // cancelling with creating new OER
        if (newRecord)
        {
            return new PageReference('/' + String.valueOf(oppty.ID));
        }
        return new PageReference('/' + String.valueOf(oer.ID));        
    }

    
}