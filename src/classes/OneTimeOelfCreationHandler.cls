public class OneTimeOelfCreationHandler 
{
    
    public static void createOelf(Map<id,Shipment_Line__c> newMapSl, Map<Id,Shipment_Line__c> oldMapSl)
    {
        Map<String,Shipment_Line__c> updateSl = new Map<String,Shipment_Line__c>();
        Map<String,Shipment_Line__c> mapOfShipLine = new Map<String,Shipment_Line__c>();
        Map<String,Order_Entry_Line__c> mapOfOEL = new Map<String,Order_Entry_Line__c>();
        List<Order_Entry_Line__c>  getOel = new List<Order_Entry_Line__c>();
        List<Shipment_Line__c>  getShipment = new List<Shipment_Line__c>();
        List<Order_Entry_Line_Shipment__c> updatedOelShip = new List<Order_Entry_Line_Shipment__c>();
        List<Id> shipId = new List<Id>();
        List<Shipment__c> shipRec = new List<Shipment__c>();
        Map<Id,Shipment__c> shipInfo = new Map<Id,Shipment__c>();


        for(Shipment_Line__c sl : newMapSl.values())
        {
            Shipment_Line__c oldSl  = oldMapSl.get(sl.Id);

           // if((oldSl.Order_Entry_Line__c == null || oldSl.Order_Entry_Line__c == '') && (sl.Order_Entry_Line__c != null || sl.Order_Entry_Line__c != ''))
           if(sl.Order_Entry_Line__c != null && oldMapSl.get(sl.Id).Order_Entry_Line__c == null)
            {
                    updateSl.put(sl.Order_Entry_Line__c,sl);
                	shipId.add(sl.Shipment__c);
                    System.debug(' Shipment Order_Entry_Line__c '+updateSl.keySet());
            }

        }

            getOel = [Select id,Name,Quantity__c,Request_Date__c,Promised_Date__c,Scheduled_Ship_Date__c,Shipping_Address__c,Order_Entry_Release__c 
                        FROM Order_Entry_Line__c WHERE Name IN: updateSl.keySet()];

            getShipment = [Select id,Shipment__r.Delivery_Number__c,Shipment__r.Ship_Date__c,Order_Entry_Line__c,Shipped_Quantity__c,Tracking_Number__c,Ordered_Quantity__c,
                                Shipment_Line_External_Reference__c,Tracking_URL__c FROM Shipment_Line__c WHERE Order_Entry_Line__c IN: updateSl.keySet()];
        	
        	shipRec = [Select id,Delivery_Number__c,Ship_Date__c FROM Shipment__c where ID IN:shipId];
        	for(Shipment__c shipPut : shipRec)
            {
                shipInfo.put(shipPut.Id,shipPut);
            }
			
            for(Order_Entry_Line__c mapOel : getOel)
            {
                mapOfOEL.put(mapOel.Name,mapOel);
            }

            for(Shipment_Line__c mapShipLine : getShipment)
            {
                mapOfShipLine.put(mapShipLine.Order_Entry_Line__c,mapShipLine);
            }

		if(mapOfOEL.keySet().Size() > 0)
        {
        for(Shipment_Line__c insertSL : newMapSl.values())
        {
            System.debug(' Map of OEL '+ mapOfOEL.keySet());
            System.debug(' Map of Shipment Line '+mapOfShipLine.keySet());
            System.debug(' Map of OEL Name '+ mapOfOEL.get(insertSL.Order_Entry_Line__c).Name);
            System.debug(' Map of Shipment Line Name '+mapOfShipLine.get(insertSL.Order_Entry_Line__c).Order_Entry_Line__c);
            
            if(insertSL.Order_Entry_Line__c != null && insertSL.Order_Entry_Line__c == mapOfOEL.get(insertSL.Order_Entry_Line__c).Name &&
                                insertSL.Order_Entry_Line__c == mapOfShipLine.get(insertSL.Order_Entry_Line__c).Order_Entry_Line__c)
            {
                Order_Entry_Line_Shipment__c insertOEFLF = new Order_Entry_Line_Shipment__c();
                
                // from Shipment and Shipment Line 
                insertOEFLF.Quantity__c = insertSL.Shipped_Quantity__c;
                insertOEFLF.Shipment_Line_External_Reference__c  = insertSL.Shipment_Line_External_Reference__c;
                insertOEFLF.Open_Quantity__c = 0;
                insertOEFLF.Quantity_Shipped__c = insertSL.Shipped_Quantity__c;
                
                insertOEFLF.Shipment_Date__c = shipInfo.get(insertSL.Shipment__c).Ship_Date__c;
                insertOEFLF.Delivery_Number__c = shipInfo.get(insertSL.Shipment__c).Delivery_Number__c;
				               
                insertOEFLF.Tracking_Number__c = insertSL.Tracking_Number__c;
                insertOEFLF.Tracking_URL__c = insertSL.Tracking_URL__c;
				
                // Info from OEL 
                insertOEFLF.Order_Entry_Line__c = mapOfOEL.get(insertSL.Order_Entry_Line__c).Id;
                insertOEFLF.Shipping_Address__c = mapOfOEL.get(insertSL.Order_Entry_Line__c).Shipping_Address__c;
                insertOEFLF.Promised_Date__c = mapOfOEL.get(insertSL.Order_Entry_Line__c).Promised_Date__c;
                insertOEFLF.Request_Date__c = mapOfOEL.get(insertSL.Order_Entry_Line__c).Request_Date__c;
                insertOEFLF.Scheduled_Ship_Date__c = mapOfOEL.get(insertSL.Order_Entry_Line__c).Scheduled_Ship_Date__c;
                insertOEFLF.Status__c = 'Closed';
                updatedOelShip.add(insertOEFLF); 
                  
            }
        }
    }
        if(updatedOelShip.Size() > 0 && !updatedOelShip.isEmpty())
                //INSERT updatedOelShip;
        	Database.SaveResult[] lsr = Database.insert(updatedOelShip,false);
    }
}