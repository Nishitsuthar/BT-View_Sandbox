@isTest
public class OrderEntryLineTriggerHandlerTest{
   
   static testMethod void TestMethod1(){
       Schema.Location testLocation = new Schema.Location(Name='test Trunk',LocationType='Trunk',IsInventoryLocation=true);
        insert testLocation;
       Schema.Location testLocation2 = new Schema.Location(Name='Anil Trunk',LocationType='Trunk',IsInventoryLocation=true);
        insert testLocation2;
        set<id> locationset=New set<id>();
       locationset.add(testLocation.Id);
       locationset.add(testLocation2.Id);
        Product2 testPro = new Product2(Name = 'ASSY',
                                        IsActive = true, 
                                        Family='CSS',
                                        CurrencyIsoCode='USD',
                                        Product_SKU__c='test',
                                        ProductCode='testc',
                                         Generation__c='1'
                                       );
        insert testPro; 
        Product2 testPro2 = new Product2(Name = 'Gen3',
                                        IsActive = true, 
                                        Family='IGU',
                                        CurrencyIsoCode='USD',
                                        Product_SKU__c='test1',
                                        ProductCode='testcd'
                                        
                                        
                                       );
        //insert testPro2; 
        ProductItem testProductItem = new ProductItem(
                                        LocationId = testLocation.Id, 
                                        Product2Id=testPro.Id,
                                        QuantityOnHand=10
                                       
                                        
                                       );
       insert testProductItem;
       ProductItem testProductItem2 = new ProductItem(
                                        LocationId = testLocation2.Id, 
                                        Product2Id=testPro2.Id,
                                        QuantityOnHand=10
                                       
                                        
                                       );
     //  insert testProductItem2;
        Project_Phase_Plan__c pplan = new Project_Phase_Plan__c();
        pplan.Status__c='New';
        insert pplan;
        
        List<Project_Phase__c> phase = new List<Project_Phase__c>();  
        Project_Phase__c p = new Project_Phase__c();
        p.Project_Phase_Plan__c=  pplan.Id;
        p.Phase_Description__c=  'Test';
        p.Project_Phase__c=  1;
        p.Trade__c=  'Glazier';
        p.Customer_Reference_id__c = '1234';
        phase.add(p);
        insert phase;
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 2, 'Imperial (US Standard)','CPQ');
       
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 2);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testOER;
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c,Reference_ID__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                            RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                            Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                            Use_Account_Shipping_Address__c,Quantity_Shipped__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                            WHERE Order_Entry_Release__c IN :oelMap.keySet() limit 1];
       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         Test.startTest(); 
       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
       Order_Entry_Line__c testOEL = updatedOELs[0];
       testOEL.Reference_ID__c = '1234';
       testOEL.Quantity__c=1;
       testOEL.Quantity_Shipped__c=1;
        testOEL.Trigger_Source__c='Integration';
       testOEL.Product__c=testPro.Id;
       update testOEL; 
       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
         Test.stopTest();
       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
       Map<Id, Order_Entry_Line__c> oelMaptest = new Map<Id,Order_Entry_Line__c>();
       oelMaptest.put(testOEL.Id,testOEL); 
        OrderEntryLineTriggerHelper.getTrunkIdWithProductIdToProductItem(locationset);
       OrderEntryLineTriggerHandler.processProjectPhase(oelMaptest); 
       System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        
   }

}