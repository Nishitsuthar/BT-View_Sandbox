public class OETestData
{
    // Version 3 - Changed to support OER Record Types
    
    public List<Product2> prodList = new List<Product2>(); // List of products
    public Map<Id, Id> pbeToProdMap = new  Map<Id, Id>();  // Map from PriceBookEntry Id to Product Id
    public Map<Id, Id> prodToPBEMap = new  Map<Id, Id>();  // Map from Product Id to Pricebook Id 
    public List<User> adminUserList = new List<User>(); // List of Admin Users
    public List<User> userList = new List<User>(); // List of non-Admin Users
    public List<Account> billToAcctList = new List<Account>(); // List of BillTo Accounts
    public List<Account> soldToAcctList = new List<Account>(); // List of SoldTo Accounts
    public List<Account> shipToAcctList = new List<Account>(); // List of ShipTo Accounts
    public List<Account> opptyAcctList = new List<Account>(); // List of Opportunity Accounts
    public Map<Id, List<Contact>> contactMap = new Map<Id, List<Contact>>(); //Map from Account to the Contact List for the Account
    public List<Opportunity> opportunityList = new List<Opportunity>(); // Opportunity List
    public Map<Id, List<Opportunity>> opptyMap = new Map<Id, List<Opportunity>>(); // Map from Account Id to Opportunity List for that Account
    public Map<Id, Opportunity> opptyIdMap = new Map<Id, Opportunity>(); // Map from Opportunity Id to Opportunity
    public Map<Id, List<OpportunityLineItem>> opptyProdMap = new Map<Id, List<OpportunityLineItem>>(); // Map from Opportunity Id to List of Opportunity Products for the Opportunity
    public List<SBQQ__Quote__c> CPQ_quoteList = new List<SBQQ__Quote__c>(); // List of CPQ Quotes
    public Map<Id, List<SBQQ__Quote__c>> CPQ_quoteMap = new Map<Id, List<SBQQ__Quote__c>>(); // Map from Opportunity to a List of CPQ Quotes for that Opportunity
    public Map<Id, List<SBQQ__QuoteLine__c>> CPQ_QuoteLineMap = new Map<Id, List<SBQQ__QuoteLine__c>>(); // Map from the Quote Id to a list of CPQ Quote Lines for that Quote
    public Map<Id, List<Quote>> quoteMap = new Map<Id, List<Quote>>(); // Map from Opportunity to a List of CPQ Quotes for that Opportunity
    public List<Quote> quoteList = new List<Quote>(); // List of Standard SFDC Quotes
    public Map<Id, List<QuoteLineItem>> quoteLineMap = new Map<Id, List<QuoteLineItem>>(); // Map from the Quote Id to a list of CPQ Quote Lines for that Quote    
    public Map<Id, List<Customer_Purchase_Order__c>> custPOMap = new Map<Id, List<Customer_Purchase_Order__c>>(); // Map from Opportunity Id to a list of Cust. Purchase Orders for the Oppty
    // JV 20181003 - Added Map for OER Record Type
    public Map<String, RecordType> oelRecordTypeMap = new Map<String, RecordType>(); // Map form OEL RecordType Developer_Name to RecordType 
    public Map<String, RecordType> oerRecordTypeMap = new Map<String, RecordType>(); // Map form OER RecordType Developer_Name to RecordType 
    public List<Order_Entry_Release__c> oerList = new List<Order_Entry_Release__c>(); // List of Order Entry Releases
    public Map<Id, List<Order_Entry_Line__c>> oelMap = new Map<Id, List<Order_Entry_Line__c>>(); // Map from Order Entry Release Id to a list of Order Entry Lines for the Release
    public String initOERStatus = 'Draft';      
}