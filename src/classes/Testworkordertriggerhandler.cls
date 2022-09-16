@isTest
public class Testworkordertriggerhandler {
    @testSetup static void setupTestdata(){
        
        Account testAcc = new Account(Name = 'Issue1 Account');
        insert testAcc;
        
        Contact testCon = new Contact(LastName='test issue contact',
                                      AccountId=testAcc.Id,
                                      Email='testissuecon1@gmail.com',
                                      Phone='040-12345',
                                      MailingStreet='854 Oakland Ave.',
                                      MailingCity='Los Angeles',
                                      MailingState='CA',
                                      MailingPostalCode='90004',
                                      MailingCountry='US'
                                     );
        insert testCon;
        
        Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
        
        Opportunity testOpp = new Opportunity(Name='Issue Opp',
                                              AccountId=testAcc.Id,
                                              ContactId =testCon.Id,
                                              Support_Region__c='Dallas',
                                              StageName = 'Value Prop.',
                                              PriceBook2Id=standardPricebook.Id,
                                              CloseDate= System.today(),
                                              LeadSource='Database'
                                             );
        insert testOpp;
        
        
        Case newCase = new Case(Subject = 'Unittest',Status = 'New',Priority='P3');
        database.insert(newCase);
        
        Issue__c issue= new Issue__c(Zone_Name__c='test',Case__c =newCase.Id,Product_Under_Warranty__c='Yes',
                                     Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes');
        database.insert(issue);
        
        Failure_Mode__c fm = new Failure_Mode__c(Name ='Customer Objection test',In_Warranty__c=true);
        Failure_Mode__c fm1 = new Failure_Mode__c(Name ='test1');
        database.insert(new list<Failure_Mode__c>{fm,fm1});
        
        Issue_Failure_Mode__c ifm= new Issue_Failure_Mode__c(Failure_Mode__c = fm.id,Issue__c=issue.id);
        database.insert(ifm);
        
        
        
        WorkType testWorkType = new WorkType(Name='Service',
                                             EstimatedDuration=18.64);
        insert testWorkType;
        
        Map<String,RecordTypeInfo> workOrderRecord = SObjectType.WorkOrder.getRecordTypeInfosByName();
        Id wrkRecordId = workOrderRecord.get('Functional Hardware Testing').getRecordTypeId(); 
        WorkOrder testWrkOrd = new WorkOrder( AccountId=testAcc.Id,
                                             RecordTypeId=wrkRecordId,
                                             ContactId=testCon.Id,
                                             opportunity__c = testOpp.Id,
                                             WorkTypeId=testWorkType.Id,
                                             CaseId=newCase.Id                                              
                                            );
        upsert testWrkOrd;
        
        
        
    }
    @istest
    static void WorkOrderTriggerHandlertest(){
        Test.startTest();
        Account acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];        
        List<Case> c= [select Id from Case where AccountId=: acc.Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> workorderlist = [select Id,CaseId,Work_Type__c,Status from WorkOrder ];        
        WorkOrderTriggerHandler workordertrigger = new WorkOrderTriggerHandler();
       // WorkOrderTriggerHandler.tryCreateWorkOrderLineItems(workorderlist);
        Test.stopTest();
        
        System.assertEquals(1, workorderlist.size() );
    }
    
}