public class Glazier_PreQualForm_VF_Controller {

    public String isPreview{get; set;}
    public String recordId{get; set;}
    public String documentURL{get; set;}
    
    public Glazier_PreQualForm_VF_Controller(){
    	isPreview = ApexPages.currentPage().getParameters().get('preview');
        recordId = ApexPages.currentPage().getParameters().get('id');
        system.debug('isPreview ------> '+isPreview);
        List<Document> docList = [SELECT Id, Name FROM Document WHERE Name =: 'Company Logo' LIMIT 1];
        buildertek__MSA_Settings__c sitesUrl = [SELECT Id, buildertek__Site_URL__c FROM buildertek__MSA_Settings__c LIMIT 1];
        List<buildertek__Checklist_Objects__c> checkobj = [select id,Name from buildertek__Checklist_Objects__c where Name = 'PreQual Logo'];
        if(checkobj.size()>0){
       Attachment Att = [select id,Name from attachment where parentId =: checkobj[0].id];
       
        documentURL = sitesUrl.buildertek__Site_URL__c+'servlet/servlet.FileDownload?file='+att.id;
        system.debug('documentURL ------> '+documentURL);
        }

}
}