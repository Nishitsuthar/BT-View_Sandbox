@isTest
public class BoxUserReset_Test {

    public static testmethod void method1()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Project Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser12121212@testorg.com');
        INSERT u;
        BoxUserReset.deleteBoxUserAssociation(u.id);
    }
}