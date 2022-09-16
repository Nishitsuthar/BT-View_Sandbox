@isTest(SeeAllData=false)
public class VG_ContentWrapperTest {
 @isTest 
    static void Test_ContentWrapper() { 
       Test.startTest();  
       // VG_ContentWrapper(List<SObject> articles, SObject content, boolean hasPendingTask) 
          List<VG_ContentWrapper> ecContentWrapperNewList = new List<VG_ContentWrapper>();
		List<SObject> temp=new List<SObject>();
        SObject content;
        ecContentWrapperNewList.add(new VG_ContentWrapper(temp,content,true));
        Test.stopTest();
    }
}