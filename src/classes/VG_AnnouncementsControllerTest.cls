@isTest(SeeAllData=false)
public class VG_AnnouncementsControllerTest {
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
    
    @isTest static void Test_getAnnouncementlist() {  
        // Id RecordTypeIdContact = Schema.SObjectType.EC_Content__C.getRecordTypeInfosByName().get('DeveloperNameOfRecordType').getRecordTypeId();
        RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Sub_Announcements'];
        EC_Content__C Ann1=new EC_Content__C();
        Ann1.RecordTypeId=rec.id;
        Ann1.Name='We are Changing';
        Ann1.Primary_Text__c='We are growing at exponential rate';
        Ann1.Start_Date__c=system.today();
        Ann1.End_Date__c=system.today()+4;
        Ann1.Department__c='Marketing';
        Ann1.Location__c='Global';
        Ann1.Role__c='All';
        Ann1.Site__c='Landing Page';
        Ann1.Status__c='Published';
        insert Ann1;
        
        Test.startTest();
        EC_Content__c ec=VG_AnnouncementsController.getAnnouncementlist(Ann1.id);
        VG_AnnouncementsController.getAllFilters();
        VG_AnnouncementsController.getMonths();
        VG_AnnouncementsController.getYears();
        VG_AnnouncementsController.getDefault('All,All');
        Test.stopTest();
    }
    
    @isTest static void Test_getAllAnnouncements_Search() { 
        Announcements();
        
        List<Integer>monthFilters=new List<Integer>{1,2};
        List<Integer>yearFilters=new List<Integer>{2017};
        Test.startTest();  
        List<EC_Content__c>ec=VG_AnnouncementsController.getAllAnnouncements('we', monthFilters, yearFilters, false, '','',10);
        Test.stopTest();
    }
    
    @isTest static void Test_getAllAnnouncements_Search_Nodata() { 
        Announcements();
        
        List<Integer>monthFilters=new List<Integer>{1,2};
        List<Integer>yearFilters=new List<Integer>{2017};
        Test.startTest();  
        List<EC_Content__c>ec=VG_AnnouncementsController.getAllAnnouncements('we', monthFilters, yearFilters, false, '','',null);
        Test.stopTest();
    }
    
    @isTest static void Test_getAllAnnouncements_NoFilter() { 
        Announcements();
        
        List<Integer>monthFilters=new List<Integer>();
        List<Integer>yearFilters=new List<Integer>();
        Test.startTest();  
        List<EC_Content__c>ec=VG_AnnouncementsController.getAllAnnouncements(null, monthFilters, yearFilters, false, '','',null);
        Test.stopTest();
    }
    
    @isTest static void Test_getAllAnnouncements_OnlyMonthFilter() { 
        Announcements();
        
        List<Integer>monthFilters=new List<Integer>{12};
        List<Integer>yearFilters=new List<Integer>();
        Test.startTest();  
        List<EC_Content__c>ec=VG_AnnouncementsController.getAllAnnouncements(null, monthFilters, yearFilters, false, '','',null);
        Test.stopTest();
    }
    
    @isTest static void Test_getAllAnnouncements_OnlyYearFilter() { 
        Announcements();
        
        List<Integer>monthFilters=new List<Integer>();
        List<Integer>yearFilters=new List<Integer>{2018};
        Test.startTest();  
        List<EC_Content__c>ec=VG_AnnouncementsController.getAllAnnouncements(null, monthFilters, yearFilters, false, '','',null);
        Test.stopTest();
    }
    
    @isTest static void Test_getAllAnnouncements_BothYearMonthFilter() { 
        Announcements();
        
        List<Integer>monthFilters=new List<Integer>{12};
        List<Integer>yearFilters=new List<Integer>{2018};
        Test.startTest();  
        List<EC_Content__c>ec=VG_AnnouncementsController.getAllAnnouncements(null, monthFilters, yearFilters, false, '','',null);
        Test.stopTest();
    }
}