@isTest
public class VenderRFQTriggerTest {
    public static testMethod void test() {
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        List<Contact> cont = new List<Contact>();
        Contact con = new Contact();
        con.Email = 'test@gmail.com';
        con.LastName = 'test4';
        con.AccountId = acc.id;
        cont.add(con);
        insert cont;
        
        buildertek__Project__c proj = new buildertek__Project__c();
        proj.Name = 'Test Project';
        insert proj;
        
        buildertek__RFQ__c rfq = new buildertek__RFQ__c();
        rfq.Name = 'Test';
        rfq.buildertek__Project__c = proj.Id;
        insert rfq;
        Account accRec = new Account();
        accRec.Name = 'Test';
        insert accRec;
        Contact ConRec = New Contact();
        ConRec.AccountId = accRec.id;
        ConRec.LastName = 'Test';
        insert ConRec;
        buildertek__RFQ_To_Vendor__c rfqToVendor = new buildertek__RFQ_To_Vendor__c();
        rfqToVendor.buildertek__Vendor__c = accRec.id;
        rfqToVendor.buildertek__Contact__c = ConRec.id;
        rfqToVendor.buildertek__RFQ__c = rfq.id;
        insert rfqToVendor;
    }
}