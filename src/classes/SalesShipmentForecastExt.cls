public class SalesShipmentForecastExt{
    public Id oppRecordId {get; set;}
    Public opportunity opp;
    public Sales_Shipment_Forecast__c ssf{get; set;}
    list<Sales_Shipment_Forecast__c> ssfList = new list<Sales_Shipment_Forecast__c>();
    list<Sales_Shipment_Forecast_Line__c> ssflList = new list<Sales_Shipment_Forecast_Line__c>();
    list<Sales_Shipment_Forecast_Line__c> newSsflList = new list<Sales_Shipment_Forecast_Line__c>();
    public SalesShipmentForecastExt(ApexPages.StandardsetController controller) {    
        //ssf = (Sales_Shipment_Forecast__c)controller.getRecord();
        
         oppRecordId = ApexPages.currentPage().getParameters().get('Id');
         opp=[select id,Ground_Breaking_Date__c, First_Request_Date_CSS__c, First_Request_Date_IGU__c from opportunity where Id=: oppRecordId];
         ssf= new Sales_Shipment_Forecast__c(Opportunity__c=oppRecordId);
         ssf.Forecast_Date__c = system.today();
         ssf.First_IGU_Shipment_Percentage__c= 100;
         ssf.First_CSS_Shipment_Percentage__c= 100;
         
        ssfList = [SELECT ID,Status__c,First_IGU_Shipment_Percentage__c,First_CSS_Shipment_Percentage__c,Opportunity__c, First_Request_Date_CSS__c, First_Request_Date_IGU__c, Groundbreaking_Date__c 
                                        FROM Sales_Shipment_Forecast__c WHERE Opportunity__c=:oppRecordId AND Status__c='Active'];
        /*if(ssfList<>null && ssfList.size()>0){
            for(Sales_Shipment_Forecast_Line__c obj: [SELECT ID,Status__c,Sales_Shipment_Forecast__c FROM Sales_Shipment_Forecast_Line__c 
                                                                            WHERE Sales_Shipment_Forecast__c IN:ssfList]){                
                obj.Status__c = 'Inactive';
                ssflList.add(obj);
            }
        }*/
        if(ssfList.isEmpty() && opp.Ground_Breaking_Date__c!=null)
        {
            
            ssf.Groundbreaking_Date__c = opp.Ground_Breaking_Date__c;
            ssf.First_Request_Date_IGU__c = ssf.Groundbreaking_Date__c.addDays(270);
            ssf.First_Request_Date_CSS__c = ssf.Groundbreaking_Date__c.addDays(360);
            ssf.First_IGU_Shipment_Percentage__c= 100;
            ssf.First_CSS_Shipment_Percentage__c= 100;
        }
        if(ssfList.size()>0 && ssfList<>null){                                
            ssf.First_Request_Date_IGU__c = ssfList[0].First_Request_Date_IGU__c;
            ssf.First_Request_Date_CSS__c = ssfList[0].First_Request_Date_CSS__c;
            ssf.Groundbreaking_Date__c = ssfList[0].Groundbreaking_Date__c;
            ssf.First_IGU_Shipment_Percentage__c= ssfList[0].First_IGU_Shipment_Percentage__c;
            ssf.First_CSS_Shipment_Percentage__c= ssfList[0].First_CSS_Shipment_Percentage__c;
            /*for(Sales_Shipment_Forecast_Line__c obj: ssfList){
                Sales_Shipment_Forecast_Line__c obj1 = new Sales_Shipment_Forecast_Line__c();
                obj1.Request_Date__c =obj.Request_Date__c;
                obj1.Product_Family__c =obj.Product_Family__c;
                obj1.Shipment_Percentage__c =obj.Shipment_Percentage__c;
                obj1.Status__c = 'Inactive';
                ssflList.add(obj1); */            
            }                                       
    }
    public PageReference Save(){    
        if(ssf.Groundbreaking_Date__c > ssf.First_Request_Date_IGU__c || ssf.Groundbreaking_Date__c > ssf.First_Request_Date_CSS__c)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Groundbreaking Date should be earlier than either of the request date.'));
            return null;
        }
        insert ssf; 
        Boolean oppUpdated = false;
        if(opp.Ground_Breaking_Date__c != ssf.Groundbreaking_Date__c) {opp.Ground_Breaking_Date__c = ssf.Groundbreaking_Date__c; oppUpdated=true;}
        if(opp.First_Request_Date_CSS__c != ssf.First_Request_Date_CSS__c) {opp.First_Request_Date_CSS__c = ssf.First_Request_Date_CSS__c; oppUpdated=true;}
        if(opp.First_Request_Date_IGU__c != ssf.First_Request_Date_IGU__c) {opp.First_Request_Date_IGU__c = ssf.First_Request_Date_IGU__c; oppUpdated=true;}
        
        if(oppUpdated){update opp; }    
                     
        //return new PageReference('/' + ssf.Id); 
        PageReference pr = new PageReference('/apex/EditSalesShipmentForecastLines');
        pr.getParameters().put('Id',ssf.Id);
        if(!ssfList.isEmpty())
        pr.getParameters().put('oldId',ssfList[0].Id);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;       
    }
    public PageReference continueLines(){ 
        if(!ssfList.isEmpty()){
           //insert ssf; 
                        
        
        PageReference pr = new PageReference('/apex/EditSalesShipmentForecastLines');
        //pr.getParameters().put('Id',ssf.Id);
        
        pr.getParameters().put('oldId',ssfList[0].Id);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;        
        }
        else
        return null;
    }
    public void populateRequetDate()
    {
        ssf.First_Request_Date_IGU__c = ssf.Groundbreaking_Date__c.addDays(270);
        ssf.First_Request_Date_CSS__c = ssf.Groundbreaking_Date__c.addDays(360);
    }
    public void populateRequetCSSDate()
    {
        
        ssf.First_Request_Date_CSS__c = ssf.First_Request_Date_IGU__c.addDays(90);
    }
}