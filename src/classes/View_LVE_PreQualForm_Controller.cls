public without sharing class View_LVE_PreQualForm_Controller {

       public class ListViews {
        @AuraEnabled public List<FieldWrapper> generalInfoList {get;set;}
        @AuraEnabled public List<FieldWrapper> companyInfoList {get;set;}
        @AuraEnabled public List<FieldWrapper> KeyManagementList {get;set;}
        @AuraEnabled public List<FieldWrapper> LVEList {get;set;}
        @AuraEnabled public List<FieldWrapper> ContractorList {get;set;}
        @AuraEnabled public List<string> referencepickvalues {get;set;}
        @AuraEnabled public List<string> referencecountryvalues {get;set;}
        
    }
      
       
    @AuraEnabled
    public static ListViews RetrieveFieldsets() {
        List<FieldWrapper> generalInfo = getFieldSet('LVE_General_Information','buildertek__Pre_Qual__c');
        List<FieldWrapper> companyInfo = getFieldSet('LVE_Company_Information','buildertek__Pre_Qual__c');
        List<FieldWrapper> KeyManageInfo = getFieldSet('LVE_Key_Management','buildertek__Pre_Qual__c');
        List<FieldWrapper> LVEInfo = getFieldSet('LVE_Team','buildertek__Pre_Qual__c');
        List<FieldWrapper> ContractorInfo = getFieldSet('LVE_Contract_License','buildertek__Pre_Qual__c');
        
         String objectType ='buildertek__References__c';
        String selectedField = 'State__c';
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
       // return pickListValuesList;
        
        
        String selectedField2 = 'Country__c';
        List<String> pickListValuesList2 = new List<String>();
        Schema.SObjectType convertToObj2 = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res2 = convertToObj2.getDescribe();
        Schema.DescribeFieldResult fieldResult2 = res2.fields.getMap().get(selectedField2).getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple2){
            pickListValuesList2.add(pickListVal.getLabel());
        }
        
        
        
        ListViews fieldssetsList = new ListViews();
        fieldssetsList.generalInfoList = generalInfo;
        fieldssetsList.companyInfoList = companyInfo;
        fieldssetsList.KeyManagementList = KeyManageInfo;
        fieldssetsList.LVEList = LVEInfo;
        fieldssetsList.ContractorList = ContractorInfo;
        fieldssetsList.referencepickvalues = pickListValuesList;        
        fieldssetsList.referencecountryvalues = pickListValuesList2;
        system.debug(getFieldSet('LVE_Canada_General_Information','buildertek__Pre_Qual__c'));
        return fieldssetsList;
    }
    @AuraEnabled
    public static List<FieldWrapper> getFieldSet(String fieldSetName, String ObjectName) {
        List<FieldWrapper> lstfieldWrapper = new List<FieldWrapper>();
        if (String.isNotBlank(fieldSetName) && String.isNotBlank(ObjectName)) {
            Schema.DescribeSObjectResult describeSObjectResult = Schema.getGlobalDescribe().get(ObjectName).getDescribe();
            Map<String,Schema.SObjectField> objFieldMap = describeSObjectResult.fields.getMap();
            Schema.FieldSet fieldSetObj = describeSObjectResult.FieldSets.getMap().get(fieldSetName);
            if (fieldSetObj != null) {
                for(Schema.FieldSetMember fieldSet : fieldSetObj.getFields() ) {
                    lstfieldWrapper.add( new FieldWrapper(
                        String.ValueOf(fieldSet.getLabel()),
                        String.ValueOf(fieldSet.getFieldPath()), 
                        (fieldSet.getDBRequired() || fieldSet.getRequired()),
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().getInlineHelpText(),
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().isHtmlFormatted() &&
                        objFieldMap.get(String.ValueOf(fieldSet.getFieldPath())).getDescribe().isCalculated(),''
                    ));
                }
            }
        }
        return lstfieldWrapper; 
    }
    
    public class FieldWrapper {
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public String fieldLabel {get;set;}
        @AuraEnabled public Boolean isRequired {get;set;}
        @AuraEnabled public String helpText {get;set;}
        @AuraEnabled public Boolean isHtmlFormatted {get;set;}
        @AuraEnabled public String fieldValue {get;set;}
        
        
        public FieldWrapper(String fieldLabel,String fieldName,Boolean isRequired, String helpText, Boolean isHtmlFormatted,String fieldValue ) {
            this.fieldLabel  = fieldLabel;
            this.fieldName   = fieldName;
            this.isRequired  = isRequired;
            this.helpText    = helpText;
            this.isHtmlFormatted = isHtmlFormatted;
            this.fieldValue = fieldValue;
        }
    }
    
    public class FileUploadWrapper{
        @AuraEnabled public String boxFolderId;
        @AuraEnabled public String accessToken;
        @AuraEnabled public String boundary;
        @AuraEnabled public Blob base64EncodeFileContent;
        @AuraEnabled public string errorMessage {get;set;}
        @AuraEnabled public boolean isError {get;set;}
        @AuraEnabled public boolean  EnableBox;
    }
    
    @AuraEnabled
    public static FileUploadWrapper savePreQualData(String JsonString,string recordId,string projectlist1,string projectlist2,string projectlist3,string refList1,string refList2,string refList3) {
        buildertek__Pre_Qual__c act = [select id,name,buildertek__Box_Folder_Id__c from buildertek__Pre_Qual__c where id =:recordId];
                       List<buildertek__Pre_Qual_Settings__c> preQualSettings = [SELECT Id,buildertek__Enable_Box__c FROM buildertek__Pre_Qual_Settings__c Where name ='PreQualSettings' LIMIT 1];

        
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
        HttpRequest req1 = new HttpRequest();
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
            fileWrapper.isError = false;
            if(preQualSettings.size() > 0){
                fileWrapper.EnableBox = preQualSettings[0].buildertek__Enable_Box__c;
            }
            else{
                 fileWrapper.EnableBox = false;
            }
        }
        
        
       try{
        
        
        buildertek__Pre_Qual__c preQualRecord = (buildertek__Pre_Qual__c)JSON.deserialize((JsonString),buildertek__Pre_Qual__c.Class);
        preQualRecord.Id =recordId;
             preQualRecord.buildertek__Qualification_Stage__c = 'Email Received';
        Update preQualRecord;
        
        if(projectlist1 != null){
            system.debug('1');
        buildertek__Past_Project__c convertProject1 = (buildertek__Past_Project__c)JSON.deserialize((projectlist1),buildertek__Past_Project__c.Class);
        convertProject1.buildertek__Pre_Qual__c	 = preQualRecord.id;
        upsert convertProject1;
             system.debug(convertProject1.Id);
        }
        
         if(projectlist2 != null){
        buildertek__Past_Project__c convertProject2 = (buildertek__Past_Project__c)JSON.deserialize((projectlist2),buildertek__Past_Project__c.Class);
        convertProject2.buildertek__Pre_Qual__c	 = preQualRecord.id;
        upsert convertProject2;
         }
        
        
         if(projectlist3 != null){
          buildertek__Past_Project__c convertProject3 = (buildertek__Past_Project__c)JSON.deserialize((projectlist3),buildertek__Past_Project__c.Class);
          convertProject3.buildertek__Pre_Qual__c	 = preQualRecord.id;
          upsert convertProject3;
         }
        
        
        if(refList1 != null){
         buildertek__References__c convertRef1 = (buildertek__References__c)JSON.deserialize((refList1),buildertek__References__c.Class);
        convertRef1.buildertek__Pre_Qual__c	 = preQualRecord.id;
        upsert convertRef1;
        }
        
        
        if(refList2 != null){
         buildertek__References__c convertRef2 = (buildertek__References__c)JSON.deserialize((refList2),buildertek__References__c.Class);
        convertRef2.buildertek__Pre_Qual__c	 = preQualRecord.id;
        upsert convertRef2;
        }
        
        
        if(refList3 != null){
        buildertek__References__c convertRef3 = (buildertek__References__c)JSON.deserialize((refList3),buildertek__References__c.Class);
        convertRef3.buildertek__Pre_Qual__c	 = preQualRecord.id;
        upsert convertRef3;
        }
        
        
        return fileWrapper;
       }catch(Exception e){
           system.debug('erroeess');
           system.debug(e.getMessage());
           fileWrapper.errorMessage = e.getMessage();
           fileWrapper.isError = true;
           return fileWrapper;
           //return e.getMessage();
       }
    }
    
  /*    @AuraEnabled
      public static  List<ContentDocumentLink> uploadFilesInSalesforce(string fileData){
          System.debug('File Date To Upload in Salesforce -------------------  '+fileData);
          
          List<ContentDocumentLink> CDList = new  List<ContentDocumentLink>();
              List<FilesWrapper1> inn = new  List<FilesWrapper1>();
        if(fileData != null && fileData != '' && fileData != '[]'){
            inn = (List<FilesWrapper1>)JSON.deserialize((fileData),List<FilesWrapper1>.Class);
            system.debug(inn);
            system.debug(inn[0].fileName);
            
        }
          
           if(inn.size() > 0){
            for(FilesWrapper1 a : inn){
                 ContentVersion cv = createContentVersion(a.fileContent, a.fileName);
                    ContentDocumentLink cdl = createContentLink(cv.Id,a.parentId);
                CDList.add(cdl);
            }
          
      }
          return CDList;
      }
    
    
     private static ContentVersion createContentVersion(String base64, String filename) {
    ContentVersion cv = new ContentVersion();
    cv.VersionData = EncodingUtil.base64Decode(base64);
    cv.Title = filename;
    cv.PathOnClient = filename;
    try {
      insert cv;
      return cv;
    } catch(DMLException e) {
      System.debug(e);
      return null;
    }
  }
    
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
              if (contentVersionId == null || recordId == null) { return null; }
    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.ContentDocumentId = [
      SELECT ContentDocumentId 
      FROM ContentVersion 
      WHERE Id =: contentVersionId
    ].ContentDocumentId;
    cdl.LinkedEntityId = recordId;
    // ShareType is either 'V', 'C', or 'I'
    // V = Viewer, C = Collaborator, I = Inferred
    cdl.ShareType = 'V';
    try {
      insert cdl;
      return cdl;
    } catch(DMLException e) {
      System.debug(e);
      return null;
    }
  } */
  
  /*  @AuraEnabled
     public static Boolean checkEnableBox(){
               List<buildertek__Pre_Qual_Settings__c> preQualSettings = [SELECT Id,buildertek__Enable_Box__c FROM buildertek__Pre_Qual_Settings__c Where name ='PreQualSettings' LIMIT 1];
        if(preQualSettings.size() > 0){
            return preQualSettings[0].buildertek__Enable_Box__c;
        }
        else{
        return false;
        }

    } */
    
      public class FilesWrapper1{
     @AuraEnabled   public String fileName;
    @AuraEnabled    public String fileContent;
     @AuraEnabled   public String parentId;
      }
    
      @AuraEnabled
     public static Boolean checkEnableBox(){
               List<buildertek__Pre_Qual_Settings__c> preQualSettings = [SELECT Id,buildertek__Enable_Box__c FROM buildertek__Pre_Qual_Settings__c Where name ='PreQualSettings' LIMIT 1];
        if(preQualSettings.size() > 0){
            return preQualSettings[0].buildertek__Enable_Box__c;
        }
        else{
        return false;
        } 
       

    }
    
     @AuraEnabled
    public static Id saveFile(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert,
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with remains chunks
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            //appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        system.debug(parentId);
        system.debug(fileName);
        system.debug(base64Data);
        system.debug(contentType);
        List<Account> lstAcc=[SELECT Id,Name FROM Account WHERE id =:parentId];        
         base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
          ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = fileName; // Display name of the files
            conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
            insert conVer;    //Insert ContentVersion
           system.debug(conVer.Id);
        system.debug('******************'+parentId);
        
            Id conDoc = [SELECT ContentDocumentId
                         FROM ContentVersion
                         WHERE Id = :conVer.Id].ContentDocumentId;
           system.debug(conDoc);
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = parentId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
            conDocLink.shareType = 'I';
            insert conDocLink;
        return conDocLink.Id;

        
        
        
        
        /*base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;        
        return oAttachment.Id;*/
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = : fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);        
        update a;
    }
}