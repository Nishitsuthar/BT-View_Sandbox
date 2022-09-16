@isTest
public class TestLogIssuesCmpController1 {
    
    private static final Integer NO_OF_RECORDS = 20;
    @testsetup
    static void LogIssuesCmpController(){
         
      /*   ContactRoleMapping__c cr = new ContactRoleMapping__c();
        cr.Contact_Role__c ='Broker';
        cr.Name='Broker';
        cr.Partner_Account__c= 'Real Estate Services';
        insert cr;*/
       
        List<Account> listOfAccounts = new List<Account>();
        for( Integer intAccountIndex = 0; intAccountIndex < NO_OF_RECORDS; intAccountIndex ++ ) {
            listOfAccounts.add
                (
                    new Account
                    (
                        Name = 'Test Account-' + intAccountIndex,
                        ShippingStreet = '299 Market St',
                        ShippingCity = 'Saddle Brook',
                        ShippingState = 'Nj',
                        ShippingPostalcode = '07663',
                        ShippingCountry = 'USA',
                        BillingStreet = '299 Market St',
                        BillingCity = 'Saddle Brook',
                        BillingState = 'Nj',
                        BillingPostalCode = '07663',
                        BillingCountry = 'USA'
                        
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
        
      /*  ContactRoleMapping__c cr = new ContactRoleMapping__c();
        cr.Contact_Role__c ='Null';
        cr.Name='Null';
        cr.Partner_Account__c= 'Null';
        insert cr;*/
        
        
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
                                    SerialNumber='Lite Id', // 7657677575
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
         System.debug('line 123 ' + Limits.getLimitQueries());
        System.debug('line 124 ' + Limits.getQueries());
       
        
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
                                          RecordTypeId=issueId,IGU_ID_Provided__c='Lite ID'
                                         );        
        
        insert testIssue;
         System.debug('line 138 ' + Limits.getLimitQueries());
        System.debug('line 139 ' + Limits.getQueries());
       
        testIssue.Window_ID__c ='testName';
        update testIssue;
         System.debug('line 143 ' + Limits.getLimitQueries());
        System.debug('line 144 ' + Limits.getQueries());
       
        
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
        
          System.debug('line 157 ' + Limits.getLimitQueries());
        System.debug('line 158 ' + Limits.getQueries());
       
        
    } 
    @istest
    public static void testcreatecssissue(){ 
        List<Account> acc=[select Id from Account];
        Contact con=[select id,name, Phone, Email,AccountId from Contact where AccountId =: acc[0].Id]; 
       // Product2 pr=[select Id,Family from Product2];
        //Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        //PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
      //  List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        List<Issue__c> listOfissues = [select Id,RecordType.Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];//And Product__c=:pr.Id
        List<Id> issueids = new List<Id>(new Map<Id, Issue__c>([select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id]).keySet());
        List<Failure_Mode__c> failureMode = [select id from Failure_Mode__c];
        List<String> failures = new List<string> ();
        for(Failure_Mode__c a: failureMode){ 
            failures.add(String.valueOf(a.id));
        } 
        System.debug('*******200 ' +Limits.getQueries());
         Test.startTest();
        System.debug('*******202 ' +Limits.getQueries());
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode[0].Id And Issue__c=:listOfissues[0].Id];
        Asset ast =[select Id,SerialNumber,Product2Id from Asset where Opportunity__c=:opp.Id limit 1];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        
       
        LogIssuesCmpController licc = new LogIssuesCmpController();
        LogIssuesCmpController.getLogIssueDetails(c[0].id);
        LogIssuesCmpController.resolveIssuesLCForIGU(c[0].id);
        LogIssuesCmpController.getCSSRecordTypes();
        
        LogIssuesCmpController.fetchopenissuesForIGU(c[0].id);
        LogIssuesCmpController.fetchopenissues(c[0].id);
        LogIssuesCmpController.getFailureModeDetails();
        
        Map<String,RecordTypeInfo> issue = SObjectType.Issue__c.getRecordTypeInfosByName();
        Id chwRecId = issue.get('Cable').getRecordTypeId();
            listOfissues[0].RecordType.Id = chwRecId;
        update listOfissues[0];
        
        
        LogIssuesCmpController.fetchopenCSSissuesForCHW(c[0].id);
        LogIssuesCmpController.fetchopenCSSissues(c[0].id);
        
        LogIssuesCmpController.resolveIssuesLCForCSS(c[0].id);
        
      //  LogIssuesCmpController.isproductactive('Test Issue2');
    //    LogIssuesCmpController.saveissues(listOfissues);
     //   LogIssuesCmpController.getprocessStatus(issueids);
    //    LogIssuesCmpController.createProductRequests(c[0].id);
    //    LogIssuesCmpController.updateIssue(listOfissues);
     //   LogIssuesCmpController.searchContactRecords('tes', c[0].id, con.id);
     //   LogIssuesCmpController.searchAssetRecords('tes',opp.id);
      //  licc.initializeDefaultStates(c[0].id);
       // LogIssuesCmpController.fetchInitialRecords(c[0].id);
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
        response.LogIssueCommonWrapper.iguId='Lite Id';
        String s =json.serialize(response);
        LogIssuesCmpController.createcssIssue(s);
        LogIssuesCmpController.dogetFailureComponents('Cable');
        LogIssuesCmpController.failureMap f = new LogIssuesCmpController.failureMap();
        f.key=listOfissues[0].id;
        list<string> f2= new list<string>();
         f2.add(listOfIssueFailure[0].id);
        f.value= f2;
        system.debug('fff'+f);
        String f1 =json.serialize(f);
        system.debug('f1111'+f1);
        f1= '['+f1+']';
        try{
        LogIssuesCmpController.updateIssueWithModes(listOfissues,f1);
            System.debug('*******288 ' +Limits.getQueries());
        Test.stopTest();
            System.debug('*******290 ' +Limits.getQueries());
        }
        catch(exception e){}
        
        
    }
    @istest
    public static void testcreatecssissue1(){ 
        List<Account> acc=[select Id from Account];
        Contact con=[select id,name, Phone, Email,AccountId from Contact where AccountId =: acc[0].Id]; 
      //  Product2 pr=[select Id,Family from Product2];
        //Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        //PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        //List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
       
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
        List<Id> issueids = new List<Id>(new Map<Id, Issue__c>([select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id]).keySet());
        //List<Failure_Mode__c> failureMode = [select id from Failure_Mode__c];
     /*   List<String> failures = new List<string> ();
        for(Failure_Mode__c a: failureMode){ 
            failures.add(String.valueOf(a.id));
        } */
     //   List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode[0].Id And Issue__c=:listOfissues[0].Id];
       // Asset ast =[select Id,SerialNumber,Product2Id from Asset where Opportunity__c=:opp.Id limit 1];
        //List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        System.debug('*******317 ' +Limits.getQueries());
      Test.startTest(); 
        System.debug('*******319 ' +Limits.getQueries());
        LogIssuesCmpController licc = new LogIssuesCmpController();
      
   //   LogIssuesCmpController.isproductactive('Test Issue2');
      LogIssuesCmpController.saveissues(listOfissues);
        LogIssuesCmpController.getprocessStatus(issueids);
        LogIssuesCmpController.createProductRequests(c[0].id);
        LogIssuesCmpController.updateIssue(listOfissues);
        LogIssuesCmpController.searchContactRecords('tes', c[0].id, con.id);
        LogIssuesCmpController.searchAssetRecords('tes',opp.id);
       // licc.initializeDefaultStates(c[0].id);
      //  LogIssuesCmpController.fetchInitialRecords(c[0].id);
      System.debug('*******331 ' +Limits.getQueries());
       Test.stopTest();
        System.debug('*******333 ' +Limits.getQueries());
        
        
        
    }
    
     @istest
    public static void testcreatecssissue2(){ 
        List<Account> acc=[select Id from Account];
        Contact con=[select id,name, Phone, Email,AccountId from Contact where AccountId =: acc[0].Id]; 
      //  Product2 pr=[select Id,Family,Name from Product2];
        //Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        //PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        //List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
       
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
      //  List<Id> issueids = new List<Id>(new Map<Id, Issue__c>([select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id]).keySet());
        List<Failure_Mode__c> failureMode = [select id from Failure_Mode__c];
       List<String> failures = new List<string> ();
        for(Failure_Mode__c a: failureMode){ 
            failures.add(String.valueOf(a.id));
        } 
      //  List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode[0].Id And Issue__c=:listOfissues[0].Id];
        Asset ast =[select Id,SerialNumber,Product2Id from Asset where Opportunity__c=:opp.Id limit 1];
      //  List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        System.debug('*******360 ' +Limits.getQueries());
      Test.startTest();  
        System.debug('*******362 ' +Limits.getQueries());
        LogIssuesCmpController licc = new LogIssuesCmpController();
      
        String objType = String.valueOf(listOfissues);
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
        logisssuewrapper.Lite_Mockid ='Lite ID';
        logisssuewrapper.listOfSelectedFailureModes = failures;
        logisssuewrapper.productidcss = ast.Product2Id;
        logisssuewrapper.existingMakeUpID =ast.Product2Id;
        logisssuewrapper.newMakeUpID =ast.Product2Id;
        logisssuewrapper.requestedDate =Date.newInstance(2020, 01, 30) ; 
        response.listOfLogIssueWrappersCSS.add(logisssuewrapper);
        response.listOfLogIssueWrappers.add(logisssuewrapper);
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
        String isslstString = json.serialize(listOfissues);
        LogIssuesCmpController.createIssue(s);
        LogIssuesCmpController.fetchlatestRecsfromissue(isslstString);
        
    //    LogIssuesCmpController.searchProductRecords('t', price.id, pr.Family);
    	System.debug('*******410 ' +Limits.getQueries());
       Test.stopTest();
        System.debug('*******412 ' +Limits.getQueries());
        
        
        
    }
    @istest
    public static void testcreatecssissue3(){ 
        List<Account> acc=[select Id from Account];
       Contact con=[select id,name, Phone, Email,AccountId from Contact where AccountId =: acc[0].Id]; 
        Product2 pr=[select Id,Family,Name from Product2];
       Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
     System.debug( 'Shipping_Address_Issue Before TestStart '+Limits.getQueries());
    Test.startTest(); 
        System.debug('*******425 ' +Limits.getQueries());
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
                List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];

        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
      //  List<Id> issueids = new List<Id>(new Map<Id, Issue__c>([select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id]).keySet());
     //   List<Failure_Mode__c> failureMode = [select id from Failure_Mode__c];
       List<String> failures = new List<string> ();
                Asset ast =[select Id,SerialNumber,Product2Id from Asset where Opportunity__c=:opp.Id limit 1];
  List< LogIssuesCmpController.LogIssueWrapper> logIssueWrapLst = new List< LogIssuesCmpController.LogIssueWrapper>();
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
   
       
        LogIssuesCmpController licc = new LogIssuesCmpController();
      
        LogIssuesCmpController.searchProductRecords('t', price.id, pr.Family);
         string isslstString = json.serialize(listOfissues);
        logIssueWrapLst.add(logisssuewrapper);
        string issueWrap = json.serialize(logIssueWrapLst);
         LogIssuesCmpController.getFailureComponents(issueWrap);
     // LogIssuesCmpController.submitIssuesForApprovalAndOrder(isslstString,c[0].Id,listOfissues,'testMap');
        LogIssuesCmpController.fetchIssuesSubmittedForApproval(new List<string>{listOfissues[0].Id});
    System.debug( 'Shipping_Address_Issue Before TestStop '+Limits.getQueries());
       Test.stopTest();
        System.debug('*******465 ' +Limits.getQueries());
    }
    
    @istest
    public static void testcreatecssissue4(){ 
        List<Account> acc=[select Id from Account];
        Contact con=[select id,name, Phone, Email,AccountId from Contact where AccountId =: acc[0].Id]; 
        Product2 pr=[select Id,Family,Name from Product2];
        //Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        //PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        //List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
       
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
      //  List<Id> issueids = new List<Id>(new Map<Id, Issue__c>([select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id]).keySet());
        List<Failure_Mode__c> failureMode = [select id from Failure_Mode__c];
       List<String> failures = new List<string> ();
        for(Failure_Mode__c a: failureMode){ 
            failures.add(String.valueOf(a.id));
        } 
      //  List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode[0].Id And Issue__c=:listOfissues[0].Id];
        Asset ast =[select Id,SerialNumber,Product2Id from Asset where Opportunity__c=:opp.Id limit 1];
      //  List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Map<String,List<String>> issueFamMap = new Map<String,List<String>>();
        issueFamMap.put(listOfissues[0].Id,new List<string>{failureMode[0].Id});
        System.debug('*******491 ' +Limits.getQueries());
     Test.startTest();  
        System.debug('*******493 ' +Limits.getQueries());
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
        //String s =json.serialize(response);
       string s = json.serialize(issueFamMap);
      LogIssuesCmpController.saveopenissues(listOfissues, s);
      LogIssuesCmpController.isproductactive(pr.id);
      LogIssuesCmpController.populateQuoteToContact(s,con.id);
       
       
       System.debug('*******538 ' +Limits.getQueries());
       Test.stopTest();
        System.debug('*******540 ' +Limits.getQueries());
        
        
        
    }
    
     @istest
    public static void testcreatecssissue5(){ 
        List<Account> acc=[select Id from Account];
        Contact con=[select id,name, Phone, Email,AccountId from Contact where AccountId =: acc[0].Id]; 
        Product2 pr=[select Id,Family,Name from Product2];
        //Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        //PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc[0].Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc[0].Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        //List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc[0].Id  And ContactId=: con.Id and CaseId=: c[0].Id];
       System.debug( 'Shipping_Address_Issue Before Start '+Limits.getQueries());
     Test.startTest(); 
        System.debug('*******558 ' +Limits.getQueries());
        List<Issue__c> listOfissues = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
      //  List<Id> issueids = new List<Id>(new Map<Id, Issue__c>([select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id]).keySet());
        List<Failure_Mode__c> failureMode = [select id from Failure_Mode__c];
       List<String> failures = new List<string> ();
        for(Failure_Mode__c a: failureMode){ 
            failures.add(String.valueOf(a.id));
        } 
      //  List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode[0].Id And Issue__c=:listOfissues[0].Id];
        Asset ast =[select Id,SerialNumber,Product2Id from Asset where Opportunity__c=:opp.Id limit 1];
      //  List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Map<String,List<String>> issueFamMap = new Map<String,List<String>>();
        issueFamMap.put(listOfissues[0].Id,new List<string>{failureMode[0].Id});
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode[0].Id And Issue__c=:listOfissues[0].Id];
         
        LogIssuesCmpController licc = new LogIssuesCmpController();
         LogIssuesCmpController.Response response = new LogIssuesCmpController.Response();
        LogIssuesCmpController.LogIssueWrapper logisssuewrapper = new LogIssuesCmpController.LogIssueWrapper();
         LogIssuesCmpController.failureMap f = new LogIssuesCmpController.failureMap();
        f.key=listOfissues[0].id;
        list<string> f2= new list<string>();
         f2.add(listOfIssueFailure[0].id);
        f.value= f2;
        system.debug('fff'+f);
        String f1 =json.serialize(f);
        system.debug('f1111'+f1);
        f1= '['+f1+']';
        String isslstString = json.serialize(listOfissues);
          try{
              
              LogIssuesCmpController.submitIssuesForApprovalAndOrder(isslstString,c[0].Id,listOfissues,f1,null);
              System.debug( 'Shipping_Address_Issue Before TestStop '+Limits.getQueries());
              System.debug('*******590 ' +Limits.getQueries());
        Test.stopTest();
              System.debug('*******592 ' +Limits.getQueries());
        }
        catch(exception e){}
      
    }

}