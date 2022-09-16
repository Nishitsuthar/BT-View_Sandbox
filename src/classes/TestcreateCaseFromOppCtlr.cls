@istest
public class TestcreateCaseFromOppCtlr {
@testsetup
    static void LogIssuesCmpController(){
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
        
        Building__c testBuilding = new Building__c(Name='testBuilding');
        insert testBuilding;
        
        Building_Account__c testCustomerSite = new Building_Account__c(Account__c=testAcc.Id,
                                                                       Building__c=testBuilding.Id);
        insert testCustomerSite;
        
        Entitlement testEntitlement = new Entitlement(Name='test',AccountId=testAcc.Id);
        insert testEntitlement;
        Partner_Account__c testpa = new Partner_Account__c( Partner_Account__c = testAcc.id,
                                                       Related_Opportunity__c = testOpp.id,
                                                      Status__c = 'Proposed',
                                                      Role__c = 'Architect');
        insert testpa;
        
        Case testCase = new Case(Customer_Site__c=testCustomerSite.Id,
                                
                                 ContactId=testCon.Id,
                                 Opportunity__c = testOpp.Id,
                                 subject='test case issues',
                                 Type = 'System Behavior Issue',
                                 Status = 'New',
                                 EntitlementId=testEntitlement.Id,
                                 AccountId = testAcc.Id,  
                                 Description = 'test desc',
                                 Intelligence_Start_Date__c = Date.newInstance(2020, 01, 01),
                                 Priority = 'P3' 
                                );
        insert testCase;
        
        Product2 testPro = new Product2(Name = 'Test Issue2',
                                        IsActive = true, 
                                        Family='CSS'
                                       );
        insert testPro; 
        
        Asset testAsset = new Asset(Name='test Asset',
                                    AccountId=testAcc.Id,
                                    ContactId=testCon.Id,
                                    SerialNumber='7657677575',
                                    Product2Id = testPro.Id,
                                    Opportunity__c=testOpp.Id);
        insert testAsset;
        CaseContactRole caseContactRole = new CaseContactRole(CasesId =testCase.Id,
                                                              ContactId = testCon.Id);
        insert caseContactRole;
        
        PriceBookEntry price = new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, 
                                                  Product2Id = testPro.Id,
                                                  UnitPrice =0.0,
                                                  isActive = true);
        insert price;
        
        
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
                                             CaseId=testCase.Id
                                            );
        upsert testWrkOrd;
        
        Map<String,RecordTypeInfo> issue = SObjectType.Issue__c.getRecordTypeInfosByName();
        Id issueId = issue.get('IGU (Halos, IGU Defects)').getRecordTypeId();
        
        Issue__c testIssue = new Issue__c(Case__c = testCase.Id,
                                          Source_Work_Order__c = testWrkOrd.Id,
                                          Issue_Status__c = 'Open',
                                          Work_Type__c = 'Troubleshooting',
                                          Asset__c=testAsset.Id,
                                          Lite_ID_Mock_ID__c =testAsset.SerialNumber,
                                          Product__c=testPro.Id,
                                          Failure_Component__c='IGU',
                                          Window_ID__c ='test',
                                          Opportunity__c =testOpp.Id,
                                          RecordTypeId=issueId
                                         );        
        
        insert testIssue;
        testIssue.Window_ID__c ='testName';
        update testIssue;
        
        
        Schema.Location testLocation = new Schema.Location(Name='test Trunk');
        insert testLocation;
        
        Failure_Mode__c testFailureMode = new Failure_Mode__c(Name='Customer%',
                                                              Failure_Component__c=testIssue.Failure_Component__c
                                                             );
        insert testFailureMode;
        
        
        
        Issue_Failure_Mode__c issueFailure = new Issue_Failure_Mode__c(Issue__c=testIssue.Id,
                                                                       Failure_Mode__c=testFailureMode.Id,
                                                                       Failure_Component__c=testIssue.Failure_Component__c
                                                                      );
        insert issueFailure;
        
    } 
     @istest
    static void createCaseFromOppCtlrtest(){
        Test.startTest();
        Account acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        Building_Account__c cs = [select Id from Building_Account__c where Account__c =: acc.Id];
        Partner_Account__c pa = [select Id from Partner_Account__c where Related_Opportunity__c =: opp.Id LIMIT 1];
        List<Case> c = [select Id,Subject,Description,Status from Case where AccountId=: acc.Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        createCaseFromOppCtlr cc = new createCaseFromOppCtlr();
        createCaseFromOppCtlr.getOppInfo(opp.Id);       
        createCaseFromOppCtlr.getAccounts(opp.Id);  
        createCaseFromOppCtlr.fetchContacts(opp.id,acc.id);
        createCaseFromOppCtlr.getCustomerSites(opp.Id);
        Test.stopTest();
        
        
        System.assertEquals(1, c.size() );
       
    }
    @istest
    static void createCasetest(){
        Test.startTest();
        Account acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        Building_Account__c cs = [select Id from Building_Account__c where Account__c =: acc.Id];
        Partner_Account__c pa = [select Id from Partner_Account__c where Related_Opportunity__c =: opp.Id LIMIT 1];
        List<Case> c = [select Id,Subject,Description,Status from Case where AccountId=: acc.Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
       // createCaseFromOppCtlr.createCase(acc.Id, opp.Id, cs.id, con.id, c[0].Subject,  Date.newInstance(2020, 01, 01), c[0].Description, c[0].Status);
        Test.stopTest();
        
        System.assertEquals(1, c.size() );
    }
}