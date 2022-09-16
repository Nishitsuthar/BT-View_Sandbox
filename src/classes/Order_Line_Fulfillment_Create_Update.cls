// Updated Date         Developer       Project             Tracking Id                             Requirement                         
// 30-July-2020         Bajrang         Project Concrete    CREATE_OELF_ON_SHIPMENT_LINE_ADD_UPD_01 New class creation for Create OELF records based on Shipment line quantity shipped and update tracking # and URL
// 03-Aug-2020 
public class Order_Line_Fulfillment_Create_Update
{
    
    public static void oerlFullFillment(List<Shipment_Line__c> shipLine){
        Map<String, Shipment_Line__c> oelRefFromShiLine = new Map<String, Shipment_Line__c>();
        Map<String,Order_Entry_Line__c> mapNewOelShip = new Map<String,Order_Entry_Line__c>(); 
        Set<String> shipDeliveryNumber = new Set<String>();
        List<Order_Entry_Line_Shipment__c> oelShipRecords = new List<Order_Entry_Line_Shipment__c>();
        List<Order_Entry_Line_Shipment__c> oelShipRecordsInsert = new List<Order_Entry_Line_Shipment__c>();
        List<Order_Entry_Line_Shipment__c> updateListOelShip = new List<Order_Entry_Line_Shipment__c>();
        List<Order_Entry_Line_Shipment__c> insertListOelShip = new List<Order_Entry_Line_Shipment__c>();
        List<Order_Entry_Line__c> insertOelFullList = new List<Order_Entry_Line__c>();
        Set<Id> oelIdForFull = new Set<id>();
        Set<Id> shipmentDelNo = new Set<Id>();
        set<string> oelidfur = new set<string>();
        Map<String,Shipment_Line__c> shipDateAndTrackingNum = new Map<String,Shipment_Line__c>();
        List<String> oelNames = new List<String>();
        List<Order_Entry_Line__c> oelData = new List<Order_Entry_Line__c>();
        
        for(Shipment_Line__c objshipline : shipLine){
            if(objshipline.Order_Entry_Line__c !=null){
                
                oelRefFromShiLine.put(objshipline.Order_Entry_Line__c, objshipline);
                shipmentDelNo.add(objshipline.Shipment__c);
                oelidfur.add(objshipline.Order_Entry_Line__c);
            }
        }
        List<Shipment_Line__c> shipInfoForDeliShiDate = [Select id, Order_Entry_Line__c,Shipment__r.Delivery_Number__c,Shipment__r.Ship_Date__c,Shipment__c from Shipment_Line__c 
                                                         WHERE Shipment__c IN: shipmentDelNo];
        for(Shipment_Line__c mapDeliShipDate : shipInfoForDeliShiDate)   
        {
            shipDateAndTrackingNum.put(mapDeliShipDate.Order_Entry_Line__c,mapDeliShipDate);
        }
        
        insertOelFullList = [Select id,Name,Promised_Date__c,Request_Date__c,Scheduled_Ship_Date__c,Shipping_Address__c from Order_Entry_Line__c 
                             WHERE Name IN : oelRefFromShiLine.keySet()];
        system.debug('insertOelFullList'+insertOelFullList);
        for(Order_Entry_Line__c insertNew : insertOelFullList){
            mapNewOelShip.put(insertNew.Name,insertNew);
        }
        System.debug(' Map **** '+mapNewOelShip);
        
        oelShipRecords = [Select id, Name, Order_Entry_Line__c, Shipment_Date__c, Order_Entry_Line__r.Name, Quantity_Shipped__c, Scheduled_Ship_Date__c, Open_Quantity__c, Quantity__c, Request_Date__c, Status__c, CreatedDate, Shipment_Line_External_Reference__c
                          from Order_Entry_Line_Shipment__c WHERE Order_Entry_Line__r.Name IN :oelRefFromShiLine.keySet() AND Status__c NOT IN ('Closed','Cancelled')];
        
        system.debug('oelShipRecords'+oelShipRecords);
        
        Map<String,Order_Entry_Line_Shipment__c> updatedOelShip = new Map<String,Order_Entry_Line_Shipment__c>();
        if(oelShipRecords.Size() > 0 )
            
        {  
            system.debug('enetrt 50');
            for (Order_Entry_Line_Shipment__c updateOelShip : oelShipRecords){
                updateOelShip.Quantity__c = oelRefFromShiLine.get(updateOelShip.Order_Entry_Line__r.Name).Shipped_Quantity__c;
                updateOelShip.Quantity_Shipped__c = oelRefFromShiLine.get(updateOelShip.Order_Entry_Line__r.Name).Shipped_Quantity__c;
                updateOelShip.Open_Quantity__c = 0;
                updateOelShip.Shipment_Line_External_Reference__c = oelRefFromShiLine.get(updateOelShip.Order_Entry_Line__r.Name).Shipment_Line_External_Reference__c;
                updateOelShip.Delivery_Number__c = shipDateAndTrackingNum.get(updateOelShip.Order_Entry_Line__r.Name).Shipment__r.Delivery_Number__c;
                updateOelShip.Shipment_Date__c = Date.valueOf(shipDateAndTrackingNum.get(updateOelShip.Order_Entry_Line__r.Name).Shipment__r.Ship_Date__c);
                updateOelShip.Tracking_Number__c = oelRefFromShiLine.get(updateOelShip.Order_Entry_Line__r.Name).Tracking_Number__c;
                updateOelShip.Tracking_URL__c = oelRefFromShiLine.get(updateOelShip.Order_Entry_Line__r.Name).Tracking_URL__c;
                updateOelShip.Status__c = 'Closed';
                updatedOelShip.put(updateOelShip.Order_Entry_Line__r.Name,updateOelShip);
                
            }
            system.debug('updatedOelShip'+updatedOelShip);
            if (updatedOelShip.Size() > 0)
                UPDATE updatedOelShip.values();
            
            
        }
        
        Map<String,Shipment_Line__c> noOelf = new Map<String,Shipment_Line__c>();
        for(Shipment_Line__c shlToOelFull : shipLine)
        {
            if(!mapNewOelShip.containsKey(shlToOelFull.Order_Entry_Line__c))
            {
              noOelf.put(shlToOelFull.Order_Entry_Line__c,shlToOelFull);  
            }
            
            if((shlToOelFull.Order_Entry_Line__c != null && mapNewOelShip.containsKey(shlToOelFull.Order_Entry_Line__c)) && (shlToOelFull.Order_Entry_Line__c == mapNewOelShip.get(shlToOelFull.Order_Entry_Line__c).Name))
            {
                if((updatedOelShip.keyset().size()>0 && shlToOelFull.Shipment_Line_External_Reference__c != updatedOelShip.get(shlToOelFull.Order_Entry_Line__c).Shipment_Line_External_Reference__c)
                   || updatedOelShip.keyset().size() == 0)
                {
                    
                    Order_Entry_Line_Shipment__c insertNewOelFull = new Order_Entry_Line_Shipment__c();
                    insertNewOelFull.Quantity__c = shlToOelFull.Ordered_Quantity__c;
                    insertNewOelFull.Quantity_Shipped__c = shlToOelFull.Shipped_Quantity__c;
                    insertNewOelFull.Open_Quantity__c = 0;
                    insertNewOelFull.Shipment_Date__c = Date.ValueOf(shipDateAndTrackingNum.get(shlToOelFull.Order_Entry_Line__c).Shipment__r.Ship_Date__c);   
                    insertNewOelFull.Delivery_Number__c = shipDateAndTrackingNum.get(shlToOelFull.Order_Entry_Line__c).Shipment__r.Delivery_Number__c;
                    insertNewOelFull.Shipment_Line_External_Reference__c = shlToOelFull.Shipment_Line_External_Reference__c;
                    insertNewOelFull.Tracking_Number__c = shlToOelFull.Tracking_Number__c;
                    insertNewOelFull.Tracking_URL__c = shlToOelFull.Tracking_URL__c;
                    insertNewOelFull.Status__c = 'Closed';
                    insertNewOelFull.Promised_Date__c = mapNewOelShip.get(shlToOelFull.Order_Entry_Line__c).Promised_Date__c;
                    insertNewOelFull.Request_Date__c = mapNewOelShip.get(shlToOelFull.Order_Entry_Line__c).Request_Date__c;
                    insertNewOelFull.Scheduled_Ship_Date__c = mapNewOelShip.get(shlToOelFull.Order_Entry_Line__c).Scheduled_Ship_Date__c;
                    insertNewOelFull.Shipping_Address__c = mapNewOelShip.get(shlToOelFull.Order_Entry_Line__c).Shipping_Address__c;
                    insertNewOelFull.Order_Entry_Line__c = mapNewOelShip.get(shlToOelFull.Order_Entry_Line__c).Id;
                    
                    insertListOelShip.add(insertNewOelFull);
                } 
            }
        }
        if(insertListOelShip.Size() > 0)
            INSERT insertListOelShip;
        
        system.debug('updatedOelShip98'+updatedOelShip);
        String jsonString = json.serialize(oelidfur);
        system.debug('jsonString'+jsonString);
        oelFulfillmentFuture.toCreateOelFulfillment(jsonString);
        
        if(!noOelf.isEmpty())
        {
            List<SmartSheet_Exceptions__c> insertExcep = new List<SmartSheet_Exceptions__c>();
            for(Shipment_Line__c shL : noOelf.values())
            {
                SmartSheet_Exceptions__c shLineExce = new SmartSheet_Exceptions__c();
                if(shL.Order_Entry_Line__c != null)
                    shLineExce.Error_Message__c = 'The OEL reference on the Shipment Line does not exist in OEL Object';
                else
                shLineExce.Error_Message__c = 'The OEL reference on the Shipment Line is Blank';
                shLineExce.Shipment_Line_Id__c = shL.Id;
                shLineExce.Order_Entry_Line_Reference__c = shL.Order_Entry_Line__c;
                shLineExce.RecordTypeId = Schema.SObjectType.SmartSheet_Exceptions__c.getRecordTypeInfosByName().get('Shipment Line Exception').getRecordTypeId();
                insertExcep.add(shLineExce);
                
            }
            Insert insertExcep;
            
        }       
    }
    // Update OEL Fulfillment when their is change in the Tracking Number, Tracking URL 
    public static void updateOelFullMent(Map<Id,Shipment_Line__c> newMapSl, Map<Id,Shipment_Line__c> oldMapSl)
    {
        
        List<Order_Entry_Line_Shipment__c> oelFull = new List<Order_Entry_Line_Shipment__c>();
        List<Order_Entry_Line_Shipment__c> udURLnumber = new List<Order_Entry_Line_Shipment__c>();
        Map<String,Shipment_Line__c> slerMap = new Map<String,Shipment_Line__c>();
        
        for(Shipment_Line__c newShipL : newMapSl.values())
        {
            Shipment_Line__c oldShipL = oldMapSl.get(newShipL.Id);
            if(newShipL.Tracking_Number__c != oldShipL.Tracking_Number__c 
               || newShipL.Tracking_URL__c != oldShipL.Tracking_URL__c
               || newShipL.Shipped_Quantity__c != oldShipL.Shipped_Quantity__c
              )
            {
                
                slerMap.put(newShipL.Shipment_Line_External_Reference__c,newShipL);
                
            }
        }
        
        oelFull = [Select id,Tracking_Number__c,Tracking_URL__c,Shipment_Line_External_Reference__c,Order_Entry_Line__r.Name,Delivery_Number__c, Quantity_Shipped__c,Quantity__c
                   FROM Order_Entry_Line_Shipment__c
                   WHERE Shipment_Line_External_Reference__c IN : slerMap.keySet() AND Shipment_Line_External_Reference__c != NULL];
        for(Order_Entry_Line_Shipment__c updateOelFull : oelFull)
        {
            if(slerMap.containsKey(updateOelFull.Shipment_Line_External_Reference__c))
            {
                if(slerMap.get(updateOelFull.Shipment_Line_External_Reference__c).Shipment_Line_External_Reference__c == updateOelFull.Shipment_Line_External_Reference__c)
                {
                    updateOelFull.Tracking_URL__c = slerMap.get(updateOelFull.Shipment_Line_External_Reference__c).Tracking_URL__c;
                    updateOelFull.Tracking_Number__c  = slerMap.get(updateOelFull.Shipment_Line_External_Reference__c).Tracking_Number__c;
                    updateOelFull.Quantity_Shipped__c = slerMap.get(updateOelFull.Shipment_Line_External_Reference__c).Shipped_Quantity__c;
                    updateOelFull.Quantity__c = slerMap.get(updateOelFull.Shipment_Line_External_Reference__c).Shipped_Quantity__c;
                    udURLnumber.add(updateOelFull);
                }
            }  
        }
        if(udURLnumber.Size() > 0 && udURLnumber != NULL)
            UPDATE udURLnumber;
    }
}