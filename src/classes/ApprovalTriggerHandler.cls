public without sharing class ApprovalTriggerHandler {
	  
    
    public static void beforeUpdate(list<sbaa__Approval__c> approvalRecs, Map<id,sbaa__Approval__c> newmap){
        for(sbaa__Approval__c approval:approvalRecs)
        {
            system.debug('newmap>>'+newmap);
            system.debug('approval.sbaa__Status__c>>'+approval.sbaa__Status__c);
            if(newmap!=null && approval.sbaa__Status__c!=newmap.get(approval.id).sbaa__Status__c){
                if(approval.sbaa__Status__c=='Requested'){
                    approval.Request_Date_and_Time__c=Datetime.now();
                }
                if(approval.sbaa__Status__c=='Approved'||approval.sbaa__Status__c=='Rejected'){
                    approval.Action_Date_and_Time__c=Datetime.now();
                }
            }else{
                if(approval.sbaa__Status__c=='Requested'){
                    approval.Request_Date_and_Time__c=Datetime.now();
                }
            }
        }
        
    }
    public static void afterUpdate(list<sbaa__Approval__c> approvalRecs, Map<id,sbaa__Approval__c> newmap){
        Set<String> quoteIds= new Set<String>();
        Set<String> UniqueQuote= new Set<String>();
        for(sbaa__Approval__c approval:approvalRecs)
        {
            if((newmap==null && approval.sbaa__Status__c=='Requested') || (newmap!=null && approval.sbaa__Status__c!=newmap.get(approval.id).sbaa__Status__c && ( approval.sbaa__Status__c=='Approved'||approval.sbaa__Status__c=='Recalled'||approval.sbaa__Status__c=='Rejected'))){
                //approval.Action_Date_and_Time__c=Datetime.now();
                quoteIds.add(approval.Quote__c);
            }
        }
        
    Map<id,SBQQ__Quote__c> quoteMap= new Map<id,SBQQ__Quote__c>([select id,Case__c,Approval_Action_taken_Date_and_time__c,Approval_Requested_Datetime__c from
                                                                      SBQQ__Quote__c where id in :quoteIds]);
        list<SBQQ__Quote__c> quoteList= new list<SBQQ__Quote__c>();
         for(sbaa__Approval__c approval:approvalRecs)
        {
            if(quoteMap!=null && quoteMap.containskey(approval.Quote__c) ){
               SBQQ__Quote__c quoteRecord= quoteMap.get(approval.Quote__c);
                if(quoteRecord.Case__c==null){
                    if(quoteRecord.Approval_Requested_Datetime__c==null && approval.sbaa__Status__c=='Requested'){
                        quoteRecord.Approval_Requested_Datetime__c=Datetime.now();
                    }
                    if(approval.sbaa__Status__c=='Recalled' && quoteRecord.Approval_Action_taken_Date_and_time__c==null && newmap!=null && approval.sbaa__Status__c!=newmap.get(approval.id).sbaa__Status__c){
                        quoteRecord.Approval_Requested_Datetime__c=null;
                    }
                }
                if(approval.sbaa__Status__c=='Approved'||approval.sbaa__Status__c=='Rejected'){
                    quoteRecord.Approval_Action_taken_Date_and_time__c=Datetime.now();
                    
                }
                if(!UniqueQuote.contains(quoteRecord.id)){
                    UniqueQuote.add(quoteRecord.id);
                    quoteList.add(quoteRecord);
                }
            }
        }
        if(!quoteList.isempty()){
            update quoteList;
        }
        
    }
    
    
}