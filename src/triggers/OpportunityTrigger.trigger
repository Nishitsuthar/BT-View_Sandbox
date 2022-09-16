trigger OpportunityTrigger on Opportunity (Before insert,Before update, After update, After Insert) {

        if(Trigger.isAfter && Trigger.isUpdate){
            //BudgetaryEstimate obj = new BudgetaryEstimate();
            list<Id> oppIdList = new list<Id>();
            for(Opportunity opp : Trigger.new){
                if(Trigger.oldMap.get(opp.Id).MOU_Initiated__c == false && opp.MOU_Initiated__c == true){
                    oppIdList.add(opp.Id);
                    //obj.CloneQuote(opp.Id);               
                }  
            }
            if(oppIdList.size()>0){
                //BudgetaryEstimate obj = new BudgetaryEstimate();
                if(!BudgetaryEstimate.isTriggerFired) {
                    BudgetaryEstimate.CloneQuote(oppIdList);
                    BudgetaryEstimate.isTriggerFired = true;
                }              
            }
        }
        
        if(Trigger.isBefore){
            
           //List<Opportunity > opportunityList = new List<Opportunity >();
           List<User> userList = [SELECT ID,isActive,Profile.Name,Support_Region__c FROM User where IsActive != false AND Support_Region__c != null];
           //User adminUser = [Select Id from User Where Name =: Label.DefaultAdminUser and isActive = true order by createddate ASC limit 1];
           //Added by ENP - START - Added Custom Label References in Query Filter
           //User CustomerSuccessManager = [Select Id from User Where Name =: Label.DefaultCustomerSuccessManager and isActive = true ];              
           //User RegionalDirector = [Select Id from User Where Name =: Label.DefaultRegionalDirector and isActive = true ];            
           //Added by ENP - END 
           //User ddUser = [Select Id from User Where Name =: Label.DefaultDDUser and isActive = true order by createddate ASC limit 1];
           Boolean flag = false;
            system.debug('opp Inside Trigger ====> '+ Trigger.new);
           if(Trigger.isInsert || Trigger.isUpdate){
                Id mouSingleProjectRecType = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
                for(Opportunity opp :Trigger.new){    
                
                    if(Trigger.isUpdate){
                        if(opp.RecordTypeId != Trigger.oldMap.get(opp.Id).RecordTypeId &&  opp.RecordTypeId == mouSingleProjectRecType && opp.Target_SE__c != null) {
                                opp.OwnerId = opp.Target_SE__c;
                                system.debug('opp Inside ====> '+opp);
                        }
                    }
                
                    if(Trigger.isInsert || Trigger.oldMap.get(opp.Id).Support_Region__c != Trigger.newMap.get(opp.Id).Support_Region__c){
                        //myUser.ForecastEnabled=true;
                        //Support Region is blank than trigger will not be fire.
                        if(!String.isBlank(opp.Support_Region__c))
                        {
                        
                            for(User u : userList){
                            
                               Set<String> regionList = new Set<String>(u.Support_Region__c.split(';'));
                               
                               if(regionList.contains(opp.Support_Region__c)){
                                   if(u.Profile.Name == Label.Customer_Success){
                                       flag = true;
                                       opp.CSM_Project_Manager__c  = u.Id;
                                   }
                                   if(u.Profile.Name == Label.Deal_Desk){
                                       flag = true;
                                       opp.Sales_Ops_Owner__c= u.Id;
                                   }
                                   if(u.Profile.Name == Label.Regional_Director || u.Profile.Name == 'Executive'){
                                       flag = true;
                                       opp.Sales_Director__c= u.Id;
                                   }
                               }
                            }
                            
                            if(opp.CSM_Project_Manager__c == null){
                                //opp.CSM_Project_Manager__c  = DefaultCustomerSuccessManagerId;  //Added by ENP
                                opp.CSM_Project_Manager__c = Label.DefaultCustomerSuccessManagerId;  //Added by ENP
                            }
                            if(opp.Sales_Ops_Owner__c== null){
                                //opp.Sales_Ops_Owner__c= Label.DefaultDDUserId;
                                opp.Sales_Ops_Owner__c= Label.DefaultDDUserId;
                            }
                            if(opp.Sales_Director__c == null){
                                //opp.Sales_Director__c= RegionalDirector.Id;  //Added by ENP
                                opp.Sales_Director__c = Label.DefaultRegionalDirectorId;  //Added by ENP
                            }
                            
                        system.debug('flag ====> '+flag);
                        
                        
                        if(!flag){
                            /*
                            opp.CSM_Project_Manager__c  = CustomerSuccessManager.Id;  //Added by ENP
                            opp.Sales_Ops_Owner__c= ddUser.Id;
                            opp.Sales_Director__c= RegionalDirector.Id;  //Added by ENP*/
                            opp.CSM_Project_Manager__c  = Label.DefaultCustomerSuccessManagerId;  //Added by ENP
                            opp.Sales_Ops_Owner__c= Label.DefaultDDUserId;
                            opp.Sales_Director__c= Label.DefaultRegionalDirectorId;  //Added by ENP
                        } 
                        }
                    }
                    system.debug('opp ====> '+opp);
                }
           }
    }
}