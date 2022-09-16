@IsTest(SeeAllData=true)
public class VG_Article_Categories_Test {
    static testMethod void Testmethod1() {
        string commId = [Select Id from Network where Name = 'My View'].Id;
        ConnectApi.ManagedTopicCollection mtCollection = ConnectAPI.ManagedTopics.getManagedTopics(commId, ConnectApi.ManagedTopicType.Navigational);
        VG_Article_Categories.getNavigationTopics();
    }
}