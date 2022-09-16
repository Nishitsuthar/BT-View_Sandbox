public class OrderEntryReleaseTriggerHandler{
    
    public static void OpptyFirstOrderBookedUpdate(List<string> oppids){
        
       list<Opportunity> oppwithorders = [select id,Name,Scheduled_Ship_Date_IGU__c,Scheduled_Ship_Date_CSS__c,First_Request_Date_IGU__c,
                                          First_Request_Date_CSS__c,(select id,Order_Type__c,Extended_Price_Total__c,Sales_Order_Status__c,Order_Book_Date__c,Opportunity__c,
                          Opportunity__r.First_Order_Booked_Date__c,Scheduled_Ship_Date__c,RecordType.Id 
                          from Order_Entry_Releases__r 
                          where Opportunity__c =:oppids 
                          and Order_Book_Date__c !=null
                          order by Order_Book_Date__c ASC limit 1) from Opportunity where id=:oppids];
        
list<Opportunity> updateopp = new list<Opportunity>();        
       for(Opportunity opp:oppwithorders)
    {
        system.debug('aa'+opp.Order_Entry_Releases__r.size());
        if(opp.Order_Entry_Releases__r.size()>0)
        {
            for(Order_Entry_Release__c ore:opp.Order_Entry_Releases__r)
            {
                   opp.First_Order_Booked_Date__c = date.valueof(ore.Order_Book_Date__c);
            }
        }
        else
        {
             opp.First_Order_Booked_Date__c=null;
        }
       updateopp.add(opp); 
        
    }
     update updateopp;   
    } 
    
    public static void IGUshiptodatefiledUpdate(List<string> oppids) {
        
        list<Opportunity> oppwithorders = [select id,Name,Scheduled_Ship_Date_IGU__c,Scheduled_Ship_Date_CSS__c,First_Request_Date_IGU__c,
                                          First_Request_Date_CSS__c,(select id,Scheduled_Ship_Date__c,RecordTypeId, Opportunity__c from Order_Entry_Releases__r 
                                                           where Opportunity__c =: oppids and Scheduled_Ship_Date__c != null
                                                           and Status__c != 'Cancelled' and  RecordType.Name='IGU'
                                                           order by Scheduled_Ship_Date__c ASC limit 1) from Opportunity where id=:oppids];
        list<Opportunity> updateopp = new list<Opportunity>();
       
    for(Opportunity opp:oppwithorders)
    {
        system.debug('aa'+opp.Order_Entry_Releases__r.size());
        if(opp.Order_Entry_Releases__r.size()>0)
        {
        for(Order_Entry_Release__c ore:opp.Order_Entry_Releases__r)
        {
            opp.Scheduled_Ship_Date_IGU__c= ore.Scheduled_Ship_Date__c;
        }
        }
        else{
            opp.Scheduled_Ship_Date_IGU__c = opp.First_Request_Date_IGU__c;
        }
        updateopp.add(opp);
    }
      update updateopp;
    }
    
    public static void CSSshiptodatefiledUpdate(List<string> oppids) {
        
        
        list<Opportunity> oppwithorders = [select id,Name,Scheduled_Ship_Date_IGU__c,Scheduled_Ship_Date_CSS__c,First_Request_Date_IGU__c,
                                          First_Request_Date_CSS__c,(select id,Scheduled_Ship_Date__c,RecordTypeId, Opportunity__c from Order_Entry_Releases__r 
                                                           where Opportunity__c =: oppids and Scheduled_Ship_Date__c != null
                                                           and Status__c != 'Cancelled' and  RecordType.Name='Control Hardware'
                                                           order by Scheduled_Ship_Date__c ASC limit 1) from Opportunity where id=:oppids];
        list<Opportunity> updateopp = new list<Opportunity>();
      
       
    for(Opportunity opp:oppwithorders)
    {
        system.debug('aa'+opp.Order_Entry_Releases__r.size());
        if(opp.Order_Entry_Releases__r.size()>0)
        {
        for(Order_Entry_Release__c ore:opp.Order_Entry_Releases__r)
        {
            opp.Scheduled_Ship_Date_CSS__c= ore.Scheduled_Ship_Date__c;
        }
        }
        else{
            opp.Scheduled_Ship_Date_CSS__c = opp.First_Request_Date_CSS__c;
        }
        updateopp.add(opp);
    }
      update updateopp; 
    }
    
    
}