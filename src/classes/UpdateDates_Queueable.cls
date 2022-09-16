public class UpdateDates_Queueable implements Queueable {
    Set<Id> orderEntryId;
    public UpdateDates_Queueable(Set<Id> oerId)
    {
            this.orderEntryId = oerId;
    }
    public void execute(QueueableContext context) {
        Order_Entry_Release__c oerQue = [Select id,Status__c,Trigger_Source__c From Order_Entry_Release__c where ID IN: orderEntryId];
        oerQue.Status__c = 'Change Integration Requested';
        oerQue.Trigger_Source__c = 'UI';
        System.debug(' Queueable Job CIR');
        UPDATE oerQue;
    }
}