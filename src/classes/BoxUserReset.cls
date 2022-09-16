public class BoxUserReset {
    @AuraEnabled
    public Static void deleteBoxUserAssociation(String userId){
        system.debug('TESTING:' + userId);
        box.Toolkit.deleteUserAssociation(userId); 
    }
}