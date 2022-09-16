public class QuoteLineWrapper
{
    public String source {get;set;}
    public Id quoteLineId {get;set;}
    public Id quoteId {get;set;}
    public Id productId {get;set;}
    public Decimal price {get;set;}
    public Decimal discount {get;set;}
    public Decimal quantity {get;set;}
    public String productSKU {get;set;}
    public String currencyISOCode {get; set;}
        
    
    public QuoteLineWrapper(SBQQ__QuoteLine__c ql)
    {
        this.source = 'CPQ';
        this.quoteLineId = ql.Id;
        this.quoteId = ql.SBQQ__Quote__c;
        this.productId = ql.SBQQ__Product__c;
        this.price = ql.SBQQ__CustomerPrice__c;
        this.discount = ql.SBQQ__Discount__c;
        this.quantity = ql.SBQQ__Quantity__c;
        this.productSKU = ql.Product_SKU__c;
        this.currencyISOCode = ql.currencyISOCode;
    }
    
    public QuoteLineWrapper(QuoteLineItem ql)
    {
        this.source = 'SFDC';
        this.quoteLineId = ql.Id;
        this.quoteId = ql.QuoteId;
        this.productId = ql.Product2Id;
        this.price = ql.UnitPrice;
        this.discount = ql.Discount;
        this.quantity = 0.0;
        this.productSKU = ql.Product_SKU__c;
        this.currencyISOCode = ql.currencyISOCode;
    }

}