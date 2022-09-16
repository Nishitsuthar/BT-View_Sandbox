@isTest
global class HttpMockClassResponceGenarator implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        
        if(SmartSheetUtil.validationContext == 'OpportunityTesting') {
            StaticResource static_resource = [SELECT Id, SystemModStamp, Name, Body FROM StaticResource WHERE Name = 'Smartsheet_Test_Response' LIMIT 1];
            string JsonString = static_resource.Body.toString();       
            JsonString = JsonString.replace('{{OPP_ID_PLACE_HOLDER}}', String.valueOf([SELECT Id FROM Opportunity LIMIT 1].Id));
            res.setHeader('Content-Type', 'application/json');
            res.setBody(JsonString);
            res.setStatusCode(200);
            res.setStatus('Success');
        }else if(SmartSheetUtil.validationContext == 'CaseTesting'){
            StaticResource static_resource = [SELECT Id, SystemModStamp, Name, Body FROM StaticResource WHERE Name = 'Sample_Test_CaseResponce' LIMIT 1];
            string JsonString = static_resource.Body.toString();       
            JsonString = JsonString.replace('{{Case_ID_PLACE_HOLDER}}', String.valueOf([SELECT Id FROM Case LIMIT 1].Id));
            res.setHeader('Content-Type', 'application/json');
            res.setBody(JsonString);
            res.setStatusCode(200); 
            res.setStatus('Success');
        }else if(SmartSheetUtil.validationContext == 'Sample_Test_EmailOppResponse'){
            StaticResource static_resource = [SELECT Id, SystemModStamp, Name, Body FROM StaticResource WHERE Name = 'Sample_Test_EmailOppResponse' LIMIT 1];
            string JsonString = static_resource.Body.toString();       
            JsonString = JsonString.replace('{{OPP_ID_PLACE_HOLDER}}', String.valueOf([SELECT Id FROM Opportunity LIMIT 1].Id));
            //system.debug('CASEID'+ [SELECT Id FROM Case LIMIT 1]);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(JsonString);
            res.setStatusCode(200);      
            res.setStatus('Success');
        }else if(SmartSheetUtil.validationContext == 'Sample_Test_RemovingStardDate'){
            StaticResource static_resource = [SELECT Id, SystemModStamp, Name, Body FROM StaticResource WHERE Name = 'Sample_Test_ErrorRows' LIMIT 1];
            string JsonString = static_resource.Body.toString();       
            JsonString = JsonString.replace('{{OPP_ID_PLACE_HOLDER}}', String.valueOf([SELECT Id FROM Opportunity LIMIT 1].Id));
            //system.debug('CASEID'+ [SELECT Id FROM Case LIMIT 1]);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(JsonString);
            res.setStatusCode(200);      
            res.setStatus('Success');
        }else if(SmartSheetUtil.validationContext == 'CaseFailTesting'){
            StaticResource static_resource = [SELECT Id, SystemModStamp, Name, Body FROM StaticResource WHERE Name = 'Sample_Test_CaseFailResponse' LIMIT 1];
            string JsonString = static_resource.Body.toString();       
            JsonString = JsonString.replace('{{Case_ID_PLACE_HOLDER}}', String.valueOf([SELECT Id FROM Case LIMIT 1].Id));
            res.setHeader('Content-Type', 'application/json');
            res.setBody(JsonString);
            res.setStatusCode(200);   
            res.setStatus('Success');
        }else{
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"message":"SUCCESS"}');
            res.setStatusCode(200);   
            res.setStatus('Success');
        }
        return res;
    }
}