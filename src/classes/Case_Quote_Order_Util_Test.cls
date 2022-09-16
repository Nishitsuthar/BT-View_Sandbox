@isTest
public class Case_Quote_Order_Util_Test {
     @testSetup static void setUpData(){
        Account account_Obj = new Account(Name = 'TestAccount', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca',
                                          BillingPostalCode = '95132', BillingCountry = 'United States', ShippingStreet = 'Sierra brooks', 
                                          ShippingCity = 'Sanjose', ShippingState = 'CA', ShippingPostalCode = '95132', ShippingCountry = 'United States',
                                          Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
        Insert account_Obj;
        Opportunity opportunity_Obj = new Opportunity();
        opportunity_Obj.Name = 'Test Opp';
        opportunity_Obj.AccountId = account_Obj.Id;
        opportunity_Obj.Book_Date__c = date.today();
        opportunity_Obj.closeDate = Date.today();
        opportunity_Obj.StageName = 'Discovery';
        Insert opportunity_Obj;
        
        Quote quote_Obj = new Quote(Name = 'SampleQuote',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, 
                                    Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, 
                                    Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, 
                                    Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false,
                                    Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
        Insert quote_Obj; 
        
        RecordType rt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType where DeveloperName = 'Control_Hardware' limit 1];
        
        Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name ='TesOrderEntry Record');
        order_entry_release_Obj.Shipping_Account__c =  account_Obj.Id;   
        order_entry_release_Obj.Billing_Account__c = account_Obj.Id;  
        order_entry_release_Obj.Sold_to_Account__c = account_Obj.Id; 
        order_entry_release_Obj.Release_Name__c = 'TestRelease'; 
        order_entry_release_Obj.Freight__c = 'Billable';
        order_entry_release_Obj.Quote__c = quote_Obj.Id;    
        order_entry_release_Obj.Opportunity__c =  opportunity_Obj.Id;  
        order_entry_release_Obj.Order_Type__c = 'Standard';
        order_entry_release_Obj.Status__c ='Draft';
        order_entry_release_Obj.Scheduled_Ship_Date__c = System.today() + 20;
        // order_entry_release_Obj.RecordTypeId = rt.Id;
        Insert order_entry_release_Obj;
        
        case lstcase = new case();
        lstcase.Status = 'New';
         lstcase.Priority = 'P3';
        lstcase.AccountId = account_Obj.id;
        lstcase.Opportunity__c = opportunity_Obj.id;
        lstcase.Type = 'System Behavior Issue';
        //lstcase.Contact_Name__c = contlst.id;
        Insert lstcase;
        
        Product2 pd=VTestDataUtility_OE.getTestProduct();
        pd.name='productWithProductItem';
        Product2 pd1=VTestDataUtility_OE.getTestProduct();
        database.insert(new List<Product2>{pd,pd1});
        
    }
    
    @isTest static void setRelatedPRsToFulFillStatusTest() { 
        Case caseRec = [Select Id from Case limit 1];
        set<Id> oerIds = new Set<Id>();
        Order_Entry_Release__c oerRec = [select Id from Order_Entry_Release__c limit 1];
        oerIds.add(oerRec.Id);
        ProductRequest prRec=new ProductRequest();
        prRec.CaseId= caseRec.Id;
        prRec.Status='Order Processing';
        prRec.Type__c='Control Hardware';
        prRec.Order_Entry_Release__c = oerRec.Id;
        Insert prRec;
        
        test.startTest();
        Case_Quote_Order_Util.setRelatedPRsToFulFillStatus(oerIds);
        test.stopTest();
    }
    @isTest static void setRelatedIssuesToFulFilledStatusTest() {

            Case caseRec = [Select Id from Case limit 1];
            Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
            Account accRec = [Select Id from Account limit 1];
            set<Id> oerIds = new Set<Id>();
            Set<Id> prIds = new Set<Id>();
            Order_Entry_Release__c oerRec = [select Id from Order_Entry_Release__c limit 1];
            oerIds.add(oerRec.Id);
            ProductRequest prRec=new ProductRequest();
            prRec.CaseId= caseRec.Id;
            prRec.Status='Order Processing';
            prRec.Type__c='Control Hardware';
            prRec.Order_Entry_Release__c = oerRec.Id;
            Insert prRec;
            
            
            Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
        test.startTest();
            Issue__c issue= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',IGU_ID_Provided__c='Lite ID',Issue_Status__c='Open',Asset__c = assetRec.Id,
                                         Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c= caseRec.Id,
                                         Consumed_From_Trunk__c = false,Quantity__c = 10, Product_Request__c = prRec.Id);
            Insert issue;
            prIds.add(prRec.Id);
            
            issue.Issue_Status__c = 'Approved';
            update issue;
            issue.Issue_Status__c = 'Order Processing';
            update issue;
            issue.Issue_Status__c = 'Order Shipped';
            update issue;
            system.debug('Issue Rec'+issue);
            
            Case_Quote_Order_Util.setRelatedIssuesToFulFilledStatusManualissue(oerIds);
         //   Case_Quote_Order_Util.setRelatedIssuesToFulFilledStatus(prIds);

            test.stopTest();
    }
}