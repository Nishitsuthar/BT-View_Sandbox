@isTest
public class AAA_Sfdc_Test {

    static testMethod void OrderEntryReleaseEdit() {
     Account act= new account();
        act.name='tset';
        insert act;
        AAA_SFDC test = new AAA_SFDC();
        test.m1();
    }
}