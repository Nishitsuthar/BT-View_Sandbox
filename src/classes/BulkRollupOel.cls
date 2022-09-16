//To handle Bulk Processing of Rollback_Order_Entry_Line__c records in batch
global class BulkRollupOel implements Database.Batchable<sObject>
{  global Map<id, Order_Entry_Line__c> oelOldRBMap ;  //for processing Trigger.old data
   global String query;
   global Set<Id> oelIdstr = new Set<Id>();
    public List<String> systemFields = new List<String>{'id','nullid','isdeleted','currencyisocode','recordtypeid','createddate','createdbyid','lastmodifieddate','lastmodifiedbyid',
            'systemmodstamp','lastactivitydate','lastvieweddate','lastreferenceddate','ownerid'};   
    

                  
     
    Public BulkRollupOel(Map<id, Order_Entry_Line__c> oelOldRBMaptrig)
    {
        oelOldRBMap = oelOldRBMaptrig;
        oelIdstr = oelOldRBMap.keySet();
          query =  'SELECT Id, Area_Sq_Cm__c, ASP_IGU_Order_Line__c, Base_decimal_in__c, Base_in__c, Base_mm__c, Base_Integration__c, Base_Height_1_decimal_in__c, Base_Height_1_in__c, Base_Height_1_mm__c, Base_Height_1_integration__c, Cancellation_Date__c, Cancellation_Reason__c, Change_Type_Requested__c, Control_Hardware_Product__c, CPQ_Quote_Line__c, '+
              ' CreatedById, CSS_Order_Line_ID__c, CurrencyIsoCode, Customer_P_O_Line__c, Customer_Reference_Description__c, Deliver_To_Account__c, Deliver_To_City__c, Deliver_To_Country__c, Deliver_To_Name__c, Deliver_To_Postal_Code__c, Deliver_To_State_Province__c, Deliver_To_Street_1__c, Deliver_To_Street_2__c, Deliver_To_Street_3__c, Dimension_Description__c,'+
              ' Discount__c, Envelope_Area_Sq_Ft__c, Extended_Price__c, First_Promised_Date__c, First_Request_Ship_Date__c, First_Scheduled_Ship_Date__c, H1_in__c, H1_mm__c, H1_integration__c, Height_decimal_in__c, Height_in__c, Height_mm__c, Height_Intergration__c, Hold_Reason__c, IGU_Part_Number__c, Initial_Quantity__c, Installation_Type__c,'+
              ' Integration_Action_Requested__c, Integration_Errors__c, Integration_Requestor__c, Integration_Status__c, IsPostIntegrationAdd__c, LastModifiedById, Line_Number__c, loader__c, Mark_Ids__c, Non_Standard_Approval__c, ODKEY__c, Open_Area_Sq_Ft__c, Open_Area_Sq_m__c, Open_Quantity__c, Oracle_Order_Line_Id__c, Order_Entry_Release__c,'+
              ' Status__c, Order_Line_Type__c, Order_SKU__c, Overall_Thickness_in__c, Overall_Thickness_mm__c, Overall_Thickness_Integration__c, Override_Factory_Validations__c, OwnerId, Pre_Cancellation_Status__c, Pre_Change_Status__c, Pre_Hold_Status__c, Previous_Promised_Date__c, Previous_Quantity__c, Previous_Request_Ship_Date__c, Previous_Scheduled_Ship_Date__c,'+
              ' Print_Total_Area__c, Priority__c, Product__c, Part_Number__c, Product_Component_Type__c, Product_Description__c, Product_Name__c, Promised_Date__c, Quantity__c, Quantity_Change_Reason__c, Quantity_Change_Reason_Code__c, Quantity_Change_Reason_Comments__c, Quantity_Shipped__c, Quote__c, RecordTypeId, Reference_ID__c, Request_Date__c,'+
              ' Request_Date_Change_Comments__c, Request_Date_Change_Reason__c, Request_Date_Update_Needed__c, Request_Date_Updated_Date__c, Sales_Order_Line_Status__c, Schedule_Ship_Date_Change_Comments__c, Schedule_Ship_Date_Change_Reason__c, Scheduled_Ship_Date__c, Is_Schedule_Date_Updated__c, Scheduled_Ship_Date_Updated_Date__c, Quote_Line_Item__c,'+
              ' SFDC_Record_Id__c,Name, Shape__c, Shipment_Date__c, Shipped_Area_Sq_Ft__c, Shipped_Area_Sq_m__c, Shipping_Account__c, Shipping_Address__c, Shipping_City__c, Shipping_Country__c, Shipping_Name__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Street_1__c, Shipping_Street_2__c, Shipping_Street_3__c, SKU__c, Software_Product__c, System_of_Measurement__c, '+
              'Test__c, Total_Area_SOM__c, Area_Sq_Ft__c, Total_Area_Sq_m__c, Trigger_Source__c, Unit_Area_Sq_m__c, Unit_Price__c, Unit_Area_Sq_Ft__c, Use_Account_Shipping_Address__c, W1_In__c, W1_mm__c, W1_integration__c, Work_Order_Id__c, Work_Order_Status__c '+ 
              ' FROM Order_Entry_Line__c WHERE Id IN :oelIdstr' ;
    
    }
           
   /*
     * Method name  : start
     * Description  : Batch Class start Method - collects the Order_Entry_Line__c records before going to 
                      integration to be passed to the interface method execute
      * Return Type  : Database.QueryLocator
     * Parameter    : Database.BatchableContext
    */         
    global Database.QueryLocator start(Database.BatchableContext BC)  
    {  
        Database.QueryLocator ql;
        System.debug('IDS ' + oelIdstr);
        System.debug('start query = ' + query);
        ql = Database.getQueryLocator(query);
         return ql;       
    }  

    /*
     * Method name  : execute
     * Description  : Batch Class execute Method - called for each batch of records passed 
                      to the method. Processes each chunk of data 
     * Return Type  : nil 
     * Parameters   : Database.BatchableContext
                      List<Order_Entry_Line__c>
     */
     
    global void execute(Database.BatchableContext BC, List<Order_Entry_Line__c> oelList) 
        {  
        System.debug('execute size' +oelList.size()); 
        
         Boolean hasErrors = false;  
        Set<String> oerIds = new Set<String>();
        Map<String, Rollback_Order_Entry_Release__c> rboerMap = new Map<String, Rollback_Order_Entry_Release__c>();
        Map<String, Schema.SObjectType> sObjectTypeMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> oelFieldMap = sObjectTypeMap.get('Order_Entry_Line__c').getDescribe().fields.getMap(); 
        Map<String, Schema.SObjectField> rboelFieldMap = sObjectTypeMap.get('Rollback_Order_Entry_Line__c').getDescribe().fields.getMap();
        List<Rollback_Order_Entry_Line__c> rboelList = new List<Rollback_Order_Entry_Line__c>();
        String errorLineId;
        String lastOERID;
        
        
       
          for (Order_Entry_Line__c oel : oelList) {  
            oerIds.add(String.valueOf(oel.Order_Entry_Release__c));
        }

        for(Rollback_Order_Entry_Release__c rboer : [SELECT Id, CreatedDate, Rollback_Datetime__c, Order_Entry_Release__c FROM Rollback_Order_Entry_Release__c 
            WHERE Order_Entry_Release__c IN :oerIDs ORDER BY Order_Entry_Release__c ASC, CreatedDate DESC]) 
        {
            if(lastOERID == null || rboer.Order_Entry_Release__c != lastOERID) {
                lastOERId = rboer.Order_Entry_Release__c;
                rboerMap.put(rboer.Order_Entry_Release__c, rboer);
            }
        }
        for(Order_Entry_Line__c oel : oelList)
        {
            Rollback_Order_Entry_Line__c rboel= new Rollback_Order_Entry_Line__c();
            if(rboerMap.keyset().contains(oel.Order_Entry_Release__c)) {
                Rollback_Order_Entry_Release__c rboer = rboerMap.get(oel.Order_Entry_Release__c);
                rboel.Rollback_Datetime__c = rboer.Rollback_Datetime__c;
                rboel.Rollback_Order_Entry_Release__c = rboer.Id;
            }
            else {
                rboel.Rollback_Errors__c = 'A Matching Rollback Order Entry Release was not found for this Rollback Order Entry Line';
                System.debug('***Error: A Matching Rollback Order Entry Release was not found for this Rollback Order Entry Line');
                hasErrors = true;
            }
            rboel.Order_Entry_Line__c = String.valueOf(oel.Id); 
            try {       
                for (String fieldName : rboelFieldMap.keySet()) {
                    if (!SystemFields.contains(fieldName)) {
                        if (oelFieldMap.keySet().contains(fieldname)) {
                            if (rboelFieldMap.get(fieldname).getDescribe().isUpdateable()) {                        
                                if (rboelFieldMap.get(fieldname).getDescribe().getType() == Schema.DisplayType.STRING && 
                                    oelFieldMap.get(fieldname).getDescribe().getType() == Schema.DisplayType.REFERENCE) {
                                    rboel.put(fieldname, String.valueOf(oelOldRBMap.get(oel.Id).get(fieldname)));//getting values from Trigger.old map
                                }
                                else {
                                    rboel.put(fieldName, oelOldRBMap.get(oel.Id).get(fieldname)); //getting values from Trigger.old map
                                }
                            }
                            else {
                                rboel.Rollback_Errors__c = 'User does not have write access to Rollback Order Entry field ' + fieldname + 
                                    ' for Line # ' + String.valueOf(oel.Line_Number__c);
                                System.debug('***Error: User does not have write access to Rollback Order Entry field ' + fieldname + 
                                    ' for Line # ' + String.valueOf(oel.Line_Number__c));
                                hasErrors = true;
                            }
                        }
                        else
                        {
                                System.debug('***Note: Rollback Field ' + fieldname + ' does not exist on Order Entry Line');
                        }
                    }
                }
                rboel.Trigger_Source__c = 'Rollback';                                   
                rboelList.add(rboel);       
            } catch (Exception e) {
                System.debug('*** An error occurred creating Order Entry Line Rollback for Line # ' + String.valueOf(oel.Line_Number__c) +': ' + e.getMessage());
                rboel.Rollback_Errors__c = 'An error occurred creating Order Entry Line Rollback for Line # '  + String.valueOf(oel.Line_Number__c)  + ' ' + e.getMessage();
            }
            
        }
        if (!hasErrors) {
            try {
                 System.debug('insert size' +rboelList.size());
                insert rboelList;
            } catch (Exception e) {
                System.debug('***Error: An error occurred inserting Order Entry Line Rollback: ' + e.getMessage());         
                System.debug(e.getMessage());
                for(Rollback_Order_Entry_Line__c rboel : rboelList) {   
                    rboel.Rollback_Errors__c = 'An error occurred inserting Order Entry Line Rollback: ' + e.getMessage();  
                }           
            }       
        }       
   //     return rboelList;                                         
    }
    
    /*
     * Method name  : finish
     * Description  : Batch Class finish Method. Called after all batches are processed. 
     * Return Type  : nil
     * Parameter    : Database.BatchableContext
     */
     
    global void finish(Database.BatchableContext BC)  
    {  
       System.Debug('Batch Job Finished');
    } 
    
}