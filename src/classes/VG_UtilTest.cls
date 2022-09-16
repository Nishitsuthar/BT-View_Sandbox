@isTest(SeeAllData=false)
public class VG_UtilTest {
 @isTest 
    static void Test_Util() { 
        VG_Util.flattenListForQuery( new List<Object> {'Recently_Viewed'});
        
        VG_Util.checkCRUD_FLS('User', new Set<String>{'Name'},'Read');
        VG_Util.stripNamespace('User');
    }
    
}