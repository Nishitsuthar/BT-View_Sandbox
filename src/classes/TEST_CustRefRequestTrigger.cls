@isTest
public class TEST_CustRefRequestTrigger
{
    
    public static Account acct;

    public static Opportunity oppty1;
    public static Opportunity oppty2;

    public static Contact contact1;
    public static Contact contact2;
    public static Contact contact3;

    public static Customer_Reference_Request__c refReq1;
    public static Customer_Reference_Request__c refReq2;
    public static Customer_Reference_Request__c refReq3;
    
    private static testMethod void testCustRefRequestTrigger() 
    {   
        //Id opptyRecordType = [select Id from RecordType where DeveloperName='Pre_Qualified_Opportunity' limit 1].Id;
         Id opptyRecordType = [select Id from RecordType where DeveloperName='MOU_Single_Opportunity' limit 1].Id;
        //
        // Create a Test Account
        //
        acct=new Account(Name='Customer Reference Request Test Account');
        insert acct;
        //
        // Create a Test Opportunities
        //
        oppty1 = new Opportunity(AccountId=acct.Id,RecordTypeId=opptyRecordType, CloseDate=Date.today()+90,
            Name='Customer Reference Request Test Opportunity 1', StageName='Pre-Qualifying-Open', Project_City__c = 'San Francisco', SVMX_Project_City__c = 'San Francisco',
            Project_State__c = 'CA', Install_Type__c = 'Sales', Construction_Type__c = 'New Construction', Basis_of_Design__c = 'View', Market_Segment__c = 'Healthcare');
        insert oppty1;
        
        oppty2 = new Opportunity(AccountId=acct.Id,RecordTypeId =opptyRecordType, CloseDate=Date.today()+90,
            Name='Customer Reference Request Test Opportunity 2', StageName='Pre-Qualifying-Open', Project_City__c = 'San Francisco', SVMX_Project_City__c = 'San Francisco',
            Project_State__c = 'CA', Install_Type__c = 'Sales', Construction_Type__c = 'New Construction', Basis_of_Design__c = 'View', Market_Segment__c = 'Healthcare');
        insert oppty2;
        //
        // Create Reference Contacts
        //
        contact1 = new Contact (LastName = 'Reference Contact 1', AccountID = acct.Id);
        insert contact1;
        contact2 = new Contact (LastName = 'Reference Contact 2', AccountID = acct.Id);
        insert contact2;
        contact3 = new Contact (LastName = 'Reference Contact 2', AccountID = acct.Id);
        insert contact3;
        //
        // Insert Customer Reference Requests and Check Totals
        //
        refReq1 = new Customer_Reference_Request__c(Opportunity__c = oppty1.Id, Type_of_Reference_Need__c = 'E-Mail', Request_Description__c = 'Test Customer Reference Request 1',
            Reference_Role_Requested__c = 'Developer', Reference_Contact_Name__c = contact1.Id, Reference_Contact_Name_2__c = contact2.Id);
        insert refReq1; 
        Contact checkContact1 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact1.Id];
        System.assertEquals(1, checkContact1.Customer_Reference_Requests_Overall__c);
        Contact checkContact2 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact2.Id];
        System.assertEquals(1, checkContact2.Customer_Reference_Requests_Overall__c);

        refReq2 = new Customer_Reference_Request__c(Opportunity__c = oppty1.Id, Type_of_Reference_Need__c = 'E-Mail', Request_Description__c = 'Test Customer Reference Request 2',
            Reference_Role_Requested__c = 'Developer', Reference_Contact_Name__c = contact1.Id, Reference_Contact_Name_2__c = contact3.Id);
        insert refReq2; 
        checkContact1 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact1.Id];
        System.assertEquals(2, checkContact1.Customer_Reference_Requests_Overall__c);
        checkContact2 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact2.Id];
        System.assertEquals(1, checkContact2.Customer_Reference_Requests_Overall__c);
        Contact checkContact3 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact3.Id];
        System.assertEquals(1, checkContact3.Customer_Reference_Requests_Overall__c);

        refReq3 = new Customer_Reference_Request__c(Opportunity__c = oppty2.Id, Type_of_Reference_Need__c = 'E-Mail', Request_Description__c = 'Test Customer Reference Request 3',
            Reference_Role_Requested__c = 'Developer', Reference_Contact_Name__c = contact1.Id, Reference_Contact_Name_2__c = contact2.Id, Reference_Contact_Name_3__c = contact3.id);
        insert refReq3; 
        checkContact1 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact1.Id];
        System.assertEquals(3, checkContact1.Customer_Reference_Requests_Overall__c);
        checkContact2 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact2.Id];
        System.assertEquals(2, checkContact2.Customer_Reference_Requests_Overall__c);
        checkContact3 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact3.Id];
        System.assertEquals(2, checkContact3.Customer_Reference_Requests_Overall__c);

        //
        // Update Customer Reference Requests and Check Totals
        //
        
        // Change a Reference
        refReq2 = [SELECT Id, Reference_Contact_Name__c, Reference_Contact_Name_2__c, Reference_Contact_Name_3__c FROM Customer_Reference_Request__c WHERE Id = :refReq2.Id];
        refReq2.Reference_Contact_Name_2__c = contact2.Id; // Change from Contact 3 to Contact 2
        update refReq2;
        
        checkContact1 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact1.Id];
        System.assertEquals(3, checkContact1.Customer_Reference_Requests_Overall__c); // Does not change
        checkContact2 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact2.Id];
        System.assertEquals(3, checkContact2.Customer_Reference_Requests_Overall__c); // Increses by 1
        checkContact3 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact3.Id];
        System.assertEquals(1, checkContact3.Customer_Reference_Requests_Overall__c); // Decreases by 1
        
        // Remove a Reference
        refReq3 = [SELECT Id, Reference_Contact_Name__c, Reference_Contact_Name_2__c, Reference_Contact_Name_3__c FROM Customer_Reference_Request__c WHERE Id = :refReq3.Id];
        refReq3.Reference_Contact_Name__c = null; // Change from Contact 1 to null
        update refReq3;
        
        checkContact1 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact1.Id];
        System.assertEquals(2, checkContact1.Customer_Reference_Requests_Overall__c); // Decreases by 1
        checkContact2 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact2.Id];
        System.assertEquals(3, checkContact2.Customer_Reference_Requests_Overall__c); // Does not change
        checkContact3 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact3.Id];
        System.assertEquals(1, checkContact3.Customer_Reference_Requests_Overall__c); // Does not change

        // Add Reference
        refReq3 = [SELECT Id, Reference_Contact_Name__c, Reference_Contact_Name_2__c, Reference_Contact_Name_3__c FROM Customer_Reference_Request__c WHERE Id = :refReq3.Id];
        refReq3.Reference_Contact_Name__c = contact1.Id; // Add contact1
        update refReq3;
        
        checkContact1 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact1.Id];
        System.assertEquals(3, checkContact1.Customer_Reference_Requests_Overall__c); // Increases by 1
        checkContact2 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact2.Id];
        System.assertEquals(3, checkContact2.Customer_Reference_Requests_Overall__c); // Does not change
        checkContact3 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact3.Id];
        System.assertEquals(1, checkContact3.Customer_Reference_Requests_Overall__c); // Does not change
        
        //
        // Delete Customer Reference Requests and Check Totals
        //
        
        delete refReq1;
        
        checkContact1 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact1.Id];
        System.assertEquals(2, checkContact1.Customer_Reference_Requests_Overall__c); // Decreases by 1
        checkContact2 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact2.Id];
        System.assertEquals(2, checkContact2.Customer_Reference_Requests_Overall__c); // Decreases by 1
        checkContact3 = [SELECT Id, Customer_Reference_Requests_Overall__c FROM Contact where Id = :contact3.Id];
        System.assertEquals(1, checkContact3.Customer_Reference_Requests_Overall__c); // Does not change

        
    }
}