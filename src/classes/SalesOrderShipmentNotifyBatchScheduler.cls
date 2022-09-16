/**
** Developed on 11th November 2019.
** Purpus : Scheduler for SalesOrderShipmentNotifyBatch.
** Version : 1
** UnitTestClass : UnitTests_SalesOrderShipmentNotifyBatch.
**/
global class SalesOrderShipmentNotifyBatchScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        SalesOrderShipmentNotifyBatch sosnb = new SalesOrderShipmentNotifyBatch();
        database.executebatch(sosnb);
    }
}