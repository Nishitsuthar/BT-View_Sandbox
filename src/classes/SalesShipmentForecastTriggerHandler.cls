public class SalesShipmentForecastTriggerHandler{   
    public static void createSalesShipmentForeCaseLines(Map<Id, Sales_Shipment_Forecast__c> newSFMap){
        list<Sales_Shipment_Forecast__c> ssfList = new list<Sales_Shipment_Forecast__c>();
        list<Sales_Shipment_Forecast_Line__c> sflList = new list<Sales_Shipment_Forecast_Line__c>();
        Sales_Shipment_Forecast_Line__c sfl_igu = new Sales_Shipment_Forecast_Line__c();
        Sales_Shipment_Forecast_Line__c sfl_css = new Sales_Shipment_Forecast_Line__c();
        Set<Id> OpportunitySet = new Set<Id>();
        Id sfId;
        
        for(Sales_Shipment_Forecast__c obj: newSFMap.values())
        {
            OpportunitySet.add(obj.Opportunity__C);
        }
        Map<Id,opportunity> mapSfOpp=new Map<Id,opportunity>([select id,name,IGU_Amount_Roll_Up__c,currencyisocode,Project_Glass_Quantity__c,CSS_Amount_Roll_Up__c from opportunity where id in:OpportunitySet]);
        for(Sales_Shipment_Forecast__c obj: newSFMap.values()){         
            if(obj.First_Request_Date_IGU__c<>null){
                system.debug('@@##'+obj.First_Request_Date_IGU__c);
                sfl_igu.Sales_Shipment_Forecast__c = obj.Id;
                sfl_igu.Product_Family__c = 'IGU';
                sfl_igu.Request_Date__c = obj.First_Request_Date_IGU__c;
                sfl_igu.Shipment_Percentage__c = 100;
                sfl_igu.Shipment_SqFt__c = mapSfOpp.get(obj.Opportunity__C).Project_Glass_Quantity__c;
                sfl_igu.Shipment_Amount__c = mapSfOpp.get(obj.Opportunity__C).IGU_Amount_Roll_Up__c;
                sfl_igu.currencyisocode = mapSfOpp.get(obj.Opportunity__C).currencyisocode;
                system.debug('@@##'+sfl_igu);
                sflList.add(sfl_igu);
                             
            }
            if(obj.First_Request_Date_CSS__c<>null){
                system.debug('@@##'+obj.First_Request_Date_CSS__c);
                sfl_css.Sales_Shipment_Forecast__c = obj.Id;
                sfl_css.Product_Family__c = 'CSS';
                sfl_css.Request_Date__c = obj.First_Request_Date_CSS__c;
                sfl_css.Shipment_Percentage__c = 100;
                sfl_css.Shipment_Amount__c = mapSfOpp.get(obj.Opportunity__C).CSS_Amount_Roll_Up__c;
                sfl_css.currencyisocode = mapSfOpp.get(obj.Opportunity__C).currencyisocode;
                system.debug('@@##'+sfl_css);
                sflList.add(sfl_css);
            }
            //OpportunitySet.add(obj.Opportunity__C);
            sfId=obj.Id;
        }
        //Add Related Old Lines to the New Header
        ssfList = [SELECT ID,Status__c, Opportunity__c, First_Request_Date_CSS__c, First_Request_Date_IGU__c, Groundbreaking_Date__c 
                                        FROM Sales_Shipment_Forecast__c WHERE Opportunity__c IN : OpportunitySet AND ID NOT IN : newSFMap.keySet() AND Status__c = 'Active'];
        for(Sales_Shipment_Forecast__c obj: ssfList){
            obj.Status__c = 'Inactive'; 
            
        }
        if(ssfList<>null && ssfList.size()>0){
            sflList.clear();
            for(Sales_Shipment_Forecast_Line__c obj: [SELECT ID,CurrencyIsoCode,Shipment_SqFt__c,Shipment_Amount__c,Shipment_Percentage__c,Request_Date__c,Status__c,Product_Family__c,Sales_Shipment_Forecast__c FROM Sales_Shipment_Forecast_Line__c 
                                                                            WHERE Sales_Shipment_Forecast__c IN:ssfList]){
                    
                
                Sales_Shipment_Forecast_Line__c newsfl=new Sales_Shipment_Forecast_Line__c();
                newsfl.Sales_Shipment_Forecast__c=sfId;
                newsfl.Status__c=obj.Status__c;
                newsfl.Request_Date__c =obj.Request_Date__c;
                newsfl.Product_Family__c =obj.Product_Family__c;
                newsfl.Shipment_Percentage__c =obj.Shipment_Percentage__c;
                newsfl.Shipment_Amount__c = obj.Shipment_Amount__c;
                newsfl.Shipment_SqFt__c = obj.Shipment_SqFt__c;
                newsfl.currencyisocode = obj.currencyisocode;
                obj.Status__c = 'Inactive';
                sflList.add(obj);
                sflList.add(newsfl);
            }
        }
        system.debug('@@##'+sflList);
        if(ssfList.size()>0 && !ssfList.isEmpty()){
            try{            
                update ssfList;
            }catch(Exception Ex){
                 System.debug('Exception'+Ex);
            }
        }
        if(sflList.size()>0 && !sflList.isEmpty()){
            try{            
                upsert(sflList);
            }catch(Exception Ex){
                 System.debug('Exception'+Ex);
            }
        }
        
    }
    /*public static void updateSalesShipmentForeCaseLines(Map<Id, Sales_Shipment_Forecast__c> newSFMap, Map<Id, Sales_Shipment_Forecast__c> oldSFMap){
        list<Sales_Shipment_Forecast_Line__c> sflList = new list<Sales_Shipment_Forecast_Line__c>();
        list<Sales_Shipment_Forecast_Line__c> ssfLines = new list<Sales_Shipment_Forecast_Line__c>();
        Map<Id,Sales_Shipment_Forecast__c>  iguMap = new Map<Id, Sales_Shipment_Forecast__c>();
        Map<Id,Sales_Shipment_Forecast__c>  cssMap = new Map<Id, Sales_Shipment_Forecast__c>();
        for(Sales_Shipment_Forecast__c obj: newSFMap.values()){     
            if(oldSFMap.get(obj.Id).First_Request_Date_IGU__c!=obj.First_Request_Date_IGU__c){
                iguMap.put(obj.Id,obj);     
            }
            if(oldSFMap.get(obj.Id).First_Request_Date_CSS__c!=obj.First_Request_Date_CSS__c){
                cssMap.put(obj.Id,obj);         
            }       
        }
        ssfLines = [SELECT Id,Product_Family__c,Request_Date__c,Sales_Shipment_Forecast__c,Shipment_Percentage__c 
                                FROM Sales_Shipment_Forecast_Line__c 
                                WHERE Sales_Shipment_Forecast__c in:newSFMap.keyset()];
        for(Sales_Shipment_Forecast_Line__c obj : ssfLines){        
            if(cssMap!=null && cssMap.containsKey(obj.Sales_Shipment_Forecast__c)){         
                if(obj.Product_Family__c=='CSS'){               
                    obj.Request_Date__c=cssMap.get(obj.Sales_Shipment_Forecast__c).First_Request_Date_CSS__c;
                    sflList.add(obj);
                }
            }
            if(iguMap!=null && iguMap.containsKey(obj.Sales_Shipment_Forecast__c)){
                if(obj.Product_Family__c=='IGU'){               
                    obj.Request_Date__c=iguMap.get(obj.Sales_Shipment_Forecast__c).First_Request_Date_IGU__c;
                    sflList.add(obj);
                }
            }       
        }
        
        if(sflList.size()>0 && !sflList.isEmpty()){
            try{            
                update sflList;
            }catch(Exception Ex){
                 System.debug('Exception'+Ex);
            }
        }
    }*/
}