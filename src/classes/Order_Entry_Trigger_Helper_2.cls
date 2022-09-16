public class Order_Entry_Trigger_Helper_2
{
    public static Map<String,String> convertShape = new Map<String,String>{'45'=>'Triangle - 45', '46' =>'Triangle - 46', '1' =>'Trapezoid - 1', '2'=>'Trapezoid - 2',
          '301'=>'Trapezoid - 301', '302'=>'Trapezoid - 302'};

    public static String addChangeType(String addType, String changeTypes)
    {   
        if (changeTypes == null)
        {
            return addType + ';';
        }   
        if (changeTypes.contains(addType))
        {
            return changeTypes;
        }
        else
        {
            return changeTypes + ';' + addType;
        }
    
    }
    
    public static void validateReleaseInsert()
    {
                
    }
    
    public static Boolean validateDimensions(OrderEntryLineWrapper oelw)
    {
        Order_Entry_Line__c oel = oelw.oel;
        Boolean dimensionError = false;
        /*
         * Validate Shape
         * If shape is loaded from an Excel file, it will either be null (Rectangle) or a numeric code for a shape
         * restricted to the values in the convertShape map's keyset. If it is entered through the UI, it will either be 
         * null (Rectangle), 'Rectangle' or restricted to the values in the convertShape value list. If none of these,
         * shape is invalid.
         */
        if (oel.Shape__c == null )
        { 
            oel.Shape__c = 'Rectangle';
        }
        
        if (!oel.Shape__c.equalsIgnoreCase('Rectangle'))
        {
            if (convertShape.containsKey(oel.Shape__c))
            {
                oel.Shape__c = convertShape.get(oel.Shape__c);
            }
            else
            {
                Boolean shapeOK = false;
                for(String checkShape : convertShape.values())
                {
                    if(checkShape.equalsIgnoreCase(oel.Shape__c))
                    {
                        shapeOK = true;
                    }
                }
                if (!shapeOK)
                {
                    oelw.addValidationError('Invalid value for shape: ' + oel.Shape__c);
                    dimensionError = true;
                }
            }
        }
        if (oelw.recordType.containsIgnoreCase('IMPERIAL'))
        //
        // Validate and Convert Dimensions
        //
        {
            if(oel.Base_in__c == null)
            {
                dimensionError = true;
                oelw.addValidationError('Base (in.) may not be null');
            }
            else
            {
                oel.Base_decimal_in__c = Order_Entry_Line_Trigger_Helper.getDecimalInches(oel.Base_in__c);
                oel.Base_mm__c = oel.Base_Decimal_in__c * 25.4;                  
                if (oel.Base_decimal_in__c < 0)
                {
                    dimensionError = true;
                    oelw.addValidationError('Base (in) ' + Order_Entry_Line_Trigger_Helper.getErrorMessage(oel.Base_decimal_in__c)); 
                }
            }   

            if(oel.Height_in__c == null)
            {
                dimensionError = true;
                oelw.addValidationError('Height(in) may not be null');
            }
            else
            {
                oel.Height_decimal_in__c = Order_Entry_Line_Trigger_Helper.getDecimalInches(oel.Height_in__c);
                oel.Height_mm__c = oel.Height_decimal_in__c * 25.4;
                                  
                if (oel.Height_decimal_in__c < 0)
                {
                    dimensionError = true;
                    oelw.addValidationError('Height (in.) ' + Order_Entry_Line_Trigger_Helper.getErrorMessage(oel.Height_decimal_in__c)); 
                }
            }   
            if (oel.Shape__c.containsIgnoreCase('TRAPEZOID'))
            {
                if(oel.Base_Height_1_in__c == null)
                {
                    dimensionError = true;
                    oelw.addValidationError('Base/Height 1(in) must be entered for trapezoids');                                                               
                }
                else
                {
                    oel.Base_Height_1_decimal_in__c = Order_Entry_Line_Trigger_Helper.getDecimalInches(oel.Base_Height_1_in__c);  
                    oel.Base_Height_1_mm__c  = oel.Base_Height_1_decimal_in__c * 25.4;               
                    if (oel.Base_Height_1_decimal_in__c < 0)
                    {
                        dimensionError = true;
                        oelw.addValidationError('Base/Height 1 (in.) ' + Order_Entry_Line_Trigger_Helper.getErrorMessage(oel.Base_Height_1_decimal_in__c)); 
                    }
                    else
                    {
                        if ((oel.Shape__c == 'Trapezoid - 301' || oel.Shape__c == 'Trapezoid - 302') && oel.Base_Height_1_Decimal_In__c > oel.Base_Decimal_In__c )
                        {
                            oelw.addValidationError('Base/Height 1 many not exceed Base');
                            dimensionError = true;
                        }
                        if ((oel.Shape__c == 'Trapezoid - 1' || oel.Shape__c == 'Trapezoid - 2') && oel.Base_Height_1_Decimal_In__c > oel.Height_Decimal_In__c )
                        {
                            oelw.addValidationError('Base/Height 1 many not exceed Height');
                            dimensionError = true;
                        }
                    }
                }   
            }
            if (!oelw.hasErrors)
            {
                oel.Envelope_Area_Sq_Ft__c = (oel.Base_decimal_in__c * oel.Height_decimal_in__c) / 144.0;
                if (oel.Shape__c.containsIgnoreCase('RECTANGLE') )
                {
                    oel.Unit_Area_Sq_Ft__c = (oel.Base_decimal_in__c * oel.Height_decimal_in__c) / 144.0; 
                }
                else
                {
                    if (oel.Shape__c.containsIgnoreCase('TRIANGLE'))
                    {
                        oel.Unit_Area_Sq_Ft__c = (oel.Base_decimal_in__c * oel.Height_decimal_in__c) / 288.0; 
                    }                                                                       
                    else
                    {
                        if (oel.Shape__c.contains('301') || oel.Shape__c.contains('302'))
                        {
                            oel.Unit_Area_Sq_Ft__c = ((oel.Base_decimal_in__c + oel.Base_Height_1_Decimal_in__c)* oel.Height_decimal_in__c) / 288.0; 
                        }
                        else
                        {
                            if (oel.Shape__c.contains('1') || oel.Shape__c.contains('2'))
                            {
                            oel.Unit_Area_Sq_Ft__c = ((oel.Height_decimal_in__c + oel.Base_Height_1_Decimal_in__c)* oel.Base_decimal_in__c) / 288.0; 
                            }
                        }
                    }
                }
                oel.Area_Sq_Ft__c = oel.Unit_Area_Sq_Ft__c * oel.Quantity__c;                
            }                           
        }
        else
        {
            if (oel.Base_mm__c != null)
            {
                //roundoff Decimal field to 1/16 for Metric Orders
                oel.Base_Decimal_in__c = Order_Entry_Line_Trigger_Helper.roundTo16ths(oel.Base_mm__c/25.4);
            }
            else
            {
                dimensionError = true;
                oelw.addValidationError('Base (mm.) may not be null');              
            }
            if (oel.Height_mm__c != null)
            {
                //roundoff Decimal field to 1/16 for Metric Orders
                oel.Height_Decimal_in__c = Order_Entry_Line_Trigger_Helper.roundTo16ths(oel.Height_mm__c/25.4);
            }
            else
            {
                oelw.addValidationError('Height (mm.) may not be null');
            }   
            if (oel.Shape__c.contains('Trapezoid') && oel.Base_Height_1_mm__c == null)
            {
                dimensionError = true;
                oelw.addValidationError('Base/Height 1 (mm.) may not be null for trapezoids');          
            }
            
            if (!oelw.hasErrors)
            {
                oel.Envelope_Area_Sq_Ft__c = oel.Base_Decimal_In__c * oel.Height_Decimal_in__c / 144;
                if (oel.Shape__c.containsIgnoreCase('RECTANGLE'))
                {
                    oel.Unit_Area_Sq_m__c = (oel.Base_mm__c * oel.Height_mm__c /1000000.0);
                }
                else
                {
                    if (oel.Shape__c.containsIgnoreCase('TRIANGLE'))
                    {
                        oel.Unit_Area_Sq_m__c = (oel.Base_mm__c * oel.Height_mm__c)/2000000.0;
                    }
                    else
                    {
                        //roundoff Decimal field to 1/16 for Metric Orders
                        oel.Base_Height_1_Decimal_in__c = Order_Entry_Line_Trigger_Helper.roundTo16ths(oel.Base_Height_1_mm__c/25.4);
                        if (oel.Shape__c.contains('301') || oel.Shape__c.contains('302') )
                        {
                            oel.Unit_Area_Sq_m__c = ((oel.Base_mm__c + oel.Base_Height_1_mm__c) * oel.Height_mm__c)/2000000.0;
                        }
                        else
                        {
                            oel.Unit_Area_Sq_m__c = ((oel.Height_mm__c + oel.Base_Height_1_mm__c) * oel.Base_mm__c)/2000000.0;
                        }
                       
                    }
                }
                oel.Unit_Area_Sq_Ft__c = oel.Unit_Area_Sq_M__c * 10.7639;
                oel.Area_Sq_Ft__c = oel.Unit_Area_Sq_Ft__c * oel.Quantity__c;
                oel.Total_Area_Sq_m__c = oel.Unit_Area_Sq_m__c * oel.Quantity__c;
            }
        }
        return dimensionError;        

    }
    
    public static Boolean validateFactory(OrderEntryLineWrapper oelw, Product2 product)
    {
        Decimal MAXDIMIN = 120.0;
        Decimal MAX2DIMIN = 72.0;
        Decimal MINDIMIN = 14.0;
        Decimal MINTAN = 0.57735;
        Decimal MAXTAN = 1.73205;
        Decimal RAD2DEG = 57.2958;
        Decimal checkTan;
        Boolean factoryError = false;
        Boolean nullDimension = false;
        Order_Entry_Line__c oel;

        oel = oelw.oel;
        //
        // No dimension may exceed maximum of MAXADMIN
        //  
        if (oel.Base_Decimal_In__c != null) 
        {
            if (oel.Base_Decimal_In__c > MAXDIMIN)
            {
                oelw.addValidationError('Factory: Base exceeds maximum (' + String.valueOf(MAXDIMIN) + '")');
                factoryError = true;
            }
            if (oel.Base_Decimal_In__c < MINDIMIN)
            {
                oelw.addValidationError('Factory: Base is less than minimum (' + String.valueOf(MINDIMIN) + '")');
                factoryError = true;
            }
        }   
        else
        {
            nullDimension = true;
        }       
        if  (oel.Height_Decimal_In__c != null)  
        {           
            if (oel.Height_Decimal_In__c > MAXDIMIN)
            {
                oelw.addValidationError('Factory: Height exceeds maximum (' + String.valueOf(MAXDIMIN) + '")');
                factoryError = true;
            }   
                    
            if (oel.Height_Decimal_In__c < MINDIMIN)
            {
                oelw.addValidationError('Factory: Height is less than minimum (' + String.valueOf(MINDIMIN) + '")');
                factoryError = true;
            }
        }
        else
        {
            nullDimension = true;
        }   
        //
        // Base and Height may not both exceed MAX2DIMIN
        //
        if (!nullDimension)
        {
            if (oel.Base_Decimal_In__c > MAX2DIMIN && oel.Height_Decimal_In__c > MAX2DIMIN)
            {
                oelw.addValidationError('Factory: Base and Height may not both exceed (' + String.valueOf(MAX2DIMIN) + '")');
                factoryError = true;
            }
        }
                            
        if (oel.Shape__c.contains('Trapezoid'))
        {
            if (oel.Base_Height_1_Decimal_In__c != null)
            {
                if (oel.Base_Height_1_Decimal_In__c < MINDIMIN)
                {
                    oelw.addValidationError('Factory: Base/Height 1 is less than minimum (' + String.valueOf(MINDIMIN) + '")');
                    factoryError = true;
                }   
            }
            else
            {
                nullDimension = true;
            }
        }               
        //
        // Acute angles may not be < 30 degrees
        //
        System.debug('*** Shape is ' + oel.Shape__c);
        System.debug('*** Base is ' + String.valueOf(oel.Base_Decimal_In__c));
        System.debug('*** Height is ' + String.valueOf(oel.Height_Decimal_In__c));
        System.debug('*** Base/Height 1 is ' + String.valueOf(oel.Base_Height_1_Decimal_In__c));
        if (!nullDimension)
        {
            if (oel.Shape__c != 'Rectangle')
            {
                if ((oel.Shape__c == 'Trapezoid - 1' || oel.Shape__c == 'Trapezoid - 2'))
                {
                    System.debug('*** Width = ' + String.valueOf(oel.Base_Decimal_In__c) + ', Height = ' + String.valueOf(oel.Height_Decimal_In__c) +
                        ', Base_Height_1__c = ' + String.valueOf(oel.Base_Height_1_Decimal_In__c) );
                    checkTan = oel.Base_Decimal_In__c / (oel.Height_Decimal_In__c - oel.Base_Height_1_Decimal_In__c);
                    if (checkTan < MINTAN)
                    {
                        System.debug('*** Tangent Angle = ' + String.valueOf(checkTan) );
                        oelw.addValidationError('Factory: Smallest angle may not be less than ' + String.valueOf((Math.atan(MINTAN)*RAD2DEG).setScale(2,System.RoundingMode.HALF_DOWN) + ' degrees'));
                        factoryError = true;
                    }
                }
                else
                {
                    if ((oel.Shape__c == 'Trapezoid - 301' || oel.Shape__c == 'Trapezoid - 302'))               
                    {
                        System.debug('*** Width = ' + String.valueOf(oel.Base_Decimal_In__c) + ', Height = ' + String.valueOf(oel.Height_Decimal_In__c) +
                            ', Base_Height_1__c = ' + String.valueOf(oel.Base_Height_1_Decimal_In__c) );

                        checkTan = oel.Height_Decimal_In__c / (oel.Base_Decimal_In__c - oel.Base_Height_1_Decimal_In__c);
                        if (checkTan < MINTAN)
                        {
                            System.debug('*** Tangent Angle = ' + String.valueOf(checkTan) );
                            oelw.addValidationError('Factory: Smallest angle may not be less than ' + String.valueOf((Math.atan(MINTAN)*RAD2DEG).setScale(2,System.RoundingMode.HALF_DOWN) + ' degrees'));
                            factoryError = true;
                        }
                    }
                    else
                    {
                        if ((oel.Shape__c == 'Triangle - 45' || oel.Shape__c == 'Triangle - 46'))
                        {
                            System.debug('*** Width = ' + String.valueOf(oel.Base_Decimal_In__c) + ', Height = ' + String.valueOf(oel.Height_Decimal_In__c) +
                                ', Base_Height_1__c = ' + String.valueOf(oel.Base_Height_1_Decimal_In__c) );
                            checkTan = oel.Base_Decimal_In__c / oel.Height_Decimal_In__c;
                        }
                        if (checkTan > MAXTAN || checkTan < MINTAN)
                        {
                            System.debug('*** Tangent Angle = ' + String.valueOf(checkTan) );
                            oelw.addValidationError('Factory: Smallest angle may not be less than ' + String.valueOf((Math.atan(MINTAN)*RAD2DEG).setScale(2,System.RoundingMode.HALF_DOWN) + ' degrees'));
                            factoryError = true;
                        }
                    }
                }
            }
        }
        return factoryError;    
    }
    
    public static Map<Id, RecordType> getRecordTypeMap (String objectName)
    {
        Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>();
        for (RecordType rt : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType WHERE IsActive = true AND SObjectType = :objectName])
        {
            recordTypeMap.put(rt.ID, rt);
        }
        return recordTypeMap;
    }
    
    public static Map<String, RecordType> getRecordTypeByNameMap(String objectName)
    {
        Map<String, RecordType> rtNameMap = new Map<String, RecordType>();
        Map<Id,RecordType> rtMap = getRecordTypeMap(objectName);
        for (RecordType rt : rtMap.values())
        {
            rtNameMap.put(rt.DeveloperName, rt);
        }
        return rtNameMap;
    }
    
    public static Map<String, RecordType> getRecordTypeByNameMap(Map<Id,RecordType>  rtMap)
    {
        Map<String, RecordType> rtNameMap = new Map<String, RecordType>();
        for (RecordType rt : rtMap.values())
        {
            rtNameMap.put(rt.DeveloperName, rt);
        }
        return rtNameMap;
    }

    

}