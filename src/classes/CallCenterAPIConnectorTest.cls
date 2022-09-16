@isTest
Private class CallCenterAPIConnectorTest {
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        string result = CallCenterAPIConnector.doGet();
//         String expectedResult = 'https://cs93.salesforce.com/services/data/v29.0/analytics/reports/00O0h000006eUrm';
     String expectedResult = 'https://login.salesforce.com/services/data/v29.0/analytics/reports/00O0h000006eUrm';
         
           
    }
}