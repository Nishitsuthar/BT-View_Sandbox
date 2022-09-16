@isTest
private class IGU_DimensionTrigger_Test{
  static testMethod void test_IGU_DimensionTrigger(){
   test.startTest();
    IGU_Dimension__c igu_dimension_Obj = new IGU_Dimension__c(Shape__c = 'Rectangle', Unit_of_Measure__c = 'Imperial', Base_in__c = 14, Base_mm__c = 15, Height_in__c = 16, Height_mm__c = 17, Base_Height_1_in__c = 18, Base_Height_1_mm__c = 19, Search_Key__c = '20', Order_SKU_Suffix__c = '001M2');
    Insert igu_dimension_Obj; 
   test.stopTest();
   } 
}