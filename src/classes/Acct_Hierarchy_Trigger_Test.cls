@isTest
public class Acct_Hierarchy_Trigger_Test
{
    static testMethod void TestMethod1()
    {
        Integer treeLevels = 3;
        Integer childrenPerParent = 2;      
        List<Account> parentList = new List<Account>();
        List<Account> childList = new List<Account>();
        List<Id> allIds = new List<Id>();
        String accountTier = '1';
        Map<id, Account> updatedAccts = new Map<id, Account>();
        Map<String, Account> acctNameMap = new Map<String, Account>();
        Integer i;
        Integer l;
        Integer p; 
        Integer pLimit;
        Id parentId;
        String acctName;
        Account testAccount;
        Account rootAccount = new Account (Name = 'Hierarchy Test Root Account', BillingStreet = 'Test Billing St.', 
            BillingCity = 'Los Gatos' , BillingState = 'CA', BillingPostalCode = '95030', ParentId = parentId,
            BillingCountry = 'United States', ShippingStreet = 'Test Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
            ShippingPostalCode = '95030', ShippingCountry = 'United States', Contract_Signed__c = false, Account_Tier__c = '3');
            

        insert rootAccount;
        // Create account trees 
        //
        for (l=0; l<treeLevels; l++) // For each level of the hierarchy
        {
            if (l==0) 
            {
                pLimit = 1;
            }
            else
            {
                pLimit = parentList.size();
            }
            Map<Id, Map<Id,Account>> parentMap = new Map<Id, Map<Id, Account>>();
            for (p = 0; p < pLimit; p++) // For each parent of the level
            {
                for (i=0; i < childrenPerParent; i++) // Create children
                {
                    if (l == 0)
                    {
                        parentID = null;
                        acctName = 'Hierarchy Test Account ' + String.valueOf(i);                       
                    }
                    else
                    {
                        parentId = parentList[p].id;
                        acctName = parentList[p].name + String.valueOf(i);
                        accountTier = null;
                    }
                    childList.add(new Account (Name = acctName, BillingStreet = 'Test Billing St.', 
                        BillingCity = 'Los Gatos' , BillingState = 'CA', BillingPostalCode = '95030', ParentId = parentId,
                        BillingCountry = 'United States', ShippingStreet = 'Test Shipping St.', ShippingCity = 'Los Gatos', ShippingState = 'CA', 
                        ShippingPostalCode = '95030', ShippingCountry = 'United States', Contract_Signed__c = false, Account_Tier__c = accountTier)); 
                }               
            }
            insert childList;
            for (Account acct: childList) allIds.add(acct.Id);
            parentList = childList.clone();
            childList.clear();
        }               
        //
        // Test for attribute inheritance on inserts
        //
        for(Account acct: [SELECT Id, Name, ParentId, Reporting_Parent__c,Account_Tier__c FROM Account WHERE Id IN :allIds])
        {
            System.debug('*** NEW ACCT: ' + String.valueOf(acct));
            updatedAccts.put(acct.Id, acct);
            System.assertEquals('1', acct.Account_Tier__c);
        }
        for(Account acct : updatedAccts.values())
        {
            if (acct.ParentId != null)
            {
                if(updatedAccts.get(acct.ParentId).Reporting_Parent__c != null)
                {
                    System.assertEquals(acct.Reporting_Parent__c, updatedAccts.get(acct.ParentId).Reporting_Parent__c);
                }
                else
                {
                    System.assertEquals(acct.Reporting_Parent__c, acct.ParentId);
                }
            }
        }
        testAccount = [SELECT Id, Name, ParentId, Reporting_Parent__c,Account_Tier__c FROM Account WHERE Name = 'Hierarchy Test Account 11' LIMIT 1];
        try {
            testAccount.Account_Tier__c = null;
            update testAccount;
        }
        catch(Exception e) {
            System.debug('***Update Error ' + e.getMessage());
            System.assert(e.getMessage().contains('** Error: Account Tier is inherited from the Parent Account'));
        }
        testAccount.Account_Tier__c = '1';
        try {
            testAccount.Reporting_Parent__c = null;
            update testAccount;
        }
        catch(Exception e) {
            System.debug('***Update Error ' + e.getMessage());
            System.assert(e.getMessage().contains('** Error: Reporting Account is inherited from the Parent Account'));
        }
        
        // Test for inheritance on change of Account Tier
        //
        testAccount = [SELECT Id, Name, ParentId, Reporting_Parent__c,Account_Tier__c FROM Account WHERE Name = 'Hierarchy Test Account 1' LIMIT 1];
        testAccount.Account_Tier__c = '4';
        update testAccount;
        //
        // Test for inheritance on reparenting Top Account;
        //
        for(Account acct: [SELECT Id, Name, ParentId, Reporting_Parent__c,Account_Tier__c FROM Account WHERE Name LIKE 'Hierarchy Test Account 1%'])
        {
            System.assertEquals('4', acct.Account_Tier__c);
        }
        
        testAccount.ParentId = rootAccount.id;
        
        update testAccount;
        for(Account acct: [SELECT Id, Name, ParentId, Reporting_Parent__c,Account_Tier__c FROM Account WHERE Name LIKE 'Hierarchy Test Account 1%'])
        {
            System.assertEquals(rootAccount.id,acct.Reporting_Parent__c);
            System.assertEquals('3', acct.Account_Tier__c);
        }
        //
        // Test for Unparenting of Top Account
        //
        testAccount.ParentId = null;
        update testAccount;
        
        for(Account acct: [SELECT Id, Name, ParentId, Reporting_Parent__c,Account_Tier__c FROM Account WHERE Name LIKE 'Hierarchy Test Account 1%' AND Id != :testAccount.Id])
        {
            System.assertEquals(testAccount.id,acct.Reporting_Parent__c);
            System.assertEquals('4', acct.Account_Tier__c);
        }
        
        //
        // Test inheritance after delete of top account
        //
        delete testAccount;
        
        for(Account acct: [SELECT Id, Name, ParentId, Reporting_Parent__c,Account_Tier__c FROM Account WHERE Name LIKE 'Hierarchy Test Account 1%'])
        {
            acctNameMap.put(acct.Name, acct);
        }
        String parentKey;
        Account parentAcct;
        for(Account acct : acctNameMap.values())
        {
            parentKey = acct.Name.substring(0, acct.Name.length()- 1);
            System.debug('**ParentKey ' + parentKey);

            if(parentKey == 'Hierarchy Test Account 1')
            {
                System.assertEquals(acct.ParentId, null);
                System.assertEquals(acct.Reporting_Parent__c, null);
                System.assertEquals(acct.Account_Tier__c, '4');
            }
            else
            {
                parentAcct = acctNameMap.get(parentKey);
                System.assertEquals(acct.ParentId, parentAcct.Id);
                System.assertEquals(acct.Reporting_Parent__c, parentAcct.Id);
                System.assertEquals(acct.Account_Tier__c, parentAcct.Account_Tier__c);              
            }
        }

    }
}