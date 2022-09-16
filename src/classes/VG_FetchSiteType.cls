global class VG_FetchSiteType extends VisualEditor.DynamicPickList {

    global override VisualEditor.DataRow getDefaultValue(){
        return null;
    }
    
    global override VisualEditor.DynamicPickListRows getValues() {
        String objectName = 'Site_Layout__c';
        String fieldName = 'Site_Type__c';
        
        VisualEditor.DynamicPickListRows  picklistValues = new VisualEditor.DynamicPickListRows();
        Map<String, Schema.SObjectField> currPageObjectfieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        for(Schema.SObjectField field : currPageObjectfieldsMap.values()) {
            Schema.DescribeFieldResult descField = field.getDescribe();
            if(String.ValueOf(descField.type)=='PICKLIST' && descField.getName()==fieldName) {
                List<Schema.PicklistEntry> valuesList = new List<Schema.PicklistEntry>();
                valuesList = descField.getPicklistValues();
                
                for(Schema.PicklistEntry value : valuesList)
                {
                    VisualEditor.DataRow dataRow = new VisualEditor.DataRow(value.getLabel(), value.getValue());
                    picklistValues.addRow(dataRow);
                }
                break;
            }
        }
        
        return picklistValues;
    }
}