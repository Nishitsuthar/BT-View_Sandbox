// 06-Jan-2021			Srikanth		DealDesk SOP Findinds DD_SOP_Findings_Jan_2021			DealDesk SOP Findings
public class RefreshAccountAddressCtrl {
    
    @AuraEnabled
    public static string verifyOERStatus(string recordid, boolean shipping, boolean billing )
    {  
        Set<String> refreshNotAllowed = new Set<String> { 'Confirmation Requested', 'Integration Requested', 
            'Cancellation Requested', 'Cancelled', 'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested', 'Cancellation Integration Requested', 'Cancellation Confirmed',
             'Change Confirmation Requested','Change Integration Requested','Partially Shipped', 'Shipped','Integration Error'};
                
        Set<String> refreshNotAllowedCSS= new Set<String> {'Integration Requested','Confirmation Requested','Confirmed',
            'Cancellation Requested', 'Cancelled', 'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested','Cancellation Integration Requested', 'Cancellation Confirmed',
            'Change Confirmation Requested','Change Integration Requested', 'Approval to Ship Requested','Partially Shipped','Shipped','Integration Error'};
                        
    	Order_Entry_Release__c oer = [SELECT RecordType.developername,Status__c FROM Order_Entry_Release__c WHERE Id = :recordid LIMIT 1];
        
        if ((oer.RecordType.developername !=Label.CSS_Hardware && refreshNotAllowed.contains(oer.Status__c)) || 
            (oer.RecordType.developername ==Label.CSS_Hardware && refreshNotAllowedCSS.contains(oer.Status__c)))
            return 'error';     
        else
            return 'success';
    }
    
    @AuraEnabled
    public static string updateAccount(string recordid, boolean soldto, boolean billing )
    {
        AddressLines addrLines;
        Boolean addressChanged = false;
        system.debug('6666'+recordid+soldto+billing);
        Order_Entry_Release__c oe = [select id,name,
                                     Sold_to_Account__c,Sold_to_Account__r.Name,Sold_to_Address__c,Sold_to_Street_1__c,Sold_to_Street_2__c,Sold_to_Street_3__c,Sold_to_City__c,Sold_to_State_Province__c,Sold_to_Postal_Code__c,Sold_to_Country__c,
                                     Billing_Account__c,Billing_Account__r.Name,Billing_Address__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c, Billing_City__c,Billing_State_Province__c,Billing_Postal_Code__c, Billing_Country__c,
                                     Shipping_Account__c,Shipping_City__c,Shipping_Country__c,Shipping_Postal_Code__c,Shipping_State_Province__c,Shipping_Street_1__c,Shipping_Street_2__c,Shipping_Street_3__c,Trigger_Source__c
                                     from Order_Entry_Release__c where id=:recordid];
        Account soldToacc =[select id,name,BillingAddress,Billing_Address__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode from Account where id=:oe.Sold_to_Account__c];
        Account billacc=[select id,name,BillingAddress,Billing_Address__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode from Account where id=:oe.Billing_Account__c];
        system.debug('6666'+soldToacc+'ss'+billacc); 
        if(soldto==True)
        {
            oe.Sold_to_Address__c = AddressUtils.formatAddress(oe.Sold_to_Account__r.Name, soldToacc.BillingAddress);
            
            addrLines = new AddressLines(oe.Sold_to_Account__r.Name,soldToacc.BillingAddress);
            if (oe.Sold_to_Street_1__c != addrLines.street1 || oe.Sold_to_Street_2__c != addrLines.street2 || oe.Sold_to_Street_3__c != addrLines.street3 ||
               oe.Sold_to_City__c != addrLines.city || oe.Sold_to_State_Province__c != addrLines.stateProvince || oe.Sold_to_Country__c != AddressUtils.getStandardName(addrLines.country))
                addressChanged = true;
            
            oe.Sold_to_Street_1__c = addrLines.street1;
            oe.Sold_to_Street_2__c = addrLines.street2;
            oe.Sold_to_Street_3__c = addrLines.street3;
            oe.Sold_to_City__c = addrLines.city;
            oe.Sold_to_State_Province__c = addrLines.stateProvince;
            oe.Sold_to_Postal_Code__c = addrLines.postalCode;
            oe.Sold_to_Country__c = AddressUtils.getStandardName(addrLines.country);
        }
        
        if(billing==True)
        {
            oe.Billing_Address__c = AddressUtils.formatAddress(oe.Billing_Account__r.Name, billacc.BillingAddress);
            
            addrLines = new AddressLines(oe.Billing_Account__r.Name,billacc.BillingAddress);
            if (oe.Billing_Street_1__c != addrLines.street1 ||
                oe.Billing_Street_2__c != addrLines.street2 ||
                oe.Billing_Street_3__c != addrLines.street3 ||
                oe.Billing_City__c != addrLines.city ||
                oe.Billing_State_Province__c != addrLines.stateProvince ||
                oe.Billing_Postal_Code__c != addrLines.postalCode ||
                oe.Billing_Country__c != AddressUtils.getStandardName(addrLines.country))
            	addressChanged = true; 
            
            oe.Billing_Street_1__c = addrLines.street1;
            oe.Billing_Street_2__c = addrLines.street2;
            oe.Billing_Street_3__c = addrLines.street3;
            oe.Billing_City__c = addrLines.city;
            oe.Billing_State_Province__c = addrLines.stateProvince;
            oe.Billing_Postal_Code__c = addrLines.postalCode;
            oe.Billing_Country__c = AddressUtils.getStandardName(addrLines.country);
            
        }
        if (addressChanged)
        	oe.Trigger_Source__c = 'UI';

        try {
            update oe;   
            system.debug('Successfully Updated Address');
            return 'success';
            
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
            //return e.getMessage();   
        }
    }
}