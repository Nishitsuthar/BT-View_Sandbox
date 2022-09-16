global class ShipmentFormComponentcontlr {
    
    @AuraEnabled
    public static Integer returnMessage(Id oerRecId){
        
        List<Packaging_and_Shipping_Instruction__c> ps_Records = [select Id, Name, Order_Entry_Release__c from Packaging_and_Shipping_Instruction__c
                                                                  where Order_Entry_Release__c =: oerRecId];
        
     
        return ps_Records.size();
    }
    
    @AuraEnabled
    public static String createShipmentForm(Id oerRecId){
        string messgae;
         /*List<Packaging_and_Shipping_Instruction__c> ps_Records = [select Id, Name, Order_Entry_Release__c from Packaging_and_Shipping_Instruction__c
                                                                  where Order_Entry_Release__c =: oerRecId];*/
         Order_Entry_Release__c oerRecord = [SELECT Id, Name, Opportunity__r.Sales_Ops_Owner__c, Opportunity__c, Order_Entry_Release_Date__c,
                                                    Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                                                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                                                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                                                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                                                   Shipping_Street_2__c, Shipping_Street_3__c, Opportunity__r.Project_Manager__r.Email,
                                                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c 
                                                   FROM Order_Entry_Release__c where Id =:oerRecId Limit 1];
        try{
               Packaging_and_Shipping_Instruction__c ps_Record = new Packaging_and_Shipping_Instruction__c();
                ps_Record.Order_Entry_Release__c = oerRecord.Id;
                ps_Record.Status__c = 'Requested';
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
            system.debug('ps_Record'+ps_Record);
                
             
        }catch(Exception Ex){
           messgae = Ex.getMessage();
        }
        //messgae = 'Packaging and Shipping Instruction form created and submitted successfully to PM';
        return messgae;
    }
    
     @AuraEnabled
    public static Order_Entry_Release__c returnOERRecord(Id oerRecId){
        system.debug('RecordId'+ oerRecId);
        Order_Entry_Release__c oerRecord = [SELECT Id, Name, Opportunity__r.Sales_Ops_Owner__c, Opportunity__c, Order_Entry_Release_Date__c,
                                                    Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                                                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                                                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                                                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                                                   Shipping_Street_2__c, Shipping_Street_3__c, Opportunity__r.Project_Manager__r.Email,
                                                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c 
                                                   FROM Order_Entry_Release__c where Id =:oerRecId Limit 1];
        system.debug('Record'+oerRecord);
     
        return oerRecord;
    }
}