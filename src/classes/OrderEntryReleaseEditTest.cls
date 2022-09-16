@isTest
public class OrderEntryReleaseEditTest{
 // @testSetup
 // JV - 20180205 - Added code for new restricted picklist in Opportunity
 // JV - 20180329 - Added code to correctly format Order Entry Release Name
static testMethod void OrderEntryReleaseEdit() {  
 
    List<SalesSupportDirector__c> abc = new List<SalesSupportDirector__c>();
    abc.add(new SalesSupportDirector__c(Name = 'Atlanta/Carolinas',User_Name__c = 'Brian Horton'));
    abc.add(new SalesSupportDirector__c(Name = 'Bay Area',User_Name__c = 'Namrata Vora'));
    abc.add(new SalesSupportDirector__c(Name = 'Chicago',User_Name__c = 'Mike Lane'));
    abc.add(new SalesSupportDirector__c(Name = 'Dallas',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'New York',User_Name__c = 'Brian Klansky'));
    abc.add(new SalesSupportDirector__c(Name = 'Hawaii',User_Name__c = 'Lance Murata'));
    abc.add(new SalesSupportDirector__c(Name = 'Houston',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'International',User_Name__c = 'Erich Klawuhn'));
    abc.add(new SalesSupportDirector__c(Name = 'Pacific Northwest',User_Name__c = 'Brad Baker'));
    abc.add(new SalesSupportDirector__c(Name = 'Memphis/Mid-South',User_Name__c = 'Brian Horton'));
    insert abc;
    
    insert new Customer_Success_Manager__c(Name='Atlanta/Carolinas',User_Name__c='Deepak Jinka');
    
    Account account_Obj = new Account(Name = 'Name419', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', ShippingStreet = 'Sierra brooks', ShippingCity = 'Sanjose', ShippingState = 'CA', ShippingPostalCode = '95132', ShippingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
    Insert account_Obj;
       Id AccId = [select Id from Account limit 1].id; 
      // Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
      Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;
       //Id ProductId = [Select Id from Product2 limit 1].id;
       //Id quote_Obj = [Select Id from Quote Where Id = Opportunity.Id limit 1].id;
       
    
    Opportunity opportunity_Obj = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Test Prequal22',AccountId = account_Obj.id,
    StageName = 'Bid/Quote',
    Request_Won_Verification__c = true,
    Closed_Won_Justification__c ='test',
    CloseDate = System.today(),
    TotalOpportunityQuantity = 80,
    Market_Segment__c = 'Commercial',
    Market_Sub_Segment__c='Owner',
    Basis_of_Design__c = 'View',
    Opportunity_Type__c = 'Priority',
    Construction_Type__c = 'New Construction',
    Install_Type__c = 'Sales',
    Project_City__c = 'San Francisco',
    Project_State__c='CA',
    Requested_Ship_Date_First_Shipment__c = System.today() + 180,
    Book_Date__c = System.today(),                                             
    // JV - 20180205 Added line for new required field
    Promised_Any_Customer__c = 'No',
    Support_Region__c='Atlanta/Carolinas',
    CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId);
    insert opportunity_Obj; 
    
    
    Product2 pe = VTestDataUtility_OE.getTestProduct();
        insert pe;
    Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
    PricebookEntry ped = new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = pe.Id, UnitPrice =1200, isActive = true);
        insert ped;
    OpportunityLineItem oplit = VTestDataUtility_OE.getTestOpportunityLineItem(opportunity_Obj.ID, ped.Id);
       oplit.Product2Id = pe.Id;
    insert oplit;
    
 
 Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
 Insert quote_Obj; 
 
List <Order_Entry_Release__c> oerj = new List <Order_Entry_Release__c> {};
for(Integer i = 0; i < 200; i++){
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-'+ i; name must have correct format for Name formatting on new releases
  Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name ='Testres12-'+ i);
          order_entry_release_Obj.Shipping_Account__c =  account_Obj.Id;     //'001E000000k6QM3';
          order_entry_release_Obj.Billing_Account__c = account_Obj.Id;  //'001E000000k6QM3';
          order_entry_release_Obj.Sold_to_Account__c = account_Obj.Id; //'001E000000k6QM3';
          order_entry_release_Obj.Release_Name__c = 'TestRelea9'; 
          order_entry_release_Obj.Freight__c = 'Billable';
          order_entry_release_Obj.Quote__c = quote_Obj.Id;    //'0Q02C0000000SUKSA2';
          order_entry_release_Obj.Opportunity__c =  opportunity_Obj.Id;  //'006E000000FvvO4';
          order_entry_release_Obj.Order_Type__c = 'External';
          order_entry_release_Obj.Status__c ='Draft';
          order_entry_release_Obj.Scheduled_Ship_Date__c = System.today() + 20;
          oerj.add(order_entry_release_Obj);
      }
      
   //  Line_Number__c =5,Quote_Line_Item__c ='0QL2C0000000C3b',Product__c='01t2C000000jcQO' 
    test.startTest();
    try{
      Insert oerj;
      }catch(exception e){}
       
    test.stopTest(); 
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases
     try{
      Order_Entry_Release__c SelectOE = [Select Id,Project_Manager__c from Order_Entry_Release__c Where Name ='Testres12-1'];
      SelectOE.Name='TestRes345';
      SelectOE.Status__c ='Pre-Release Review';
      
      if(SelectOE.Billing_Account__c <> Null){
          SelectOE.Billing_Account__c = account_Obj.Id;    //'001E0000010oCir';
          SelectOE.Shipping_Account__c = account_Obj.Id;   //'001E0000010oCir';          
      }   
    }catch(exception e){}
    
    Quote quote_ObjId = quote_Obj;
    //Id objRTypeMap =  [select id from RecordType where name='Pre-Qualified Opportunity'].id;
    Id objRTypeMap =  [select id from RecordType where name='MOU Single Project Opportunity'].id;
    System.debug('****'+objRTypeMap);
   //Opportunity objRTypeMap = [Select ID, RecordtypeId from Opportunity Where RecordType.Name ='Pre-Qualified Opportunity' limit 1];
    //TestData.objRTypeMap.put('Opportunity','012E0000000oQMdIAM');   
    Customer_Purchase_Order__c customer_purchase_order_Obj = new Customer_Purchase_Order__c(Name__c = 'Name__c756');
    Insert customer_purchase_order_Obj;     
    Opportunity opportunity_Obj1 = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Name266',AccountId = account_Obj.id,
        StageName = 'Pre-Qualifying-Open',
        Request_Won_Verification__c = true,
        Closed_Won_Justification__c ='test',
        CloseDate = System.today(),
        TotalOpportunityQuantity = 80,
        Market_Segment__c = 'Commercial',
        Market_Sub_Segment__c='Owner',
        Basis_of_Design__c = 'View',
        Opportunity_Type__c = 'Priority',
        Construction_Type__c = 'New Construction',
        Install_Type__c = 'Sales',
        Project_City__c = 'San Francisco',
        Project_State__c='CA',
        Requested_Ship_Date_First_Shipment__c = System.today() + 180,
        Book_Date__c = System.today(),                                             
        // JV - 20180205 Added line for new required field
        Promised_Any_Customer__c = 'No',
        Support_Region__c='Atlanta/Carolinas');
    insert opportunity_Obj1; 
    Quote quote_Obj1 = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Manual_Control_Only__c = false, Include_SDG_Travel__c = false, Include_SDG_Project_Management__c = false, Include_SDG_Commissioning__c = false, Include_SDG_Engineering_Support__c = false, Standard_IGU__c = false, Other_Laminated_Make_up__c = false, Low_E_Inboard_Lite_Surface_3__c = false, Low_E_Inboard_Lite_Surface_4__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
    Insert quote_Obj1; 
    
   // account_Obj.Oracle_Customer_Number__c = NOT NULL;
   
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-'+ i; name must have correct format for Name formatting on new releases
    Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name='Testres12-1',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'Relea912', Freight__c = 'Billable', Quote__c = quote_Obj.Id,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External');
    try{
    Insert order_entry_release_Obj; 
    
    //test.stopTest();
    // Coverage for OrderEntryReleaseWrapper
    // 
    OrderEntryReleaseWrapper oedc = new OrderEntryReleaseWrapper(order_entry_release_Obj);    
    oedc.addValidationError('validationError');
    }catch(exception e){}
    
    try{     
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases
    Order_Entry_Release__c order_entry_release_Obj2T = new Order_Entry_Release__c(Name='Testres12-1',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'Relea912', Freight__c = 'Billable', Quote__c = null,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',Shipping_Name__c='Test');
    Insert order_entry_release_Obj2T;
    }
    catch(Exception e)
    {
        Boolean expectedExceptionThrown =  e.getMessage().contains('Quote is a required field; it may not be null.') ? true : false;
        System.AssertEquals(expectedExceptionThrown, false);
    }
    try{     
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases
    Order_Entry_Release__c order_entry_release_Obj3T = new Order_Entry_Release__c(Name='Testres12-1',Shipping_Account__c= account_Obj.id,Billing_Account__c = null, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'Relea912', Freight__c = 'Billable', Quote__c = null,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',Shipping_Name__c='Test');
    Insert order_entry_release_Obj3T;
    }
    catch(Exception e)
    {
        Boolean expectedExceptionThrown =  e.getMessage().contains('Billing Account is a required field; it may not be null.') ? true : false;
       // System.AssertEquals(expectedExceptionThrown, true);
    }
    try{     
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases
    Order_Entry_Release__c order_entry_release_Obj3T = new Order_Entry_Release__c(Name='Testres12-1',Shipping_Account__c= account_Obj.id,Billing_Account__c = null, Sold_to_Account__c =null,Release_Name__c = 'Relea912', Freight__c = 'Billable', Quote__c = null,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',Shipping_Name__c='Test');
    Insert order_entry_release_Obj3T;
    }
    catch(Exception e)
    {
        Boolean expectedExceptionThrown =  e.getMessage().contains('Sold-to Account is a required field; it may not be null.') ? true : false;
       // System.AssertEquals(expectedExceptionThrown, true);
    } 
    
   }    

static testMethod void test_formatName_UseCase1(){
        
     List<SalesSupportDirector__c> abc = new List<SalesSupportDirector__c>();
    abc.add(new SalesSupportDirector__c(Name = 'Atlanta/Carolinas',User_Name__c = 'Brian Horton'));
    abc.add(new SalesSupportDirector__c(Name = 'Bay Area',User_Name__c = 'Namrata Vora'));
    abc.add(new SalesSupportDirector__c(Name = 'Chicago',User_Name__c = 'Mike Lane'));
    abc.add(new SalesSupportDirector__c(Name = 'Dallas',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'New York',User_Name__c = 'Brian Klansky'));
    abc.add(new SalesSupportDirector__c(Name = 'Hawaii',User_Name__c = 'Lance Murata'));
    abc.add(new SalesSupportDirector__c(Name = 'Houston',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'International',User_Name__c = 'Erich Klawuhn'));
    abc.add(new SalesSupportDirector__c(Name = 'Pacific Northwest',User_Name__c = 'Brad Baker'));
    abc.add(new SalesSupportDirector__c(Name = 'Memphis/Mid-South',User_Name__c = 'Brian Horton'));
    insert abc;
    
    insert new Customer_Success_Manager__c(Name='Atlanta/Carolinas',User_Name__c='Deepak Jinka');
    
   Account account_Obj = new Account(Name = 'Name419', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', ShippingStreet = 'Sierra brooks', ShippingCity = 'Sanjose', ShippingState = 'CA', ShippingPostalCode = '95132', ShippingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
   Insert account_Obj;
       Id AccId = [select Id from Account limit 1].id; 
      // Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
       Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;
       //Id ProductId = [Select Id from Product2 limit 1].id;
       //Id quote_Obj = [Select Id from Quote Where Id = Opportunity.Id limit 1].id;
       
    Opportunity opportunity_Obj = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Test Prequal22',AccountId = account_Obj.id,
        StageName = 'Bid/Quote',
        Request_Won_Verification__c = true,
        Closed_Won_Justification__c ='test',
        CloseDate = System.today(),
        TotalOpportunityQuantity = 80,
        Market_Segment__c = 'Commercial',
        Market_Sub_Segment__c='Owner',
        Basis_of_Design__c = 'View',
        Opportunity_Type__c = 'Priority',
        Construction_Type__c = 'New Construction',
        Install_Type__c = 'Sales',
        Project_City__c = 'San Francisco',
        Project_State__c='CA',
        Requested_Ship_Date_First_Shipment__c = System.today() + 180,
        Book_Date__c = System.today(),     
        // JV - 20180205 Added line for new required field
        Promised_Any_Customer__c = 'No',                                      
        Support_Region__c='Atlanta/Carolinas');
        insert opportunity_Obj; 
    
   Product2 pe = VTestDataUtility_OE.getTestProduct();
        insert pe;
    Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
    PricebookEntry ped = new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = pe.Id, UnitPrice =1200, isActive = true);
        insert ped;
    OpportunityLineItem oplit = VTestDataUtility_OE.getTestOpportunityLineItem(opportunity_Obj.ID, ped.Id);
       oplit.Product2Id = pe.Id;
    insert oplit;
 
 Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
 Insert quote_Obj; 
 
List <Order_Entry_Release__c> oerj = new List <Order_Entry_Release__c> {};
for(Integer i = 0; i < 200; i++){
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-'+ i; name must have correct format for Name formatting on new releases
  Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name ='Testres12-'+ i);
          order_entry_release_Obj.Shipping_Account__c =  account_Obj.Id;     //'001E000000k6QM3';
          order_entry_release_Obj.Billing_Account__c = account_Obj.Id;  //'001E000000k6QM3';
          order_entry_release_Obj.Sold_to_Account__c = account_Obj.Id; //'001E000000k6QM3';
          order_entry_release_Obj.Release_Name__c = 'TestRelea9'; 
          order_entry_release_Obj.Freight__c = 'Billable';
          order_entry_release_Obj.Quote__c = quote_Obj.Id;    //'0Q02C0000000SUKSA2';
          order_entry_release_Obj.Opportunity__c =  opportunity_Obj.Id;  //'006E000000FvvO4';
          order_entry_release_Obj.Order_Type__c = 'External';
          order_entry_release_Obj.Status__c ='Draft';
          order_entry_release_Obj.Scheduled_Ship_Date__c = System.today() + 20;
          oerj.add(order_entry_release_Obj);
      }
      
   //  Line_Number__c =5,Quote_Line_Item__c ='0QL2C0000000C3b',Product__c='01t2C000000jcQO' 
    test.startTest();
    try{
      Insert oerj;
      }catch(exception e){}
      
    test.stopTest(); 
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases
     try{
      Order_Entry_Release__c SelectOE = [Select Id from Order_Entry_Release__c Where Name ='Testres12-1'];
      SelectOE.Name='TestRes345';
      SelectOE.Status__c ='Pre-Release Review';
      
      if(SelectOE.Billing_Account__c <> Null){
          SelectOE.Billing_Account__c = account_Obj.Id;    //'001E0000010oCir';
          SelectOE.Shipping_Account__c = account_Obj.Id;   //'001E0000010oCir';
          
      }
     }catch(exception e){} 
    Quote quote_ObjId = [Select id from Quote limit 1];
   // Id objRTypeMap =  [select id from RecordType where name='Pre-Qualified Opportunity'].id;
    Id objRTypeMap =  [select id from RecordType where name='MOU Single Project Opportunity'].id;
    System.debug('****'+objRTypeMap);
   //Opportunity objRTypeMap = [Select ID, RecordtypeId from Opportunity Where RecordType.Name ='Pre-Qualified Opportunity' limit 1];
    //TestData.objRTypeMap.put('Opportunity','012E0000000oQMdIAM');   
    Customer_Purchase_Order__c customer_purchase_order_Obj = new Customer_Purchase_Order__c(Name__c = 'Name__c756');
    Insert customer_purchase_order_Obj;     
    Opportunity opportunity_Obj1 = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Name266',AccountId = account_Obj.id,
        StageName = 'Pre-Qualifying-Open',
        Request_Won_Verification__c = true,
        Closed_Won_Justification__c ='test',
        CloseDate = System.today(),
        TotalOpportunityQuantity = 80,
        Market_Segment__c = 'Commercial',
        Market_Sub_Segment__c='Owner',
        Basis_of_Design__c = 'View',
        Opportunity_Type__c = 'Priority',
        Construction_Type__c = 'New Construction',
        Install_Type__c = 'Sales',
        Project_City__c = 'San Francisco',
        Project_State__c='CA',
        Requested_Ship_Date_First_Shipment__c = System.today() + 180,
        Book_Date__c = System.today(),                                             
        // JV - 20180205 Added line for new required field
        Promised_Any_Customer__c = 'No',
        Support_Region__c='Atlanta/Carolinas');
    insert opportunity_Obj1; 
    
    Quote quote_Obj1 = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Manual_Control_Only__c = false, Include_SDG_Travel__c = false, Include_SDG_Project_Management__c = false, Include_SDG_Commissioning__c = false, Include_SDG_Engineering_Support__c = false, Standard_IGU__c = false, Other_Laminated_Make_up__c = false, Low_E_Inboard_Lite_Surface_3__c = false, Low_E_Inboard_Lite_Surface_4__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
    Insert quote_Obj1; 
    
   // account_Obj.Oracle_Customer_Number__c = NOT NULL;
   string iguRecId=Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosByName().get('IGU').getRecordTypeId();
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases
    Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name='Testres12-1',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'Relea912', Freight__c = 'Billable', Quote__c = quote_Obj.Id,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',RecordtypeId=iguRecId);
    Insert order_entry_release_Obj; 
    List<Order_Entry_Release__c> order_entry_release_Obj1  =  [SELECT Id,Name,RecordTypeId,Opportunity__c,Billing_Account__c,Shipping_Account__c,Sold_to_Account__c,Release_Name__c,Freight__c,Quote__c,Order_Type__c from Order_Entry_Release__c limit 100];
    System.assertEquals(true,order_entry_release_Obj1.size()>0);
    List<Customer_Purchase_Order__c> customer_purchase_order_Obj1  =  [SELECT Id,Name__c from Customer_Purchase_Order__c];
    System.assertEquals(true,customer_purchase_order_Obj1.size()>0);
    List<Opportunity> opportunity_Obj2  =  [SELECT Id,AccountId,Name,StageName,CloseDate from Opportunity];
    
    System.assertEquals(true,opportunity_Obj2.size()>0);
    List<Account> account_Obj1  =  [SELECT Id,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingAddress,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,ShippingAddress,Contract_Signed__c,Oracle_Customer_Number__c from Account WHERE Oracle_Customer_Number__c <> NULL];
    System.assertEquals(true,account_Obj1.size()>0);
    OrderEntryReleaseEditExt obj01 = new OrderEntryReleaseEditExt(new ApexPages.StandardController(order_entry_release_Obj1[0]));
    obj01.oer = order_entry_release_Obj1[0];
      //((obj01.Size() > 0)); 
    System.assert(obj01 != null);                                                        
    obj01.oppty = new Opportunity();
    obj01.existingOERList = new List<Order_Entry_Release__c>();
    obj01.newRecord = false;
    obj01.formatName();
  }
static testMethod void test_updateShippingAddress_UseCase1(){
    
   List<SalesSupportDirector__c> abc = new List<SalesSupportDirector__c>();
    abc.add(new SalesSupportDirector__c(Name = 'Atlanta/Carolinas',User_Name__c = 'Brian Horton'));
    abc.add(new SalesSupportDirector__c(Name = 'Bay Area',User_Name__c = 'Namrata Vora'));
    abc.add(new SalesSupportDirector__c(Name = 'Chicago',User_Name__c = 'Mike Lane'));
    abc.add(new SalesSupportDirector__c(Name = 'Dallas',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'New York',User_Name__c = 'Brian Klansky'));
    abc.add(new SalesSupportDirector__c(Name = 'Hawaii',User_Name__c = 'Lance Murata'));
    abc.add(new SalesSupportDirector__c(Name = 'Houston',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'International',User_Name__c = 'Erich Klawuhn'));
    abc.add(new SalesSupportDirector__c(Name = 'Pacific Northwest',User_Name__c = 'Brad Baker'));
    abc.add(new SalesSupportDirector__c(Name = 'Memphis/Mid-South',User_Name__c = 'Brian Horton'));
    insert abc;
    
    insert new Customer_Success_Manager__c(Name='Atlanta/Carolinas',User_Name__c='Deepak Jinka');
    
   Account account_Obj = new Account(Name = 'Name419', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', ShippingStreet = 'Sierra brooks', ShippingCity = 'Sanjose', ShippingState = 'CA', ShippingPostalCode = '95132', ShippingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
    Insert account_Obj;
       Id AccId = [select Id from Account limit 1].id; 
       //Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
       Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;
       //Id ProductId = [Select Id from Product2 limit 1].id;
       //Id quote_Obj = [Select Id from Quote Where Id = Opportunity.Id limit 1].id;
      
    
    Opportunity opportunity_Obj = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Test Prequal22',AccountId = account_Obj.id,
    StageName = 'Bid/Quote',
    Request_Won_Verification__c = true,
    Closed_Won_Justification__c ='test',
    CloseDate = System.today(),
    TotalOpportunityQuantity = 80,
    Market_Segment__c = 'Commercial',
    Market_Sub_Segment__c='Owner',
    Basis_of_Design__c = 'View',
    Opportunity_Type__c = 'Priority',
    Construction_Type__c = 'New Construction',
    Install_Type__c = 'Sales',
    Project_City__c = 'San Francisco',
    Project_State__c='CA',
    Requested_Ship_Date_First_Shipment__c = System.today() + 180,
    Book_Date__c = System.today(),                                             
    // JV - 20180205 Added line for new required field
    Promised_Any_Customer__c = 'No',
    Support_Region__c='Atlanta/Carolinas');
    insert opportunity_Obj; 
    
   Product2 pe = VTestDataUtility_OE.getTestProduct();
        insert pe;
    Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
    PricebookEntry ped = new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = pe.Id, UnitPrice =1200, isActive = true);
        insert ped;
    OpportunityLineItem oplit = VTestDataUtility_OE.getTestOpportunityLineItem(opportunity_Obj.ID, ped.Id);
       oplit.Product2Id = pe.Id;
    insert oplit;
    
 
    Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
    Insert quote_Obj; 
 
    List <Order_Entry_Release__c> oerj = new List <Order_Entry_Release__c> {};
    for(Integer i = 0; i < 200; i++){
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-'+ i; name must have correct format for Name formatting on new releases
          Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name ='Testres12-'+ i);
          order_entry_release_Obj.Shipping_Account__c =  account_Obj.Id;     //'001E000000k6QM3';
          order_entry_release_Obj.Billing_Account__c = account_Obj.Id;  //'001E000000k6QM3';
          order_entry_release_Obj.Sold_to_Account__c = account_Obj.Id; //'001E000000k6QM3';
          order_entry_release_Obj.Release_Name__c = 'TestRelea9'; 
          order_entry_release_Obj.Freight__c = 'Billable';
          order_entry_release_Obj.Quote__c = quote_Obj.Id;    //'0Q02C0000000SUKSA2';
          order_entry_release_Obj.Opportunity__c =  opportunity_Obj.Id;  //'006E000000FvvO4';
          order_entry_release_Obj.Order_Type__c = 'External';
          order_entry_release_Obj.Status__c ='Draft';
          order_entry_release_Obj.Scheduled_Ship_Date__c = System.today() + 20;
          oerj.add(order_entry_release_Obj);
      }
      
   //  Line_Number__c =5,Quote_Line_Item__c ='0QL2C0000000C3b',Product__c='01t2C000000jcQO' 
    test.startTest();
    try{
      Insert oerj;
      }catch(exception e){}
      
    test.stopTest(); 
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases
     try{
      Order_Entry_Release__c SelectOE = [Select Id from Order_Entry_Release__c Where Name ='Testres12-1'];
      SelectOE.Name='TestRes345';
      SelectOE.Status__c ='Pre-Release Review';
      
      if(SelectOE.Billing_Account__c <> Null){
          SelectOE.Billing_Account__c = account_Obj.Id;    //'001E0000010oCir';
          SelectOE.Shipping_Account__c = account_Obj.Id;   //'001E0000010oCir';          
      }
     }catch(exception e){} 
     
     try{
      Order_Entry_Release__c SelectOE1 = [Select Id,Name from Order_Entry_Release__c where name='Testres12-1'];
      SelectOE1.Name='';
     }catch(exception e){} 
      
    Quote quote_ObjId = [Select id from Quote limit 1];
   // Id objRTypeMap =  [select id from RecordType where name='Pre-Qualified Opportunity'].id;
    Id objRTypeMap =  [select id from RecordType where name='MOU Single Project Opportunity'].id;
    System.debug('****'+objRTypeMap);
   //Opportunity objRTypeMap = [Select ID, RecordtypeId from Opportunity Where RecordType.Name ='Pre-Qualified Opportunity' limit 1];
    //TestData.objRTypeMap.put('Opportunity','012E0000000oQMdIAM');   
    Customer_Purchase_Order__c customer_purchase_order_Obj = new Customer_Purchase_Order__c(Name__c = 'Name__c756');
    Insert customer_purchase_order_Obj;     
    Opportunity opportunity_Obj1 = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Name266',AccountId = account_Obj.id,
        StageName = 'Pre-Qualifying-Open',
        Request_Won_Verification__c = true,
        Closed_Won_Justification__c ='test',
        CloseDate = System.today(),
        TotalOpportunityQuantity = 80,
        Market_Segment__c = 'Commercial',
        Market_Sub_Segment__c='Owner',
        Basis_of_Design__c = 'View',
        Opportunity_Type__c = 'Priority',
        Construction_Type__c = 'New Construction',
        Install_Type__c = 'Sales',
        Project_City__c = 'San Francisco',
        Project_State__c='CA',
        Requested_Ship_Date_First_Shipment__c = System.today() + 180,
        Book_Date__c = System.today(),                                             
        // JV - 20180205 Added line for new required field
        Promised_Any_Customer__c = 'No',
        Support_Region__c='Atlanta/Carolinas');
    insert opportunity_Obj1;
    Quote quote_Obj1 = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Manual_Control_Only__c = false, Include_SDG_Travel__c = false, Include_SDG_Project_Management__c = false, Include_SDG_Commissioning__c = false, Include_SDG_Engineering_Support__c = false, Standard_IGU__c = false, Other_Laminated_Make_up__c = false, Low_E_Inboard_Lite_Surface_3__c = false, Low_E_Inboard_Lite_Surface_4__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
    Insert quote_Obj1; 
    
   // account_Obj.Oracle_Customer_Number__c = NOT NULL;
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases  
    string iguRecId=Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosByName().get('IGU').getRecordTypeId();
    Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name='Testres12-1',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'Relea912', Freight__c = 'Billable', Quote__c = quote_Obj.Id,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',RecordtypeId=iguRecId);
    Insert order_entry_release_Obj; 
    List<Order_Entry_Release__c> order_entry_release_Obj2  =  [SELECT Id,Name,RecordTypeId,Billing_Account__c,Opportunity__c,Shipping_Account__c,Release_Name__c,Freight__c,Quote__c,Order_Type__c from Order_Entry_Release__c limit 100];
    System.assertEquals(true, order_entry_release_Obj2.size()>0);
    List<Opportunity> opportunity_Obj2  =  [SELECT Id,AccountId,Name,StageName,CloseDate from Opportunity];
    List<Customer_Purchase_Order__c> customer_purchase_order_Obj2  =  [SELECT Id,Name__c from Customer_Purchase_Order__c limit 1];
    System.assertEquals(true,customer_purchase_order_Obj2.size()>0);
    System.assertEquals(true,opportunity_Obj2.size()>0);
    List<Account> account_Obj2  =  [SELECT Id,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingAddress,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,ShippingAddress,Contract_Signed__c,Oracle_Customer_Number__c from Account WHERE Oracle_Customer_Number__c <> NULL];
    System.assertEquals(true,account_Obj2.size()>0);
    OrderEntryReleaseEditExt obj01 = new OrderEntryReleaseEditExt(new ApexPages.StandardController(order_entry_release_Obj2[0]));
    obj01.oer = order_entry_release_Obj2[0];
    obj01.oppty = new Opportunity();
    obj01.existingOERList = new List<Order_Entry_Release__c>();
    obj01.newRecord = false;
    obj01.updateShippingAddress();
  }
static testMethod void test_updateBillingAddress_UseCase1(){
      
   List<SalesSupportDirector__c> abc = new List<SalesSupportDirector__c>();
    abc.add(new SalesSupportDirector__c(Name = 'Atlanta/Carolinas',User_Name__c = 'Brian Horton'));
    abc.add(new SalesSupportDirector__c(Name = 'Bay Area',User_Name__c = 'Namrata Vora'));
    abc.add(new SalesSupportDirector__c(Name = 'Chicago',User_Name__c = 'Mike Lane'));
    abc.add(new SalesSupportDirector__c(Name = 'Dallas',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'New York',User_Name__c = 'Brian Klansky'));
    abc.add(new SalesSupportDirector__c(Name = 'Hawaii',User_Name__c = 'Lance Murata'));
    abc.add(new SalesSupportDirector__c(Name = 'Houston',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'International',User_Name__c = 'Erich Klawuhn'));
    abc.add(new SalesSupportDirector__c(Name = 'Pacific Northwest',User_Name__c = 'Brad Baker'));
    abc.add(new SalesSupportDirector__c(Name = 'Memphis/Mid-South',User_Name__c = 'Brian Horton'));
    insert abc;
    
    insert new Customer_Success_Manager__c(Name='Atlanta/Carolinas',User_Name__c='Deepak Jinka');
    
   Account account_Obj = new Account(Name = 'Name419', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', ShippingStreet = 'Sierra brooks', ShippingCity = 'Sanjose', ShippingState = 'CA', ShippingPostalCode = '95132', ShippingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
    Insert account_Obj;
       Id AccId = [select Id from Account limit 1].id; 
      // Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
       Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;
       //Id ProductId = [Select Id from Product2 limit 1].id;
       //Id quote_Obj = [Select Id from Quote Where Id = Opportunity.Id limit 1].id;
       
       
    Opportunity opportunity_Obj = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Test Prequal22',AccountId = account_Obj.id,
    StageName = 'Bid/Quote',
    Request_Won_Verification__c = true,
    Closed_Won_Justification__c ='test',
    CloseDate = System.today(),
    TotalOpportunityQuantity = 80,
    Market_Segment__c = 'Commercial',
    Market_Sub_Segment__c='Owner',
    Basis_of_Design__c = 'View',
    Opportunity_Type__c = 'Priority',
    Construction_Type__c = 'New Construction',
    Install_Type__c = 'Sales',
    Project_City__c = 'San Francisco',
    Project_State__c='CA',
    Requested_Ship_Date_First_Shipment__c = System.today() + 180,
    Book_Date__c = System.today(),                                             
    // JV - 20180205 Added line for new required field
    Promised_Any_Customer__c = 'No',
    Support_Region__c='Atlanta/Carolinas');
    insert opportunity_Obj; 
    
  Product2 pe = VTestDataUtility_OE.getTestProduct();
        insert pe;
    Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
    PricebookEntry ped = new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = pe.Id, UnitPrice =1200, isActive = true);
        insert ped;
    OpportunityLineItem oplit = VTestDataUtility_OE.getTestOpportunityLineItem(opportunity_Obj.ID, ped.Id);
       oplit.Product2Id = pe.Id;
    insert oplit;
    
 
    Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
    Insert quote_Obj; 
 
    List <Order_Entry_Release__c> oerj = new List <Order_Entry_Release__c> {};
    for(Integer i = 0; i < 200; i++){
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-'+ i; name must have correct format for Name formatting on new releases
       Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name ='Testres12-'+ i);
          order_entry_release_Obj.Shipping_Account__c =  account_Obj.Id;     //'001E000000k6QM3';
          order_entry_release_Obj.Billing_Account__c = account_Obj.Id;  //'001E000000k6QM3';
          order_entry_release_Obj.Sold_to_Account__c = account_Obj.Id; //'001E000000k6QM3';
          order_entry_release_Obj.Release_Name__c = 'TestRelea9'; 
          order_entry_release_Obj.Freight__c = 'Billable';
          order_entry_release_Obj.Quote__c = quote_Obj.Id;    //'0Q02C0000000SUKSA2';
          order_entry_release_Obj.Opportunity__c =  opportunity_Obj.Id;  //'006E000000FvvO4';
          order_entry_release_Obj.Order_Type__c = 'External';
          order_entry_release_Obj.Status__c ='Draft';
          order_entry_release_Obj.Scheduled_Ship_Date__c = System.today() + 20;
          oerj.add(order_entry_release_Obj);
      }
      
   //  Line_Number__c =5,Quote_Line_Item__c ='0QL2C0000000C3b',Product__c='01t2C000000jcQO' 
    test.startTest();
    try{
      Insert oerj;
      }catch(exception e){}
      
    test.stopTest(); 
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases
     try{
      Order_Entry_Release__c SelectOE = [Select Id from Order_Entry_Release__c Where Name ='Testres12-1'];
      SelectOE.Name='TestRes345';
      SelectOE.Status__c ='Pre-Release Review';
      
      if(SelectOE.Billing_Account__c <> Null){
          SelectOE.Billing_Account__c = account_Obj.Id;    //'001E0000010oCir';
          SelectOE.Shipping_Account__c = account_Obj.Id;   //'001E0000010oCir';
          
      }
     }catch(exception e){} 
    Quote quote_ObjId = [Select id from Quote limit 1];
    //Id objRTypeMap =  [select id from RecordType where name='Pre-Qualified Opportunity'].id;
    Id objRTypeMap =  [select id from RecordType where name='MOU Single Project Opportunity'].id;
    System.debug('****'+objRTypeMap);
   //Opportunity objRTypeMap = [Select ID, RecordtypeId from Opportunity Where RecordType.Name ='Pre-Qualified Opportunity' limit 1];
    //TestData.objRTypeMap.put('Opportunity','012E0000000oQMdIAM');   
    Customer_Purchase_Order__c customer_purchase_order_Obj = new Customer_Purchase_Order__c(Name__c = 'Name__c756');
    Insert customer_purchase_order_Obj;     
    Opportunity opportunity_Obj1 = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Name266',AccountId = account_Obj.id,
    StageName = 'Pre-Qualifying-Open',
    Request_Won_Verification__c = true,
    Closed_Won_Justification__c ='test',
    CloseDate = System.today(),
    TotalOpportunityQuantity = 80,
    Market_Segment__c = 'Commercial',
    Market_Sub_Segment__c='Owner',
    Basis_of_Design__c = 'View',
    Opportunity_Type__c = 'Priority',
    Construction_Type__c = 'New Construction',
    Install_Type__c = 'Sales',
    Project_City__c = 'San Francisco',
    Project_State__c='CA',
    Requested_Ship_Date_First_Shipment__c = System.today() + 180,
    Book_Date__c = System.today(),                                             
    // JV - 20180205 Added line for new required field
    Promised_Any_Customer__c = 'No',
    Support_Region__c='Atlanta/Carolinas');
    Insert opportunity_Obj1; 
    Quote quote_Obj1 = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Manual_Control_Only__c = false, Include_SDG_Travel__c = false, Include_SDG_Project_Management__c = false, Include_SDG_Commissioning__c = false, Include_SDG_Engineering_Support__c = false, Standard_IGU__c = false, Other_Laminated_Make_up__c = false, Low_E_Inboard_Lite_Surface_3__c = false, Low_E_Inboard_Lite_Surface_4__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
    Insert quote_Obj1; 
    
   // account_Obj.Oracle_Customer_Number__c = NOT NULL;
    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-1'; name must have correct format for Name formatting on new releases  
    string iguRecId=Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosByName().get('IGU').getRecordTypeId();
    Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c(Name='Testres12-1',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'Relea912', Freight__c = 'Billable', Quote__c = quote_Obj.Id,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',RecordtypeId=iguRecId);
    Insert order_entry_release_Obj; 
    
    Order_Entry_Release__c order_entry_release_Objs = new Order_Entry_Release__c(Name='Testing',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'RMA 1585', Freight__c = 'Billable', Quote__c = quote_Obj.Id,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',RecordtypeId=iguRecId);
    insert order_entry_release_Objs;
    
    List<Order_Entry_Release__c> order_entry_release_Obj2  =  [SELECT Id,Name,RecordtypeId,Opportunity__c,Billing_Account__c,Shipping_Account__c,Release_Name__c,Freight__c,Quote__c,Order_Type__c from Order_Entry_Release__c limit 100];
    
    System.assertEquals(true,order_entry_release_Obj2.size()>0);
    List<Customer_Purchase_Order__c> customer_purchase_order_Obj2  =  [SELECT Id,Name__c from Customer_Purchase_Order__c];
    System.assertEquals(true,customer_purchase_order_Obj2.size()>0);
    List<Opportunity> opportunity_Obj2  =  [SELECT Id,AccountId,Name,StageName,CloseDate from Opportunity];
    System.assertEquals(true,opportunity_Obj2.size()>0);
    List<Account> account_Obj2  =  [SELECT Id,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingAddress,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,ShippingAddress,Contract_Signed__c,Oracle_Customer_Number__c from Account WHERE Oracle_Customer_Number__c <> NULL];
    System.assertEquals(true,account_Obj2.size()>0);
    OrderEntryReleaseEditExt obj01 = new OrderEntryReleaseEditExt(new ApexPages.StandardController(order_entry_release_Obj2[0]));
    obj01.oer = order_entry_release_Obj2[0];
    obj01.oppty = new Opportunity();
    obj01.existingOERList = new List<Order_Entry_Release__c>();
    obj01.newRecord = false;
    PageReference ss = obj01.updateBillingAddress(); 
    
   
    OrderEntryReleaseEditExt obj012 = new OrderEntryReleaseEditExt(new ApexPages.StandardController(order_entry_release_Objs));
    obj012.oer = order_entry_release_Objs;
    obj012.oppty = new Opportunity();
    obj012.existingOERList = new List<Order_Entry_Release__c>();
    obj012.newRecord = false;
    PageReference ss1 = obj012.updateBillingAddress();
    
    
     Account account_Obj223 = new Account(Name = 'Name319', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
    Insert account_Obj223;
    
  }
  
    //Added by ENP - START - Sajid - Controller class coverage for UpdateBillingAddr action
    static testMethod void test_updateShippingAddress(){
        Id objRTypeMap =  [select id from RecordType where name='MOU Single Project Opportunity'].id; 
        string iguRecId=Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosByName().get('IGU').getRecordTypeId();
        Account account_Obj = new Account(Name = 'Name319', ShippingStreet='',ShippingCity='',BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
        Insert account_Obj;
        Opportunity opportunity_Obj = new Opportunity(RecordTypeId = objRTypeMap,Name = 'Name266',AccountId = account_Obj.id,
        StageName = 'Pre-Qualifying-Open',
        Request_Won_Verification__c = true,
        Closed_Won_Justification__c ='test',
        CloseDate = System.today(),
        TotalOpportunityQuantity = 80,
        Market_Segment__c = 'Commercial',
        Market_Sub_Segment__c='Owner',
        Basis_of_Design__c = 'View',
        Opportunity_Type__c = 'Priority',
        Construction_Type__c = 'New Construction',
        Install_Type__c = 'Sales',
        Project_City__c = 'San Francisco',
        Project_State__c='CA',
        Requested_Ship_Date_First_Shipment__c = System.today() + 180,
        Book_Date__c = System.today(),                                             
        // JV - 20180205 Added line for new required field
        Promised_Any_Customer__c = 'No',
        Support_Region__c='Atlanta/Carolinas');
        insert opportunity_Obj;
        Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Manual_Control_Only__c = false, Include_SDG_Travel__c = false, Include_SDG_Project_Management__c = false, Include_SDG_Commissioning__c = false, Include_SDG_Engineering_Support__c = false, Standard_IGU__c = false, Other_Laminated_Make_up__c = false, Low_E_Inboard_Lite_Surface_3__c = false, Low_E_Inboard_Lite_Surface_4__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
        Insert quote_Obj;    
        Order_Entry_Release__c order_entry_release = new Order_Entry_Release__c(Name='Testing',Shipping_Address__c='Alternate Glazing Systems',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'RMA 1585', Freight__c = 'Billable', Quote__c = quote_Obj.Id,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',RecordtypeId=iguRecId);
        insert order_entry_release;
        
        OrderEntryReleaseEditExt obj012 = new OrderEntryReleaseEditExt(new ApexPages.StandardController(order_entry_release));
        PageReference OrderEntryReleaseEditPg = Page.OrderEntryReleaseEdit;
        Test.setCurrentPage(OrderEntryReleaseEditPg);
        // Assigning parameters in the URL
        //ApexPages.currentPage().getParameters().put('isClone','true');
        
        PageReference ss1 = obj012.updateShippingAddress();
        
    }  
  //Added by ENP - END
    
  //Added by ENP - START- Sajid - Controller class coverage for Cancel action
    static testMethod void test_CancelAction(){
        Id objRTypeMap =  [select id from RecordType where name='MOU Single Project Opportunity'].id; 
        string iguRecId=Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosByName().get('IGU').getRecordTypeId();
        Account account_Obj = new Account(Name = 'Name319', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
        Insert account_Obj;
        Opportunity opportunity_Obj = new Opportunity(RecordTypeId = objRTypeMap,Name = 'Name266',AccountId = account_Obj.id,
            StageName = 'Pre-Qualifying-Open',
            Request_Won_Verification__c = true,
            Closed_Won_Justification__c ='test',
            CloseDate = System.today(),
            TotalOpportunityQuantity = 80,
            Market_Segment__c = 'Commercial',
            Market_Sub_Segment__c='Owner',
            Basis_of_Design__c = 'View',
            Opportunity_Type__c = 'Priority',
            Construction_Type__c = 'New Construction',
            Install_Type__c = 'Sales',
            Project_City__c = 'San Francisco',
            Project_State__c='CA',
            Requested_Ship_Date_First_Shipment__c = System.today() + 180,
            Book_Date__c = System.today(),                                             
            // JV - 20180205 Added line for new required field
            Promised_Any_Customer__c = 'No',
            Support_Region__c='Atlanta/Carolinas');
        insert opportunity_Obj;
        Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Manual_Control_Only__c = false, Include_SDG_Travel__c = false, Include_SDG_Project_Management__c = false, Include_SDG_Commissioning__c = false, Include_SDG_Engineering_Support__c = false, Standard_IGU__c = false, Other_Laminated_Make_up__c = false, Low_E_Inboard_Lite_Surface_3__c = false, Low_E_Inboard_Lite_Surface_4__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
        Insert quote_Obj;    
        Order_Entry_Release__c order_entry_release = new Order_Entry_Release__c(Name='Testing',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'RMA 1585', Freight__c = 'Billable', Quote__c = quote_Obj.Id,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',RecordtypeId=iguRecId);
        insert order_entry_release;
        
        OrderEntryReleaseEditExt obj012 = new OrderEntryReleaseEditExt(new ApexPages.StandardController(order_entry_release));
        PageReference OrderEntryReleaseEditPg = Page.OrderEntryReleaseEdit;
        Test.setCurrentPage(OrderEntryReleaseEditPg);
        // Assigning parameters in the URL
        ApexPages.currentPage().getParameters().put('isClone','');
        
        PageReference ss1 = obj012.cancel();
    }  
    //Added by ENP - END
    
    //Added by ENP - START - Sajid - Controller class coverage for getHeaderStatus action
    static testmethod void test_HeaderStatus(){
        Id objRTypeMap =  [select id from RecordType where name='MOU Single Project Opportunity'].id; 
        string iguRecId=Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosByName().get('IGU').getRecordTypeId();
        Account account_Obj = new Account(Name = 'Name319', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
        Insert account_Obj;
        Opportunity opportunity_Obj = new Opportunity(RecordTypeId = objRTypeMap,Name = 'Pre-Qualifying-Open',AccountId = account_Obj.id,
            StageName = 'Pre-Qualifying-Open',
            Request_Won_Verification__c = true,
            Closed_Won_Justification__c ='test',
            CloseDate = System.today(),
            TotalOpportunityQuantity = 80,
            Market_Segment__c = 'Commercial',
            Market_Sub_Segment__c='Owner',
            Basis_of_Design__c = 'View',
            Opportunity_Type__c = 'Priority',
            Construction_Type__c = 'New Construction',
            Install_Type__c = 'Sales',
            Project_City__c = 'San Francisco',
            Project_State__c='CA',
            Requested_Ship_Date_First_Shipment__c = System.today() + 180,
            Book_Date__c = System.today(),                                             
            // JV - 20180205 Added line for new required field
            Promised_Any_Customer__c = 'No',
            Support_Region__c='Atlanta/Carolinas');
        insert opportunity_Obj;
        Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Manual_Control_Only__c = false, Include_SDG_Travel__c = false, Include_SDG_Project_Management__c = false, Include_SDG_Commissioning__c = false, Include_SDG_Engineering_Support__c = false, Standard_IGU__c = false, Other_Laminated_Make_up__c = false, Low_E_Inboard_Lite_Surface_3__c = false, Low_E_Inboard_Lite_Surface_4__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
        Insert quote_Obj;
        Order_Entry_Release__c order_entry_release = new Order_Entry_Release__c(Name='Testing',Shipping_Account__c= account_Obj.id,Billing_Account__c = account_Obj.id, Sold_to_Account__c =account_Obj.id,Release_Name__c = 'RMA 1585', Freight__c = 'Billable', Quote__c = quote_Obj.Id,Opportunity__c=Opportunity_obj.id, Order_Type__c = 'External',RecordtypeId=iguRecId);
        insert order_entry_release;
        OrderEntryReleaseEditExt obj012 = new OrderEntryReleaseEditExt(new ApexPages.StandardController(order_entry_release));
        obj012.getHeaderStatusList();   
    }
    //Added by ENP - END
}