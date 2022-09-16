public class Order_Entry_Line_Trigger_Helper
{
    //
    // Version 2 - Changes to Support OEL Metric Record Type
    //
    public static final decimal sxtnth = 0.0625;
    
    public static Decimal getDecimalInches(String inInches)
    {
        // 
        // Converts number string to decimal number.
        // String may be normal decimal number, e.g. '32.25' or
        // Expressed as a fraction e.g. '32 1/4'
        //
        String charInches = inInches.trim();
        String strInches;
        Decimal decInches;
        Decimal numerator;
        String strNumerator;
        Decimal denominator;
        String strDenominator;
        try 
        {
            if (charInches.contains(' '))
            {
                strInches = charInches.subStringBefore(' ');
            }
            else
            {
                if (charInches.remove('.').isNumeric())
                {
                    return roundTo16ths((Decimal.valueOf(charInches))).setScale(4);             
                }
                else
                {
                    return(-1.0);
                }
            }
            if (!strInches.isNumeric())
            {
                return(-2.0);
            }
            else 
            {
                decInches = Decimal.valueOf(strInches);
            }
            if (charInches.contains('/'))
            {
                strNumerator = charInches.subStringBetween(' ','/').trim();
            }
            else
            {
                return(-1.0);
            }
            if(strNumerator.isNumeric())
            {
                numerator = Decimal.valueOf(strNumerator);
            }
            else
            {
                return(-3.0);
            }
            strDenominator = charInches.subStringAfterLast('/').trim();
            if (strDenominator.isNumeric())
            {
                denominator = Decimal.valueOf(strDenominator);
            }
            else
            {
                return(-4.0);
            }
            if (denominator == 0)
            {
                return(-5.0);
            }
            System.debug('***Fraction: ' + String.valueof(numerator) + '/' + String.valueOf(denominator) + ' = ' + String.valueOf(numerator/denominator));
            return roundTo16ths((decInches + numerator/denominator).setscale(4)); 
        }
        catch (Exception ex)
        {
            return(-9.0);
        }   
    } 
    
    public static String getErrorMessage(Decimal errorNum)
    {
        //
        // Coverts return error codes to error messages for errors which occur during string to decimal conversion
        //
        Map<Decimal,String> errorMessages = new Map<Decimal,String> {-1.0=>'is not numeric. Please re-enter.',-2.0=>'is not numeric. Please re-enter.',-3.0=>'has an invalid numerator. Please re-enter.',
            -4.0=>'has an invalid denominator. Please re-enter.',-5.0=>'has a zero denominator. Please re-enter.',-9.0 =>'is invalid. Please re-enter.' };
        if (errorMessages.containsKey(errorNum))
        {
            return (errorMessages.get(errorNum));
        }
        else
        {
            return('caused a decimal conversion exception. Please re-enter.');
        }               
    }
    
    public static String decimalto16ths(Decimal decIn)
    {
        //
        // Converts a decimal number to a fraction string to the nearest 16th
        // for example 32.6 -> '32 5/8'
        //
        Map<Long,String> sixteenths = new Map<Long,String> {0=>'', 1=>'1/16', 2=>'1/8', 3=>'3/16', 4=>'1/4',
            5=>'5/16', 6=>'3/8', 7=>'7/16', 8=>'1/2', 9=>'9/16', 10=>'5/8', 11=>'11/16', 12=>'3/4', 13=>'13/16',
            14=>'7/8', 15=>'15/16'};
        Long intDecIn = decIn.round(System.roundingMode.DOWN);
        Decimal fractDecIn = (decIn-intDecIn).abs();
        System.debug('Int = ' + String.valueOf(intDecIn) + '; Frct = ' + String.valueOf(fractDecIn));
        Long numerator = (fractDecIn / sxtnth).round(System.roundingMode.HALF_EVEN);    
        String result = String.valueOf(intDecIn) + ' ' + sixteenths.get(numerator);
        System.debug('Result '+result);
        return(result);
    }
    
    public static Decimal roundTo16ths(Decimal dec)
    {
        //
        // Rounds a decimal number to the nearest 16th
        //
        Decimal whole = dec.round(System.RoundingMode.DOWN);
        if (whole == dec) return dec;
        Decimal fraction = math.abs(dec-whole);
        Decimal sixteenths = (fraction/sxtnth).round(System.RoundingMode.HALF_EVEN);
        if (dec >= 0) return whole + sixteenths * sxtnth;
        return whole - sixteenths * sxtnth;
    }
    
    
    public static String getDimensionSearchKey(Order_Entry_Line__c oel, Map<ID,Schema.RecordTypeInfo> rt_Map)
    {
        Map<String,String> uomMap = new Map<String,String> {'Imperial'=>'1', 'Metric'=>'2'};
        Map<String,String> shapeMap = new Map<String,String> {'Rectangle'=>'0', 'Triangle - 45'=>'45', 'Triangle - 46'=>'46', 'Trapezoid - 1'=>'1', 'Trapezoid - 2'=>'2', 
            'Trapezoid - 301'=>'301', 'Trapezoid - 302'=>'302'};
        
        String dimensionSearchKey = '';
        System.debug('*** getDimensionSearchKey: Base = ' + String.valueOf(oel.Base_Decimal_In__c) + ', Height = ' + String.valueOf(oel.Height_Decimal_In__c) + ', Base/Height 1 = ' + String.valueOf(oel.Base_Height_1_Decimal_In__c));
        if (rt_map.get(oel.recordTypeID).getDeveloperName().containsIgnoreCase('IMPERIAL'))
        {
            dimensionSearchKey = '1' + '\t' + shapeMap.get(oel.shape__c) + '\t' + String.valueOf(oel.Base_Decimal_In__c) + '\t' + String.valueOf(oel.Height_Decimal_In__c) + 
                '\t' + String.valueof(oel.Base_Height_1_Decimal_In__c);
        }
        else
        {
            dimensionSearchKey = '2' + '\t' + shapeMap.get(oel.shape__c) + '\t' + String.valueOf(oel.Base_mm__c) + '\t' + String.valueOf(oel.Height_mm__c) + 
                '\t' + String.valueof(oel.Base_Height_1_mm__c);
        }
        return dimensionSearchKey;                  
    }
    
    
    
}