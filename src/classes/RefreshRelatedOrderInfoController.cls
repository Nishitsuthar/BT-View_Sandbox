// 06-Jan-2021			Srikanth		DealDesk SOP Findinds DD_SOP_Findings_Jan_2021			DealDesk SOP Findings
// 06-Jan-2021 		    Rekha    	    SOS Hold Invoice      SOS_HOLD_INVOICE   
public without sharing class RefreshRelatedOrderInfoController {
    
    Map<Id, QuoteWrapper> map_QId_QWrapper;
    Map<Id, OrderEntryReleaseWrapper> map_OERId_OER;
    Id quoteId;

    public RefreshRelatedOrderInfoController(ApexPages.StandardController controller) {

        quoteId = controller.getRecord().Id;
        Set<Id> oerIds = new Set<Id>();

        //Get Quote and related lines add them to wrappers.
        map_QId_QWrapper = new Map<Id, QuoteWrapper>();
        if(quoteId.getsobjecttype() == SBQQ__Quote__c.sObjectType) {
            SBQQ__Quote__c quote = [SELECT Id, CurrencyISOCode, RecordTypeId, name, SBQQ__Opportunity2__c,
                                        (SELECT Id, SBQQ__Quote__c, SBQQ__Product__c, SBQQ__CustomerPrice__c,
                                            SBQQ__Discount__c, SBQQ__Quantity__c, Product_SKU__c,CurrencyISOCode
                                            FROM SBQQ__LineItems__r),
                                        (SELECT Id, CPQ_Quote__c, Quote__c
                                            FROM Order_Entry_Releases__r where (NOT Status__c LIKE 'Cancel%'))
                                     FROM SBQQ__Quote__c
                                     WHERE id = :quoteId];
            for(Order_Entry_Release__c eachOER : quote.Order_Entry_Releases__r) {
                oerIds.add(eachOER.Id);
            }                
            map_QId_QWrapper.put(quote.Id, new QuoteWrapper(quote));    

            for(SBQQ__QuoteLine__c eachQLine : quote.SBQQ__LineItems__r) {
                map_QId_QWrapper.get(quote.Id).addQuoteLineItem(eachQLine);
            }
        } else if(quoteId.getsobjecttype() == Quote.sObjectType) {
            Quote quote = [SELECT Id, name, CurrencyISOCode, OpportunityId, QuoteNumber,
                                (SELECT Id, QuoteId, Product2Id, UnitPrice, Discount,Product_SKU__c, CurrencyISOCode
                                    FROM QuoteLineItems),
                                (SELECT Id, CPQ_Quote__c, Quote__c
                                    FROM Order_Entry_Releases__r where (NOT Status__c LIKE 'Cancel%'))
                             FROM Quote
                             WHERE id = :quoteId];  
            for(Order_Entry_Release__c eachOER : quote.Order_Entry_Releases__r) {
                oerIds.add(eachOER.Id);
            }
            map_QId_QWrapper.put(quote.Id, new QuoteWrapper(quote));

            for(QuoteLineItem eachQLine : quote.QuoteLineItems) {
                map_QId_QWrapper.get(quote.Id).addQuoteLineItem(eachQLine);
            }
        }
        
        //Get Order Entry Release and realted lines and add them to corresponding wrappers.
        //DD_SOP_Findings_Jan_2021 - added Unit_Area_Sq_Ft__c, RecordType.Name
        map_OERId_OER = new Map<Id, OrderEntryReleaseWrapper>();
        for(Order_Entry_Release__c OER : [SELECT Id, CPQ_Quote__c, Quote__c,
                                        (SELECT Id, CurrencyISOCode, RecordTypeId, Product__c, Order_Entry_Release__c, CPQ_Quote_Line__c,
                                            Quote_Line_Item__c, Unit_Price__c, Line_Number__c, Unit_Area_Sq_Ft__c, RecordType.Name
                                        FROM Order_Entry_Lines__r where (NOT Status__c LIKE 'Cancel%'))
                                        FROM Order_Entry_Release__c
                                        WHERE Id IN :oerIds AND (NOT Status__c LIKE 'Cancel%')]) {

            map_OERId_OER.put(OER.Id, new OrderEntryReleaseWrapper(OER));
            for(Order_Entry_Line__c eachOELine : OER.Order_Entry_Lines__r) {
                map_OERId_OER.get(eachOELine.Order_Entry_Release__c).addOrderEntryLine(eachOELine, Schema.SObjectType.Order_Entry_Line__c.getRecordTypeInfosById().get(eachOELine.RecordTypeId).getDeveloperName());  
            }
        }

        system.debug('Order Entry Release Wrapper Map Info:' + map_OERId_OER);
        system.debug('Quote Wrapper Map Info:' + map_QId_QWrapper);
    }

    public pageReference syncQuoteWithOrders() {

        /*Boolean hasException = false;
        try{
        */  
        if (verifyOERStatus(map_OERId_OER) == 'success' ){
            SyncQuoteToOrderUtil.synceQLRefAndPriceOnOERLines(map_QId_QWrapper, map_OERId_OER);
            return new pageReference('/' + quoteId);
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Refresh Related Order Info is not supported as some of the associated Orders Status dont allow pricing refresh'));
            return null;
        }
            
        /*}catch(Exception e) {
            hasException = true;
        }

        if(!hasException) {
            return new pageReference('/' + quoteId);
        }

        return null;*/
        //return new pageReference('/' + quoteId);
    }

    public pageReference backToQuotePage() {
        return new pageReference('/' + quoteId);
    }
    public static string verifyOERStatus(Map<Id, OrderEntryReleaseWrapper> map_OERId_OER)
    {  
        Set<String> refreshNotAllowed = new Set<String> { 'Confirmation Requested', 'Integration Requested', 
            'Cancellation Requested', 'Cancelled', 'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested', 'Cancellation Integration Requested', 'Cancellation Confirmed',
            'Change Confirmation Requested','Change Integration Requested','Partially Shipped', 'Shipped','Integration Error'};
                
        Set<String> refreshNotAllowedCSS= new Set<String> {'Integration Requested','Confirmation Requested','Confirmed', 'Change Confirmed',
                    'Cancellation Requested', 'Cancelled', 'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested','Cancellation Integration Requested', 'Cancellation Confirmed',
                    'Change Confirmation Requested','Change Integration Requested', 'Approval to Ship Requested','Partially Shipped','Shipped','Integration Error'};
                        
                        //Order_Entry_Release__c oer = [SELECT RecordType.developername,Status__c,Pre_Change_Status__c FROM Order_Entry_Release__c WHERE Id IN :map_OERId_OER.keyset()];
                        
        for (Order_Entry_Release__c oer:[SELECT RecordType.developername,Status__c,Pre_Change_Status__c FROM Order_Entry_Release__c WHERE Id IN :map_OERId_OER.keyset()]){
        	if ((oer.RecordType.developername.contains('IGU') && refreshNotAllowed.contains(oer.Status__c)) || 
            	(oer.RecordType.developername == Label.CSS_Hardware && refreshNotAllowedCSS.contains(oer.Status__c)) || 
                (oer.RecordType.developername == Label.CSS_Software && oer.Status__c != 'Draft')){ // SOS_HOLD_INVOICE  
                	return 'error';         
                }       
            else{
            	if (oer.Pre_Change_Status__c == 'Partially Shipped')
                	return 'error';
			}
		}
        return 'success';  
    }
}