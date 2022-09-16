@isTest(SeeAllData=false)
public class VG_NetworkDataAccessTest {
 @isTest 
    static void Test_getDetailById() { 
        Id p = [select id from profile where name='System Administrator'].id;
        User user = new User(alias = 'test123', email='test123@view.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                timezonesidkey='America/Los_Angeles', username='tester@view.com');
         insert user;
        system.runAs(user) {
       Test.startTest();  
     String communityId=Network.getNetworkId();
            System.debug('@@ communityId'+communityId);
            VG_NetworkDataAccess.getDetailById(new List<Id>{communityId});
        Test.stopTest();
        }
    }
}