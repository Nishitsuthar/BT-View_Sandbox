@isTest
public class ShipmentFormController_Test {
    @testSetup static void setUpData(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                Order_Entry_Release__c oerRecord;
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        
        oerRecord = [SELECT Id, Name, Status__c, Trigger_Source__c  FROM Order_Entry_Release__c WHERE Id =: oerList[0].Id Limit 1];
        
        oerRecord.Status__c = 'Draft';
        oerRecord.Trigger_Source__c = 'UI';
        
        update oerRecord;
        
        oerRecord.Status__c = 'Integration Requested';
        oerRecord.Trigger_Source__c = 'UI';
        
        update oerRecord;
        List<Order_Entry_Line__c> lineToUpdate = new List<Order_Entry_Line__c>();
        
        for(Order_Entry_Line__c oerLine : [SELECT Id, Order_Entry_Release__c,Trigger_Source__c,Integration_Status__c  FROM Order_Entry_Line__c  where Order_Entry_Release__c =: oerRecord.Id]){
            oerLine.Trigger_Source__c = 'Integration';
            oerLine.Integration_Status__c = 'Complete';
            lineToUpdate.add(oerLine);
        }
        
        update lineToUpdate;
        
        
    }
    
    @isTest static void creatingShipmentForm() { 
        
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
        
        Packaging_and_Shipping_Instruction__c packagin_obj = new Packaging_and_Shipping_Instruction__c();
        packagin_obj.Order_Entry_Release__c = updatedOERRecord.Id;
        Insert packagin_obj;
        Test.stopTest();
        
        PageReference pageRef = Page.ShipmentForm;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(updatedOERRecord);
        ShipmentFormController testAccPlan = new ShipmentFormController(sc);
        testAccPlan.resendNotification();
        testAccPlan.GoBack();
        testAccPlan.confirmMethod();
        
    }
    
    @isTest static void testShipmentEditForm(){
        
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
        
        
        Packaging_and_Shipping_Instruction__c packagin_obj = new Packaging_and_Shipping_Instruction__c();
        packagin_obj.Order_Entry_Release__c = updatedOERRecord.Id;
        packagin_obj.Is_Form_Approved__c = false;
        Insert packagin_obj;
        Test.stopTest();
        Packaging_and_Shipping_Instruction__c packing_obj_update = [select Id, Name, Packaging__c , Order_Number__c,Customer_Name__c,Project_Manager_Name__c,Terms_agreed_to_by_deal_desk__c,Special_packing_order__c,Order_Entry_Release__r.Trigger_Source__c,
                                                                    Special_Packing_Comments__c, Special_Requirements__c,Special_Requirements_Comments__c, Shipping_Name__c,Shipping_Street1__c,Is_Active__c,
                                                                    Shipping_Street2__c,Shipping_Street3__c,Shipping_City__c,Shipping_State__c, Shipping_Zip__c,Shipping_Country__c,Point_of_Contact_Name__c,
                                                                    Special_Delivery_Instructions__c,Special_Delivery_Instruction_Comments__c, Accept_Partial_Shipment__c,Partial_Shipment_Comments__c from Packaging_and_Shipping_Instruction__c 
                                                                    where Id =: packagin_obj.Id Limit 1];
        
        packing_obj_update.Accept_Partial_Shipment__c = 'Yes';
        packing_obj_update.Is_Active__c = true ; 
        packing_obj_update.Packaging__c = 'Crate';
        packing_obj_update.Point_of_Contact_Name__c = 'Sample Name';
        packing_obj_update.Shipping_City__c = 'Hyd';
        packing_obj_update.Shipping_Country__c = 'CANADA';
        packing_obj_update.Terms_agreed_to_by_deal_desk__c  = true;
        packing_obj_update.Is_Form_Approved__c = True;
        
        update packing_obj_update;
        
        PageReference pageRefEdit = Page.ShipmentEditForm;
        Test.setCurrentPage(pageRefEdit);
        ApexPages.StandardController editPage = new ApexPages.StandardController(packing_obj_update);
        ShipmentEditFormContlr testEditPage = new ShipmentEditFormContlr(editPage);
        testEditPage.FormSave();
        
    }
    
}