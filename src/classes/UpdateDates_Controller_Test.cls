/***********************************************************************************************************
* Name         : UpdateDates_Controller_Test.cls
* Created By   : ENP Team - Adi
* Purpose      : This class is an test class for  UpdateDates_Controller
* Created Date : 02 Oct 2019
*
* Date Modified                Modified By             Description of the update
----------------------------------------------------------------------------------------------------------
* 18-Feb-2021	               Rekha                   //FIX_VALIDATION_ON_PAST_SSD
**********************************************************************************************************/
@isTest
public class UpdateDates_Controller_Test {
    
    static testMethod void TestMethod1(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                
                System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        Order_Entry_Release__c testRel = oerList[0];
        Order_Entry_Line__c testOEL;     
        //Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
        Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ]; 
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        update testRel;    
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        
        update testOEL;  
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];      
        
        testRel.Integration_Status__c='Complete';
        testRel.Trigger_Source__c='Integration';
        
        List<UpdateDates_Controller.Details> lstData = new List<UpdateDates_Controller.Details>();
        lstData.add(new UpdateDates_Controller.Details(testRel.id,testRel.Name));
        update testRel;  
        UpdateDates_Controller.onLoadCall(opp.Id);
        
        UpdateDates_Controller.UpdateDatesWrapper wrap= new UpdateDates_Controller.UpdateDatesWrapper();
        
        wrap.releaseNames = lstData;
        wrap.getOrdersToUpdate = oerList;
        wrap.isContinue = true;
        
        wrap.conformOrders = new List<Order_Entry_Line__c>{testOEL};
            
            UpdateDates_Controller.getPicklistvalues('Order_Entry_Line__c','Schedule_Ship_Date_Change_Reason__c',true);
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap));
        wrap.isContinue = false;
        wrap.isFinishedMethod = false;
        wrap.isChanged = true;
        wrap.getOrdersToUpdate =  oerList;
        wrap.selectedReferenceId = 'akdh87324';
        wrap.selectedName = 'selectedName';
        wrap.selectedSKU = 'akdh87324';
        wrap.requestDateChecked = true;
        wrap.shipDateChecked = true;
        List<UpdateDates_Controller.EditableOELWrapper> wrOel = new List<UpdateDates_Controller.EditableOELWrapper>();
        wrOel.add(new UpdateDates_Controller.EditableOELWrapper(true,testOEL));
        wrap.updateTableOELs = wrOel;
        wrap.editableOELs = wrOel;
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        wrap.hasError = true;
        Map<Id, Order_Entry_Line__c> mpOel = new Map<Id, Order_Entry_Line__c>();
        mpOel.put(testOEL.Id,testOEL);
        wrap.mapOldOEL = mpOel;  
        wrap.getOrders = oerList;  
        
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap)); 
        UpdateDates_Controller.filterChange(opp.Id,JSON.serialize(wrap));  
        wrap.isContinue = true;
        wrap.isChanged = true;
        wrap.DisplayPageBlock = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = false;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        //FIX_VALIDATION_ON_PAST_SSD
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'--None--',system.today(),'test','test','test'); 
        Test.stopTest(); 
    }  
    static testMethod void TestMethod2(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                
                System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        Order_Entry_Release__c testRel = oerList[0];
        Order_Entry_Line__c testOEL;     
        //Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
        Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ]; 
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        update testRel;    
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        
        update testOEL;  
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];      
        
        testRel.Integration_Status__c='Complete';
        testRel.Trigger_Source__c='Integration';
        
        List<UpdateDates_Controller.Details> lstData = new List<UpdateDates_Controller.Details>();
        lstData.add(new UpdateDates_Controller.Details(testRel.id,testRel.Name));
        update testRel;  
        UpdateDates_Controller.onLoadCall(opp.Id);
        
        UpdateDates_Controller.UpdateDatesWrapper wrap= new UpdateDates_Controller.UpdateDatesWrapper();
        
        wrap.releaseNames = lstData;
        wrap.getOrdersToUpdate = oerList;
        wrap.isContinue = true;
        
        wrap.conformOrders = new List<Order_Entry_Line__c>{testOEL};
            
            UpdateDates_Controller.getPicklistvalues('Order_Entry_Line__c','Schedule_Ship_Date_Change_Reason__c',true);
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap));
        wrap.isContinue = false;
        wrap.isFinishedMethod = false;
        wrap.isChanged = true;
        wrap.getOrdersToUpdate =  oerList;
        wrap.selectedReferenceId = 'akdh87324';
        wrap.selectedName = 'selectedName';
        wrap.selectedSKU = 'akdh87324';
        wrap.requestDateChecked = true;
        wrap.shipDateChecked = true;
        List<UpdateDates_Controller.EditableOELWrapper> wrOel = new List<UpdateDates_Controller.EditableOELWrapper>();
        wrOel.add(new UpdateDates_Controller.EditableOELWrapper(true,testOEL));
        wrap.updateTableOELs = wrOel;
        wrap.editableOELs = wrOel;
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        wrap.hasError = true;
        Map<Id, Order_Entry_Line__c> mpOel = new Map<Id, Order_Entry_Line__c>();
        mpOel.put(testOEL.Id,testOEL);
        wrap.mapOldOEL = mpOel;  
        wrap.getOrders = oerList;  
        
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap)); 
        UpdateDates_Controller.filterChange(opp.Id,JSON.serialize(wrap));  
        wrap.isContinue = true;
        wrap.isChanged = true;
        wrap.DisplayPageBlock = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = false;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        //FIX_VALIDATION_ON_PAST_SSD
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'test',system.today(),'--None--','test','test'); 
        Test.stopTest(); 
    }  
    static testMethod void TestMethod3(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                
                System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        Order_Entry_Release__c testRel = oerList[0];
        Order_Entry_Line__c testOEL;     
        //Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
        Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ]; 
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        update testRel;    
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        
        update testOEL;  
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];      
        
        testRel.Integration_Status__c='Complete';
        testRel.Trigger_Source__c='Integration';
        
        List<UpdateDates_Controller.Details> lstData = new List<UpdateDates_Controller.Details>();
        lstData.add(new UpdateDates_Controller.Details(testRel.id,testRel.Name));
        update testRel;  
        UpdateDates_Controller.onLoadCall(opp.Id);
        
        UpdateDates_Controller.UpdateDatesWrapper wrap= new UpdateDates_Controller.UpdateDatesWrapper();
        
        wrap.releaseNames = lstData;
        wrap.getOrdersToUpdate = oerList;
        wrap.isContinue = true;
        
        wrap.conformOrders = new List<Order_Entry_Line__c>{testOEL};
            
            UpdateDates_Controller.getPicklistvalues('Order_Entry_Line__c','Schedule_Ship_Date_Change_Reason__c',true);
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap));
        wrap.isContinue = false;
        wrap.isFinishedMethod = false;
        wrap.isChanged = true;
        wrap.getOrdersToUpdate =  oerList;
        wrap.selectedReferenceId = 'akdh87324';
        wrap.selectedName = 'selectedName';
        wrap.selectedSKU = 'akdh87324';
        wrap.requestDateChecked = true;
        wrap.shipDateChecked = true;
        List<UpdateDates_Controller.EditableOELWrapper> wrOel = new List<UpdateDates_Controller.EditableOELWrapper>();
        wrOel.add(new UpdateDates_Controller.EditableOELWrapper(true,testOEL));
        wrap.updateTableOELs = wrOel;
        wrap.editableOELs = wrOel;
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        wrap.hasError = true;
        Map<Id, Order_Entry_Line__c> mpOel = new Map<Id, Order_Entry_Line__c>();
        mpOel.put(testOEL.Id,testOEL);
        wrap.mapOldOEL = mpOel;  
        wrap.getOrders = oerList;  
        
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap)); 
        UpdateDates_Controller.filterChange(opp.Id,JSON.serialize(wrap));  
        wrap.isContinue = true;
        wrap.isChanged = true;
        wrap.DisplayPageBlock = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = false;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        //FIX_VALIDATION_ON_PAST_SSD
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today()-2,'test',system.today(),'test','test','test'); 
        Test.stopTest(); 
    }  
    static testMethod void TestMethod4(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                
                System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        Order_Entry_Release__c testRel = oerList[0];
        Order_Entry_Line__c testOEL;     
        //Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
        Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ]; 
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        update testRel;    
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        
        update testOEL;  
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];      
        
        testRel.Integration_Status__c='Complete';
        testRel.Trigger_Source__c='Integration';
        
        List<UpdateDates_Controller.Details> lstData = new List<UpdateDates_Controller.Details>();
        lstData.add(new UpdateDates_Controller.Details(testRel.id,testRel.Name));
        update testRel;  
        UpdateDates_Controller.onLoadCall(opp.Id);
        
        UpdateDates_Controller.UpdateDatesWrapper wrap= new UpdateDates_Controller.UpdateDatesWrapper();
        
        wrap.releaseNames = lstData;
        wrap.getOrdersToUpdate = oerList;
        wrap.isContinue = true;
        
        wrap.conformOrders = new List<Order_Entry_Line__c>{testOEL};
            
            UpdateDates_Controller.getPicklistvalues('Order_Entry_Line__c','Schedule_Ship_Date_Change_Reason__c',true);
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap));
        wrap.isContinue = false;
        wrap.isFinishedMethod = false;
        wrap.isChanged = true;
        wrap.getOrdersToUpdate =  oerList;
        wrap.selectedReferenceId = 'akdh87324';
        wrap.selectedName = 'selectedName';
        wrap.selectedSKU = 'akdh87324';
        wrap.requestDateChecked = true;
        wrap.shipDateChecked = true;
        List<UpdateDates_Controller.EditableOELWrapper> wrOel = new List<UpdateDates_Controller.EditableOELWrapper>();
        wrOel.add(new UpdateDates_Controller.EditableOELWrapper(true,testOEL));
        wrap.updateTableOELs = wrOel;
        wrap.editableOELs = wrOel;
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        wrap.hasError = true;
        Map<Id, Order_Entry_Line__c> mpOel = new Map<Id, Order_Entry_Line__c>();
        mpOel.put(testOEL.Id,testOEL);
        wrap.mapOldOEL = mpOel;  
        wrap.getOrders = oerList;  
        
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap)); 
        UpdateDates_Controller.filterChange(opp.Id,JSON.serialize(wrap));  
        wrap.isContinue = true;
        wrap.isChanged = true;
        wrap.DisplayPageBlock = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = false;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        //FIX_VALIDATION_ON_PAST_SSD
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Other',system.today(),'test',' ','test'); 
        Test.stopTest(); 
    } 
    static testMethod void TestMethod5(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                
                System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        Order_Entry_Release__c testRel = oerList[0];
        Order_Entry_Line__c testOEL;     
        //Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
        Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ]; 
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        update testRel;    
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        
        update testOEL;  
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];      
        
        testRel.Integration_Status__c='Complete';
        testRel.Trigger_Source__c='Integration';
        
        List<UpdateDates_Controller.Details> lstData = new List<UpdateDates_Controller.Details>();
        lstData.add(new UpdateDates_Controller.Details(testRel.id,testRel.Name));
        update testRel;  
        UpdateDates_Controller.onLoadCall(opp.Id);
        
        UpdateDates_Controller.UpdateDatesWrapper wrap= new UpdateDates_Controller.UpdateDatesWrapper();
        
        wrap.releaseNames = lstData;
        wrap.getOrdersToUpdate = oerList;
        wrap.isContinue = true;
        
        wrap.conformOrders = new List<Order_Entry_Line__c>{testOEL};
            
            UpdateDates_Controller.getPicklistvalues('Order_Entry_Line__c','Schedule_Ship_Date_Change_Reason__c',true);
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap));
        wrap.isContinue = false;
        wrap.isFinishedMethod = false;
        wrap.isChanged = true;
        wrap.getOrdersToUpdate =  oerList;
        wrap.selectedReferenceId = 'akdh87324';
        wrap.selectedName = 'selectedName';
        wrap.selectedSKU = 'akdh87324';
        wrap.requestDateChecked = true;
        wrap.shipDateChecked = true;
        List<UpdateDates_Controller.EditableOELWrapper> wrOel = new List<UpdateDates_Controller.EditableOELWrapper>();
        wrOel.add(new UpdateDates_Controller.EditableOELWrapper(true,testOEL));
        wrap.updateTableOELs = wrOel;
        wrap.editableOELs = wrOel;
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        wrap.hasError = true;
        Map<Id, Order_Entry_Line__c> mpOel = new Map<Id, Order_Entry_Line__c>();
        mpOel.put(testOEL.Id,testOEL);
        wrap.mapOldOEL = mpOel;  
        wrap.getOrders = oerList;  
        
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap)); 
        UpdateDates_Controller.filterChange(opp.Id,JSON.serialize(wrap));  
        wrap.isContinue = true;
        wrap.isChanged = true;
        wrap.DisplayPageBlock = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = false;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        //FIX_VALIDATION_ON_PAST_SSD
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'Other','Test',' '); 
        Test.stopTest(); 
    } 
    static testMethod void TestMethod6(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                
                System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        Order_Entry_Release__c testRel = oerList[0];
        Order_Entry_Line__c testOEL;     
        //Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
        Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ]; 
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        update testRel;    
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        
        update testOEL;  
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];      
        
        testRel.Integration_Status__c='Complete';
        testRel.Trigger_Source__c='Integration';
        
        List<UpdateDates_Controller.Details> lstData = new List<UpdateDates_Controller.Details>();
        lstData.add(new UpdateDates_Controller.Details(testRel.id,testRel.Name));
        update testRel;  
        UpdateDates_Controller.onLoadCall(opp.Id);
        
        UpdateDates_Controller.UpdateDatesWrapper wrap= new UpdateDates_Controller.UpdateDatesWrapper();
        
        wrap.releaseNames = lstData;
        wrap.getOrdersToUpdate = oerList;
        wrap.isContinue = true;
        
        wrap.conformOrders = new List<Order_Entry_Line__c>{testOEL};
            
            UpdateDates_Controller.getPicklistvalues('Order_Entry_Line__c','Schedule_Ship_Date_Change_Reason__c',true);
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap));
        wrap.isContinue = false;
        wrap.isFinishedMethod = false;
        wrap.isChanged = true;
        wrap.getOrdersToUpdate =  oerList;
        wrap.selectedReferenceId = 'akdh87324';
        wrap.selectedName = 'selectedName';
        wrap.selectedSKU = 'akdh87324';
        wrap.requestDateChecked = true;
        wrap.shipDateChecked = true;
        List<UpdateDates_Controller.EditableOELWrapper> wrOel = new List<UpdateDates_Controller.EditableOELWrapper>();
        wrOel.add(new UpdateDates_Controller.EditableOELWrapper(true,testOEL));
        wrap.updateTableOELs = wrOel;
        wrap.editableOELs = wrOel;
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        wrap.hasError = true;
        Map<Id, Order_Entry_Line__c> mpOel = new Map<Id, Order_Entry_Line__c>();
        mpOel.put(testOEL.Id,testOEL);
        wrap.mapOldOEL = mpOel;  
        wrap.getOrders = oerList;  
        
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap)); 
        UpdateDates_Controller.filterChange(opp.Id,JSON.serialize(wrap));  
        wrap.isContinue = true;
        wrap.isChanged = true;
        wrap.DisplayPageBlock = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = false;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        //FIX_VALIDATION_ON_PAST_SSD
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'Other','Test',' '); 
        Test.stopTest(); 
    }  
    static testMethod void TestMethod7(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
                
                System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.startTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        Order_Entry_Release__c testRel = oerList[0];
        Order_Entry_Line__c testOEL;     
        //Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
        Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ]; 
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testRel.Status__c='Integration Requested';
        update testRel;    
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];
        testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                   RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                   Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                   Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                   WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
        
        testOEL.Integration_Status__c='Complete';
        testOEL.Trigger_Source__c='Integration';
        
        update testOEL;  
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                   Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                   Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                   Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                   Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                   Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                   Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                   System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                   Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                   Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testRel.Id LIMIT 1];      
        
        testRel.Integration_Status__c='Complete';
        testRel.Trigger_Source__c='Integration';
        
        List<UpdateDates_Controller.Details> lstData = new List<UpdateDates_Controller.Details>();
        lstData.add(new UpdateDates_Controller.Details(testRel.id,testRel.Name));
        update testRel;  
        UpdateDates_Controller.onLoadCall(opp.Id);
        
        UpdateDates_Controller.UpdateDatesWrapper wrap= new UpdateDates_Controller.UpdateDatesWrapper();
        
        wrap.releaseNames = lstData;
        wrap.getOrdersToUpdate = oerList;
        wrap.isContinue = true;
        
        wrap.conformOrders = new List<Order_Entry_Line__c>{testOEL};
            
            UpdateDates_Controller.getPicklistvalues('Order_Entry_Line__c','Schedule_Ship_Date_Change_Reason__c',true);
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap));
        wrap.isContinue = false;
        wrap.isFinishedMethod = false;
        wrap.isChanged = true;
        wrap.getOrdersToUpdate =  oerList;
        wrap.selectedReferenceId = 'akdh87324';
        wrap.selectedName = 'selectedName';
        wrap.selectedSKU = 'akdh87324';
        wrap.requestDateChecked = true;
        wrap.shipDateChecked = true;
        List<UpdateDates_Controller.EditableOELWrapper> wrOel = new List<UpdateDates_Controller.EditableOELWrapper>();
        wrOel.add(new UpdateDates_Controller.EditableOELWrapper(true,testOEL));
        wrap.updateTableOELs = wrOel;
        wrap.editableOELs = wrOel;
        wrap.enableRequestDate = true;
        wrap.enableShipDate = true;
        wrap.hasError = true;
        Map<Id, Order_Entry_Line__c> mpOel = new Map<Id, Order_Entry_Line__c>();
        mpOel.put(testOEL.Id,testOEL);
        wrap.mapOldOEL = mpOel;  
        wrap.getOrders = oerList;  
        
        UpdateDates_Controller.approvedDates( JSON.serialize(wrap)); 
        UpdateDates_Controller.filterChange(opp.Id,JSON.serialize(wrap));  
        wrap.isContinue = true;
        wrap.isChanged = true;
        wrap.DisplayPageBlock = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        wrap.enableRequestDate = false;
        wrap.enableShipDate = true;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'Test',system.today(),'test','test','test'); 
        System.debug(' CUP time '+ Limits.getCpuTime()+ ' SOQL '+ Limits.getQueries());
        //FIX_VALIDATION_ON_PAST_SSD
        wrap.enableRequestDate = true;
        wrap.enableShipDate = false;
        UpdateDates_Controller.saveUpdateDates(opp.Id,JSON.serialize(wrap),system.today(),'test',system.today(),'--None--','test','test'); 
        Test.stopTest(); 
    }  
}