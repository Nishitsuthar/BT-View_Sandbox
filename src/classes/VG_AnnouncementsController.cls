public class VG_AnnouncementsController {
    
    @AuraEnabled
    public static AnnoucementFilters getAllFilters() {
        AnnoucementFilters filterObj = new AnnoucementFilters();
        filterObj.lAnnouncementsGroupedByMonth = getMonths();
        filterObj.lAnnouncementsGroupedByYear = getYears();
        return filterObj;
    }
    
    @AuraEnabled
    public static EC_Content__c getAnnouncementlist(Id annId ){
       list<EC_Content__c> Annlist = [select id,name,Primary_Text__c,Secondary_Summary_Detail__c,Primary_Summary__c,Start_date__c,Secondary_Text__c,Secondary_Summary__c,Action_URL__c,Action_BgColor__c,Action_Label__c,Primary_BgColor__c,Primary_FgColor__c, (Select ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks order by ContentDocument.lastmodifieddate desc LIMIT 1)  from EC_Content__c where  (recordType.name='Sub Announcements'or recordType.name='Announcement')  AND id =:annId];
       if(!Annlist.IsEmpty() && Annlist.size()>0)
        return Annlist[0];
        else
            return null;
    }
    
    
    @AuraEnabled
    public static List<string> getMonths() {
        
        List<string> months = new List<string> ();
        Months.add('January');
        Months.add('February');
        Months.add('March');
        Months.add('April');
        Months.add('May');
        Months.add('June');
        Months.add('July');
        Months.add('August');
        Months.add('September');
        Months.add('October');
        Months.add('November');
        Months.add('December');
        return months;
        
    }
    
    @AuraEnabled
    public static List<Integer> getYears() {
        Date dt=system.today();
        List<Integer> years = new List<Integer> ();
        years.add(dt.year()-1);
        years.add(dt.year());
        years.add(dt.year()+1);
        return years;
    }
    
    
    
    @AuraEnabled
    public static List<EC_Content__c> getAllAnnouncements(String searchKey, List<Integer> monthFilters, List<Integer> yearFilters, Boolean showmore, String sortBy, String sortOrder,integer recordLimit) {
        system.debug('---monthFilters---!'+monthFilters+'----yearFilters----!'+yearFilters);
        system.debug('searchKey---'+searchKey);
        List<EC_Content__c> result=new List<EC_Content__c>();
        List<Id>mainid=new List<Id>();
        String namespace = VG_Constants.NAMESPACE_PREFIX;
        String soql = 'select id,name,Secondary_Summary_Detail__c,Primary_Text__c,Primary_Summary__c,Start_date__c,Secondary_Text__c,Secondary_Summary__c,Action_URL__c,Action_BgColor__c,Action_Label__c,Primary_BgColor__c,Primary_FgColor__c,(Select ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks order by ContentDocument.lastmodifieddate desc LIMIT 1)  from EC_Content__c where (recordType.name=\'Sub Announcements\' or recordType.name=\'Announcement\') and Status__c=\'Published\'  ';
        
        user u=[SELECT Id,name, Employee_Office_Location__c, Employee_Role__c, Employee_Department__c FROM User where Id = : UserInfo.getUserId()];
        string userdept=u.Employee_Department__c;
        String userrole=u.Employee_Role__c;   
        string userloc =u.Employee_Office_Location__c;
        system.debug('before if'+monthFilters+'     '+yearFilters);
        
        if(searchKey != null  )
        {    
            system.debug('---searchKey---'+searchKey);
            String j= '%'+searchKey+'%';
            if(recordLimit!=null)
            {
                soql = 'select id,name,Primary_Text__c,Secondary_Summary_Detail__c,Primary_Summary__c,Start_date__c,Secondary_Text__c,Secondary_Summary__c,Action_URL__c,Action_BgColor__c,Action_Label__c,Primary_BgColor__c,Primary_FgColor__c,(Select ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks order by ContentDocument.lastmodifieddate desc LIMIT 1)  from EC_Content__c where (recordType.name=\'Sub Announcements\' or recordType.name=\'Announcement\') and Status__c=\'Published\'  ';
				soql += +' AND Department__c'+namespace+ ' includes (\''+ userdept + '\',\''+getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT)+'\')' 
                + ' AND role__c '+ namespace + ' includes (\''+ userrole + '\',\''+getDefault(VG_Constants.EC_DEFAULT_ROLE)+ '\')' 
                + ' AND location__c' + namespace+ ' includes (\''+ userloc + '\',\''+getDefault(VG_Constants.EC_DEFAULT_LOCATION)+ '\')'
                    +'and ( Primary_Text__c like:j or Secondary_Text__c like :j  or name like :j  or Primary_Summary__c like:j )'
                     + ' ORDER BY '+namespace+' LastModifiedDate DESC limit :recordLimit ';
                 System.debug('------with serach key query and record limit-----'+soql);
                
               List<EC_Content__c> a=Database.query(soql); 
            return a;
                // return [select id,name,Primary_Text__c,Primary_Summary__c,Start_date__c,Secondary_Text__c,Secondary_Summary__c,Action_URL__c,Action_BgColor__c,Action_Label__c,Primary_BgColor__c,Primary_FgColor__c,(Select ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks order by ContentDocument.lastmodifieddate desc LIMIT 1)  from EC_Content__c where  recordType.name='Sub Announcements' and Status__c='Published'and (Secondary_Text__c like :j or Primary_Text__c like:j or name like :j  or Primary_Summary__c like:j )limit :recordLimit ];
            }
            else
            {
				//return [select id,name,Primary_Text__c,Primary_Summary__c,Start_date__c,Secondary_Text__c,Secondary_Summary__c,Action_URL__c,Action_BgColor__c,Action_Label__c,Primary_BgColor__c,Primary_FgColor__c,(Select ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks order by ContentDocument.lastmodifieddate desc LIMIT 1)  from EC_Content__c where  recordType.name='Sub Announcements' and (Secondary_Text__c like :j or Primary_Text__c like:j or name like :j  or Primary_Summary__c like:j ) and Status__c='Published'];
				soql +=+' AND Department__c'+namespace+ ' includes (\''+ userdept + '\',\''+getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT)+'\')' 
                + ' AND role__c '+ namespace + ' includes (\''+ userrole + '\',\''+getDefault(VG_Constants.EC_DEFAULT_ROLE)+ '\')' 
                + ' AND location__c' + namespace+ ' includes (\''+ userloc + '\',\''+getDefault(VG_Constants.EC_DEFAULT_LOCATION)+ '\')'
                    +'and ( Primary_Text__c like:j or Secondary_Text__c like :j or name like :j  or Primary_Summary__c like:j )'
                    + ' ORDER BY '+namespace+' LastModifiedDate DESC';
                 System.debug('------with serach key query without record limit-----'+soql);
               List<EC_Content__c> a=Database.query(soql); 
            return a;
            }
        }
        
        else if(monthFilters.size()==0 && yearFilters.size()==0 )
        {
            soql += +' AND Department__c'+namespace+ ' includes (\''+ userdept + '\',\''+getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT)+'\')' 
                + ' AND role__c '+ namespace + ' includes (\''+ userrole + '\',\''+getDefault(VG_Constants.EC_DEFAULT_ROLE)+ '\')' 
                + ' AND location__c' + namespace+ ' includes (\''+ userloc + '\',\''+getDefault(VG_Constants.EC_DEFAULT_LOCATION)+ '\')' 
                 + ' ORDER BY '+namespace+' LastModifiedDate DESC';
            System.debug('------no month no year-----'+soql);
            List<EC_Content__c> a=Database.query(soql); 
            return a;
        }
        else if(monthFilters.size()!=0 && yearFilters.size()==0)
        {
            for(SObject ec:[select id,recordType.name, CALENDAR_MONTH(Start_date__c)from EC_Content__c where CALENDAR_MONTH(Start_date__c) in:monthFilters and (RecordType.Name='Sub Announcements' or RecordType.Name='Announcement') group by id,RecordType.Name, CALENDAR_MONTH(Start_date__c)])
            {
                mainid.add(ec.id);
            }
            soql += +'and id in:mainid AND Department__c'+namespace+ ' includes (\''+ userdept + '\',\''+getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT)+'\')' 
                + ' AND role__c '+ namespace + ' includes (\''+ userrole + '\',\''+getDefault(VG_Constants.EC_DEFAULT_ROLE)+ '\')' 
                + ' AND location__c' + namespace+ ' includes (\''+ userloc + '\',\''+getDefault(VG_Constants.EC_DEFAULT_LOCATION)+ '\')' 
                + ' ORDER BY '+namespace+' LastModifiedDate DESC';
            System.debug('------only month-----'+soql);
            List<EC_Content__c> a=Database.query(soql); 
            return a;  
        }
        else if(monthFilters.size()!=0 && yearFilters.size()!=0)
        {
            system.debug('After if true'+monthFilters+' only year true   '+yearFilters);
            for(SObject ec:[select id,recordType.name, CALENDAR_YEAR(Start_date__c),CALENDAR_MONTH(Start_date__c)from EC_Content__c where CALENDAR_YEAR(Start_date__c) in:yearFilters and (RecordType.Name='Sub Announcements' or RecordType.Name='Announcement') and CALENDAR_MONTH(Start_date__c) in:monthFilters group by id, RecordType.Name,CALENDAR_YEAR(Start_date__c),CALENDAR_MONTH(Start_date__c)])
            {
                mainid.add(ec.id);
            }
            soql += +'and id in:mainid AND Department__c'+namespace+ ' includes (\''+ userdept + '\',\''+getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT)+'\')' 
                + ' AND role__c '+ namespace + ' includes (\''+ userrole + '\',\''+getDefault(VG_Constants.EC_DEFAULT_ROLE)+ '\')' 
                + ' AND location__c' + namespace+ ' includes (\''+ userloc + '\',\''+getDefault(VG_Constants.EC_DEFAULT_LOCATION)+ '\')' 
                + ' ORDER BY '+namespace+' LastModifiedDate DESC';
            System.debug('------both month year-----'+soql);
            List<EC_Content__c> a=Database.query(soql); 
            return a;  
        }
        else
        {
            system.debug('After if '+monthFilters+' only year    '+yearFilters);
            for(SObject ec:[select id,recordType.name, CALENDAR_YEAR(Start_date__c)from EC_Content__c where CALENDAR_YEAR(Start_date__c) in:yearFilters and (RecordType.Name='Sub Announcements' or RecordType.Name='Announcement')   group by id,RecordType.Name, CALENDAR_YEAR(Start_date__c)])
            {
                mainid.add(ec.id);
            }
            soql += +'and id in:mainid AND Department__c'+namespace+ ' includes (\''+ userdept + '\',\''+getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT)+'\')' 
                + ' AND role__c '+ namespace + ' includes (\''+ userrole + '\',\''+getDefault(VG_Constants.EC_DEFAULT_ROLE)+ '\')' 
                + ' AND location__c' + namespace+ ' includes (\''+ userloc + '\',\''+getDefault(VG_Constants.EC_DEFAULT_LOCATION)+ '\')' 
                + ' ORDER BY '+namespace+' LastModifiedDate DESC';
            System.debug('------only year-----'+soql);
            List<EC_Content__c> a=Database.query(soql); 
            return a;  
        }
        
    }
    

    
    public static String getDefault(String type){
        String defaultKey = '';
        Map<String, List<EC_Settings__c>> ecSettingsMap = VG_Settings.getSettingsByType(type, VG_Constants.NAMESPACE_PREFIX + 'Text1__c');
        if(ecSettingsMap.isEmpty()) return defaultKey;
        for(String str: ecSettingsMap.keySet()) {
            defaultKey +=   String.escapeSingleQuotes(str) + ', ';
        }
        defaultKey = String.isNotBlank(defaultKey) ?
            defaultKey.left(defaultKey.lastIndexOf(',')) : '';
        
        return defaultKey;
    }
 
    
    // Wrapper class for filters
    public class AnnoucementFilters {
        public @AuraEnabled List<string> lAnnouncementsGroupedByMonth;
        public @AuraEnabled List<Integer> lAnnouncementsGroupedByYear;
    }
}