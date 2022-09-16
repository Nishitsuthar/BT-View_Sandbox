@IsTest
public class VG_FetchCalendarEventsTest {

    
    @isTest
    public static void testFetchEvents() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User managerUser = new User(Alias = 'sysadmin', Email='sysadmin@view.com',
				 EmailEncodingKey='UTF-8', LastName='Smith1', FirstName='John1', LanguageLocaleKey='en_US',
				 LocaleSidKey='en_US', ProfileId = p.Id, Phone='1234567890',Department='Sales', City='Atlanta',
				 TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuser1@view.com', Title ='CEO', Country='USA',
                 Employee_Office_Location__c = 'Global', Employee_Role__c = 'All', Employee_Department__c = 'All');
		insert managerUser;
        
        System.runAs(managerUser) {
            Test.startTest();
            List<Event> allEvent = VG_FetchCalendarEvents.fetchAllEvents();
            System.assertEquals(allEvent.size(), 0);
            Test.stopTest();
        }
    }
    
}