public class VG_DynamicLayoutController {

    @AuraEnabled
    public static SiteDetails fetchLayoutAndComponents(String SiteType, Boolean Preview, String SiteId) {
        
        Map<String, List<Site_Section__c>> groupedSiteSection = new Map<String, List<Site_Section__c>>();

		String siteLayoutQuery = 'SELECT Id, Site_Type__c, RecordType.Name, Status__c FROM Site_Layout__c';
		siteLayoutQuery +=   Preview ? ' WHERE Id = :SiteId' : ' WHERE Site_Type__c = :SiteType AND Status__c = \'Published\'';
        siteLayoutQuery += ' LIMIT 1';
        System.debug('siteLayoutQuery'+siteLayoutQuery);
        List<Site_Layout__c> layout = database.query(siteLayoutQuery);
        
        if (layout.size() > 0) {
            
            for (Site_Section__c eachSection : [
                SELECT Id, Widget__c, Column__c, Height_in_Pixel__c, Order__c, Autoplay__c, 
                    Autoplay_Speed__c, Number_of_Cards__c, Custom_Widget__c, Custom_Widget__r.Widget_API_Name__c,
                    RecordType.Name , Text__c
                FROM Site_Section__c 
                WHERE Site_Layout__c = :layout[0].Id
                ORDER BY Column__c, Order__c
            ]) {
                if (!groupedSiteSection.containsKey(eachSection.Column__c.replace(' ', ''))) {
                    groupedSiteSection.put(eachSection.Column__c.replace(' ', '') , new List<Site_Section__c>());
                }
                groupedSiteSection.get(eachSection.Column__c.replace(' ', '')).add(eachSection);
            }
            
            SiteDetails allDetails = new SiteDetails();
            allDetails.layoutDetails = layout[0];
            allDetails.siteSections = groupedSiteSection;
            
            return allDetails;
        }

        return null;
    }
    
    public class SiteDetails {
        @AuraEnabled
        public Site_Layout__c layoutDetails{get;set;}
        @AuraEnabled
        public Map<String, List<Site_Section__c>> siteSections{get;set;}
    }
}