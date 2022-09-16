@Istest
public class VG_Breadcrumbcontroller_test {
    
    public static testmethod void sitelayouttest(){
        Site_Layout__c SL = new Site_Layout__c();
        SL.Name = 'Human resource Dynamic Site';
        SL.Site_Type__c = 'Human Resource';
        SL.Status__c = 'Published';
        Insert SL;
        Site_Section__c Ssec = new Site_Section__c();
        Ssec.Site_Layout__c = SL.Id;
        Ssec.Column__c = 'Header';
        Ssec.Order__c = 2;
        Insert Ssec;
        VG_Breadcrumbcontroller.getsitelayout(Ssec.Id);
    }
}