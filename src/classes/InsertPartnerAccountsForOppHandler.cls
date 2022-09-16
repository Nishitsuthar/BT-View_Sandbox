public class InsertPartnerAccountsForOppHandler {
 public void InsertPartnerAccount(List<OpportunityContactRole> oppTrigger){
        system.debug('oppTriggeroppTrigger'+oppTrigger);
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id, Id> contAccountMap = new Map<Id,Id>(); 
        Map<Id, Id> contOppMap = new Map<Id,Id>(); 
        Map<Id, Id> partnerAccountIdMap = new Map<Id,Id>(); 
        Map<Id, String> contRoleMap = new Map<Id,String>();
        List<Partner_Account__c> partnerAccList = new List<Partner_Account__c>();
        for(OpportunityContactRole oppConRole : oppTrigger){
            contactIdSet.add(oppConRole.contactId);
            contRoleMap.put(oppConRole.Id, oppConRole.Role);
            //contAccountMap.put(oppConRole.Id, oppConRole.contact.AccountId);
            system.debug('contAccountMap :: '+contAccountMap);
            contOppMap.put(oppConRole.Id, oppConRole.opportunityId);
        }
    
        if(!contactIdSet.isEmpty()){
            for(contact con : [SELECT Id, Name, AccountId from contact where Id IN : contactIdSet]){
                contAccountMap.put(con.Id, con.AccountId);
            }
        }
        for(Partner_Account__c partnerAcc : [SELECT Id, Name, Partner_Account__c , Related_Opportunity__c from Partner_Account__c WHERE Related_Opportunity__c IN : contOppMap.values()]){
            partnerAccountIdMap.put(partnerAcc.Partner_Account__c, partnerAcc.Partner_Account__c);     
        }
        
        for(OpportunityContactRole oppConRole : oppTrigger){
            System.debug('oppConRole Role :: ' + oppConRole.Role);  
            if(partnerAccountIdMap != Null){ 
                if(contAccountMap.containsKey(oppConRole.contactId)){
                    if(!partnerAccountIdMap.containsKey(contAccountMap.get(oppConRole.contactId))){
                        Partner_Account__c partnerAccount = new Partner_Account__c();
                        partnerAccount.Partner_Account__c = contAccountMap.get(oppConRole.contactId);
                        system.debug('oppConRole.Role'+oppConRole.Role);

                        partnerAccount.Role__c = getContactRoleMapping(oppConRole.Role);
                        partnerAccount.Related_Opportunity__c = oppConRole.opportunityId;
                        partnerAccList.add(partnerAccount);
                    }                    
                }       
            }
        }
    
        if(!partnerAccList.isEmpty()){
            insert partnerAccList;
        }
            
    }
    
    public String getContactRoleMapping(String contRole){
        String partnerRole;
        system.debug('contRole'+contRole);
        if(contRole != null)
        {
        ContactRoleMapping__c con = ContactRoleMapping__c.getValues(contRole);
        
      //  system.debug('con'+con);
        if(con.Partner_Account__c != null){
        partnerRole = con.Partner_Account__c;
        }
            }
        return partnerRole;
    }
}