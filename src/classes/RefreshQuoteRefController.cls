// 06-Jan-2021			Srikanth		DealDesk SOP Findinds DD_SOP_Findings_Jan_2021			DealDesk SOP Findings
public without sharing class RefreshQuoteRefController {
    
    Map<Id, QuoteWrapper> map_QId_QWrapper;
    Map<Id, OrderEntryReleaseWrapper> map_OERId_OER;
    Id oerId;

    public RefreshQuoteRefController(ApexPages.StandardController controller) {

        oerId = controller.getRecord().Id;

        //Get Order Entry Release and realted lines and add them to corresponding wrappers.
        ////DD_SOP_Findings_Jan_2021 - added Unit_Area_Sq_Ft__c, RecordType.Name
        Order_Entry_Release__c OER = [SELECT Id, CPQ_Quote__c, Quote__c,
                                        (SELECT Id, CurrencyISOCode, RecordTypeId, Product__c, Order_Entry_Release__c, CPQ_Quote_Line__c,
                                            Quote_Line_Item__c, Unit_Price__c, Line_Number__c, Unit_Area_Sq_Ft__c, RecordType.Name
                                        FROM Order_Entry_Lines__r where (NOT Status__c LIKE 'Cancel%'))
                                        FROM Order_Entry_Release__c
                                        WHERE Id = :controller.getRecord().Id];

        map_OERId_OER = new Map<Id, OrderEntryReleaseWrapper>();                                
        map_OERId_OER.put(OER.Id, new OrderEntryReleaseWrapper(OER));
        for(Order_Entry_Line__c eachOELine : OER.Order_Entry_Lines__r) {
            map_OERId_OER.get(eachOELine.Order_Entry_Release__c).addOrderEntryLine(eachOELine, Schema.SObjectType.Order_Entry_Line__c.getRecordTypeInfosById().get(eachOELine.RecordTypeId).getDeveloperName());  
        }

        system.debug('Order Entry Release Wrapper Map Info:' + map_OERId_OER);

        //Get Related Quote and add them to wrappers.
        map_QId_QWrapper = new Map<Id, QuoteWrapper>();
        if(OER.CPQ_Quote__c != NULL) {
            SBQQ__Quote__c quote = [SELECT Id, CurrencyISOCode, RecordTypeId, name, SBQQ__Opportunity2__c,
                                        (SELECT Id, SBQQ__Quote__c, SBQQ__Product__c, SBQQ__CustomerPrice__c,
                                            SBQQ__Discount__c, SBQQ__Quantity__c, Product_SKU__c,CurrencyISOCode FROM SBQQ__LineItems__r)
                                     FROM SBQQ__Quote__c
                                     WHERE id = :OER.CPQ_Quote__c];
            map_QId_QWrapper.put(quote.Id, new QuoteWrapper(quote));

            for(SBQQ__QuoteLine__c eachQLine : quote.SBQQ__LineItems__r) {
                map_QId_QWrapper.get(quote.Id).addQuoteLineItem(eachQLine);
            }
        }else if(OER.Quote__c != NULL) {
            Quote quote = [SELECT Id, name, CurrencyISOCode, OpportunityId, QuoteNumber,
                                (SELECT Id, QuoteId, Product2Id, UnitPrice, Discount,Product_SKU__c, CurrencyISOCode
                                 FROM QuoteLineItems)
                             FROM Quote
                             WHERE id = :OER.Quote__c]; 
            map_QId_QWrapper.put(quote.Id, new QuoteWrapper(quote));

            for(QuoteLineItem eachQLine : quote.QuoteLineItems) {
                map_QId_QWrapper.get(quote.Id).addQuoteLineItem(eachQLine);
            }
        }
    }

    public pageReference syncOrderWithQuote() {
        
        //Boolean hasException = false;
        //try{
            SyncQuoteToOrderUtil.synceQLRefAndPriceOnOERLines(map_QId_QWrapper, map_OERId_OER);
        //}catch(Exception e) {
            //hasException = true;
        //}

        //if(!hasException) {
            //return new pageReference('/' + oerId);
        //}

        //return null;
        return new pageReference('/' + oerId);
    }

    public pageReference backToOERPage() {
        return new pageReference('/' + oerId);
    }
}