@istest(SeeAllData=true)
public class testbatchfieldchange
{

 static testmethod void testing()
 {
  Test.StartTest();
   fieldchange1 fchange= new fieldchange1 ();
   fchange.query='SELECT Project_Name__c,W0__c,W1__c,W2__c,W3__c,W4__c,W5__c,W6__c,W7__c,W8__c,W9__c,W10__c,W11__c,W12__c,W_1__c FROM SD_Project_Tracking__c LIMIT 200';
  
   ID batchprocessid = Database.executeBatch(fchange);
   Test.StopTest();
 
 
 }

}