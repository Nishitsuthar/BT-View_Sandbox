@IsTest
public class Deposit_Request_Test {
    
    @IsTest static void testSaveMethod(){
        
        try{
        Account newAccount = new Account(name = 'Unittest');
            newAccount.Billingstreet  = 'sample street';
            newAccount.BillingCity   = 'city';
            newAccount.BillingCountry   = 'sample Country';
            newAccount.BillingPostalCode   = '12345';
            newAccount.BillingState   = 'USA';
            newAccount.Shippingstreet  = 'sample street';
            newAccount.ShippingCity   = 'city';
            newAccount.ShippingCountry   = 'sample Country';
            newAccount.ShippingPostalCode   = '12345';
            newAccount.ShippingState   = 'USA';
            newAccount.Oracle_Customer_Number__c = '001';
            
            database.insert(newAccount);
            
            Contact testContact = new Contact();
            testContact.LastName = 'First';
            testContact.LastName = 'Last Test';
            testContact.AccountId = newAccount.Id;
            testContact.Email = 'first@last.com';
            
            insert testContact;
            
            Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
            
            Opportunity testMOUOpportunityObj = new Opportunity();
            testMOUOpportunityObj.Name = 'testOppty';
            testMOUOpportunityObj.CloseDate = Date.today();
            testMOUOpportunityObj.StageName = 'POC Stage';
            testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
            testMOUOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
            testMOUOpportunityObj.BOX_Folder_Id__c='123456';
            testMOUOpportunityObj.Service_Date__c=Date.today()-10;
            
            insert testMOUOpportunityObj;
            
            Order_Entry_Release__c oer = new Order_Entry_Release__c(Name='ssss',Order_Type__c='Standard',Payment_Terms__c='  IMMEDIATE',Opportunity__c=testMOUOpportunityObj.id,MES_Routing__c='MES',Billing_Account__c=newAccount.id,Shipping_Account__c=newAccount.id,Sold_to_Account__c=newAccount.id,Release_Name__c='testRelease');
            database.insert(oer);
            
            Customer_Purchase_Order__c CPO = new Customer_Purchase_Order__c(Name__c = 'Name__c756',Opportunity__c=testMOUOpportunityObj.Id);
            database.insert(CPO);
            
            Id quoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Bid_Quote_Locked_Record_Type').getRecordTypeId();
            SBQQ__Quote__c testQuote = new SBQQ__Quote__c();
            testQuote.RecordTypeId = quoteRecordtype;
            testQuote.Related_Opportunity__c = testMOUOpportunityObj.Id;
            testQuote.SBQQ__Account__c = newAccount.Id;   
            testQuote.Total_Sq_Feet__c = 10;
            testQuote.IGU_Price_Per_Sq_Ft__c = 30;
            testQuote.BOS_Price_Per_Sq_Ft__c = 50;
            testQuote.SBQQ__Account__c = newAccount.Id;
            testQuote.Bid_Status__c = 'Won Bid';
            testQuote.Exclude_Sync__c = false;
            testQuote.Quote_Plan__c = 'All In';
            testQuote.Quote_Type__c = 'All In';
            //testQuote.Template_Type__c = 'BUDGET';
            testQuote.SBQQ__PrimaryContact__c = testContact.Id;
            testQuote.Are_you_using_Plenum__c='yes';
            testQuote.Deal_Desk_Analyst__c= UserInfo.getUserId(); 
            testQuote.Primary_Contact_E_Mail__c= testContact.Email; 
            testQuote.Regional_Director2__c= UserInfo.getUserId(); 
            testQuote.Regional_Vice_President__c= UserInfo.getUserId(); 
            testQuote.SBQQ__SalesRep__c = UserInfo.getUserId();
            
            database.insert(testQuote);
            
            DepositRequest.onLoadPickistVal(testQuote.Id);
            String expected = '{"Invoiced_Amount__c":"1","Invoice_Date__c":"2020-8-20","Allocation__c":"1","Description__c":"Test Record Created from Deposit Request button on Contract Price Quote","Invoice_Type__c":"Deposit Request","Integration_Status__c":"New","Opportunity__c":"0060L00000mVyChQAK","Project_Id__c":"180112903","Quote__c":"a830h000000XZSLAA4","Bill_to_Account__c":"Idexx Laboratories","Customer_Id__c":"9155","Billing_Street_1__c":"One Idexx Drive Eisenhower Business Park","Billing_State_Province__c":"ME","Billing_City__c":"WESTBROOK","Billing_Postal_Code__c":"04092","Billing_Country__c":"United States"}';
            DepositRequest.saveInvoice(expected,oer.Payment_Terms__c,CPO.Name,'USD');
            }
        catch(exception e){}
    }
}