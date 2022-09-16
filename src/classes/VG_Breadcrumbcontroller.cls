public class VG_Breadcrumbcontroller {
    @AuraEnabled
    public static list<string> getsitelayout(Id sitedetailId){
        Site_Section__c sitesection = [select Id, Site_Layout__c from Site_Section__c where Id=: sitedetailId];
        Site_Layout__c sitelayout = [select Id, Name from Site_Layout__c where Id=: sitesection.Site_Layout__c];
        list<string> siteidandname = new list<string>();
        siteidandname.add(sitelayout.Id); 
        siteidandname.add(sitelayout.Name);
        return siteidandname;
    }
}