@isTest
public class VG_FileCreationHelperTest {
    public static testmethod void VG_FileCreationHelperTestMethod(){	
        RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Sub_Announcements'];
        
        EC_Content__C Ann1=new EC_Content__C();
        Ann1.RecordTypeId=rec.id;
        Ann1.Name='We are Changing';
        Ann1.Primary_Text__c='We are growing at exponential rate';
        Ann1.Start_Date__c=system.today();
        Ann1.End_Date__c=system.today()+4;
        Ann1.Department__c='Marketing';
        Ann1.Location__c='Global';
        Ann1.Role__c='All';
        Ann1.Site__c='Landing Page';
        Ann1.Status__c='Published';
        insert Ann1; 
        string before = 'Testing base 64 encode';            
        Blob beforeblob = Blob.valueOf(before);
        
        
        
        //Insert contentdocument data
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        ContentDocumentLink cd =new ContentDocumentLink();
        cd.LinkedEntityId=Ann1.Id;
        cd.ContentDocumentId=testContent.ContentDocumentId;
        cd.ShareType='I';
        cd.Visibility='AllUsers';
        insert cd;
        Test.startTest();
        VG_FileCreationHelper.getImage(Ann1.Id, 'title');
        VG_FileCreationHelper.getRelatedFiles(Ann1.Id);
        VG_FileCreationHelper.saveFile(Ann1.Id, 'fileName', 'base64Data', 'contentType', 'title');
        VG_FileCreationHelper.getResolutionValues(Ann1.Id);
        
        Test.stopTest();
    }
}