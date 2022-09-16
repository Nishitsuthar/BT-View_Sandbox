/*
This batch class is used to create tasks based on Opportunity key project fields and runs daily.
*/
global class KeyProjectTaskCreationBatch implements Database.Batchable<sObject>{ 
    
    public Set<String> openStatus = new Set<String> {'Pre-Qualifying-Open','Pre-Qualifying-Developing',
                                                            'Value Prop.','Budgetary Estimate','Bid/Quote','Discovery'
                                                    };
                                                        
    public Set<String> closedStatus = new Set<String> {'Closed: Won','Booked','Partial Release','Released to Factory',
                                                            'Partial Shipment','Product Shipped','Invoiced'
                                                    };
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT Id, Key_Project_HQ__c, Key_Project_Region__c, Key_Project_Sales__c, CloseDate , CreatedDate, Name,Group_Stage__c,'+
            'OwnerId, StageName, First_Request_Date_IGU__c, IGU_P_O__c, BOS_P_O__c FROM Opportunity '+                   
            'WHERE (StageName IN:openStatus OR StageName IN:closedStatus)';
        system.debug('----query----'+query);
        system.debug('results'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<Opportunity> scope){
        //List<Opportunity> errorLogList = New List<Opportunity>();
        Id devRecordTypeId          = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Key Project Type').getRecordTypeId();
        List<Task> keyProTaskList   = new List<Task>();
        system.debug('-----oppData----'+json.serializePretty(scope));
        
        Datetime dt             = System.now();
        date newDt              = date.newInstance(dt.year(), dt.month()+12, dt.day());
        string stringFinalDt    = newDt.month()+'/'+newDt.day()+'/'+newDt.year();
        string stringTodayDt    = dt.month()+'/'+dt.day()+'/'+dt.year();
        
        date finalDt = date.parse(stringFinalDt);
        date todayDt = date.parse(stringTodayDt);
        date firstRequestDt;
        //system.debug('------todayDt------'+ todayDt+'-----finalDt------'+finalDt);
        
        for(Opportunity opp : scope){
            
            Date startTodayDt       = Date.today();
            Date closeDt            = opp.closeDate;
            Integer daysDue         = startTodayDt.daysBetween(closeDt);
            
            //CR Team - 14/02/2020 condition-1 : Opportunities with only Key Project HQ = True, when in open stage from today till closed date every Friday
            
            if((!opp.Key_Project_Region__c && opp.Key_Project_HQ__c)
               && openStatus.contains(opp.StageName)
               && daysDue < 180 ){
                   if(dt.format('EEE') == System.label.RunningDay){
                       
                       Task keyProTask             = new Task();
                       keyProTask.Status           = 'Completed';
                       keyProTask.Subject          = 'Key Project Update';
                       keyProTask.WhatId           = opp.ID;
                       keyProTask.OwnerId          = opp.OwnerId;
                       KeyProTask.ActivityDate     = Date.today();
                       KeyProTask.RecordTypeId     = devRecordTypeId;
                  //     KeyProTask.Next_Steps__c     = '7 AM PST PST - Con 1';
                       
                       keyProTaskList.add(KeyProTask);
                       system.debug('--- weekly inserted----'+keyProTaskList);
                   }
               }//end: cond-1 -IF
            
            // CR Team - 14/02/2020 condition-2: Opportunities with only Key Project HQ = True, when in closed stage from 12 months prior to  First igu request date
            if(opp.First_Request_Date_IGU__c != null){
                Date dueDate = opp.First_Request_Date_IGU__c;
                Date startDate = date.today();
               // Date startDate = opp.closeDate;
                Integer numberDaysDue = startDate.daysBetween(dueDate);
                system.debug('-------numberdays---'+numberDaysDue);
                
                if((!opp.Key_Project_Region__c && opp.Key_Project_HQ__c)
                   && closedStatus.contains(opp.StageName) 
                   && (numberDaysDue >=1 && numberDaysDue  <366)
                  ){
                      system.debug('---numberDaysDue'+numberDaysDue);
                      if(dt.format('EEE') == System.label.RunningDay){
                          
                          Task keyProTask             = new Task();
                          keyProTask.Status           = 'Completed';
                          keyProTask.Subject          = 'Key Project Update';
                          keyProTask.WhatId           = opp.ID;
                          keyProTask.OwnerId          = opp.OwnerId;
                          KeyProTask.ActivityDate     = Date.today();
                          KeyProTask.RecordTypeId     = devRecordTypeId;
                        //  KeyProTask.Next_Steps__c     = '7 AM PST PST - Con 2';
                          
                          keyProTaskList.add(KeyProTask);
                          system.debug('--- weekly inserted----'+keyProTaskList);
                      }
                  }//end: if
            }//end:condn-2: if
            
            
            // CR Team - 14/02/2020 condition-3:Opportunities with only Key Project HQ = True, when in closed stage, if First IGU request date is blank or in the past, 
            //send notifications every Friday till the CSS PO and IGU PO fields have the value of 100%
            
            if(opp.First_Request_Date_IGU__c != null){
                string stringFirstRequestDt = opp.First_Request_Date_IGU__c.month()+'/'+opp.First_Request_Date_IGU__c.day()+
                    '/'+opp.First_Request_Date_IGU__c.year();
                firstRequestDt = date.parse(stringFirstRequestDt);
            } 
            
             //system.debug('--before 3rd condn----> firstRequestDt=>'+firstRequestDt+' TodayDt=>'+todayDt+' FinalDt=>'+finalDt);
             system.debug('--stagename--'+opp.StageName);
            //if(opp.StageName == 'Booked')
            system.debug('--id--'+opp.Id+'--day--'+dt.format('EEE')+'--contains---'+closedStatus.contains(opp.StageName)+'--HQ=>--'+opp.Key_Project_HQ__c);   
            
            if(closedStatus.contains(opp.StageName)                   
               && ((opp.IGU_P_O__c == null || opp.IGU_P_O__c < 100) && (opp.BOS_P_O__c == null || opp.BOS_P_O__c < 100))
               && (!opp.Key_Project_Region__c && opp.Key_Project_HQ__c)
               && (opp.First_Request_Date_IGU__c == null || firstRequestDt <= todayDt)
               )
            {
                system.debug('---entered---');
                //system.debug('firstRequestDt=>'+firstRequestDt+'TodayDt=>'+todayDt+'FinalDt=>'+finalDt);
                if(dt.format('EEE') == System.label.RunningDay){
                    
                    Task keyProTask             = new Task();
                    keyProTask.Status           = 'Completed';
                    keyProTask.Subject          = 'Key Project Update';
                    keyProTask.WhatId           = opp.ID;
                    keyProTask.OwnerId          = opp.OwnerId;
                    KeyProTask.ActivityDate     = Date.today();
                    KeyProTask.RecordTypeId     = devRecordTypeId;
                //   KeyProTask.Next_Steps__c     = '7 AM PST PST - Con 3';
                    
                    keyProTaskList.add(KeyProTask);
                    system.debug('--- weekly inserted----'+keyProTaskList);
                }
            }//end:- condn-3: if
            
            // CR Team - 14/02/2020 condition-4 & 5:- Opportunities with Key Project HQ = True & Key Project Region = True OR
            //Opportunities with Key Project Region = True, when in open stage from today till closed date everyday
            
            if((opp.Key_Project_Region__c && !opp.Key_Project_HQ__c)
               ||
               (opp.Key_Project_HQ__c && opp.Key_Project_Region__c)
               && openStatus.contains(opp.StageName)
               && daysDue < 366 )
               {
                Task keyProTask             = new Task();
                keyProTask.Status           = 'Completed';
                keyProTask.Subject          = 'Key Project Update';
                keyProTask.WhatId           = opp.ID;
                keyProTask.OwnerId          = opp.OwnerId;
                KeyProTask.ActivityDate     = Date.today();
                KeyProTask.RecordTypeId     = devRecordTypeId;
               // KeyProTask.Next_Steps__c     = '7 AM PST - Con 4 & 5';
                
                keyProTaskList.add(KeyProTask);
                system.debug('---Daily inserted----'+keyProTaskList);
                   
            }//end:condtn-4&5
                        
        }//end: for
        
        if(keyProTaskList.size() > 0){
            system.debug('---inserted----');
            insert keyProTaskList;
            system.debug('---task----'+keyProTaskList);
        }//end:if
   }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}