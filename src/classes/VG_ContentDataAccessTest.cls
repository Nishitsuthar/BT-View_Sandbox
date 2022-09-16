@isTest(SeeAllData=false)
public class VG_ContentDataAccessTest {
private static Integer nowString;
private static void Announcements() {
    RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Sub_Announcements'];
		 User testUser = VG_TestDataUtils.createUser();
        testUser.Employee_Department__c='All';
        testUser.Employee_Role__c='All';
        testUser.Employee_Office_Location__c='Global';
        testUser.Username= 'john' + nowString + '.smith@view.com';
		testUser.FirstName = 'John' + nowString;
		testUser.LastName = 'Smith';
		testUser.Employee_Department__c = 'Human Resource';
		testUser.City = 'Los Angeles';
        insert testUser;
		List<EC_Content__C> AnnList = new List<EC_Content__C>();
		
		EC_Content__C Ann1=new EC_Content__C();
		Ann1.RecordTypeId=rec.id;
		Ann1.Name='We are Changing';
		Ann1.Primary_Text__c='We are growing at exponential rate';
		//Ann1.Profile__c='All';
		Ann1.Start_Date__c=system.today();
		Ann1.End_Date__c=system.today()+4;
		Ann1.Department__c='All';
		Ann1.Location__c='Global';
		Ann1.Role__c='All';
		Ann1.Site__c='Landing Page';
		Ann1.Status__c='Published';
		AnnList.add(Ann1);
		
    
        EC_Content__C Ann2=new EC_Content__C();
		Ann2.RecordTypeId=rec.id;
		Ann2.Name='We are Changing';
		Ann2.Primary_Text__c='We are growing at exponential rate';
		//Ann2.Profile__c='Employee';
		Ann2.Start_Date__c=system.today();
		Ann2.End_Date__c=system.today()+4;
		Ann2.Department__c='Marketing';
		Ann2.Location__c='Global';
		Ann2.Role__c='All';
		Ann2.Site__c='Landing Page';
		Ann2.Status__c='Published';
		AnnList.add(Ann2);
		insert AnnList;
}
    
     @isTest static void Test_getContentByRecordType() { 
        Announcements();
      List<String>recordTypes=new List<String>{'Quick_Links','Announcement'};
          Set<String> fieldSet=new Set<String>{'Name','Start_Date__c'};   
       
          Test.startTest();  
		List<EC_Content__c>ec=VG_ContentDataAccess.getContentByRecordType(fieldSet,recordTypes);
          VG_ContentDataAccess.getDefault('All,All');
    //  List<EC_Content__c>ec1= VG_ContentDataAccess.getActiveContentByFiltersAndRecordType('Landing Page','Human Resource','Global','All','United States','en_US','All','Sub_Announcements','False');
        Test.stopTest();
    }
    
     @isTest static void Test_getActiveContentByFiltersAndRecordType() { 
        Announcements();
          Test.startTest();  
     List<EC_Content__c>ec1= VG_ContentDataAccess.getActiveContentByFiltersAndRecordType(false,'Landing Page','Human Resource','Global','All','United States','en_US','All','Sub_Announcements',False);
        Test.stopTest();
    }
    
     @isTest static void Test_getActiveContentByFiltersAndRecordType_Announcement() { 
        Announcements();
          Test.startTest();  
     List<EC_Content__c>ec1= VG_ContentDataAccess.getActiveContentByFiltersAndRecordType(false,'Landing Page','Human Resource','Global','All','United States','en_US','All','Announcement',False);
        Test.stopTest();
    }
    
     @isTest static void Test_getActiveContentByFiltersAndRecordType_QuickLinks() { 
        Announcements();
          Test.startTest();  
     List<EC_Content__c>ec1= VG_ContentDataAccess.getActiveContentByFiltersAndRecordType(false,'Landing Page','Human Resource','Global','All','United States','en_US','All','Quick_Links',False);
        Test.stopTest();
     }
          @isTest static void Test_getActiveContentByFiltersAndRecordType_tile() { 
        Announcements();
          Test.startTest();  
     List<EC_Content__c>ec1= VG_ContentDataAccess.getActiveContentByFiltersAndRecordType(false,'Landing Page','Human Resource','Global','All','United States','en_US','All','tile',False);
        Test.stopTest();
    }
    
      @isTest static void Test_getActiveContentByFiltersAndRecordType_Footer() { 
        Announcements();
          Test.startTest();  
     List<EC_Content__c>ec1= VG_ContentDataAccess.getActiveContentByFiltersAndRecordType(false,'Landing Page','Human Resource','Global','All','United States','en_US','All','Footer',False);
        Test.stopTest();
    }
}