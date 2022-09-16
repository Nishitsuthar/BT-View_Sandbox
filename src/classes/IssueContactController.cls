public without sharing class IssueContactController {
    
    @AuraEnabled
    public static wrapperData fetchcontactsDetails(string contactId){
        wrapperData wrap = new wrapperData();
        Set<string> accIds = new Set<string>();
        
        wrap.accountTypePLV = getPicklistValues('Account','Account_Type__c');
        wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
        //wrap.stagePLV = getPicklistValues('Opportunity','StageName');
        
     /*   List<Contact> conLst = [SELECT Id,Name,AccountID,Account.Name,Account.Account_Type__c FROM Contact WHERE Id=:contactId];
        for(Contact c:conLst){
            accIds.add(c.AccountID);
        }
        
        if(accIds.size()>0){
            List<Opportunity> oppLst = [SELECT Id,Account.Name,Account.Account_Type__c,Name,StageName,owner.Name,Amount,
                                        Construction_Type__c,CloseDate,CreatedDate,Project_City__c,Project_State__c 
                                        FROM Opportunity WHERE AccountID IN:accIds];
            List<tableLvlRecds> tableLstRecds = new List<tableLvlRecds>();
            
            if(oppLst.size()>0){
                for(Opportunity opp:oppLst){
                    tableLvlRecds recd = new tableLvlRecds();
                    recd.AccountName = opp.Account.Name;
                    recd.AccountType = opp.Account.Account_Type__c;
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Name;
                    recd.Stage = opp.StageName;
                    recd.Owner = opp.owner.Name;
                    recd.TotalBuildingSQFT = String.ValueOf(opp.Amount);
                    recd.ConstructionType = opp.Construction_Type__c;
                    recd.CloseDate = String.ValueOf(opp.CloseDate);
                    recd.CreatedDate = String.ValueOf(opp.CreatedDate);
                    recd.City = opp.Project_City__c;
                    recd.State = opp.Project_State__c;
                    tableLstRecds.add(recd);
                }
            }
            wrap.oppAccLvlRecd = tableLstRecds;
            wrap.oppRecLst = oppLst;
        } 
        
        wrap.conReclst = conLst;*/
     list<CurrencyType> ct=   [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM CurrencyType where IsActive=true];
       
        map<string,double> ctmap = new map<string,double>();
        for(CurrencyType c:ct)
        {
          ctmap.put(c.IsoCode,c.ConversionRate);  
        }
        
        List<OpportunityContactRole> oppCOntactRolelst = [SELECT Id,OpportunityId,Opportunity.Project_Glass_Quantity_2__c,Opportunity.Total_Building_Sqft__c,Opportunity.Name,Contact.Account.Name,
                                                          Opportunity.Account.Name,Opportunity.Account.Account_Type__c,Opportunity.StageName,
                                                          Opportunity.CurrencyIsoCode,Opportunity.owner.Name,Opportunity.Amount,Opportunity.Opportunity_ID__c,
                                                          Opportunity.Account.Account_ID__c,Contact.Account.Account_ID__c,
                                                          Opportunity.Construction_Type__c,Opportunity.CloseDate,Opportunity.Design_Win_Date__c,Opportunity.Market_Segment__c,
                                                          Opportunity.CreatedDate,Opportunity.Project_City__c,Opportunity.Amount_Range__c,
                                                          Opportunity.Project_State__c,Contact.Name, Role,Opportunity.Group_Stage__c,
                                                          Contact.Account.Account_Type__c,
                                                          IsPrimary FROM OpportunityContactRole
                                                          WHERE ContactId =:contactId];
        List<tableLvlRecds> sTableLstRecds = new List<tableLvlRecds>();
        
        if(oppCOntactRolelst.size()>0){
            for(OpportunityContactRole opp:oppCOntactRolelst){
                tableLvlRecds recd = new tableLvlRecds();
                recd.AccountName = opp.Opportunity.Account.Name;
                recd.AccountType = opp.Opportunity.Account.Account_Type__c;
                recd.AccountContactName  =opp.Contact.Account.Name;
                recd.AccountContactType =opp.Contact.Account.Account_Type__c;
                recd.ContactName = opp.Contact.Name;
                recd.ContactRole = opp.Role;
                recd.OpportunityName = opp.Opportunity.Name;
                recd.Stage = opp.Opportunity.Group_Stage__c;
                recd.Owner = opp.Opportunity.owner.Name;
              /*  if(opp.Opportunity.CurrencyIsoCode=='USD')
                {
                recd.Amount =  string.isNotBlank(String.ValueOf(opp.Opportunity.Amount)) ? String.ValueOf(opp.Opportunity.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Opportunity.Amount)) ? String.ValueOf((opp.Opportunity.Amount/ctmap.get(opp.Opportunity.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                recd.Amount = String.ValueOf(opp.Opportunity.Amount_Range__c);
                recd.TotalBuildingSQFT =Integer.ValueOf(opp.Opportunity.Total_Building_Sqft__c);
                recd.MarketSegment=opp.Opportunity.Market_Segment__c; 
                recd.ConstructionType = opp.Opportunity.Construction_Type__c;
                recd.CloseDate = String.ValueOf(opp.Opportunity.CloseDate.year()+'/'+opp.Opportunity.CloseDate.month()+'/'+opp.Opportunity.CloseDate.day());//String.ValueOf(opp.Opportunity.CloseDate);
                recd.DesignWin =string.isNotBlank(String.ValueOf(opp.Opportunity.Design_Win_Date__c)) ? String.ValueOf(opp.Opportunity.Design_Win_Date__c.year()+'/'+opp.Opportunity.Design_Win_Date__c.month()+'/'+opp.Opportunity.Design_Win_Date__c.day()) : '';//String.ValueOf(opp.Opportunity.Design_Win_Date__c.year()+'/'+opp.Opportunity.Design_Win_Date__c.month()+'/'+opp.Opportunity.Design_Win_Date__c.day());//String.ValueOf(opp.Opportunity.Design_Win_Date__c);
                recd.CreatedDate = String.ValueOf(opp.Opportunity.CreatedDate.year()+'/'+opp.Opportunity.CreatedDate.month()+'/'+opp.Opportunity.CreatedDate.day());//String.ValueOf(opp.Opportunity.CreatedDate);
                recd.City = opp.Opportunity.Project_City__c;
                recd.State = opp.Opportunity.Project_State__c;
                recd.AccountId = opp.Opportunity.Account.Account_ID__c;
                 recd.Contactaccountid =opp.Contact.Account.Account_ID__c;
                recd.OpportunityId =opp.Opportunity.Opportunity_ID__c ;
                sTableLstRecds.add(recd);
            }
        }
        wrap.cntctRleLvlRecd = sTableLstRecds;
        wrap.oppCntctRoleLst = oppCOntactRolelst;
        wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
       
        string stage  = System.Label.Group_Stage;
        
        wrap.stagePLV  = stage.split(',');
        
        return wrap;
    }
    
     @AuraEnabled
    public static wrapperData fetchpartaccountsDetails(string AccountId){
   
        list<id> accids = new list<id>();
   list<id> oppids = new list<id>();
        accids.add(AccountId);
        
        Account checkreporting = [select id,Reporting_Parent__c from account where id=:AccountId];
       if(checkreporting.Reporting_Parent__c !=null)
       {
           accids.add(checkreporting.Reporting_Parent__c);
       }
      for(Account acc :[select id from account where Reporting_Parent__c=:accids])
      {
         accids.add(acc.id); 
      }
         list<CurrencyType> ct=   [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM CurrencyType where IsActive=true];
       
        map<string,double> ctmap = new map<string,double>();
        for(CurrencyType c:ct)
        {
          ctmap.put(c.IsoCode,c.ConversionRate);  
        }
       
        
        wrapperData wrap = new wrapperData();
        
           wrap.accountTypePLV = getPicklistValues('Account','Account_Type__c');
        wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
     //   wrap.stagePLV = getPicklistValues('Opportunity','StageName');
     
        
        list<Opportunity>  accopplst= [select Id,Account.Name,Project_Glass_Quantity_2__c,Total_Building_Sqft__c,CurrencyIsoCode,Account.Account_Type__c,Name,StageName,Group_Stage__c,owner.Name,Amount,
                                        Construction_Type__c,CloseDate,Market_Segment__c,Amount_Range__c,Design_Win_Date__c,CreatedDate,Project_City__c,Project_State__c,Opportunity_ID__c, 
                                        Account.Account_ID__c FROM Opportunity WHERE AccountID =:accids];
										
						for(Opportunity op:accopplst)
						{
							oppids.add(op.id);
						}							
        
        list<Partner_Account__c> partneracclst =[select id,Partner_Account__c,Partner_Account__r.name,Partner_Account__r.Account_Type__c,
                                                Role__c,Related_Opportunity__r.name,Related_Opportunity__r.Group_Stage__c,Related_Opportunity__r.StageName,Related_Opportunity__r.Amount,
                                                Related_Opportunity__r.Construction_Type__c,Related_Opportunity__r.Project_Glass_Quantity_2__c,Related_Opportunity__r.Total_Building_Sqft__c,Related_Opportunity__r.owner.Name,Related_Opportunity__r.CloseDate,Related_Opportunity__r.Design_Win_Date__c,
                                                 Related_Opportunity__r.CreatedDate,Related_Opportunity__r.CurrencyIsoCode,Related_Opportunity__r.Project_City__c,Related_Opportunity__r.Project_State__c,
                                                Related_Opportunity__r.Amount_Range__c,Related_Opportunity__r.Market_Segment__c,Partner_Account__r.Account_ID__c,Related_Opportunity__r.Opportunity_ID__c,Related_Opportunity__r.Account.Name from Partner_Account__c where Related_Opportunity__c=:oppids];
        
        
                       List<tableLvlRecds> tableLstRecds = new List<tableLvlRecds>();
            
            if(accopplst.size()>0){
                for(Opportunity opp:accopplst){
                    tableLvlRecds recd = new tableLvlRecds();
                    recd.AccountName = opp.Account.Name;
                    recd.AccountType = opp.Account.Account_Type__c;
                    recd.PartnerAccountRole ='';
                    recd.PartnerAccountName='';
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Name;
                    recd.Stage = opp.Group_Stage__c;
                  //  recd.Amount = String.ValueOf(opp.Amount.setScale(0));
               /*   if(opp.CurrencyIsoCode=='USD')
                {
               recd.Amount =  string.isNotBlank(String.ValueOf(opp.Amount)) ? String.ValueOf(opp.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Amount)) ? String.ValueOf((opp.Amount/ctmap.get(opp.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/ 
                    recd.Amount = String.ValueOf(opp.Amount_Range__c);
                    recd.TotalBuildingSQFT =Integer.ValueOf(opp.Total_Building_Sqft__c);
                    recd.MarketSegment=opp.Market_Segment__c;
                    recd.ConstructionType = opp.Construction_Type__c;
                    recd.Owner = opp.owner.Name;
                    recd.CloseDate = String.ValueOf(opp.CloseDate.year()+'/'+opp.CloseDate.month()+'/'+opp.CloseDate.day());//String.ValueOf(opp.CloseDate);
                    recd.DesignWin = string.isNotBlank(String.ValueOf(opp.Design_Win_Date__c)) ? String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day()) : '';//String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day());//String.ValueOf(opp.Design_Win_Date__c);
                    recd.CreatedDate = String.ValueOf(opp.CreatedDate.year()+'/'+opp.CreatedDate.month()+'/'+opp.CreatedDate.day());//String.ValueOf(opp.CreatedDate);
                    recd.City = opp.Project_City__c;
                    recd.State = opp.Project_State__c;
                    recd.AccountId= opp.Account.Account_ID__c;
                    recd.OpportunityId= opp.Opportunity_ID__c;
                    tableLstRecds.add(recd);
                }
            }
        if(partneracclst.size()>0){
                for( Partner_Account__c opp:partneracclst){
                    tableLvlRecds recd = new tableLvlRecds();
                    recd.AccountName = opp.Related_Opportunity__r.Account.Name;
                    recd.AccountType = opp.Partner_Account__r.Account_Type__c;
                    recd.PartnerAccountRole =opp.Role__c;
                    recd.PartnerAccountName=opp.Partner_Account__r.name;
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Related_Opportunity__r.name;
                    recd.Stage = opp.Related_Opportunity__r.Group_Stage__c;
                  //  recd.Amount = String.ValueOf(opp.Related_Opportunity__r.Amount.setScale(0));
             /*     if(opp.Related_Opportunity__r.CurrencyIsoCode=='USD')
                {
              recd.Amount =  string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Amount)) ? String.ValueOf(opp.Related_Opportunity__r.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Amount)) ? String.ValueOf((opp.Related_Opportunity__r.Amount/ctmap.get(opp.Related_Opportunity__r.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                    recd.Amount = String.ValueOf(opp.Related_Opportunity__r.Amount_Range__c);
                    recd.TotalBuildingSQFT =Integer.ValueOf(opp.Related_Opportunity__r.Total_Building_Sqft__c);
 					recd.MarketSegment=opp.Related_Opportunity__r.Market_Segment__c;
                    recd.ConstructionType = opp.Related_Opportunity__r.Construction_Type__c;
                    recd.Owner = opp.Related_Opportunity__r.owner.Name;
                    recd.CloseDate = String.ValueOf(opp.Related_Opportunity__r.CloseDate.year()+'/'+opp.Related_Opportunity__r.CloseDate.month()+'/'+opp.Related_Opportunity__r.CloseDate.day());//String.ValueOf(opp.Related_Opportunity__r.CloseDate);
                    recd.DesignWin =string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c)) ? String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c.year()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.month()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.day()) : '';
                    recd.CreatedDate = String.ValueOf(opp.Related_Opportunity__r.CreatedDate.year()+'/'+opp.Related_Opportunity__r.CreatedDate.month()+'/'+opp.Related_Opportunity__r.CreatedDate.day());//String.ValueOf(opp.Related_Opportunity__r.CreatedDate);
                    recd.City = opp.Related_Opportunity__r.Project_City__c;
                    recd.State = opp.Related_Opportunity__r.Project_State__c;
                    recd.AccountId= opp.Partner_Account__r.Account_ID__c;
                    recd.OpportunityId= opp.Related_Opportunity__r.Opportunity_ID__c;
                    tableLstRecds.add(recd);
                }
            }
            wrap.partRleLvlRecd = tableLstRecds;
          //  wrap.oppRecLst = accopplst;
          wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
      //  wrap.stagePLV = getPicklistValues('Opportunity','StageName');
      string stage  = System.Label.Group_Stage;
        
        wrap.stagePLV  = stage.split(',');
        
       
      
    
    return wrap; 
    }
    
    @AuraEnabled
    public static wrapperData fetchaccountsDetails(string AccountId){
        system.debug('AccountId'+AccountId);
       list<id> accids = new list<id>();
        accids.add(AccountId);
        
        Account checkreporting = [select id,Reporting_Parent__c from account where id=:AccountId];
       if(checkreporting.Reporting_Parent__c !=null)
       {
           accids.add(checkreporting.Reporting_Parent__c);
       }
      for(Account acc :[select id from account where Reporting_Parent__c=:accids])
      {
         accids.add(acc.id); 
      }
           
        
        wrapperData wrap = new wrapperData();
        
           wrap.accountTypePLV = getPicklistValues('Account','Account_Type__c');
        wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
     //   wrap.stagePLV = getPicklistValues('Opportunity','StageName');
     
  list<CurrencyType> ct=   [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM CurrencyType where IsActive=true];
       
        map<string,double> ctmap = new map<string,double>();
        for(CurrencyType c:ct)
        {
          ctmap.put(c.IsoCode,c.ConversionRate);  
        }
            
        list<Opportunity>  accopplst= [select Id,Account.Name,Market_Segment__c,Project_Glass_Quantity_2__c,Total_Building_Sqft__c,Amount_Range__c,CurrencyIsoCode,Account.Account_Type__c,Name,StageName,Group_Stage__c,owner.Name,Amount,
                                        Construction_Type__c,CloseDate,Design_Win_Date__c,CreatedDate,Project_City__c,Project_State__c,Opportunity_ID__c, 
                                        Account.Account_ID__c FROM Opportunity WHERE AccountID =:accids];
        
        list<Partner_Account__c> partneracclst =[select id,Partner_Account__c,Partner_Account__r.name,Partner_Account__r.Account_Type__c,
                                                Role__c,Related_Opportunity__r.CurrencyIsoCode,Related_Opportunity__r.name,Related_Opportunity__r.Group_Stage__c,Related_Opportunity__r.StageName,Related_Opportunity__r.Amount,
                                               Related_Opportunity__r.Amount_Range__c,Related_Opportunity__r.Project_Glass_Quantity_2__c,Related_Opportunity__r.Total_Building_Sqft__c ,Related_Opportunity__r.Market_Segment__c, Related_Opportunity__r.Construction_Type__c,Related_Opportunity__r.owner.Name,Related_Opportunity__r.CloseDate,Related_Opportunity__r.Design_Win_Date__c,
                                                 Related_Opportunity__r.CreatedDate,Related_Opportunity__r.Project_City__c,Related_Opportunity__r.Project_State__c,
                                                Partner_Account__r.Account_ID__c,Related_Opportunity__r.Opportunity_ID__c,Related_Opportunity__r.Account.Name,Related_Opportunity__r.Account.Account_Type__c from Partner_Account__c where Partner_Account__c=:accids];
        
        
                       List<tableLvlRecds> tableLstRecds = new List<tableLvlRecds>();
            system.debug('partneracclst'+partneracclst);
            if(accopplst.size()>0){
                for(Opportunity opp:accopplst){
                    tableLvlRecds recd = new tableLvlRecds();
                    recd.AccountName = opp.Account.Name;
                    recd.AccountType = opp.Account.Account_Type__c;
                    recd.PartnerAccountRole ='';
                    recd.PartnerAccountName='';
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Name;
                    recd.Stage = opp.Group_Stage__c;
                    //system.debug('String.ValueOf(opp.Amount)'+String.ValueOf(opp.Amount)+'opp.Amount'+opp.Amount);
                  //  recd.Amount = String.ValueOf(opp.Amount.setScale(0));
                     
               /*     if(opp.CurrencyIsoCode=='USD')
                {
                 recd.Amount =  string.isNotBlank(String.ValueOf(opp.Amount)) ? String.ValueOf(opp.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Amount)) ? String.ValueOf((opp.Amount/ctmap.get(opp.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                    recd.Amount = String.ValueOf(opp.Amount_Range__c);
                    recd.TotalBuildingSQFT =Integer.ValueOf(opp.Total_Building_Sqft__c);
                    recd.MarketSegment=opp.Market_Segment__c; 
                    
                    recd.ConstructionType = opp.Construction_Type__c;
                    recd.Owner = opp.owner.Name;
                    recd.CloseDate = String.ValueOf(opp.CloseDate.year()+'/'+opp.CloseDate.month()+'/'+opp.CloseDate.day());//String.ValueOf(opp.CloseDate);
                    recd.DesignWin  =string.isNotBlank(String.ValueOf(opp.Design_Win_Date__c)) ? String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day()) : '';  //string.isNotBlank(String.ValueOf(opp.Design_Win_Date__c)) ? String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day()) : '';//; //String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day());//String.ValueOf(opp.Design_Win_Date__c);
                    recd.CreatedDate = String.ValueOf(opp.CreatedDate.year()+'/'+opp.CreatedDate.month()+'/'+opp.CreatedDate.day());//String.ValueOf(opp.CreatedDate);
                    recd.City = opp.Project_City__c;
                    recd.State = opp.Project_State__c;
                    recd.AccountId= opp.Account.Account_ID__c;
                    recd.OpportunityId= opp.Opportunity_ID__c;
                    tableLstRecds.add(recd);
                }
            }
        if(partneracclst.size()>0){
                for( Partner_Account__c opp:partneracclst){
                    tableLvlRecds recd = new tableLvlRecds();
                    recd.AccountName = opp.Related_Opportunity__r.Account.Name;
                    recd.AccountType = opp.Related_Opportunity__r.Account.Account_Type__c;
                    recd.PartnerAccountRole =opp.Role__c;
                    recd.PartnerAccountName=opp.Partner_Account__r.name;
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Related_Opportunity__r.name;
                    recd.Stage = opp.Related_Opportunity__r.Group_Stage__c;
                  //  recd.Amount = String.ValueOf(opp.Related_Opportunity__r.Amount.setScale(0));
                 
              /*         if(opp.Related_Opportunity__r.CurrencyIsoCode=='USD')
                {
                recd.Amount =  string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Amount)) ? String.ValueOf(opp.Related_Opportunity__r.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Amount)) ? String.ValueOf((opp.Related_Opportunity__r.Amount/ctmap.get(opp.Related_Opportunity__r.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                    recd.Amount = String.ValueOf(opp.Related_Opportunity__r.Amount_Range__c);
                    recd.TotalBuildingSQFT =Integer.ValueOf(opp.Related_Opportunity__r.Total_Building_Sqft__c );
                   recd.MarketSegment=opp.Related_Opportunity__r.Market_Segment__c; 
                  
                    recd.ConstructionType = opp.Related_Opportunity__r.Construction_Type__c;
                    recd.Owner = opp.Related_Opportunity__r.owner.Name;
                    recd.CloseDate = String.ValueOf(opp.Related_Opportunity__r.CloseDate.year()+'/'+opp.Related_Opportunity__r.CloseDate.month()+'/'+opp.Related_Opportunity__r.CloseDate.day());// String.ValueOf(opp.Related_Opportunity__r.CloseDate);
                    recd.DesignWin = string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c)) ? String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c.year()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.month()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.day()) : '';   //string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c)) ? String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c.year()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.month()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.day()) : '';// '';//;// String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c);
                    recd.CreatedDate =String.ValueOf(opp.Related_Opportunity__r.CreatedDate.year()+'/'+opp.Related_Opportunity__r.CreatedDate.month()+'/'+opp.Related_Opportunity__r.CreatedDate.day());// String.ValueOf(opp.Related_Opportunity__r.CreatedDate);
                    recd.City = opp.Related_Opportunity__r.Project_City__c;
                    recd.State = opp.Related_Opportunity__r.Project_State__c;
                    recd.AccountId= opp.Partner_Account__r.Account_ID__c;
                    recd.OpportunityId= opp.Related_Opportunity__r.Opportunity_ID__c;
                    tableLstRecds.add(recd);
                }
            }
            wrap.oppAccLvlRecd = tableLstRecds;
            wrap.oppRecLst = accopplst;
          wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
      //  wrap.stagePLV = getPicklistValues('Opportunity','StageName');
      string stage  = System.Label.Group_Stage;
        
        wrap.stagePLV  = stage.split(',');
        
    system.debug('wrapwrap'+wrap);   
      
    
    return wrap;
    }
    
    public class wrapperData{
        @AuraEnabled public List<Account> accRecLst;
        @AuraEnabled public List<Contact> conReclst;
        @AuraEnabled public List<Opportunity> oppRecLst;
        @AuraEnabled public List<OpportunityContactRole> oppCntctRoleLst;
        @AuraEnabled public List<string> accountTypePLV;
        @AuraEnabled public List<string> stagePLV;
        @AuraEnabled public List<string> constructionType;
        @AuraEnabled public List<string> partneraccountrole;
        @AuraEnabled public List<tableLvlRecds> oppAccLvlRecd;
        @AuraEnabled public List<tableLvlRecds> cntctRleLvlRecd;
        @AuraEnabled public List<tableLvlRecds> partRleLvlRecd;
        public wrapperData(){
            oppCntctRoleLst = new List<OpportunityContactRole>();
            conReclst = new List<Contact>();
            oppRecLst = new List<Opportunity>();
        }
        
        
    }
    
    public class tableLvlRecds{
        @AuraEnabled public string AccountName; 
        @AuraEnabled public string PartnerAccountRole;
        @AuraEnabled public string PartnerAccountName;
        @AuraEnabled public string AccountType;
        @AuraEnabled public string AccountContactName;
        @AuraEnabled public string AccountContactType;
        @AuraEnabled public string ContactName; 
        @AuraEnabled public Integer TotalBuildingSQFT;
        @AuraEnabled public string ContactRole; 
        @AuraEnabled public string OpportunityName; 
        @AuraEnabled public string Stage; 
        @AuraEnabled public string Owner; 
        @AuraEnabled public string Amount; 
        @AuraEnabled public string ConstructionType; 
        @AuraEnabled public string CloseDate;
        @AuraEnabled public string DesignWin;
        @AuraEnabled public string CreatedDate; 
        @AuraEnabled public string City; 
        @AuraEnabled public string State; 
        @AuraEnabled public string AccountId; 
        @AuraEnabled public string OpportunityId; 
        @AuraEnabled public string Contactaccountid;
        @AuraEnabled public string MarketSegment;
    }
    
    
    public static List<String> getPicklistValues(string objName,string fieldName){
        List<String> pickLstValues = new List<String>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickLstValues.add(pickListVal.getValue());
         
        }
        return pickLstValues;
    }
    
      @AuraEnabled
    public static wrapperData filteraccountsDetails(string AccountId,string stage,string accounttype,string constuiontype,string partneraccountrole){
  
        system.debug('partneraccountrole'+partneraccountrole);
        system.debug('stage'+stage);
        system.debug('accounttype'+accounttype);
        system.debug('constuiontype'+constuiontype);
        system.debug('partneraccountrole'+partneraccountrole);
        
        List<tableLvlRecds> tableLstRecds = new List<tableLvlRecds>();
          list<id> accids = new list<id>();
        accids.add(AccountId);
          Account checkreporting = [select id,Reporting_Parent__c from account where id=:AccountId];
       if(checkreporting.Reporting_Parent__c !=null)
       {
           accids.add(checkreporting.Reporting_Parent__c);
       }
      for(Account acc :[select id from account where Reporting_Parent__c=:accids ])
      {
         accids.add(acc.id); 
      }
         list<CurrencyType> ct=   [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM CurrencyType where IsActive=true];
       
        map<string,double> ctmap = new map<string,double>();
        for(CurrencyType c:ct)
        {
          ctmap.put(c.IsoCode,c.ConversionRate);  
        }
    
        wrapperData wrap = new wrapperData();
        if(String.isBlank( partneraccountrole ))
        {
        String query = 'select Id,Account.Name,Account.Account_Type__c,Amount_Range__c,Project_Glass_Quantity_2__c,Total_Building_Sqft__c,Market_Segment__c,CurrencyIsoCode,Name,StageName,Group_Stage__c,owner.Name,Amount,'+
                                        'Construction_Type__c,CloseDate,Design_Win_Date__c,CreatedDate,Project_City__c,Project_State__c,Opportunity_ID__c,'+ 
                                        'Account.Account_ID__c FROM Opportunity WHERE AccountID =:accids';
        if( !String.isBlank( stage ) &&  stage !='Choose one...') {
            query += ' AND Group_Stage__c  =: stage';
        }
        if( !String.isBlank( accounttype) &&  accounttype !='Choose one...')  {
            query += ' AND Account.Account_Type__c  =: accounttype ';
        }
        if( !String.isBlank( constuiontype) &&  constuiontype !='Choose one...')  {
            query += ' AND Construction_Type__c  =: constuiontype';
        }
        
        system.debug('query'+query);
        
        list<Opportunity> opplst =Database.query( query );
       for(Opportunity opp : opplst)
       {
           tableLvlRecds recd = new tableLvlRecds();
                    recd.AccountName = opp.Account.Name;
                    recd.AccountType = opp.Account.Account_Type__c;
                    recd.PartnerAccountRole ='';
                    recd.PartnerAccountName='';
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Name;
                    recd.Stage = opp.Group_Stage__c;
                  //  recd.Amount = String.ValueOf(opp.Amount.setScale(0));
               /*   if(opp.CurrencyIsoCode=='USD')
                {
                 recd.Amount =  string.isNotBlank(String.ValueOf(opp.Amount)) ? String.ValueOf(opp.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Amount)) ? String.ValueOf((opp.Amount/ctmap.get(opp.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                    recd.Amount = String.ValueOf(opp.Amount_Range__c);
                    recd.TotalBuildingSQFT =Integer.ValueOf(opp.Total_Building_Sqft__c);
                    recd.MarketSegment=opp.Market_Segment__c;
                    recd.ConstructionType = opp.Construction_Type__c;
                    recd.Owner = opp.owner.Name;
                    recd.CloseDate = String.ValueOf(opp.CloseDate.year()+'/'+opp.CloseDate.month()+'/'+opp.CloseDate.day());//String.ValueOf(opp.CloseDate);
                    recd.DesignWin = string.isNotBlank(String.ValueOf(opp.Design_Win_Date__c)) ? String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day()) : '';//String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day());//String.ValueOf(opp.Design_Win_Date__c);
                    recd.CreatedDate = String.ValueOf(opp.CreatedDate.year()+'/'+opp.CreatedDate.month()+'/'+opp.CreatedDate.day());//String.ValueOf(opp.CreatedDate);
                    recd.City = opp.Project_City__c;
                    recd.State = opp.Project_State__c;
                    recd.AccountId= opp.Account.Account_ID__c;
                    recd.OpportunityId= opp.Opportunity_ID__c;
                    tableLstRecds.add(recd);
       }
        }
        system.debug('accids'+accids);
          String query1 = 'select id,Partner_Account__c,Partner_Account__r.name,Partner_Account__r.Account_Type__c,'+
                                                'Related_Opportunity__r.Amount_Range__c,Related_Opportunity__r.Market_Segment__c,Role__c,Related_Opportunity__r.name,Related_Opportunity__r.Group_Stage__c,Related_Opportunity__r.StageName,Related_Opportunity__r.Amount,'+
                                                'Related_Opportunity__r.Construction_Type__c,Related_Opportunity__r.owner.Name,Related_Opportunity__r.Design_Win_Date__c,Related_Opportunity__r.CloseDate,'+
                                                 'Related_Opportunity__r.CreatedDate,Related_Opportunity__r.CurrencyIsoCode,Related_Opportunity__r.Project_City__c,Related_Opportunity__r.Project_State__c,'+
                                                'Partner_Account__r.Account_ID__c,Related_Opportunity__r.Project_Glass_Quantity_2__c,Related_Opportunity__r.Total_Building_Sqft__c,Related_Opportunity__r.Opportunity_ID__c,Related_Opportunity__r.Account.Name,Related_Opportunity__r.Account.Account_Type__c from Partner_Account__c where Partner_Account__c=:accids';
        if( !String.isBlank( stage ) &&  stage !='Choose one...') {
            query1 += ' AND Related_Opportunity__r.Group_Stage__c  =: stage';
        }
        if( !String.isBlank( accounttype) &&  accounttype !='Choose one...')  {
            query1 += ' AND Related_Opportunity__r.Account.Account_Type__c  =: accounttype ';
        }
        if( !String.isBlank( constuiontype) &&  constuiontype !='Choose one...')  {
            query1 += ' AND Related_Opportunity__r.Construction_Type__c  =: constuiontype';
        }
        
        if( !String.isBlank( partneraccountrole) &&  partneraccountrole !='Choose one...')  {
            query1 += ' AND  Role__c =: partneraccountrole';
        }
        system.debug('query'+query1);
          list<Partner_Account__c> partacclst=Database.query( query1 );
        system.debug('partacclst'+partacclst.size());
          for(Partner_Account__c opp:partacclst){
                    tableLvlRecds recd = new tableLvlRecds();
                   recd.AccountName = opp.Related_Opportunity__r.Account.Name;
                    recd.AccountType = opp.Related_Opportunity__r.Account.Account_Type__c;
                    recd.PartnerAccountRole =opp.Role__c;
                    recd.PartnerAccountName=opp.Partner_Account__r.name;
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Related_Opportunity__r.name;
                    recd.Stage = opp.Related_Opportunity__r.Group_Stage__c;
                 //   recd.Amount = String.ValueOf(opp.Related_Opportunity__r.Amount.setScale(0));
             /*         if(opp.Related_Opportunity__r.CurrencyIsoCode=='USD')
                {
                recd.Amount =  string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Amount)) ? String.ValueOf(opp.Related_Opportunity__r.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Amount)) ? String.ValueOf((opp.Related_Opportunity__r.Amount/ctmap.get(opp.Related_Opportunity__r.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                    recd.Amount = String.ValueOf(opp.Related_Opportunity__r.Amount_Range__c);
                    recd.TotalBuildingSQFT =Integer.ValueOf(opp.Related_Opportunity__r.Total_Building_Sqft__c);
                    recd.MarketSegment=opp.Related_Opportunity__r.Market_Segment__c;
                    recd.ConstructionType = opp.Related_Opportunity__r.Construction_Type__c;
                    recd.Owner = opp.Related_Opportunity__r.owner.Name;
                    recd.CloseDate = String.ValueOf(opp.Related_Opportunity__r.CloseDate.year()+'/'+opp.Related_Opportunity__r.CloseDate.month()+'/'+opp.Related_Opportunity__r.CloseDate.day());//String.ValueOf(opp.Related_Opportunity__r.CloseDate);
                    recd.DesignWin = string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c)) ? String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c.year()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.month()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.day()) : '';//String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c.year()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.month()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.day());//String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c);
                    recd.CreatedDate = String.ValueOf(opp.Related_Opportunity__r.CreatedDate.year()+'/'+opp.Related_Opportunity__r.CreatedDate.month()+'/'+opp.Related_Opportunity__r.CreatedDate.day());//String.ValueOf(opp.Related_Opportunity__r.CreatedDate);
                    recd.City = opp.Related_Opportunity__r.Project_City__c;
                    recd.State = opp.Related_Opportunity__r.Project_State__c;
                    recd.AccountId= opp.Partner_Account__r.Account_ID__c;
                    recd.OpportunityId= opp.Related_Opportunity__r.Opportunity_ID__c;
                    tableLstRecds.add(recd);
                }
        system.debug('tableLstRecds'+tableLstRecds.size());
         wrap.oppAccLvlRecd = tableLstRecds;
         wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
      string stage1  = System.Label.Group_Stage;
        
        wrap.stagePLV  = stage1.split(',');
          wrap.accountTypePLV = getPicklistValues('Account','Account_Type__c');
       
          //  wrap.oppRecLst = accopplst;
        system.debug('wrap.oppAccLvlRecd'+wrap.oppAccLvlRecd.size());    
     return wrap;   
    }
    
      @AuraEnabled
    public static wrapperData filtercontatcsDetails(string contactId,string stage,string accounttype,string constuiontype){
  system.debug('AccountId'+contactId+'stage'+stage+'accounttype'+accounttype+'constuiontype'+constuiontype);
          wrapperData wrap = new wrapperData();
        List<tableLvlRecds> sTableLstRecds = new List<tableLvlRecds>();
         list<CurrencyType> ct=   [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM CurrencyType where IsActive=true];
       
        map<string,double> ctmap = new map<string,double>();
        for(CurrencyType c:ct)
        {
          ctmap.put(c.IsoCode,c.ConversionRate);  
        }
    
        String query = 'SELECT Id,OpportunityId,Opportunity.Name,Opportunity.Market_Segment__c,Opportunity.Amount_Range__c,Opportunity.CurrencyIsoCode,Contact.Account.Name,Opportunity.Group_Stage__c,'+
                         'Opportunity.Account.Name,Opportunity.Account.Account_Type__c,Opportunity.StageName,Opportunity.Project_Glass_Quantity_2__c,Opportunity.Total_Building_Sqft__c,'+
                                                          'Opportunity.owner.Name,Opportunity.Amount,'+
                                                          'Opportunity.Construction_Type__c,Opportunity.CloseDate,Opportunity.Design_Win_Date__c,'+
                                                          'Opportunity.CreatedDate,Opportunity.Project_City__c,'+
                                                          'Opportunity.Project_State__c,Contact.Name, Role,'+
                                                          'Contact.Account.Account_Type__c,Opportunity.Account.Account_ID__c,'+
                                                          'Contact.Account.Account_ID__c,Opportunity.Opportunity_ID__c,IsPrimary FROM OpportunityContactRole'+
                                                          ' WHERE ContactId =:contactId';
        
         if( !String.isBlank( stage ) &&  stage !='Choose one...') {
            query += ' AND Opportunity.Group_Stage__c  =: stage';
        }
        if( !String.isBlank( accounttype) &&  accounttype !='Choose one...')  {
            query += ' AND Opportunity.Account.Account_Type__c  =: accounttype ';
        }
        if( !String.isBlank( constuiontype) &&  constuiontype !='Choose one...')  {
            query += ' AND Opportunity.Construction_Type__c  =: constuiontype';
        }
        system.debug('query'+query);
        list<OpportunityContactRole> oppCOntactRolelst =Database.query(query);
        for(OpportunityContactRole opp:oppCOntactRolelst){
                tableLvlRecds recd = new tableLvlRecds();
                recd.AccountName = opp.Opportunity.Account.Name;
                recd.AccountType = opp.Opportunity.Account.Account_Type__c;
                recd.AccountContactName  =opp.Contact.Account.Name;
                recd.AccountContactType =opp.Contact.Account.Account_Type__c;
                recd.ContactName = opp.Contact.Name;
                recd.ContactRole = opp.Role;
                recd.OpportunityName = opp.Opportunity.Name;
                recd.Stage = opp.Opportunity.Group_Stage__c;
                recd.Owner = opp.Opportunity.owner.Name;
              //  recd.Amount = String.ValueOf(opp.Opportunity.Amount.setScale(0));
          /*    if(opp.Opportunity.CurrencyIsoCode=='USD')
                  {
                recd.Amount =  string.isNotBlank(String.ValueOf(opp.Opportunity.Amount)) ? String.ValueOf(opp.Opportunity.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Opportunity.Amount)) ? String.ValueOf((opp.Opportunity.Amount/ctmap.get(opp.Opportunity.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                recd.Amount = String.ValueOf(opp.Opportunity.Amount_Range__c);
                recd.TotalBuildingSQFT =Integer.ValueOf(opp.Opportunity.Total_Building_Sqft__c);
                recd.MarketSegment=opp.Opportunity.Market_Segment__c; 
                recd.ConstructionType = opp.Opportunity.Construction_Type__c;
                recd.CloseDate = String.ValueOf(opp.Opportunity.CloseDate.year()+'/'+opp.Opportunity.CloseDate.month()+'/'+opp.Opportunity.CloseDate.day());//String.ValueOf(opp.Opportunity.CloseDate);
                 recd.DesignWin =string.isNotBlank(String.ValueOf(opp.Opportunity.Design_Win_Date__c)) ? String.ValueOf(opp.Opportunity.Design_Win_Date__c.year()+'/'+opp.Opportunity.Design_Win_Date__c.month()+'/'+opp.Opportunity.Design_Win_Date__c.day()) : '';//String.ValueOf(opp.Opportunity.Design_Win_Date__c.year()+'/'+opp.Opportunity.Design_Win_Date__c.month()+'/'+opp.Opportunity.Design_Win_Date__c.day());//String.ValueOf(opp.Opportunity.Design_Win_Date__c);
                recd.CreatedDate = String.ValueOf(opp.Opportunity.CreatedDate.year()+'/'+opp.Opportunity.CreatedDate.month()+'/'+opp.Opportunity.CreatedDate.day());// opp.Opportunity.CreatedDate.month(), opp.Opportunity.CreatedDate.day();
                recd.City = opp.Opportunity.Project_City__c;
                recd.State = opp.Opportunity.Project_State__c;
               recd.AccountId = opp.Opportunity.Account.Account_ID__c;
                 recd.Contactaccountid =opp.Contact.Account.Account_ID__c;
                recd.OpportunityId =opp.Opportunity.Opportunity_ID__c ;
                sTableLstRecds.add(recd);
            }
        
      
          wrap.cntctRleLvlRecd = sTableLstRecds;
         wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
      string stage1  = System.Label.Group_Stage;
        
        wrap.stagePLV  = stage1.split(',');
          wrap.accountTypePLV = getPicklistValues('Account','Account_Type__c');
       
      
     return wrap;   
    }
    
     @AuraEnabled
    public static wrapperData filterpartDetails(string AccountId,string stage,string accounttype,string constuiontype,string partneraccountrole){
    list<id> accids = new list<id>();
  list<id> oppids = new list<id>();
        system.debug('partneraccountrole'+partneraccountrole);
        system.debug('accounttype'+accounttype);
        List<tableLvlRecds> tableLstRecds = new List<tableLvlRecds>();
        accids.add(AccountId);
          Account checkreporting = [select id,Reporting_Parent__c from account where id=:AccountId];
       if(checkreporting.Reporting_Parent__c !=null)
       {
           accids.add(checkreporting.Reporting_Parent__c);
       }
      for(Account acc :[select id from account where Reporting_Parent__c=:accids ])
      {
         accids.add(acc.id); 
      }
        
         list<CurrencyType> ct=   [SELECT Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM CurrencyType where IsActive=true];
       
        map<string,double> ctmap = new map<string,double>();
        for(CurrencyType c:ct)
        {
          ctmap.put(c.IsoCode,c.ConversionRate);  
        }
    
        
        wrapperData wrap = new wrapperData();
        system.debug('');
        String query = 'select Id,Account.Name,Account.Account_Type__c,Market_Segment__c,Amount_Range__c,Project_Glass_Quantity_2__c,Total_Building_Sqft__c,Name,CurrencyIsoCode,StageName,Group_Stage__c,owner.Name,Amount,'+
                                        'Construction_Type__c,CloseDate,Design_Win_Date__c,CreatedDate,Project_City__c,Project_State__c,Opportunity_ID__c,'+ 
                                        'Account.Account_ID__c FROM Opportunity WHERE AccountID =:accids';
        if( !String.isBlank( stage ) &&  stage !='Choose one...') {
            query += ' AND Group_Stage__c  =: stage';
        }
        if( !String.isBlank( accounttype) &&  accounttype !='Choose one...')  {
            query += ' AND Account.Account_Type__c  =: accounttype ';
        }
        if( !String.isBlank( constuiontype) &&  constuiontype !='Choose one...')  {
            query += ' AND Construction_Type__c  =: constuiontype';
        }
        
        system.debug('query'+query);
        
        list<Opportunity> opplst =Database.query( query );
       for(Opportunity opp : opplst)
       {
           tableLvlRecds recd = new tableLvlRecds();
                    recd.AccountName = opp.Account.Name;
                    recd.AccountType = opp.Account.Account_Type__c;
                    recd.PartnerAccountRole ='';
                    recd.PartnerAccountName='';
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Name;
                    recd.Stage = opp.Group_Stage__c;
                 //   recd.Amount = String.ValueOf(opp.Amount.setScale(0));
               /*    if(opp.CurrencyIsoCode=='USD')
                {
                recd.Amount =  string.isNotBlank(String.ValueOf(opp.Amount)) ? String.ValueOf(opp.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Amount)) ? String.ValueOf((opp.Amount/ctmap.get(opp.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                    recd.Amount = String.ValueOf(opp.Amount_Range__c);
                    recd.TotalBuildingSQFT =Integer.ValueOf(opp.Total_Building_Sqft__c);
                    recd.MarketSegment=opp.Market_Segment__c;
                    recd.ConstructionType = opp.Construction_Type__c;
                    recd.Owner = opp.owner.Name;
                    recd.CloseDate = String.ValueOf(opp.CloseDate.year()+'/'+opp.CloseDate.month()+'/'+opp.CloseDate.day());//String.ValueOf(opp.CloseDate);
                    recd.DesignWin = string.isNotBlank(String.ValueOf(opp.Design_Win_Date__c)) ? String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day()) : '';//String.ValueOf(opp.Design_Win_Date__c.year()+'/'+opp.Design_Win_Date__c.month()+'/'+opp.Design_Win_Date__c.day());//String.ValueOf(opp.Design_Win_Date__c);
                    recd.CreatedDate = String.ValueOf(opp.CreatedDate.year()+'/'+opp.CreatedDate.month()+'/'+opp.CreatedDate.day());//String.ValueOf(opp.CreatedDate);
                    recd.City = opp.Project_City__c;
                    recd.State = opp.Project_State__c;
                    recd.AccountId= opp.Account.Account_ID__c;
                    recd.OpportunityId= opp.Opportunity_ID__c;
                  if(String.isBlank(partneraccountrole))
        {
                     tableLstRecds.add(recd);
        }
					oppids.add(opp.id);
       }
        
        system.debug('oppids'+oppids);
          String query1 = 'select id,Partner_Account__c,Partner_Account__r.name,Related_Opportunity__r.Account.Account_Type__c,Partner_Account__r.Account_Type__c,'+
                                                'Role__c,Related_Opportunity__r.name,Related_Opportunity__r.Group_Stage__c,Related_Opportunity__r.StageName,Related_Opportunity__r.Amount,'+
                                                'Related_Opportunity__r.Construction_Type__c,Related_Opportunity__r.owner.Name,Related_Opportunity__r.Project_Glass_Quantity_2__c,Related_Opportunity__r.Total_Building_Sqft__c,Related_Opportunity__r.Design_Win_Date__c,Related_Opportunity__r.CloseDate,'+
                                                 'Related_Opportunity__r.Market_Segment__c,Related_Opportunity__r.Amount_Range__c,Related_Opportunity__r.CreatedDate,Related_Opportunity__r.CurrencyIsoCode,Related_Opportunity__r.Project_City__c,Related_Opportunity__r.Project_State__c,'+
                                                'Partner_Account__r.Account_ID__c,Related_Opportunity__r.Opportunity_ID__c,Related_Opportunity__r.Account.Name from Partner_Account__c where Related_Opportunity__c=:oppids';
        if( !String.isBlank( stage ) &&  stage !='Choose one...') {
            query1 += ' AND Related_Opportunity__r.Group_Stage__c  =: stage';
        }
        if( !String.isBlank( accounttype) &&  accounttype !='Choose one...')  {
            query1 += ' AND Related_Opportunity__r.Account.Account_Type__c  =: accounttype ';
        }
        if( !String.isBlank( constuiontype) &&  constuiontype !='Choose one...')  {
            query1 += ' AND Related_Opportunity__r.Construction_Type__c  =: constuiontype';
        }
        
        if( !String.isBlank( partneraccountrole) &&  partneraccountrole !='Choose one...')  {
            query1 += ' AND  Role__c =: partneraccountrole';
        }
        system.debug('query'+query1);
          list<Partner_Account__c> partacclst=Database.query( query1 );
        system.debug('partacclst'+partacclst.size());
          for(Partner_Account__c opp:partacclst){
                    tableLvlRecds recd = new tableLvlRecds();
                   recd.AccountName = opp.Related_Opportunity__r.Account.Name;
                    recd.AccountType = opp.Related_Opportunity__r.Account.Account_Type__c;
                    recd.PartnerAccountRole =opp.Role__c;
                    recd.PartnerAccountName=opp.Partner_Account__r.name;
                    //recd.ContactName = opp.Account.Name;
                    //recd.ContactRole = opp.Account.Name;
                    recd.OpportunityName = opp.Related_Opportunity__r.name;
                    recd.Stage = opp.Related_Opportunity__r.Group_Stage__c;
                  //  recd.Amount = String.ValueOf(opp.Related_Opportunity__r.Amount.setScale(0));
                 /*    if(opp.Related_Opportunity__r.CurrencyIsoCode=='USD')
                {
                 recd.Amount =  string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Amount)) ? String.ValueOf(opp.Related_Opportunity__r.Amount.setScale(0)) : '0';  
                    }
                else
                {
                  recd.Amount = string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Amount)) ? String.ValueOf((opp.Related_Opportunity__r.Amount/ctmap.get(opp.Related_Opportunity__r.CurrencyIsoCode)).setScale(0)) : '0';
                  
                }*/
                    recd.Amount = String.ValueOf(opp.Related_Opportunity__r.Amount_Range__c);
                    recd.TotalBuildingSQFT =Integer.ValueOf(opp.Related_Opportunity__r.Total_Building_Sqft__c);
                    recd.MarketSegment=opp.Related_Opportunity__r.Market_Segment__c;
                    recd.ConstructionType = opp.Related_Opportunity__r.Construction_Type__c;
                    recd.Owner = opp.Related_Opportunity__r.owner.Name;
                    recd.CloseDate = String.ValueOf(opp.Related_Opportunity__r.CloseDate.year()+'/'+opp.Related_Opportunity__r.CloseDate.month()+'/'+opp.Related_Opportunity__r.CloseDate.day());//String.ValueOf(opp.Related_Opportunity__r.CloseDate);
                    recd.DesignWin = string.isNotBlank(String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c)) ? String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c.year()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.month()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.day()) : '';//String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c.year()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.month()+'/'+opp.Related_Opportunity__r.Design_Win_Date__c.day());//String.ValueOf(opp.Related_Opportunity__r.Design_Win_Date__c);
                    recd.CreatedDate = String.ValueOf(opp.Related_Opportunity__r.CreatedDate.year()+'/'+opp.Related_Opportunity__r.CreatedDate.month()+'/'+opp.Related_Opportunity__r.CreatedDate.day());//String.ValueOf(opp.Related_Opportunity__r.CreatedDate);
                    recd.City = opp.Related_Opportunity__r.Project_City__c;
                    recd.State = opp.Related_Opportunity__r.Project_State__c;
                    recd.AccountId= opp.Partner_Account__r.Account_ID__c;
                    recd.OpportunityId= opp.Related_Opportunity__r.Opportunity_ID__c;
                    tableLstRecds.add(recd);
                }
        system.debug('tableLstRecds'+tableLstRecds.size());
         wrap.partRleLvlRecd = tableLstRecds;
         wrap.constructionType = getPicklistValues('Opportunity','Construction_Type__c');
        wrap.partneraccountrole= getPicklistValues('Partner_Account__c','Role__c');
      string stage1  = System.Label.Group_Stage;
        
        wrap.stagePLV  = stage1.split(',');
          wrap.accountTypePLV = getPicklistValues('Account','Account_Type__c');
       
          //  wrap.oppRecLst = accopplst;
         
     return wrap;   
    }
    
}