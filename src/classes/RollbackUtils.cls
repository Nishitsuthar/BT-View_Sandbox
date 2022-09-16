public class RollbackUtils {
    
    public List<String> systemFields = new List<String>{'id','nullid','isdeleted','currencyisocode','recordtypeid','createddate','createdbyid','lastmodifieddate','lastmodifiedbyid',
            'systemmodstamp','lastactivitydate','lastvieweddate','lastreferenceddate','ownerid'};   
    
    public Rollback_Order_Entry_Release__c createOERRollback(Order_Entry_Release__c  oer) {
        Map<String, Schema.SObjectType> sObjectTypeMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> oerFieldMap = sObjectTypeMap.get('Order_Entry_Release__c').getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> rboerFieldMap = sObjectTypeMap.get('Rollback_Order_Entry_Release__c').getDescribe().fields.getMap(); 
        Rollback_Order_Entry_Release__c rboer= new Rollback_Order_Entry_Release__c();
        rboer.Order_Entry_Release__c = String.valueOf(oer.Id);
        rboer.Rollback_Datetime__c = String.valueOf(System.now());
        try {       
            
            for (String fieldName : rboerFieldMap.keySet()) {
                if (!SystemFields.contains(fieldName)) {
                    if (oerFieldMap.keySet().contains(fieldname)) {                         
                        if(rboerFieldMap.get(fieldname).getDescribe().isUpdateable()) {                     
                            if (rboerFieldMap.get(fieldname).getDescribe().getType() == Schema.DisplayType.STRING && 
                                oerFieldMap.get(fieldname).getDescribe().getType() == Schema.DisplayType.REFERENCE) {
                                rboer.put(fieldname, String.valueOf(oer.get(fieldname)));
                            }
                            else {                      
                                rboer.put(fieldName, oer.get(fieldname));
                            }
                        }
                        else {
                            System.debug('*** Error: User does not have write access to ' + fieldname + ' on Rollback Order Entry Release');
                            rboer.Rollback_Errors__c = 'User does not have write access to ' + fieldname + ' on Rollback Order Entry Release';
                        }
                    }
                    else
                    {
                        System.debug('***Note: The OER Rollback Field ' + fieldname + ' has no corresponding field on OER');
                    }
                }               
            }   
            System.debug(String.valueOf(rboer));
        } catch (Exception e) {
            System.debug(e.getMessage());
            rboer.Rollback_Errors__c = 'An error occurred creating Order Entry Release Rollback: ' + e.getMessage();
        }
        if (rboer.Rollback_Errors__c == null) {
            try {
                insert rboer;
            } catch (Exception e) {
                System.debug('*** Error inserting OER Rollback: ' + e.getMessage());
                rboer.Rollback_Errors__c = 'An error occurred inserting Order Entry Release Rollback: ' + e.getMessage();               
            }
        }       
        return rboer;
    }
    
    public List<Rollback_Order_Entry_Line__c> createOELsRollback(List<Order_Entry_Line__c> oelList) {
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
                                    rboel.put(fieldname, String.valueOf(oel.get(fieldname)));
                                }
                                else {
                                    rboel.put(fieldName, oel.get(fieldname)); 
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
                insert rboelList;
            } catch (Exception e) {
                System.debug('***Error: An error occurred inserting Order Entry Line Rollback: ' + e.getMessage());         
                System.debug(e.getMessage());
                for(Rollback_Order_Entry_Line__c rboel : rboelList) {   
                    rboel.Rollback_Errors__c = 'An error occurred inserting Order Entry Line Rollback: ' + e.getMessage();  
                }           
            }       
        }       
        return rboelList;
    }
    
    public String getSelectFields (String sObjectType) { 
        String returnString = ' ';
        Map<String,Schema.sObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset())
        {
            if (!systemFields.contains(fieldName)) {
                if(!fieldMap.get(fieldName).getDescribe().isCalculated() && fieldMap.get(fieldName).getDescribe().isAccessible()) {
                    returnString = returnString + fieldName + ',';
                }
            }
        }
        return returnString.removeEnd(',').trim();              
    }
    
    
    public String clearRollBacks (Order_Entry_Release__c oer) {
        String result = clearRollbacks(oer, TRUE);      
        return result;
    }
    
    public String clearRollBacks (Order_Entry_Release__c oer, Boolean clearAll) {
        List<RollBack_Order_Entry_Release__c> oerRollbacks = new List<Rollback_Order_Entry_Release__c>();
        String result = 'OK';
        String strOERId = String.valueOf(oer.Id);
        try {
            oerRollbacks = [SELECT Id from Rollback_Order_Entry_Release__c where Order_Entry_Release__c = :strOERId ORDER by CreatedDate DESC];
            if (oerRollbacks.size() > 0) {
                if (clearAll) {
                    delete oerRollbacks;
                }
                else
                {
                    delete oerRollbacks[0];
                }
            }
        } catch (Exception e) {
            System.debug('*** An error occurred clearing Order Entry Release Rollback: ' + e.getMessage());
            result = '*** An error occurred clearing Order Entry Release Rollback: ' + e.getMessage();
        }       
        return result;
    }
    

    
    public List<String> rollbackIntegration(Order_Entry_Release__c oer)
    {
        Boolean hasErrors = false;
        String queryString;
        List<String> errorList = new List<String>();
        
        Map<String, Schema.SObjectType> sObjectTypeMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> oerFieldMap = sObjectTypeMap.get('Order_Entry_Release__c').getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> rboerFieldMap = sObjectTypeMap.get('Rollback_Order_Entry_Release__c').getDescribe().fields.getMap(); 
        Map<String, Schema.SObjectField> oelFieldMap = sObjectTypeMap.get('Order_Entry_Line__c').getDescribe().fields.getMap(); 
        Map<String, Schema.SObjectField> rboelFieldMap = sObjectTypeMap.get('Rollback_Order_Entry_Line__c').getDescribe().fields.getMap();
        Map<String, Order_Entry_Line__c> oelMap = new Map<String, Order_Entry_Line__c>();
        List<Rollback_Order_Entry_Line__c> rboelList;
        Rollback_Order_Entry_Release__c rboer;
        String strOERId = String.valueOf(oer.Id);
        
        try {           
            // Retrieve updatable fields for Order Entry Release
            queryString = 'SELECT Id, ' +  getSelectFields('Order_Entry_Release__c') + ' FROM Order_Entry_Release__c WHERE Id = \'' + oer.Id + '\'';
            oer = Database.query(queryString);
            // Retrieve latest Order Entry Release Rollback 
            queryString = 'SELECT Id,CreatedDate,' + getSelectFields('Rollback_Order_Entry_Release__c') + ' FROM Rollback_Order_Entry_Release__c WHERE Order_Entry_Release__c = \'' + strOERId + '\' ORDER BY CreatedDate DESC LIMIT 1';            
            rboer =  Database.query(queryString);
            for(String fieldName : rboerFieldMap.keyset()) {
                if(oerFieldMap.keySet().contains(fieldName) &&
                    oerFieldMap.get(fieldname).getDescribe().isUpdateable() &&
                    !systemFields.contains(fieldname)) {
                    if (rboerFieldMap.get(fieldname).getDescribe().getType() == Schema.DisplayType.STRING && 
                        oerFieldMap.get(fieldname).getDescribe().getType() == Schema.DisplayType.REFERENCE &&
                        rboer.get(fieldname) != null) {
                            oer.put(fieldname, Id.valueOf((String) rboer.get(fieldname)));
                    }
                    else {
                        oer.put(fieldName, rboer.get(fieldname));
                    }
                }               
            }
            oer.Trigger_Source__c = 'Rollback';                             
            update oer;                     
        } catch (Exception e) {
            errorList.add('Order Entry Release Rollback failed : ' + e.getMessage()); 
            System.debug('*** Order Entry Release Rollback failed : ' + e.getMessage());
            hasErrors = true;
        }
        if (!hasErrors) 
        {
            try {
                // Retrieve the Order Entry Lines for the Order Entry Release
                queryString = 'SELECT Id,' + getSelectFields('Order_Entry_Line__c') + ' FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = \'' + oer.Id + '\'';
                System.debug('***OEL Rollback Query: ' + queryString);
                for (Order_Entry_Line__c oel : Database.query(queryString)) {
                    oelMap.put(String.valueOf(oel.Id), oel);
                }
                // Retrieve Rollback Order Entry Lines
                queryString = 'SELECT Id,' + getSelectFields('Rollback_Order_Entry_Line__c') + ' FROM Rollback_Order_Entry_Line__c WHERE Rollback_Order_Entry_Release__c = \'' + rboer.id + 
                    '\'';
                rboelList = Database.query(queryString);    
                for(Rollback_Order_Entry_Line__c rboel : rboelList) {
                    Order_Entry_Line__c oel = oelMap.get(rboel.Order_Entry_Line__c);
                    for(String fieldName : rboelFieldMap.keyset()) {
                        if(oelFieldMap.keySet().contains(fieldName) &&
                            oelFieldMap.get(fieldname).getDescribe().isUpdateable() &&
                            !systemFields.contains(fieldName)) 
                        {
                            if (rboelFieldMap.get(fieldname).getDescribe().getType() == Schema.DisplayType.STRING && 
                                oelFieldMap.get(fieldname).getDescribe().getType() == Schema.DisplayType.REFERENCE &&
                                rboel.get(fieldname) != null)
                            {
                                oel.put(fieldname, Id.valueOf((String) rboel.get(fieldname)));
                            }
                            else {
                                    oel.put(fieldName, rboel.get(fieldname));
                            }
                        }
                    }
                    oel.Trigger_Source__c = 'Rollback';
                }
            } catch (Exception e) {
                hasErrors = true;
                errorList.add ('Order Entry Line Rollback Creation Failed: ' + e.getMessage());
                System.debug('*** Order Entry Line Rollback Creation Failed: ' + e.getMessage());
                hasErrors = true;           
            }
            try {
                if (!hasErrors) {
                    update oelMap.values(); 
                }
            }   
            catch(Exception e)
            {
                hasErrors = true;
                errorList.add ('Order Entry Lines Rollback Update Failed: ' + e.getMessage());
                System.debug('*** Order Entry Lines Rollback Update Failed: ' + e.getMessage());
                hasErrors = true;   
            }                                                       
        }
        return errorList;               
    }
}