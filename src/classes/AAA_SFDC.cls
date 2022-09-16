public class AAA_SFDC{
public void m1(){
List<Account> account_Obj1  =  [SELECT Id,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingAddress,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,ShippingAddress,Contract_Signed__c,Oracle_Customer_Number__c from Account WHERE Oracle_Customer_Number__c <> NULL];

}

}