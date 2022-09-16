@isTest(SeeAllData=false)
public class VG_DataCategoryServiceTest {
 @isTest 
    static void Test_VG_DataCategoryService() { 
       Test.startTest();  
       VG_DataCategoryService.retrieveAllDataCategories();
        Test.stopTest();
    }
}