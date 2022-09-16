/*********************************************************************
Project Concrete
Class:OelShipmentDetails
Description: This class is used to create and updated the OEL Fullfiment
- when a OEL is loaded or created it will create a new OEL Fullfilment with method - oelShipmentDetailsInsert
- When a OEL Quantity is changed from Oracle - updateOerShipQuantity is called and the Open OEL Fullfilment will be updated with the correct open quantity
- When a OEL field values are changed Request Date, Promise Date, Scheduled Ship Date, Shipment date are changed it will update the open OEL Fullfilment record
**********************************************************************/

public class OelShipmentDetails {
    
    public static void oelShipmentDetailsInsert(List<Order_Entry_Line__c> newlist)
    {
        List<Order_Entry_Line__c> oelData = new List<Order_Entry_Line__c>();
        List<Order_Entry_Line_Shipment__c> oelShip = new List<Order_Entry_Line_Shipment__c>();
        Map<Id, OrderEntryReleaseWrapper> oerWrapperMap = new Map<Id, OrderEntryReleaseWrapper>();
        
        
        for(Order_Entry_Line__c oerl : newlist)
        {
            Order_Entry_Line_Shipment__c oershipInsert = new Order_Entry_Line_Shipment__c();
            oershipInsert.Order_Entry_Line__c = oerl.Id;
            oershipInsert.Quantity_Shipped__c = oerl.Quantity_Shipped__c;
            oershipInsert.Scheduled_Ship_Date__c =oerl.Scheduled_Ship_Date__c;
            oershipInsert.Quantity__c = oerl.Quantity__c;
            oershipInsert.Request_Date__c = oerl.Request_Date__c;
            oershipInsert.Status__c = 'Open';
            oershipInsert.Open_Quantity__c = oerl.Quantity__c;
            oershipInsert.Promised_Date__c = oerl.Promised_Date__c;
            oershipInsert.Shipping_Address__c= oerl.Shipping_Address__c;
            //oershipInsert.Shipment_Id__c = '12334455';
            oelShip.add(oershipInsert);  
        }
        if(oelShip != null && oelShip.Size() >0)
            INSERT oelShip;
        
    }
    
    public static void updateOerShipQuantity(Map<id,Order_Entry_Line__c> newMapOel, Map<id,Order_Entry_Line__c> oldMapOel)
    {
        Set<id> oelShipIds = new Set<id>();
        List<id> oelShipIdsAggId = new List<id>();
        List<Order_Entry_Line_Shipment__c> updateShimentDetails = new List<Order_Entry_Line_Shipment__c>();
        List<Order_Entry_Line_Shipment__c> insertShimentDetails = new List<Order_Entry_Line_Shipment__c>();
        Boolean quantityChaged;
        Decimal newQuantity = 0;
        Boolean oelfCancel = False;
        Decimal openQuantity = 0;
        Boolean oelFieldChanged;
        Map<Id,Decimal> rollupQu = new map<Id,Decimal>();
        System.debug('OEL for Shipment '+newMapOel.values());
        System.debug('OEL for Shipment '+oldMapOel.values());
        
        for(Order_Entry_Line__c compQuan : newMapOel.values())
        {
            oelShipIdsAggId.add(compQuan.id);
        }
        AggregateResult[] groupedResultsRoll = [select Order_Entry_Line__c, sum(Quantity_Shipped__c)sumQ,min(Status__c) from Order_Entry_Line_Shipment__c 
                                                WHERE Status__c = 'Closed' AND Order_Entry_Line__c IN :oelShipIdsAggId Group by Order_Entry_Line__c ];
        if(groupedResultsRoll.Size() >= 1)
        {
            for(AggregateResult arQu : groupedResultsRoll)
            {
                if((Decimal)arQu.get('sumQ') == null)
                {
                    rollupQu.put(((string)arQu.get('Order_Entry_Line__c')),0);
                    
                }
                else{
                    rollupQu.put(((string)arQu.get('Order_Entry_Line__c')),((Decimal)arQu.get('sumQ')));
                }
            }
        }                            
        
        for(Order_Entry_Line__c compQuan : newMapOel.values())
        {   
            System.debug('OELF Cancel '+ compQuan.Status__c);
            if((compQuan.Status__c.containsIgnoreCase('Cancel')))
            {
                oelfCancel = True;
                //oelShipIds.add(compQuan.id);
                //System.debug('New Line Status '+ compQuan.Status__c);
            }
            if(compQuan.Quantity__c != oldMapOel.get(compQuan.id).Quantity__c && oldMapOel.get(compQuan.id).Quantity__c != null) 
            {
                quantityChaged = True;
                newQuantity = compQuan.Quantity__c;
                oelShipIds.add(compQuan.id);
                
            } 
            
            
            Order_Entry_Line__c oldOel = oldMapOel.get(compQuan.id);
            if(compQuan.Request_Date__c != oldOel.Request_Date__c || compQuan.Promised_Date__c != oldOel.Promised_Date__c || 
               compQuan.Scheduled_Ship_Date__c != oldOel.Scheduled_Ship_Date__c ||compQuan.Shipping_Address__c !=oldOel.Shipping_Address__c)
            {
                oelShipIds.add(compQuan.id);
                oelFieldChanged = True;
                System.debug('Field Changed ');
            }
        }
        System.debug(' OEL ID '+oelShipIds);
        System.debug(' Change in OEL Quantity '+quantityChaged);
        
        List<Order_Entry_Line_Shipment__c> updateOerlshipOpen = new List<Order_Entry_Line_Shipment__c>();
        Map<Id,Order_Entry_Line__c> updateNewMap = new Map<Id,Order_Entry_Line__c>();
        
        
        updateOerlshipOpen = [Select id,Shipment_Date__c,Shipping_Address__c,Quantity_Shipped__c,Order_Entry_Line__c,Scheduled_Ship_Date__c,Open_Quantity__c,Quantity__c,Request_Date__c,Status__c 
                              from Order_Entry_Line_Shipment__c WHERE Order_Entry_Line__c IN : oelShipIds AND Status__c !='Closed'];
        // AND Order_Entry_Line__r.Status__c !='Cancellation Requested'];
        
        for(Order_Entry_Line__c updateOerlShip1 : newMapOel.values())
        {
            updateNewMap.put(updateOerlShip1.Id, updateOerlShip1);
        }
        
        for(Order_Entry_Line_Shipment__c updateNotClosedShip : updateOerlshipOpen)
        {
            if(oelFieldChanged == True)
            {
                updateNotClosedShip.Scheduled_Ship_Date__c = updateNewMap.get(updateNotClosedShip.Order_Entry_Line__c).Scheduled_Ship_Date__c;
                updateNotClosedShip.Request_Date__c = updateNewMap.get(updateNotClosedShip.Order_Entry_Line__c).Request_Date__c;
                updateNotClosedShip.Promised_Date__c = updateNewMap.get(updateNotClosedShip.Order_Entry_Line__c).Promised_Date__c; 
                updateNotClosedShip.Shipping_Address__c=updateNewMap.get(updateNotClosedShip.Order_Entry_Line__c).Shipping_Address__c;
            }
            
            if(quantityChaged == True)
            {   
                if(rollupQu.get(String.valueOf(updateNotClosedShip.Order_Entry_Line__c)) == null)
                {
                    updateNotClosedShip.Quantity__c = newQuantity;
                    updateNotClosedShip.Open_Quantity__c = newQuantity;
                }
                else {
                    updateNotClosedShip.Quantity__c = newQuantity - rollupQu.get(String.valueOf(updateNotClosedShip.Order_Entry_Line__c));
                    updateNotClosedShip.Open_Quantity__c = newQuantity - rollupQu.get(String.valueOf(updateNotClosedShip.Order_Entry_Line__c));
                }
            
                if(updateNotClosedShip.Quantity__c == 0 && updateNotClosedShip.Open_Quantity__c == 0){
                	updateNotClosedShip.Status__c = 'Cancelled';
                } 
                
                if(updateNotClosedShip.Quantity__c == updateNotClosedShip.Open_Quantity__c && updateNotClosedShip.Open_Quantity__c != 0){
                    updateNotClosedShip.Status__c = 'Open';
                }
                
                
            }
            if(oelfCancel == True)
            {
                updateNotClosedShip.Status__c = 'Cancelled';
                updateNotClosedShip.Quantity__c= updateNewMap.get(updateNotClosedShip.Order_Entry_Line__c).Open_Quantity__c;
                updateNotClosedShip.Open_Quantity__c= updateNewMap.get(updateNotClosedShip.Order_Entry_Line__c).Open_Quantity__c;
            }
            
            updateShimentDetails.add(updateNotClosedShip);
        }
        
        if(updateShimentDetails != null && updateShimentDetails.Size() > 0)
            UPDATE updateShimentDetails;
    }
    
    
}