/*****************************************************************************************************************

Author		: 		ENP Solutionz
Date 		: 		03/04/19
Description	: 		This class hosts utility functions that sync quote and order information.

*****************************************************************************************************************/
// 06-Jan-2021			Srikanth		DealDesk SOP Findinds DD_SOP_Findings_Jan_2021			DealDesk SOP Findings
public without sharing class SyncQuoteToOrderUtil {

	public class syncQuoteOERException extends Exception { }
	
	public static void synceQLRefAndPriceOnOERLines(Map<Id, QuoteWrapper> map_QId_QWrapper, Map<Id, OrderEntryReleaseWrapper> map_OERId_OER) {

		Map<Id, Order_Entry_Line__c> map_oelId_oel_updated = new Map<Id, Order_Entry_Line__c>();
		Map<Id, Order_Entry_Line__c> map_oelId_oel_QLRefNull = new Map<Id, Order_Entry_Line__c>();

		for(OrderEntryReleaseWrapper eachOERWrapper : map_OERId_OER.values()) {
			Id quoteId = eachOERWrapper.oer.CPQ_Quote__c != NULL?eachOERWrapper.oer.CPQ_Quote__c:eachOERWrapper.oer.Quote__c;
			if(quoteId != NULL && map_QId_QWrapper.containsKey(quoteId)) {
				QuoteWrapper qWrapper = map_QId_QWrapper.get(quoteId);
				Map<Id, QuoteLineWrapper> map_prdId_QLWrapper = qWrapper.qlwMap;
				for(OrderEntryLineWrapper eachOERLine : eachOERWrapper.oelwList) {

					system.debug('Each Order Entry Line:' + eachOERLine.oel);
					//Check if order line product exist on associated quote
					if(map_prdId_QLWrapper.containsKey(eachOERLine.oel.Product__c)) {
						
						//Check if quote line reference is same
						if(map_prdId_QLWrapper.get(eachOERLine.oel.Product__c).quoteLineId != (eachOERLine.oel.CPQ_Quote_Line__c != NULL?eachOERLine.oel.CPQ_Quote_Line__c:eachOERLine.oel.Quote_Line_Item__c)) {
							
							if(map_prdId_QLWrapper.get(eachOERLine.oel.Product__c).source == 'CPQ')
								eachOERLine.oel.CPQ_Quote_Line__c = map_prdId_QLWrapper.get(eachOERLine.oel.Product__c).quoteLineId;
							else if(map_prdId_QLWrapper.get(eachOERLine.oel.Product__c).source == 'SFDC')
								eachOERLine.oel.Quote_Line_Item__c = map_prdId_QLWrapper.get(eachOERLine.oel.Product__c).quoteLineId;									
						
							eachOERLine.oel.Trigger_Source__c = 'UI';
							map_oelId_oel_updated.put(eachOERLine.oel.Id, eachOERLine.oel);	
						}

						//Check if quote line and order line price matches and update on order line if do not match.
						if(map_prdId_QLWrapper.get(eachOERLine.oel.Product__c).price != eachOERLine.oel.Unit_Price__c) {
                            if (eachOERLine.oel.RecordType.Name.containsIgnoreCase('IGU'))
                                eachOERLine.oel.Unit_Price__c = eachOERLine.oel.Unit_Area_Sq_Ft__c * map_prdId_QLWrapper.get(eachOERLine.oel.Product__c).price;
							else
                                eachOERLine.oel.Unit_Price__c = map_prdId_QLWrapper.get(eachOERLine.oel.Product__c).price;
							

							eachOERLine.oel.Trigger_Source__c = 'UI';
							map_oelId_oel_updated.put(eachOERLine.oel.Id, eachOERLine.oel);
						}

					} else {//If product doesn't exist on quote, clear quote line reference.

						if(eachOERLine.oel.CPQ_Quote_Line__c != NULL) { 
							eachOERLine.oel.CPQ_Quote_Line__c = NULL;
							eachOERLine.oel.Trigger_Source__c = 'UI';
							map_oelId_oel_updated.put(eachOERLine.oel.Id, eachOERLine.oel);
						}else if(eachOERLine.oel.Quote_Line_Item__c != NULL) {
							eachOERLine.oel.Quote_Line_Item__c = NULL;
							eachOERLine.oel.Trigger_Source__c = 'UI';
							map_oelId_oel_updated.put(eachOERLine.oel.Id, eachOERLine.oel);
						}	

						//Track all order lines with no quote reference to check if price need to modified from product table.
						map_oelId_oel_QLRefNull.put(eachOERLine.oel.Id, eachOERLine.oel);					
					}
				}
			}
		}

		if(map_oelId_oel_QLRefNull.values().size() > 0) {

			Set<Id> prodIds = new Set<Id>();
			for(Order_Entry_Line__c eachOEL : map_oelId_oel_QLRefNull.values())
				if(eachOEL.Product__c != NULL)
					prodIds.add(eachOEL.Product__c);

			 Map<String, Decimal> priceBookEntryMap = new Map<String, Decimal>();				
			for (PricebookEntry pbe : [SELECT Id, Pricebook2Id, CurrencyISOCode, IsActive, Product2.Name, Product2.Id, Product2.Family,
											 Product2.IsActive, Product2.Description, UnitPrice, Product2.Product_SKU__c
									    FROM PricebookEntry
									    WHERE Product2.isActive=True AND IsActive=true  AND Product2.Id IN :prodIds])
            	priceBookEntryMap.put(pbe.Product2.Id + '-' + pbe.CurrencyISOCode , pbe.UnitPrice);

            for(Order_Entry_Line__c eachOEL : map_oelId_oel_QLRefNull.values())
            	if(priceBookEntryMap.containsKey(eachOEL.Product__c + '-' + eachOEL.CurrencyISOCode))
            		if(priceBookEntryMap.get(eachOEL.Product__c + '-' + eachOEL.CurrencyISOCode) != eachOEL.Unit_Price__c) {
            			eachOEL.Unit_Price__c = priceBookEntryMap.get(eachOEL.Product__c + '-' + eachOEL.CurrencyISOCode);
            			if(!map_oelId_oel_updated.containsKey(eachOEL.Id))
            				map_oelId_oel_updated.put(eachOEL.Id, eachOEL);
            		}

        }

		if(map_oelId_oel_updated.values().size() > 0) {
			List<Order_Entry_Line__c> updatedOERLinesList = new List<Order_Entry_Line__c>();
			updatedOERLinesList = map_oelId_oel_updated.values();

			
			Database.SaveResult[] saveResList = Database.update(updatedOERLinesList, false);
			/*
			Boolean hasException = false;

			for(Integer Indx = 0; Indx < saveResList.size(); Indx++) {
				Database.SaveResult sr = saveResList[Indx];
			    if (!sr.isSuccess()) {
			        hasException = true;
			        break;
			    }
			}

			if(hasException) {	
				throw new syncQuoteOERException();
			}*/
		}
	}
}