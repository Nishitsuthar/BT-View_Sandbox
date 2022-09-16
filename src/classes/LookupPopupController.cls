//
// Custom controller for lookup example popup page
//
public with sharing class LookupPopupController 
{
    public String query {get; set;}
    public List<Product2> products{get; set;}
    public Map<Id,Decimal> prodIdToPrice {get;set;}
    String qPBID;
    String oppPBID;
    String Id;
  
    
    public LookupPopupController (){
        //qPBID = System.currentPageReference().getParameters().get('qPB');
        oppPBID = System.currentPageReference().getParameters().get('oPB');
        //query  = System.currentPageReference().getParameters().get('qPB');
        Id = System.currentPageReference().getParameters().get('idfield');
        System.debug('oppPBID :::::::'+oppPBID +'qPBID ::'+qPBID );
        runQuery();
    }
    
    public PageReference runQuery()
    {
        products = new List<Product2>();
        prodIdToPrice  =  new Map<Id,Decimal>();
        String soql = 'select id, name, Family from Product2';
        if(query  != '' && query != null)
            soql = soql +  ' where name LIKE \'%' + query  +'%\'';
    
        if(oppPBID  != '' && oppPBID != null ){
            if(!soql.contains('where')){
                soql = soql + ' Where ';
            }else{
                soql = soql + ' AND ';
            }
            Set<Id> prodIds = new Set<Id>();
            
            for(PricebookEntry p : [Select id, Product2Id, UnitPrice from PricebookEntry where Pricebook2Id  = :oppPBID]){
                prodIds.add(p.Product2Id); 
                prodIdToPrice.put(p.Product2Id, p.UnitPrice);  
            }
            
            soql = soql + ' Id in :prodIds' ; //\'' +pbEntryIds+'\'';
            
        }
        soql = soql + ' limit 25';
            System.debug(soql);
            products = database.query(soql);
        return null;
    }
}