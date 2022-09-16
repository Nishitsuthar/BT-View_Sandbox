@isTest
public class TestLogIssuesCmpController {
    private static final Integer NO_OF_RECORDS = 200;
    @testsetup
    static void LogIssuesCmpController(){
        List<Account> listOfAccounts = new List<Account>();
        for( Integer intAccountIndex = 0; intAccountIndex < NO_OF_RECORDS; intAccountIndex ++ ) {
            listOfAccounts.add
                (
                    new Account
                    (
                        Name = 'Test Account-' + intAccountIndex
                    )
                );
        }
        INSERT listOfAccounts;
        
        Contact testCon = new Contact(LastName='test issue contact',
                                      AccountId=listOfAccounts[0].Id,
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
                                              AccountId=listOfAccounts[0].Id,
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
        
        Building_Account__c testCustomerSite = new Building_Account__c(Account__c=listOfAccounts[0].Id,
                                                                       Building__c=testBuilding.Id);
        insert testCustomerSite;
        
        Entitlement testEntitlement = new Entitlement(Name='test',AccountId=listOfAccounts[0].Id);
        insert testEntitlement;
        
        
        Case testCase = new Case(Customer_Site__c=testCustomerSite.Id,
                                
                                
                                 ContactId=testCon.Id,
                                 Opportunity__c = testOpp.Id,
                                 subject='test case issues', 
                                 Type = 'System Behavior Issue',
                                 Status = 'New',
                                 Priority ='P3',
                                 EntitlementId=testEntitlement.Id,
                                 AccountId = listOfAccounts[0].Id
                                );
        insert testCase;
        
        Product2 testPro = new Product2(Name = 'Test Issue2',
                                        IsActive = true, 
                                        Family='CSS'
                                       );
        insert testPro; 
        
        Asset testAsset = new Asset(Name='test Asset',
                                    AccountId=listOfAccounts[0].Id,
                                    ContactId=testCon.Id,
                                    SerialNumber='Lite ID', // 7657677575
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
    /*    WorkOrder testWrkOrd = new WorkOrder( 
                                             RecordTypeId=wrkRecordId,
                                             ContactId=testCon.Id,
                                             opportunity__c = testOpp.Id, 
                                             WorkTypeId=testWorkType.Id,
                                             CaseId=testCase.Id
                                            );
        insert testWrkOrd; */
        
        Map<String,RecordTypeInfo> issue = SObjectType.Issue__c.getRecordTypeInfosByName();
        Id issueId = issue.get('IGU (Halos, IGU Defects)').getRecordTypeId();
        
        Issue__c testIssue = new Issue__c(Case__c = testCase.Id,
                                          //Source_Work_Order__c = testWrkOrd.Id,
                                          Issue_Status__c = 'Open',
                                          Work_Type__c = 'Troubleshooting',
                                          Asset__c=testAsset.Id,
                                          Lite_ID_Mock_ID__c =testAsset.SerialNumber,
                                          Product__c=testPro.Id,
                                          Failure_Component__c='IGU',
                                          Window_ID__c ='test',
                                          Opportunity__c =testOpp.Id,
                                          RecordTypeId=issueId,
                                          IGU_ID_Provided__c='Lite ID'
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
    public static void testgetIssues(){
        List<Account> acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc[0].Id]; 
        Product2 pr=[select Id from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        Case ca = [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<WorkOrder> workorderlist = [select Id from WorkOrder where CaseId=:c[0].Id];
        Failure_Mode__c failureMode = [select id from Failure_Mode__c];
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode.Id And Issue__c=:listOfissues[0].Id];
        Asset ast =[select Id from Asset where Opportunity__c=:opp.Id limit 1];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Schema.Location testlocation=[select id From Location ];
        Test.startTest();
        LogIssuesCmpController licc = new LogIssuesCmpController();
        LogIssuesCmpController.getLogIssueDetails(ca.id);
        LogIssuesCmpController.LogIssueWrapper IssueWrapper = new LogIssuesCmpController.LogIssueWrapper ();
        LogIssuesCmpController.fetchopenissues(ca.id);
        LogIssuesCmpController.fetchopencssissues(ca.id); 
        Test.stopTest();
        
        
    }
    
    @istest
    public static void testsearchContactRecords(){
        List<Account> acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc[0].Id]; 
        Product2 pr=[select Id,Family from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        Case ca = [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<WorkOrder> workorderlist = [select Id from WorkOrder where CaseId=:c[0].Id];
        Failure_Mode__c failureMode = [select id from Failure_Mode__c];
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode.Id And Issue__c=:listOfissues[0].Id];
        Asset ast =[select Id from Asset where Opportunity__c=:opp.Id limit 1];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Test.startTest();
        LogIssuesCmpController licc = new LogIssuesCmpController();
        LogIssuesCmpController.searchContactRecords('test issue contact',c[0].id,con.Id);
        LogIssuesCmpController.getFailureModeDetails();
        LogIssuesCmpController.Response response = new LogIssuesCmpController.Response();
        LogIssuesCmpController.SearchResultWrapper searchResult = new LogIssuesCmpController.SearchResultWrapper(pr.id,'5',10,'test');
        string s = json.serialize(listOfissues);
        //LogIssuesCmpController.submitIssuesForApprovalAndOrder(s,c[0].id);
        Test.stopTest();
        
    } 
    
    @istest
    public static void testcreateIssue(){
        List<Account> acc=[select Id from Account];
        Contact con=[select id,name, Phone, Email,AccountId from Contact where AccountId =: acc[0].Id]; 
        Product2 pr=[select Id,Family from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];        
        List<Failure_Mode__c> failureModes = [select id,Failure_Component__c from Failure_Mode__c where Failure_Component__c = 'IGU'];
        System.debug('==failureModes==='+failureModes);  
        List<String> failures = new List<string> ();
        for(Failure_Mode__c a: failureModes){ 
            failures.add(String.valueOf(a.id));
        }
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureModes[0].Id And Issue__c=:listOfissues[0].Id];
        
        Asset ast =[select Id,SerialNumber,Product2Id from Asset where Opportunity__c=:opp.Id limit 1];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Test.startTest();
        LogIssuesCmpController licc = new LogIssuesCmpController();        
        
        system.debug('--'+JSON.serialize(listOfissues));
        LogIssuesCmpController.Response response = new LogIssuesCmpController.Response();
        LogIssuesCmpController.LogIssueWrapper logisssuewrapper = new LogIssuesCmpController.LogIssueWrapper();
        logisssuewrapper.Lite_Mockid = ast.SerialNumber;
        logisssuewrapper.Assetid = ast.id;
        logisssuewrapper.Liteid =ast.SerialNumber;
        logisssuewrapper.Mockid = ast.SerialNumber;
        logisssuewrapper.markID = '12345';
        logisssuewrapper.sel_Resp_Entity = 'View';
        logisssuewrapper.reason_replacement = 'Wrong SKU';
        logisssuewrapper.prodQty = 3;
        logisssuewrapper.recordTypeId= Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
        logisssuewrapper.failureComponent = 'IGU';
        logisssuewrapper.listOfSelectedFailureModes = failures;
        logisssuewrapper.existingMakeUpID =ast.Product2Id;
        logisssuewrapper.newMakeUpID =ast.Product2Id;
        logisssuewrapper.requestedDate =Date.newInstance(2020, 01, 30) ; 
        response.listOfLogIssueWrappers.add(logisssuewrapper);
        response.LogIssueCommonWrapper.selectedIssueType = 'IGU';
        response.LogIssueCommonWrapper.recordCase = c[0];
        response.LogIssueCommonWrapper.recordAccount = acc[0];
        response.LogIssueCommonWrapper.recordOpportunity =  opp;
        response.LogIssueCommonWrapper.quoteToContactname = con.name;
        response.LogIssueCommonWrapper.quoteToContactPhone = con.Phone;
        response.LogIssueCommonWrapper.quoteToContactEmail=  con.Email;
        response.LogIssueCommonWrapper.quoteToContactid = con.Id;
        response.LogIssueCommonWrapper.shipToContactname = con.Name;
        response.LogIssueCommonWrapper.shipToContactPhone =con.Phone;
        response.LogIssueCommonWrapper.shipToContactEmail = con.Email;
        response.LogIssueCommonWrapper.shipToContactid =con.id;
        response.LogIssueCommonWrapper.Shipping_Street_1 = 'Jvp Building';
        response.LogIssueCommonWrapper.Shipping_Street_2 = 'cr';
        response.LogIssueCommonWrapper.Shipping_City = 'NYC';
        response.LogIssueCommonWrapper.Shipping_State_Province = 'New York';
        response.LogIssueCommonWrapper.Shipping_Country = 'United States';
        response.LogIssueCommonWrapper.Shipping_Postal_Code = '52154';
        response.LogIssueCommonWrapper.iguId='Lite Id';
        String s =json.serialize(response);
        LogIssuesCmpController.createIssue(s);
        Test.stopTest();
        
    }
    @istest
    public static void testsearchProductRecords(){ 
        List<Account> acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc[0].Id]; 
        Product2 pr=[select Id,Family from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        Case ca = [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<Id> issueids = new List<Id>(new Map<Id, Issue__c>([select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id]).keySet());
        List<WorkOrder> workorderlist = [select Id from WorkOrder where CaseId=:c[0].Id];
        Failure_Mode__c failureMode = [select id from Failure_Mode__c];
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode.Id And Issue__c=:listOfissues[0].Id];
        Asset ast =[select Id from Asset where Opportunity__c=:opp.Id limit 1];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Test.startTest();
        LogIssuesCmpController licc = new LogIssuesCmpController();
        List<LogIssuesCmpController.issueandFMwrapper> issueandfmwrapper = new List<LogIssuesCmpController.issueandFMwrapper>();
        LogIssuesCmpController.getprocessStatus(issueids);       
        LogIssuesCmpController.searchProductRecords('Test Issue2',p.Id,pr.Family);
        LogIssuesCmpController.searchAssetRecords('test Asset',opp.Id);        
        LogIssuesCmpController.createProductRequests(c[0].Id);
        LogIssuesCmpController.getCSSRecordTypes();
        LogIssuesCmpController.issueandFMwrapper testWrap=new LogIssuesCmpController.issueandFMwrapper(listOfissues[0]); 
        LogIssuesCmpController.failuremodeswrap failure=new LogIssuesCmpController.failuremodeswrap(listOfIssueFailure[0]);
        LogIssuesCmpController.Response response = new LogIssuesCmpController.Response();
        String s =json.serialize(response);
        LogIssuesCmpController.populateQuoteToContact(s,con.id);
        Test.stopTest();
        
        
    }
    @istest
    public static void testcreatecssissue(){ 
        List<Account> acc=[select Id from Account];
        Contact con=[select id,name, Phone, Email,AccountId from Contact where AccountId =: acc[0].Id]; 
        Product2 pr=[select Id,Family from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<Id> issueids = new List<Id>(new Map<Id, Issue__c>([select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id]).keySet());
        List<Failure_Mode__c> failureMode = [select id from Failure_Mode__c];
        List<String> failures = new List<string> ();
        for(Failure_Mode__c a: failureMode){ 
            failures.add(String.valueOf(a.id));
        } 
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode[0].Id And Issue__c=:listOfissues[0].Id];
        Asset ast =[select Id,SerialNumber,Product2Id from Asset where Opportunity__c=:opp.Id limit 1];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Test.startTest();
        LogIssuesCmpController licc = new LogIssuesCmpController();
        LogIssuesCmpController.Response response = new LogIssuesCmpController.Response();
        LogIssuesCmpController.LogIssueWrapper logisssuewrapper = new LogIssuesCmpController.LogIssueWrapper();
        logisssuewrapper.Lite_Mockid = ast.SerialNumber;
        logisssuewrapper.Assetid = ast.id;
        logisssuewrapper.Liteid =ast.SerialNumber;
        logisssuewrapper.Mockid = ast.SerialNumber;
        logisssuewrapper.markID = '12345';
        logisssuewrapper.sel_Resp_Entity = 'View';
        logisssuewrapper.reason_replacement = 'Wrong SKU';
        logisssuewrapper.prodQty = 3;
        logisssuewrapper.recordTypeId= Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId();
        logisssuewrapper.failureComponent = 'IGU Cable';
        logisssuewrapper.listOfSelectedFailureModes = failures;
        logisssuewrapper.productidcss = ast.Product2Id;
        logisssuewrapper.existingMakeUpID =ast.Product2Id;
        logisssuewrapper.newMakeUpID =ast.Product2Id;
        logisssuewrapper.requestedDate =Date.newInstance(2020, 01, 30) ; 
        response.listOfLogIssueWrappersCSS.add(logisssuewrapper);
        response.LogIssueCommonWrapper.selectedIssueType = 'Cable';
        response.LogIssueCommonWrapper.recordCase = c[0];
        response.LogIssueCommonWrapper.recordAccount = acc[0];
        response.LogIssueCommonWrapper.recordOpportunity =  opp;
        response.LogIssueCommonWrapper.quoteToContactname = con.name;
        response.LogIssueCommonWrapper.quoteToContactPhone = con.Phone;
        response.LogIssueCommonWrapper.quoteToContactEmail=  con.Email;
        response.LogIssueCommonWrapper.quoteToContactid = con.Id;
        response.LogIssueCommonWrapper.shipToContactname = con.Name;
        response.LogIssueCommonWrapper.shipToContactPhone =con.Phone;
        response.LogIssueCommonWrapper.shipToContactEmail = con.Email;
        response.LogIssueCommonWrapper.shipToContactid =con.id;
        response.LogIssueCommonWrapper.Shipping_Street_1 = 'Jvp Building';
        response.LogIssueCommonWrapper.Shipping_Street_2 = 'cr';
        response.LogIssueCommonWrapper.Shipping_City = 'NYC';
        response.LogIssueCommonWrapper.Shipping_State_Province = 'New York';
        response.LogIssueCommonWrapper.Shipping_Country = 'United States';
        response.LogIssueCommonWrapper.Shipping_Postal_Code = '52154';
        String s =json.serialize(response);
        LogIssuesCmpController.createcssIssue(s);
        Test.stopTest();
        
        
        
    }
}