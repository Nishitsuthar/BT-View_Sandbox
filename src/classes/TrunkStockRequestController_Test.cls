//@istest(seealldata = true)
@isTest(SeeAllData=true)
public class TrunkStockRequestController_Test {
   /* 
    @testSetup static void testData() {
		
        
		} 
*/
    
    static testmethod void methodOne()
        {
           ServiceResource ser = [Select id from ServiceResource where id='0Hn0h000000fy1pCAA' LIMIT 1];
            
           TrunkStockRequestController.getProducts();
           TrunkStockRequestController.getServiceRecource(ser.Id);
            TrunkStockRequestController.getServiceRecourceSelfOrOther(ser.Id);
        }
    /*
    String srId, String trunkId,String reqDate,String street,String city, String state, String postcode, 
                                         String country, String shippingConName, String shippingConPhone */
    static testmethod void methodTwo()
        {
           ServiceResource ser = [Select id,LocationId from ServiceResource where id='0Hn0h000000fy1pCAA' LIMIT 1];
            String reDate = '2021-04-27';
            String street = 'test street 1 ';
            String city = 'Dallas';
            String state = 'TX';
            String postcode = '34534';
            String country = 'United States';
            String shippingConName = 'Test Man';
            String shippingConPhone = '9988776655';
            
			List<ProductRequest> prReq = new List<ProductRequest>();
            prReq.add(new ProductRequest(Product__c ='01t0L00000AX8BJQA1',Quantity__c = 10.0));
            prReq.add(new ProductRequest(Product__c ='01t0L00000AX53OQAT',Quantity__c = 12.0));
            
           TrunkStockRequestController.createNewFseParts(ser.Id,ser.LocationId,reDate,street,city,state,postcode,country,shippingConName,shippingConPhone);
           TrunkStockRequestController.createPreEmptiveParts(ser.Id,ser.LocationId,reDate,street,city,state,postcode,country,prReq,shippingConName,shippingConPhone);
        }
    
    static testmethod void methodThree()
    {
        String address = '2020 Grill';
        String placeId = '2323jlj232';
        String acc = 'Account';
            String fieldFilter = 'Name';
        String serString = 'Test';
        String valStr = 'test1122';
        TrunkStockRequestController.getAddressSet(address);
        TrunkStockRequestController.getAddressDetailsByPlaceId(placeId);
       // TrunkStockRequestController.fetchRecords(acc, fieldFilter, serString, valStr);
    }
}