@isTest
public class Order_Entry_Line_Trigger_Helper_Test
{
    //
    // Version 2 - Changes to support OEL Metric Record Type
    static testMethod void TestMethod1()
    {
        String testFraction;
        String errorMessage;
        Decimal returnValue;
        String returnString;
        Decimal testDecimal;
        
        testFraction = '25 15/16';
        returnValue = Order_Entry_Line_Trigger_Helper.getDecimalInches(testFraction);   
        System.AssertEquals(25.9375, returnValue); 
        
        testFraction = '3.556';
        returnValue = Order_Entry_Line_Trigger_Helper.getDecimalInches(testFraction);   
        System.AssertEquals(3.5625, returnValue); 

        testFraction = '4A 2/16';
        returnValue = Order_Entry_Line_Trigger_Helper.getDecimalInches(testFraction);   
        System.AssertEquals(-2.0, returnValue); 
        errorMessage =Order_Entry_Line_Trigger_Helper.getErrorMessage(returnValue);
        System.Assert(errorMessage.contains('is not numeric'));

        testFraction = '88 x/16';
        returnValue = Order_Entry_Line_Trigger_Helper.getDecimalInches(testFraction);   
        System.AssertEquals(-3.0, returnValue); 
        errorMessage =Order_Entry_Line_Trigger_Helper.getErrorMessage(returnValue);
        System.Assert(errorMessage.contains('has an invalid numerator'));
        
        testFraction = '88 5/x';
        returnValue = Order_Entry_Line_Trigger_Helper.getDecimalInches(testFraction);   
        System.AssertEquals(-4.0, returnValue); 
        errorMessage =Order_Entry_Line_Trigger_Helper.getErrorMessage(returnValue);
        System.Assert(errorMessage.contains('has an invalid denominator'));

        testFraction = '88 5/0';
        returnValue = Order_Entry_Line_Trigger_Helper.getDecimalInches(testFraction);   
        System.AssertEquals(-5.0, returnValue); 
        errorMessage =Order_Entry_Line_Trigger_Helper.getErrorMessage(returnValue);
        System.Assert(errorMessage.contains('zero denominator'));

        testDecimal = 102.6678;
        returnString = Order_Entry_Line_Trigger_Helper.decimalto16ths(testDecimal);
        System.AssertEquals('102 11/16', returnString); 
        
        testDecimal = 57.1277;
        returnValue = Order_Entry_Line_Trigger_Helper.roundTo16ths(testDecimal);
        System.AssertEquals(57.1250, returnValue); 
        
        //Map<ID,RecordType> rtSchemaMap = Order_Entry_Trigger_Helper_2.getRecordTypeMap('Order_Entry_Line__c');
        Map<ID,Schema.RecordTypeInfo> rtSchemaMap =Schema.SObjectType.Order_Entry_Line__c.getRecordTypeInfosById();
        Map<ID,RecordType> rtMap = Order_Entry_Trigger_Helper_2.getRecordTypeMap('Order_Entry_Line__c');
        Map<String,RecordType> rtNameMap = Order_Entry_Trigger_Helper_2.getRecordTypeByNameMap(rtMap);
        
        

        Order_Entry_Line__c oel = new Order_Entry_Line__c(Quantity__c = 5.0, Base_Decimal_In__c = 57.5, Height_Decimal_In__c = 65.25,
                            Base_Height_1_Decimal_In__c = 0.0, Shape__c = 'Rectangle', RecordTypeId = rtNameMap.get('IGU_Imperial').Id, Status__c = 'Draft');
        
        returnString = Order_Entry_Line_Trigger_Helper.getDimensionSearchKey(oel, rtSchemaMap);
        System.debug('*** Dimension Search Key = ' + returnString);         

        oel.RecordTypeId = rtNameMap.get('IGU_Metric').Id;
        returnString = Order_Entry_Line_Trigger_Helper.getDimensionSearchKey(oel, rtSchemaMap);
        System.debug('*** Dimension Search Key = ' + returnString);         
                
    }
    
    
}