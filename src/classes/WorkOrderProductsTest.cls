@IsTest
private class WorkOrderProductsTest{
    /*
* setupTestdata : sets the test data
*/
    @testSetup static void setupTestdata(){
        
        Boolean failureModeInWarranty = false;
        Boolean failureModeOfCustomerObjection = false;
        
        Case newCase = new Case(Subject = 'Unittest',Status = 'New');
        database.insert(newCase);
        
        Opportunity newOpp = new Opportunity(Name = 'testOpp', CloseDate = date.valueOf( '2020-07-07' ), StageName = 'Customer Decision', LeadSource = 'Trade Show Name');
        database.insert(newOpp);
        
        Issue__c issue= new Issue__c(Zone_Name__c='test',Case__c =newCase.Id,Product_Under_Warranty__c='Yes',
                                     Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='No',Manually_updated_Warranty_Type__c = true);
        database.insert(issue);
        
        Failure_Mode__c fm = new Failure_Mode__c(Name ='test101',In_Warranty__c=false);
        Failure_Mode__c fm1 = new Failure_Mode__c(Name ='test102');
        database.insert(new list<Failure_Mode__c>{fm,fm1});
        
        Issue_Failure_Mode__c ifm= new Issue_Failure_Mode__c(Failure_Mode__c = fm.id,Issue__c=issue.id);
        database.insert(ifm);
    }
    
    @IsTest static void createIssueFailureModeSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            
            Issue__c issue = [select id from Issue__c where Zone_Name__c= 'test']; 
            List<Failure_Mode__c> selectedFailureMode = [Select id,Name,In_Warranty__c from Failure_Mode__c where Name ='test101'];
            test.starttest();
            try{
                WorkOrderProducts.createIssueFailureMode(null,null,null,null,null);
                WorkOrderProducts.createIssueFailureMode(null,issue.Id,selectedFailureMode,true,null);
                test.stopTest();
            }
            catch(exception e){
            }
            issue.Failure_Mode_Under_Warranty__c = 'Yes';
            update issue;
        }
    }
    
    @IsTest static void createIssueFailureModeSuccessWithoutAllTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
                    
            Failure_Mode__c fm2 = new Failure_Mode__c(Name ='test102 Customer Objection',In_Warranty__c=false);
            Insert fm2;
            System.debug('fm2' +fm2);

            List<Failure_Mode__c> selectedFailureMode2 = [Select id,In_Warranty__c,name from Failure_Mode__c where Name ='test102 Customer Objection'];
            
            Issue__c issue = [select id,Failure_Mode_Under_Warranty__c,Product_Under_Warranty__c,Manually_updated_Warranty_Type__c from Issue__c where Zone_Name__c= 'test']; 
            test.starttest();
            try{
                WorkOrderProducts.createIssueFailureMode(new List<string>{selectedFailureMode2.get(0).Id},issue.Id,selectedFailureMode2,false,null);
                test.stopTest();
            }
            catch(exception e){
            }
            issue.Failure_Mode_Under_Warranty__c = 'Yes';
            issue.Failure_Mode_of_Customer_Objection__c = true;
            update issue;
        }
    }
    
    @IsTest static void getProductListTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            List<Failure_Mode__c> productlist; 
            test.starttest();
            productlist =WorkOrderProducts.getProductList(null);
            test.stopTest();
            System.assertEquals(true,productlist.isEmpty());        
        }
    }
    
    @IsTest static void getProductListErrorTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('Project Manager','atestOwner2@test.demo');
        System.runAs(u1) {
            List<Failure_Mode__c> productlist; 
            test.starttest();
            try{
                productlist =WorkOrderProducts.getProductList(null);
            }
            catch(exception e){}
            test.stopTest();
        }
    } 
    
    @IsTest static void getProductListSuccessTest(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        System.runAs(u1) {
            List<Failure_Mode__c> productlist; 
            Issue__c issue = [select id from Issue__c where Zone_Name__c= 'test']; 
            test.starttest();
            productlist =WorkOrderProducts.getProductList(issue.Id);
            test.stopTest();
            System.assertEquals(false,productlist.isEmpty());        
        }
    }
    
     @IsTest static void updateIssueOnFailureModeDeleteTest(){
        List<Failure_Mode__c> selectedFailureMode = new List<Failure_Mode__c>();
        
        Failure_Mode__c fm1 = new Failure_Mode__c(Name ='test1',In_Warranty__c=false);
        Insert fm1;
        Failure_Mode__c fm2 = new Failure_Mode__c(Name ='test2');
        Insert fm2;
        
        selectedFailureMode.add(fm1);
        selectedFailureMode.add(fm2);

        case newCase = [select id from case limit 1];
         
        opportunity newOpp = [select id from opportunity limit 1];    
         
        Issue__c issue= new Issue__c(Zone_Name__c='test',Case__c =newCase.Id,Product_Under_Warranty__c='Yes',
                                     Failure_Mode_of_Customer_Objection__c=true,Failure_Mode_Under_Warranty__c='Yes',Opportunity__c = newOpp.id);
        database.insert(issue);
        
        Issue_Failure_Mode__c ifm = new Issue_Failure_Mode__c(Failure_Mode__c=selectedFailureMode.get(0).Id,
                                                              Issue__c=issue.id);
        
        Issue_Failure_Mode__c ifm1 = new Issue_Failure_Mode__c(Failure_Mode__c=selectedFailureMode.get(1).Id,
                                                               Issue__c=issue.id);
        
        database.insert(new List<Issue_Failure_Mode__c>{ifm});
        test.starttest();

        database.delete(ifm);
       //  database.delete(ifm1);
        database.insert(new List<Issue_Failure_Mode__c>{ifm1});
        issue.Failure_Mode_Under_Warranty__c = 'Yes';
        issue.Failure_Mode_of_Customer_Objection__c = true;
        update issue;
        test.stoptest();
    } 
}