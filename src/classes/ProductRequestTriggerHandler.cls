public class ProductRequestTriggerHandler {
    
    public static void doAfterUpdate(List<ProductRequest> oldPRs, List<ProductRequest> newPRs) {
        Set<Id> fulFilledPRIds = new Set<Id>();
        for(Integer Indx = 0; Indx < oldPRs.size(); Indx++) {
            if(oldPRs[Indx].Status != newPRs[Indx].Status && newPRs[Indx].Status == 'Order Shipped'){
                fulFilledPRIds.add(newPRs[Indx].Id);
            }
        }
        if(fulFilledPRIds.size() > 0) {
         //   Case_Quote_Order_Util.setRelatedIssuesToFulFilledStatus(fulFilledPRIds);
        }
    }

}