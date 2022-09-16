public without sharing class VIS_GC_Subcontractor_Ctrl {
    @AuraEnabled
    public static innerClass getAccount(string AccountId){
        List<Account> accountList = [select id,Name,
                                     buildertek__Alternate_Name__c,
                                     buildertek__Type_of_Company__c,
                                     buildertek__Year_Established__c,
                                     Phone,
                                     Company_Type__c,
                                     Worker_Compensation_Coverage__c,
                                     Website,
                                     buildertek__Bid_Limit__c,
                                     buildertek__General_Liability_Coverage__c,
                                     buildertek__Number_of_Employees__c,
                                     buildertek__Service_Are__c,
                                     Additional_Information__c,
                                     Completed_By__c,
                                     Title__c,
                                     Foreman_Cell_Phone__c,Foreman_Certifications__c,Foreman_Email_Address__c,Foreman_Name__c,
                                     Project_Manager_Name__c,Project_Manager_Email_Address__c,Project_Manager_Cell_Phone__c,Project_Manager_Certifications__c,
                                     Office_Administrator_Name__c,Office_Administrator_Email_Address__c,Office_Administrator_Cell_Phone__c,Office_Administrator_Certifications__c,
                                     Estimator_Cell_Phone__c,Estimator_Certifications__c,Estimator_Email_Address__c	,Estimator_Name__c,
                                     Second_Owner_Name__c,Second_Owner_Email_Address__c,Second_Owner_Cell_Phone__c,First_Owner_Name__c,First_Owner_Email_Address__c,First_Owner_Cell_Phone__c,
                                     Contractor_License_State1__c,Contractor_License_Number1__c,Contractor_License_Number2__c,Contractor_License_State2__c,Contractor_License_Number3__c,Contractor_License_State3__c,
                                     buildertek__Office_Address__c,buildertek__City__c,buildertek__State__c,buildertek__ZipCode__c,Contract_date__c,Completed_Date__c
                                     from Account
                                     
                                     Where Id=:AccountId];
        system.debug('AccountId'+AccountId);
        system.debug('accountList'+accountList);
        List<Project__c> projectlist = [select id,Project_Name__c,Date_Completed__c,Contractor_Name__c,Contract_Value__c,Contact_Name__c,Contact_Email__c,Contact_Cell__c from Project__c where Account__c=:AccountId];
        List<Reference__c> referencelist =[select  id,Company_Name__c,Address__c,State__c,City__c,Zip__c,Contact_Name__c,Email__c,Cell_Phone__c from Reference__c where Account__c=:AccountId];
        // system.debug('accountList[0]'+accountList[0]);
        innerClass inn = new innerClass();
        if(accountList.size()>0){	
            inn.acc = accountList[0];
        }
        inn.proj = projectlist;
        inn.ref =  referencelist;
        return inn;
        
        
    }
    
    
    
    
    @AuraEnabled
    public static FileUploadWrapper updateAcc(String ac,string projectlist1,string projectlist2,string projectlist3,string refList1,string refList2,string refList3,string isClear,string AccountID,Id project1Id,Id project2Id,Id project3Id,Id reference1Id,Id reference2Id,Id reference3Id){
        system.debug('ac'+ac);
        try{
            List<ContentVersion> contentVersionList = new List<ContentVersion>();
            Account act = [select id,name,buildertek__Box_Folder_Id__c from Account where id =:AccountID];
            
            
            //ParameterResponseClass boxdatalist = (ParameterResponseClass)System.JSON.deserialize(boxData, ParameterResponseClass.class);
            string clientid = buildertek__Box_Settings__c.getValues('BOX API').buildertek__Client_Id__c;
            string client_secret = buildertek__Box_Settings__c.getValues('BOX API').buildertek__Client_Secret__c;
            string ViewAPI_Key = buildertek__Box_Settings__c.getValues('BOX API').buildertek__API_Key__c;
            string AccessToken = buildertek__Box_Settings__c.getValues('BOX API').buildertek__Access_Token__c;
            string RefreshToken = buildertek__Box_Settings__c.getValues('BOX API').buildertek__Refresh_Token__c;
            string EnterpriceId = buildertek__Box_Settings__c.getValues('BOX API').buildertek__Enterprise_ID__c;
            
            FileUploadWrapper fileWrapper = new FileUploadWrapper();
            string Response1='';
            string Response='';
            
            string endPointURL;
            //string RefreshToken;
            /*code to get access token*/
            HttpRequest req1 = new HttpRequest();
            //endPointURL='https://app.box.com/api/oauth2/token?code='+Authcode+'&client_id='+clientid+'&client_secret='+client_secret+'&grant_type=authorization_code';
            endPointURL='https://app.box.com/api/oauth2/token?';
            System.debug('******endPointURL:'+endPointURL);
            req1.setEndpoint(endPointURL);
            req1.setMethod('POST');
            req1.setHeader('Content-Type','application/x-www-form-urlencoded');
            String bb='grant_type=authorization_code';
            
            req1.setbody('grant_type=client_credentials'+
                         '&box_subject_type=enterprise'+
                         '&box_subject_id='+EnterpriceId+
                         '&client_id='+clientid+
                         '&client_secret='+client_secret);
            req1.setHeader('Accept','application/json');
            Http http = new Http();
            HTTPResponse res1 = http.send(req1);
            Response=res1.getBody();
            Integer statusCode=res1.getStatusCode();
            System.debug(Response);
            // Parse JSON response to get refresh_token values.
            JSONParser parser = JSON.createParser(Response);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'access_token') {
                        AccessToken= parser.getText();
                    }if(fieldName == 'refresh_token') {
                        RefreshToken= parser.getText();
                    }
                }
                String boundary = '----------------------------741e90d31eff';
                fileWrapper.boxFolderId = act.buildertek__Box_Folder_Id__c;
                fileWrapper.accessToken = accessToken;
                fileWrapper.boundary = boundary; 
                // }
                
                
            }
            
            
            
            
            
            
            system.debug('@@@ACC'+ac);
            system.debug('refList2'+refList2);
            system.debug('refList1'+refList1);
            List<Project__c> projectlist = [select id,Project_Name__c,Date_Completed__c,Contractor_Name__c,Contract_Value__c,Contact_Name__c,Contact_Email__c,Contact_Cell__c from Project__c where Account__c=:AccountId];
            //{
            if(isClear == 'false'){
                
                Account convertAccount = (Account)JSON.deserialize((ac),Account.Class);
                convertAccount.buildertek__Qualification_Stage__c = 'Email Received';
                update convertAccount;
                
                if(projectlist1 != null){
                    Project__c convertProject1 = (Project__c)JSON.deserialize((projectlist1),Project__c.Class);
                    convertProject1.Account__c = convertAccount.id;
                    upsert convertProject1;
                }
                
                if(projectlist2 != null){
                    Project__c convertProject2 = (Project__c)JSON.deserialize((projectlist2),Project__c.Class);
                    convertProject2.Account__c = convertAccount.id;
                    upsert convertProject2;
                }
                
                
                if(projectlist3 != null){
                    Project__c convertProject3 = (Project__c)JSON.deserialize((projectlist3),Project__c.Class);
                    convertProject3.Account__c = convertAccount.id;
                    upsert convertProject3;
                }
                
                
                if(refList1 != null){
                    Reference__c convertRef1 = (Reference__c)JSON.deserialize((refList1),Reference__c.Class);
                    convertRef1.Account__c = convertAccount.id;
                    upsert convertRef1;
                }
                
                
                if(refList2 != null){
                    Reference__c convertRef2 = (Reference__c)JSON.deserialize((refList2),Reference__c.Class);
                    convertRef2.Account__c = convertAccount.id;
                    upsert convertRef2;
                }
                
                
                if(refList3 != null){
                    Reference__c convertRef3 = (Reference__c)JSON.deserialize((refList3),Reference__c.Class);
                    convertRef3.Account__c = convertAccount.id;
                    upsert convertRef3;
                }
                //return 'Account updated successfully';
                
            }else if(isClear == 'true'){
                Account acc = new Account();
                acc.id = AccountID;
                acc.buildertek__Alternate_Name__c = '';
                acc.buildertek__Type_of_Company__c = '';
                acc.buildertek__Year_Established__c = '';
                acc.Phone = '';
                acc.Website ='';
                acc.buildertek__Bid_Limit__c =null;
                acc.buildertek__General_Liability_Coverage__c = null;
                acc.buildertek__Number_of_Employees__c = null;
                acc.buildertek__Service_Are__c = null;
                acc.Additional_Information__c ='';
                acc.Completed_By__c ='';
                acc.Title__c ='';
                acc.Company_Type__c='';
                acc.Worker_Compensation_Coverage__c ='';
                acc.Foreman_Cell_Phone__c='';acc.Foreman_Certifications__c='';acc.Foreman_Email_Address__c='';acc.Foreman_Name__c='';
                acc.Project_Manager_Name__c='';acc.Project_Manager_Email_Address__c='';acc.Project_Manager_Cell_Phone__c='';acc.Project_Manager_Certifications__c='';
                acc.Office_Administrator_Name__c='';acc.Office_Administrator_Email_Address__c='';acc.Office_Administrator_Cell_Phone__c='';acc.Office_Administrator_Certifications__c = '';
                acc.Estimator_Cell_Phone__c='';acc.Estimator_Certifications__c='';acc.Estimator_Email_Address__c='';acc.Estimator_Name__c='';
                acc.Second_Owner_Name__c ='';acc.Second_Owner_Email_Address__c='';acc.Second_Owner_Cell_Phone__c='';acc.First_Owner_Name__c='';acc.First_Owner_Email_Address__c='';acc.First_Owner_Cell_Phone__c='';
                acc.Contractor_License_State1__c='';acc.Contractor_License_Number1__c='';acc.Contractor_License_Number2__c='';acc.Contractor_License_State2__c='';acc.Contractor_License_Number3__c='';acc.Contractor_License_State3__c='';
                acc.buildertek__Office_Address__c='';acc.buildertek__City__c='';acc.buildertek__State__c='';acc.buildertek__ZipCode__c='';acc.Contract_date__c=null;acc.Completed_Date__c=null;
                update acc;
                Account convertAccount = (Account)JSON.deserialize((ac),Account.Class);
                convertAccount.buildertek__Qualification_Stage__c = 'Email Received';
                update convertAccount;
                
                // if(projectlist.size()>0){
                system.debug('@#$'+project1Id);
                if(project1Id != null ){
                    Project__c pr1 = new Project__c();
                    pr1.Id =project1Id;
                    pr1.Project_Name__c = '';
                    pr1.Date_Completed__c = null;pr1.Contractor_Name__c='';pr1.Contract_Value__c='';pr1.Contact_Name__c='';pr1.Contact_Email__c='';pr1.Contact_Cell__c='';
                    pr1.Account__c = AccountID; 
                    update pr1;
                }
                if(projectlist1 != null){
                    Project__c convertProject1 = (Project__c)JSON.deserialize((projectlist1),Project__c.Class);
                    convertProject1.Account__c = convertAccount.id;
                    upsert convertProject1;
                }
                
                
                if(project2Id != null){
                    Project__c pr2 = new Project__c();
                    pr2.Id =project2Id;
                    pr2.Project_Name__c = '';
                    pr2.Date_Completed__c = null;pr2.Contractor_Name__c='';pr2.Contract_Value__c='';pr2.Contact_Name__c='';pr2.Contact_Email__c='';pr2.Contact_Cell__c='';
                    pr2.Account__c = AccountID; 
                    update pr2;
                }
                if(projectlist2 != null){
                    Project__c convertProject2 = (Project__c)JSON.deserialize((projectlist2),Project__c.Class);
                    convertProject2.Account__c = convertAccount.id;
                    upsert convertProject2;
                }
                
                
                if(project3Id != null){
                    Project__c pr3 = new Project__c();
                    pr3.Id =project3Id;
                    pr3.Project_Name__c = '';
                    pr3.Date_Completed__c = null;pr3.Contractor_Name__c='';pr3.Contract_Value__c='';pr3.Contact_Name__c='';pr3.Contact_Email__c='';pr3.Contact_Cell__c='';
                    pr3.Account__c = AccountID; 
                    update pr3;
                }
                if(projectlist3 != null){
                    Project__c convertProject3 = (Project__c)JSON.deserialize((projectlist3),Project__c.Class);
                    convertProject3.Account__c = convertAccount.id;
                    upsert convertProject3;
                }
                if(reference1Id != null ){
                    system.debug('reference1Id'+reference1Id);
                    Reference__c rf1 = new Reference__c();
                    rf1.Id =reference1Id;
                    rf1.Company_Name__c = '';
                    rf1.Address__c = '';rf1.State__c='';rf1.City__c='';rf1.Zip__c='';rf1.Contact_Name__c='';rf1.Email__c='';rf1.Cell_Phone__c='';
                    rf1.Account__c = AccountID; 
                    update rf1;
                    system.debug(rf1);
                }
                if(refList1 != null){
                    Reference__c convertRef1 = (Reference__c)JSON.deserialize((refList1),Reference__c.Class);
                    convertRef1.Account__c = convertAccount.id;
                    upsert convertRef1;
                }
                
                if(reference2Id != null ){
                    Reference__c rf2 = new Reference__c();
                    rf2.Id =reference2Id;
                    rf2.Company_Name__c = '';
                    rf2.Address__c = '';rf2.State__c='';rf2.City__c='';rf2.Zip__c='';rf2.Contact_Name__c='';rf2.Email__c='';rf2.Cell_Phone__c='';
                    rf2.Account__c = AccountID; 
                    update rf2;
                }
                if(refList2 != null){
                    Reference__c convertRef2 = (Reference__c)JSON.deserialize((refList2),Reference__c.Class);
                    convertRef2.Account__c = convertAccount.id;
                    upsert convertRef2;
                }
                
                if(reference3Id != null ){
                    Reference__c rf3 = new Reference__c();
                    rf3.Id =reference3Id;
                    rf3.Company_Name__c = '';
                    rf3.Address__c = '';rf3.State__c='';rf3.City__c='';rf3.Zip__c='';rf3.Contact_Name__c='';rf3.Email__c='';rf3.Cell_Phone__c='';
                    rf3.Account__c = AccountID; 
                    update rf3;
                }
                if(refList3 != null){
                    Reference__c convertRef3 = (Reference__c)JSON.deserialize((refList3),Reference__c.Class);
                    convertRef3.Account__c = convertAccount.id;
                    upsert convertRef3;
                }
                
            }
            return fileWrapper;
        }catch(Exception e){
            system.debug(e.getMessage());
            FileUploadWrapper fileWrapper = new FileUploadWrapper();
            fileWrapper.boundary = e.getMessage();
            return fileWrapper;
        }      
        
        
        
    }
    public class innerClass{
        @AuraEnabled public Account acc;
        @AuraEnabled public List<Project__c> proj;  
        @AuraEnabled public List<Reference__c> ref; 
    }
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(){
        String objectType ='Account';
        String selectedField = 'Company_Type__c';
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    public class FilesWrapper{
        public String fileName;
        public String fileContent;
        public String parentId;
        public String fileType;
        public Integer fileSize;
    }
    
    /*public static blob base64EncodeFileContent(string file_body, String file_name){
        String boundary = '----------------------------741e90d31eff';
        String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file_name+'";\nContent-Type: application/octet-stream';
        String footer = '--'+boundary+'--';             
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('='))
        {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String bodyEncoded = file_body;
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        
        if(last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else if(last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
        } else {
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            system.debug('headerEncoded ****' + headerEncoded);
            system.debug('bodyEncoded ****' + bodyEncoded);
            system.debug('footerEncoded ****' + footerEncoded);
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
        }
        
        return bodyBlob;
    }*/
    
    public static HTTPResponse sendHttpRequest(HTTPRequest req){
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('****response body:'+res.getBody());
        return res;
    }
    public class FileUploadWrapper{
        @AuraEnabled public String boxFolderId;
        @AuraEnabled public String accessToken;
        @AuraEnabled public String boundary;
        @AuraEnabled public Blob base64EncodeFileContent;
    }
    
    
    
    
}