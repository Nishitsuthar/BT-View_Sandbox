/*
EventHelper : This class is created to sync events with field appointments
Author : Magnet360
*/
public class EventHelper{
    /*
    updtateFSLEvent : when service appointment is updated event of coresponding event is also updated
    */
    public static void updtateFSLEvent(list<ServiceAppointment> newServiceAppointmentList,
                                        Map<Id,ServiceAppointment> oldServiceAppointmentMap){
        try{
            Map<Id,ServiceAppointment> mapAppointment = new Map<Id,ServiceAppointment>();
            List<Event> listEventToUpdate = new List<Event>();
            for(ServiceAppointment sa : newServiceAppointmentList){
                ServiceAppointment oldSa;
                if(oldServiceAppointmentMap != null
                && oldServiceAppointmentMap.containskey(sa.Id)){
                    oldSa= oldServiceAppointmentMap.get(sa.id);
                }
                if(oldSa!= null 
                && (sa.SchedStartTime != oldSa.SchedStartTime
                || sa.SchedEndTime!= oldSa.SchedEndTime
                || sa.Work_Order__c!= oldSa.Work_Order__c
                || sa.Subject != oldSa.Subject)){
                   mapAppointment.put(sa.Id,sa);
               }
            }
            if(!mapAppointment.IsEmpty()){
                for(event fslEvent: [select id,StartDateTime,EndDateTime,Subject,whatId,Work_Order__c
                               from event where whatId in : mapAppointment.keySet() and Available_On_Weekend__c = false]){
                    if(mapAppointment.containskey(fslEvent.whatid)){
                        ServiceAppointment sa = mapAppointment.get(fslEvent.whatid);
                        fslEvent.StartDateTime = sa.SchedStartTime;
                        fslEvent.EndDateTime = sa.SchedEndTime;
                        fslEvent.Subject = sa.Subject;
                        fslEvent.Work_Order__c= sa.Work_Order__c;
                        listEventToUpdate.add(fslEvent);
                    }
                }
                if(!listEventToUpdate.IsEmpty()){
                    database.update(listEventToUpdate);
                }
            }
        }
        catch(Exception e){}
    }
    /*
    createEvent : Mthod is called when assigned resource are created/edited
    */
    public static void createEvent(list<AssignedResource> assignedResourceList,Map<Id,AssignedResource> assignedResourceMap){
        try{
            Id devRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Field_Appointment').getRecordTypeId();
            List<event> listevents = new List<Event>();
            set<Id> assignedResourceForEventreation = new Set<Id>();//populated for assigned resource insert event
            Map<Id,AssignedResource> serviceResourceSet = new Map<Id,AssignedResource>();
            Map<String,Id> mapAssignedResourceEvent = new map<String,Id>();//stores event id in values
            Map<Id,String> mapAssignedResourceId = new map<Id,String>();
            for(AssignedResource ar : assignedResourceList){
                if(assignedResourceMap != null && assignedResourceMap.containsKey(ar.Id)){
                    AssignedResource oldAr =  assignedResourceMap.get(ar.Id);
                    if(oldAr.ServiceResourceId != ar.ServiceResourceId){
                        serviceResourceSet.put(oldAr.ServiceResourceId,ar);
                        mapAssignedResourceId.put(ar.Id,oldAr.ServiceAppointmentId + '-' + oldAr.ServiceResourceId);
                    }
                }
                else if(assignedResourceMap == null
                && (ar.ServiceResourceId != null || ar.ServiceAppointmentId != null)){
                    assignedResourceForEventreation.add(ar.Id);
                }
            }                           
            if(!serviceResourceSet.IsEmpty()){
                for(event ev : [Select id,whatId,Service_Resource__c from event 
                                where (Service_Resource__c in : serviceResourceSet.keySet())
                                and recordtypeid =: devRecordTypeId]){
                    mapAssignedResourceEvent.put(ev.whatId + '-' +  ev.Service_Resource__c,ev.Id);
                }
            }
            if(!assignedResourceForEventreation.IsEmpty() || !mapAssignedResourceId.IsEmpty()){
                for(AssignedResource ar : [select id,ServiceResourceId,ServiceResource.RelatedRecordId,ServiceAppointment.SchedEndTime, 
                                           ServiceAppointment.SchedStartTime,ServiceAppointment.Subject,ServiceAppointmentId,
                                           ServiceAppointment.ParentRecordId,ServiceResource.RelatedRecord.Name
                                           from AssignedResource 
                                           where id in : assignedResourceForEventreation or id in : mapAssignedResourceId.keySet()
                                          limit 200]){
                    Event fslEvent = new event();
                    Id eventId;
                    if(mapAssignedResourceId.containsKey(ar.Id)){
                        string key = mapAssignedResourceId.get(ar.Id);                        
                        if(mapAssignedResourceEvent.containsKey(key)){
                            eventId = mapAssignedResourceEvent.get(key);
                            fslEvent.Id = eventId;
                        }
                        
                    }
                    if(eventId != null || assignedResourceForEventreation.contains(ar.Id)){
                        fslEvent.StartDateTime = ar.ServiceAppointment.SchedStartTime;
                        fslEvent.EndDateTime = ar.ServiceAppointment.SchedEndTime;
                        fslEvent.Subject = ar.ServiceAppointment.Subject;
                        fslEvent.whatId = ar.ServiceAppointmentId;
                        fslEvent.OwnerId = ar.ServiceResource.RelatedRecordId;
                        fslEvent.recordtypeId =  devRecordTypeId;
                        fslEvent.Service_Resource__c = ar.ServiceResourceId;
                        if(ar.ServiceAppointment.ParentRecordId != null){
                            String sObjName = (ar.ServiceAppointment.ParentRecordId).getSObjectType().getDescribe().getName();
                            if(sObjName =='WorkOrder'){
                                fslEvent.Work_Order__c= ar.ServiceAppointment.ParentRecordId;
                            }
                        }
                        listevents.add(fslEvent);
                    }
                    if(!listevents.Isempty()){
                        database.upsert(listevents);
                    }
                }
            }
        }
        catch(Exception e){}   
    }
    /*
    deleteEvents : delete even record when assigned resource record is deleted
    */
    public static void deleteEvents(list<AssignedResource> listAssignedResource){
        try{
            Set<String> setserviceRecourceAppointmentId = new Set<String>();
            Set<Id> setServiceAppointmentId = new Set<Id>();
            for(AssignedResource ar : listAssignedResource){
                setserviceRecourceAppointmentId.add(Ar.ServiceAppointmentId + '-' + Ar.ServiceResourceId);
                setServiceAppointmentId.add(ar.ServiceAppointmentId);
            }
            if(!setServiceAppointmentId.IsEmpty()){
                List<Event> listEventToDelete = new List<Event>();
                Id devRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Field_Appointment').getRecordTypeId();
                for(Event ev : [select id,Service_Resource__c,whatId from event 
                                where whatId in : setServiceAppointmentId and recordtypeid =: devRecordTypeId]){
                    string key = ev.whatId + '-' + ev.Service_Resource__c;
                    if(setserviceRecourceAppointmentId.contains(key)){
                        listEventToDelete.add(ev);
                    }
                 }
                if(!listEventToDelete.IsEmpty()){
                    database.delete(listEventToDelete);
                }
            }
        }
        catch(exception e){}
    }
    /*
    populateAssignTo : when weekend availability record is created it populates ownerid from service resoruce 
    */
    public static void populateAssignTo(list<event> listEvents){
        try{
            If(!listEvents.IsEmpty()){
                List<ServiceResource> listServiceResource = new List<ServiceResource>();
                set<Id> setEventIds                       = new Set<Id>();
                Map<Id,ServiceResource> mapServiceResource    = new map<Id,ServiceResource>();
                for(event ev: listEvents){
                    if(ev.Available_On_Weekend__c && ev.Service_Resource__c!= null){
                        setEventIds.add(ev.Service_Resource__c);
                    }
                }
                if(!setEventIds.IsEmpty()){
                    mapServiceResource = new Map<Id,ServiceResource>([select id,RelatedRecordId 
                                                                      from ServiceResource 
                                                                      where id in : setEventIds
                                                                     limit 200]);
                    if(!mapServiceResource.isEmpty()){
                        for(event ev: listEvents){
                            if(ev.Available_On_Weekend__c && ev.Service_Resource__c!= null
                              && mapServiceResource.containsKey(ev.Service_Resource__c)){
                                  ev.OwnerId = mapServiceResource.get(ev.Service_Resource__c).RelatedRecordId;
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e){}
    }    
}