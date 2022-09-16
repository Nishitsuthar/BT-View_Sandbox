public class CloneOrderWithLines {
    // Updated Date         Developer       Project             Tracking Id                        					 Requirement                         
    // 18-Sep-2020         Bajrang         Project Concrete    CLONE_ORDER_ISSUE_FIX_SEP_20     				.
    // 06-Jan-2021          Rekha           SOS Hold Invoice    SOS_HOLD_INVOICE    
    public Order_Entry_Release__c oldOER; //for retrieving records
    public Order_Entry_Release__c newOER; //for inserting records
    public Id OERid{set;get;} //retrieving & defining ID from page opened
    
    public String oerNumStr; //to capture three digit number after '-'
    public Integer oerNum; //to convert String to Integer for increasing the counter
    
    public Map<Id, Order_Entry_Release__c> oerMap = new Map<id, Order_Entry_Release__c>();
    public Integer maxOERNumber = 1; //to check the number of digits in the oerNumStr and put 0 or 00 in increasing count
    
    public CloneOrderWithLines(ApexPages.StandardController stdController) 
    {
        oldOer = (Order_Entry_Release__c)stdController.getRecord();
        system.debug('========================the value of oldOer is======================'+oldOer);
    }
    
    public PageReference CloneOER()
    {
        List<String> fieldNames;
        String queryString=''; //to iterate the query on required fields
        List<Id> oerIdList = new list<Id>();
        List<Order_Entry_Release__c> oerList; //used by queryString to query on fields
        List<Order_Entry_Line__c> oerLines; //query the records
        List<Order_Entry_Line__c> newOERLines = new List<Order_Entry_Line__c>(); //inserting records
        
        for(Order_Entry_Release__c obj : [Select Id, Name FROM Order_Entry_Release__c where Id=:oldOer.Id])
        {
            oerIdList.add(obj.Id);
        }
        
        Map<String, Schema.SObjectField> oerFields = Schema.getGlobalDescribe().get('Order_Entry_Release__c').getDescribe().fields.getMap();
        fieldNames = new List<String>(oerFields.keySet()); //to query on fields from 'Order_Entry_Release'
        
        queryString = 'SELECT ';
        for (String fieldName : fieldnames)
        {
            queryString = queryString + fieldname + ',';
        }
        
        queryString = queryString.removeEnd(',') + ' from Order_Entry_Release__c where ID = \''+oerIdList[0]+'\'';
       
        oerList = Database.query(queryString);
        system.debug('============value of oerList is================'+oerList);
        
        oldOer = [SELECT Id, Name, Release_Name__c, Billing_Account__c, Sold_to_Account__c, Shipping_Account__c, Opportunity__c
                  from Order_Entry_Release__c where Id = :oldOER.id LIMIT 1];
        //oldOer is only retrieving ID hence, mandatory fields are only queried from the Object matching with ID
        
        //oer is the collection of the fields in all the Order_Entry_Release records from a single Opportunity
        for(Order_Entry_Release__c oer : [select Id, name, Opportunity__c from Order_Entry_Release__c 
                                          where Opportunity__c = :oldOER.Opportunity__c])
        {
            oerMap.put(oer.Id, oer);
            oerNumStr = oer.Name.SubStringAfterLast('-');
            
            if (oerNumStr != null)
            { 
                oerNum = Integer.valueOf(oerNumStr);
                if (oerNum > maxOERNumber) maxOERNumber = oerNum;
            }
        }
        
        maxOERNumber++;
        oerNumStr = String.valueOf(maxOERNumber);
        
        if (oerNumStr.length() == 1)
        {
            oerNumStr= '00' + oerNumStr;
        }
        else
        {
            if (oerNumStr.length() == 2)
            {
                oerNumStr = '0' + oerNumStr;
            }
        }       
        
        newOER = oerList[0].clone(false,false); //it will not preserve the ID or field values when cloning
        newOER.name =  oerList[0].name.SubStringBeforeLast('-') + '-' + oerNumStr;
        newOER.currencyIsoCode = oerList[0].currencyIsoCode;
        
        Map<string,OER_Default_Values__mdt> oERFieldDefaultValues = new Map<string,OER_Default_Values__mdt>();
        for(OER_Default_Values__mdt oerD : [SELECT  DeveloperName,Field_API_Name__c,Field_Default_Value__c,Field_Type__c FROM OER_Default_Values__mdt]){
            oERFieldDefaultValues.put(oerD.Field_API_Name__c, oerD);
        }
        for(string field : oERFieldDefaultValues.keySet()){ 
            OER_Default_Values__mdt mdtRec = oERFieldDefaultValues.get(field);
            
            //CLONE_ORDER_ISSUE_FIX_SEP_20
            if(mdtRec.Field_Type__c == 'Text'){
                newOER.put(field,String.ValueOf(mdtRec.Field_Default_Value__c));
            }else if(mdtRec.Field_Type__c == 'Number'){
                newOER.put(field,Integer.ValueOf(mdtRec.Field_Default_Value__c));
            }else if(mdtRec.Field_Type__c == 'CheckBox'){
                newOER.put(field,Boolean.ValueOf(mdtRec.Field_Default_Value__c));
            }
        }
        
        //Added a custom setting for removing fields based on the selection. on 26-12-2019
        for(OER_Default_Values_Custom__c field : OER_Default_Values_Custom__c.getAll().values()){
            //system.debug('field.Name----'+field.Field_API_Name__c+'===========isvsisble=============='+field.IsVisible__c);
            if(!field.IsCloned__c){
                Map<String, Object> fieldMap = (Map<String, Object>) JSON.deserializeUntyped( JSON.serialize( newOER ) );				
                fieldMap.remove( field.Field_API_Name__c );                
                newOER = (Order_Entry_Release__c) JSON.deserialize( JSON.serialize( fieldMap ), Order_Entry_Release__c.class );
            }           
        }
        
        insert newOER;
        
        
        Map<String, Schema.SObjectField> oerLineFields = Schema.getGlobalDescribe().get('Order_Entry_Line__c').getDescribe().fields.getMap();
        fieldNames = new List<String>(oerLineFields.keySet());
        
        queryString = 'SELECT ';
        
        for (String fieldName : fieldnames) queryString = queryString + fieldname + ',';
        {
            //CLONE_ORDER_ISSUE_FIX_SEP_20
            queryString = queryString.removeEnd(',') + ' FROM Order_Entry_Line__c WHERE (NOT status__c like \'%Cancel%\' ) AND Order_Entry_Release__c = \''+OERList[0].Id+'\'';
        }
        
        oerLines = Database.query(queryString);
        system.debug('=============value of oerLines is================='+oerLines);
        
        //CLONE_ORDER_ISSUE_FIX_SEP_20
        Map<string,OEL_Default_Values__mdt> oELFieldDefaultValues = new Map<string,OEL_Default_Values__mdt>();
        for(OEL_Default_Values__mdt oerD : [SELECT  DeveloperName,Field_Type__c,Field_API_Name__c,Field_Default_Value__c FROM OEL_Default_Values__mdt]){
            oELFieldDefaultValues.put(oerD.Field_API_Name__c, oerD);
        }
        
        
        if(oerLines.size()>0){        
            for (Order_Entry_Line__c oel : OERLines)
            {
                Order_Entry_Line__c newoel = oel.clone(false);
                newoel.Order_Entry_Release__c = newOER.id;
                newoel.Previous_Quantity__c = null;
                newoel.Quantity_Shipped__c = null;
                newoel.Status__c = 'Draft'; //SOS_HOLD_INVOICE
                //CLONE_ORDER_ISSUE_FIX_SEP_20
                for(string field : oELFieldDefaultValues.keySet()){ 
                    OEL_Default_Values__mdt mdtRec = oELFieldDefaultValues.get(field);
                    if(mdtRec.Field_Type__c == 'Text'){
                        newoel.put(field,String.ValueOf(mdtRec.Field_Default_Value__c));
                    }else if(mdtRec.Field_Type__c == 'Number'){
                        newoel.put(field,Integer.ValueOf(mdtRec.Field_Default_Value__c));
                    }else if(mdtRec.Field_Type__c == 'Checkbox'){
                        newoel.put(field,Boolean.ValueOf(mdtRec.Field_Default_Value__c));
                    }
                }
                
                newOERLines.add(newoel);
            }
            
            insert newOERLines;
        }
        system.debug('===================value of newOERLines is==============='+newOERLines);
        
        return new PageReference('/'+newOER.Id);
    }            
}