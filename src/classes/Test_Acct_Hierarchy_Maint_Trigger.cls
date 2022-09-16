@isTest

public class Test_Acct_Hierarchy_Maint_Trigger 
{   
    
    static TestMethod void unitTest_1 () 
    {
        Account checkAcct;
        Test.startTest();
        Account Hierarchy_Level_0 = new Account(Name='Hierarchy Level 0');
        insert Hierarchy_Level_0;

        Account New_Hierarchy_Level_0 = new Account(Name='New_Hierarchy Level 0');
        insert New_Hierarchy_Level_0;
        
        Account Hierarchy_Level_1_A = new Account(Name='Hierarchy Level 1 A', ParentId = Hierarchy_Level_0.Id);        
        insert Hierarchy_Level_1_A;
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_1_A.Id LIMIT 1];
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_0.Id);
        
        Account Hierarchy_Level_1_B = new Account(Name='Hierarchy Level 1 B', ParentId = Hierarchy_Level_0.Id);        
        insert Hierarchy_Level_1_B;
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_1_B.Id LIMIT 1];
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_0.Id);

        Account Hierarchy_Level_2_A_A = new Account(Name='Hierarchy Level 2 A A', ParentId = Hierarchy_Level_1_A.Id);
        insert Hierarchy_Level_2_A_A;
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_A.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_0.Id);

        Account Hierarchy_Level_2_A_B = new Account(Name='Hierarchy Level 2 A B', ParentId = Hierarchy_Level_1_A.Id);
        insert Hierarchy_Level_2_A_B;
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_B.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_0.Id);

        Account Hierarchy_Level_2_B_A = new Account(Name='Hierarchy Level 2 B A', ParentId = Hierarchy_Level_1_B.Id);
        insert Hierarchy_Level_2_B_A;
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_B_A.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_0.Id);

        Account Hierarchy_Level_2_B_B = new Account(Name='Hierarchy Level 2 B B', ParentId = Hierarchy_Level_1_B.Id);
        insert Hierarchy_Level_2_B_B;
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_B_B.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_0.Id);

        Account Hierarchy_Level_Minus_1 = new Account(Name='Hierarchy Level -1');
        insert Hierarchy_Level_Minus_1;

        Hierarchy_Level_0 = [SELECT Id,Name,ParentId FROM Account WHERE Id = :Hierarchy_Level_0.Id];
        Hierarchy_Level_0.parentId = Hierarchy_Level_Minus_1.Id;
        update Hierarchy_Level_0;
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_A.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_Minus_1.Id);
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_B.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_Minus_1.Id);
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_B_A.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_Minus_1.Id);
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_B_B.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_Minus_1.Id);
        
        Hierarchy_Level_1_A = [SELECT Id,Name,ParentId FROM Account WHERE Id = :Hierarchy_Level_1_A.Id];
        Hierarchy_Level_1_A.ParentId = New_Hierarchy_Level_0.Id;       
        update Hierarchy_Level_1_A; 
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_A.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, New_Hierarchy_Level_0.Id);
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_B.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, New_Hierarchy_Level_0.Id);

        Hierarchy_Level_1_A = [SELECT Id,Name,ParentId FROM Account WHERE Id = :Hierarchy_Level_1_A.Id];
        Hierarchy_Level_1_A.ParentId = null;       
        update Hierarchy_Level_1_A; 
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_A.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_1_A.Id);

        Hierarchy_Level_1_A = [SELECT Id,Name,ParentId FROM Account WHERE Id = :Hierarchy_Level_1_A.Id];
        Hierarchy_Level_1_A.ParentId = Hierarchy_Level_0.Id;       
        update Hierarchy_Level_1_A; 
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_A.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_Minus_1.Id);

        Hierarchy_Level_Minus_1 = [SELECT Id,Name,ParentId FROM Account WHERE Id = :Hierarchy_Level_Minus_1.Id];
        delete Hierarchy_Level_Minus_1;
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_0.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, null);
        checkAcct = [SELECT Id, ParentId, Reporting_Parent__c FROM Account WHERE Id = :Hierarchy_Level_2_A_A.Id LIMIT 1];       
        System.assertEquals(checkAcct.Reporting_Parent__c, Hierarchy_Level_0.Id);
               
               
        Test.stopTest();  
    }
}