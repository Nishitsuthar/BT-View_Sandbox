@isTest
public class Order_Entry_Line_BU_AU_test1
{
  
    
static testMethod void Elseconditiontest()
    {
       Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
     
        System.runAs ( dealDeskUser ) {

        
     //   OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        //---rekha change
  //      System.runAs ( oetd.userList[0] ) {
            
            
          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();

       
        Account acc = new Account();
        acc.Name='test';
       // acc.BillingAddress
        acc.BillingCity='Livermore';
        acc.BillingCountry='USA';
        acc.BillingPostalCode='94550';
        acc.BillingState='CA';
        acc.BillingStreet='6400 Brisa Street';
        acc.Oracle_Customer_Number__c ='123';
         acc.ShippingCity='Livermore';
        acc.ShippingCountry='USA';
        acc.ShippingPostalCode='94550';
        acc.ShippingState='CA';
        acc.ShippingStreet='6400 Brisa Street';
        insert acc;
        
        contact c = new contact();
        c.AccountId = acc.id;
        c.LastName='Test';
        c.Salutation='Mr.';
        c.Email='test@test.com';
        insert c;
        
       Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOpptyParent';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype; 
        testMOUOpportunityObj.AccountId= acc.id;
            testMOUOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Ops_Owner__c =UserInfo.getUserId(); 
       // testMOUOpportunityObj.pri
        insert testMOUOpportunityObj;
        
       Order_Entry_Release__c od = new Order_Entry_Release__c();
        od.name='s';
        od.Release_Name__c='test';
           od.Order_Type__c='Standard';
            od.Payment_Terms__c='1% 10, Net 30';
            od.Freight__c='Billable';
            od.MES_Routing__c='MES';
            od.Opportunity__c = testMOUOpportunityObj.id;
            od.Shipping_Account__c=acc.id;
            od.Sold_to_Account__c =acc.id;
            od.Shipping_Account__c =acc.id;
            od.Billing_Account__c = acc.id;
            od.Scheduled_Ship_Date__c=system.today()+10;
          
        insert od;
            SKU_Prefix_Element_Map__c eleMap;
        List<SKU_Prefix_Element_Map__c> lstEleMap = new List<SKU_Prefix_Element_Map__c>();
        List<String> eleMapName = new List<String>{'Generation', 'Laminate', 'Color', 'Shape', 'Panes'};
        
        for(Integer i = 0; i<5; i++) {
            eleMap = new SKU_Prefix_Element_Map__c();
            eleMap.Name = eleMapName[i];
            lstEleMap.add(eleMap);
        }
        insert lstEleMap;
          SKU_Prefix_Element_Map_Entry__c eleMapEntry;
        List<SKU_Prefix_Element_Map_Entry__c> lstEleMapEntry = new List<SKU_Prefix_Element_Map_Entry__c>();
        List<String> lstMapValue = new List<String>{
            '2', 'NO', 'CLR (CLEAR)', 'SHAPE','DOUBLE'
        };
        for(Integer i = 0; i<5; i++) {
            eleMapEntry = new SKU_Prefix_Element_Map_Entry__c();
            eleMapEntry.Name = lstMapValue[i];
            eleMapEntry.Map_to_Value__c = '0'+i;
            eleMapEntry.SKU_Prefix_Element_Map__c = lstEleMap[i].Id;
            lstEleMapEntry.add(eleMapEntry);
        }
        
        insert lstEleMapEntry;

     Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        testProductObj.BOS_Non_Operable__c = true;
        testProductObj.Family  = 'IGU';
        testProductObj.CSS_SqFt_Countable__c=true;
        testProductObj.Generation__c  = '2';
        testProductObj.Laminate__c = 'No';
        testProductObj.Panes__c = 'Double';
        testProductObj.Inboard_Lite__c = 'CLR (Clear)';
        testProductObj.Spacer__c = '1/2" 90% Argon';
        testProductObj.Inboard_Thickness__c = '6MM';
        testProductObj.Shape__c = 'Shape';
        testProductObj.Inboard_Treatment__c = 'T (Tempered)';
        testProductObj.Spacer_Type__c = 'TRISEAL FOAM';
        testProductObj.Spacer_Thickness__c = '1/2" (12.7 mm.)';
        testProductObj.Spacer_Fill__c = '90% Argon';
        testProductObj.Outboard_Lite__c = '6MM EC #2 CLR T';
        testProductObj.Edge_Black__c = 'NONE';
        testProductObj.Outboard_Treatment__c = 'T (Tempered)';
        testProductObj.Bird_Friendly__c = 'No';
        testProductObj.Pig_Tail__c = 'KEYED M8';
        testProductObj.IGU_Overall_Thickness__c = 1;
        testProductObj.Secondary_Seal_Color__c = 'Black';
        testProductObj.Secondary_Seal_Type__c = 'SI';
     //       testProductObj.IsActive = true;
        insert testProductObj;
      
        //  RecordType rt1 = new RecordType();   
         //   RecordType rt1 = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];
     SBQQ__Quote__c quote=new SBQQ__Quote__c();
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId= '0120h000000YOJuAAO';
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = c.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
    quote.Related_Opportunity__c = testMOUOpportunityObj.Id;
        insert quote;
            Test.startTest();
      SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
         qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
    qtLine.SBQQ__Product__c = testProductObj.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
        qtLine.SBQQ__CustomerPrice__c=5.03;
       insert qtLine;
            
               SBQQ__Quote__c sb = new SBQQ__Quote__c();
        sb.SBQQ__Status__c = 'Active';
      //  sb.Name='test';
        sb.Quote_Name__c='ss';
        sb.Quote_Approval_Type__c='Pricing Approval';
        sb.Are_you_using_Plenum__c='Yes';
        sb.Shipping_Included__c ='No';
        sb.Detailed_Summary_of_Deal__c='test';
        sb.SBQQ__Account__c=acc.id;
        sb.SBQQ__PrimaryContact__c=c.id;
      //  insert sb;
      //  
      //  
            Quote quote_Obj1 = new Quote(Name = 'Name113',OpportunityId=testMOUOpportunityObj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
 Insert quote_Obj1; 

 //  RecordType rt = new RecordType();         
 //  rt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND (SObjectType = 'Order_Entry_Release__c')  LIMIT 1 ];     
/*Order_Entry_Line__c odl = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 50, Base_In__c = '65', Height_In__c = '88 3/16',
                            Base_Height_1_In__c = ' ', Shape__c = 'Rectangle', 
                                                 recordtypeid = '0120L000000NQCrQAO',
                                                  Status__c = 'Draft', Base_mm__c = 15,Height_mm__c = 17,

                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Unit_Price__c = 707.70,Base_Height_1_Decimal_In__c = 0.0, Base_Decimal_In__c = 57.5, Height_Decimal_In__c = 65.25,Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 90);*/
            Order_Entry_Line__c odl = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 1, Base_In__c = '59 1/4', Height_In__c = '115',
                            Base_Height_1_In__c = ' ', Shape__c = 'Rectangle', 
                                                 recordtypeid = '0120L000000NQCrQAO',
                                                  Status__c = 'Draft', Base_mm__c = 1505 ,Height_mm__c = 2921,

                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C5-1' , Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Unit_Price__c = 707.77,Base_Height_1_Decimal_In__c = 0.0, Base_Decimal_In__c = 59.2500, Height_Decimal_In__c = 115.0000,Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 90);
            
        
        insert odl;            
        
      /*    Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=testMOUOpportunityObj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
          Insert quote_Obj; 
 
           od.Quote__c= quote_Obj.id;
           od.Scheduled_Ship_Date__c=system.today()+20;
           od.Order_Book_Date__c = system.now()+1;
              od.Extended_Price_Total__c=10000;
             od.Sales_Order_Status__c='Booked';
        update od; */

      //  List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 2, 'Imperial (US Standard)','CPQ');
           
        List <Order_Entry_Release__c> oerList = new  List <Order_Entry_Release__c>();  
     //   Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 2);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testOER;
        Boolean passedTest;
     /*    oerList = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = od.Id];  
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c,Request_Date_Update_Needed__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :od.Id];*/
               system.debug('--updatedOELs--'+odl.Scheduled_Ship_Date__c);
        system.debug('--updatedOELs--'+odl);  
        Order_Entry_Release__c testRel = od;
        Order_Entry_Line__c testOEL = odl;
        //testOEL.Status__c='Shipped';
        testOEL.Request_Date__c= System.Today() + 3;
        testOEL.Request_Date_Update_Needed__c=true;
        testOEL.Shipping_City__c='Hyd';
        testOEL.Shipping_Country__c='India';
        testOEL.Shipping_Name__c='fffof';
        testOEL.Shipping_Postal_Code__c='7474747';
        testOEL.Shipping_Street_1__c='kkkfkfk';
        passedTest = true;
        update testOEL;
     /*    oerList = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN :oelMap.keyset()];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c,Request_Date_Update_Needed__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :oelMap.keySet()];*/
        testRel=od;
        testOEL = odl;
       testRel.Trigger_Source__c = 'Test Data Setup';
        testRel.Status__c = 'In Production';
             update testRel;
        testRel.Trigger_Source__c = 'UI';
       // for (Order_Entry_Line__c oel: oelMap.get(testRel.id))
       // {
            odl.Trigger_Source__c = 'Test Data Setup';
            odl.Status__c = 'In Production';
       // }
      //  update oelMap.get(testRel.id);
        update odl;
       // for (Order_Entry_Line__c oel: oelMap.get(testRel.id))
       // {
            odl.Trigger_Source__c = 'UI';
      //  }
        Map <String,Schema.RecordTypeInfo> recordTypeOEL = Order_Entry_Line__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id RecType_IGU;
        Id RecType_CSS_Hardware;
        if(recordTypeOEL.containskey('IGU')){
             RecType_IGU = recordTypeOEL.get('IGU').getRecordTypeId();
        }
        if(recordTypeOEL.containskey(Label.CSS_Hardware)){
             
            RecType_CSS_Hardware = recordTypeOEL.get(Label.CSS_Hardware).getRecordTypeId();
        }
        system.debug('--RecType_CSS_Hardware--'+RecType_CSS_Hardware);
     // Id RecType_CSS_Hardware = recordTypeOEL.get(Label.CSS_Hardware).getRecordTypeId();          
               
        //Test.startTest();
        testRel = od;
       
        
        testOEL = odl;
        testOEL.Trigger_Source__c = 'UI';
        //testOEL.Status__c = 'Cancellation Requested';
       // testOEL.Cancellation_Reason__c = '';
        testOEL.Integration_Action_Requested__c='Cancel';
        testOEL.Unit_Price__c=234;
        try{
            update testOEL;
        }catch(dmlException e){}
      testOEL.Status__c = 'Change Integration Requested';
       
           try{
            update testOEL;
        }catch(dmlException e){}
       
        system.debug('--testOEL.Status__c--'+testOEL.Status__c);
            Test.stopTest();
    }
    }  

   static testMethod void TestMethod1()
    {
        
       Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
     
        System.runAs ( dealDeskUser ) {

        
     //   OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        //---rekha change
  //      System.runAs ( oetd.userList[0] ) {
            
            
          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
    //   Test.startTest();
   // System.test.startTest();
   
        Account acc = new Account();
        acc.Name='test';
       // acc.BillingAddress
        acc.BillingCity='Livermore';
        acc.BillingCountry='USA';
        acc.BillingPostalCode='94550';
        acc.BillingState='CA';
        acc.BillingStreet='6400 Brisa Street';
        acc.Oracle_Customer_Number__c ='123';
         acc.ShippingCity='Livermore';
        acc.ShippingCountry='USA';
        acc.ShippingPostalCode='94550';
        acc.ShippingState='CA';
        acc.ShippingStreet='6400 Brisa Street';
        insert acc;
        
        contact c = new contact();
        c.AccountId = acc.id;
        c.LastName='Test';
        c.Salutation='Mr.';
        c.Email='test@test.com';
        insert c;
        
       Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOpptyParent';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype; 
        testMOUOpportunityObj.AccountId= acc.id;
            testMOUOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Ops_Owner__c =UserInfo.getUserId(); 
       // testMOUOpportunityObj.pri
        insert testMOUOpportunityObj;
        
       Order_Entry_Release__c od = new Order_Entry_Release__c();
        od.name='s';
        od.Release_Name__c='test';
           od.Order_Type__c='Standard';
            od.Payment_Terms__c='1% 10, Net 30';
            od.Freight__c='Billable';
            od.MES_Routing__c='MES';
            od.Opportunity__c = testMOUOpportunityObj.id;
            od.Shipping_Account__c=acc.id;
            od.Sold_to_Account__c =acc.id;
            od.Shipping_Account__c =acc.id;
            od.Billing_Account__c = acc.id;
            od.Scheduled_Ship_Date__c=system.today()+10;
          
        insert od;
                  SKU_Prefix_Element_Map__c eleMap;
        List<SKU_Prefix_Element_Map__c> lstEleMap = new List<SKU_Prefix_Element_Map__c>();
        List<String> eleMapName = new List<String>{'Generation', 'Laminate', 'Color', 'Shape', 'Panes'};
        
        for(Integer i = 0; i<5; i++) {
            eleMap = new SKU_Prefix_Element_Map__c();
            eleMap.Name = eleMapName[i];
            lstEleMap.add(eleMap);
        }
        insert lstEleMap;
          SKU_Prefix_Element_Map_Entry__c eleMapEntry;
        List<SKU_Prefix_Element_Map_Entry__c> lstEleMapEntry = new List<SKU_Prefix_Element_Map_Entry__c>();
        List<String> lstMapValue = new List<String>{
            '2', 'NO', 'CLR (CLEAR)', 'SHAPE','DOUBLE'
        };
        for(Integer i = 0; i<5; i++) {
            eleMapEntry = new SKU_Prefix_Element_Map_Entry__c();
            eleMapEntry.Name = lstMapValue[i];
            eleMapEntry.Map_to_Value__c = '0'+i;
            eleMapEntry.SKU_Prefix_Element_Map__c = lstEleMap[i].Id;
            lstEleMapEntry.add(eleMapEntry);
        }
        
        insert lstEleMapEntry;

     Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        testProductObj.BOS_Non_Operable__c = true;
        testProductObj.Family  = 'IGU';
        testProductObj.CSS_SqFt_Countable__c=true;
        testProductObj.Generation__c  = '2';
        testProductObj.Laminate__c = 'No';
        testProductObj.Panes__c = 'Double';
        testProductObj.Inboard_Lite__c = 'CLR (Clear)';
        testProductObj.Spacer__c = '1/2" 90% Argon';
        testProductObj.Inboard_Thickness__c = '6MM';
        testProductObj.Shape__c = 'Shape';
        testProductObj.Inboard_Treatment__c = 'T (Tempered)';
        testProductObj.Spacer_Type__c = 'TRISEAL FOAM';
        testProductObj.Spacer_Thickness__c = '1/2" (12.7 mm.)';
        testProductObj.Spacer_Fill__c = '90% Argon';
        testProductObj.Outboard_Lite__c = '6MM EC #2 CLR T';
        testProductObj.Edge_Black__c = 'NONE';
        testProductObj.Outboard_Treatment__c = 'T (Tempered)';
        testProductObj.Bird_Friendly__c = 'No';
        testProductObj.Pig_Tail__c = 'KEYED M8';
        testProductObj.IGU_Overall_Thickness__c = 1;
        testProductObj.Secondary_Seal_Color__c = 'Black';
        testProductObj.Secondary_Seal_Type__c = 'SI';
     //       testProductObj.IsActive = true;
        insert testProductObj; 
            //  RecordType rt1 = new RecordType();   
         //   RecordType rt1 = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];
     SBQQ__Quote__c quote=new SBQQ__Quote__c();
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId= '0120h000000YOJuAAO';
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = c.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
    quote.Related_Opportunity__c = testMOUOpportunityObj.Id;
        insert quote;
    //    Test.startTest();  
      SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
         qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
    qtLine.SBQQ__Product__c = testProductObj.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
        qtLine.SBQQ__CustomerPrice__c=5.03;
       insert qtLine;
            
               SBQQ__Quote__c sb = new SBQQ__Quote__c();
        sb.SBQQ__Status__c = 'Active';
      //  sb.Name='test';
        sb.Quote_Name__c='ss';
        sb.Quote_Approval_Type__c='Pricing Approval';
        sb.Are_you_using_Plenum__c='Yes';
        sb.Shipping_Included__c ='No';
        sb.Detailed_Summary_of_Deal__c='test';
        sb.SBQQ__Account__c=acc.id;
        sb.SBQQ__PrimaryContact__c=c.id;
      //  insert sb;
      //  
      //  
            Quote quote_Obj1 = new Quote(Name = 'Name113',OpportunityId=testMOUOpportunityObj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
 Insert quote_Obj1; 

 //  RecordType rt = new RecordType();         
 //  rt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND (SObjectType = 'Order_Entry_Release__c')  LIMIT 1 ];     
/* Order_Entry_Line__c odl = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 50, Base_In__c = '65', Height_In__c = '88 3/16',
                            Base_Height_1_In__c = ' ', Shape__c = 'Rectangle', 
                                                 recordtypeid = '0120L000000NQCrQAO',
                                                  Status__c = 'Draft', Base_mm__c = 15,Height_mm__c = 17,

                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Unit_Price__c = 707.70,Base_Height_1_Decimal_In__c = 0.0, Base_Decimal_In__c = 57.5, Height_Decimal_In__c = 65.25,Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 90);*/
            Order_Entry_Line__c odl = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 1, Base_In__c = '59 1/4', Height_In__c = '115',
                            Base_Height_1_In__c = ' ', Shape__c = 'Rectangle', 
                                           //      recordtypeid = '0120L000000NQCrQAO',
                                                  Status__c = 'Draft', Base_mm__c = 1505 ,Height_mm__c = 2921,

                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C5-1' , Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Unit_Price__c = 707.77,Base_Height_1_Decimal_In__c = 0.0, Base_Decimal_In__c = 59.2500, Height_Decimal_In__c = 115.0000,Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 90);
        
        insert odl;            
        
      /*    Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=testMOUOpportunityObj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
 Insert quote_Obj; 
 
           od.Quote__c= quote_Obj.id;
           od.Scheduled_Ship_Date__c=system.today()+20;
           od.Order_Book_Date__c = system.now()+1;
              od.Extended_Price_Total__c=10000;
             od.Sales_Order_Status__c='Booked';
        update od;  */

        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testOER;
        Boolean passedTest;
        
        
                
      /*  oerList = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN :oelMap.keyset()];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :oelMap.keySet()];*/
                    
        Order_Entry_Line__c testOEL = odl;
        
        testOEL.Shipping_City__c = 'Burbank';
        testOEL.Request_Date__c = System.Today() + 300;
        testOEL.Scheduled_Ship_Date__c = System.Today() + 225;
        testOEL.Promised_Date__c = System.Today() + 275;
        testOEL.Quantity__c = testOEL.Quantity__c + 15.0;
        testOEL.Mark_Ids__c = 'Mark 2';
        
        
        Test.startTest();        
        passedTest = true;
        try
        {
            update testOEL;
        }
        catch (Exception ex)
        {
            passedTest = false;
        }
        System.assert(passedTest);
         
                
       /* oerList = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN :oelMap.keyset()];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :oelMap.keySet()];*/
                    
        testOEL = odl;
        testOER = od;
            
            
        testOEL.Request_Date__c = null;
        testOEL.Scheduled_Ship_Date__c = null;
        testOEL.Promised_Date__c = null;
        
                
        passedTest = true;
        try
        {
            update testOEL;
        }
        catch (Exception ex)
        {
            passedTest = false;
        }
        System.assert(passedTest);
                    
        
        testOEL.Request_Date__c = System.Today() + 305;
        testOEL.Scheduled_Ship_Date__c = System.Today() + 225;
        testOEL.Promised_Date__c = System.Today() + 205;
        
                
        passedTest = true;
        try
        {
            update testOEL;
        }
        catch (Exception ex)
        {
            System.debug('Exception: ' + ex.getMessage());
            passedTest = false;
        }
        System.assert(passedTest);

     /*   oerList = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
                    Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
                    Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
                    Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
                    Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
                    Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
                    Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
                    System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
                    Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
                    Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id IN :oelMap.keyset()];
                    
        updatedOELs = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c IN :oelMap.keySet()]; */
      
                    
        
        testOEr = od;
       
        
        testOER.Status__c = 'Integration Requested';
        testOER.Trigger_Source__c = 'UI';


        passedTest = true;
        System.debug('**********'+testOER);
        try
        {
            update testOER;
            System.debug('**********'+testOER);
        }
        
        catch (Exception ex)
        {
            System.debug('Exception: ' + ex.getMessage());
            passedTest = false;
        }
        System.debug('**********'+passedTest);
        System.assert(!passedTest);
        Test.stopTest();
   
    
    
}
        
}    
 static testMethod void TestMethod2()
    {
        // *********************************************************************
        //
        // Tests process for individual Order Entry Lines
        //
        // *********************************************************************
        
        {
       Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
     
        System.runAs ( dealDeskUser ) {

        
     //   OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        //---rekha change
  //      System.runAs ( oetd.userList[0] ) {
            
            
          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();

       
        Account acc = new Account();
        acc.Name='test';
       // acc.BillingAddress
        acc.BillingCity='Livermore';
        acc.BillingCountry='USA';
        acc.BillingPostalCode='94550';
        acc.BillingState='CA';
        acc.BillingStreet='6400 Brisa Street';
        acc.Oracle_Customer_Number__c ='123';
         acc.ShippingCity='Livermore';
        acc.ShippingCountry='USA';
        acc.ShippingPostalCode='94550';
        acc.ShippingState='CA';
        acc.ShippingStreet='6400 Brisa Street';
        insert acc;
        
        contact c = new contact();
        c.AccountId = acc.id;
        c.LastName='Test';
        c.Salutation='Mr.';
        c.Email='test@test.com';
        insert c;
        
       Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOpptyParent';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype; 
        testMOUOpportunityObj.AccountId= acc.id;
            testMOUOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Ops_Owner__c =UserInfo.getUserId(); 
       // testMOUOpportunityObj.pri
        insert testMOUOpportunityObj;
        
       Order_Entry_Release__c od = new Order_Entry_Release__c();
        od.name='s';
        od.Release_Name__c='test';
           // od.Status__c = 'Draft';
           od.Order_Type__c='Standard';
            od.Payment_Terms__c='1% 10, Net 30';
            od.Freight__c='Billable';
            od.MES_Routing__c='MES';
            od.Opportunity__c = testMOUOpportunityObj.id;
            od.Shipping_Account__c=acc.id;
            od.Sold_to_Account__c =acc.id;
            od.Shipping_Account__c =acc.id;
            od.Billing_Account__c = acc.id;
            od.Scheduled_Ship_Date__c=system.today()+10;
          
        insert od;
        
        SKU_Prefix_Element_Map__c eleMap;
        List<SKU_Prefix_Element_Map__c> lstEleMap = new List<SKU_Prefix_Element_Map__c>();
        List<String> eleMapName = new List<String>{'Generation', 'Laminate', 'Color', 'Shape', 'Panes'};
        
        for(Integer i = 0; i<5; i++) {
            eleMap = new SKU_Prefix_Element_Map__c();
            eleMap.Name = eleMapName[i];
            lstEleMap.add(eleMap);
        }
        insert lstEleMap;
            
          SKU_Prefix_Element_Map_Entry__c eleMapEntry;
        List<SKU_Prefix_Element_Map_Entry__c> lstEleMapEntry = new List<SKU_Prefix_Element_Map_Entry__c>();
        List<String> lstMapValue = new List<String>{
            '2', 'NO', 'CLR (CLEAR)', 'SHAPE','DOUBLE'
        };
        for(Integer i = 0; i<5; i++) {
            eleMapEntry = new SKU_Prefix_Element_Map_Entry__c();
            eleMapEntry.Name = lstMapValue[i];
            eleMapEntry.Map_to_Value__c = '0'+i;
            eleMapEntry.SKU_Prefix_Element_Map__c = lstEleMap[i].Id;
            lstEleMapEntry.add(eleMapEntry);
        }
        
        insert lstEleMapEntry;

     Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        testProductObj.BOS_Non_Operable__c = true;
        testProductObj.Family  = 'IGU';
        testProductObj.CSS_SqFt_Countable__c=true;
        testProductObj.Generation__c  = '2';
        testProductObj.Laminate__c = 'No';
        testProductObj.Panes__c = 'Double';
        testProductObj.Inboard_Lite__c = 'CLR (Clear)';
        testProductObj.Spacer__c = '1/2" 90% Argon';
        testProductObj.Inboard_Thickness__c = '6MM';
        testProductObj.Shape__c = 'Shape';
        testProductObj.Inboard_Treatment__c = 'T (Tempered)';
        testProductObj.Spacer_Type__c = 'TRISEAL FOAM';
        testProductObj.Spacer_Thickness__c = '1/2" (12.7 mm.)';
        testProductObj.Spacer_Fill__c = '90% Argon';
        testProductObj.Outboard_Lite__c = '6MM EC #2 CLR T';
        testProductObj.Edge_Black__c = 'NONE';
        testProductObj.Outboard_Treatment__c = 'T (Tempered)';
        testProductObj.Bird_Friendly__c = 'No';
        testProductObj.Pig_Tail__c = 'KEYED M8';
        testProductObj.IGU_Overall_Thickness__c = 1;
        testProductObj.Secondary_Seal_Color__c = 'Black';
        testProductObj.Secondary_Seal_Type__c = 'SI';
     // testProductObj.IsActive = true;
        insert testProductObj;
        //  RecordType rt1 = new RecordType();   
         //   RecordType rt1 = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];
     
        SBQQ__Quote__c quote=new SBQQ__Quote__c();
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId= '0120h000000YOJuAAO';
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = c.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
      quote.Related_Opportunity__c = testMOUOpportunityObj.Id;
        insert quote;
            Test.startTest();
            
      SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
         qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
      qtLine.SBQQ__Product__c = testProductObj.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
        qtLine.SBQQ__CustomerPrice__c=5.03;
       insert qtLine;
            
               SBQQ__Quote__c sb = new SBQQ__Quote__c();
        sb.SBQQ__Status__c = 'Active';
      //  sb.Name='test';
        sb.Quote_Name__c='ss';
        sb.Quote_Approval_Type__c='Pricing Approval';
        sb.Are_you_using_Plenum__c='Yes';
        sb.Shipping_Included__c ='No';
        sb.Detailed_Summary_of_Deal__c='test';
        sb.SBQQ__Account__c=acc.id;
        sb.SBQQ__PrimaryContact__c=c.id;
      //  insert sb;
      
            Order_Entry_Line__c odl = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 10, Base_In__c = '59 1/4', Height_In__c = '115',
                            Base_Height_1_In__c = ' ', Shape__c = 'Rectangle', 
                                                 recordtypeid = '0120L000000NQCrQAO', Base_mm__c = 1505 ,Height_mm__c = 2921,

                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C5-1' , Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Unit_Price__c = 707.77,Base_Height_1_Decimal_In__c = 0.0, Base_Decimal_In__c = 59.2500, Height_Decimal_In__c = 115.0000,Scheduled_Ship_Date__c = System.today() + 240, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 90);
            
        
        insert odl;            
        
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        Order_Entry_Line__c testOEL;
        Boolean passedTest;
 

            odl.Trigger_Source__c = 'Test Data Setup';
            //odl.Status__c = 'In Production';
            odl.Request_Date__c = System.today() + 100;
            odl.Scheduled_Ship_Date__c =System.today() + 260;
     
        update odl;
      
       // odl.Status__c = 'Cancellation Confirmed';
        odl.Trigger_Source__c = 'UI';
        
        update odl;

     
                                
        //odl.Status__c = 'Cancellation Integration Requested';
        odl.Trigger_Source__c = 'UI';
        
        update odl;

      
        odl.Trigger_Source__c = 'Integration';
        odl.Integration_Status__c = 'Complete';
        
        update odl;

       Test.stopTest();
    }    
    
 }
}
   


}