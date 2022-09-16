public class ShipmentEditFormContlr {
   public Packaging_and_Shipping_Instruction__c oerPackagingRec{get;set;}
    public Boolean showShipmentForm{get;set;}
    public Boolean shippingRequested{get;set;}
    public Boolean shippingSubmitted{get;set;}
    public List<SelectOption> items {get; set;}
    public List<String> selectedPackaging {get; set;}
    
    public ShipmentEditFormContlr(ApexPages.StandardController controller){
        showShipmentForm=false;
        shippingRequested=false;
        shippingSubmitted=false;
        this.selectedPackaging= new List<String>();
        this.items = new List<SelectOption>();
        items.add(new SelectOption('Crate','Crate'));
        items.add(new SelectOption('A-Frame','A-Frame'));
        
        this.oerPackagingRec = (Packaging_and_Shipping_Instruction__c)controller.getRecord();
        oerPackagingRec=[select id,Name,Packaging__c ,Order_Number__c,Customer_Name__c,Project_Manager_Name__c,Terms_agreed_to_by_deal_desk__c,Special_packing_order__c,
                   Special_Packing_Comments__c, Special_Requirements__c,Special_Requirements_Comments__c, Shipping_Name__c,Shipping_Street1__c,
                   Shipping_Street2__c,Shipping_Street3__c,Shipping_City__c,Shipping_State__c, Shipping_Zip__c,Shipping_Country__c,Point_of_Contact_Name__c,
                   Special_Delivery_Instructions__c,Special_Delivery_Instruction_Comments__c, Accept_Partial_Shipment__c,Partial_Shipment_Comments__c from Packaging_and_Shipping_Instruction__c where id=:oerPackagingRec.id ];
        
        if(oerPackagingRec.Packaging__c!=null){
            selectedPackaging= oerPackagingRec.Packaging__c.split(';');
            
        }
    }
   

    public Pagereference FormSave(){
        system.debug('selectedPackaging>>'+selectedPackaging);
        if(oerPackagingRec !=null){
         	oerPackagingRec.Is_Form_Approved__c = false;
            update oerPackagingRec;
        
            return new PageReference('/'+oerPackagingRec.id);
        }
        return null;
    }
}