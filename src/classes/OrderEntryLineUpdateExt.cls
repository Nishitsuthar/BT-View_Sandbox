public class OrderEntryLineUpdateExt 
{ 
    //
    // Version 2 - Incorporates Date Name Changes
    // - This version includes Address hack to get around deployment spurious error on Account.ShippingAddress
    //
    public Order_Entry_Line__c oel {get; set;}
    public List<Order_Entry_Line__c> orderEntryLines = new List<Order_Entry_Line__c>();
    public Order_Entry_Release__c oer;
    public String recordTypeName {get; set;}
    public Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>();
    public Boolean isIGUMetric {get; set;}
    public Boolean isIGUImperial {get; set;}
    public Boolean isIGU {get; set;}
    public Boolean showQuantity {get; set;}
    public Boolean inProduction = false;
    //Added by - ENP Solutionz
    public Boolean isCSSHardware {get; set;}
    public Boolean isCSSSWService {get; set;}
    public Boolean isCSS {get; set;}
    //public String productFamily;
    public String developerName;
    //END by - ENP Solutionz
    
    
    public OrderEntryLineUpdateExt(ApexPages.StandardController stdController) 
    {
        for (RecordType rt : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE SObjectType = 'Order_Entry_Line__c'])
        {
            recordTypeMap.put(rt.Id, rt);
        }
        oel = (Order_Entry_Line__c) stdController.getRecord();
        oel.Trigger_Source__c = 'UI';
        isIGUMetric = false;
        isIGUImperial = false;
        showQuantity = false;
        //Added by - ENP Solutionz
        isCSSHardware = false;
        isCSSSWService = false;
        isCSS = false; 
        ////END - ENP Solutionz
        recordTypeName = recordTypeMap.get(oel.RecordTypeID).Name;
        developerName = recordTypeMap.get(oel.RecordTypeID).DeveloperName;
        if (developerName == 'IGU_Imperial'){
            isIGUImperial = true;           
        }
        else if (developerName == 'IGU_Metric'){
                isIGUMetric = true;
        }        
        //Added by - ENP Solutionz
        else if (developerName == Label.CSS_Hardware){
                isCSSHardware = true;
                //productFamily = 'Service';
           
        }
        else if (developerName == Label.CSS_Software){
                isCSSSWService = true;
                //productFamily = 'Software';           
        }
        isCSS = isCSSSWService || isCSSHardware;
        //END - ENP Solutionz
        isIGU = isIGUImperial || isIGUMetric;
        showQuantity = !isIGU || oel.Status__c == 'Draft' || oel.Status__c == 'Pre-Release Review' || oel.Status__c == 'Confirmed';
        oer = [SELECT Name, Opportunity__c, System_of_Measurement__c, Shipping_Account__c, Shipping_City__c, Shipping_Country__c, Shipping_Name__c, 
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Street_1__c, Shipping_Street_2__c, Shipping_Street_3__c, Shipping_Address__c,
            Request_Date__c, Scheduled_Ship_Date__c, Quote__c, Status__c FROM Order_Entry_Release__c WHERE Id = :oel.Order_Entry_Release__c LIMIT 1];
    }
    
        
    //Added by - ENP Solutionz
    public list <SelectOption> getHeaderStatusList() {
        list <SelectOption> hStatus = new list <SelectOption>();
        //StateTransitionMap obj = StateTransitionMap();
        system.debug('@@@@oel.Status__c'+oel.Status__c);
        system.debug('@@@@developerName'+developerName);
        //if(oel.status__c==null) 
        //    oel.status__c='Draft';
        hStatus = StateTransitionMap.getOELStatusSelections(oel.Status__c, developerName);
        system.debug('@@@@'+hStatus);
        return hStatus;      
    }

    public pageReference updateShippingInfo()
    {
        AddressLines addrLines = new AddressLines();
        if (oel.Use_Account_Shipping_Address__c)
        {
            if (oel.Shipping_Account__c == null)
            {
                oel.Shipping_Address__c = null;
            }
            else
            {
//                Account shippingAccount = [SELECT Id, Name, ShippingAddress, BillingAddress FROM Account WHERE Id = :oel.Shipping_Account__c LIMIT 1];

                Account shippingAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity,
                    ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Id = :oel.Shipping_Account__c LIMIT 1];

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
                        addrLines.city = shippingAccount.BillingCity;
                        addrLines.stateProvince = shippingAccount.BillingState;
                        addrLines.postalCode = shippingAccount.BillingPostalCode;
                        addrLines.country = shippingAccount.BillingCountry;                       
                    }
                    else
                    {
                        addrLines = null;
                        oel.Shipping_Address__c = null;
                    }
                }
                if (addrLines != null) 
                {
                    oel.Shipping_Name__c = addrLines.Name;
                    oel.Shipping_Street_1__c = addrLines.street1;
                    oel.Shipping_Street_2__c = addrLines.street2;
                    oel.Shipping_Street_3__c = addrLines.street3;
                    oel.Shipping_City__c = addrLines.city;
                    oel.Shipping_State_Province__c = addrLines.stateProvince;
                    oel.Shipping_Postal_Code__c = addrLines.postalCode;
                    oel.Shipping_Country__c = AddressUtils.getStandardName(addrLines.Country);
                }
            }
        }
        else
        {
            addrLines = new AddressLines();
            addrLines.Name = oel.Shipping_Name__c;
            addrLines.street1 = oel.Shipping_Street_1__c;
            addrLines.street2 = oel.Shipping_Street_2__c;
            addrLines.street3 = oel.Shipping_Street_3__c;
            addrLines.city = oel.Shipping_City__c;
            addrLines.stateProvince = oel.Shipping_State_Province__c;
            addrLines.postalCode = oel.Shipping_Postal_Code__c;
            addrLines.country = AddressUtils.getStandardName(oel.Shipping_Country__c);
        }
        if (addrLines != null)
        {
            oel.Shipping_Address__c = AddressUtils.formatAddress(oel.Shipping_Name__c, addrLines, true);
        } 
        return null;
    }

    
}