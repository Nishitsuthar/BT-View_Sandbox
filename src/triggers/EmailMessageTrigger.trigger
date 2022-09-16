trigger EmailMessageTrigger on EmailMessage (after insert) {
   
       //Map of EmailMessage Id to Case Id(Parent) 
       Map<Id, Id> eMsgIdToCaseIdMap = new Map<Id, Id>();
       
       for(EmailMessage e :trigger.new){
       
           system.debug('EmailMessage  ___ '+e);
         
            if(e.ParentId != null && e.ParentId.getSObjectType() == Case.SObjectType){    //&& e.HasAttachment == true
                //eMsgIdSet.add(e.Id);
                eMsgIdToCaseIdMap.put(e.Id, e.ParentId);
            }
       }
       system.debug('eMsgIdToCaseIdMap--'+eMsgIdToCaseIdMap);
       if(eMsgIdToCaseIdMap.keyset().size() > 0){
          EmailMessageTriggerHelper.afterInsertMethod(eMsgIdToCaseIdMap);
       }
}