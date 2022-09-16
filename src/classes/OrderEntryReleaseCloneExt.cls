public class OrderEntryReleaseCloneExt 
{ 
    //
    // JV - 20171116 Removed the following fields from the clone query: Oracle_Sales_Order_Id__c, ODKey__c, Original_Sales_Order__c,
    //      Release_Date__c, Scheduled_Ship_Date__c
    // JV - 20180628 - Added CPQ_Quote__c, Payment_Terms__c and CurrencyISOCode to cloned fields
    // 
    public Order_Entry_Release__c oldOER;
    public Order_Entry_Release__c newOER;
    public Map<Id, Order_Entry_Release__c> oerMap = new Map<id, Order_Entry_Release__c>();
    public Integer maxOERNumber = 1;
    public Integer oerNum;
    public String oerNumStr;
    
    public OrderEntryReleaseCloneExt(ApexPages.StandardController stdController) 
    {
        oldOER = (Order_Entry_Release__c) stdController.getRecord();
    }
    
    public PageReference cloneOER()
    {
        oldOer = [SELECT Id, Name, Billing_Account__c, Billing_Address__c, 
            Billing_City__c, Billing_Contact__c, Billing_Country__c, Billing_Name__c, Billing_Postal_Code__c, 
            Billing_State_Province__c, Billing_Street_1__c, Billing_Street_2__c, Billing_Street_3__c, 
            Customer_P_O_Number__c, Freight__c, Opportunity__c,CPQ_Quote__c, CurrencyISOCode, Payment_Terms__c,
            Order_Entry_Release_Date__c, Order_Type__c, Packing_Instructions__c, 
            Project_ID__c, Project_Manager__c, Quote__c, Release_Name__c, Sales_Executive__c,  
            Shipping_Account__c, Shipping_Address__c, Shipping_City__c, Shipping_Contact__c, 
            Shipping_Country__c, Shipping_Name__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Street_1__c, 
            Shipping_Street_2__c, Shipping_Street_3__c, Sold_to_Account__c, Sold_to_Address__c, Sold_to_City__c, 
            Sold_to_Contact__c, Sold_to_Country__c, Sold_to_Postal_Code__c, Sold_to_State_Province__c, Sold_to_Street_1__c, 
            Sold_to_Street_2__c, Sold_to_Street_3__c,System_of_Measurement__c,RecordType.DeveloperName FROM Order_Entry_Release__c 
            WHERE Id = :oldOER.id LIMIT 1];
        for (Order_Entry_Release__c oer : [SELECT Id, name, Release_Name__c FROM Order_Entry_Release__c 
            WHERE Opportunity__c = :oldOER.Opportunity__c])
        {
            oerMap.put(oer.Id, oer);
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
        newOER = oldOER.clone(false,false);
        newOER.name = oldOER.name.SubStringBeforeLast('-') + '-' + oerNumStr;
        newOER.Release_Name__c = 'Cloned from ' + oldOER.name;
        newOER.Status__c = 'Draft'; 
        newOER.Order_Type__c ='Standard';       
        newOER.Trigger_Source__c = 'UI';
        newOER.Order_Entry_Release_Date__c = System.today();
        insert newOER;
        PageReference editPageRef = new PageReference('/apex/OrderEntryReleaseEdit?ID=' + String.valueOf(newOER.Id));
        editPageRef.getParameters().put('isClone','true');
        editPageRef.getParameters().put('clonedId', String.valueOf(oldOER.Id));
       
        editPageRef.setRedirect(true);
        return editPageRef;  
    }        
}