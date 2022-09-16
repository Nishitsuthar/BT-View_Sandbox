@isTest
private class SKU_Trigger_Helper_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    SKU_Prefix_Element_Map__c sku_prefix_element_map_Obj = new SKU_Prefix_Element_Map__c(Name = 'Name500');
    Insert sku_prefix_element_map_Obj; 
    SKU_Prefix_Element_Map_Entry__c sku_prefix_element_map_entry_Obj = new SKU_Prefix_Element_Map_Entry__c(Name = 'Name918', Map_to_Value__c = '1', SKU_Prefix_Element_Map__c = sku_prefix_element_map_Obj.id);
    Insert sku_prefix_element_map_entry_Obj; 
    
    test.stopTest();
  }
  static testMethod void test_toHex_UseCase1(){
    List<SKU_Prefix_Element_Map_Entry__c> sku_prefix_element_map_entry_Obj  =  [SELECT Id,IsDeleted,Name,Map_to_Value__c,SKU_Prefix_Element_Map__c from SKU_Prefix_Element_Map_Entry__c];
    System.assertEquals(true,sku_prefix_element_map_entry_Obj.size()>0);
    List<SKU_Prefix_Element_Map__c> sku_prefix_element_map_Obj  =  [SELECT Id,IsDeleted,Name,SFDC_Record_Id__c from SKU_Prefix_Element_Map__c];
    System.assertEquals(true,sku_prefix_element_map_Obj.size()>0);
    SKU_Trigger_Helper obj01 = new SKU_Trigger_Helper();
    SKU_Trigger_Helper.toHex(10,10);
  }
  static testMethod void test_toBase36_UseCase1(){
    List<SKU_Prefix_Element_Map_Entry__c> sku_prefix_element_map_entry_Obj  =  [SELECT Id,IsDeleted,Name,Map_to_Value__c,SKU_Prefix_Element_Map__c from SKU_Prefix_Element_Map_Entry__c];
    System.assertEquals(true,sku_prefix_element_map_entry_Obj.size()>0);
    List<SKU_Prefix_Element_Map__c> sku_prefix_element_map_Obj  =  [SELECT Id,IsDeleted,Name,SFDC_Record_Id__c from SKU_Prefix_Element_Map__c];
    System.assertEquals(true,sku_prefix_element_map_Obj.size()>0);
    SKU_Trigger_Helper obj01 = new SKU_Trigger_Helper();
    SKU_Trigger_Helper.toBase36(10,10,10);
  }
 
  static testMethod void test_loadMap_UseCase1(){
    List<SKU_Prefix_Element_Map_Entry__c> sku_prefix_element_map_entry_Obj  =  [SELECT Id,IsDeleted,Name,Map_to_Value__c,SKU_Prefix_Element_Map__c from SKU_Prefix_Element_Map_Entry__c];
    System.assertEquals(true,sku_prefix_element_map_entry_Obj.size()>0);
    List<SKU_Prefix_Element_Map__c> sku_prefix_element_map_Obj  =  [SELECT Id,IsDeleted,Name,SFDC_Record_Id__c from SKU_Prefix_Element_Map__c];
    System.assertEquals(true,sku_prefix_element_map_Obj.size()>0);
    SKU_Trigger_Helper obj01 = new SKU_Trigger_Helper();
    SKU_Trigger_Helper.loadMap('test data');
  }
}