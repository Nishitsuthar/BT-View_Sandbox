@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock 
{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
      //  response.setBody('{" https://cs93.salesforce.com/services/data/v29.0/analytics/reports/00O0h000006eUrm"}');
         response.setBody('{" https://login.salesforce.com/services/data/v29.0/analytics/reports/00O0h000006eUrm"}');
        response.setStatus('new');
        response.setStatusCode(200);
        return response;
        
    }
}