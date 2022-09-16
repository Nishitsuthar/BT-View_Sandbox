// Batch class to create a new Open OELF'S based on the Closed Status aggregate 
public class BatchToCreateOpenOELF implements Database.Batchable<sObject>
{
    
    List<Id> idsToCheck = new List<Id>{'a6b0h000000bmfT','a6b0h000000bmfW','a6b0h000000bmfb','a6b0h000000bmel','a6b0h000000bmen','a6b0h000000bmpx',
                                    'a6b0h000000bmeQ','a6b0h000000bmeS','a6b0h000000bmeX','a6b0h000000bmfQ'};
        
    public database.querylocator Start(database.batchablecontext bc)
    {
           List<String> noRp = new List<String>{'Shipped'};
        return Database.getQueryLocator([Select id,Name,Quantity__c,Request_Date__c,Promised_Date__c,Scheduled_Ship_Date__c,Shipping_Address__c,Status__c 
                                                        FROM Order_Entry_Line__c WHERE Status__c NOT IN: noRp]); 
                                         //ID IN:idsToCheck]);
                                        //  LIMIT 200                                     
                                         
    }

    public void execute(database.batchableContext bc, List<Order_Entry_Line__c> oelRecords)
    {
                Set<Id> oelIds = new Set<Id>();
                
                for(Order_Entry_Line__c oelId : oelRecords)
                {
                    oelIds.add(oelId.Id);
                }
                
             
            AggregateResult[] groupedResults = [select Order_Entry_Line__c, sum(Quantity_Shipped__c) from Order_Entry_Line_Shipment__c 
                                                    WHERE Order_Entry_Line__c IN:oelIds Group by Order_Entry_Line__c];

            Map<string,Decimal> rollUpnotNull = new map<string,Decimal>();
            List<Order_Entry_Line__c> getOelForOelfRollUp = new List<Order_Entry_Line__c>();
            List<Order_Entry_Line_Shipment__c> insertOelfForRP = new List<Order_Entry_Line_Shipment__c>();
            


                                for(AggregateResult ar : groupedResults)
                                {
                                    System.debug(' Ar '+ar.get('Order_Entry_Line__c'));
                                    if((Decimal)ar.get('expr0') != null && (Decimal)ar.get('expr0') != 0)
                                    {
                                    System.debug(' OEL Aggregate NOT NULL **** '+ (string)ar.get('Order_Entry_Line__c') + ' OEL Aggregate NOT NULL '+ (Decimal)ar.get('expr0'));
                                    rollUpnotNull.put(((string)ar.get('Order_Entry_Line__c')),((Decimal)ar.get('expr0')));
                                    }
                                    
                                }
                                 
                                System.debug(' notNullRollUp Size **** '+rollUpnotNull.keySet());
                                
                                System.debug(' notNullRollUp Values **** '+rollUpnotNull.Values());
                              

                                getOelForOelfRollUp = [Select id,Name,Quantity__c,Request_Date__c,Promised_Date__c,Scheduled_Ship_Date__c,Shipping_Address__c,Status__c 
                                                            FROM Order_Entry_Line__c WHERE ID IN: rollUpnotNull.keySet()];

                                
            if(getOelForOelfRollUp.Size() > 0)
            {
                for(Order_Entry_Line__c oelAssin : getOelForOelfRollUp)
                {
                   if(oelAssin.Quantity__c > rollUpnotNull.get(oelAssin.Id))
                   {
                        System.debug(' In OELF Create RollUp ');
                    Order_Entry_Line_Shipment__c oelfForRP = new Order_Entry_Line_Shipment__c();
                            oelfForRP.Order_Entry_Line__c  = oelAssin.Id;
                            oelfForRP.Quantity_Shipped__c = null;
                            oelfForRP.Shipping_Address__c = oelAssin.Shipping_Address__c;
                            oelfForRP.Quantity__c = oelAssin.Quantity__c - rollUpnotNull.get(oelAssin.Id);
                            oelfForRP.Open_Quantity__c = oelAssin.Quantity__c - rollUpnotNull.get(oelAssin.Id);
                            oelfForRP.Promised_Date__c = oelAssin.Promised_Date__c;
                            oelfForRP.Request_Date__c = oelAssin.Request_Date__c;
                            oelfForRP.Scheduled_Ship_Date__c = oelAssin.Scheduled_Ship_Date__c;
                            if(oelAssin.Status__c.contains('Cancel'))
                                oelfForRP.Status__c = 'Cancelled';
                            else 
                                oelfForRP.Status__c = 'Open';
                            insertOelfForRP.add(oelfForRP);

                    }       

                }
            }

            if(insertOelfForRP.size() > 0 && !insertOelfForRP.isEmpty())
                Database.SaveResult[] srList = Database.insert(insertOelfForRP, false);


            // To create a new OELF based on the OEL OELF Size. An open OELF will be created
                    List<Order_Entry_Line__c> countOfOelf = [Select id,Name,Status__c,(Select id from Order_Entry_Line_Shipments__r) from Order_Entry_Line__c WHERE ID IN:oelIds];

                    Set<Id> oelWithNoOelfs = new Set<Id>();

                    for(Order_Entry_Line__c oelFull : countOfOelf)
                    {
                        if(oelFull.Order_Entry_Line_Shipments__r.Size() == 0 || oelFull.Order_Entry_Line_Shipments__r.Size() == null)
                        {
                            oelWithNoOelfs.add(oelFull.Id);
                            System.debug(' OEL with no OELF '+oelWithNoOelfs.Size());
                        }
                    }

                    List<Order_Entry_Line_Shipment__c> oelForOelf = new List<Order_Entry_Line_Shipment__c>();
                        for(Order_Entry_Line__c oel : [Select id,Name,Quantity__c,Request_Date__c,Promised_Date__c,Scheduled_Ship_Date__c,Shipping_Address__c,Status__c FROM Order_Entry_Line__c 
                                                                WHERE ID IN: oelWithNoOelfs])
                        {
                                Order_Entry_Line_Shipment__c oelf = new Order_Entry_Line_Shipment__c();
                                                oelf.Order_Entry_Line__c  = oel.Id;
                                                oelf.Quantity_Shipped__c = null;
                                                oelf.Shipping_Address__c = oel.Shipping_Address__c;
                                                oelf.Quantity__c = oel.Quantity__c;
                                                oelf.Open_Quantity__c = oel.Quantity__c; 
                                                oelf.Promised_Date__c = oel.Promised_Date__c;
                                                oelf.Request_Date__c = oel.Request_Date__c;
                                                oelf.Scheduled_Ship_Date__c = oel.Scheduled_Ship_Date__c; 
                                                if(oel.Status__c.contains('Cancel'))
                                                    oelf.Status__c = 'Cancelled';
                                                else 
                                                    oelf.Status__c = 'Open';
                                                oelForOelf.add(oelf);

                        }

                            if(oelForOelf.Size() > 0 && !oelForOelf.isEmpty())
                                    //INSERT oelForOelf;
                                Database.SaveResult[] insertOelfDB = Database.Insert(oelForOelf,false);



    }

    public void finish(database.batchablecontext bc)
    {
    /*
        AsyncApexJob apexJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: bc.getJobId()];
                                  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                  String[] toAddress = new String[] {'bajrang.m@neevsystems.com','bajrang.mekala@view.com'};
                                  mail.setToAddresses(toAddress);
                                  mail.setSubject('Apex Job status is ' + apexJob.Status);
                                  mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems + ' batches with '+ apexJob.NumberOfErrors + ' failures.');
                                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
      */ 
    }

}