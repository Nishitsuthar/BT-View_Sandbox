public class OpportunityProjectsController {

   public String filterProjects { get; set; }
   public String Quantity { get; set; }
   public String installStatus { get; set; }
   public String installType { get; set; }
   public String SupportRegion { get; set; }
   public String MarketSegment {get; set;}
   public Integer NumberOfProj {get; set;}
   public String Closeddate {get;set;}
   public String Stage {get; set;}
   string query;
   //  string str = '\'Active\',\'Service\'';

    
public List<Opportunity> getProjectAddressList() {
  
 
//system.debug(query);

String[] ss = new String[]{'On Track', 'Service', 'On Hold'};


String[] stg = new String[]{'Closed: Won', 'Booked', 'Partial Release', 'Released to Factory', 'Partial Shipment', 'Product Shipped', 'Invoiced','Non-Revenue Completed'};

    
  //To check TLS version 
  //  String a=ApexPages.currentPage().getHeaders().get('CipherSuite');
        
      //  System.debug('++++++++'+a); 

  

     If(Stage==null)
     {  
      query = 'select Id, Name, StageName, Support_Region__c, GeoLocation__Latitude__s, GeoLocation__Longitude__s, Project_Address__c,Project_City__c,Project_State__c,Project_Country__c,Project_Zip_Code__c,Glass_Quantity__c,toLabel(Install_Status__c)  from Opportunity where GeoLocation__Latitude__s != null and toLabel(Install_Status__c) in :ss';

   
   
    if(Quantity != null) {
           if(Quantity =='1')
           query = query + ' and Glass_Quantity__c> 0 and Glass_Quantity__c < 1000';
            else if(Quantity =='2')
                query = query + ' and Glass_Quantity__c > 1000 and Glass_Quantity__c < 5000';
           else if(Quantity =='3')
                query = query + ' and Glass_Quantity__c > 5000';
           else if(Quantity =='4')
                query = query + ' and Glass_Quantity__c > 5000 and Glass_Quantity__c < 10000';
           else if(Quantity =='5')
                query = query + ' and Glass_Quantity__c > 10000 and Glass_Quantity__c < 20000';
           else if(Quantity =='6')
                query = query + ' and Glass_Quantity__c > 20000 and Glass_Quantity__c < 50000';
           else if(Quantity =='7')
                query = query + ' and Glass_Quantity__c > 50000';
           else if(Quantity =='8')
                query = query + ' and Glass_Quantity__c > 10000';
           else if(Quantity =='9')
                query = query + ' and Glass_Quantity__c > 20000'; 
           
       }  
       if(installStatus != null) {
          query=query+' and Install_Status__c  = \''+ installStatus +'\'';
         
         }  
       if(installType != null) {
          query=query+' and Install_Type__c  = \''+ installType +'\'';
        
         }  
       if(MarketSegment != null)
       {
           query=query+' and Market_Segment__c = \''+MarketSegment +'\'';
       }
        if(SupportRegion!= null)
       {
           query=query+' and Support_Region__c= \''+SupportRegion+'\'';
       }
       If(Closeddate != null)
       {
           if(Closeddate == '1')
           query = query + ' and Closedate >= 2015-01-01 and Closedate <= Today';
            else if(Closeddate == '2')
                query = query + ' and Closedate >= 2016-01-01 and Closedate <= Today';
           else if(Closeddate == '3')
                query = query + ' and Closedate >= 2017-01-01 and Closedate <= Today';
       }
       
    }
    else
    {
     query = 'select Id, StageName, Name, Support_Region__c, GeoLocation__Latitude__s, GeoLocation__Longitude__s, Project_Address__c,Project_City__c,Project_State__c,Project_Country__c,Project_Zip_Code__c,Glass_Quantity__c,Install_Status__c from Opportunity where GeoLocation__Latitude__s != null and StageName in :stg';
     
      if(Quantity != null) {
           if(Quantity =='1')
           query = query + ' and Glass_Quantity__c  > 0 and Glass_Quantity__c < 1000';
            else if(Quantity =='2')
                query = query + ' and Glass_Quantity__c  > 1000 and Glass_Quantity__c < 5000';
           else if(Quantity =='3')
                query = query + ' and Glass_Quantity__c  > 5000';
           else if(Quantity =='4')
                query = query + ' and Glass_Quantity__c  > 5000 and Glass_Quantity__c  < 10000';
           else if(Quantity =='5')
                query = query + ' and Glass_Quantity__c  > 10000 and Glass_Quantity__c  < 20000';
           else if(Quantity =='6')
                query = query + ' and Glass_Quantity__c  > 20000 and Glass_Quantity__c  < 50000';
           else if(Quantity =='7')
                query = query + ' and Glass_Quantity__c  > 50000';
           else if(Quantity =='8')
                query = query + ' and Glass_Quantity__c  > 10000';
           else if(Quantity =='9')
                query = query + ' and Glass_Quantity__c > 20000'; 
           
       } 
       if(installType != null) {
          query=query+' and Install_Type__c  = \''+ installType +'\'';
       
         }   
       if(installStatus != null) {
          query=query+' and Install_Status__c  = \''+ installStatus +'\'';
       
         }  
       if(MarketSegment != null)
       {
           query=query+' and Market_Segment__c = \''+MarketSegment +'\'';
       }
        if(SupportRegion!= null)
       {
           query=query+' and Support_Region__c= \''+SupportRegion+'\'';
       }
       If(Closeddate != null)
       {
           if(Closeddate == '1')
           query = query + ' and Closedate >= 2015-01-01 and Closedate <= Today';
            else if(Closeddate == '2')
                query = query + ' and Closedate >= 2016-01-01 and Closedate <= Today';
           else if(Closeddate == '3')
                query = query + ' and Closedate >= 2017-01-01 and Closedate <= Today';
       }
       
    }

    
    List<Opportunity> OppRecords = Database.query(query);
    NumberOfProj = OppRecords.size();

    
    return OppRecords;
    }
     
  
}