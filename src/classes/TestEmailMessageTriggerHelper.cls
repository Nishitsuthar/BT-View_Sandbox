@isTest
private class TestEmailMessageTriggerHelper{
   
   //this method covers the class EmailMessageTriggerHelper afterInsertMethod()
   static testMethod void unitTest(){
      
      Account testAcc = new Account(Name = 'Test Acc');
      insert testAcc;
      
      Contact testCon = new Contact(LastName = 'Acontact', FirstName = 'Test', AccountId = testAcc.Id, Email = 'agoel@mondaycall.com');
      insert testCon;
      
      test.startTest();
      
      Case testCase = new Case(Subject = 'Test', Status = 'New',Est_Cmpl_Date__c = system.today(),
                                Description = 'This is a test.', ContactId = testCon.Id,Priority = 'P3');
      insert testCase;
      
      EmailMessage mail1 = new EmailMessage();
      mail1.fromaddress ='test@test.com';
      mail1.toAddress = testCon.Email;
      mail1.subject = 'Test Message';
      mail1.TextBody = 'This is the message body.';
      mail1.parentid = testCase.id;
      insert mail1;  
         
      Attachment attach1 = new Attachment();    
      attach1.Name = 'Unit Test Attachment';
      Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
      attach1.body = bodyBlob;
      attach1.parentId = mail1.id;
      insert attach1; 
      
      EmailMessage mail2 = new EmailMessage();
      mail2.fromaddress ='test@test.com';
      mail2.toAddress = testCon.Email;
      mail2.subject = 'Test Message';
      mail2.TextBody = 'This is the message body.';
      mail2.parentid = testCase.id;
      insert mail2;  
      
      Attachment attach2 = new Attachment();    
      attach2.Name = 'Unit Test Attachment';
      Blob bodyBlob2 = Blob.valueOf('Unit Test Attachment Body');
      attach2.body = bodyBlob2;
      attach2.parentId = mail2.id;
      insert attach2;
      
      test.stopTest();
      
      List<Attachment> aList = [Select Id, Name From Attachment Where ParentId = :testCase.Id ];
      system.assertEquals(aList.size(), 2);
      
   }
   
}