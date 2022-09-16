@IsTest
private class IssueTriggerHelperTest {
    @testSetup static void setupTestdata(){
         Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
     
        Opportunity testMOUOpportunityObj = new Opportunity();
        testMOUOpportunityObj.Name = 'testOppty';
        testMOUOpportunityObj.CloseDate = Date.today();
        testMOUOpportunityObj.StageName = 'POC Stage';
        testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
        testMOUOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
        testMOUOpportunityObj.BOX_Folder_Id__c='123456';
        testMOUOpportunityObj.Service_Date__c=Date.today()-10;
        insert testMOUOpportunityObj;
        Case newCase = new Case(Subject = 'Unittest',Status = 'New',opportunity__c=testMOUOpportunityObj.Id,Priority ='P4');
        database.insert(newCase);
       
        Account newAccount = new Account(name = 'Unittest');
        newAccount.Billingstreet  = 'sample street';
        newAccount.BillingCity   = 'city';
        newAccount.BillingCountry   = 'sample Country';
        newAccount.BillingPostalCode   = '12345';
        newAccount.BillingState   = 'USA';
        newAccount.Shippingstreet  = 'sample street';
        newAccount.ShippingCity   = 'city';
        newAccount.ShippingCountry   = 'sample Country';
        newAccount.ShippingPostalCode   = '12345';
        newAccount.ShippingState   = 'USA';
        
        database.insert(newAccount);
        
        Product2 pd=VTestDataUtility_OE.getTestProduct();
        pd.name='productWithProductItem';
        Product2 pd1=VTestDataUtility_OE.getTestProduct();
        database.insert(new List<Product2>{pd,pd1});
        
        Schema.Location lc = new Schema.Location(name='test',IsInventoryLocation=true);
        database.insert(lc);
        
        productitem pi = new productitem(Product2Id = pd.Id,QuantityOnHand=5,locationid =lc.id);
        insert pi;
        
        Order_Entry_Release__c oer = new Order_Entry_Release__c(Name='ssss',Order_Type__c='Standard',Payment_Terms__c='	IMMEDIATE',Opportunity__c=testMOUOpportunityObj.id,MES_Routing__c='MES',Shipping_Account__c=newAccount.id);
  
        Order_Entry_Line__c  orl = new Order_Entry_Line__c(Quantity__c=10,Order_Entry_Release__c=oer.id,Shipment_Date__c=system.today(),Status__c='Draft');
        Id devRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        WorkOrder issue= new WorkOrder(accountid = newAccount.id,recordtypeid =devRecordTypeId,subject = 'Testing');
        database.insert(issue);    
    }
    @IsTest static void createProductsConsumedTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {    
            List<Product2> pd=[select id from product2 limit 2];
            Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id from Case limit 1];
            Issue__c issue= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',Issue_Status__c='Open',
                                         Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c=CaseRec.Id,
                                         Consumed_From_Trunk__c = true,Quantity__c = 1,product__c = pd.get(0).id,trunk__c = lc.id,Source_Work_Order__c=wo.Id);
            
            Issue__c issue1= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',Issue_Status__c='Open',
                                          Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c=CaseRec.Id,
                                          Consumed_From_Trunk__c = true,Create_Box_Folder__c=True,Quantity__c = 1,product__c = pd.get(1).id,trunk__c = lc.id,Source_Work_Order__c=wo.Id);
            test.starttest();
            try{
                
                database.insert(new list<Issue__c>{issue,issue1});
                
            }
            catch(Exception e){}
            test.stoptest();
        }
    }
    @IsTest static void createProductsConsumedQuantityErrorTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {    
            Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
            Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id from Case limit 1];
            Issue__c issue= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',Issue_Status__c='Open',
                                         Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c=CaseRec.Id,
                                         Consumed_From_Trunk__c = true,Create_Box_Folder__c=true,Quantity__c = 10,product__c = pd.id,trunk__c = lc.id,Source_Work_Order__c=wo.Id);
            
            test.starttest();
            try{
                database.insert(issue);  
            }
            catch(Exception e){}      
            test.stoptest();
        }
    }   
    @IsTest static void createProductsConsumedUpdateTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {    
            Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
            Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id from Case limit 1];
            Issue__c issue= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',Issue_Status__c='Open',Requested_Delivery_Date__c = Date.today()+2,
                                         Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c=CaseRec.Id,
                                         Quantity__c = 1,Create_Box_Folder__c=true,product__c = pd.id,trunk__c = lc.id,Source_Work_Order__c=wo.Id,Product_Replacement__c=true);
            database.insert(issue); 
            issue.Consumed_From_Trunk__c = true;
            test.starttest();
            database.update(issue);      
            test.stoptest();
        }
    }    
    @IsTest static void unlockApprovalLockedRecords(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {    
            WorkOrder wo=[select id from WorkOrder limit 1];
            Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
            Case caseRec=[select id from Case limit 1];
            Issue__c issue= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',Issue_Status__c='Open',Warranty_Type__c = 'Warranty',
                                         Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c=CaseRec.Id,
                                         Quantity__c = 1,Source_Work_Order__c=wo.Id,product__c = pd.id,Create_Box_Folder__c=true);
            database.insert(issue); 
            test.starttest();
            IssueTriggerHelper.unlockApprovalLockedRecords(new List<ID>{issue.Id});
            
            test.stoptest();
        }
    }  
     @IsTest static void populateAssetDataBeforeInsertTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {    
            Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
            Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id from Case limit 1];
            Account accRec =[select Id from Account limit 1];
            
            Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
            /*Asset assetRec2 = new Asset(Name = 'Sample AssetRec2', AccountId = accRec.Id, SerialNumber = '5567', Lite_Height__c = 11, Lite_Width__c = 09, Product2Id =pd.Id );
            Insert assetRec2;*/
            Issue__c issue= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',Issue_Status__c='Open',Asset__c = assetRec.Id,
                                         Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c=CaseRec.Id,
                                         Want_to_order_existing_Makeup__c='No',
                                         Consumed_From_Trunk__c = true,Create_Box_Folder__c=True,Quantity__c = 10,product__c = pd.id,trunk__c = lc.id,Source_Work_Order__c=wo.Id);
            
            test.starttest();
            try{
                database.insert(issue);  
                /*issue.Asset__c = assetRec2.Id;
                database.update(issue);*/
            }
            catch(Exception e){}      
            test.stoptest();
        }
    }   
    @IsTest static void populateShippingAddressTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {    
            Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
            Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id from Case limit 1];
            Account accRec =[select Id from Account limit 1];
            caseRec.AccountId = accRec.Id;
            update caseRec;
            
            Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
            List<Issue__c> listNewIssues = new List<Issue__c>();
            Issue__c issue= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',Issue_Status__c='Open',Asset__c = assetRec.Id,Product_Replacement__c = true,
                                         Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c=CaseRec.Id,Requested_Delivery_Date__c = Date.today()+2,
                                         Consumed_From_Trunk__c = false,Create_Box_Folder__c=True, Quantity__c = 10,product__c = pd.id,trunk__c = lc.id,Source_Work_Order__c=wo.Id,IGU_ID_Provided__c='Lite ID');
           listNewIssues.add(issue);
                Insert listNewIssues;
                IssueTriggerHelper.populateShippingAddress(listNewIssues);
           
        }
    }  
     @IsTest static void populateAssetDataBeforeUpdateTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {    
            Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
            Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id from Case limit 1];
            Account accRec =[select Id from Account limit 1];
            
            Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
            Asset assetRec2 = new Asset(Name = 'Sample AssetRec2', AccountId = accRec.Id, SerialNumber = '5567', Lite_Height__c = 11, Lite_Width__c = 09, Product2Id =pd.Id );
            Insert assetRec2;
            Issue__c issue= new Issue__c(Zone_Name__c='test',Product_Under_Warranty__c='Yes',Issue_Status__c='Open',Asset__c = assetRec.Id,
                                         Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Case__c=CaseRec.Id,
                                         Consumed_From_Trunk__c = false,Quantity__c = 10,Create_Box_Folder__c=true,product__c = pd.id,trunk__c = lc.id,Source_Work_Order__c=wo.Id,IGU_ID_Provided__c='Lite ID');
           Insert issue;
            test.starttest();
            try{
                
                issue.Asset__c = assetRec2.Id;
                issue.Create_Box_Folder__c=false;
                issue.Work_Type__c='Engineering Request';
                dataBase.update(issue);
            }
            catch(Exception e){}      
            test.stoptest();
        }
         
       
    }
      @IsTest static void populateIGUCSSUnderWarrantynewTest(){
              User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
             System.runAs(u1) { 
                 Id IGURecordTypeId = Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
                  Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
                 Product2 pd2=[select id from product2 where name !='productWithProductItem' limit 1];
                  Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id,opportunity__c from Case limit 1];
            Account accRec =[select Id from Account limit 1];
                 Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
                   Issue__c issue= new Issue__c(Issue_Status__c='Open',Asset__c = assetRec.Id,Opportunity__c=CaseRec.opportunity__c,
                                                Ownership__c='View',Lite_ID_Mock_ID__c='Lite ID',Product_Replacement__c=true,
                                                Reason_for_Replacement__c='Non-compliant Product',Requested_Delivery_Date__c=Date.today()+10,
                                                Date_Identified__c=date.today(),Want_to_Order_Existing_Makeup__c='Yes',
                                         Case__c=CaseRec.Id,Quantity__c = 10,Create_Box_Folder__c=true,product__c = pd.id,IGU_ID_Provided__c='Lite ID');
                 test.starttest();
           Insert issue;
                 issue.Reason_for_Replacement__c='Customer Objection';
                 
                 Update issue;
                 test.stoptest();
             }
         }
     @IsTest static void populateIGUCSSUnderWarrantynewTest2(){
              User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
             System.runAs(u1) { 
                 Id IGURecordTypeId = Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
                  
                 Product2 pd2=[select id from product2 where name !='productWithProductItem' limit 1];
                  Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id,opportunity__c from Case limit 1];
            Account accRec =[select Id from Account limit 1];
                 Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd2.Id );
            Insert assetRec;
                   Issue__c issue= new Issue__c(Issue_Status__c='Open',Asset__c = assetRec.Id,Opportunity__c=CaseRec.opportunity__c,
                                                Ownership__c='View',Lite_ID_Mock_ID__c='Lite ID',Product_Replacement__c=true,
                                                Reason_for_Replacement__c='Non-compliant Product',Requested_Delivery_Date__c=Date.today()+10,
                                                Date_Identified__c=date.today(),Existing_Makeup__c=pd2.Id,
                                         Case__c=CaseRec.Id,Quantity__c = 10,Create_Box_Folder__c=true,product__c = pd2.id,IGU_ID_Provided__c='Lite ID');
                 test.starttest();
           Insert issue;
                issue.Want_to_Order_Existing_Makeup__c='No';
                 update issue;
                 test.stoptest();
             }
         }
    
    @IsTest static void populateIGUCSSUnderWarrantynewTest1(){
              User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
             System.runAs(u1) { 
                 Id IGURecordTypeId = Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
                  Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
                 Product2 pd2=[select id from product2 where name !='productWithProductItem' limit 1];
                  Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id,opportunity__c from Case limit 1];
            Account accRec =[select Id from Account limit 1];
                 caseRec.AccountId=accrec.id;
                 update caseRec;
                 Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
                   Issue__c issue= new Issue__c(Issue_Status__c='Open',Asset__c = assetRec.Id,Opportunity__c=CaseRec.opportunity__c,
                                                Ownership__c='View',Lite_ID_Mock_ID__c='Lite ID',Product_Replacement__c=true,
                                                Reason_for_Replacement__c='Non-compliant Product',Requested_Delivery_Date__c=Date.today()+10,
                                                Date_Identified__c=date.today(),Recordtypeid=Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId(),Want_to_Order_Existing_Makeup__c='Yes',
                                         Case__c=CaseRec.Id,Quantity__c = 10,Create_Box_Folder__c=true,product__c = pd.id,IGU_ID_Provided__c='Lite ID');
                 test.starttest();
           Insert issue;
                 issue.Reason_for_Replacement__c='Customer Objection';
                 
                 Update issue;
                 list<Issue__c> listOfissues = new list<Issue__c>();
                 listOfissues.add(issue);
                 test.stoptest();
                 IssueTriggerHelper issth= new IssueTriggerHelper();
                 IssueTriggerHelper.populateShippingAddress(listOfissues);
             }
         }
    @IsTest static void populateIGUCSSUnderWarrantynewTest5(){
              User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
             System.runAs(u1) { 
                 Id IGURecordTypeId = Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
                  Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
                 Product2 pd2=[select id from product2 where name !='productWithProductItem' limit 1];
                  Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id,opportunity__c from Case limit 1];
            Account accRec =[select Id from Account limit 1];
                 caseRec.AccountId=accrec.id;
                 update caseRec;
                  Order_Entry_Release__c oer = new Order_Entry_Release__c(Name='ssss',Order_Type__c='Standard',Payment_Terms__c='IMMEDIATE',Recordtypeid=Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosByName().get('Control Hardware').getRecordTypeId(),Opportunity__c=CaseRec.opportunity__c,MES_Routing__c='MES',Shipping_Account__c=accRec.id);
  
        Order_Entry_Line__c  orl = new Order_Entry_Line__c(Quantity__c=10,Order_Entry_Release__c=oer.id,Shipment_Date__c=system.today(),Status__c='Draft');
    //   insert orl;
                 
                 
                 Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
                   Issue__c issue= new Issue__c(Issue_Status__c='Open',Asset__c = assetRec.Id,Opportunity__c=CaseRec.opportunity__c,
                                                Ownership__c='View',Lite_ID_Mock_ID__c='Lite ID',Product_Replacement__c=true,
                                                Reason_for_Replacement__c='Non-compliant Product',Requested_Delivery_Date__c=Date.today()+10,
                                                Date_Identified__c=date.today(),Recordtypeid=Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId(),Want_to_Order_Existing_Makeup__c='No',
                                         Case__c=CaseRec.Id,Quantity__c = 10,Create_Box_Folder__c=true,product__c = pd.id,IGU_ID_Provided__c='Lite ID');
                 test.starttest();
           Insert issue;
                 issue.Reason_for_Replacement__c='Customer Objection';
                 
                 Update issue;
                 list<Issue__c> listOfissues = new list<Issue__c>();
                 listOfissues.add(issue);
                 test.stoptest();
                 //IssueTriggerHelper issth= new IssueTriggerHelper();
                 //IssueTriggerHelper.populateShippingAddress(listOfissues);
             }
         }
    
    @IsTest static void populateIGUCSSUnderWarrantynewTest6(){
              User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
             System.runAs(u1) { 
                 Id IGURecordTypeId = Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
                  Product2 pd=[select id from product2 where name ='productWithProductItem' limit 1];
                 Product2 pd2=[select id from product2 where name !='productWithProductItem' limit 1];
                  Schema.Location lc = [select id from location limit 1];
            WorkOrder wo=[select id from WorkOrder limit 1];
            Case caseRec=[select id,opportunity__c from Case limit 1];
            Account accRec =[select Id from Account limit 1];
                 
                 
                 BOS_Fulfillment__c bs = new BOS_Fulfillment__c(Name='123',Opportunity_ID__c=CaseRec.opportunity__c,Ship_Date__c=system.today()-10);
                 insert bs;
                 Order_Entry_Release__c oer = new Order_Entry_Release__c(Name='ssss',Order_Type__c='Standard',Payment_Terms__c='IMMEDIATE',Recordtypeid=Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosByName().get('Control Hardware').getRecordTypeId(),Opportunity__c=CaseRec.opportunity__c,MES_Routing__c='MES',Shipping_Account__c=accRec.id);
  //insert oer;
        Order_Entry_Line__c  orl = new Order_Entry_Line__c(Quantity__c=10,Order_Entry_Release__c=oer.id,Shipment_Date__c=system.today(),Status__c='Draft');
     //  insert orl;
                 
                 caseRec.AccountId=accrec.id;
                 update caseRec;
                 Asset assetRec = new Asset(Name = 'Sample AssetRec', AccountId = accRec.Id, SerialNumber = '556788', Lite_Height__c = 12, Lite_Width__c = 10, Product2Id =pd.Id );
            Insert assetRec;
                   Issue__c issue= new Issue__c(Issue_Status__c='Open',Asset__c = assetRec.Id,Opportunity__c=CaseRec.opportunity__c,
                                                Ownership__c='View',Lite_ID_Mock_ID__c='Lite ID',Product_Replacement__c=true,
                                                Reason_for_Replacement__c='Non-compliant Product',Requested_Delivery_Date__c=Date.today()+10,
                                                Date_Identified__c=date.today(),Recordtypeid=Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId(),Want_to_Order_Existing_Makeup__c='No',
                                         Case__c=CaseRec.Id,Quantity__c = 10,Create_Box_Folder__c=true,product__c = pd.id,IGU_ID_Provided__c='Lite ID');
                 test.starttest();
           Insert issue;
                 issue.Reason_for_Replacement__c='Customer Objection';
                 
                 Update issue;
                 list<Issue__c> listOfissues = new list<Issue__c>();
                 listOfissues.add(issue);
                 test.stoptest();
                 //IssueTriggerHelper issth= new IssueTriggerHelper();
                 //IssueTriggerHelper.populateShippingAddress(listOfissues);
             }
         }
      @isTest
        static void issueordercode()
        {
             Account account_Obj = new Account(Name = 'Name419', BillingStreet = 'Sierrabrooks', BillingCity = 'Sanjose', BillingState = 'Ca', BillingPostalCode = '95132', BillingCountry = 'United States', ShippingStreet = 'Sierra brooks', ShippingCity = 'Sanjose', ShippingState = 'CA', ShippingPostalCode = '95132', ShippingCountry = 'United States', Contract_Signed__c = false, Oracle_Customer_Number__c = '78844');
    Insert account_Obj;
       Id AccId = [select Id from Account limit 1].id; 
      // Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
      Id OppRecTypId = [select id from RecordType where name='MOU Single Project Opportunity'].id;
       //Id ProductId = [Select Id from Product2 limit 1].id;
       //Id quote_Obj = [Select Id from Quote Where Id = Opportunity.Id limit 1].id;
       
    
    Opportunity opportunity_Obj = new Opportunity(RecordTypeId = OppRecTypId,Name = 'Test Prequal22',AccountId = account_Obj.id,
    StageName = 'Bid/Quote',
    Request_Won_Verification__c = true,
    Closed_Won_Justification__c ='test',
    CloseDate = System.today(),
    TotalOpportunityQuantity = 80,
    Market_Segment__c = 'Commercial',
    Market_Sub_Segment__c='Owner',
    Basis_of_Design__c = 'View',
    Opportunity_Type__c = 'Priority',
    Construction_Type__c = 'New Construction',
    Install_Type__c = 'Sales',
    Project_City__c = 'San Francisco',
    Project_State__c='CA',
    Requested_Ship_Date_First_Shipment__c = System.today() + 180,
    Book_Date__c = System.today(),                                             
    // JV - 20180205 Added line for new required field
    Promised_Any_Customer__c = 'No',
    Support_Region__c='Atlanta/Carolinas',
    CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId);
    insert opportunity_Obj; 
    
    
    Product2 pe = VTestDataUtility_OE.getTestProduct();
        insert pe;
    Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
    PricebookEntry ped = new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = pe.Id, UnitPrice =1200, isActive = true);
        insert ped;
    OpportunityLineItem oplit = VTestDataUtility_OE.getTestOpportunityLineItem(opportunity_Obj.ID, ped.Id);
       oplit.Product2Id = pe.Id;
    insert oplit;
    
 
 Quote quote_Obj = new Quote(Name = 'Name323',OpportunityId=opportunity_Obj.id ,Include_Freight_rough_estimate_only__c = false, Architecturals_Attached__c = false, Glass_Takeoff_Attached__c = false, Glass_Spec_Attached__c = false, Intermediate_States__c = false, iPad_User_Interface__c = false, Trapezoid__c = false, Triangles__c = false, Grey_Inboard_Lite__c = false, Bronze_Inboard_Lite__c = false, Blue_Inboard_Lite__c = false, Green_Inboard_Lite__c = false, Triple_Pane_No_Low_E__c = false, Triple_Pane_Low_E__c = false, Operable_Doors__c = false, Synced__c = false, Won_Quote__c = false );
 Insert quote_Obj; 
 


    // JV - 20180309 - Added hyphen to Name string to form 'Testres12-'+ i; name must have correct format for Name formatting on new releases
  Order_Entry_Release__c order_entry_release_Obj = new Order_Entry_Release__c();order_entry_release_Obj.Name ='Testres12';
          order_entry_release_Obj.Shipping_Account__c =  account_Obj.Id;     
          order_entry_release_Obj.Billing_Account__c = account_Obj.Id; 
          order_entry_release_Obj.Sold_to_Account__c = account_Obj.Id; 
          order_entry_release_Obj.Release_Name__c = 'TestRelea9';
          order_entry_release_Obj.Freight__c = 'Billable';
          order_entry_release_Obj.Quote__c = quote_Obj.Id;
          order_entry_release_Obj.Opportunity__c =  opportunity_Obj.Id; 
          order_entry_release_Obj.Order_Type__c = 'Standard';
          order_entry_release_Obj.Status__c ='Draft';
          order_entry_release_Obj.Scheduled_Ship_Date__c = System.today() + 20;
         insert order_entry_release_Obj;
            
            
             Order_Entry_Line__c  orl = new Order_Entry_Line__c(Quantity__c=10,Order_Entry_Release__c=order_entry_release_Obj.id,Shipment_Date__c=system.today(),Status__c='Draft');
   //    insert orl;
       
         
        }
    
        
static testMethod void TestMethod1(){
        
    Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
        'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
        'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
    Test.startTest();
    
    //IGU_Imperial
    recordtype OERrecid = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Release__c' and DeveloperName =: Label.CSS_Hardware limit 1];
    recordtype OELrecid1 = [select id,name,DeveloperName,sObjectType from recordtype where sObjectType='Order_Entry_Line__c' and DeveloperName =: Label.CSS_Hardware limit 1];
    recordtype OELrecid2 = [select id,name,DeveloperName from recordtype where DeveloperName = 'IGU_Metric' limit 1];

    Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
 
    Opportunity testMOUOpportunityObj = new Opportunity();
    testMOUOpportunityObj.Name = 'testOppty';
    testMOUOpportunityObj.CloseDate = Date.today();
    testMOUOpportunityObj.StageName = 'POC Stage';
    testMOUOpportunityObj.RecordTypeId = opptyRecordtype;
    testMOUOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
    testMOUOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
    insert testMOUOpportunityObj;
    
     
    Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
    Opportunity testOpportunityObj = new Opportunity();
    testOpportunityObj.Name = 'testOppty';
    testOpportunityObj.CloseDate = Date.today();
    testOpportunityObj.StageName = 'POC Stage';
    testOpportunityObj.RecordTypeId = opptyProjectRecordtype;  
    testOpportunityObj.Winning_Projects_Total_Sq_Ft__c = 10;
    testOpportunityObj.Winning_Total_of_IGUs__c = 2;
    testOpportunityObj.IGU_Total_Amount__c = 10;
    testOpportunityObj.BOS_Total_Amount__c = 10;
    testOpportunityObj.MOU_Opportunity__c = testMOUOpportunityObj.Id;
    testOpportunityObj.Regional_Vice_President__c = UserInfo.getUserId();
    testOpportunityObj.Support_Region__c='Atlanta/Carolinas';
    testOpportunityObj.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;
    insert testOpportunityObj;      
    

    account acc = new account();
    acc.name = 'View Inc';
     acc.BillingStreet ='1482 Cliveden Ave.' ;
     acc.BillingCity ='Delta' ;
     acc.BillingState = 'British Columbia';
     acc.BillingPostalCode ='V3M 6K2' ;
    acc.BillingCountry = 'Canada';
      acc.Shippingstreet  = 'sample street';
    acc.ShippingCity   = 'city';
    acc.ShippingCountry   = 'sample Country';
    acc.ShippingPostalCode   = '12345';
    acc.ShippingState   = 'USA';
    acc.Oracle_Customer_Number__c   ='3591';
    insert acc;

    contact con = new contact();
    con.LastName = 'Test Contact';
    con.AccountId = acc.id;
    con.Email = 'test_view@testview.com';
    insert con;
    
SKU_Prefix_Element_Map__c eleMap;
    List<SKU_Prefix_Element_Map__c> lstEleMap = new List<SKU_Prefix_Element_Map__c>();
    List<String> eleMapName = new List<String>{'Generation', 'Laminate', 'Color', 'Shape', 'Panes'};
    
    for(Integer i = 0; i<5; i++) {
        eleMap = new SKU_Prefix_Element_Map__c();
        eleMap.Name = eleMapName[i];
        lstEleMap.add(eleMap);
    }
    insert lstEleMap;
    
    SKU_Prefix_Element_Map_Entry__c eleMapEntry;
    List<SKU_Prefix_Element_Map_Entry__c> lstEleMapEntry = new List<SKU_Prefix_Element_Map_Entry__c>();
    List<String> lstMapValue = new List<String>{
        '2', 'NO', 'CLR (CLEAR)', 'SHAPE','DOUBLE'
    };
    for(Integer i = 0; i<5; i++) {
        eleMapEntry = new SKU_Prefix_Element_Map_Entry__c();
        eleMapEntry.Name = lstMapValue[i];
        eleMapEntry.Map_to_Value__c = '0'+i;
        eleMapEntry.SKU_Prefix_Element_Map__c = lstEleMap[i].Id;
        lstEleMapEntry.add(eleMapEntry);
    }
    
    insert lstEleMapEntry;
List<Product2> productsample = NEW List<Product2>();
 Product2 testProductObj = new Product2();
    testProductObj.Name = 'Test Product';
    //*******COMMENTING THIS LINE AS PART OF BOS REFERENCE UPDATES WITH CSS
    //testProductObj.Family  = 'BOS';
    testProductObj.Family  = 'CSS';
    testProductObj.Generation__c  = '2';
    testProductObj.Laminate__c = 'No';
    testProductObj.Panes__c = 'Double';
    testProductObj.Inboard_Lite__c = 'CLR (Clear)';
    testProductObj.Spacer__c = '1/2" 90% Argon';
    testProductObj.Inboard_Thickness__c = '6MM';
    testProductObj.Shape__c = 'Shape';
    testProductObj.Inboard_Treatment__c = 'T (Tempered)';
    testProductObj.Spacer_Type__c = 'TRISEAL FOAM';
    testProductObj.Spacer_Thickness__c = '1/2" (12.7 mm.)';
    testProductObj.Spacer_Fill__c = '90% Argon';
    testProductObj.Outboard_Lite__c = '6MM EC #2 CLR T';
    testProductObj.Edge_Black__c = 'NONE';
    testProductObj.Outboard_Treatment__c = 'T (Tempered)';
    testProductObj.Bird_Friendly__c = 'No';
    testProductObj.Pig_Tail__c = 'KEYED M8';
    testProductObj.IGU_Overall_Thickness__c = 1;
    testProductObj.Secondary_Seal_Color__c = 'Black';
    testProductObj.Secondary_Seal_Type__c = 'SI';
    insert testProductObj;
productsample.add(testProductObj);
    RecordType qrt = [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Budgetary_Estimate' LIMIT 1];
 SBQQ__Quote__c quote=new SBQQ__Quote__c();
    quote.Quote_Approval_Type__c = 'Pricing Approval'; 
    quote.First_Ship_Date__c = system.today();
    quote.Detailed_Summary_of_Deal__c = 'test';
    quote.RecordTypeId=qrt.id;
    quote.Are_you_using_Plenum__c='No';
    quote.Quote_Plan__c='All In';
   // quote.SBQQ__SalesRep__c='0050L0000096RtS';
    quote.SBQQ__Account__c = acc.id;
    quote.SBQQ__PrimaryContact__c = con.Id;
    quote.Primary_Contact_E_Mail__c = 'meghna.sharma@viewglass.com';  
quote.Related_Opportunity__c = testOpportunityObj.Id;
    insert quote;
    system.debug('^^^^^^^^^^'+quote.id);
     List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>();  
    system.debug('%%%%quote%%%%'+quote+quote.Total_IGU_s_QL__c+'999999999'+quote.BOS_Total_Sq_Ft__c);
    SBQQ__QuoteLine__c qtLine=new SBQQ__QuoteLine__c();
    //*******COMMENTING THIS LINE AS PART OF BOS REFERENCE UPDATES WITH CSS
    //qtline.Product_Family_CPQ__c = 'BOS';
    qtline.Product_Family_CPQ__c = 'CSS';
    qtline.BOS_Non_Operable__c = True;
    qtLine.SBQQ__Quote__c=quote.Id;
qtLine.SBQQ__Product__c = testProductObj.Id;
    qtLine.No_of_IGU_s__c = 3000;
    qtLine.SBQQ__Quantity__c = 20000;
   insert qtLine;
 qliList.add(qtLine);
 Test.stopTest();
    Order_Entry_Release__c oer = new Order_Entry_Release__c(Shipping_Account__c   = acc.id,Billing_Account__c   = acc.id,Sold_to_Account__c = acc.id ,Shipping_Name__c = 'Envision Global Inc.', Shipping_Street_1__c = '1850 Kingsway Ave.', 
                        Shipping_City__c = 'Port Coquitlam', Shipping_Postal_Code__c = 'V3C 1S6',recordtypeid = OERrecid.id,
                        Shipping_State_Province__c = 'BC', CPQ_Quote__c = quote.id, Shipping_Country__c = 'CANADA',Opportunity__c=testOpportunityObj.id,Release_Name__c='test');
//     try{
      insert oer;
//    }catch(exception e){}
         
    Integer oelQuantity = 5;
        String oelShape;
        String oelBase;
        String oelHeight;
        String oelBaseHeight;
    
    Order_Entry_Line__c test22 = new Order_Entry_Line__c(Order_Entry_Release__c = oer.Id, Quantity__c = oelQuantity, Base_In__c = oelBase, Height_In__c = oelHeight,
                        Base_Height_1_In__c = oelBaseHeight, Shape__c = oelShape, recordtypeid = OELrecid1.id, Status__c = 'Draft', 
                        Integration_Status__c = 'Initial', Trigger_Source__c = 'UI', CPQ_Quote_Line__c = qliList[0].Id, Product__c = qliList[0].SBQQ__Product__c, 
                        Order_Line_Type__c = 'Product', Mark_Ids__c = 'C-' + String.valueOf(XMath.getRandomInt(10)) + '/' +
                        String.valueOf(XMath.getRandomInt(100)), Shipping_Name__c = oer.Shipping_Name__c, Shipping_Street_1__c = oer.Shipping_Street_1__c, 
                        Shipping_Account__c = oer.Shipping_Account__c, Shipping_City__c = oer.Shipping_City__c, Shipping_Postal_Code__c = oer.Shipping_Postal_Code__c,
                        Shipping_State_Province__c = oer.Shipping_State_Province__c, Shipping_Country__c = oer.Shipping_Country__c, Use_Account_Shipping_Address__c = true,
                        Installation_Type__c = 'Commercial', Line_Number__c = 1,Base_Decimal_In__c= 2,Height_Decimal_In__c = 1);
                        
   
    IssueTriggerHelper.deletemethod(); 
    try{            
         insert test22;   
Case caseRec=[select id,opportunity__c from Case limit 1];
          caseRec.opportunity__c =testOpportunityObj.id;
           caseRec.AccountId= acc.id;
          update caseRec;
          
          Issue__c issue= new Issue__c(Issue_Status__c='Open',Opportunity__c=CaseRec.opportunity__c,Product_Replacement__c=true,
                                            Ownership__c='View',Lite_ID_Mock_ID__c='Lite ID',
                                            Reason_for_Replacement__c='Non-compliant Product',Requested_Delivery_Date__c=Date.today()+10,
                                            Date_Identified__c=date.today(),Recordtypeid=Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId(),Want_to_Order_Existing_Makeup__c='No',
                                     Case__c=CaseRec.Id,Quantity__c = 10,Create_Box_Folder__c=true,product__c = testProductObj.id);
          
         
    } catch(Exception e)
    {
       System.debug(e.getMessage());
        Boolean expectedExceptionThrown =  e.getMessage().contains('Base (in.) may not be null') ? true : false;
       // System.AssertEquals(expectedExceptionThrown, true);
        
    }   

 }
   
}