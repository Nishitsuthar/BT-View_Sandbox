global class fieldchange1 implements Database.Batchable<sObject>,Schedulable {

//string a='a64V0000000VgcC';

public string query = 'SELECT Project_Name__c,W0__c,W1__c,W2__c,W3__c,W4__c,W5__c,W6__c,W7__c,W8__c,W9__c,W10__c,W11__c,W12__c,W_1__c FROM SD_Project_Tracking__c' ;

   global Database.QueryLocator start(Database.BatchableContext bc) {
    
     return Database.getQueryLocator(query);  
     
    }

    global void execute(Database.BatchableContext bc, List<SD_Project_Tracking__c> records){
   system.debug('@@@ '+records);
   List<Decimal> week01=new List<Decimal>();
    //Decimal w01=0;
    
    Set<ID> op = new Set<ID>();
   List<SD_Resource_Tracking__c> sr = new List<SD_Resource_Tracking__c>();
   List<SD_Project_Tracking__c> sc = new List<SD_Project_Tracking__c>();
  try{ 
   for(SD_Project_Tracking__c sp : records)
   {
    system.debug('@@@!!!! '+sp.W_1__c);
   op.add(sp.Project_Name__c);
  // w01+=sp.W_1__c;
   if(sp.W_1__c>0)
   {
   //week01.add(sp.W_1__c);
   SD_Resource_Tracking__c srt = new SD_Resource_Tracking__c();
//System.debug('FORLOOP '+opid );  
  
  srt.W0__c=sp.W_1__c;
  srt.SD_Project_Tracking__c=sp.id;
srt.Project_Name__c=sp.Project_Name__c;
  sr.add(srt);
   
   }
   sp.W_1__c=sp.W0__c;
   sp.W0__c=sp.W1__c;
   sp.W1__c=sp.W2__c;
   sp.W2__c=sp.W3__c;
   sp.W3__c=sp.W4__c;
   sp.W4__c=sp.W5__c;
   sp.W5__c=sp.W6__c;
   sp.W6__c=sp.W7__c;
   sp.W7__c=sp.W8__c;
   sp.W8__c=sp.W9__c;
   sp.W9__c=sp.W10__c;
   sp.W10__c=sp.W11__c;
   sp.W11__c=sp.W12__c;
   sp.W12__c=0.0;
  
   sc.add(sp);
   
   }
   
  
   insert sr;
   System.debug('##$ '+sr);
   System.debug('##$! '+sc);
   update sc;
   }
   catch(Exception e)
   {
   System.debug('ERROR OCCURED '+e);
   }
   
    }  
    
     global void execute(SchedulableContext ctx)  
     {
       fieldchange1 b = new fieldchange1(); 
      database.executebatch(b);
     }

    global void finish(Database.BatchableContext bc){
      
    }    

}