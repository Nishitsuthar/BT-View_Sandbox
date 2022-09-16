/*
Name : NewQuoteCreation
Author: Magnt360
Purpose: This class is used in lightning component NewQuoteCreation.
class returns the fields to be displayed on quote creation page based on layout and record type selected.
Line 121-123 : Added code to populate First Request Date - IGU from opportunity
*/
 /* =================================================================================================
       Description          : Changed the code to populate First Request Date - IGU from opportunity
       Modification History : Rekha Talluri 20200616  
    ====================================================================================================*/ 


public class NewQuoteCreation {
    @auraEnabled
    /*
    getPageLayoutStructure : this method returns layoutDetail wrapper which store detail regarding fields to be displayed on page.
    */
    public static Map<String,List<layoutDetail>> getPageLayoutStructure(Id entityId,
                                                                        String recordTypeName,
                                                                        String pageLayoutName,
                                                                        String sobjectName) {
        //Get Default values of case if entityId is caseId
        Case caseRec;
        Opportunity oppRec;
        if(String.valueOf(entityId).StartsWith(Case.sObjectType.getDescribe().getKeyPrefix())){
        	 caseRec = [SELECT Id, Opportunity__c, Opportunity__r.Name, Partner_Contact__c, Opportunity__r.CurrencyIsoCode, Quote_Plan__c, 
                        Quote_Type__c, Template_Type__c, Partner_Contact__r.AccountId FROM Case WHERE Id = :entityId];                                                                       
        } else if(String.valueOf(entityId).StartsWith(Opportunity.sObjectType.getDescribe().getKeyPrefix())) {
          oppRec = [SELECT Id, CurrencyIsoCode, First_Request_Date_IGU__c FROM Opportunity WHERE Id = :entityId];
      //       oppRec = [SELECT Id, CurrencyIsoCode FROM Opportunity WHERE Id = :entityId];
        }
                                                                            
        // Provide the page layout name here
        // You can give multiple page layout names here as well
        Map<String,List<layoutDetail>> mapLayoutBySection = new map<String,List<layoutDetail>>();
        try{
            Id recordTypeId =Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            List<String> componentNameList = new List<String>{pageLayoutName};
            // Retrieve page layout details 
            List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, componentNameList);
            Metadata.Layout pageLayot = (Metadata.Layout) components.get(0);
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(sobjectName);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            // We are going to find the fields names and will keep them according to columns so 
            // we can show them as per page layout 
            for( Metadata.LayoutSection ls : pageLayot.layoutSections ) {
                integer columnNumber =0;
                for( Metadata.LayoutColumn lc : ls.layoutColumns ) {
                    // check if there are fields available in that column
                    if( lc.layoutItems != null ) { 
                        // Get the max number of fields in a column to preserve the alignment 
                        for( Metadata.LayoutItem li : lc.layoutItems ) {
                            layoutDetail detail = new layoutDetail();
                            detail.sectionName = ls.label;
                            Boolean formulaField = false;
                            if(li.field != null){
                                detail.fieldName = li.field;
                                //Block to get field label and also check if field is formula field
                                if(fieldMap.containskey(li.field)){
                                    Schema.DescribeFieldResult sfr = fieldMap.get(li.field).getDescribe();
                                    detail.fieldLabel = sfr.getLabel();
                                    formulaField = sfr.isCalculated();
                                }
                                //We do not want to display formula field on create page.
                                if(!formulaField){
                                    if(String.valueOf(li.behavior) == 'Readonly'){
                                        detail.readOnly = true;
                                    }
                                    else if(String.ValueOf(li.behavior) == 'Required'){
                                        detail.required = true;
                                    }
                                    if(columnNumber==0){
                                        detail.isLeft = true;
                                    }
                                    else{
                                        detail.isRight = true;
                                    }                   
                                    //call the method to populate default value
                                   	if(String.valueOf(entityId).StartsWith(Case.sObjectType.getDescribe().getKeyPrefix())){
                                        detail = returnCaseDefaultValuePopulated(detail,recordTypeId,entityId,recordTypeName, caseRec);
                                    } else {
                                    	detail = returnDefaultValuePopulated(detail,recordTypeId,entityId,recordTypeName, oppRec);
                                    }
                                    if(!mapLayoutBySection.IsEmpty() && mapLayoutBySection.containsKey(detail.sectionName)){
                                        mapLayoutBySection.get(detail.sectionName).add(detail);
                                    }      
                                    else if(mapLayoutBySection.IsEmpty() || !mapLayoutBySection.containsKey(detail.sectionName)){
                                        List<layoutDetail> layoutList = new list<layoutDetail>();
                                        layoutList.add(detail);
                                        mapLayoutBySection.put(detail.sectionName,layoutList);
                                    }   
                                }
                            }
                        }
                    }      
                    columnNumber++;  
                }
            }
        }
        catch(Exception e){}
        return mapLayoutBySection;
    }
    /*
    returnDefaultValuePopulated : Method returns layoutdetail after populating default values.
    */
    public static layoutDetail returnDefaultValuePopulated(layoutDetail detail,Id recordTypeId,Id entityId,String RecordTypeName, Opportunity Opp){
        if(detail.fieldName =='RecordTypeId'){
            detail.defaultValue= recordTypeId;
            detail.readOnly = true;
        }              
        if(detail.FieldName =='Related_Opportunity__c' && RecordTypeName == 'Budgetary_Estimate'
        && String.valueOf(entityId).StartsWith(Opportunity.sObjectType.getDescribe().getKeyPrefix())){
            detail.defaultValue=entityId;
            detail.readOnly = true;
        }
        if(detail.FieldName =='SBQQ__Opportunity2__c' && RecordTypeName =='Pricing_Quote'
        && String.valueOf(entityId).StartsWith(Opportunity.sObjectType.getDescribe().getKeyPrefix())){
            detail.defaultValue=entityId;
            detail.readOnly = true;
        } 
        if(detail.fieldName =='CurrencyIsoCode'){
            detail.defaultValue= Opp.CurrencyIsoCode;
            detail.readOnly = true;
        }
        if(detail.fieldName =='First_Ship_Date__c'){
            detail.defaultValue= String.valueOf(Opp.First_Request_Date_IGU__c);
            detail.readOnly = false;
        }
    
        return detail; 
    }
    /*
    returnCaseDefaultValuePopulated : Method returns layoutdetail after populating default values from Case.
    */
    public static layoutDetail returnCaseDefaultValuePopulated(layoutDetail detail,Id recordTypeId,Id entityId,String RecordTypeName, Case caseRec){
        if(detail.fieldName =='RecordTypeId'){
            detail.defaultValue= recordTypeId;
            detail.readOnly = true;
        }              
        if(detail.FieldName =='Related_Opportunity__c'){
            detail.defaultValue=caseRec.Opportunity__c;
        }
        if(detail.FieldName =='SBQQ__PrimaryContact__c'){
            detail.defaultValue=caseRec.Partner_Contact__c;
        }
        if(detail.FieldName =='CurrencyIsoCode'){
            detail.defaultValue=caseRec.Opportunity__r.CurrencyIsoCode;
        }
        if(detail.FieldName =='Case__c'){
            detail.defaultValue=caseRec.Id;
        }
        if(detail.FieldName =='Quote_Plan__c'){
            detail.defaultValue=caseRec.Quote_Plan__c;
        }
        if(detail.FieldName =='Quote_Type__c'){
            detail.defaultValue=caseRec.Quote_Type__c;
        }
        if(detail.FieldName =='Quote_Name__c'){
            detail.defaultValue=caseRec.Opportunity__r.Name;
        }
        if(detail.FieldName =='Template_Type__c'){
            detail.defaultValue=caseRec.Template_Type__c;
        }
        if(detail.FieldName =='SBQQ__Account__c'){
            detail.defaultValue=caseRec.Partner_Contact__r.AccountId;
        }
        return detail; 
    }
    /*
    Wrapper class which is used in lightning component to get field detail
    */
    public class layoutDetail {
        @auraEnabled
        public String fieldName {get; set;}
        @auraEnabled
        public Boolean readOnly {get; set;}
        @auraEnabled
        public Boolean required {get; set;}
        @auraEnabled
        public Boolean isLeft {get; set;}
        @auraEnabled
        public Boolean isRight {get; set;}
        @auraEnabled
        public String sectionName {get; set;}
        @auraEnabled
        public String defaultValue {get; set;}   
        @auraEnabled
        public String fieldLabel {get; set;}      
    }
}