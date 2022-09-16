Public With Sharing Class AssignedResourcesHelper{
    @auraEnabled
    public static List<AssignedResource> getAssignedResources(String worOrderId){
        Map<Id,ServiceAppointment> mapServiceAppoinments = new Map<Id,ServiceAppointment>();
        List<AssignedResource> listAssignedResource = new List<AssignedResource>();
        mapServiceAppoinments = new Map<Id,ServiceAppointment>([select id,Work_Order__c 
                                                                from ServiceAppointment where Work_Order__c=: worOrderId ]);
        if(mapServiceAppoinments != null && !mapServiceAppoinments.IsEmpty()){
            Set<Id> setServiceAppointmentIds = new Set<Id>(mapServiceAppoinments.keySet());
            
            String queryString = 'Select Id, ';
            for(FieldSetMemberWrapperClass fieldName : getFieldSetMember('AssignedResource','Assigned_Resources')){
                queryString += fieldName.fieldAPIName +',';
            }
            queryString = queryString.removeEnd(',');
            queryString +=' from AssignedResource where ServiceAppointmentid in : XXX';

            listAssignedResource = database.query(queryString.replace('XXX', 'setServiceAppointmentIds'));
        }     
        return listAssignedResource;                                                   
    }
    @AuraEnabled
    public static List<FieldSetMemberWrapperClass> getFieldSetMember(String objectName , String fieldSetName){
        
        List<FieldSetMemberWrapperClass> wrapperList = new List<FieldSetMemberWrapperClass>();
        try{
            Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
            
            for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()){
                FieldSetMemberWrapperClass wrapper = new FieldSetMemberWrapperClass();
                wrapper.fieldLabel = fieldMember.getLabel();
                wrapper.fieldAPIName = fieldMember.getFieldPath();
                if(fieldMember.getFieldPath().Endswith('Id')
                   && String.valueOf(fieldMember.getType())=='REFERENCE'){
                       string apiName = fieldMember.getFieldPath().replace('Id','.Name');
                       string label = fieldMember.getLabel().replace('ID','');
                       wrapper.fieldLabel = label;
                       wrapper.displayURL = true;               
                       wrapper.urlFieldAPI = fieldMember.getFieldPath();
                       wrapper.fieldAPIName = apiName;
                   }  
                else if(fieldMember.getFieldPath().Endswith('__c') && String.valueOf(fieldMember.getType())=='REFERENCE'){
                            wrapper.fieldAPIName = fieldMember.getFieldPath().replace('__c','__r.Name');
                            wrapper.displayURL = true;
                            wrapper.urlFieldAPI = fieldMember.getFieldPath();
                }   
                if(fieldMember.getFieldPath() =='ServiceAppointmentId'){
                    wrapper.fieldAPIName = 'ServiceAppointment.AppointmentNumber';
                }
                wrapperList.add(wrapper);
            }
        }
        catch(Exception e){
            
        }
        return wrapperList;
    }
    /*
* @Description : Wrapper class contains the information about all the fields of a FieldSet
*/ 
    public class FieldSetMemberWrapperClass{
        
        @AuraEnabled
        public Boolean displayURL{ get; set; }
        @AuraEnabled
        public String urlFieldAPI{ get; set; }
        @AuraEnabled
        public String fieldLabel{ get; set; }
        @AuraEnabled
        public String fieldAPIName{ get; set; }   
    }    
}