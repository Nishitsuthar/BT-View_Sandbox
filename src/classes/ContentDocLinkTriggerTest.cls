@isTest
public class ContentDocLinkTriggerTest {
    public static testMethod void test() {
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        buildertek__Project__c proj = new buildertek__Project__c();
        proj.Name = 'Test Project';
        insert proj;
        
        buildertek__RFQ__c rfq = new buildertek__RFQ__c();
        rfq.Name = 'Test';
        rfq.buildertek__Project__c = proj.Id;
        insert rfq;
        
       buildertek__RFQ_To_Vendor__c rfqToVendor = new buildertek__RFQ_To_Vendor__c();
        rfqToVendor.buildertek__RFQ__c = rfq.id;
        
           ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=rfq.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
    
       // insert rfqToVendor; 
          
      //  buildertek__RFI__c rfi = new buildertek__RFI__c();
       // rfi.buildertek__RFQ_To_Vendor__c = rfqToVendor.id;
       // rfi.buildertek__RFI_Assigned_To__c = 'rfqToVendor.id';
      //  rfi.buildertek__Due_Date__c = system.today();
      //  rfi.buildertek__Subject__c = 'testing';
       // insert rfi;
        
      //  buildertek__RFI_Response__c response = new buildertek__RFI_Response__c();
      //  response.buildertek__Response__c = 'test';
       // insert response;
        
    }
}