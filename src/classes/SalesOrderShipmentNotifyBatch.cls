/**
** Developed on 1st November 2019.
** Purpus : This batch will send the email notification with the details around the shipments.
** Version : 1
** UnitTestClass : UnitTests_SalesOrderShipmentNotifyBatch.
**/

global class SalesOrderShipmentNotifyBatch implements Database.Batchable<sObject>,Database.Stateful {
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'Salesforce.Notification@View.com'];
    
    Map<Id, String> trackingURLMap = new Map<Id, String>();
    global database.querylocator start(Database.BatchableContext BC)
    {
        DateTime filterTime = System.now().addHours(-24);
        String IGU = 'IGU';
        String StatusValue = 'Initial';
        string query = 'select Id, Order_Entry_Release_Record__r.Project_Manager__c,Tracking_URL__c,Shipping_City__c,Shipping_State_Province__c,Shipping_Country__c,Shipping_Street_3__c,Shipping_Street_2__c,Shipping_Street_1__c,Shipment__r.Opportunity__r.Name,Shipped_Quantity__c,Product_Description__c,Shipping_Postal_Code__c,Product_SKU__c,Order_Entry_Release_Record__c,Order_Entry_Release_Record__r.Name,Order_Entry_Release_Record__r.Requestor__c from Shipment_Line__c where Order_Entry_Release_Record__c<>null and createdDate >=:filterTime and Shipment_Notification_Status__c =: StatusValue and Order_Entry_Release_Record__r.RecordType.Name<>:IGU and Tracking_Number__c<>null';
        //string query = 'select Id, Order_Entry_Release_Record__r.Project_Manager__c,Tracking_URL__c,Shipping_City__c,Shipping_State_Province__c,Shipping_Country__c,Shipping_Street_3__c,Shipping_Street_2__c,Shipping_Street_1__c,Shipment__r.Opportunity__r.Name,Shipped_Quantity__c,Product_Description__c,Shipping_Postal_Code__c,Product_SKU__c,Order_Entry_Release_Record__c,Order_Entry_Release_Record__r.Name,Order_Entry_Release_Record__r.Requestor__c from Shipment_Line__c where Order_Entry_Release_Record__c<>null and createdDate >=:filterTime and Order_Entry_Release_Record__r.RecordType.Name<>:IGU and Tracking_Number__c<>null';
        //string query = 'select Order_Entry_Release_Record__r.Project_Manager__c,Tracking_URL__c,Shipping_City__c,Shipping_State_Province__c,Shipping_Country__c,Shipping_Street_3__c,Shipping_Street_2__c,Shipping_Street_1__c,Shipment__r.Opportunity__r.Name,Shipped_Quantity__c,Product_Description__c,Shipping_Postal_Code__c,Product_SKU__c,Order_Entry_Release_Record__c,Order_Entry_Release_Record__r.Name,Order_Entry_Release_Record__r.Requestor__c from Shipment_Line__c where Order_Entry_Release_Record__c<>null and Order_Entry_Release_Record__r.RecordType.Name<>:IGU and Tracking_Number__c<>null';
        
        system.debug('query value:'+query);
        system.debug('filter date:'+filterTime);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, Sobject[] scope)
    {   
        Map<String,List<Shipment_Line__c>> shipmentsByRequestor = new Map<String,List<Shipment_Line__c>>();
        set<id> oerIdsSet = new set<id>();
        List<Shipment_Line__c> updateSLsPickedforNotifyList = new List<Shipment_Line__c>();
        List<Shipment_Line__c> updateSLsProcessedNotifyList = new List<Shipment_Line__c>();
        for (Shipment_Line__c item : (List<Shipment_Line__c>)scope) {
            Shipment_Line__c sl = new Shipment_Line__c();
            sl.Id = item.Id;
            sl.Shipment_Notification_Status__c = 'Picked by Scheduler';
            updateSLsPickedforNotifyList.add(sl);
            oerIdsSet.add(item.Order_Entry_Release_Record__c);
            //set the trackingURLMap with order_Entry_ReleaseId as key, trackingURL as key
            trackingURLMap.put(item.Order_Entry_Release_Record__c, item.Tracking_URL__c);
            List<Shipment_Line__c> shimpmentLineList = new List<Shipment_Line__c>();
            shimpmentLineList.add(item);
            //Requestor route
            if(item.Order_Entry_Release_Record__r.Requestor__c != null){
                if(shipmentsByRequestor.get(item.Order_Entry_Release_Record__r.Requestor__c) != null){
                    shimpmentLineList.addAll(shipmentsByRequestor.get(item.Order_Entry_Release_Record__r.Requestor__c));
                }
                shipmentsByRequestor.put(item.Order_Entry_Release_Record__r.Requestor__c,shimpmentLineList);
            }else if(item.Order_Entry_Release_Record__r.Project_Manager__c != null){
                if(shipmentsByRequestor.get(item.Order_Entry_Release_Record__r.Project_Manager__c) != null){
                    shimpmentLineList.addAll(shipmentsByRequestor.get(item.Order_Entry_Release_Record__r.Project_Manager__c));
                }
                shipmentsByRequestor.put(item.Order_Entry_Release_Record__r.Project_Manager__c,shimpmentLineList);
            }
        }
        if (!updateSLsPickedforNotifyList.isEmpty())
            Database.update(updateSLsPickedforNotifyList,false);
        
        map<id,id> orderNumberCaseMap = new map<id,id>();
        map<id,string> orderNameCaseMap = new map<id,string>();
        for(Issue__c issueRec:[select id,Case__c,Case__r.CaseNumber,Order_Entry_Release__c from Issue__c where Case__c<>null and Order_Entry_Release__c in : oerIdsSet]){
            orderNumberCaseMap.put(issueRec.Order_Entry_Release__c,issueRec.Case__c);
            orderNameCaseMap.put(issueRec.Order_Entry_Release__c,issueRec.Case__r.CaseNumber);
        }
        
                
        for(String requester:shipmentsByRequestor.keySet()){
            Shipment_Line__c firstRec = shipmentsByRequestor.get(requester).get(0);
            Map<String,Order_Entry_Release__c> orderMap = new Map<String,Order_Entry_Release__c>();
            Set<id> orderEntrySet = new Set<id>();
            for(Shipment_Line__c slRec:shipmentsByRequestor.get(requester)){
                orderEntrySet.add(slRec.Order_Entry_Release_Record__c);
            }
            for(Order_Entry_Release__c orderRec:[select id,Requestor__c,Name from Order_Entry_Release__c where id in :orderEntrySet]){
                orderMap.put(orderRec.id,orderRec);
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            id userId = firstRec.Order_Entry_Release_Record__r.Requestor__c != null ? firstRec.Order_Entry_Release_Record__r.Requestor__c : firstRec.Order_Entry_Release_Record__r.Project_Manager__c;
            mail.setTargetObjectId(userId);//requestor emial goes here.
            List<string> sendTo = new List<string>();
            //sendTo.add('meghna.sharma@view.com.invalid');
            // sendTo.add('xin.niu@view.com.invalid');
            mail.setSaveAsActivity( false );
            mail.setToAddresses(sendTo);
            mail.setSubject('Control Hardware Order Shipped for ' + firstRec.Shipment__r.Opportunity__r.Name);
            
            
            String htmlHeader = '<head><style>table {  font-family: arial, sans-serif;  border-collapse: collapse;  width: 100%;'+
                '}td, th {  border: 1px solid #dddddd;  text-align: left;  padding: 8px;}tr:nth-child(even) {'+
                'background-color: #dddddd;}</style></head>';
            String messageBody = '<html>'+htmlHeader+'<body><br><br>This is an automated notification.<br><br>Opportunity Name: '+firstRec.Shipment__r.Opportunity__r.Name+'<br><br>Shipping Address: <br>'+(firstRec.Shipping_Street_1__c != null ?firstRec.Shipping_Street_1__c+'<br>':'')+(firstRec.Shipping_Street_2__c != null ? firstRec.Shipping_Street_2__c+'<br>' : '')+(firstRec.Shipping_Street_3__c != null ? firstRec.Shipping_Street_3__c+'<br>':'')+(firstRec.Shipping_City__c != null ? firstRec.Shipping_City__c:'')+','+(firstRec.Shipping_State_Province__c != null ? firstRec.Shipping_State_Province__c:'')+' '+(firstRec.Shipping_Postal_Code__c != null ? firstRec.Shipping_Postal_Code__c:'')+','+(firstRec.Shipping_Country__c != null ? firstRec.Shipping_Country__c:'')+'<br><br>Shipment Tracking Link: '+firstRec.Tracking_URL__c+'<br><br>The following Control Hardware Orders / Parts Requests have been shipped:<br><br>';
            
            
            
            String table1Header ='<table border="1"><tr>    <th>Order #</th>    <th>Order Type </th>    <th>Link</th>  </tr>';
            String table1Body ='';
            for(Order_Entry_Release__c oer :orderMap.values()){
                
                String url = oer.Requestor__c != null ? ('<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/'+orderNumberCaseMap.get(oer.id)+'/related/Defects__r/view">'+orderNameCaseMap.get(oer.id)+'</a>'):('<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/lightning/r/Order_Entry_Release__c/'+oer.id+'/view">'+oer.Name+'</a>');
                    
                    table1Body =table1Body+'<tr><td>'+oer.Name+'</td>'+
                    '<td>'+(oer.Requestor__c != null ? 'Parts Request': 'Control Hardware Order')+'</td>'+
                    '<td>'+url+'</td></tr>';
            }
            table1Body = table1Body+'</table><br><br>The shipment includes the following parts:<br><br>';
            String table2Header ='<table border="1"><tr>    <th>Order #</th>    <th>Product SKU</th>    <th>Product Description</th><th>Quantity</th>  </tr>';
            
            String table2Body = '';
            List<Shipment_Line__c> shipmentbyReqSLList = new List <Shipment_Line__c>();
            
            for(Shipment_Line__c SLRec : shipmentsByRequestor.get(requester)){
                Shipment_Line__c sl = new Shipment_Line__c();
                sl.id = SLRec.Id;
                sl.Shipment_Notification_Status__c = 'Notification Sent';
                shipmentbyReqSLList.add(sl);
                table2Body = table2Body+ '<tr><td>'+SLRec.Order_Entry_Release_Record__r.Name+'</td>'+
                    '<td>'+(SLRec.Product_SKU__c != null ? SLRec.Product_SKU__c:'')+'</td>'+'<td>'+SLRec.Product_Description__c+'</td>'+
                    '<td>'+(SLRec.Shipped_Quantity__c != null ? SLRec.Shipped_Quantity__c.round(System.RoundingMode.CEILING):0)+'</td></tr>';
                
            }
            table2Body = table2Body+'</table>';                                  
            String boadyEnd = '</body>  </html>';
            messageBody = messageBody +table1Header+table1Body+table2Header+table2Body+boadyEnd;
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setHtmlBody(messageBody);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                mail
                    });
            if (results[0].success) {
                updateSLsProcessedNotifyList.addAll(shipmentbyReqSLList);
                shipmentbyReqSLList.clear();
            } 
        }
        if (!updateSLsProcessedNotifyList.isEmpty())
            Database.update(updateSLsProcessedNotifyList,false);
    }
    
    global void finish(Database.BatchableContext BC) {
        Database.executeBatch(new IssueUpdateTrackingURLBatch(trackingURLMap));
    }
    
}