public with sharing class VG_OrgChartUtilsCtrl {

    @AuraEnabled
    public static String getParent_SubOrdinateUsers(String userId) {

        userId = String.isBlank(userId) ? UserInfo.getUserId() : userId;

        try {

          List<User> currentUsers = VG_UserDataAccess.getDetailsById(new List<Id>{userId});
        	User currUser = new User();
        	if (!currentUsers.isEmpty()) {
        		currUser = currentUsers[0];
        	}

          List<User> mgrUsers = VG_UserDataAccess.getDetailsById(new List<Id>{currUser.ManagerId});
          User mgrUsr = new User();
          if (!mgrUsers.isEmpty()) {
          	mgrUsr = mgrUsers[0];
          }

          List<User> subOrdinates =  VG_UserDataAccess.getDetailsByManagers(new List<Id>{currUser.Id});
          VG_UserHierarchyWrapper userHierarchyWrapper = new VG_UserHierarchyWrapper(mgrUsr,currUser, subOrdinates);

          System.debug('userHierarchyWrapper-->'+JSON.serialize(userHierarchyWrapper));
          
          return JSON.serialize(userHierarchyWrapper);

        }catch(Exception e){
            System.debug('Error while getting the orgHierarchy');
        }


        return '';
    }



}