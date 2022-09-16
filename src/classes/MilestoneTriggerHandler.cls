public class MilestoneTriggerHandler{
   
   public static void decommissionMilestone(){
			
    }
   
}

/*When a new Customer Kickoff meeting milestone is created, find the IGU Ship milestone on the parent opportunity and if the 
     Deadline date on the IGU Ship milestone is populated, set it as the Kickoff date on Customer Kickoff Meeting milestone.*/
     /*
   public void setKickoffDateMethod(List<CSM_Milestone__c> newCSMList){
      
      //Set of Parent Opportunity Ids for CSM Milestones in newCSMList
      Set<Id> opptyIdSet = new Set<Id>();
      
      for(CSM_Milestone__c csm :newCSMList){
         if(csm.Opportunity__c != null && !opptyIdSet.contains(csm.Opportunity__c)){
            opptyIdSet.add(csm.Opportunity__c);

         }
      }
      system.debug('opptyIdSet--'+opptyIdSet);
      
      //Map of Opportunities whose Id is in opptyIdSet
      Map<Id, Opportunity> opptyMap ;
      /*if(opptyIdSet.size() > 0){
         opptyMap = new Map<Id, Opportunity>([Select Id, (Select Id, Deadline__c,Name From Milestones__r Where Name Like 'IGU Ship%' Order By Deadline__c Asc) From Opportunity Where Id In :opptyIdSet]);
      }
      //opptyMap = retrieveOpptyData(opptyIdSet);
      
      //Setting value of Start_Date__c(Kickoff Date) on CSM Milestone
      for(CSM_Milestone__c c :newCSMList){
          
         opptyMap = retrieveOpptyData(opptyIdSet,c.Name);
         if(opptyMap.keySet().size() > 0 && opptyMap.containsKey(c.Opportunity__c) && opptyMap.get(c.Opportunity__c).MileStones__r.size() > 0){
                         
            //c.PM_Milestone__c = opptyMap.get(c.Opportunity__c).MileStones__r[0].Id ;
            if(opptyMap.get(c.Opportunity__c).MileStones__r[0].Deadline__c != null){
                
                System.debug(opptyMap.get(c.Opportunity__c).MileStones__r[0].Name);
                System.debug(c.Name+'CSM MileStone Record');
                
                if(c.Name.equalsIgnoreCase('Occupant Engagement'))
                {
                     Date d = opptyMap.get(c.Opportunity__c).MileStones__r[0].Deadline__c ; // added 09092017
                     c.Completion_Date__c = d.addDays(7);
                }
                else if(c.Name.equalsIgnoreCase('Training and initial verbal feedback'))
                {
                    Date d = opptyMap.get(c.Opportunity__c).MileStones__r[0].Deadline__c ; // added 09092017
                     c.Completion_Date__c = d.addDays(14);
                }
                else if(c.Name.equalsIgnoreCase('Resolve occupant issues'))
                {
                    Date d = opptyMap.get(c.Opportunity__c).MileStones__r[0].Deadline__c ; // added 09092017
                     c.Completion_Date__c = d.addDays(30);
                }
                else if(c.Name.contains('Final feedback'))
                {
                    Date d = opptyMap.get(c.Opportunity__c).MileStones__r[0].Deadline__c ; // added 09092017
                     c.Completion_Date__c = d.addDays(60);
                }  
                
               
                else 
                {
                   c.Completion_Date__c= opptyMap.get(c.Opportunity__c).MileStones__r[0].Deadline__c ; // added 09092017   
                } 
              // c.Start_Date__c = opptyMap.get(c.Opportunity__c).MileStones__r[0].Deadline__c ;\               
              // c.Completion_Date__c= opptyMap.get(c.Opportunity__c).MileStones__r[0].Deadline__c ; // added 09092017   
            }
            system.debug('success--');
         }
      }
   }
   
   //If the deadline date on the IGU Ship record was updated after the customer kick off milestone was created, it should go back and update the customer kick off meeting milestone
   public void onMilestoneUpdateMethod(List<Milestone1_Milestone__c> newMilestoneList,String typeof){
       
      System.debug('*****csmname'+typeof);   
      if(typeof != null)
      {
          //Set of Opportunity Ids, related to the Milestones in the newMilestoneList
      Set<Id> opptyIdSet = new Set<Id>();
      
      for(Milestone1_Milestone__c m :newMilestoneList){
         if(m.Opportunity__c != null && !opptyIdSet.contains(m.Opportunity__c)){
            opptyIdSet.add(m.Opportunity__c);
         }
      }
      System.debug('*****'+'Inside Logic Handler');
      //Querying opportunity to retrieve information of csm Milesone n other IGU Ship milestones
      //Map of Opportunity Id with the opportunity record
      Map<Id, Opportunity> opptyMap;
      
      if(opptyIdSet.size() > 0 && typeof == 'OccupancyMultiple'){
          
          System.debug('Inside the MH OccupancySOQL');
          opptyMap = new Map<Id, Opportunity>([Select Id, (Select Id, Deadline__c, Type__c From Milestones__r Where Type__c = 'Occupancy' Order By Deadline__c Asc Nulls Last), (Select Id, Start_Date__c ,Completion_Date__c,Name  From CSM_Milestones__r Where Name IN ('Initial POC training on product and controls','Occupant Engagement','Training and initial verbal feedback','Resolve occupant issues','Final feedback survey')) From Opportunity Where Id In :opptyIdSet]);
          System.debug(opptyMap);
      }
      else
       {
           System.debug('*****'+'Inside the Map Population');
           opptyMap = retrieveOpptyDataUpdate(opptyIdSet,typeof);
           System.debug(opptyMap);
       }
      
      //List of CSM Milestone to be updated
      List<CSM_Milestone__c> toBeUpdated = new List<CSM_Milestone__c>();
       
      System.debug(opptyMap.keySet());
       
      if(opptyMap.keySet().size() > 0 && typeof != 'OccupancyMultiple'){
         for(Id i:opptyMap.keySet()){
            if(opptyMap.get(i).CSM_Milestones__r != null && opptyMap.get(i).CSM_Milestones__r.size() > 0 && opptyMap.get(i).Milestones__r.size() > 0){
               if(opptyMap.get(i).Milestones__r.size() > 0 && opptyMap.get(i).Milestones__r[0].Deadline__c != null){
                   //opptyMap.get(i).CSM_Milestones__r[0].Start_Date__c = opptyMap.get(i).Milestones__r[0].Deadline__c ;
                   opptyMap.get(i).CSM_Milestones__r[0].Completion_Date__c = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added on 09092017
               }
                //Added Lines to Test Null Functionality.
               else if (opptyMap.get(i).Milestones__r.size() > 0 && opptyMap.get(i).Milestones__r[0].Deadline__c == null)
               {
                   opptyMap.get(i).CSM_Milestones__r[0].Completion_Date__c = null;
               }
               //opptyMap.get(i).CSM_Milestones__r[0].PM_Milestone__c = opptyMap.get(i).Milestones__r[0].Id;
               toBeUpdated.add(opptyMap.get(i).CSM_Milestones__r[0]);
            }
         }
      }
      else
      {
           for(Id i : opptyMap.keySet()){
               
            System.debug('Inside the Update handler');
               
            if(opptyMap.get(i).CSM_Milestones__r != null && opptyMap.get(i).CSM_Milestones__r.size() > 0 && opptyMap.get(i).Milestones__r.size() > 0){
              
                for(Integer val = 0; val < opptyMap.get(i).CSM_Milestones__r.size(); val++ )
                {
           if(opptyMap.get(i).Milestones__r.size() > 0 && opptyMap.get(i).Milestones__r[0].Deadline__c != null){
                        
                if(opptyMap.get(i).CSM_Milestones__r[val].Name.equalsIgnoreCase('Occupant Engagement'))
                {
                     Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c = d.addDays(7);
                }
                else if(opptyMap.get(i).CSM_Milestones__r[val].Name.equalsIgnoreCase('Training and initial verbal feedback'))
                {
                    Date d = opptyMap.get(i).Milestones__r[0].Deadline__c; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c = d.addDays(14);
                }
                else if(opptyMap.get(i).CSM_Milestones__r[val].Name.equalsIgnoreCase('Resolve occupant issues'))
                {
                    Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c = d.addDays(30);
                }
                else if(opptyMap.get(i).CSM_Milestones__r[val].Name.containsIgnoreCase('Final feedback'))
                {
                    Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c = d.addDays(60);
                }  
               else if(opptyMap.get(i).CSM_Milestones__r[val].Name.containsIgnoreCase('Meet with PM '))
                {
                    Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c = d.addDays(7);
                }  
               else if(opptyMap.get(i).CSM_Milestones__r[val].Name.containsIgnoreCase('BOS Design'))
                {
                    Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c = d.addDays(7);
                }  
                else
                {
                   opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c= opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017   
                }
                //opptyMap.get(i).CSM_Milestones__r[val].PM_Milestone__c = opptyMap.get(i).Milestones__r[0].Id;
                toBeUpdated.add(opptyMap.get(i).CSM_Milestones__r[val]);// added on 09092017s
            }
            // Repeated the logic to handle the Null Data.
             else if(opptyMap.get(i).Milestones__r.size() > 0 && opptyMap.get(i).Milestones__r[0].Deadline__c == null)
                    {
                if(opptyMap.get(i).CSM_Milestones__r[val].Name.equalsIgnoreCase('Occupant Engagement'))
                {
                    // Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c =  opptyMap.get(i).Milestones__r[0].Deadline__c;
                }
                else if(opptyMap.get(i).CSM_Milestones__r[val].Name.equalsIgnoreCase('Training and initial verbal feedback'))
                {
                   // Date d = opptyMap.get(i).Milestones__r[0].Deadline__c; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c =  opptyMap.get(i).Milestones__r[0].Deadline__c;
                }
                else if(opptyMap.get(i).CSM_Milestones__r[val].Name.equalsIgnoreCase('Resolve occupant issues'))
                {
                   // Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c =  opptyMap.get(i).Milestones__r[0].Deadline__c;
                }
                else if(opptyMap.get(i).CSM_Milestones__r[val].Name.containsIgnoreCase('Final feedback'))
                {
                    //Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c =  opptyMap.get(i).Milestones__r[0].Deadline__c;
                }  
               else if(opptyMap.get(i).CSM_Milestones__r[val].Name.containsIgnoreCase('Meet with PM '))
                {
                    //Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c =  opptyMap.get(i).Milestones__r[0].Deadline__c;
                }  
               else if(opptyMap.get(i).CSM_Milestones__r[val].Name.containsIgnoreCase('BOS Design'))
                {
                    //Date d = opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017
                     opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c = opptyMap.get(i).Milestones__r[0].Deadline__c;
                }  
                else
                {
                   opptyMap.get(i).CSM_Milestones__r[val].Completion_Date__c= opptyMap.get(i).Milestones__r[0].Deadline__c ; // added 09092017   
                }
                //opptyMap.get(i).CSM_Milestones__r[val].PM_Milestone__c = opptyMap.get(i).Milestones__r[0].Id;
                toBeUpdated.add(opptyMap.get(i).CSM_Milestones__r[val]);// added on 09092017s
                    }
                     
                }
                   
               }
              
            }
      }
     
      if(toBeUpdated.size() > 0){
         try{
             System.debug('Update Executed');
            update toBeUpdated;
         } catch(DMLException e){
              system.debug('--'+e.getMessage());
         }
      } 
      }
     
   }
   
   //method which returns a list of Opportunities and their related Milestone reocrds
    public Map<Id, Opportunity> retrieveOpptyData(Set<Id> opptyIdSet,String Name){
      Map<Id, Opportunity> opptyMap ;
      String keyval = MilestoneTriggerHandler.getKeyValueForQuery(Name);
      if(keyval != null)
      {
         if(opptyIdSet.size() > 0){        
         opptyMap = new Map<Id, Opportunity>((List<Opportunity>)Database.query('Select Id, (Select Id, Deadline__c, Name  From Milestones__r Where Type__c = :keyval Order By Deadline__c Asc Nulls Last) From Opportunity Where Id In :opptyIdSet'));
      }
      if(opptyMap.keySet().size() > 0){
          System.debug(opptyMap);
         return opptyMap;
      }     
      }
      return null;
   }
    
    public Map<Id, Opportunity> retrieveOpptyDataUpdate(Set<Id> opptyIdSet,String CSMName){
        
      Map<Id, Opportunity> opptyMap ;
      String keyval = MilestoneTriggerHandler.getKeyValueForQuery(CSMName);
      System.debug(keyval);
      if(keyval != null)
      {
         if(opptyIdSet.size() > 0){        
         opptyMap = new Map<Id, Opportunity>((List<Opportunity>)Database.query('Select Id, (Select Id, Deadline__c, Name  From Milestones__r Where Type__c = :keyval Order By Deadline__c Asc Nulls Last),(Select Id, Start_Date__c From CSM_Milestones__r Where Name = :CSMName) From Opportunity Where Id In :opptyIdSet'));
      }
      if(opptyMap.keySet().size() > 0){
          System.debug(opptyMap+'From Update');
         return opptyMap;
      }     
      }
      return null;
        
    }
   public static String getKeyValueForQuery(String csmname)
   {
       if(csmname == null)
       {
           return null;
       }
       if(csmname.containsIgnoreCase('Sales to Ops Turnover'))
            return 'Sales to Ops Turnover';
       else if (csmname.containsIgnoreCase('Meet with PM'))
       {
           return 'Project Kickoff Meeting';
       } */
     /*  else if(csmname.containsIgnoreCase('BOS Design'))
       {
           return 'Preliminary BOS Design';
       } 11/17/2017 */
       /*
        else if(csmname.containsIgnoreCase('BOS Design Check'))
       {
           return 'Final BOS Design';
       }
       else if(csmname.containsIgnoreCase('Initial engagement with customer'))
       {
           return 'IGU Ship';
       }
      // else if(csmname.containsIgnoreCase('Architectural Zoning') || csmname.containsIgnoreCase('BOS Ship')) 11/17/2017
       else if(csmname.containsIgnoreCase('Architectural Zoning') )
       {
           return 'Architectural Zoning';
       }
       else if(csmname.containsIgnoreCase('BOS Commissioning') ||csmname.containsIgnoreCase('Hardware Commissioning') )
       {
           return 'BOS Commissioning';
       }
       else if(csmname.containsIgnoreCase('Intelligence Commissioning')|| csmname.containsIgnoreCase('Software Commissioning'))
       {
           return 'Intelligence Commissioning';
       }
       else if(csmname.containsIgnoreCase('Initial POC training on product')||csmname.equalsIgnoreCase('Occupant Engagement')||csmname.equalsIgnoreCase('Training and initial verbal feedback')||
               
               csmname.equalsIgnoreCase('Resolve occupant issues')||csmname.containsIgnoreCase('Final feedback'))
       {
           return 'Occupancy';
       }
       return null;
   }
    
    public static String getTypeFromMileStoneName(String csmname)
    {
       if(csmname == null)
       {
           return null;
       }
       if(csmname.containsIgnoreCase('Sales to Ops Turnover'))
            return 'Sales to Ops Turnover';
        
       else if (csmname.containsIgnoreCase('Project Kickoff Meeting'))
       {
           return 'Project Kickoff Meeting';
       }
      /* else if(csmname.containsIgnoreCase('Preliminary BOS Design'))
       {
           return 'Preliminary BOS Design';
       }  11/17/2017 */
       /*
        else if(csmname.containsIgnoreCase('BOS Design'))
       {
           return 'Final BOS Design';
       }
       else if(csmname.containsIgnoreCase('IGU Ship'))
       {
           return 'IGU Ship';
       }
     //  else if(csmname.containsIgnoreCase('Architectural Zoning') ||csmname.containsIgnoreCase('BOS Ship') ) 11/17/2017
       else if(csmname.containsIgnoreCase('Architectural Zoning'))
       {
           return 'Architectural Zoning';
       }
       else if(csmname.containsIgnoreCase('BOS Commissioning') || csmname.containsIgnoreCase('Hardware Commissioning'))
       {
           return 'BOS Commissioning';
       }
       else if(csmname.containsIgnoreCase('Intelligence Commissioning') || csmname.containsIgnoreCase('Software Commissioning'))
       {
           return 'Intelligence Commissioning';
       }
       else if(csmname.containsIgnoreCase('Occupancy'))
       {
           return 'Occupancy';
       }
        
       return null;
    }
    
    public static String getCSMNameForMileStoneLogic(String Mname)
    {
        if(Mname == null)
        {
            return null;
        }
        if(Mname.containsIgnoreCase('IGU Ship') )
             {              
                 return 'Initial engagement with customer';
             }
             else if(Mname.containsIgnoreCase('Project Kickoff Meeting'))
             {                
                 return 'Meet with PM to get customer details';
             }
             */
             /* else if(Mname.containsIgnoreCase('Preliminary BOS Design'))
             {                
                 return 'BOS Design Check';
             } 11/17/2017 */
             /*
              else if(Mname.containsIgnoreCase('Final BOS Design'))
             {                
                 return 'BOS Design Check';
             }
              else if(Mname.containsIgnoreCase('Sales to Ops Turnover') )
             {
                 return 'Attend Sales to Ops Turnover MTG';
             }
              //else if(Mname.containsIgnoreCase('Architectural Zoning') || Mname.containsIgnoreCase('BOS Ship') ) 11/17/2017
              else if(Mname.containsIgnoreCase('Architectural Zoning'))
             {             
                 return 'Architectural Zoning';
             }
             else if(Mname.containsIgnoreCase('BOS Commissioning')||Mname.containsIgnoreCase('Hardware Commissioning') )
             {                 
                 return 'BOS Commissioning';
             }
             else if(Mname.containsIgnoreCase('Intelligence Commissioning')|| Mname.containsIgnoreCase('Software Commissioning') )
             {               
                 return 'Intelligence Commissioning';
             }
              else if(Mname.containsIgnoreCase('Occupancy'))
             {                
                 return 'OccupancyMultiple';
             }
        return null;
    }*/