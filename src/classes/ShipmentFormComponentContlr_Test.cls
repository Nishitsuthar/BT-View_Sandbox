@isTest
public class ShipmentFormComponentContlr_Test {
    
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
        order_entry_release_Obj.Order_Type__c = 'External';
        order_entry_release_Obj.Status__c ='Draft';
        order_entry_release_Obj.Scheduled_Ship_Date__c = System.today() + 20;
        // order_entry_release_Obj.RecordTypeId = rt.Id;
        Insert order_entry_release_Obj;
        system.debug('order_entry_release_Obj'+order_entry_release_Obj);
        
        /* Order_Entry_Line__c newOEL = (new Order_Entry_Line__c(Order_Entry_Release__c = order_entry_release_Obj.Id, Quantity__c = 1, 
Status__c = 'Draft', Base_in__c = '15', Height_in__c= '15',
Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', 
Order_Line_Type__c = 'Product',Installation_Type__c = 'Commercial', 
Line_Number__c = 1, Scheduled_Ship_Date__c = System.today() + 240, 
Promised_Date__c = System.today() + 255,
RecordTypeId = rt.Id, Request_Date__c = System.today() + 90));
insert newOEL;*/
    }
    
    @isTest static void testShiomentComponent(){
        Order_Entry_Release__c updatedOERRecord = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                                                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                                                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                                                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                                                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                                                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                                                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                                                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                                                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                                                   Packing_Instructions__c FROM Order_Entry_Release__c Limit 1];
        Test.startTest();
        ShipmentFormComponentcontlr.returnMessage(updatedOERRecord.Id);
        ShipmentFormComponentcontlr.createShipmentForm(updatedOERRecord.Id);
        ShipmentFormComponentcontlr.returnOERRecord(updatedOERRecord.Id);
        Test.stopTest();
        
    }
    @isTest static void testpackagingTrigger(){
        Order_Entry_Release__c updatedOERRecord = [SELECT Id, Name, Opportunity__c, Opportunity__r.Sales_Ops_Owner__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                                                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,Shipping_Street_2__c,
                                                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, Shipping_Street_3__c,
                                                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                                                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                                                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                                                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                                                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                                                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                                                   Packing_Instructions__c FROM Order_Entry_Release__c Limit 1];
        
        Packaging_and_Shipping_Instruction__c packagin_obj1 = new Packaging_and_Shipping_Instruction__c();
        packagin_obj1.Order_Entry_Release__c = updatedOERRecord.Id;
        Insert packagin_obj1;
        
        Test.startTest();
        Packaging_and_Shipping_Instruction__c packagin_obj = new Packaging_and_Shipping_Instruction__c();
        packagin_obj.Order_Entry_Release__c = updatedOERRecord.Id;
        packagin_obj.Status__c = 'Requested';
        packagin_obj.Deal_Desk_Analyst__c = updatedOERRecord.Opportunity__r.Sales_Ops_Owner__c;
        packagin_obj.Shipping_Name__c = updatedOERRecord.Shipping_Name__c;
        packagin_obj.Shipping_Street1__c = updatedOERRecord.Shipping_Street_1__c;
        packagin_obj.Shipping_Street2__c = updatedOERRecord.Shipping_Street_2__c;
        packagin_obj.Shipping_Street3__c = updatedOERRecord.Shipping_Street_3__c;
        packagin_obj.Shipping_City__c    = updatedOERRecord.Shipping_City__c;
        packagin_obj.Shipping_State__c   = updatedOERRecord.Shipping_State_Province__c;
        packagin_obj.Shipping_Country__c = updatedOERRecord.Shipping_Country__c;
        packagin_obj.Shipping_Zip__c     = updatedOERRecord.Shipping_Postal_Code__c;
        Insert packagin_obj;
        
        
        packagin_obj.Is_Form_Approved__c = true;
        update packagin_obj;
        Test.stopTest();
        
        
        
    }
}