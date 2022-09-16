public class BudgetaryEstimate {
       public static Boolean isTriggerFired = false;
       public BudgetaryEstimate(){
       }

       /*public void CloneQuote(Id OppId){
            SBQQ__Quote__c QuoteObj;
            
            System.debug('MS 1 = ' + OppId);

            QuoteObj= [Select Id, Name, SBQQ__Opportunity2__c FROM SBQQ__Quote__c  Where SBQQ__Opportunity2__c = :OppId AND SBQQ__Primary__c=TRUE];

            Map<String, Schema.SObjectField> quoteFields = Schema.getGlobalDescribe().get('SBQQ__Quote__c').getDescribe().fields.getMap();
            List<String> fieldNames = new List<String>(quoteFields.keySet());    
            String queryString = 'SELECT '; 
            for (String fieldName : fieldnames) queryString = queryString + fieldname + ',';
            queryString = queryString.removeEnd(',') + ' FROM SBQQ__Quote__c WHERE ID = \''+QuoteObj.Id+'\'';
            System.debug('MS 2 = ' + queryString);
            List<SBQQ__Quote__c> quoteList = Database.query(queryString);
            SBQQ__Quote__c quote =  quoteList[0];
            SBQQ__Quote__c newQuote = quote.clone(false);
            newQuote.Quote_Plan__c ='All In';
            newQuote.Quote_Type__c='All In';
            newQuote.Template_Type__c='BUDGET';
            newQuote.Lead_Time_Weeks__c='16';    
            newQuote.SBQQ__Primary__c=False;
            newQuote.RecordTypeId ='0120h000000YOJu';
        
            insert newQuote;
            System.debug('MS 3');
            
            Map<String, Schema.SObjectField> quoteLineFields = Schema.getGlobalDescribe().get('SBQQ__QuoteLine__c').getDescribe().fields.getMap();
            fieldNames = new List<String>(quoteLineFields.keySet());
            queryString = 'SELECT '; 
            for (String fieldName : fieldnames) queryString = queryString + fieldname + ',';
            queryString = queryString.removeEnd(',') + ' FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = \''+QuoteObj.Id+'\'';
            
            System.debug('MS 4 = ' + queryString);
            List<SBQQ__QuoteLine__c> quoteLines = Database.query(queryString);
            List<SBQQ__QuoteLine__c> newQuoteLines = new List<SBQQ__QuoteLine__c>();

            for (SBQQ__QuoteLine__c qli : quoteLines) {
                          SBQQ__QuoteLine__c newqli = qli.clone(false);
                          newqli.SBQQ__Quote__c = newQuote.id;
                          newQuoteLines.add(newqli);
            }
            System.debug('MS 5 ');
            insert newQuoteLines;                    
            System.debug('MS 6');
}*/


        public static void CloneQuote(list<Id> OppIdList){
            //isTriggerFired = true;
            Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>();            
            SBQQ__Quote__c newQuote;
            List<SBQQ__Quote__c> quoteList;
            List<Id> quoteIdList = new list<Id>();
            List<SBQQ__QuoteLine__c> quoteLines;
            List<SBQQ__QuoteLine__c> newQuoteLines = new List<SBQQ__QuoteLine__c>();
            String queryString = '';
            List<String> fieldNames;
            for(SBQQ__Quote__c obj : [Select Id, Name, SBQQ__Opportunity2__c FROM SBQQ__Quote__c  
                                                WHERE SBQQ__Opportunity2__c in:OppIdList 
                                                    AND SBQQ__Primary__c=true]){                    
                //quoteMap.put(obj.Id, obj);
                quoteIdList.add(obj.Id);
            }
            if(quoteIdList.Size()>0){
                Map<String, Schema.SObjectField> quoteFields = Schema.getGlobalDescribe().get('SBQQ__Quote__c').getDescribe().fields.getMap();
                fieldNames = new List<String>(quoteFields.keySet());
                queryString = 'SELECT ';
                for (String fieldName : fieldnames) {
                    queryString = queryString + fieldname + ',';
                }           
                queryString = queryString.removeEnd(',') + ' FROM SBQQ__Quote__c WHERE ID = \''+quoteIdList[0]+'\'';
            }
            System.debug('MS 2 = ' + queryString);
            if(queryString<>null){
                 quoteList = Database.query(queryString);
            }
            if(quoteList.size()>0){
                System.debug('#####'+quoteList[0].Quote_Plan__c);
                System.debug('#####'+quoteList[0].IGU_Freight_Estimate__c);
                System.debug('#####'+quoteList[0].Quote_Type__c);
                System.debug('#####'+quoteList[0].Template_Type__c);
                System.debug('#####'+quoteList[0].Lead_Time_Weeks__c);
                System.debug('#####'+quoteList[0].SBQQ__Primary__c);
                System.debug('#####'+quoteList[0].RecordTypeId);
                newQuote = quoteList[0].clone(false);
                newQuote.Quote_Plan__c ='All In';
                newQuote.Quote_Type__c='All In';
                newQuote.Template_Type__c='BUDGET';
                newQuote.Lead_Time_Weeks__c='16';    
                newQuote.SBQQ__Primary__c=False;
                newQuote.SBQQ__Source__c=null;
                newQuote.RecordTypeId =Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Budgetary_Estimate').getRecordTypeId();
                insert newQuote;
                System.debug(newQuote.Quote_Plan__c);
                System.debug(newQuote.IGU_Freight_Estimate__c);
                System.debug(newQuote);
                //System.debug(newQuote);
            }           
            System.debug('MS 3');
            if(newQuote<>null){
                Map<String, Schema.SObjectField> quoteLineFields = Schema.getGlobalDescribe().get('SBQQ__QuoteLine__c').getDescribe().fields.getMap();
                fieldNames = new List<String>(quoteLineFields.keySet());
                queryString = 'SELECT '; 
                for (String fieldName : fieldnames) queryString = queryString + fieldname + ',';{
                    queryString = queryString.removeEnd(',') + ' FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = \''+quoteList[0].Id+'\'';
                }
            }            
            System.debug('MS 4 = ' + queryString);
            quoteLines = Database.query(queryString);
            for (SBQQ__QuoteLine__c qli : quoteLines) {
                  SBQQ__QuoteLine__c newqli = qli.clone(false);
                  newqli.SBQQ__Quote__c = newQuote.id;
                  newQuoteLines.add(newqli);
            }
            System.debug('MS 5 ');
            insert newQuoteLines;                    
            System.debug('MS 6');
        }
}

/*Map<String, Schema.SObjectField> quoteFields = Schema.getGlobalDescribe().get('SBQQ__Quote__c').getDescribe().fields.getMap();
List<String> fieldNames = new List<String>(quoteFields.keySet());
String queryString = 'SELECT '; 
for (String fieldName : fieldnames) queryString = queryString + fieldname + ',';
queryString = queryString.removeEnd(',') + ' FROM SBQQ__Quote__c WHERE ID = \'a830h000000TNbAAAW\'';
System.debug('Query = ' + queryString);
List<SBQQ__Quote__c> quoteList = Database.query(queryString);   
System.debug(quoteList[0]);*/