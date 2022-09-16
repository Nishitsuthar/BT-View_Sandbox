trigger ContentDocLinkTrigger on ContentDocumentLink (before insert) {
    for(ContentDocumentLink contentdoclink:Trigger.new) {
        Id recordId= contentdoclink.LinkedEntityId;
        String sObjName = recordId.getSObjectType().getDescribe().getName();  
        //system.debug('sObjName'+sObjName);
        if(sObjName=='buildertek__RFQ__c' || sObjName=='buildertek__RFI__c' || sObjName== 'buildertek__RFQ_To_Vendor__c' || sObjName=='buildertek__RFI_Response__c'){
        	contentdoclink.Visibility='AllUsers';    
        }        
    }
}