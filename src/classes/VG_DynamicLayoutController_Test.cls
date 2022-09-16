@isTest
public class VG_DynamicLayoutController_Test {

    @isTest
    public static void testFetchLayout() {
        
        //create widget record
        Custom_Widget__c widget = new Custom_Widget__c();
        widget.Name = 'Announcements';
        widget.Widget_API_Name__c = 'VG_Announcements';
        insert widget;
        
        //create layout record
        Site_Layout__c layoutrecord = new Site_Layout__c();
        layoutRecord.Name = 'Custom HR Layout';
        layoutRecord.Site_Type__c = 'Human Resource';
        layoutRecord.Status__c = 'Draft';
        insert layoutRecord;
        
        
        //create another layout record
        Site_Layout__c layoutrecord1 = new Site_Layout__c();
        layoutRecord1.Name = 'Custom HR Layout 1';
        layoutRecord1.Site_Type__c = 'Human Resource';
        layoutRecord1.Status__c = 'Published';
        insert layoutRecord1;
        
        try {
            //create another layout record
            Site_Layout__c layoutrecord2 = new Site_Layout__c();
            layoutRecord2.Name = 'Custom HR Layout 2';
            layoutRecord2.Site_Type__c = 'Human Resource';
            layoutRecord2.Status__c = 'Published';
            insert layoutRecord2;
        } catch(Exception e) {
            
        }
        
        
        //create site section
        Site_Section__c section = new Site_Section__c();
        section.Custom_Widget__c = widget.Id;
        section.Order__c = 1;
        section.Column__c = 'Header';
        section.Site_Layout__c = layoutRecord.Id;
        insert section;
        
        VG_DynamicLayoutController.fetchLayoutAndComponents(layoutrecord.Site_Type__c, true, layoutRecord.Id);
           
    }
}