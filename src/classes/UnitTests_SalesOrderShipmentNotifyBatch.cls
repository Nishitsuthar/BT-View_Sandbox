@isTest(seealldata=true)
private class UnitTests_SalesOrderShipmentNotifyBatch{
    static testMethod void runSalesOrderShipmentNotifyBatch() {
        Order_Entry_Release__c oer= [select id,Oracle_Sales_Order_Id__c from Order_Entry_Release__c where Oracle_Sales_Order_Id__c <>null and RecordType.Name<>'IGU' and Project_Manager__c<>null limit 1];
        Product2 prodRec = [select id,ProductCode from Product2 where ProductCode<>null and Description<>null limit 1];
        Shipment_Line__c sl = [select id,shipment__c,lastmodifieddate,Order_Entry_Release_Record__c,Product_SKU__c from Shipment_Line__c where Tracking_Number__c<>null limit 1];
        sl.SO_number__c = oer.Oracle_Sales_Order_Id__c;
        sl.Product_SKU__c = prodRec.ProductCode;
        update sl;
        
        Shipment_Line__c slrec = new Shipment_Line__c();
        slrec.Shipment__c = sl.shipment__c;
        slrec.SO_number__c  = oer.Oracle_Sales_Order_Id__c;
        slrec.Product_SKU__c = prodRec.ProductCode;
        slrec.Shipped_Quantity__c=10;
        slrec.Tracking_Number__c = '1234';
                insert slrec;
        
        slrec = [select createdDate from Shipment_line__c where id=:slrec.id];
        system.debug('slrec value:'+slrec.createdDate);
        SalesOrderShipmentNotifyBatch son = new SalesOrderShipmentNotifyBatch();
        ID batchprocessid = Database.executeBatch(son);
        
        Test.StartTest();
         String CRON_EXP = '0 0 0 15 3 ? 2022';
         String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new SalesOrderShipmentNotifyBatchScheduler()); 
        
        Test.StopTest();
        
        //Order_Entry_Release_Record__c<>null
    }
}