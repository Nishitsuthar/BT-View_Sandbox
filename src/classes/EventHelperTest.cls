@IsTest
private class EventHelperTest{
    /*
* setupTestdata : sets the test data
*/
    @testSetup static void setupTestdata() {
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner2@test.demo');
        User u2 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwne42@test.demo');
        database.insert(new List<User>{u1,u2});
        
        ServiceResource sr = new ServiceResource(RelatedRecordId = u1.Id,Name='testsr',isactive=true,ResourceType='T');
        ServiceResource sr1 = new ServiceResource(RelatedRecordId = u2.Id,Name='testsr',isactive=true,ResourceType='T');
        database.insert(new List<ServiceResource>{sr,sr1});
        
        Case caseRecord = new Case(Subject='Test'); 
        insert caseRecord;        
        WorkOrder wo = new WorkOrder(subject = 'Testing',CaseId=caseRecord.Id);
        insert wo;
        OperatingHours oh = new OperatingHours(name='test');
        insert oh;
        ServiceTerritory st = new ServiceTerritory(IsActive=true,name='test',OperatingHoursId=oh.id);
        insert st;
        
        ServiceTerritoryMember sta = new ServiceTerritoryMember(ServiceTerritoryId = st.id,ServiceResourceId = sr.id,
        TerritoryType='P',EffectiveStartDate=date.today());
        
        ServiceTerritoryMember sta1 = new ServiceTerritoryMember(ServiceTerritoryId = st.id,ServiceResourceId = sr1.id,
        TerritoryType='P',EffectiveStartDate=date.today());        
        database.insert(new List<ServiceTerritoryMember>{sta,sta1});

        ServiceAppointment sa = new ServiceAppointment(Subject = 'test',ActualEndTime=System.today(),
        ActualStartTime=System.today(),EarliestStartTime = DateTime.now(),ParentRecordId = wo.Id,DueDate = DateTime.now(),
        SchedStartTime = DateTime.now(),SchedEndTime = DateTime.Now().AddDays(1));
       
        database.insert(sa);

    }
    @IsTest static void createEvent(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner@test.demo');
        system.runas(u1){
            List<ServiceResource> sr =[select id from ServiceResource limit 2];
            List<ServiceAppointment> sa =[select id from ServiceAppointment limit 2];
            assignedResource ar = new AssignedResource(ServiceResourceId = sr.get(0).Id ,ServiceAppointmentId = sa.get(0).id);
            FSL.GlobalAPIS.addStatusTransition('New', 'Scheduled');
            test.starttest();
                database.insert(ar);    
                System.assertEquals(1,[select id from event where Service_Resource__c=: sr.get(0).id].size());
                ar.ServiceResourceId =  sr.get(1).id;  
                database.update(ar); 
                System.assertEquals(1,[select id from event where Service_Resource__c=: sr.get(1).id].size());
                
                database.delete(ar);
            test.stoptest(); 
                System.assertEquals(0,[select id from event where Service_Resource__c=: sr.get(1).id].size());

        }
    }
    @IsTest static void updtateFSLEventCatch(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner@test.demo');
        system.runas(u1){
            ServiceResource sr =[select id from ServiceResource limit 1];
            ServiceAppointment sa =[select id from ServiceAppointment limit 1];
            assignedResource ar = new AssignedResource(ServiceResourceId = sr.Id ,ServiceAppointmentId = sa.id);
            FSL.GlobalAPIS.addStatusTransition('New', 'Scheduled');
            database.insert(ar);
            test.starttest();
               EventHelper.updtateFSLEvent([select id from ServiceAppointment limit 1],
                                           new Map<Id,ServiceAppointment>([select id from ServiceAppointment limit 1]));       
            test.stoptest(); 
            System.assertEquals(1,[select id from event where Service_Resource__c=: sr.id].size());        

        }
    }    
    @IsTest static void updtateFSLEvent(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner@test.demo');
        system.runas(u1){
            ServiceResource sr =[select id from ServiceResource limit 1];
            ServiceAppointment sa =[select id,subject from ServiceAppointment limit 1];
            assignedResource ar = new AssignedResource(ServiceResourceId = sr.Id ,ServiceAppointmentId = sa.id);
            FSL.GlobalAPIS.addStatusTransition('New', 'Scheduled');
            database.insert(ar);  
            test.starttest();
              sa.subject= 'updated subject';       
              database.update(sa);
            test.stoptest(); 
            System.assertEquals(1,[select id from event where Service_Resource__c=: sr.id].size());        

        }
    }    
    @IsTest static void populateAssignTo(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner@test.demo');
        system.runas(u1){
            ServiceResource sr =[select id from ServiceResource limit 1];
            Event ev = new Event(Available_On_Weekend__c=true,subject ='test',Service_Resource__c=sr.id,
                                EndDateTime=DateTime.newInstance(2019, 8,31,4, 4, 4),
                                ActivityDateTime=DateTime.newInstance(2019, 8,31,3, 3, 3));
            test.starttest();
                database.insert(ev);       
            test.stoptest(); 
            System.assertEquals(null,ev.ownerid);        

        }
    }    
    @IsTest static void populateAssignToCatch(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner@test.demo');
        system.runas(u1){
            ServiceResource sr =[select id from ServiceResource limit 1];
            Event ev = new Event(subject ='test',Service_Resource__c=sr.id,
                                DurationInMinutes =2,ActivityDateTime=Date.newInstance(2019, 8,31));
            database.insert(ev); 
            test.starttest();
               EventHelper.populateAssignTo([select id from event limit 1]);       
            test.stoptest(); 
            
        }
    }    
    @IsTest static void createEventCatch(){
        User u1 = CaseStatusCahngeTriggerHandlerTest.getUser('System Administrator','atestOwner@test.demo');
        system.runas(u1){
            ServiceResource sr =[select id from ServiceResource limit 1];
            ServiceAppointment sa =[select id from ServiceAppointment limit 1];
            assignedResource ar = new AssignedResource(ServiceResourceId = sr.Id ,ServiceAppointmentId = sa.id);
            FSL.GlobalAPIS.addStatusTransition('New', 'Scheduled');
            insert ar;
            test.starttest();
               EventHelper.createEvent([select id from assignedResource limit 1],null);       
            test.stoptest(); 

        }
    }    
}