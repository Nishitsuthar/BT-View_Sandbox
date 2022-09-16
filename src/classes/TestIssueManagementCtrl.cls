/*
@ PURPOSE : TEST THE FUNCTIONALITY OF IssueManagementCtrl.
*/
@IsTest
Private class TestIssueManagementCtrl {
    
    @testsetup
    static void issueManagementControl(){
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
        
        Pricebook2 standardPricebook = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
        );
        Update standardPricebook;        
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
        
        
        Case testCase = new Case(Customer_Site__c=testCustomerSite.Id,
                                 
                                 ContactId=testCon.Id,
                                 Opportunity__c = testOpp.Id,
                                 subject='test case issues',
                                 Type = 'System Behavior Issue',
                                 Status = 'New',
                                 EntitlementId=testEntitlement.Id,
                                 AccountId = testAcc.Id,
                                 Priority = 'P3'
                                );
        insert testCase;
         
        Product2 testPro = new Product2(Name = 'ASSY',
                                        IsActive = true, 
                                        Family='CSS',
                                        CurrencyIsoCode='USD',
                                        Product_SKU__c='test',
                                        ProductCode='testc'
                                        
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
        system.debug('----inserted price===>'+json.serializePretty(price));
      
        WorkType testWorkType = new WorkType(Name='Service',
                                            EstimatedDuration=18.64);
        insert testWorkType;
        
        List<String> userAliases    = new List<String>{'rohli','mshar','gromm'};
        List<User> userIdsList      = [SELECT id FROM User WHERE Alias IN: userAliases];
        
        Map<String,RecordTypeInfo> workOrderRecord = SObjectType.WorkOrder.getRecordTypeInfosByName();
        Id wrkRecordId = workOrderRecord.get('Functional Hardware Testing').getRecordTypeId(); 
        WorkOrder testWrkOrd = new WorkOrder( AccountId=testAcc.Id,
                                             RecordTypeId           = wrkRecordId,
                                             ContactId              = testCon.Id,
                                             opportunity__c         = testOpp.Id,
                                             WorkTypeId             = testWorkType.Id,
                                             CaseId                 = testCase.Id,
                                             CSM__c                 = userIdsList.get(0).id,
                                             OwnerId                = UserInfo.getUserId(),
                                             PM__c                  = userIdsList.get(1).id,
                                             Site_Operations__c     = userIdsList.get(2).id
                                            );
        insert testWrkOrd;
        
        system.debug('---testWrkOrd----'+testWrkOrd);
         Schema.Location testLocation = new Schema.Location(Name='test Trunk');
        insert testLocation;
       
        Map<String,RecordTypeInfo> issue = SObjectType.Issue__c.getRecordTypeInfosByName();
        Id issueId = issue.get('IGU (Halos, IGU Defects)').getRecordTypeId();
        System.debug('line 119 ' + Limits.getLimitQueries());
        System.debug('line 120 ' + Limits.getQueries());
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
                                          RecordTypeId=issueId,
                                          Replacement_Needed__c='Yes',
                                          Required_Trade__c='Glazier',
                                          Trade_Support_Provided__c=false,
                                          Trunk__c=testLocation.id,IGU_ID_Provided__c='Lite ID'
                                         );        
        
        insert testIssue;
         System.debug('line 139 ' + Limits.getLimitQueries());
        System.debug('line 140 ' + Limits.getQueries());
       
      //  testIssue.Window_ID__c ='testName';
        //update testIssue;
         System.debug('line 144 ' + Limits.getLimitQueries());
        System.debug('line 145 ' + Limits.getQueries());
       
        
       

        Failure_Mode__c testFailureMode = new Failure_Mode__c(Name='test failure',
                                                              Failure_Component__c=testIssue.Failure_Component__c
                                                             );
        insert testFailureMode;
        
        
    
        Issue_Failure_Mode__c issueFailure = new Issue_Failure_Mode__c(Issue__c=testIssue.Id,
                                                                       Failure_Mode__c=testFailureMode.Id,
                                                                       Failure_Component__c=testIssue.Failure_Component__c
                                                                      );
        insert issueFailure;
            
    } 
    
    @IsTest 
    static void testgetIssues(){
        Test.startTest();
        Account acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id]; 
        List<Contact> listCon=[select id,AccountId from Contact where AccountId =: acc.Id];
        Product2 pr=[select Id from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Opportunity> listOpp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc.Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc.Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        Issue__c issueList = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
        List<Issue__c> listOfissues = [select Id,RecordTypeId from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<WorkOrder> workorderlist = [select Id from WorkOrder where CaseId=:c[0].Id];
        Failure_Mode__c failureMode = [select id from Failure_Mode__c];
        List<Failure_Mode__c> listoffails=[select id from Failure_Mode__c];
        List<String> failstring= new List<String>();
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode.Id And Issue__c=:listOfissues[0].Id];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Schema.Location testlocation=[select id From Location ];
         System.debug('line 180 ' + Limits.getLimitQueries());
        System.debug('line 181 ' + Limits.getQueries());
       
        IssueManagementCtrl issuemngmnt = new IssueManagementCtrl();
        IssueManagementCtrl.saveIssues(listOfissues);
        IssueManagementCtrl.Response response = new IssueManagementCtrl.Response();
        IssueManagementCtrl.SearchResultWrapper searchResult = new IssueManagementCtrl.SearchResultWrapper(pr,'five');
        
        response.setWorkOrder(wrk[0].Id);        
        IssueManagementCtrl.IssueManagementCtrlWrapper issueManagement = new IssueManagementCtrl.IssueManagementCtrlWrapper(TRUE,issueList);
        response.listOfIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        response.listOfPartRequestedWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        response.listOfPMIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        System.debug('listOfPMIssueWrappers'+ response.listOfPMIssueWrappers);
        response.listOfIGUIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        IssueManagementCtrl.getIssues(wrk[0].Id);  
        IssueManagementCtrl.isclosedcase(wrk[0].Id);
        IssueManagementCtrl.getUpdatedIssuesOnly(wrk[0].Id);
        IssueManagementCtrl.getOrderDetails(wrk[0].Id); 
        searchResult.setOption('lab','val');
        IssueManagementCtrl.searchContactRecords('test issue contact',listOpp[0].id,listCon[0].id);
        IssueManagementCtrl.searchProductRecords('ASSY',p.Id,'CSS','USD');
        IssueManagementCtrl.searchTrunkRecords('test Trunk');
        IssueManagementCtrl.searchAssetRecords('test Asset',opp.Id);
        IssueManagementCtrl.searchFailureModeRecords('test failure','','IGU',listoffails[0].id);
        IssueManagementCtrl.updateIssues(wrk[0].Id,json.serialize(listOfissues[0].Id));
        IssueManagementCtrl.updatePMIssueRecords(listOfissues[0].Id,1);
        IssueManagementCtrl.updateTradeIssueRecords(listOfissues[0].Id);
        IssueManagementCtrl.fetchPredictions('test');
        IssueManagementCtrl.fetchPlaceDetails('testplace');
        IssueManagementCtrl.searchContactFromOpportunityContactRoles('test issue contact',listOpp[0].id,listCon[0].id);
        IssueManagementCtrl.submitIssuesForApproval(listOfissues);
        IssueManagementCtrl.getCustomMessageFromException('exception');
        IssueManagementCtrl.updatePartsRequested(wrk[0].Id,listOfissues[0].Id,1);
        IssueManagementCtrl.fetchIssuesSubmittedForApproval(listOfissues[0].Id);
        IssueManagementCtrl.createProductRequests(c[0].Id);
        IssueManagementCtrl.fetchOrderIssues(wrk[0].Id,'2','3');
         System.debug('line 217 ' + Limits.getLimitQueries());
        System.debug('line 218 ' + Limits.getQueries());
       
        Test.stopTest();
        
        System.assertEquals(1, workorderlist.size() );
        System.assertEquals(1, c.size() );
        System.assertEquals(1, wrk.size() ); 
        System.assertEquals(1, listOfissues.size() );
    }
     @IsTest 
    static void testgetIssues1(){
        Test.startTest();
        Account acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id]; 
        List<Contact> listCon=[select id,AccountId from Contact where AccountId =: acc.Id];
        Product2 pr=[select Id from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Opportunity> listOpp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc.Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc.Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        Issue__c issueList = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
        List<Issue__c> listOfissues = [select Id,RecordTypeId from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<WorkOrder> workorderlist = [select Id from WorkOrder where CaseId=:c[0].Id];
        Failure_Mode__c failureMode = [select id from Failure_Mode__c];
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode.Id And Issue__c=:listOfissues[0].Id];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Schema.Location testlocation=[select id From Location ];
        
        IssueManagementCtrl issuemngmnt = new IssueManagementCtrl();
        IssueManagementCtrl.saveIssues(listOfissues);
        IssueManagementCtrl.Response response = new IssueManagementCtrl.Response();
        IssueManagementCtrl.SearchResultWrapper searchResult = new IssueManagementCtrl.SearchResultWrapper(pr,'five');
        
        response.setWorkOrder(wrk[0].Id);        
        IssueManagementCtrl.IssueManagementCtrlWrapper issueManagement = new IssueManagementCtrl.IssueManagementCtrlWrapper(TRUE,issueList);
        response.listOfIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        response.listOfPartRequestedWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        response.listOfPMIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        System.debug('listOfPMIssueWrappers'+ response.listOfPMIssueWrappers);
        response.listOfIGUIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        IssueManagementCtrl.searchContactRecords(null,listOpp[0].id,listCon[0].id);
        IssueManagementCtrl.searchAssetRecords(null,opp.Id);
        IssueManagementCtrl.searchProductRecords('ASSY',p.Id,'CSS','USD');
        IssueManagementCtrl.updatePartsRequested(wrk[0].Id,null,1);
         IssueManagementCtrl.getCustomMessageFromException('higher than quantity available in selected trunk');
        Test.stopTest();
    }
      @IsTest 
    static void testgetIssues2(){
        Test.startTest();
        Account acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id]; 
        List<Contact> listCon=[select id,AccountId from Contact where AccountId =: acc.Id];
        Product2 pr=[select Id from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Opportunity> listOpp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc.Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc.Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        Issue__c issueList = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
        List<Issue__c> listOfissues = [select Id,RecordTypeId from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<WorkOrder> workorderlist = [select Id from WorkOrder where CaseId=:c[0].Id];
        Failure_Mode__c failureMode = [select id from Failure_Mode__c];
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode.Id And Issue__c=:listOfissues[0].Id];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Schema.Location testlocation=[select id From Location ];
        
        IssueManagementCtrl issuemngmnt = new IssueManagementCtrl();
        IssueManagementCtrl.saveIssues(null);
        IssueManagementCtrl.Response response = new IssueManagementCtrl.Response();
        IssueManagementCtrl.SearchResultWrapper searchResult = new IssueManagementCtrl.SearchResultWrapper(pr,'five');
        
        response.setWorkOrder(wrk[0].Id);        
        IssueManagementCtrl.IssueManagementCtrlWrapper issueManagement = new IssueManagementCtrl.IssueManagementCtrlWrapper(TRUE,issueList);
        response.listOfIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        response.listOfPartRequestedWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        response.listOfPMIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        System.debug('listOfPMIssueWrappers'+ response.listOfPMIssueWrappers);
        response.listOfIGUIssueWrappers = new List<IssueManagementCtrl.IssueManagementCtrlWrapper>();
        IssueManagementCtrl.getIssues(null);  
        IssueManagementCtrl.getUpdatedIssuesOnly(null);
        IssueManagementCtrl.searchTrunkRecords(null);
        IssueManagementCtrl.searchAssetRecords('test Asset',null);
        IssueManagementCtrl.updateIssues(wrk[0].Id,null);
        IssueManagementCtrl.searchFailureModeRecords('test failure','',null,'listOfAlreadySelectedFailureModes');
        IssueManagementCtrl.searchContactRecords('test issue contact',null,listCon[0].id);
        IssueManagementCtrl.submitIssuesForApproval(null);
        IssueManagementCtrl.getCustomMessageFromException(null);
        IssueManagementCtrl.searchContactFromOpportunityContactRoles(null,null,listCon[0].id);
        IssueManagementCtrl.updatePMIssueRecords(null,1);
        IssueManagementCtrl.updatePartsRequested(null,listOfissues[0].Id,1);
        IssueManagementCtrl.fetchPredictions(null);
        IssueManagementCtrl.fetchPlaceDetails(null);
        IssueManagementCtrl.updateTradeIssueRecords(null);
        IssueManagementCtrl.fetchIssuesSubmittedForApproval(null);
        Test.stopTest();
    }
     @IsTest 
    static void testgetIssues3(){
        Test.startTest();
        Account acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id]; 
        List<Contact> listCon=[select id,AccountId from Contact where AccountId =: acc.Id];
        Product2 pr=[select Id from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Opportunity> listOpp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc.Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc.Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        Issue__c issueList = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
        List<Issue__c> listOfissues = [select Id,RecordTypeId from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<WorkOrder> workorderlist = [select Id from WorkOrder where CaseId=:c[0].Id];
        Failure_Mode__c failureMode = [select id from Failure_Mode__c];
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode.Id And Issue__c=:listOfissues[0].Id];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Schema.Location testlocation=[select id From Location ];
        
        IssueManagementCtrl issuemngmnt = new IssueManagementCtrl();
        IssueManagementCtrl.getCustomMessageFromException('product is not available in the Trunk selected');
        Test.stopTest();
    }
       @IsTest 
    static void testgetIssues4(){
        Test.startTest();
        Account acc=[select Id from Account];
        Contact con=[select id,AccountId from Contact where AccountId =: acc.Id]; 
        List<Contact> listCon=[select id,AccountId from Contact where AccountId =: acc.Id];
        Product2 pr=[select Id from Product2];
        Pricebook2 p=[select Id from Pricebook2 where Id=:Test.getStandardPricebookId()];
        PriceBookEntry price= [select Id from PriceBookEntry where Product2Id=: pr.Id And PriceBook2Id=: p.Id];
        Opportunity opp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Opportunity> listOpp=[select Id from Opportunity where AccountId=: acc.Id and ContactId=:con.Id ];
        List<Case> c= [select Id from Case where AccountId=: acc.Id And ContactId=: con.Id And Opportunity__c=: opp.Id];
        List<WorkOrder> wrk= [select Id from WorkOrder where AccountId=: acc.Id  And ContactId=: con.Id and CaseId=: c[0].Id];
        Issue__c issueList = [select Id from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id ];
        List<Issue__c> listOfissues = [select Id,RecordTypeId from Issue__c where case__c =: c[0].Id And Opportunity__c=: opp.Id And Product__c=:pr.Id];
        List<WorkOrder> workorderlist = [select Id from WorkOrder where CaseId=:c[0].Id];
        Failure_Mode__c failureMode = [select id from Failure_Mode__c];
        List<Issue_Failure_Mode__c> listOfIssueFailure =[select Id from Issue_Failure_Mode__c where Failure_Mode__c=:failureMode.Id And Issue__c=:listOfissues[0].Id];
        List<Asset> assetsList=[select Id from Asset where Opportunity__c=:opp.Id];
        Schema.Location testlocation=[select id From Location ];
        
        IssueManagementCtrl issuemngmnt = new IssueManagementCtrl();
        IssueManagementCtrl.getCustomMessageFromException('once a product has already been consumed');
        Test.stopTest();
    }
      
        
}