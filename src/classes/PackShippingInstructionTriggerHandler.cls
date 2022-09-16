public class PackShippingInstructionTriggerHandler {
    
    public Static void doBeforeCreatingForm(List<Packaging_and_Shipping_Instruction__c> packagingRecList){
        Set<Id> oerHeaderIds = new Set<Id>();
        for(Packaging_and_Shipping_Instruction__c packRec : packagingRecList){
            packRec.Is_Active__c = true;
            oerHeaderIds.add(packRec.Order_Entry_Release__c);
        }
        List<Packaging_and_Shipping_Instruction__c> packRecList = [select Id, Name, Is_Active__c, Order_Entry_Release__c from Packaging_and_Shipping_Instruction__c
                                                                   where Order_Entry_Release__c =: oerHeaderIds];
        if( packRecList.size() > 0){
            for(Packaging_and_Shipping_Instruction__c packRec : packRecList ){
                packRec.Is_Active__c = false;
            }
            update packRecList;
        }
        
    }
    
    
    public static void doAfterUpdateShipmentForm(List<Packaging_and_Shipping_Instruction__c> packagingRecList){
        Set<Id> oerHeaderIds = new Set<Id>();
        for(Packaging_and_Shipping_Instruction__c packRec : packagingRecList){
            oerHeaderIds.add(packRec.Order_Entry_Release__c);
        }
        Map<Id, Order_Entry_Release__c> oerRecordsMap = new Map<Id,Order_Entry_Release__c>([select Accept_Partial_Shipment__c,Crate_Terms_Agreed__c, Packaging__c, 
                                                                                            Partial_Shipment_Comments__c, Point_of_Contact_Name__c, Point_of_Contact_Phone__c,
                                                                                            Shipping_City__c, Shipping_Country__c,Shipping_Name__c,Shipping_Postal_Code__c,
                                                                                            Shipping_State_Province__c, Shipping_Street_1__c,Shipping_Street_2__c,Shipping_Street_3__c,
                                                                                            Special_Delivery_Instruction_Comments__c,Special_Delivery_Instructions__c,Special_Packing_Comments__c,
                                                                                            Special_Packing_Order__c, Special_Requirements_Comments__c,Special_Requirements__c, Status__c, Id from Order_Entry_Release__c where Id =: oerHeaderIds]);
        //Map<Id, Packaging_and_Shipping_Instruction__c> oerIdToPackingRecMap = new Map<Id, Packaging_and_Shipping_Instruction__c>();
        List<Order_Entry_Release__c> oerUpdateRecList = new List<Order_Entry_Release__c>();
        for(Packaging_and_Shipping_Instruction__c packRec : packagingRecList){
            
            Order_Entry_Release__c orderEntryRec = oerRecordsMap.get(packRec.Order_Entry_Release__c);
            //oerIdToPackingRecMap.put(orderEntryRec.Id, packRec);
            // system.debug('orderEntryRec'+orderEntryRec);
            orderEntryRec.Will_customer_Accept_Partial_Shipment__c = packRec.Will_Customer_Accept_Partial_Shipment__c;
            orderEntryRec.Crate_Terms_Agreed__c = packRec.Terms_agreed_to_by_deal_desk__c;
            orderEntryRec.Packaging__c = packRec.Packaging__c;
            orderEntryRec.Partial_Shipment_Comments__c = packRec.Partial_Shipment_Comments__c;
            orderEntryRec.Point_of_Contact_Name__c = packRec.Point_of_Contact_Name__c;
            orderEntryRec.Point_of_Contact_Phone__c = packRec.Point_of_Contact_Phone__c;
            orderEntryRec.Shipping_City__c = packRec.Shipping_City__c;
            orderEntryRec.Shipping_Country__c = packRec.Shipping_Country__c;
            orderEntryRec.Shipping_Name__c = packRec.Shipping_Name__c;
            orderEntryRec.Shipping_Postal_Code__c = packRec.Shipping_Zip__c;
            orderEntryRec.Shipping_State_Province__c = packRec.Shipping_State__c;
            orderEntryRec.Shipping_Street_1__c = packRec.Shipping_Street1__c;
            orderEntryRec.Shipping_Street_2__c = packRec.Shipping_Street2__c;
            orderEntryRec.Shipping_Street_3__c = packRec.Shipping_Street3__c;
            orderEntryRec.Special_Delivery_Instruction_Comments__c = packRec.Special_Delivery_Instruction_Comments__c;
            orderEntryRec.Special_Delivery_Instructions_i_e_48hrs__c = packRec.Special_Delivery_Instructions_i_e_48hr__c;
            orderEntryRec.Special_Packing_Comments__c = packRec.Special_Packing_Comments__c;
            orderEntryRec.Special_Packaging_Order__c = packRec.Special_packaging_order__c;
            orderEntryRec.Special_Requirements_Comments__c = packRec.Special_Requirements_Comments__c;
            orderEntryRec.Special_Requirements_Crate_Aframe__c = packRec.Special_Requirements_Crate_Aframe__c;
            orderEntryRec.Trigger_Source__c = 'UI';
            oerUpdateRecList.add(orderEntryRec);
            
        }
        try{
            Update oerUpdateRecList;
        }catch(Exception e){
            for(Packaging_and_Shipping_Instruction__c packRec : packagingRecList){
                packRec.addError('Error encountered while approving. \r'+e.getMessage()+'\r'+'Please try again later.');
            }
        }
        
        List<Order_Entry_Release__c> updateOERStatus = new List<Order_Entry_Release__c>();
        for(Order_Entry_Release__c oerRec : [select Status__c,Trigger_Source__c, Id from Order_Entry_Release__c where Id IN: oerRecordsMap.keySet()] ){
            if(oerRec.Status__c == 'Change Requested'){
                oerRec.Trigger_Source__c = 'UI';
                oerRec.Status__c = 'Change Integration Requested';
                //oerRec.Integration_Scope__c
                updateOERStatus.add(oerRec);
            }
        }
        Update updateOERStatus;
        
    }
    
}