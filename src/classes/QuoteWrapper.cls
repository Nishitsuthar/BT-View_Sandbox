public class QuoteWrapper
{   
    public id quoteId {get; set;}
    public Id opportunityID {get; set;}
    public String source {get; set;}    
    public String name {get; set;}
    public String quoteNumber {get; set;}
    public Id recordTypeId {get; set;}
    public SObject quote {get; set;}
    public String currencyISOCode {get; set;}
  
    public Map<Id, QuoteLineWrapper> qlwMap = new Map<Id, QuoteLineWrapper>();
    
    public QuoteWrapper (SBQQ__Quote__c qte)
    {
        this.source = 'CPQ';
        this.quoteId = qte.Id;
        this.opportunityId = qte.SBQQ__Opportunity2__c;
        this.name = qte.name;
        this.quoteNumber = qte.name;
        this.recordTypeId = qte.RecordTypeId;
        this.quote = qte;
        this.currencyISOCode = qte.currencyISOCode;        
    }

    public QuoteWrapper (Quote qte)
    {
        this.source = 'SFDC';
        this.quoteId = qte.Id;
        this.opportunityId = qte.OpportunityId;
        this.name = qte.name;
        this.quoteNumber = qte.QuoteNumber;
        this.recordTypeId = null;
        this.quote = qte;
        this.currencyISOCode = qte.currencyISOCode;       
    }
    
    public void addQuoteLineItem(QuoteLineItem qli)
    {
        if (this.source == 'CPQ')
        {
            System.debug( '**Error: CPQ Quote may not have SFDC Quote Lines');
        }
        else
        {
            QuoteLineWrapper qlw = new QuoteLineWrapper(qli);
            qlwMap.put(qlw.productId,qlw);
        }
        
    }
    
    
    public void addQuoteLineItem(SBQQ__QuoteLine__c qli)
    {
        if (this.source == 'SFDC')
        {
            System.debug('**Error: SFDC Quote may not have CPQ Quote Lines');
        }
        else
        {
            QuoteLineWrapper qlw = new QuoteLineWrapper(qli);
            qlwMap.put(qlw.productId,qlw);
        }
    }
    
    public QuoteLineWrapper getQuoteLineWrapper (Id ProductId)
    {
        if (qlwMap.keySet().contains(productId))
        {
            return qlwMap.get(productID);           
        }
        return null;
    }
    
    public QuoteLineItem getQuoteLine(Id productId)
    {
/*      if (qlwMap.keySet().contains(productId))
        {
            QuoteLine ql = qlwMap.get(productId);
            return new QuoteLineItem(Id = ql.quoteLineId, QuoteId = ql.quoteId, Product2Id = ql.productId, UnitPrice = ql.price, Discount = ql.discount);           
        } */
        return null;
    }
    
    public SBQQ__QuoteLine__c getCPQQuoteLine(Id productId)
    {
        // Method retained to support compatibility with earlier versions.
        return null;
    }
    
}