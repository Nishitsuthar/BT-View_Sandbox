@isTest
public class Order_Entry_Line_BU_AU_test2
{
 @testSetup static void setup() { 
 
  Id dealDeskProfileId =[SELECT Id, Name from Profile WHERE Name = 'Deal Desk' LIMIT 1 ].Id;
        User dealDeskUser = new User(Alias = 'Userdels', Email='User.dealdesl@view.com', 
                    EmailEncodingKey='UTF-8', LastName='UserDealDesk', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = dealDeskProfileId, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
                    
        insert dealDeskUser;
     
        System.runAs ( dealDeskUser ) {

          Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
          Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
       
        Account acc = new Account();
                    acc.Name='test1';
                    acc.BillingCity='Livermore1';
                    acc.BillingCountry='USA';
                    acc.BillingPostalCode='945501';
                    acc.BillingState='CA';
                    acc.BillingStreet='6400 Brisa Street11';
                    acc.Oracle_Customer_Number__c ='1231';
                    acc.ShippingCity='Livermore1';
                    acc.ShippingCountry='USA';
                    acc.ShippingPostalCode='945510';
                    acc.ShippingState='CA';
                    acc.ShippingStreet='6400 Brisa Street1';
        insert acc;
           
         Account acc1 = new Account();
                    acc1.Name='test';
                    acc1.BillingCity='Livermore Test';
                    acc1.BillingCountry='USA';
                    acc1.BillingPostalCode='94555';
                    acc1.BillingState='NY';
                    acc1.BillingStreet='6122 Brisa Street';
                    acc1.Oracle_Customer_Number__c ='12323';
                    acc1.ShippingCity='Livermore tEST 1 ';
                    acc1.ShippingCountry='USA';
                    acc1.ShippingPostalCode='94555';
                    acc1.ShippingState='NY';
                    acc1.ShippingStreet='6400 Test Street';
        insert acc1;
        
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
        insert testMOUOpportunityObj;
            
             Product2 testProductObj = new Product2();
                    testProductObj.Name = 'Test Product';
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

            
            SBQQ__Quote__c quote=new SBQQ__Quote__c();
                    quote.Quote_Approval_Type__c = 'Pricing Approval'; 
                    quote.First_Ship_Date__c = system.today();
                    quote.Detailed_Summary_of_Deal__c = 'test';
                    quote.RecordTypeId= '0120h000000YOJuAAO';
                    quote.Are_you_using_Plenum__c='No';
                    quote.Quote_Plan__c='All In';
                    quote.SBQQ__Account__c = acc.id;
                    quote.SBQQ__PrimaryContact__c = c.Id;
                    quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
                    quote.Related_Opportunity__c = testMOUOpportunityObj.Id;
        insert quote;
            
     List<SBQQ__QuoteLine__c> lstQL = new List<SBQQ__QuoteLine__c>();
            SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
                    qtline.Product_Family_CPQ__c = 'CSS';
                    qtline.BOS_Non_Operable__c = True;
                    qtLine.SBQQ__Quote__c=quote.Id;
                    qtLine.SBQQ__Product__c = testProductObj.Id;
                    qtLine.No_of_IGU_s__c = 3000;
                    qtLine.SBQQ__Quantity__c = 20000;
                    qtLine.SBQQ__CustomerPrice__c=5.03;
            lstQL.add(qtLine);
                         SBQQ__QuoteLine__c qtLine1=new SBQQ__QuoteLine__c();
                         qtline1.Product_Family_CPQ__c = 'CSS';
                         qtline1.BOS_Non_Operable__c = True;
                         qtLine1.SBQQ__Quote__c=quote.Id;
                         qtLine1.SBQQ__Product__c = testProductObj.Id;
                         qtLine1.No_of_IGU_s__c = 3000;
                         qtLine1.SBQQ__Quantity__c = 20000;
                         qtLine1.SBQQ__CustomerPrice__c=5.03;
            lstQL.add(qtLine1);
       insert lstQL;
       /*     
            // CPQ Quote 2 
            
             SBQQ__Quote__c quote2=new SBQQ__Quote__c();
                        quote2.Quote_Approval_Type__c = 'Pricing Approval'; 
                        quote2.First_Ship_Date__c = system.today();
                        quote2.Detailed_Summary_of_Deal__c = 'test';
                        quote2.RecordTypeId= '0120h000000YOJuAAO';
                        quote2.Are_you_using_Plenum__c='No';
                        quote2.Quote_Plan__c='All In';
                        quote2.SBQQ__Account__c = acc.id;
                        quote2.SBQQ__PrimaryContact__c = c.Id;
                        quote2.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
                        quote2.Related_Opportunity__c = testMOUOpportunityObj.Id;
        insert quote2;
            
     List<SBQQ__QuoteLine__c> lstQL2 = new List<SBQQ__QuoteLine__c>();
            
            SBQQ__QuoteLine__c qtLine2=new SBQQ__QuoteLine__c();
                    qtLine2.Product_Family_CPQ__c = 'CSS';
                    qtLine2.BOS_Non_Operable__c = True;
                    qtLine2.SBQQ__Quote__c=quote.Id;
                    qtLine2.SBQQ__Product__c = testProductObj.Id;
                    qtLine2.No_of_IGU_s__c = 3000;
                    qtLine2.SBQQ__Quantity__c = 20000;
                    qtLine2.SBQQ__CustomerPrice__c=5.03;
            lstQL2.add(qtLine2);
                    SBQQ__QuoteLine__c qtLine11=new SBQQ__QuoteLine__c();
                   qtLine11.Product_Family_CPQ__c = 'CSS';
                  qtLine11.BOS_Non_Operable__c = True;
                  qtLine11.SBQQ__Quote__c=quote.Id;
                  qtLine11.SBQQ__Product__c = testProductObj.Id;
                  qtLine11.No_of_IGU_s__c = 3000;
                  qtLine11.SBQQ__Quantity__c = 20000;
                  qtLine11.SBQQ__CustomerPrice__c=5.03;
             lstQL2.add(qtLine11);
       insert lstQL2;

        */    
            
            
            // CHW Record Type
        recordtype OERrecid = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Release__c' and DeveloperName =: Label.CSS_Hardware limit 1];
        recordtype OELrecid1 = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Line__c' and DeveloperName =: Label.CSS_Hardware limit 1];
          
       
            // CHW Order Entry Release
            Order_Entry_Release__c od = new Order_Entry_Release__c( Status__c = 'Draft', Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id ,
                            Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.',Deposit_Amount__c=150, 
                            Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6',recordtypeid = OERrecid.id,Trigger_Source__c = 'UI',
                            Shipping_State_Province__c = 'BC', CPQ_Quote__c = quote.id, Shipping_Country__c = 'CANADA',Opportunity__c=testMOUOpportunityObj.id,Release_Name__c='test12311',
                            Scheduled_Ship_Date__c = System.today() + 20, Promised_Date__c = System.today() + 25,Request_Date__c = System.today() + 10,
                                                                  Freight__c ='Non-Billable' ,Payment_Terms__c = '1% 10, Net 30');
   

         
            insert od;
       // SKU Comment ***
            
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


        SBQQ__Quote__c sb1 = new SBQQ__Quote__c();
                    sb1.SBQQ__Status__c = 'Active';
                    sb1.Quote_Name__c='ss';
                    sb1.Quote_Approval_Type__c='Pricing Approval';
                    sb1.Are_you_using_Plenum__c='Yes';
                    sb1.Shipping_Included__c ='No';
                    sb1.Detailed_Summary_of_Deal__c='test';
                    sb1.SBQQ__Account__c=acc.id;
                    sb1.SBQQ__PrimaryContact__c=c.id;
   
          // CHW Order Entry Line
          Order_Entry_Line__c odl = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 10, Base_In__c = ' ', Height_In__c = ' ',currencyISOCode = 'USD' ,
                            Base_Height_1_In__c = ' ', Shape__c = ' ', recordtypeid = OELrecid1.id, Status__c = 'Draft',First_Request_Ship_Date__c = NULL, 
                            Integration_Status__c = 'Initial', Trigger_Source__c = '', CPQ_Quote_Line__c = lstQL[0].Id,Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1,Customer_Reference_Description__c = 'Test One',
                              Scheduled_Ship_Date__c = System.today() + 20, Promised_Date__c = System.today() + 25,Request_Date_Update_Needed__c = False,
                            Request_Date__c = System.today() + 10); 
        
            insert odl;
     
            Order_Entry_Line__c odl2 = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 5, Base_In__c = ' ', Height_In__c = ' ',
                            Base_Height_1_In__c = ' ', Shape__c = ' ', recordtypeid = OELrecid1.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1,
                              Scheduled_Ship_Date__c = System.today() + 20, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 10);
            insert odl2;
            
            
      //odl2.Request_Date__c = System.today() + 15;
            //odl2.Scheduled_Ship_Date__c = System.today() + 25;
            //update odl2;
            
            try{
                Test.StartTest();
                if(test.isRunningTest())
                {
                 Order_Entry_Line__c odl3 = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 5, Base_In__c = ' ', Height_In__c = ' ',
                            Base_Height_1_In__c = ' ', Shape__c = ' ', recordtypeid = OELrecid1.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1,
                              Scheduled_Ship_Date__c = System.today() + 25, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 20);
            insert odl3;
              odl3.Request_Date__c = System.today() + 25;
              odl3.Scheduled_Ship_Date__c = System.today() + 25;
              update odl3;
                
                Order_Entry_Line__c odl4 = new Order_Entry_Line__c(Order_Entry_Release__c = od.Id, Quantity__c = 5, Base_In__c = ' ', Height_In__c = ' ',
                            Base_Height_1_In__c = ' ', Shape__c = ' ', recordtypeid = OELrecid1.id, Status__c = 'Draft', 
                            Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qtLine.Id, Product__c = qtLine.SBQQ__Product__c, 
                            Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                            String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = od.Shipping_Name__c, Shipping_Street_1__c = od.Shipping_Street_1__c, 
                            Shipping_Account__c = od.Shipping_Account__c, Shipping_City__c = od.Shipping_City__c, Shipping_Postal_Code__c = od.Shipping_Postal_Code__c,
                            Shipping_State_Province__c = od.Shipping_State_Province__c, Shipping_Country__c = od.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                            Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1,
                              Scheduled_Ship_Date__c = System.today() + 25, Promised_Date__c = System.today() + 255,
                            Request_Date__c = System.today() + 20);
            insert odl4;
          
            odl4.Request_Date__c = System.today() + 25;
            odl4.Scheduled_Ship_Date__c = System.today() + 30;
            update odl4;
                
            }
                Test.StopTest();
                }
            catch(DmlException ex)
            {
                
            }
             
            
  
        }   
 }

static testmethod void methodOne()
{
    Test.startTest();  
    Order_Entry_Release__c mtQ1 =[SELECT Id,Status__c, Shipping_Account__c,Billing_Account__c ,Sold_to_Account__c ,Trigger_Source__c,Freight__c,Payment_Terms__c,CurrencyISOCode,
                                      Shipping_Name__c, Shipping_Street_1__c, Shipping_City__c , Shipping_Postal_Code__c ,recordtypeid ,Deposit_Amount__c,
                                  Shipping_State_Province__c, CPQ_Quote__c, Shipping_Country__c,Opportunity__c,Release_Name__c,Scheduled_Ship_Date__c, Promised_Date__c,
                                      Request_Date__c FROM Order_Entry_Release__c limit 1];
      
      Order_Entry_Line__c mtLine1 = [SELECT Id,Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c,currencyISOCode,First_Request_Ship_Date__c,
                            Base_Height_1_In__c, Shape__c , recordtypeid, Status__c,Request_Date_Update_Needed__c , 
                            Integration_Status__c, Trigger_Source__c , CPQ_Quote_Line__c,Quote_Line_Item__c , Product__c, 
                            Order_Line_Type__c, Mark_Ids__c, Shipping_Name__c , Shipping_Street_1__c, 
                            Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c,
                            Shipping_State_Province__c , Shipping_Country__c, Use_Account_Shipping_Address__c,
                            Installation_Type__c, Line_Number__c,Base_Decimal_In__c,Height_Decimal_In__c,
                              Scheduled_Ship_Date__c , Promised_Date__c,Customer_Reference_Description__c,
                            Request_Date__c FROM Order_Entry_Line__c LIMIT 1];
      List<Account> secondAcc = [Select id,billingStreet,billingcity,billingState,billingCountry FROM Account];
        
    
    List<SBQQ__QuoteLine__c> lstQL = [Select id,Product_Family_CPQ__c,BOS_Non_Operable__c,SBQQ__Quote__c,
                                      SBQQ__Product__c,No_of_IGU_s__c,SBQQ__Quantity__c,SBQQ__CustomerPrice__c FROM SBQQ__QuoteLine__c];
    
    //List<SBQQ__Quote__c> secQuote = [Select id from SBQQ__Quote__c LIMIT 1];
    //SBQQ__Quote__c secQuote = [Select id from SBQQ__Quote__c LIMIT 1];
      
        
        
        mtLine1.Request_Date__c = System.today() + 15;
                        mtLine1.Scheduled_Ship_Date__c = System.today() + 25;
                        mtLine1.CPQ_Quote_Line__c = lstQL[1].Id;
                        mtLine1.Request_Date_Update_Needed__c = True;
                        mtLine1.Customer_Reference_Description__c = 'Test 2update';
                        mtLine1.Quantity__c = 10;
                        mtQ1.Shipping_Street_1__c =  'Test from Tets method';
                        mtQ1.Billing_Account__c  = secondAcc[1].Id;
                        mtQ1.Shipping_Address__c = secondAcc[1].Id;
                        mtQ1.Sold_to_Account__c = secondAcc[1].Id;
                        mtQ1.Promised_Date__c = System.today() + 35; 
                        mtQ1.Scheduled_Ship_Date__c  = System.today() + 33;
                        mtQ1.Request_Date__c  = System.today() + 14;
                        mtQ1.Trigger_Source__c = 'UI';
                        //mtQ1.CPQ_Quote__c = quote.id;
        
        //mtQ1.Billing_City__c   = secondAcc[1].billingCity;
    
            update mtLine1;
    
            mtQ1.Status__c = 'Integration Requested';
        update mtQ1;
    
            mtLine1.Integration_Status__c = 'Complete';
                    mtLine1.Trigger_Source__c = 'Integration';
        update mtLine1;
    
            mtQ1.Integration_Status__c = 'Complete';
          mtQ1.Trigger_Source__c = 'Integration';
            //mtQ1.Status__c = 'Planned';
            mtQ1.Sales_Order_Status__c='Booked';
            mtQ1.Trigger_Source__c=null;
        update mtQ1;
            /*
            mtLine1.Request_Date__c = System.today() + 16;
            mtLine1.Scheduled_Ship_Date__c = System.today() + 20;
        update mtLine1;
    */
      Test.stopTest(); 
}
  
    static testmethod void methodTwo()
{
      Order_Entry_Release__c mtQ2 =[SELECT Id,Status__c, Shipping_Account__c,Billing_Account__c ,Sold_to_Account__c ,Trigger_Source__c,Freight__c,Payment_Terms__c,CurrencyISOCode,
                                      Shipping_Name__c, Shipping_Street_1__c, Shipping_City__c , Shipping_Postal_Code__c ,recordtypeid ,Deposit_Amount__c,
                                  Shipping_State_Province__c, CPQ_Quote__c, Shipping_Country__c,Opportunity__c,Release_Name__c,Scheduled_Ship_Date__c, Promised_Date__c,
                                      Request_Date__c FROM Order_Entry_Release__c limit 1];
    List<Order_Entry_Line__c> mtLine2 = [SELECT Id,Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c,currencyISOCode,First_Request_Ship_Date__c,
                            Base_Height_1_In__c, Shape__c , recordtypeid, Status__c , 
                            Integration_Status__c, Trigger_Source__c , CPQ_Quote_Line__c,Quote_Line_Item__c , Product__c,Request_Date_Update_Needed__c, 
                            Order_Line_Type__c, Mark_Ids__c, Shipping_Name__c , Shipping_Street_1__c, 
                            Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c,
                            Shipping_State_Province__c , Shipping_Country__c, Use_Account_Shipping_Address__c,
                            Installation_Type__c, Line_Number__c,Base_Decimal_In__c,Height_Decimal_In__c,Customer_Reference_Description__c ,
                              Scheduled_Ship_Date__c , Promised_Date__c,
                            Request_Date__c FROM Order_Entry_Line__c];
    
      Test.startTest();
        mtLine2[2].Request_Date__c = System.today() + 13;
            mtLine2[2].Scheduled_Ship_Date__c = System.today() + 22;
            update mtLine2[2];
    
        mtLine2[2].Status__c ='Draft';
        mtLine2[2].Shipping_Name__c = 'Update From 2 test Method';
        //mtLine2.currencyISOCode = 'EUR';
        update mtLine2[2];
    try{
        if(test.isRunningTest()){
          mtQ2.Status__c = 'Integration Requested';
                  
        update mtQ2;
      
                mtQ2.Integration_Status__c = 'Complete';
          mtQ2.Trigger_Source__c = 'Integration';
        update mtQ2;
            
            mtLine2[2].Sales_Order_Line_Status__c = 'Entered';
        update mtLine2[2]; 
            
                    mtLine2[2].Quantity_Shipped__c  = 5;
                    mtLine2[2].Quantity__c = 5;
            update mtLine2[2];
     
    }
        }
    catch(DmlException ex)
    {
        
    }

      Test.stopTest();
} 
    
    
    static testmethod void methodThree()
{
      Order_Entry_Release__c mtQ3 =[SELECT Id,Status__c, Shipping_Account__c,Billing_Account__c ,Sold_to_Account__c ,Trigger_Source__c,Freight__c,Payment_Terms__c,CurrencyISOCode, 
                                      Shipping_Name__c, Shipping_Street_1__c, Shipping_City__c , Shipping_Postal_Code__c ,recordtypeid ,Deposit_Amount__c,
                                  Shipping_State_Province__c, CPQ_Quote__c, Shipping_Country__c,Opportunity__c,Release_Name__c,Scheduled_Ship_Date__c, Promised_Date__c,
                                      Request_Date__c FROM Order_Entry_Release__c limit 1];
    
     Order_Entry_Line__c mtLine3 = [SELECT Id,Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c,currencyISOCode,First_Request_Ship_Date__c ,
                            Base_Height_1_In__c, Shape__c, recordtypeid, Status__c , 
                            Integration_Status__c, Trigger_Source__c , CPQ_Quote_Line__c,Quote_Line_Item__c , Product__c, Request_Date_Update_Needed__c,
                            Order_Line_Type__c, Mark_Ids__c, Shipping_Name__c , Shipping_Street_1__c, 
                            Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c,
                            Shipping_State_Province__c , Shipping_Country__c, Use_Account_Shipping_Address__c,
                            Installation_Type__c, Line_Number__c,Base_Decimal_In__c,Height_Decimal_In__c,Customer_Reference_Description__c ,
                              Scheduled_Ship_Date__c , Promised_Date__c,
                            Request_Date__c FROM Order_Entry_Line__c LIMIT 1];
    Test.startTest();
        //mtLine3.Request_Date__c = System.today() + 15;
            //mtLine3.Scheduled_Ship_Date__c = System.today() + 25;
        mtQ3.Deposit_Amount__c = 1000;
        mtQ3.Freight__c = 'Billable';
        mtQ3.Payment_Terms__c = '30 NET';
            //update mtLine3;  
        update mtQ3;
    
      Test.stopTest();
}  
  
   
}