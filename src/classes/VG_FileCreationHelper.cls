public class VG_FileCreationHelper {
    @AuraEnabled
    public static String getImage(Id parentId, String title) {
        List<ContentDocumentLink> cdl = new List<ContentDocumentLink>{};
        cdl = [	SELECT ContentDocumentId  
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :parentId
            AND ContentDocument.Title =: title
            ORDER BY Id DESC 
            LIMIT 1
        ];
        if(cdl.size() > 0 ){
            List<ContentVersion> cvs = new List<ContentVersion>{};
            cvs = [SELECT Id,VersionData,ContentDocumentId  FROM ContentVersion  WHERE ContentDocumentId = :cdl[0].ContentDocumentId ORDER BY CreatedDate DESC LIMIT 1];
            if(cvs.size() == 1){ return cvs[0].Id; }
        }
        return null;
    }
    @AuraEnabled
    public static List<contentVersion> getRelatedFiles(id parentId){
         system.debug('@@ in getRelatedFiles parentId'+parentId);
          set<id> cdlIdSet = new set<id>();   
             for(contentDocumentLink cdl:  [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :parentId]){
             	  cdlIdSet.add(cdl.contentDocumentId);
             }       
        system.debug('@@ cdlIdSet'+cdlIdSet);
        if(cdlIdSet.size() > 0 ){
            List<ContentVersion> cvs = new List<ContentVersion>{};
            cvs = [SELECT Id,Title,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :cdlIdSet];
            system.debug('@@ cvs'+cvs);
            if(cvs.size() > 0){return cvs;}
        }
        
        return null;
    }
    @AuraEnabled
    public static ImageResolution__mdt getResolutionValues(id recordId){
        system.debug('@@ recordId'+recordId);
        string EC_RecordType = [select id,recordtype.name from EC_Content__c where id=:recordId limit 1].recordtype.name;
        system.debug('@@ EC_RecordType'+EC_RecordType);
       // List<ImageResolution__mdt> imrList = new List<ImageResolution__mdt>();
        ImageResolution__mdt imr = new ImageResolution__mdt();
        List<ImageResolution__mdt> imrList = [select MasterLabel,height__c,width__c from ImageResolution__mdt where MasterLabel=:EC_RecordType limit 1];
        if(imrList != null && !imrList.isEmpty()){
            return imrList[0];
        }
        return null;     
    }
    
    @AuraEnabled
    public static Id saveFile(Id parentId, String fileName, String base64Data, String contentType, String title) {         
        return saveFile(parentId, fileName, base64Data, contentType, NULL, title);
    }

    @AuraEnabled
    public static Id saveFile(Id parentId, String fileName, String base64Data, String contentType, Id contentDocumentId, String title) { 

        delete [
            SELECT Id 
            FROM  ContentDocumentLink 
            WHERE LinkedEntityId =: parentId 
            AND ContentDocument.Title =: title
        ];
        
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.ContentDocumentId = contentDocumentId;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = title;
        cv.PathOnClient = filename;  
        
        insert cv;              
                
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = parentId;
        cdl.Visibility = 'AllUsers';
        cdl.ShareType = 'I';
        insert cdl;     

        return cv.Id;
        
    }

}