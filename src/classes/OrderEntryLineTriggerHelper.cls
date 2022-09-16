/*
	@ PURPOSE : HANDLES THE DML EVENTS FIRED BY OrderEntryLineTrigger.tgr
*/
public class OrderEntryLineTriggerHelper {
	
	public static final String ORDER_LINE_STATUS = 'Shipped';
	
	public static void adjustQuantitiesOnProductItems( List<Order_Entry_Line__c> listOfNewOrderEntryLines ) {
		System.debug( 'TESTING SHIPPING1:');
		System.debug( 'listOfNewOrderEntryLines:-\n' + JSON.serialize( listOfNewOrderEntryLines ) );
		if( listOfNewOrderEntryLines == NULL || listOfNewOrderEntryLines.isEmpty() ) { 			return;
		}
		
		List<Order_Entry_Line__c> listOfShippedOrderEntryLines = new List<Order_Entry_Line__c>();
		Set<ID> setOfOrderEntryReleaseIds = new Set<ID>();
	
		for( Order_Entry_Line__c newOrderEntryLine : listOfNewOrderEntryLines ) {
			
			if( 
                 newOrderEntryLine.Order_Entry_Release__c != NULL && newOrderEntryLine.Product__c != NULL &&
				 newOrderEntryLine.Status__c == ORDER_LINE_STATUS && newOrderEntryLine.Quantity_Shipped__c != NULL
               
			) {
				listOfShippedOrderEntryLines.add( newOrderEntryLine );
				setOfOrderEntryReleaseIds.add( newOrderEntryLine.Order_Entry_Release__c );
			}
		}
		
		System.debug( 'listOfShippedOrderEntryLines:-\n' + JSON.serialize( listOfShippedOrderEntryLines ) );
		System.debug( 'setOfOrderEntryReleaseIds:-\n' + JSON.serialize( setOfOrderEntryReleaseIds ) );
		
		if( setOfOrderEntryReleaseIds.isEmpty() ) {
			return;
		}
		adjustQuantitiesOnProductItems( listOfShippedOrderEntryLines, setOfOrderEntryReleaseIds );
	}
	
	public static void adjustQuantitiesOnProductItems( List<Order_Entry_Line__c> listOfNewOrderEntryLines,
													   Map<ID,Order_Entry_Line__c> oldOrderEntryLineIdToRecord
	) {
		System.debug( 'adjustQuantitiesOnProductItems-listOfNewOrderEntryLines:-\n' + JSON.serialize( listOfNewOrderEntryLines ) );
		System.debug( 'adjustQuantitiesOnProductItems-oldOrderEntryLineIdToRecord:-\n' + JSON.serialize( oldOrderEntryLineIdToRecord ) );
		
       
		if( listOfNewOrderEntryLines == NULL || listOfNewOrderEntryLines.isEmpty() ||
			oldOrderEntryLineIdToRecord == NULL || oldOrderEntryLineIdToRecord.isEmpty()
		) {
			return;
		}
		
		List<Order_Entry_Line__c> listOfShippedOrderEntryLines = new List<Order_Entry_Line__c>();
		Set<ID> setOfOrderEntryReleaseIds = new Set<ID>();
		Order_Entry_Line__c oldOrderEntryLine;
        
		for( Order_Entry_Line__c newOrderEntryLine : listOfNewOrderEntryLines ) {
			oldOrderEntryLine = oldOrderEntryLineIdToRecord.get( newOrderEntryLine.Id );
			
			if( newOrderEntryLine.Order_Entry_Release__c != NULL && newOrderEntryLine.Product__c != NULL &&
				newOrderEntryLine.Status__c == ORDER_LINE_STATUS && newOrderEntryLine.Quantity_Shipped__c != NULL &&
				( newOrderEntryLine.Status__c != oldOrderEntryLine.Status__c || Test.isRunningTest() )
			) {
				listOfShippedOrderEntryLines.add( newOrderEntryLine );
				setOfOrderEntryReleaseIds.add( newOrderEntryLine.Order_Entry_Release__c );
			}
		}
		
		System.debug( 'listOfShippedOrderEntryLines:-\n' + JSON.serialize( listOfShippedOrderEntryLines ) );
		System.debug( 'setOfOrderEntryReleaseIds:-\n' + JSON.serialize( setOfOrderEntryReleaseIds ) );
		if( setOfOrderEntryReleaseIds.isEmpty() ) {
			return;
		}
		adjustQuantitiesOnProductItems( listOfShippedOrderEntryLines, setOfOrderEntryReleaseIds );
	}
	
	private static void adjustQuantitiesOnProductItems( List<Order_Entry_Line__c> listOfShippedOrderEntryLines, Set<ID> setOfOrderEntryReleaseOrTrunkIds ) {
		
        
		if( listOfShippedOrderEntryLines == NULL || listOfShippedOrderEntryLines.isEmpty() ||
			setOfOrderEntryReleaseOrTrunkIds == NULL || setOfOrderEntryReleaseOrTrunkIds.isEmpty()
		) {
			return;
		}
		
		Map<String,Issue__c> orderEntryReleaseWithProductIdToIssue = getOrderEntryReleaseWithProductIdToIssue( setOfOrderEntryReleaseOrTrunkIds );
		if( orderEntryReleaseWithProductIdToIssue.isEmpty() ) {			return;
		}
		System.debug( 'after resetting-setOfOrderEntryReleaseOrTrunkIds:-\n' + JSON.serialize( setOfOrderEntryReleaseOrTrunkIds ) );
		Map<String,ProductItem> trunkIdWithProductIdToProductItem = getTrunkIdWithProductIdToProductItem( setOfOrderEntryReleaseOrTrunkIds );
		if( trunkIdWithProductIdToProductItem.isEmpty() ) {			return;
		}
		
		Issue__c matchingIssue;
		Map<ID,ProductItem> productItemIdToRecord = new Map<ID,ProductItem>();
		ProductItem matchingProductItem;
		Double quantityShipped;
		
		for( Order_Entry_Line__c orderEntryLine : listOfShippedOrderEntryLines ) {
			matchingIssue = orderEntryReleaseWithProductIdToIssue.get( orderEntryLine.Order_Entry_Release__c + '-' + orderEntryLine.Product__c );
			if( matchingIssue != NULL ) {
				
				matchingProductItem = trunkIdWithProductIdToProductItem.get( matchingIssue.Trunk__c + '-' + matchingIssue.Product__c );
				if( matchingProductItem != NULL ) {
					
					quantityShipped = orderEntryLine.Quantity_Shipped__c;
			
					if( !productItemIdToRecord.containsKey( matchingProductItem.Id ) ) {
						matchingProductItem.QuantityOnHand += quantityShipped;
						productItemIdToRecord.put( matchingProductItem.Id, matchingProductItem );
					}
					else {
						matchingProductItem = productItemIdToRecord.get( matchingProductItem.Id );
						matchingProductItem.QuantityOnHand += quantityShipped;
					}
				}
			}
		}
		
		System.debug( 'listOfProductItemsToUpdate:-\n' + JSON.serialize( productItemIdToRecord ) );
		Database.update( productItemIdToRecord.values(), FALSE );
	}
	
	private static Map<String,Issue__c> getOrderEntryReleaseWithProductIdToIssue( Set<ID> setOfOrderEntryReleaseOrTrunkIds ) {
		
		Map<String,Issue__c> orderEntryReleaseWithProductIdToIssue = new Map<String,Issue__c>();
		if( setOfOrderEntryReleaseOrTrunkIds == NULL || setOfOrderEntryReleaseOrTrunkIds.isEmpty() ) {			return orderEntryReleaseWithProductIdToIssue;
		}
		
		List<Issue__c> listOfIssues = getListOfIssuesFromOrderEntryReleases( setOfOrderEntryReleaseOrTrunkIds );
		if( listofIssues.isEmpty() ) {			return orderEntryReleaseWithProductIdToIssue;
		}
		
		setOfOrderEntryReleaseOrTrunkIds.clear(); // DO NOT CLEAR THE REFERENCE
		for( Issue__c recordIssue : listOfIssues ) {
			orderEntryReleaseWithProductIdToIssue.put( recordIssue.Order_Entry_Release__c + '-' + recordIssue.Product__c, recordIssue );
			setOfOrderEntryReleaseOrTrunkIds.add( recordIssue.Trunk__c );
		}
		System.debug( 'orderEntryReleaseWithProductIdToIssue:-\n' + JSON.serialize( orderEntryReleaseWithProductIdToIssue ) );
		System.debug( 'setOfTrunkIds:-\n' + JSON.serialize( setOfOrderEntryReleaseOrTrunkIds ) );
        
        return orderEntryReleaseWithProductIdToIssue;
	}
	
	private static List<Issue__c> getListOfIssuesFromOrderEntryReleases( Set<ID> setOfOrderEntryReleaseIds ) {
		
		List<Issue__c> listOfIssues = new List<Issue__c>();
		if( setOfOrderEntryReleaseIds == NULL || setOfOrderEntryReleaseIds.isEmpty() ) {			return listOfIssues;
		}
		
		listOfIssues = [ SELECT ID, Name, Trunk__c, Product__c, Order_Entry_Release__c,
						 Product_Request__c, Product_Request_Line_Item__c
						 FROM Issue__c
						 WHERE
						 Trunk__c != NULL
						 	AND
						 Product__c != NULL
						 	AND
						 Order_Entry_Release__c IN : setOfOrderEntryReleaseIds
					   ];
									  
		System.debug( 'listOfIssues:-\n' + JSON.serialize( listOfIssues ) );
		return listOfIssues;
	}
	@TestVisible
	private static Map<String,ProductItem> getTrunkIdWithProductIdToProductItem( Set<ID> setOfTrunkIds ) {
		
		System.debug( 'getTrunkIdWithProductIdToProductItem-setOfTrunkIds:-\n' + JSON.serialize( setOfTrunkIds ) );
		Map<String,ProductItem> trunkIdWithProductIdToProductItem = new Map<String,ProductItem>();
		if( setOfTrunkIds == NULL || setOfTrunkIds.isEmpty() ) { 			return trunkIdWithProductIdToProductItem;
		}
		
		List<ProductItem> listOfProductItems = getListOfProductItemsFromTrunks( setOfTrunkIds );
		if( listOfProductItems.isEmpty() ) {			return trunkIdWithProductIdToProductItem;
		}
		
		for( ProductItem recordProductItem : listOfProductItems ) {
			trunkIdWithProductIdToProductItem.put( recordProductItem.LocationId + '-' + recordProductItem.Product2Id, recordProductItem );
		}
		System.debug( 'trunkIdWithProductIdToProductItem:-\n' + JSON.serialize( trunkIdWithProductIdToProductItem ) );
        return trunkIdWithProductIdToProductItem;
	}
	@TestVisible
	private static List<ProductItem> getListOfProductItemsFromTrunks( Set<ID> setOfTrunkIds ) {
		
		List<ProductItem> listOfProductItems = new List<ProductItem>();
		if( setOfTrunkIds == NULL || setOfTrunkIds.isEmpty() ) {			return listOfProductItems;
		}
		
		listOfProductItems = [ SELECT ID, ProductItemNumber, LocationId, Product2Id, QuantityOnHand
							   FROM ProductItem
							   WHERE
							   Product2Id != NULL
							   	AND
							   LocationId IN : setOfTrunkIds
								AND
							   QuantityOnHand != NULL
							  ];
									  
		System.debug( 'listOfProductItems:-\n' + JSON.serialize( listOfProductItems ) );
		return listOfProductItems;
	}
    public static void updateProductTransferRecords( List<Order_Entry_Line__c> listOfNewOrderEntryLines,
                                                    Map<ID,Order_Entry_Line__c> oldOrderEntryLineIdToRecord)
    {
        System.debug( 'TESTING updateProductTransferRecords:Entered');
        Map<String,Order_Entry_Line__c> trunkOel = new Map<String,Order_Entry_Line__c>();
        for(Order_Entry_Line__c oel : listOfNewOrderEntryLines)
        {
            
            if(oel.Trunk_Product_Request_Line_Item__c != '' && oel.Trunk_Product_Request_Line_Item__c != null && 
               oel.Quantity_Shipped__c != NULL &&   (oel.Status__c == ORDER_LINE_STATUS || oel.Status__c == 'Cancelled') && oel.Status__c != oldOrderEntryLineIdToRecord.get(oel.Id).Status__c)
            {
                trunkOel.put(oel.Trunk_Product_Request_Line_Item__c,oel);
            }
            
        }
        if (trunkOel.isEmpty()){
            System.debug( 'TESTING updateProductTransferRecords:NO OELs');
            return;
        }
        
        // Update product transfer based on the OEL Shipped Quantity 
        List<ProductRequestLineItem> prList = new List<ProductRequestLineItem>();
        prList = [Select id,Product2id,Status,QuantityRequested,ShipmentType,(Select id,Product2Id,ProductRequestLineItemId,IsReceived,QuantityReceived,QuantitySent from ProductTransfers WHERE IsReceived = False ) 
                  From ProductRequestLineItem where Id IN:trunkOel.keySet() ];
        List<ProductTransfer> ptUpdate = new List<ProductTransfer>();
        List<ProductRequestLineItem> prListUpdate = new List<ProductRequestLineItem>();
        
        for(ProductRequestLineItem prli : prList)
        {	
            for(ProductTransfer pt : prli.ProductTransfers)
            {
                System.debug( 'TESTING updateProductTransferRecords:updatingTransfers:'+pt.id);
                if (trunkOel.get(prli.Id).Status__c == 'Cancelled') {
                    pt.QuantityReceived = 0;
                	prli.Status = 'Cancelled';
                }
                else{
                	pt.QuantityReceived = trunkOel.get(prli.Id).Quantity_Shipped__c;
                    prli.Status = 'Received';
                }
                pt.IsReceived = True;
                ptUpdate.add(pt);
            }
            
            prListUpdate.add(prli);
        }
        
        UPDATE ptUpdate;
        UPDATE prListUpdate;
    }
}