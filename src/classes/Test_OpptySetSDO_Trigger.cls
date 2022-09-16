@isTest(SeeAllData=TRUE)
public class Test_OpptySetSDO_Trigger
{
    static testMethod void unitTest1()
    {
        RecordType preQualRecType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Pre_Qualified_Opportunity'];
        
        Profile salesDevProfile = [SELECT Id FROM Profile WHERE Name = 'Sales Development'];
        User  salesDevUser= new User(Alias = 'sdUser', Email='SDUser12@test.com', EmailEncodingKey='UTF-8', LastName='SaleDevUser1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = salesDevProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
        insert salesDevUser;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User  standardUser= new User(Alias = 'stdUser', Email='StandardUser12@test.com', EmailEncodingKey='UTF-8', LastName='StdUser1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = standardProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UX' + String.valueOf(math.random()).replace('.','') + '@X7ab5L16.com');
        insert standardUser;

        
        Account testAcct1;
        Account testAcct2;
        Opportunity testOppty1;
        Opportunity testOppty2;
        Opportunity checkOppty;
        test.startTest();
        System.RunAs(salesDevUser)
        {
            testAcct1 = new Account(Name='Oppty Set SDO Trigger Test Account 1');
            insert testAcct1;
            testOppty1 = new Opportunity(Name='Test SDO Opportunity 1', RecordTypeId = preQualRecType.Id, AccountId = testAcct1.Id, StageName = 'Pre-Qualifying-Open', Support_Region__c = 'Bay Area', CloseDate = System.today() + 60,
                Market_Segment__c = 'Commercial', Basis_of_Design__c = 'View', Opportunity_Type__c = 'Opportunity', Construction_Type__c = 'New Construction', Install_Type__c = 'Sales',
                Project_City__c = 'San Francisco');
            insert testOppty1;
        }
        checkOppty = [SELECT Id, Inside_Sales_Owner__c from Opportunity WHERE ID = :testOppty1.Id LIMIT 1];
        System.assertEquals(checkOppty.Inside_Sales_Owner__c,salesDevUser.Id);
        
        System.RunAs(standardUser)
        {
            testAcct2 = new Account(Name='Oppty Set SDO Trigger Test Account 2');
            insert testAcct2;
            testOppty2 = new Opportunity(Name='Test SDO Opportunity 2', RecordTypeId = preQualRecType.Id, AccountId = testAcct2.Id, StageName = 'Pre-Qualifying-Open', Support_Region__c = 'Bay Area', CloseDate = System.today() + 60,
                Market_Segment__c = 'Commercial', Basis_of_Design__c = 'View', Opportunity_Type__c = 'Opportunity', Construction_Type__c = 'New Construction', Install_Type__c = 'Sales',
                Project_City__c = 'San Francisco');
            insert testOppty2;
        }
        checkOppty = [SELECT Id, Inside_Sales_Owner__c from Opportunity WHERE ID = :testOppty2.Id LIMIT 1];
        System.assertEquals(checkOppty.Inside_Sales_Owner__c,null);
        
        test.stopTest();
        

    }
}