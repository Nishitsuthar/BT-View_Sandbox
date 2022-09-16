public class OppSyncToBidQuoteController {

    public static void OppSyncToBidQuote(List<SBQQ__Quote__c> quotes)
    {
       // Veriables  
       List<SBQQ__Quote__c> bidQuotes = new List<SBQQ__Quote__c>(); 
       List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
       List<Id> opportunityIds = new List<Id>();
       List<Opportunity> relatedOpportunity = new List<Opportunity>();
       Map<Id,Opportunity> mapOfrelatedOpportunity = new Map<Id,Opportunity>();
       List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
       Map<Id,List<OpportunityLineItem>> realtedOpporunitiesProduct = new Map<Id,List<OpportunityLineItem>>();
       Map<Id,List<SBQQ__Quote__c>> mapOfoppRelatedQuotes = new Map<Id,List<SBQQ__Quote__c>>();
       List<SBQQ__Quote__c> oppRelatedQuotes = new List<SBQQ__Quote__c>();

       List<Id> opptyRecordtype = new List<Id>();
       opptyRecordtype.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId());
       opptyRecordtype.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId());
       opptyRecordtype.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Multi Project Opportunity').getRecordTypeId());
       
       Id QuoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Bid Quote Record Type').getRecordTypeId();

      
       for(SBQQ__Quote__c quote :quotes)
       {
            if(quote.RecordTypeId  == QuoteRecordtype)
            {
                bidQuotes.add(quote);
                opportunityIds.add(quote.Related_Opportunity__c);
            }
       }
       
       
       relatedOpportunity = [SELECT Id,RecordTypeId FROM Opportunity WHERE ID IN: opportunityIds];

       for(Opportunity oppList : relatedOpportunity)
        {
            mapOfrelatedOpportunity.put(oppList.Id, oppList);
        }

       oppRelatedQuotes = [SELECT Id,SBQQ__Opportunity2__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c IN : relatedOpportunity AND RecordTypeId != : QuoteRecordtype];

       
              
       for(SBQQ__Quote__c oppRelatedQuote : oppRelatedQuotes) {
                                        if(mapOfoppRelatedQuotes.containsKey(oppRelatedQuote.SBQQ__Opportunity2__c))
                                        {
                                           mapOfoppRelatedQuotes.get(oppRelatedQuote.SBQQ__Opportunity2__c).add(oppRelatedQuote);
                                        }
                                        else
                                        {
                                           mapOfoppRelatedQuotes.put(oppRelatedQuote.SBQQ__Opportunity2__c,new List<SBQQ__Quote__c>{oppRelatedQuote}); 
                                        }
                                    
                                    }


       oppLineItems = [SELECT Id,OpportunityId,Quantity,ListPrice,UnitPrice,Product2Id,CurrencyIsoCode FROM OpportunityLineItem WHERE OpportunityId IN : opportunityIds];

       for(OpportunityLineItem oppLineItem : oppLineItems) {
                                        if(realtedOpporunitiesProduct.containsKey(oppLineItem.OpportunityId))
                                        {
                                           realtedOpporunitiesProduct.get(oppLineItem.OpportunityId).add(oppLineItem);
                                        }
                                        else
                                        {
                                           realtedOpporunitiesProduct.put(oppLineItem.OpportunityId,new List<OpportunityLineItem>{oppLineItem}); 
                                        }
                                    
                                    }
       
       for(SBQQ__Quote__c quote : bidQuotes)
       {
           if(!quote.isClone())
           {
               List<OpportunityLineItem> oppLines = new List<OpportunityLineItem>();
               oppLines = realtedOpporunitiesProduct.get(quote.Related_Opportunity__c);
               Id thisOppRecordType;
               if(mapOfrelatedOpportunity.containskey(quote.Related_Opportunity__c)){
                   thisOppRecordType = mapOfrelatedOpportunity.get(quote.Related_Opportunity__c).RecordTypeId;
               }               
               if(mapOfoppRelatedQuotes.containsKey(quote.Related_Opportunity__c) && opptyRecordtype.contains(mapOfrelatedOpportunity.get(quote.Related_Opportunity__c).RecordTypeId))
               {
               
                    for(OpportunityLineItem oppLineItem : oppLines)
                    {
                        SBQQ__QuoteLine__c newQuoteLine = new SBQQ__QuoteLine__c();
    
                        newQuoteLine.SBQQ__Quantity__c = oppLineItem.Quantity;
                        newQuoteLine.SBQQ__ListPrice__c = oppLineItem.UnitPrice;
                        newQuoteLine.CurrencyIsoCode = oppLineItem.CurrencyIsoCode;
                        newQuoteLine.SBQQ__NetPrice__c = oppLineItem.UnitPrice;
                        newQuoteLine.SBQQ__Product__c = oppLineItem.Product2Id;
                        newQuoteLine.SBQQ__PriceEditable__c = True;
                        //newQuoteLine.CPQ_PriceFromOpportunityItems__c = oppLineItem.UnitPrice;
                        newQuoteLine.SBQQ__Quote__c = quote.Id;
    
                        quoteLines.add(newQuoteLine);
                    }
               }

           //quote.SBQQ__Opportunity2__c = null;
           }

       }
       
       if(!quoteLines.isEmpty())
       {
           Insert quoteLines;
           //Update bidQuotes;
       }
      


    }
}