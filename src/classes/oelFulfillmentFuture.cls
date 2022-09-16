// Updated Date			Developer		Project 			Tracking Id         					Requirement							
	// 30-July-2020 		Bajrang         Project Concrete	CREATE_OELF_ON_SHIPMENT_LINE_ADD_UPD_01 New class creation which will be called from orlFullCreateFromShipmentLine trigger for Create OELF records
    // 03-Aug-2020 
global class oelFulfillmentFuture
{
    // Future class
    @future
    public static void toCreateOelFulfillment(String jsonString)
    {
        
        system.debug('jsonStringjsonString'+jsonString);
       List<string> newOelfulfill =  (List<string>)Json.deserialize(jsonString,List<string>.class);
        
      AggregateResult[] groupedResults = [select Order_Entry_Line__c, sum(Quantity_Shipped__c) from Order_Entry_Line_Shipment__c where Order_Entry_Line_Name__c=:newOelfulfill Group by Order_Entry_Line__c];
    list<Order_Entry_Line__c> oellist = [select id,Name,Quantity__c,Scheduled_Ship_Date__c,Request_Date__c,Promised_Date__c,Shipping_Address__c from Order_Entry_Line__c where Name=:newOelfulfill];
        
        Map<string,Decimal> rollup = new map<string,Decimal>();
        for(AggregateResult ar : groupedResults)
        {
            rollup.put(((string)ar.get('Order_Entry_Line__c')),((Decimal)ar.get('expr0')));
        }
        //System.debug(' RollUp **** '+rollup);
        //System.debug(' Oel **** '+oellist[0].Quantity__c);
        
        List<Order_Entry_Line_Shipment__c> shlst = new List<Order_Entry_Line_Shipment__c>();
        for(Order_Entry_Line__c o: oellist)
        {
            
            if(rollup.containsKey(o.id) && o.Quantity__c > rollup.get(o.id))
            {
                
	        Order_Entry_Line_Shipment__c sh = new Order_Entry_Line_Shipment__c();
            sh.Order_Entry_Line__c = o.id;
            sh.Open_Quantity__c = o.Quantity__c - rollup.get(o.id);
            sh.Quantity__c = o.Quantity__c - rollup.get(o.id);
            sh.Scheduled_Ship_Date__c = o.Scheduled_Ship_Date__c;
            sh.Request_Date__c = o.Request_Date__c;
            sh.Promised_Date__c = o.Promised_Date__c;
            sh.Shipping_Address__c = o.Shipping_Address__c;
            sh.Status__c = 'Open';
            shlst.add(sh);
            }
        }
    system.debug('enetr38'+shlst);
    insert shlst;
        system.debug('enetr40'+shlst);
    }
        
           
}