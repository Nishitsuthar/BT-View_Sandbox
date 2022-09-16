/***********************************************************************************************************
* Name         : CSS_OERMassUpdateController_Test.cls
* Created By   : ENP Team - Adi
* Purpose      : This class is an test class for  CSS_OERMassUpdateController
* Created Date : 02 Apr 2019
*
* Date Modified                Modified By             Description of the update
----------------------------------------------------------------------------------------------------------
* 
**********************************************************************************************************/
@isTest
public class CSS_OERMassUpdateController_Test {

   static testMethod void TestMethod1()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
        'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
        'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        Test.stopTest(); 
        
        PageReference testPageRef = Page.CSS_OERMassUpdate;
       
        Test.setCurrentPage(testPageRef);
       
        Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
       Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ];
       ApexPages.currentPage().getParameters().put('id', String.valueOf(opp.Id));
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(oerList);
        CSS_OERMassUpdateController sdScreen = new CSS_OERMassUpdateController(stdSetController); 
        sdScreen.orderItemReferenceonLoadMethod();
        
        boolean isEditable = sdScreen.isHeaderEditable(OEL,'Draft');
        
        
        /* List <Order_Entry_Release__c> oerListData = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN : oerList];         
        sdScreen.selectedName = oerListData[0].Release_Name__c;*/
        sdScreen.selectedName = oerList[0].Release_Name__c;
        sdScreen.selectedReferenceId =oel.Customer_Reference_Description__c;
        sdScreen.selectedSKU = oel.SKU__C;
       
        
       List<CSS_OERMassUpdateController.WrapperClass> obj = new List<CSS_OERMassUpdateController.WrapperClass>();
        
         List<Order_Entry_Line__c> newOELList = [SELECT Id,Request_Date__c,Request_Date_Update_Needed__c,Is_Schedule_Date_Updated__c,Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c,Customer_Reference_Description__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c  
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = : oerList[0].Id];
       
        
        Order_Entry_Line__c objOel = New Order_Entry_Line__c();
        objOel.Request_Date__c = system.today();
        objOel.Request_Date_Change_Reason__c = 'Added trade';
        objOel.Scheduled_Ship_Date__c = system.today();
        objOel.Schedule_Ship_Date_Change_Reason__c = 'Added trade';
        sdScreen.oel1 = objOel;
        sdScreen.isContinue= true;
        sdScreen.orderItemReferenceonLoadMethod();
       system.debug('@@oellist'+newOELList);
        for(Order_Entry_Line__c oelw : newOELList){
            CSS_OERMassUpdateController.WrapperClass wr = new CSS_OERMassUpdateController.WrapperClass(oelw);
            wr.checked = true;
            wr.oel = oelw ;
            obj.add(wr);
        }
        sdScreen.listWrapper = obj;
        sdScreen.allBool = true;
        
        sdScreen.isContinue= true;
        try{
        sdScreen.SelectSaveRecordsInlineEdit();
        sdScreen.CancelFunc();
        sdScreen.resetData();
        
        
        sdScreen.isContinue= true;
        sdScreen.isChanged= true;
        sdScreen.SelectSaveRecordsInlineEdit();
        sdScreen.CancelFunc();
        sdScreen.resetData();
        }
        catch(Exception e)
        {
        }
        
    }  
    
  static testMethod void TestMethod2()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
        'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
        'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        Test.stopTest(); 
        
        PageReference testPageRef = Page.CSS_OERMassUpdate;
       
        Test.setCurrentPage(testPageRef);
        
        Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
       Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ];
       ApexPages.currentPage().getParameters().put('id', String.valueOf(opp.Id));
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(oerList);
        CSS_OERMassUpdateController sdScreen = new CSS_OERMassUpdateController(stdSetController); 
        sdScreen.orderItemReferenceonLoadMethod();
        
        boolean isEditable = sdScreen.isHeaderEditable(OEL,'Draft');
        
        
        /* List <Order_Entry_Release__c> oerListData = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN : oerList];         
        sdScreen.selectedName = oerListData[0].Release_Name__c;*/
        sdScreen.selectedName = oerList[0].Release_Name__c;
        sdScreen.selectedReferenceId =oel.Customer_Reference_Description__c;
        sdScreen.selectedSKU = oel.SKU__C;
       
        
       List<CSS_OERMassUpdateController.WrapperClass> obj = new List<CSS_OERMassUpdateController.WrapperClass>();
        
         List<Order_Entry_Line__c> newOELList = [SELECT Id,Request_Date__c,Request_Date_Update_Needed__c,Is_Schedule_Date_Updated__c,Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c,Customer_Reference_Description__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c  
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = : oerList[0].Id];
        /*for(Order_Entry_Line__c oelw : newOELList){
            oelw.Request_Date__c = system.today();
            oelw.Request_Date_Change_Reason__c = 'Added trade';
            oelw.Scheduled_Ship_Date__c = system.today();
            oelw.Schedule_Ship_Date_Change_Reason__c = 'Added trade';
             
        }*/
       // update newOELList;
        
        Order_Entry_Line__c objOel = New Order_Entry_Line__c();
        objOel.Request_Date__c = system.today();
        objOel.Request_Date_Change_Reason__c = 'Added trade';
        objOel.Scheduled_Ship_Date__c = system.today();
        objOel.Schedule_Ship_Date_Change_Reason__c = 'Added trade';
        sdScreen.oel1 = objOel;
        sdScreen.orderItemReferenceonLoadMethod();
       
        for(Order_Entry_Line__c oelw : newOELList){
            CSS_OERMassUpdateController.WrapperClass wr = new CSS_OERMassUpdateController.WrapperClass(oelw);
            wr.checked = true;
            wr.oel = oelw ;
            obj.add(wr);
        }
        sdScreen.listWrapper = obj;
        sdScreen.allBool = true;
        
        sdScreen.SelectSaveRecordsInlineEdit();
        
        
        
        
        sdScreen.enableShipDate = true;
        sdScreen.enableRequestDate = false;
        sdScreen.SelectSaveRecordsInlineEdit();
        
        sdScreen.enableShipDate = false;
        sdScreen.enableRequestDate = true;
        sdScreen.SelectSaveRecordsInlineEdit();
        
        
        sdScreen.isContinue = true; 
        sdScreen.resetData();
        sdScreen.CancelFunc();
        sdScreen.isContinue = false;
         sdScreen.resetData();
        sdScreen.CancelFunc();
        //sdScreen.orderItemReferenceMethod();
        //obj.checked = true;
        sdScreen.selectIndividual();
        sdScreen.allBool = true;
        sdScreen.selectAll();
        
        
        objOel.Request_Date__c = system.today();
        objOel.Request_Date_Change_Reason__c = null;
        objOel.Scheduled_Ship_Date__c = system.today();
        objOel.Schedule_Ship_Date_Change_Reason__c = null;
        sdScreen.oel1 = objOel;
        
        for(Order_Entry_Line__c oelw : newOELList){
            CSS_OERMassUpdateController.WrapperClass wr = new CSS_OERMassUpdateController.WrapperClass(oelw);
            wr.checked = true;
            wr.oel = oelw ;
            obj.add(wr);
        }
        sdScreen.listWrapper = obj;
        
        try{
            sdScreen.allBool = true;
            sdScreen.enableShipDate = true;
            sdScreen.enableRequestDate = true;
            sdScreen.SelectSaveRecordsInlineEdit();
            sdScreen.approvedDates();
            sdScreen.GoBack();
            sdScreen.isContinue = true;
            sdScreen.isChanged = true;
            sdScreen.CancelFunc();
            sdScreen.resetData();
            sdScreen.approvedDates();
            sdScreen.GoBack();
            
            sdScreen.DisplayPageBlock = true;
            sdScreen.approvedDates();
            sdScreen.GoBack();
        }
        catch(exception ex){
        }
        
        //sdScreen.SelectSaveRecordsInlineEdit();
    }  
    
     static testMethod void TestMethod3()
    {
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 0, 'Users' => 0, 'Products' => 1,      
        'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
        'QuotesPerOppty' => 1, 'CPOsPerOppty' => 1};
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        
        Test.stopTest(); 
        PageReference testPageRef = Page.CSS_OERMassUpdate;
        //PageReference testPageRef = Page.CSS_MassUpdate;
        Test.setCurrentPage(testPageRef);
        //ApexPages.currentPage().getParameters().put('id',oerList[0].Id);
        Order_Entry_Line__c OEL =  oelMap.get(oerList[0].Id).get(0); 
        
        Opportunity opp=[select Id from Opportunity where Id =: oerList[0].Opportunity__c ];
        ApexPages.currentPage().getParameters().put('id', String.valueOf(opp.Id));
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(oerList);
        CSS_OERMassUpdateController sdScreen = new CSS_OERMassUpdateController(stdSetController); 
        sdScreen.orderItemReferenceonLoadMethod();
        boolean isEditable = sdScreen.isHeaderEditable(OEL,'Draft');
        
        
        /* List <Order_Entry_Release__c> oerListData = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, Quote__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN : oerList];   */      
        sdScreen.selectedName = oerList[0].Release_Name__c;
        sdScreen.selectedReferenceId ='testReferenceId';
        sdScreen.selectedSKU = 'SKU';
        //sdScreen.getOrders = oerListData;
        sdScreen.dummyCall();
        
       List<CSS_OERMassUpdateController.WrapperClass> obj = new List<CSS_OERMassUpdateController.WrapperClass>();
        
         List<Order_Entry_Line__c> newOELList = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, 
                    RecordTypeId, Status__c, Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , 
                    Shipping_Name__c, Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, 
                    Shipping_Country__c,Customer_Reference_Description__c, Use_Account_Shipping_Address__c,Installation_Type__c, Line_Number__c, Scheduled_Ship_Date__c, Shipping_Address__c,
                    Request_Date__c
                    FROM Order_Entry_Line__c WHERE Order_Entry_Release__c = : oerList[0].Id];
        
        
        
        Order_Entry_Line__c objOel = New Order_Entry_Line__c();
        objOel.Request_Date__c = system.today().addDays(5);
        objOel.Request_Date_Change_Reason__c = 'Added trade';
        objOel.Scheduled_Ship_Date__c = system.today();
        objOel.Schedule_Ship_Date_Change_Reason__c = 'Added trade';
        sdScreen.oel1 = objOel;
        
       
        for(Order_Entry_Line__c oelw : newOELList){
            CSS_OERMassUpdateController.WrapperClass wr = new CSS_OERMassUpdateController.WrapperClass(oelw);
            wr.checked = true;
            wr.oel = oelw ;
            obj.add(wr);
        }
        try{
        sdScreen.validationMsg = true;
        sdScreen.listWrapper = obj;
        sdScreen.allBool = false;
        sdScreen.SelectSaveRecordsInlineEdit();
        
        
        
        
        sdScreen.enableShipDate = true;
        sdScreen.enableRequestDate = false;
        sdScreen.SelectSaveRecordsInlineEdit();
        
        sdScreen.enableShipDate = false;
        sdScreen.enableRequestDate = true;
        sdScreen.DisplayPageBlock = false;
        sdScreen.SelectSaveRecordsInlineEdit();
        
        
        sdScreen.orderItemReferenceonLoadMethod();
        sdScreen.resetData();
        sdScreen.CancelFunc();
        //obj.checked = true;
        sdScreen.selectIndividual();
        sdScreen.allBool = false;
        sdScreen.selectAll();
        
        
        objOel.Request_Date__c = system.today();
        objOel.Request_Date_Change_Reason__c = null;
        objOel.Scheduled_Ship_Date__c = system.today();
        objOel.Schedule_Ship_Date_Change_Reason__c = null;
        sdScreen.oel1 = objOel;
        
        for(Order_Entry_Line__c oelw : newOELList){
            CSS_OERMassUpdateController.WrapperClass wr = new CSS_OERMassUpdateController.WrapperClass(oelw);
            wr.checked = true;
            wr.oel = oelw ;
            obj.add(wr);
        }
        sdScreen.listWrapper = obj;
        
        
            sdScreen.allBool = false;
            sdScreen.enableShipDate = true;
            sdScreen.enableRequestDate = true;
            
            sdScreen.SelectSaveRecordsInlineEdit();
            
            sdScreen.allBool = true;
            sdScreen.enableShipDate = true;
            sdScreen.enableRequestDate = true;
            sdScreen.isContinue= true;
            sdScreen.DisplayPageBlock = false;
            sdScreen.SelectSaveRecordsInlineEdit();
            sdScreen.approvedDates();
            sdScreen.GoBack();
           
        }
        catch(exception ex){
        }
        
        //sdScreen.SelectSaveRecordsInlineEdit();
    }  
}