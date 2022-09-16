@RestResource(urlmapping='/api/trial/*')

global class CallCenterAPIConnector{

    @HTTPGET
    global static string doGet(){

    

        Http http = new Http();

        HttpRequest httpReq = new HttpRequest();

        HttpResponse httpRes = new HttpResponse();
        

        httpReq.setMethod('GET');

        httpReq.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());

        httpReq.setEndpoint(

            URL.getSalesforceBaseUrl().toExternalForm()+

          //  '/services/data/v29.0/analytics/reports/' + '00O0v000000LXS6' +
              '/services/data/v29.0/analytics/reports/' + '00O0h000006eUrm' +

            '?includeDetails=true'

        );

        
        httpRes = http.send(httpReq);
        
        return httpRes.getBody();
    

    }

}