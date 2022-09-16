@isTest
public class VG_ContentServiceTest {
 

   /* public static testmethod void testretrieveContentBanner(){
    	
    
		Test.startTest();

		
		Test.stopTest();
    }*/
    
    @isTest 
    static void Test_DynamicLayoutServiceTest() { 
        RecordType rec = [SELECT Id FROM RecordType Where DeveloperName = 'Footer'];
      
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
        Ann1.Article_Numbers__c='';
        insert Ann1;
       // List<EC_Content__C>AnnList=new List<EC_Content__C>{Ann1};
        Test.startTest();  
        VG_ContentService.retrieveContent('Mission_Statement','',False);
        VG_ContentService.retrieveContent('Announcement','',False);
        VG_ContentService.retrieveContent('Sub_Announcements','',False);
        VG_ContentService.retrieveContent('Quick_Links','',False); 
         VG_ContentService.retrieveContent('Tiles','',False);
         VG_ContentService.retrieveContent('Quick_Document_Links','',False);
        VG_ContentService.retrieveContent('Footer','',False);
        VG_ContentService.getPrefix();
        VG_ContentService.retrieveContentForMenu('Footer',False);
       VG_ContentService.contactus();
        VG_ContentService.missionStatement();
        
        List<SObject> so = [select Id, Name from EC_Content__c]; 
        List<SObject> listobj=new List<SObject>(so);
        Map<String, List<SObject>> obj=VG_ContentService.buildMapWithKey(so,'Name');
        List<Site_Section__c> layoutid=VG_ContentService.getRelatedLayoutRecords('ooasj12p');
            
        Test.stopTest();
        
    }
}