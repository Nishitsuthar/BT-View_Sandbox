public class ShipmentFormController {
    public Order_Entry_Release__c oerRecord{get;set;}
    public String pageMessage{get; set;}
    public Boolean showShipmentForm{get;set;}
    public Boolean shippingRequested{get;set;}
    public Boolean DisplayPageBlock{get; set;}
    public Boolean displayCustomMsg{get; set;}
    public Boolean DisplayPageBlock1{get; set;}
    Public Packaging_and_Shipping_Instruction__c ps_Record{get; set;}
    Public List<Packaging_and_Shipping_Instruction__c> ps_Records{get; set;}
    
    public ShipmentFormController(ApexPages.StandardController controller){
        showShipmentForm = false;
        shippingRequested = false;
        DisplayPageBlock = false;
        DisplayPageBlock1 = false;
        
        oerRecord = (Order_Entry_Release__c)controller.getRecord();
        ps_Record = new Packaging_and_Shipping_Instruction__c();
        ps_Record.Order_Entry_Release__c = oerRecord.id;
        oerRecord = [Select Id, Name ,Opportunity__r.Sales_Ops_Owner__c,Opportunity__r.Sales_Ops_Owner__r.Email,Opportunity__r.Project_Manager__r.Email, Project_Manager__r.Email,Shipping_Name__c,
                     Shipping_Street_1__c, Opportunity__r.Project_Manager__r.Name, Shipping_Street_2__c,Shipping_Street_3__c,Shipping_City__c,Shipping_State_Province__c,
                     Shipping_Country__c,Shipping_Postal_Code__c from Order_Entry_Release__c where Id =: oerRecord.Id];
        system.debug('oerrec'+ oerRecord);
        
        ps_Records = [Select Id, Name, Order_Entry_Release__c from Packaging_and_Shipping_Instruction__c where Order_Entry_Release__r.Id =: oerRecord.Id];
        if(ps_Records.size() > 0){
            DisplayPageBlock = true;
            pageMessage = 'Packaging and Shipping Instruction form has been requested already. Do you want to submit it again?';
            //ApexPages.addmessage(new ApexPages.message('Shipping form has been requested already.Do you want to Submit new form Again?'));
        }else{
            DisplayPageBlock = true;
            pageMessage = 'You are about to create a shipment form';
            //ApexPages.addmessage(new ApexPages.message('You are about to create a shipment form'));
            
        }
    }
    
    public void resendNotification(){
        DisplayPageBlock = false;
        DisplayPageBlock1 = true;
        try{
            if(ps_Records.size()> 0){
                for(Packaging_and_Shipping_Instruction__c rec : ps_Records){
                    rec.Is_Active__c = false;
                }
                update ps_Records;
            }
            Integer RecordSize = ps_Records.size() + 1;
            
            ps_Record.Order_Entry_Release__c = oerRecord.Id;
            ps_Record.Status__c = 'Requested';
            ps_Record.Is_Active__c = true;
            ps_Record.Deal_Desk_Analyst__c = oerRecord.Opportunity__r.Sales_Ops_Owner__c;
            ps_Record.Shipping_Name__c = oerRecord.Shipping_Name__c;
            ps_Record.Shipping_Street1__c = oerRecord.Shipping_Street_1__c;
            ps_Record.Shipping_Street2__c = oerRecord.Shipping_Street_2__c;
            ps_Record.Shipping_Street3__c = oerRecord.Shipping_Street_3__c;
            ps_Record.Shipping_City__c    = oerRecord.Shipping_City__c;
            ps_Record.Shipping_State__c   = oerRecord.Shipping_State_Province__c;
            ps_Record.Shipping_Country__c = oerRecord.Shipping_Country__c;
            ps_Record.Shipping_Zip__c     = oerRecord.Shipping_Postal_Code__c;
                       
            Insert ps_Record;
            
            Packaging_and_Shipping_Instruction__c PSIRec = [Select Id,Name, Owner.Name from Packaging_and_Shipping_Instruction__c where Id =: ps_Record.Id Limit 1];
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            //String[] sendingTo = new String[]{oerRecord.Opportunity__r.Sales_Ops_Owner__r.Email}; 
            String[] sendingTo = new String[]{oerRecord.Opportunity__r.Project_Manager__r.Email}; 
            system.debug('Deal desk user email'+sendingTo);
            semail.setToAddresses(sendingTo); 
            semail.setSubject('Packaging and Shipping Instructions Form Request'); 
            semail.setPlainTextBody('Dear '+oerRecord.Opportunity__r.Project_Manager__r.Name+',\r\r'+'A new Packaging and Shipping Instructions form has been requested by '+PSIRec.Owner.Name +'\r'+
                                    'Please click here to view \r'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Packaging_and_Shipping_Instruction__c/'+PSIRec.Id+'/view');  
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}); 
        }catch(Exception Ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Ex.getMessage()));
        }
        pageMessage = 'Packaging and Shipping Instruction form created and submitted successfully to PM';
       
    }
    
    Public PageReference GoBack(){
        return new PageReference('/'+oerRecord.id);
    }
    
    public PageReference confirmMethod(){
        return new PageReference('/'+oerRecord.id);
    }
    
}