@isTest(seeAllData=false)
private class SDProjectTrackingHistoryTriggerTest{
    
    private static testMethod void TestTrackingHistory(){
        
        //Insert sd project records
        SD_Project_Tracking__c spt = new SD_Project_Tracking__c();
        spt.name='Test';
       // spt.Application_Engineer__c='';
        spt.Drafter__c='';
        spt.Monthly_Capacity__c=0.0;
        spt.Notes_Comments__c='';
        spt.IGU__c=0.0;
        //spt.SD_ProjectTracking_ID__c='';
        spt.Final_Delivery_ask__c=system.Today();
        spt.Revised_Prelim_Delivery_ask__c=system.Today();
        spt.Prelim_Int_delivery_ask__c=system.Today();
        spt.Revised_Final_Delivery_ask__c=system.Today();
        spt.System_Design_Re_Commit__c='';
        
        insert spt;
        
          //update  sd project records to create history tracking
        SD_Project_Tracking__c spt1 = new SD_Project_Tracking__c();
        spt1.id=spt.id;
        spt1.Final_Delivery_ask__c=system.Today().addDays(+1);
        spt1.Revised_Prelim_Delivery_ask__c=system.Today().addDays(+1);
        spt1.Prelim_Int_delivery_ask__c=system.Today().addDays(+1);
        spt1.Revised_Final_Delivery_ask__c=system.Today().addDays(+1);
        spt1.System_Design_Re_Commit__c='Lack of SD manpower';
        update spt1;
        
        //delete sd project field values to create history tracking
        SD_Project_Tracking__c spt2 = new SD_Project_Tracking__c();
        spt2.id=spt.id;
        spt2.Final_Delivery_ask__c=null;
        spt2.Revised_Prelim_Delivery_ask__c=null;
        spt2.Prelim_Int_delivery_ask__c=null;
        spt2.Revised_Final_Delivery_ask__c=null;
        spt2.System_Design_Re_Commit__c=null;
        update spt2;
         //populate empty  sd project field values to create history tracking
        SD_Project_Tracking__c spt3 = new SD_Project_Tracking__c();
        spt3.id=spt.id;
        spt3.Final_Delivery_ask__c=system.Today().addDays(+1);
        spt3.Revised_Prelim_Delivery_ask__c=system.Today().addDays(+1);
        spt3.Prelim_Int_delivery_ask__c=system.Today().addDays(+1);
        spt3.Revised_Final_Delivery_ask__c=system.Today().addDays(+1);
        spt3.System_Design_Re_Commit__c='Lack of SD manpower';
        update spt1;
    }
     private static testMethod void TestTrackingHistoryDeleteTest(){
        
        //Insert sd project records
        SD_Project_Tracking__c spt = new SD_Project_Tracking__c();
        spt.name='Test';
       // spt.Application_Engineer__c='';
        spt.Drafter__c='';
        spt.Monthly_Capacity__c=0.0;
        spt.Notes_Comments__c='';
        spt.IGU__c=0.0;
        //spt.SD_ProjectTracking_ID__c='';
        spt.System_Design_Re_Commit__c='';
       
        spt.Final_Delivery_ask__c=system.Today();
        spt.Revised_Prelim_Delivery_ask__c=system.Today();
        spt.Prelim_Int_delivery_ask__c=system.Today();
        spt.Revised_Final_Delivery_ask__c=system.Today();
        spt.System_Design_Re_Commit__c='';
        
        insert spt;
        
          //update  sd project records to create history tracking
     /*   SD_Project_Tracking__c spt1 = new SD_Project_Tracking__c();
        spt1.id=spt.id;
        spt1.Final_Delivery_ask__c=system.Today().addDays(+1);
        spt1.Revised_Prelim_Delivery_ask__c=system.Today().addDays(+1);
        spt1.Prelim_Int_delivery_ask__c=system.Today().addDays(+1);
        spt1.Revised_Final_Delivery_ask__c=system.Today().addDays(+1);
        spt1.System_Design_Re_Commit__c='Lack of SD manpower';
        update spt1;*/
        
        //delete sd project field values to create history tracking
        SD_Project_Tracking__c spt2 = new SD_Project_Tracking__c();
        spt2.id=spt.id;
        spt2.Final_Delivery_ask__c=null;
        spt2.Revised_Prelim_Delivery_ask__c=null;
        spt2.Prelim_Int_delivery_ask__c=null;
        spt2.Revised_Final_Delivery_ask__c=null;
        spt2.System_Design_Re_Commit__c=null;
        update spt2;
       
    }
     private static testMethod void TestTrackingHistoryChangeTest(){
        
        //Insert sd project records
        SD_Project_Tracking__c spt = new SD_Project_Tracking__c();
        spt.name='Test';
       // spt.Application_Engineer__c='';
        spt.Drafter__c='';
        spt.Monthly_Capacity__c=0.0;
        spt.Notes_Comments__c='';
        spt.IGU__c=0.0;
        //spt.SD_ProjectTracking_ID__c='';
    
        spt.System_Design_Re_Commit__c='';
        spt.Final_Delivery_ask__c=system.Today();
        spt.Revised_Prelim_Delivery_ask__c=system.Today();
        spt.Prelim_Int_delivery_ask__c=system.Today();
        spt.Revised_Final_Delivery_ask__c=system.Today();
        spt.System_Design_Re_Commit__c='Lack of SD manpower';
        
        insert spt;
        
          //update  sd project records to create history tracking
        SD_Project_Tracking__c spt1 = new SD_Project_Tracking__c();
        spt1.id=spt.id;
        spt1.Final_Delivery_ask__c=system.Today().addDays(+1);
        spt1.Revised_Prelim_Delivery_ask__c=system.Today().addDays(+1);
        spt1.Prelim_Int_delivery_ask__c=system.Today().addDays(+1);
        spt1.Revised_Final_Delivery_ask__c=system.Today().addDays(+1);
        spt1.System_Design_Re_Commit__c='Resource allocated to higher priority tasks';
        update spt1;
        
     
       
    }
     private static testMethod void TestTrackingHistoryOldValueNull(){
        
        //Insert sd project records
        SD_Project_Tracking__c spt = new SD_Project_Tracking__c();
        spt.name='Test';
       // spt.Application_Engineer__c='';
        spt.Drafter__c='';
        spt.Monthly_Capacity__c=0.0;
        spt.Notes_Comments__c='';
        spt.IGU__c=0.0;
        //spt.SD_ProjectTracking_ID__c='';
       
        spt.System_Design_Re_Commit__c=null;
        spt.Final_Delivery_ask__c=null;
        spt.Revised_Prelim_Delivery_ask__c=null;
        spt.Prelim_Int_delivery_ask__c=null;
        spt.Revised_Final_Delivery_ask__c=null;
        spt.System_Design_Re_Commit__c=null;
        
        insert spt;
        
          //update  sd project records to create history tracking
        SD_Project_Tracking__c spt1 = new SD_Project_Tracking__c();
        spt1.id=spt.id;
        spt1.Final_Delivery_ask__c=system.Today().addDays(+1);
        spt1.Revised_Prelim_Delivery_ask__c=system.Today().addDays(+1);
        spt1.Prelim_Int_delivery_ask__c=system.Today().addDays(+1);
        spt1.Revised_Final_Delivery_ask__c=system.Today().addDays(+1);
        spt1.System_Design_Re_Commit__c='Resource allocated to higher priority tasks';
        update spt1;       
     
       
    }
    
     static testMethod void Testrecursive(){
        CheckRecursive.runOnce();
        CheckRecursive.runOnceSDTrack();
    }
    
}