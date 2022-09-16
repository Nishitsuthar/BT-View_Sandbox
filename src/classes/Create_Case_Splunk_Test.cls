@isTest
public class Create_Case_Splunk_Test {

    
    @testsetup
    public static void testData() {
        
         Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
         Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();

        Account acc = new Account();
            acc.Name='test';
            acc.BillingCity='Livermore';
            acc.BillingCountry='USA';
            acc.BillingPostalCode='94550';
            acc.BillingState='CA';
            acc.BillingStreet='6400 Brisa Street';
            acc.Oracle_Customer_Number__c ='123';
            acc.ShippingCity='Livermore';
            acc.ShippingCountry='USA';
            acc.ShippingPostalCode='94550';
            acc.ShippingState='CA';
            acc.ShippingStreet='6400 Brisa Street';
        insert acc;
        
        Opportunity testMOUOpportunityObj = new Opportunity();
            testMOUOpportunityObj.Name = 'testOpptyParent';
            testMOUOpportunityObj.CloseDate = Date.today();
            testMOUOpportunityObj.StageName = 'POC Stage';
            testMOUOpportunityObj.RecordTypeId = opptyRecordtype; 
            testMOUOpportunityObj.AccountId= acc.id;
        insert testMOUOpportunityObj;
        
        Building__c bulDet = new Building__c();
            bulDet.Name = 'Building One View';
            bulDet.CurrencyIsoCode = 'USD';
        insert bulDet;
        
        Building_Account__c bulAcc = new Building_Account__c();
            bulAcc.Name = 'Building Account One View';
            bulAcc.Account__c = acc.id;
            bulAcc.Opportunity__c = testMOUOpportunityObj.Id;
            bulAcc.Building__c = bulDet.Id; 
        insert bulAcc;
        
}

    static testmethod void toCallPost()
    {
        
        List<Create_Case_Splunk.CaseRequest> rawDataCall = new List<Create_Case_Splunk.CaseRequest>();
        List<Create_Case_Splunk.CaseResponse> response = new List<Create_Case_Splunk.CaseResponse>();
        
        Building_Account__c qBuildAccount = [Select id,Building_Location_ID__c FROM Building_Account__c];
        
        Create_Case_Splunk.CaseRequest rawData = new Create_Case_Splunk.CaseRequest();        
            rawData.caseSubject = 'Test from DT Post External ID';
            rawData.locationId = qBuildAccount.Building_Location_ID__c;
            rawData.caseDescription = 'Testing from DT';
            rawData.caseEventId = '12334554';
            rawData.caseObjectReference = '8098080U9WE8';
        	rawData.splunkId = '9977663237';
        rawDataCall.add(rawData);
        
        
        Test.startTest();
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();             
                        req.requestURI = '/services/apexrest/createCaseFromSplunk';
                        req.httpMethod = 'POST';
                RestContext.request = req;
                RestContext.response= res;
        
        response = Create_Case_Splunk.doPost(rawDataCall);
        Test.stopTest();
    }
}