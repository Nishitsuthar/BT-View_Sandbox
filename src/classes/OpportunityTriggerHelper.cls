public class OpportunityTriggerHelper{
    
    public static void supportRegionUpdate(List<Opportunity> newList,Map<id,Opportunity> oldMap){
     Map<String,SalesSupportDirector__c> salesDirectors = SalesSupportDirector__c.getAll();
    List<String> AllSalesDirectors =new List<String>();
    for(String sd : salesDirectors.keyset())
    {
        AllSalesDirectors.add(salesDirectors.get(sd).User_Name__c);
    }
    List<User> SalesDireUsers = [select id,name from user where Name IN: AllSalesDirectors];
    Map<String,Id> DirName_Id = new Map<String,ID>();
    for(User u : SalesDireUsers )
    {
        DirName_Id.put(u.Name,u.Id);
    }
     // CSM Milestone
     Map<String,Customer_Success_Manager__c> CSM = Customer_Success_Manager__c.getAll();
     List<String> AllCSM =new List<String>();
     
     for(String sd:CSM.keySet())
     {
         AllCSM.add(CSM.get(sd).User_Name__c);
     }
    List<User> CSM1=[Select id,name from user where Name IN:AllCSM];
    Map<String,Id> MgrName_Id = new Map<String,ID>();
    for(User u: CSM1)
    {
        MgrName_Id.put(u.Name,u.Id);
    }
    
    
    for(Opportunity a : newList)
    {
        
    
        if(oldMap==null ||(oldMap.get(a.id).Support_Region__c != a.Support_Region__c || String.IsBlank(a.Sales_Director__c)) )
        //a.UserProfile__c !='SalesOPS User' &&(
       //a.UserProfile__c != 'System Administrator'&&
        {
        
            if (a.Support_Region__c == 'Atlanta/Carolinas') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Brian Horton
            else if (a.Support_Region__c == 'Bay Area') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Randy Schmitz
            else if (a.Support_Region__c == 'Boston') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Peter Kujawski
            else if (a.Support_Region__c == 'Chicago') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Mike Lane
            else if (a.Support_Region__c == 'Dallas') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Jay Elms
            else if (a.Support_Region__c == 'Mountain') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);}
            else if (a.Support_Region__c == 'Florida') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Peter Kujawski
            else if (a.Support_Region__c == 'Hawaii') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Lance Murata
            else if (a.Support_Region__c == 'Houston') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Matt LeBlanc
            else if (a.Support_Region__c == 'International') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);}
            else if (a.Support_Region__c == 'Pacific Southwest') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);}
            else if (a.Support_Region__c == 'Memphis/Mid-South') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);}
            else if (a.Support_Region__c == 'New York') {a.Sales_Director__c =DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Brian Klansky
           // else if (a.Support_Region__c == 'Phoenix/Vegas') {a.Sales_Director__c =DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);}
            else if (a.Support_Region__c == 'Pacific Northwest') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Brad Baker
            else if (a.Support_Region__c == 'Toronto') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // John Carpenter
            else if (a.Support_Region__c == 'Vancouver') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Guthrie Cox
            else if (a.Support_Region__c == 'Washington DC') {a.Sales_Director__c = DirName_Id.get(salesDirectors.get(a.Support_Region__c).User_Name__c);} // Peter Kujawski
           
       }
          // CSM Milestone
           
       if(oldMap==null ||(oldMap.get(a.id).Support_Region__c != a.Support_Region__c || String.IsBlank(a.CSM_Project_Manager__c )) ){
       System.debug('inside--->'+a.CSM_Project_Manager__c);
            if (a.Support_Region__c =='Atlanta/Carolinas'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Bay Area'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Boston'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Chicago'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Dallas'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Florida'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Hawaii'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Houston'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='International'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Pacific Southwest'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Memphis/Mid-South'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Mountain'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='New York'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Pacific Northwest'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Toronto'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Vancouver'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
             else if(a.Support_Region__c =='Washington DC'){a.CSM_Project_Manager__c = MgrName_Id.get(CSM.get(a.Support_Region__c).User_Name__c);}
        }
          
    }
    
     }    
    
    public static void beforeInsert(List<Opportunity> newList ){
    Id profileId = Id.valueOf(UserInfo.getProfileId());
    Id currentUserId = Id.valueOf(UserInfo.getUserId());
    
    Profile userProfile = [SELECT Id, Name from Profile WHERE ID=:profileId LIMIT 1];


    if (userProfile.name == 'Sales Development')
    {
         for (Opportunity opty : newList)
        {
            opty.Inside_Sales_Owner__c = currentUserId;
        }
    }
        
    }
    public static void beforeUpdate(List<Opportunity> newList ,Map<id,Opportunity> oldMap){
       // Id opportunityRecordTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();
        Id opportunityRecordTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId(); //added by NN

        for(Opportunity oppRec : newList){
            if(oppRec.RecordTypeId != oldMap.get(oppRec.Id).RecordTypeId &&  oppRec.RecordTypeId == opportunityRecordTypeId && oppRec.Target_SE__c != null) {
                    oppRec.OwnerId = oppRec.Target_SE__c;
            }
        }
    }
    /*
    public static void afterInsert(List<Opportunity> newList ,Map<id,Opportunity> oldMap){
        
    }
    public static void afterUpdate(List<Opportunity> newList ,Map<id,Opportunity> oldMap){
        
    } */
    
}