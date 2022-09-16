@isTest
private class Test_CountAttachment {
static testMethod void testAttachments() 
{ 
        Halo_Profile__c cse=new Halo_Profile__c (); 
        insert cse; 
        
        Halo_Profile__c cse1=new Halo_Profile__c (); 
        insert cse1; 
              
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=cse.id;
        insert attach;
        
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:cse.id];
        System.assertEquals(1, attachments.size());
        
        attach = [Select Id, Name from attachment Where parent.id=:cse.id];
        delete attach;
       System.assertEquals(1, attachments.size());
        
 }
 
 }