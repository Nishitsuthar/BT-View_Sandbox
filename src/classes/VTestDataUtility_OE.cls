@isTest
public class VTestDataUtility_OE{
    // JV - 20180522 Changed to use CPQ Quote Object
    //get User
    public static User getUser()
    {
         Profile OEProfile= [SELECT Id FROM Profile WHERE Name = 'Standard user'];
        User userObj = new User(Alias = 'OEUser', Email='OEUser12@test.com', EmailEncodingKey='UTF-8', LastName='OEDevUser1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = OEProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='OE' + String.valueOf(math.random()).replace('.','') + '@oe.com');
        return userObj; 
    }
    
    //Get Salesdirector
    public static SalesSupportDirector__c getSupportDirector()
    {
        SalesSupportDirector__c ssd = new SalesSupportDirector__c(Name = 'Bay area', User_Name__c ='Lance Murata');
        return ssd;
    }
    
     // get test campaign  - add NN
    public static Campaign getTestCampaign ()
    {
     Campaign camp1 = new Campaign(Name = 'Test Campaign 1', IsActive = True);
     return camp1;
     }
    
    // get test account
    public static Account getTestAccount()
    {
        Account acc = new Account();
        acc.Name = 'TestOE Account';
        acc.BillingCity = 'Sanjose';        
        acc.BillingCountry = 'United States';
        acc.BillingState = 'CA';
        acc.BillingPostalCode = '95121';
        acc.ShippingCity = 'Milpitas';
        acc.ShippingCountry = 'United States';
        return acc;   
    }
    
    
    
    
     // get test Opportunity
    public static Opportunity getTestOpportunity(Id accId)
    {
        Opportunity opp = new Opportunity();
        //opp.RecordTypeId = '012E0000000oQMn';
        opp.RecordTypeId = '0120h000000YOJr';
        opp.Name = 'Test Opp OE';
        opp.AccountId = accId;
        opp.Book_Date__c = date.today();
        opp.closeDate = Date.today();
        opp.StageName = 'Discovery';
        opp.TotalOpportunityQuantity = 80;
        opp.Project_Address__c = 'Test addr oe';
        opp.Basis_of_Design__c = 'View';
        opp.Construction_Type__c ='Renovation';
        opp.Install_Status__c = 'None';
        opp.Project_City__c = 'Sanjose';
        opp.Project_State__c = 'CA';
        opp.Opportunity_Type__c = 'Opportunity';
        opp.Install_Type__c = 'Sales';
        opp.Support_Region__c = 'Bay Area';
        opp.Market_Segment__c = 'Multi-Family';
        return opp;
    }
      // get test Product
    public static Product2 getTestProduct()
    {
        //Product2 prod = new Product2(Name = 'Test Product OE', IsActive = true, Family = 'IGU ',CanUseQuantitySchedule=true);
        //***COMMENTING THIS LINE AS PART OF BOS REFERENCE UPDATES WITH CSS
        //Product2 prod = new Product2(Name = 'IGUTestprd', ProductCode = '963-997999', Description = '4',IsActive = true, Family = 'BOS',Coating_Surface__c = '3',Spacer_2_Fill__c = 'Argon',Generation__c = '3', Inboard_Lite__c = 'CLR (Clear)', Laminate__c = 'No', Panes__c = 'Double', Shape__c = 'Rectangle');
        Product2 prod = new Product2(Name = 'IGUTestprd', ProductCode = '963-997999', Description = '4',IsActive = true, Family = 'CSS',Coating_Surface__c = '3',Spacer_2_Fill__c = 'Argon',Generation__c = '3', Inboard_Lite__c = 'CLR (Clear)', Laminate__c = 'No', Panes__c = 'Double', Shape__c = 'Rectangle');
        return prod;
    }
     // get test PriceBook
    public static Pricebook2 getTestPriceBook()
    {
        Pricebook2 pb = new Pricebook2(Name = 'TestpriceBook OE', IsActive = true);
        return pb;
    }
      // get test PricebookEntry
    // @param: Id of pricebook and product
    public static PricebookEntry getTestPricebookEntry(Id productId)
    {
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2 = [select id from PriceBook2 where isStandard = true], // Changed from isStandard to isActive
            product2Id = productId,
            UnitPrice = 1000, 
            IsActive = true, 
            UseStandardPrice = true);
        return pbe;
    }
    // get test opportunitylineitem
    // @param: id of Opportunity Id and PricebookEntry ID
    public static OpportunityLineItem getTestOpportunityLineItem(Id oppId, Id priceBookEntryId)
    {
        OpportunityLineItem opli = new OpportunityLineItem(OpportunityId=oppId,pricebookentryId = priceBookEntryId, UnitPrice = 100, Quantity = 5,ServiceDate=date.today().addDays(1));
        return opli;
    }
    
    // get test opportunitylineitemshcedule
    // @param: ID of Opportunity Product record
    public static OpportunityLineItemSchedule getTestOpportunityLineItemSchedule(Id opliId)
    {
        OpportunityLineItemSchedule opliSch = new OpportunityLineItemSchedule(OpportunityLineItemId=opliId,Quantity=5,ScheduleDate=system.today(),Type='Quantity');
        return opliSch;
    }
    public static Customer_Purchase_Order__c CustomerPO_OE()
    {
        Customer_Purchase_Order__c OECustPO = New Customer_Purchase_Order__c(Name__c = 'TestOEPO');
        return OECustPO;
    }
    public static SBQQ__Quote__c GetQuote(Id opp){
        SBQQ__Quote__c QuoteOE = new SBQQ__Quote__c(SBQQ__Opportunity2__c=opp, SBQQ__ExpirationDate__c = System.today() + 60, Quote_Plan__c = 'All In', Quote_Type__c = 'All In');                         
        return QuoteOE;
    }
    public static SBQQ__QuoteLine__c GetQline(Id OEQuoteId, Id prd, Id PrbE){
        SBQQ__QuoteLine__c  Qline = new SBQQ__QuoteLine__c (SBQQ__Quote__c = OEQuoteId, SBQQ__Product__c = prd, SBQQ__Quantity__c = 1000, SBQQ__CustomerPrice__c = 100);
        return Qline;
    }
    public static IGU_Dimension__c IGUOE(){
        IGU_Dimension__c igu_dimension_Obj = new IGU_Dimension__c(Shape__c = 'Rectangle', Unit_of_Measure__c = 'Imperial', Base_in__c = 14, Base_mm__c = 15, Height_in__c = 16, Height_mm__c = 17, Base_Height_1_in__c = 18, Base_Height_1_mm__c = 19, Search_Key__c = '20', Order_SKU_Suffix__c = '001M2');
        return igu_dimension_Obj;
    }
    public static SKU_Prefix_Element_Map__c OEPSKU(){
        SKU_Prefix_Element_Map__c sku_prefix_element_map_Obj = new SKU_Prefix_Element_Map__c(Name = 'Name500');
        return sku_prefix_element_map_Obj;
    }
    public static SKU_Prefix_Element_Map_Entry__c OESKUMap(Id sku_prefix_element_map_Obj){
        SKU_Prefix_Element_Map_Entry__c sku_prefix_element_map_entry_Obj = new SKU_Prefix_Element_Map_Entry__c(Name = 'Name918', Map_to_Value__c = '1', SKU_Prefix_Element_Map__c = sku_prefix_element_map_Obj);
        return sku_prefix_element_map_entry_Obj;        
    }
    
    public static Order_Entry_Release__c GetOER(Id opp, Id OEQuote, Id accId){
        Order_Entry_Release__c OER = New Order_Entry_Release__c(Name='Testres12',Shipping_Account__c= accId,Billing_Account__c = accId, Sold_to_Account__c =accId,Release_Name__c = 'Relea912', Freight__c = 'Not Included', Quote__c = OEQuote,Opportunity__c=Opp, Order_Type__c = 'External');
        return OER;
    }
    
    // Add by NN 
     public static void InsertCustomSettings(){
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
    abc.add(new SalesSupportDirector__c(Name = 'Boston',User_Name__c = 'Test User'));
    abc.add(new SalesSupportDirector__c(Name = 'Florida',User_Name__c = 'Florida User'));
    abc.add(new SalesSupportDirector__c(Name = 'Toronto',User_Name__c = 'Toronto User'));
    abc.add(new SalesSupportDirector__c(Name = 'Vancouver',User_Name__c = 'Vancouver User'));
     abc.add(new SalesSupportDirector__c(Name = 'Washington DC',User_Name__c = 'Washington DC User'));
    //Vancouver Washington DC
    insert abc;
     List<Customer_Success_Manager__c> csmList= new List<Customer_Success_Manager__c>();
     csmList.add(new Customer_Success_Manager__c(Name = 'Atlanta/Carolinas',User_Name__c = 'Brian Horton'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Bay Area',User_Name__c = 'Namrata Vora'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Chicago',User_Name__c = 'Mike Lane'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Dallas',User_Name__c = 'Mahesh Tharoor'));
    csmList.add(new Customer_Success_Manager__c(Name = 'New York',User_Name__c = 'Brian Klansky'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Hawaii',User_Name__c = 'Lance Murata'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Houston',User_Name__c = 'Mahesh Tharoor'));
    csmList.add(new Customer_Success_Manager__c(Name = 'International',User_Name__c = 'Erich Klawuhn'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Pacific Northwest',User_Name__c = 'Brad Baker'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Memphis/Mid-South',User_Name__c = 'Brian Horton'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Boston',User_Name__c = 'Test User'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Florida',User_Name__c = 'Florida User'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Toronto',User_Name__c = 'Toronto User'));
    csmList.add(new Customer_Success_Manager__c(Name = 'Vancouver',User_Name__c = 'Vancouver User'));
     csmList.add(new Customer_Success_Manager__c(Name = 'Washington DC',User_Name__c = 'Washington DC User'));
     
       insert csmList;
    }
    
    
    
}