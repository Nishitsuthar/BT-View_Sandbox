@isTest
public class TestOESFDC {
    //
    // Update to handle both CPQ and SFDC Quote Types
    // Updated product creation to incorporate fields required by validation rules
    static testMethod void abc(){
        

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();
        
        recordtype recid = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Imperial'];
             recordtype recid2 = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Metric'];

        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
     
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
        testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Ops_Owner__c ='005E0000007tPIo';
        testMOUOpportunityObj.Regional_Vice_President__c = '005E0000007Nik3';
        insert testMOUOpportunityObj;
        
         
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Opportunity testOpportunityObj = new Opportunity();
        testOpportunityObj.Name = 'testOppty';
        testOpportunityObj.CloseDate = Date.today();
        testOpportunityObj.StageName = 'POC Stage';
        testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
        testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
        testOpportunityObj.Winning_Total_of_IGUs__c = 2;
        testOpportunityObj.IGU_Total_Amount__c = 10;
        testOpportunityObj.BOS_Total_Amount__c = 10;
        testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
        testOpportunityObj.Support_Region__c='Atlanta/Carolinas';
        testOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
        testOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testOpportunityObj.Sales_Ops_Owner__c ='005E0000007tPIo';
        testOpportunityObj.Regional_Vice_President__c = '005E0000007Nik3';
        
        insert testOpportunityObj;      
        

        account acc = new account();
        acc.name = 'View Inc';
         acc.BillingStreet ='1482 Cliveden Ave.' ;
         acc.BillingCity ='Delta' ;
         acc.BillingState = 'British Columbia';
         acc.BillingPostalCode ='V3M 6K2' ;
        acc.BillingCountry = 'Canada';
        acc.Oracle_Customer_Number__c   ='3591';
        insert acc;

        contact con = new contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc.id;
        con.Email = 'test_view@testview.com';
        insert con;
        
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
  List<Product2> productsample = NEW List<Product2>();
     Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //testProductObj.Family  = 'BOS';
        testProductObj.Family  = 'CSS';
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
        insert testProductObj;
    productsample.add(testProductObj);
        RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];
     SBQQ__Quote__c quote=new SBQQ__Quote__c();
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId=qrt.id;
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = con.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
    quote.Related_Opportunity__c = testOpportunityObj.Id;
        insert quote;
        system.debug('^^^^^^^^^^'+quote.id);
         List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>();  
        system.debug('%%%%quote%%%%'+quote+quote.Total_IGU_s_QL__c+'999999999'+quote.BOS_Total_Sq_Ft__c);
        SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //qtline.Product_Family_CPQ__c = 'BOS';
        qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
    qtLine.SBQQ__Product__c = testProductObj.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
       insert qtLine;
     qliList.add(qtLine);
     Test.stopTest();
        Order_Entry_Release__c oer = new Order_Entry_Release__c(Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id ,Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.', 
                            Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6',
                            Shipping_State_Province__c = 'BC', Shipping_Country__c = 'CANADA',Opportunity__c=testOpportunityObj.id,Release_Name__c='test');
        try{
      insert oer;
      }catch(exception e){}
             
        Integer oelQuantity;
            String oelShape;
            String oelBase;
            String oelHeight;
            String oelBaseHeight;
        
        Order_Entry_Line__c test22 = new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase, Height_In__c = oelHeight,
                            Base_Height_1_In__c = oelBaseHeight, Shape__c = oelShape, recordtypeid = recid.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = oer.Shipping_Name__c, Shipping_Street_1__c = oer.Shipping_Street_1__c, 
                            Shipping_Account__c = oer.Shipping_Account__c, Shipping_City__c = oer.Shipping_City__c, Shipping_Postal_Code__c = oer.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = oer.Shipping_State_Province__c, Shipping_Country__c = oer.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1);
        
         Order_Entry_Line__c test2 = new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase, Height_In__c = oelHeight,
                            Base_Height_1_In__c = oelBaseHeight, Shape__c = 'oelShape', recordtypeid = recid.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = oer.Shipping_Name__c, Shipping_Street_1__c = oer.Shipping_Street_1__c, 
                            Shipping_Account__c = oer.Shipping_Account__c, Shipping_City__c = oer.Shipping_City__c, Shipping_Postal_Code__c = oer.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = oer.Shipping_State_Province__c, Shipping_Country__c = oer.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1, Base_Decimal_In__c= 140.0,Height_Decimal_In__c = 135.0);
        
         Order_Entry_Line__c test3 = new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase,Base_mm__c = null,Height_In__c = oelHeight, Height_mm__c = null,
                            Base_Height_1_In__c = oelBaseHeight, Base_Height_1_mm__c = null, Shape__c = 'Trapezoid', recordtypeid = recid2.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = oer.Shipping_Name__c, Shipping_Street_1__c = oer.Shipping_Street_1__c, 
                            Shipping_Account__c = oer.Shipping_Account__c, Shipping_City__c = oer.Shipping_City__c, Shipping_Postal_Code__c = oer.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = oer.Shipping_State_Province__c, Shipping_Country__c = oer.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1, Base_Decimal_In__c= 140.0,Height_Decimal_In__c = 135.0);
        
        
        try{            
             insert test22;           
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Base (in.) may not be null') ? true : false;
           // System.AssertEquals(expectedExceptionThrown, true);
            
        }   
        try{            
             insert test2;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Base (in.) may not be null') ? true : false;
            //System.AssertEquals(expectedExceptionThrown, true);
            
        } 
        try{      
            
             insert test3;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Base (mm.) may not be null') ? true : false;
          //  System.AssertEquals(expectedExceptionThrown, true);
            
        } 
        
        OrderEntryLineWrapper wrap = new OrderEntryLineWrapper(test22);
        OrderEntryLineWrapper wrap2 = new OrderEntryLineWrapper(test22,1);
        OrderEntryLineWrapper wrap3 = new OrderEntryLineWrapper(test22,1,'IGU_Imperial');
        Boolean vari = Order_Entry_Trigger_Helper_2.validateDimensions(wrap2);
        Order_Entry_Trigger_Helper_2.validateReleaseInsert();
        
        ///////////////////////////////////////////////////////////////////////////////////////
      //  List<Product2> testcont = oetd.prodList;
       // System.assert(oetd.prodList.size() > 0);
        
        String aa = Order_Entry_Trigger_Helper_2.addChangeType('abcd','abc');
        //System.assertEquals('abc;abcd', aa);
        String bb = Order_Entry_Trigger_Helper_2.addChangeType('abc','abcd');
        //System.assertEquals('abcd', bb);
        String cc = Order_Entry_Trigger_Helper_2.addChangeType('abcd',null);
       // System.assertEquals('abcd;', cc);
        
        //Map<String, RecordType> ab = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap('Opportunity');
        
        Map<String, RecordType> ab = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap('MOU Single Project Opportunity'); 
        //System.assert(ab.size() > 0);
               
       // Map<ID, RecordType> bc = Order_Entry_Trigger_Helper_2.getRecordTypeMap('Opportunity');
        Map<ID, RecordType> bc = Order_Entry_Trigger_Helper_2.getRecordTypeMap('MOU Single Project Opportunity');
        Map<String, RecordType> te = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap(bc);
        //System.assert(te.size() > 0);
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        PageReference pgref1 = Page.UpdateOrderEntryLine;
        Test.setCurrentPage(pgref1);
       // pgref.getParameters().put('RecordType', String.valueOf(recid.ID));
   //    try{
   //     ApexPages.StandardController sc1 = new ApexPages.standardController(test22);
   //     OrderEntryLineUpdateExt ss1 = new OrderEntryLineUpdateExt(sc1);
       // System.assert(ss1 != null);
  //      Pagereference pdd2 = ss1.updateShippingInfo();
   //     }catch(exception e){}
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        //CreateProductSKU
        Map <String, Map<String,String>> skuPrefixMaps = new Map<String, Map<String,String>> 
        {
            'Laminate' => new Map<String,String> {'NO' => '0', '.060 PVB' => '1', '.090 SGP' => '1', '.030 PVB' => '1', '.090 PVB' => '1', '.060 SGP' => '1', '.180 SGP' => '1'},
            'Generation' => new Map<String,String> {'1' => '1', '2' => '2', '3' => '3'}, 
            'Color' => new Map<String,String> {'CLR (CLEAR)' => '1', 'CLEAR' => '1', 'SBL (SOLAR BLUE)' => '2', 'SOLAR BLUE' => '2', 'AZU (AZURIA)' => '3', 'AZURIA' => '3', 
                'PAC (PACIFICA)' => '4', 'PACIFIC BLUE' => '4', 'SGY (SOLAR GRAY)' => '6', 'SOLAR GRAY' => '6', 'CGY (CRYSTAL GRAY)' => '7', 'CRYSTAL GRAY' => '7', 
                'LOW-E SN68' => '8', 'LOW-E I89' => '9', 'IS20' => 'A', 'LOW IRON SAPPHIRE' => 'B'}, 
            'Panes' => new Map<String,String> {'DOUBLE' => '2', 'TRIPLE' => '3'}, 
            'Shape' => new Map<String,String> {'RECTANGLE' => '1', 'SHAPE' => '2'}
        };
        List<String> paneList = new List<String>(skuPrefixMaps.get('Panes').keySet());
        String productCode = '9' + String.valueOf(XMath.getRandomInt(100)) + '-' + String.valueOf(XMath.getRandomInt(100000));
        
        //
        // 20180604 - JV Added fields to the new product creation to include fields required by Validation Rules.
        //
        Product2 val1 = new Product2(Name = 'Product' + String.valueOf(1), Generation__c = null, Shape__c = null, Inboard_Lite__c = null,
                    Panes__c = null, Laminate__c = null, IsActive = true, ProductCode = productCode, Family = 'View IGU', IGU_Overall_ThickNess__c = 1.000,
                    Bird_Friendly__c = 'No', Edge_Black__c = 'None', Inboard_Laminate_Specifications__c ='6MM CLR AN / 0.060 PVB / 6MM CLR T', SBQQ__IncludeInMaintenance__c = true,
                    Inboard_Treatment__c = 'T (Tempered)', Inboard_Thickness__c = '6 MM', Outboard_Lite__c = '6MM EC #2 CLR T', Outboard_Treatment__c = 'T (Tempered)', 
                    Pig_Tail__c = 'KEYED M8', Spacer__c = '1/2 90% Argon', Spacer_Fill__c = '90% Argon', Spacer_Thickness__c = '1/2" (12.7 mm.)', Spacer_Type__c = 'TRISEAL FOAM' );
        
        Product2 val2 = new Product2(Name = 'Product' + String.valueOf(1), Generation__c = productsample[0].Generation__c, Shape__c = productsample[0].Shape__c, Inboard_Lite__c = productsample[0].Inboard_Lite__c,
                    Panes__c = paneList[XMath.getRandomInt(1)], Laminate__c = productsample[0].Laminate__c, IsActive = true, ProductCode = productCode, Family = 'View IGU', IGU_Overall_ThickNess__c = 1.0000,
                    Bird_Friendly__c = 'No', Edge_Black__c = 'None', Inboard_Laminate_Specifications__c ='6MM CLR AN / 0.060 PVB / 6MM CLR T', SBQQ__IncludeInMaintenance__c = true,
                    Inboard_Treatment__c = 'T (Tempered)', Inboard_Thickness__c = '6 MM', Outboard_Lite__c = '6MM EC #2 CLR T', Outboard_Treatment__c = 'T (Tempered)', 
                    Pig_Tail__c = 'KEYED M8', Spacer__c = '1/2 90% Argon', Spacer_Fill__c = '90% Argon', Spacer_Thickness__c = '1/2" (12.7 mm.)', Spacer_Type__c = 'TRISEAL FOAM'); 
                    if (val2.panes__c == 'TRIPLE')
                    {
                        val2.Middle_Lite__c = 'CLEAR';
                        val2.Middle_Lite_Thickness__c = '6MM';
                        val2.Middle_Lite_Treatment__c = 'T (Tempered)';
                        val2.Secondary_Seal_Color__c = 'Black';
                        val2.Secondary_Seal_Type__c = 'SI';
                        val2.Spacer_2_Fill__c = '90% Argon';
                        val2.Spacer_2_Thickness__c = '1/2" (12.7 mm.)';
                    } 
          
         insert val2;
        
        try{            
            insert val1;            
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Invalid value for Generation; please re-enter or update SKU Prefix Element Map') ? true : false;
           // System.AssertEquals(expectedExceptionThrown, true);           
        } 
           
        try{
            
            val2.Family = 'IGU';
            update val2;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Generation is an IGU SKU key field and may not be updated') ? true : false;
          //  System.AssertEquals(expectedExceptionThrown, true);           
        } 
        try
        {
            update oer;
        }
        catch(Exception e)
        {
            System.debug('AssertEquals unable to update OER with count reference');
        }
        
        try
        {
            Order_Entry_Release__c oerd = oer;
            delete oerd;
            // please be cautious to update this line inorder to further reuse the oer as it was deleted.
        }
        catch(Exception e)
        {
            System.debug('AssertEquals unable to update OER with count reference');
        }
        //Test.stopTest();
    }
  
   static testMethod void Shipping1(){
        

        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();
        
        recordtype OERrecid = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Release__c' and DeveloperName =: Label.CSS_Hardware limit 1];
        recordtype OELrecid1 = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Line__c' and DeveloperName =: Label.CSS_Hardware limit 1];
       // recordtype recid = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Imperial'];
       // recordtype recid2 = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Metric'];

        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
     
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
       	testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Ops_Owner__c ='005E0000007tPIo';
        testMOUOpportunityObj.Regional_Vice_President__c = '005E0000007Nik3';
       
        insert testMOUOpportunityObj;
        
         
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Opportunity testOpportunityObj = new Opportunity();
        testOpportunityObj.Name = 'testOppty';
        testOpportunityObj.CloseDate = Date.today();
        testOpportunityObj.StageName = 'POC Stage';
        testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
        testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
        testOpportunityObj.Winning_Total_of_IGUs__c = 2;
        testOpportunityObj.IGU_Total_Amount__c = 10;
        testOpportunityObj.BOS_Total_Amount__c = 10;
        testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
        testOpportunityObj.Support_Region__c='Atlanta/Carolinas';
        testOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
       	testOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testOpportunityObj.Sales_Ops_Owner__c ='005E0000007tPIo';
        testOpportunityObj.Regional_Vice_President__c = '005E0000007Nik3';
        insert testOpportunityObj;      
        

        account acc = new account();
        acc.name = 'View Inc';
         acc.BillingStreet ='1482 Cliveden Ave.' ;
         acc.BillingCity ='Delta' ;
         acc.BillingState = 'British Columbia';
         acc.BillingPostalCode ='V3M 6K2' ;
        acc.BillingCountry = 'Canada';
        acc.Oracle_Customer_Number__c   ='3591';
        insert acc;

        contact con = new contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc.id;
        con.Email = 'test_view@testview.com';
        insert con;
        
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
  List<Product2> productsample = NEW List<Product2>();
     Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //testProductObj.Family  = 'BOS';
        testProductObj.Family  = 'CSS';
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
        insert testProductObj;
    productsample.add(testProductObj);
        RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];
     SBQQ__Quote__c quote=new SBQQ__Quote__c();
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId=qrt.id;
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = con.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
    	quote.Related_Opportunity__c = testOpportunityObj.Id;
        insert quote;
        system.debug('^^^^^^^^^^'+quote.id);
         List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>();  
        system.debug('%%%%quote%%%%'+quote+quote.Total_IGU_s_QL__c+'999999999'+quote.BOS_Total_Sq_Ft__c);
        SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //qtline.Product_Family_CPQ__c = 'BOS';
        qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
    qtLine.SBQQ__Product__c = testProductObj.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
       insert qtLine;
     qliList.add(qtLine);
     Test.stopTest();
        Order_Entry_Release__c oer = new Order_Entry_Release__c(Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id ,Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.', 
                            Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6', recordtypeid = OERrecid.id,
                            Shipping_State_Province__c = 'BC', Shipping_Country__c = 'CANADA',Opportunity__c=testOpportunityObj.id,Release_Name__c='test');
        try{
      insert oer;
      }catch(exception e){}
             
        Integer oelQuantity=5;
            String oelShape;
            String oelBase;
            String oelHeight;
            String oelBaseHeight;
        
        Order_Entry_Line__c test22 = new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase, Height_In__c = oelHeight,
                            Base_Height_1_In__c = oelBaseHeight, Shape__c = oelShape, recordtypeid = OELrecid1.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = oer.Shipping_Name__c, Shipping_Street_1__c = oer.Shipping_Street_1__c, 
                            Shipping_Account__c = oer.Shipping_Account__c, Shipping_City__c = oer.Shipping_City__c, Shipping_Postal_Code__c = oer.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = oer.Shipping_State_Province__c, Shipping_Country__c = oer.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1);
        
        
        try{            
             insert test22;           
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Base (in.) may not be null') ? true : false;
           // System.AssertEquals(expectedExceptionThrown, true);
            
        }   
        
        PageReference pgref1 = Page.UpdateOrderEntryLine;
        Test.setCurrentPage(pgref1);
       // pgref.getParameters().put('RecordType', String.valueOf(recid.ID));
      // try{
        ApexPages.StandardController sc1 = new ApexPages.standardController(test22);
        OrderEntryLineUpdateExt ss1 = new OrderEntryLineUpdateExt(sc1);
       // System.assert(ss1 != null);
        Pagereference pdd2 = ss1.updateShippingInfo();
    //  }catch(exception e){}
  }
  
   static testMethod void Shipping2(){
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 3,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 2,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();
        recordtype OERrecid = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Release__c' and DeveloperName =: Label.CSS_Hardware limit 1];
        recordtype OELrecid1 = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Line__c' and DeveloperName =: Label.CSS_Hardware limit 1];
        //recordtype recid = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Imperial'];
        //recordtype recid2 = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Metric'];

        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;      
        insert testMOUOpportunityObj;
         
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Opportunity testOpportunityObj = new Opportunity();
        testOpportunityObj.Name = 'testOppty';
        testOpportunityObj.CloseDate = Date.today();
        testOpportunityObj.StageName = 'POC Stage';
        testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
        testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
        testOpportunityObj.Winning_Total_of_IGUs__c = 2;
        testOpportunityObj.IGU_Total_Amount__c = 10;
        testOpportunityObj.BOS_Total_Amount__c = 10;
        testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
        testOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
        insert testOpportunityObj;

        account acc = new account();
        acc.name = 'View Inc';
         acc.BillingStreet ='1482 Cliveden Ave.' ;
         acc.BillingCity ='Delta' ;
         acc.BillingState = 'British Columbia';
         acc.BillingPostalCode ='V3M 6K2' ;
        acc.BillingCountry = 'Canada';
        acc.Oracle_Customer_Number__c   ='3591';
        insert acc;

        contact con = new contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc.id;
        con.Email = 'test_view@testview.com';
        insert con;
        
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
        List<Product2> productsample = NEW List<Product2>();
        Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //testProductObj.Family  = 'BOS';
        testProductObj.Family  = 'CSS';
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
        insert testProductObj;
    productsample.add(testProductObj);
        RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Bid_Quote_Locked_Record_Type' LIMIT 1];
     SBQQ__Quote__c quote=new SBQQ__Quote__c();
     
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId=qrt.id;
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.Deal_Desk_Analyst__c='0050L0000096RtS';
       // quote.Regional_Director2__c='0050L0000096RtS';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = con.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
    quote.Related_Opportunity__c = testOpportunityObj.Id;
        insert quote;
        system.debug('^^^^^^^^^^'+quote.id);
         List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>();  
        system.debug('%%%%quote%%%%'+quote+quote.Total_IGU_s_QL__c+'999999999'+quote.BOS_Total_Sq_Ft__c);
        SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //qtline.Product_Family_CPQ__c = 'BOS';
        qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
    qtLine.SBQQ__Product__c = testProductObj.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
       insert qtLine;
     qliList.add(qtLine);
     Test.stopTest();
        Order_Entry_Release__c oer = new Order_Entry_Release__c(Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id , Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.', 
                            Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6',recordtypeID = OERrecid.id,
                            Shipping_State_Province__c = 'BC', Shipping_Country__c = 'CANADA',Opportunity__c=testOpportunityObj.id,Release_Name__c='test');
        try{
      insert oer;
      }catch(exception e){}
        
        
        Integer oelQuantity=5;
            String oelShape;
            String oelBase;
            String oelHeight;
            String oelBaseHeight;

     
       
        Order_Entry_Line__c test4 = new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase,Base_mm__c = null,Height_In__c = oelHeight, Height_mm__c = null,
                            Base_Height_1_In__c = oelBaseHeight, Base_Height_1_mm__c = null, Shape__c = 'Trapezoid', recordtypeID = OELrecid1.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)),Shipping_Country__c = oer.Shipping_Country__c,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1, Base_Decimal_In__c= 140.0,Height_Decimal_In__c = 135.0);
        
         try{
            
            insert test4;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Quantity must be > 0') ? true : false;
           // System.AssertEquals(expectedExceptionThrown, true);
            
        } 
    //    try{        
        ApexPages.StandardController sc2 = new ApexPages.standardController(test4);
        OrderEntryLineUpdateExt ss2 = new OrderEntryLineUpdateExt(sc2);
       // System.assert(ss2 != null);
        Pagereference pdd3 = ss2.updateShippingInfo();
    //   }catch(exception e){} 
  }
  
   static testMethod void abc1(){
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 3,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 2,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();
        recordtype recid = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Imperial'];
             recordtype recid2 = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Metric'];

        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
       	testMOUOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testMOUOpportunityObj.Sales_Ops_Owner__c ='005E0000007tPIo';
        testMOUOpportunityObj.Regional_Vice_President__c = '005E0000007Nik3';
        insert testMOUOpportunityObj;
         
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Opportunity testOpportunityObj = new Opportunity();
        testOpportunityObj.Name = 'testOppty';
        testOpportunityObj.CloseDate = Date.today();
        testOpportunityObj.StageName = 'POC Stage';
        testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
        testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
        testOpportunityObj.Winning_Total_of_IGUs__c = 2;
        testOpportunityObj.IGU_Total_Amount__c = 10;
        testOpportunityObj.BOS_Total_Amount__c = 10;
        testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
        testOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
        testOpportunityObj.Sales_Director__c =UserInfo.getUserId();
        testOpportunityObj.Sales_Ops_Owner__c ='005E0000007tPIo';
        testOpportunityObj.Regional_Vice_President__c = '005E0000007Nik3';
        insert testOpportunityObj;

        account acc = new account();
        acc.name = 'View Inc';
         acc.BillingStreet ='1482 Cliveden Ave.' ;
         acc.BillingCity ='Delta' ;
         acc.BillingState = 'British Columbia';
         acc.BillingPostalCode ='V3M 6K2' ;
        acc.BillingCountry = 'Canada';
        acc.Oracle_Customer_Number__c   ='3591';
        insert acc;

        contact con = new contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc.id;
        con.Email = 'test_view@testview.com';
        insert con;
        
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
        List<Product2> productsample = NEW List<Product2>();
        Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //testProductObj.Family  = 'BOS';
        testProductObj.Family  = 'CSS';
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
        insert testProductObj;
    productsample.add(testProductObj);
        RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Bid_Quote_Locked_Record_Type' LIMIT 1];
     SBQQ__Quote__c quote=new SBQQ__Quote__c();
     
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId=qrt.id;
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.Deal_Desk_Analyst__c='0050L0000096RtS';
       // quote.Regional_Director2__c='0050L0000096RtS';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = con.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
    	quote.Related_Opportunity__c = testOpportunityObj.Id;
        insert quote;
        system.debug('^^^^^^^^^^'+quote.id);
         List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>();  
        system.debug('%%%%quote%%%%'+quote+quote.Total_IGU_s_QL__c+'999999999'+quote.BOS_Total_Sq_Ft__c);
        SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //qtline.Product_Family_CPQ__c = 'BOS';
        qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
    qtLine.SBQQ__Product__c = testProductObj.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
       insert qtLine;
     qliList.add(qtLine);
     Test.stopTest();
        Order_Entry_Release__c oer = new Order_Entry_Release__c(Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id , Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.', 
                            Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6',
                            Shipping_State_Province__c = 'BC', Shipping_Country__c = 'CANADA',Opportunity__c=testOpportunityObj.id,Release_Name__c='test');
        try{
      insert oer;
      }catch(exception e){}
        
        
        Integer oelQuantity;
            String oelShape;
            String oelBase;
            String oelHeight;
            String oelBaseHeight;

        
        ///////////////////////////////////////////////////////////////////////////////////////
      //  List<Product2> testcont = oetd.prodList;
       // System.assert(oetd.prodList.size() > 0);
        
        String aa = Order_Entry_Trigger_Helper_2.addChangeType('abcd','abc');
        //System.assertEquals('abc;abcd', aa);
        String bb = Order_Entry_Trigger_Helper_2.addChangeType('abc','abcd');
        //System.assertEquals('abcd', bb);
        String cc = Order_Entry_Trigger_Helper_2.addChangeType('abcd',null);
       // System.assertEquals('abcd;', cc);
        
        //Map<String, RecordType> ab = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap('Opportunity');
        
        Map<String, RecordType> ab = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap('MOU Single Project Opportunity'); 
        //System.assert(ab.size() > 0);
               
       // Map<ID, RecordType> bc = Order_Entry_Trigger_Helper_2.getRecordTypeMap('Opportunity');
        Map<ID, RecordType> bc = Order_Entry_Trigger_Helper_2.getRecordTypeMap('MOU Single Project Opportunity');
        Map<String, RecordType> te = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap(bc);
        //System.assert(te.size() > 0);
       
        Order_Entry_Line__c test4 = new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase,Base_mm__c = null,Height_In__c = oelHeight, Height_mm__c = null,
                            Base_Height_1_In__c = oelBaseHeight, Base_Height_1_mm__c = null, Shape__c = 'Trapezoid', recordtypeID = recid.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)),Shipping_Country__c = oer.Shipping_Country__c,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1, Base_Decimal_In__c= 140.0,Height_Decimal_In__c = 135.0);
        
         try{
            
            insert test4;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Quantity must be > 0') ? true : false;
           // System.AssertEquals(expectedExceptionThrown, true);
            
        } 
      //  try{        
        ApexPages.StandardController sc2 = new ApexPages.standardController(test4);
     //   OrderEntryLineUpdateExt ss2 = new OrderEntryLineUpdateExt(sc2);
       // System.assert(ss2 != null);
    //    Pagereference pdd3 = ss2.updateShippingInfo();
   //    }catch(exception e){} 
       
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        //CreateProductSKU
        Map <String, Map<String,String>> skuPrefixMaps = new Map<String, Map<String,String>> 
        {
            'Laminate' => new Map<String,String> {'NO' => '0', '.060 PVB' => '1', '.090 SGP' => '1', '.030 PVB' => '1', '.090 PVB' => '1', '.060 SGP' => '1', '.180 SGP' => '1'},
            'Generation' => new Map<String,String> {'1' => '1', '2' => '2', '3' => '3'}, 
            'Color' => new Map<String,String> {'CLR (CLEAR)' => '1', 'CLEAR' => '1', 'SBL (SOLAR BLUE)' => '2', 'SOLAR BLUE' => '2', 'AZU (AZURIA)' => '3', 'AZURIA' => '3', 
                'PAC (PACIFICA)' => '4', 'PACIFIC BLUE' => '4', 'SGY (SOLAR GRAY)' => '6', 'SOLAR GRAY' => '6', 'CGY (CRYSTAL GRAY)' => '7', 'CRYSTAL GRAY' => '7', 
                'LOW-E SN68' => '8', 'LOW-E I89' => '9', 'IS20' => 'A', 'LOW IRON SAPPHIRE' => 'B'}, 
            'Panes' => new Map<String,String> {'DOUBLE' => '2', 'TRIPLE' => '3'}, 
            'Shape' => new Map<String,String> {'RECTANGLE' => '1', 'SHAPE' => '2'}
        };
        List<String> paneList = new List<String>(skuPrefixMaps.get('Panes').keySet());
        String productCode = '9' + String.valueOf(XMath.getRandomInt(100)) + '-' + String.valueOf(XMath.getRandomInt(100000));
        
        //
        // 20180604 - JV Added fields to the new product creation to include fields required by Validation Rules.
        //
        Product2 val1 = new Product2(Name = 'Product' + String.valueOf(1), Generation__c = null, Shape__c = null, Inboard_Lite__c = null,
                    Panes__c = null, Laminate__c = null, IsActive = true, ProductCode = productCode, Family = 'View IGU', IGU_Overall_ThickNess__c = 1.000,
                    Bird_Friendly__c = 'No', Edge_Black__c = 'None', Inboard_Laminate_Specifications__c ='6MM CLR AN / 0.060 PVB / 6MM CLR T', SBQQ__IncludeInMaintenance__c = true,
                    Inboard_Treatment__c = 'T (Tempered)', Inboard_Thickness__c = '6 MM', Outboard_Lite__c = '6MM EC #2 CLR T', Outboard_Treatment__c = 'T (Tempered)', 
                    Pig_Tail__c = 'KEYED M8', Spacer__c = '1/2 90% Argon', Spacer_Fill__c = '90% Argon', Spacer_Thickness__c = '1/2" (12.7 mm.)', Spacer_Type__c = 'TRISEAL FOAM' );
        
        Product2 val2 = new Product2(Name = 'Product' + String.valueOf(1), Generation__c = productsample[0].Generation__c, Shape__c = productsample[0].Shape__c, Inboard_Lite__c = productsample[0].Inboard_Lite__c,
                    Panes__c = paneList[XMath.getRandomInt(1)], Laminate__c = productsample[0].Laminate__c, IsActive = true, ProductCode = productCode, Family = 'View IGU', IGU_Overall_ThickNess__c = 1.0000,
                    Bird_Friendly__c = 'No', Edge_Black__c = 'None', Inboard_Laminate_Specifications__c ='6MM CLR AN / 0.060 PVB / 6MM CLR T', SBQQ__IncludeInMaintenance__c = true,
                    Inboard_Treatment__c = 'T (Tempered)', Inboard_Thickness__c = '6 MM', Outboard_Lite__c = '6MM EC #2 CLR T', Outboard_Treatment__c = 'T (Tempered)', 
                    Pig_Tail__c = 'KEYED M8', Spacer__c = '1/2 90% Argon', Spacer_Fill__c = '90% Argon', Spacer_Thickness__c = '1/2" (12.7 mm.)', Spacer_Type__c = 'TRISEAL FOAM'); 
                    if (val2.panes__c == 'TRIPLE')
                    {
                        val2.Middle_Lite__c = 'CLEAR';
                        val2.Middle_Lite_Thickness__c = '6MM';
                        val2.Middle_Lite_Treatment__c = 'T (Tempered)';
                        val2.Secondary_Seal_Color__c = 'Black';
                        val2.Secondary_Seal_Type__c = 'SI';
                        val2.Spacer_2_Fill__c = '90% Argon';
                        val2.Spacer_2_Thickness__c = '1/2" (12.7 mm.)';
                    } 
            
         insert val2;
        
        try{            
            insert val1;            
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Invalid value for Generation; please re-enter or update SKU Prefix Element Map') ? true : false;
           // System.AssertEquals(expectedExceptionThrown, true);           
        } 
           
        try{
            
            val2.Family = 'IGU';
            update val2;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Generation is an IGU SKU key field and may not be updated') ? true : false;
          //  System.AssertEquals(expectedExceptionThrown, true);           
        } 
        try
        {
            update oer;
        }
        catch(Exception e)
        {
            System.debug('AssertEquals unable to update OER with count reference');
        }
        
        try
        {
            Order_Entry_Release__c oerd = oer;
            delete oerd;
            // please be cautious to update this line inorder to further reuse the oer as it was deleted.
        }
        catch(Exception e)
        {
            System.debug('AssertEquals unable to update OER with count reference');
        }
        //Test.stopTest();
    }
     
     //OrderEntryLineUpdateExt.getHeaderStatusList();
     static testMethod void abc3(){
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 3,      
            'OpptyAccts' => 2, 'BillToAccts' => 2, 'ShipToAccts' => 3, 'SoldToAccts' => 2, 'ContactsPerAcct' => 2, 'OpptysPerOpptyAcct' => 2,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();
        recordtype OERrecid = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Release__c' and DeveloperName =: Label.CSS_Hardware limit 1];
        recordtype OELrecid1 = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Line__c' and DeveloperName =: Label.CSS_Hardware limit 1];
        //recordtype recordid = [select id,name,DeveloperName from recordtype where DeveloperName = Label.CSS_Hardware limit 1];
        //recordtype recid2 = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Metric'];

        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;      
        insert testMOUOpportunityObj;
         
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Opportunity testOpportunityObj = new Opportunity();
        testOpportunityObj.Name = 'testOppty';
        testOpportunityObj.CloseDate = Date.today();
        testOpportunityObj.StageName = 'POC Stage';
        testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
        testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
        testOpportunityObj.Winning_Total_of_IGUs__c = 2;
        testOpportunityObj.IGU_Total_Amount__c = 10;
        testOpportunityObj.BOS_Total_Amount__c = 10;
        testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
        testOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
        insert testOpportunityObj;

        account acc = new account();
        acc.name = 'View Inc';
         acc.ShippingStreet ='1482 Cliveden Ave.' ;
         acc.ShippingCity ='Delta' ;
        acc.Oracle_Customer_Number__c   ='3591';
        insert acc;

        contact con = new contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc.id;
        con.Email = 'test_view@testview.com';
        insert con;
        
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
        List<Product2> productsample = NEW List<Product2>();
        Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //testProductObj.Family  = 'BOS';
        testProductObj.Family  = 'CSS';
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
        insert testProductObj;
    productsample.add(testProductObj);
        RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Bid_Quote_Locked_Record_Type' LIMIT 1];
     SBQQ__Quote__c quote=new SBQQ__Quote__c();
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId=qrt.id;
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = con.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
    quote.Related_Opportunity__c = testOpportunityObj.Id;
        insert quote;
        system.debug('^^^^^^^^^^'+quote.id);
         List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>();  
        system.debug('%%%%quote%%%%'+quote+quote.Total_IGU_s_QL__c+'999999999'+quote.BOS_Total_Sq_Ft__c);
        SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //qtline.Product_Family_CPQ__c = 'BOS';
        qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
    qtLine.SBQQ__Product__c = testProductObj.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
       insert qtLine;
     qliList.add(qtLine);
     Test.stopTest();
        Order_Entry_Release__c oer = new Order_Entry_Release__c(Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id , Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.', 
                            Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6', recordtypeID = OERrecid.id,
                            Shipping_State_Province__c = 'BC', Shipping_Country__c = 'CANADA',Opportunity__c=testOpportunityObj.id,Release_Name__c='test');
        try{
      insert oer;
      }catch(exception e){}
        
        
        Integer oelQuantity = 5;
            String oelShape;
            String oelBase;
            String oelHeight;
            String oelBaseHeight;

       
        Order_Entry_Line__c test4 = new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase,Base_mm__c = null,Height_In__c = oelHeight, Height_mm__c = null,
                            Base_Height_1_In__c = oelBaseHeight, Base_Height_1_mm__c = null, Shape__c = 'Trapezoid', recordtypeID = OELrecid1.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)),Shipping_Country__c = oer.Shipping_Country__c,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1, Base_Decimal_In__c= 140.0,Height_Decimal_In__c = 135.0);
        
         try{
            
            insert test4;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Quantity must be > 0') ? true : false;
           // System.AssertEquals(expectedExceptionThrown, true);
            
        }    
      //  try{     
        ApexPages.StandardController sc2 = new ApexPages.standardController(test4);
        OrderEntryLineUpdateExt ss2 = new OrderEntryLineUpdateExt(sc2);
        ss2.getHeaderStatusList();
     //   }catch(exception e){}
 }
    
    //Added by ENP - Start - Sajid
    //Order_Entry_Trigger_Helper_2.validateDimensions(oelWrap);
    static testMethod void testMethod_OEL_ValidationRectangle()
    {
        
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        Test.startTest();
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Test.stopTest();
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        Order_Entry_Line__c testOEL;
        Boolean passedTest;
 
        
        testRel = oerList[0];
        
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
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Height_mm__c, Height_In__c,Height_Decimal_in__c, Base_Height_1_In__c,Base_In__c,Base_Decimal_in__c,Base_mm__c, Shape__c,
                  Envelope_Area_Sq_Ft__c,Unit_Area_Sq_m__c, Line_Number__c,Unit_Area_Sq_Ft__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id LIMIT 1];
       
        testOEL.Base_mm__c=1.00;
        testOEL.Height_mm__c=1.00;
        update testOEL;
        
        OrderEntryLineWrapper oelWrap = new OrderEntryLineWrapper(testOEL,1,Label.CSS_Hardware);
        Boolean vari = Order_Entry_Trigger_Helper_2.validateDimensions(oelWrap);
        //Order_Entry_Trigger_Helper_2.validateReleaseInsert();
          
                
    }
    //Added by ENP _ END
    
    //Added by ENP - Start - Sajid
    static testMethod void testMethod_OEL_ValidationTrapezoid()
    {
        //creating master data
        test.startTest();
        Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Opportunity testOpportunityObj = new Opportunity();
        testOpportunityObj.Name = 'testOppty';
        testOpportunityObj.CloseDate = Date.today();
        testOpportunityObj.StageName = 'POC Stage';
        testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
        testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
        testOpportunityObj.Winning_Total_of_IGUs__c = 2;
        testOpportunityObj.IGU_Total_Amount__c = 10;
        testOpportunityObj.BOS_Total_Amount__c = 10;
        //testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
        testOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
        insert testOpportunityObj;

        account acc = new account();
        acc.name = 'View Inc';
         acc.ShippingStreet ='1482 Cliveden Ave.' ;
         acc.ShippingCity ='Delta' ;
        acc.Oracle_Customer_Number__c   ='3591';
        insert acc;

        contact con = new contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc.id;
        con.Email = 'test_view@testview.com';
        insert con;
        /********************************************************************
         * ***********************************************************************/
        List<SKU_Prefix_Element_Map__c> spemList = new List<SKU_Prefix_Element_Map__c>();
        List<SKU_Prefix_Element_Map_Entry__c> spemeList = new List<SKU_Prefix_Element_Map_Entry__c>();
        Map<String,String> spemeMap = new Map<String, String>();
        
        // Create the SKU Prefix Element Map
        Map <String, Map<String,String>> skuPrefixMaps = new Map<String, Map<String,String>> 
        {
            'Laminate' => new Map<String,String> {'NO' => '0', '.060 PVB' => '1', '.090 SGP' => '1', '.030 PVB' => '1', '.090 PVB' => '1', '.060 SGP' => '1', '.180 SGP' => '1'},
            'Generation' => new Map<String,String> {'1' => '1', '2' => '2', '3' => '3'}, 
            'Color' => new Map<String,String> {'CLR (CLEAR)' => '1', 'AZU (AZURIA)' => '3', 
                'PAC (PACIFICA)' => '4', 'SBL (SOLAR BLUE)' => '2', 'SGY (SOLAR GRAY)' => '6', 'CGY (CRYSTAL GRAY)' => '7', 
                'LOW-E SN68' => '8', 'LOW-E I89' => '9',  'LOW-E SN78-65' => 'A'}, 
            'Panes' => new Map<String,String> {'DOUBLE' => '2', 'TRIPLE' => '3'}, 
            'Shape' => new Map<String,String> {'RECTANGLE' => '1', 'SHAPE' => '2'}
        };
         
        for (String spm : skuPrefixMaps.KeySet())
        { 
            spemList.add(new SKU_Prefix_Element_Map__c(Name = spm));
        }
        insert spemList;
        
        for (SKU_Prefix_Element_Map__c spem : spemList)
        {
            spemeMap = skuPrefixMaps.get(spem.Name);
            for (String fromValue : spemeMap.keySet())
            {
                spemeList.add(new SKU_Prefix_Element_Map_Entry__c(SKU_Prefix_Element_Map__c = spem.Id, Name = fromValue, Map_to_Value__c = spemeMap.get(fromValue)));
            }
        }
        insert spemeList;
        Product2 newProduct;
            
            List<String> genList = new List<String>(skuPrefixMaps.get('Generation').keySet());
            List<String> shapeList = new List<String>(skuPrefixMaps.get('Shape').keySet());
            List<String> paneList = new List<String>(skuPrefixMaps.get('Panes').keySet());
            List<String> colorList = new List<String>(skuPrefixMaps.get('Color').keySet());
            List<String> lamiList = new List<String>(skuPrefixMaps.get('Laminate').keySet());
            Integer genListSize = genList.size();
            Integer shapeListSize = shapeList.size();
            Integer paneListSize = paneList.size();
            Integer colorListSize = colorList.size();
            Integer lamiListSize = lamiList.size();
            String productCode;
            String generation;          
            String shape;
            String panes;
            String color;
            String lamination;

                           
                generation = genList[XMath.getRandomInt(genListSize)];
                panes = paneList[XMath.getRandomInt(paneListSize)];
                color = colorList[XMath.getRandomInt(colorListSize)];
                lamination = lamiList[XMath.getRandomInt(lamiListSize)];
                shape = shapeList[XMath.getRandomInt(shapeListSize)];
                productCode = '9' + String.valueOf(XMath.getRandomInt(100)) + '-' + String.valueOf(XMath.getRandomInt(100000));
                
                
                newProduct = new Product2(Name = 'myProduct-XXX', Generation__c = generation, Shape__c = shape, Inboard_Lite__c = color,
                    Panes__c = panes, Laminate__c = lamination, IsActive = true, ProductCode = productCode, Family = 'IGU', IGU_Overall_ThickNess__c = 1.0000,
                    Bird_Friendly__c = 'No', Edge_Black__c = 'None', Inboard_Laminate_Specifications__c ='6MM CLR AN / 0.060 PVB / 6MM CLR T', SBQQ__IncludeInMaintenance__c = true,
                    Inboard_Treatment__c = 'T (Tempered)', Inboard_Thickness__c = '6 MM', Outboard_Lite__c = '6MM EC #2 CLR T', Outboard_Treatment__c = 'T (Tempered)', 
                    Pig_Tail__c = 'KEYED M8', Spacer__c = '1/2 90% Argon', Spacer_Fill__c = '90% Argon', Spacer_Thickness__c = '1/2" (12.7 mm.)', Spacer_Type__c = 'TRISEAL FOAM',
                    Secondary_Seal_Color__c = 'Black', Secondary_Seal_Type__c = 'SI' ); 
                if (panes == 'TRIPLE')
                {
                    newProduct.Middle_Lite__c = 'CLEAR';
                    newProduct.Middle_Lite_Thickness__c = '6MM';
                    newProduct.Middle_Lite_Treatment__c = 'T (Tempered)';
                    newProduct.Spacer_2_Fill__c = '90% Argon';
                    newProduct.Spacer_2_Thickness__c = '1/2" (12.7 mm.)';
                } 
                
            
            insert newProduct;
            
        
        
        
        
        
        
/*        
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
        List<Product2> productsample = NEW List<Product2>();
        Product2 testProductObj = new Product2();
        testProductObj.Name = 'Test Product';
        testProductObj.Family  = 'BOS';
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
        insert testProductObj;
    productsample.add(testProductObj); */
        
        RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Bid_Quote_Locked_Record_Type' LIMIT 1];
     SBQQ__Quote__c quote=new SBQQ__Quote__c();
        quote.Quote_Approval_Type__c = 'Pricing Approval'; 
        quote.First_Ship_Date__c = system.today();
        quote.Detailed_Summary_of_Deal__c = 'test';
        quote.RecordTypeId=qrt.id;
        quote.Are_you_using_Plenum__c='No';
        quote.Quote_Plan__c='All In';
       // quote.SBQQ__SalesRep__c='0050L0000096RtS';
        quote.SBQQ__Account__c = acc.id;
        quote.SBQQ__PrimaryContact__c = con.Id;
        quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
    quote.Related_Opportunity__c = testOpportunityObj.Id;
        insert quote;
        system.debug('^^^^^^^^^^'+quote.id);
         List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>();  
        system.debug('%%%%quote%%%%'+quote+quote.Total_IGU_s_QL__c+'999999999'+quote.BOS_Total_Sq_Ft__c);
        SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
        //****COMMENTING THIS AS PART OF BOS REFERENCE UPDATES WITH CSS
        //qtline.Product_Family_CPQ__c = 'BOS';
        qtline.Product_Family_CPQ__c = 'CSS';
        qtline.BOS_Non_Operable__c = True;
        qtLine.SBQQ__Quote__c=quote.Id;
    qtLine.SBQQ__Product__c = newProduct.Id;
        qtLine.No_of_IGU_s__c = 3000;
        qtLine.SBQQ__Quantity__c = 20000;
       insert qtLine;
     qliList.add(qtLine);
     
        //
        
        Id rid=[select id from recordtype where DeveloperName =: Label.CSS_Hardware and SobjectType ='Order_Entry_Line__c'].id;
        Id oerTyId=[select id from recordtype where DeveloperName =: Label.CSS_Hardware and SobjectType ='Order_Entry_Release__c'].id;
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
        //OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        //List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Order_Entry_Release__c testRel = new Order_Entry_Release__c(Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id ,Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.', 
                            Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6',recordtypeid=oerTyId,
                            Shipping_State_Province__c = 'BC', Shipping_Country__c = 'CANADA',Opportunity__c=testOpportunityObj.id,Release_Name__c='test');
        insert testRel;     
        test.stopTest();
        
        Boolean passedTest;
 
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
        Order_Entry_Line__c testOEL = new Order_Entry_Line__c(Order_Entry_Release__c = testRel.Id, Quantity__c = 1, //Base_In__c = 1.00,Base_mm__c = 1.00,Height_In__c = oelHeight, 
                                                              Height_mm__c = 1.50,Base_mm__c = 1.00,
                            //Base_Height_1_In__c = 1.10, 
                                                              Base_Height_1_mm__c = 1.10, Shape__c = 'Trapezoid - 302', recordtypeID = rid, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)),Shipping_Country__c = testRel.Shipping_Country__c,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1
                                                             // , Base_Decimal_In__c= 140.0,Height_Decimal_In__c = 135.0
                                                             );
       
       
        insert testOEL;
        
        OrderEntryLineWrapper oelWrap = new OrderEntryLineWrapper(testOEL,1,Label.CSS_Hardware);
        Boolean vari = Order_Entry_Trigger_Helper_2.validateDimensions(oelWrap);
        //Order_Entry_Trigger_Helper_2.validateReleaseInsert();
          
                
    }
    //Added by ENP _ END
    
    
}