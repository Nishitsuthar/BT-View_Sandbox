public class createCaseFromOppCtlr {

    @AuraEnabled
    public static Opportunity getOppInfo(Id oppId) {
        Opportunity opp = [SELECT Id, AccountId, Account.Name, Name, 
                            (SELECT Id, Opportunity__c, Name FROM Building_Accounts__r),
                            (SELECT Id,ContactId FROM OpportunityContactRoles)
                            FROM Opportunity WHERE Id = :oppId];

        return opp;
    }

    @AuraEnabled
    public static Case createCase(string accId, string oppId, string customerSiteId, string contactId, String subject, String caseType, Date issueStrDate, String description, string status) {
        system.debug('accId=='+Id.valueOf(accId));
        Case caseRec = new Case(AccountId = Id.valueOf(accId), Opportunity__c = Id.valueOf(oppId), ContactId = Id.valueOf(contactId), Customer_Site__c = Id.valueOf(customerSiteId),
                                Subject = subject, Type = caseType, Intelligence_Start_Date__c = issueStrDate, Description = description, Status = 'New',
                                RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Product Issue').getRecordTypeId());
		system.debug('caseRec=before='+caseRec);
        insert caseRec;
		system.debug('caseRec=after='+caseRec);
        return caseRec;
       
    }

    @AuraEnabled
    public static List<Building_Account__c> getCustomerSites(Id oppId) {
        return [SELECT Id, Name FROM Building_Account__c WHERE Opportunity__c = :oppId];
    }

    @AuraEnabled
    public static List<OpportunityContactRole> fetchContacts(Id oppId,Id accountId) {
        return [SELECT ContactId, Contact.Name,Contact.AccountId,Role,Contact.Title FROM OpportunityContactRole WHERE OpportunityId = :oppId AND Contact.AccountId =: accountid];
    }

    @AuraEnabled
    public static List<AccountRoleWrap> getAccounts(Id oppId) {
        List<Account> retAccts = new List<Account>();
        List<AccountRoleWrap> rolewrap=New List<AccountRoleWrap>();
        
		map<string,Account> accmap=New map<string,Account>();
        for( Account oppAcct : [SELECT Id, Name FROM Account
                                WHERE Id = :[SELECT Id, AccountId FROM Opportunity
                               WHERE Id = :oppId].AccountId]){
                                    retAccts.add(oppAcct);
                                   accmap.put(oppAcct.Name,oppAcct);
                                  /* AccountRoleWrap roles=New AccountRoleWrap();
                                   roles.lable=oppAcct.Name;
                                   roles.Ids=oppAcct.Id;
                                   rolewrap.add(roles);*/
                             }
        
		system.debug('==rolewrap=1='+rolewrap);
        Set<Id> pAAcctsIs = new Set<Id>();
        for(Partner_Account__c eachPAAcct : [SELECT Id, Partner_Account__c, Partner_Account__r.Name,Role__c FROM Partner_Account__c WHERE Related_Opportunity__c = :oppId]) {
           AccountRoleWrap roless=New AccountRoleWrap();
            if(!accmap.containskey(eachPAAcct.Partner_Account__r.Name)){
            pAAcctsIs.add(eachPAAcct.Partner_Account__c);
                
                 roless.lable=eachPAAcct.Partner_Account__r.Name+' - '+eachPAAcct.Role__c;
                                   roless.Ids=eachPAAcct.Partner_Account__c;
                                   
            }else{
                roless.lable=eachPAAcct.Partner_Account__r.Name+' - '+eachPAAcct.Role__c;
                                   roless.Ids=eachPAAcct.Partner_Account__c;
            }
            rolewrap.add(roless);
        }
		system.debug('==rolewrap=='+rolewrap);
        List<Account> pAAccts = [SELECT Id, Name FROM Account WHERE Id IN :pAAcctsIs];
        if(pAAccts.size() > 0) {
            retAccts.addAll(pAAccts);
        }

        return rolewrap;
    }
    public class AccountRoleWrap{
        @AuraEnabled
        public string lable{get;set;}
        @AuraEnabled
        public string Ids{get;set;}
    }
}