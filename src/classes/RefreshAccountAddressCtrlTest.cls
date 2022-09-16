// 06-Jan-2021			Srikanth		DealDesk SOP Findinds DD_SOP_Findings_Jan_2021			DealDesk SOP Findings
@istest
public class RefreshAccountAddressCtrlTest {
    static testMethod void TestMethod1(){
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
                Test.startTest();
        
        //IGU_Imperial
        recordtype OERrecid = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Release__c' and DeveloperName =: Label.CSS_Hardware limit 1];
        recordtype OELrecid1 = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Line__c' and DeveloperName =: Label.CSS_Hardware limit 1];
        recordtype OELrecid2 = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Metric' limit 1];
        
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
        testOpportunityObj.Support_Region__c='Atlanta/Carolinas';
        testOpportunityObj.Regional_Vice_President__c = '005E0000007Nik3';
        testOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
        insert testOpportunityObj;      
        
        
        account acc = new account();
        acc.name = 'View Inc';
        acc.BillingStreet ='1482 Cliveden Ave.' ;
        acc.BillingCity ='Delta' ;
        acc.BillingState = 'British Columbia';
        acc.BillingPostalCode ='V3M 6K2' ;
        acc.BillingCountry = 'Canada';
        acc.Shippingstreet  = 'sample street';
        acc.ShippingCity   = 'city';
        acc.ShippingCountry   = 'sample Country';
        acc.ShippingPostalCode   = '12345';
        acc.ShippingState   = 'USA';
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
        List<String> lstMapValue = new List<String>{'2', 'NO', 'CLR (CLEAR)', 'SHAPE','DOUBLE'};
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
        //*******COMMENTING THIS LINE AS PART OF BOS REFERENCE UPDATES WITH CSS
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
        //*******COMMENTING THIS LINE AS PART OF BOS REFERENCE UPDATES WITH CSS
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
                                                                Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6',recordtypeid = OERrecid.id,Scheduled_Ship_Date__c=system.today(),
                                                                Shipping_State_Province__c = 'BC', CPQ_Quote__c = quote.id, Shipping_Country__c = 'CANADA',Opportunity__c=testOpportunityObj.id,Release_Name__c='test');
        //     try{
        insert oer;
        
        string verifyOERStatus = RefreshAccountAddressCtrl.verifyOERStatus(oer.id, True, True);
        string  returnResult = RefreshAccountAddressCtrl.updateAccount(oer.id, True, True);  
        
        //    }catch(exception e){}
        
        Integer oelQuantity = 5;
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
            Case caseRec=[select id,opportunity__c from Case limit 1];
            caseRec.opportunity__c =testOpportunityObj.id;
            caseRec.AccountId= acc.id;
            update caseRec; 
        } catch(Exception e)
        {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('Base (in.) may not be null') ? true : false;
            // System.AssertEquals(expectedExceptionThrown, true);  
        } 
    }
}