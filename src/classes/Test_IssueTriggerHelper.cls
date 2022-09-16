@isTest
public class Test_IssueTriggerHelper {
    
    
    
    @isTest
    public static void IssueTriggerHelper1(){
   
         Account testAcc= new Account(Name='test account',
                                     ShippingCity='Hyd',
                                     ShippingCountry='India',
                                     //ShippingLatitude=5657.577,
                                     //ShippingLongitude=7845.46,
                                     ShippingPostalCode='500032',
                                     ShippingState='Telangana',
                                     ShippingStreet='hitechcity');
        insert testAcc;
        
        Contact testCon= new Contact(LastName='test contact',
                                    AccountId=testAcc.id,
                                     Email='testissuecon1@gmail.com',
                                      Phone='040-12345',
                                      MailingStreet='854 Oakland Ave.',
                                      MailingCity='Los Angeles',
                                      MailingState='CA',
                                      MailingPostalCode='90004',
                                      MailingCountry='US'
                                    );
        insert testCon;
        
        IssueManagementCtrl iss = new IssueManagementCtrl();
        IssueManagementCtrl.getIssues();
        GenerateProductReqController iss1= new GenerateProductReqController();
        GenerateProductReqController.getIssues();
        IssueTriggerHelper i2 = new IssueTriggerHelper();
        IssueTriggerHelper.getIssues();
            ProductRequestTriggerHandler i4 = new ProductRequestTriggerHandler();
        ProductRequestTriggerHandler.getIssues();
            LogIssuesCmpController i3 = new LogIssuesCmpController();
        LogIssuesCmpController.getIssues();
        
        Case_Quote_Order_Util iss123 = new Case_Quote_Order_Util();
        Case_Quote_Order_Util.getIssues();
        set<id> OERIds = new set<id>();
        Case_Quote_Order_Util.setRelatedPRsToFulFillStatus(OERIds);
    }

}