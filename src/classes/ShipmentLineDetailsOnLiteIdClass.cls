public without sharing class ShipmentLineDetailsOnLiteIdClass {
    
	public static void updateLiteIdDetails(List<String> shipRef, List<Lite_Id__c> newLiteIds)
    {
       
        List<Shipment_Line__c> shipDetails = [Select id,Shipment_Line_External_Reference__c,Order_Entry_Line__c,Shipment__c from Shipment_Line__c 
                                        		WHERE Shipment_Line_External_Reference__c IN: shipRef];
        
        Map<String,Shipment_Line__c> shlMap = new Map<String,Shipment_Line__c>();
		List<Lite_Id__c>  updateLiteId = new List<Lite_Id__c>();       
        for(Shipment_Line__c shLine : shipDetails)
            {
                shlMap.put(shLine.Shipment_Line_External_Reference__c, shLine);
                
            } 
        
        if(!shipDetails.isEmpty())
        {
            for(Lite_Id__c li : newLiteIds)
            {
                Lite_Id__c upLi = new Lite_Id__c();
                upLi.Order_Entry_Line__c = shlMap.get(li.Shipment_Line_Reference__c) != null ? shlMap.get(li.Shipment_Line_Reference__c).Order_Entry_Line__c : null;
                upLi.Shipment_Line__c = shlMap.get(li.Shipment_Line_Reference__c) != null ? shlMap.get(li.Shipment_Line_Reference__c).Id : null;
                upLi.Asset_Created__c = 'No';
                upLi.Id = li.Id;
                updateLiteId.add(upLi);
            }
        } 
        if(!updateLiteId.isEmpty())
          {
              UPDATE updateLiteId;
          }
    }
    
    public static void afterInsertExceptionToCreate(List<Lite_Id__c> newLiteIds)
    {
       /*
        List<Shipment_Line__c> shipDetails = [Select id,Shipment_Line_External_Reference__c,Order_Entry_Line__c,Shipment__c from Shipment_Line__c 
                                        		WHERE Shipment_Line_External_Reference__c IN: liteSet];
	*/
       // List<SmartSheet_Exceptions__c> insertExcep = new List<SmartSheet_Exceptions__c>();
        List<Lite_Id__c> updateLite = new List<Lite_Id__c>();
		if(newLiteIds.size() > 0)
        {
            for(Lite_Id__c liId : newLiteIds)
            {
                /*
                SmartSheet_Exceptions__c excep = new SmartSheet_Exceptions__c();
						excep.Asset_Lite_Id__c = liId.Lite_Id__c;
                		excep.Error_Message__c = ' Shipment Line Reference Dont have Shipment line for Lite Id  ' + liId.Id;
                		excep.Shipment_Line_External_Reference__c = liId.Shipment_Line_Reference__c;
                		excep.RecordTypeId = Schema.SObjectType.SmartSheet_Exceptions__c.getRecordTypeInfosByName().get('Assert Creation Exception').getRecordTypeId();
                		insertExcep.add(excep);
                */
                Lite_Id__c uplite = new Lite_Id__c();
                uplite.Asset_Created__c = 'Error';
                uplite.Error_Message__c = 'Shipment Line Reference Dont have Shipment line for Lite Id';
                uplite.Id = liId.Id;
                updateLite.add(uplite);
                    
                
            }
            
            //INSERT insertExcep;
            UPDATE updateLite;
        }
        
    }
}