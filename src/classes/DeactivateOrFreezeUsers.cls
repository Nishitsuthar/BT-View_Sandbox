public class DeactivateOrFreezeUsers implements Schedulable {

    public void execute(SchedulableContext ctx) {
      Profile userId = [select Id from Profile where name='Intranet Basic Profile'];
        List<User> userupdatelist = new List<User>();
      List<User> IBPuserslist =[select Id,IsACtive from user where ProfileId =: userId.Id 
                                and Termination_Date__c < Today and IsActive = True];
        system.debug('Users List'+IBPuserslist);
        for(User u :IBPuserslist){
            u.IsActive = false;
            userupdatelist.add(u);
        }
        
        if(userupdatelist.size()> 0){
            update userupdatelist;
        }        
        
        // users not in intranet basic profile
        List<User> usersNIBP =[select Id from user where ProfileId !=: userId.Id and Termination_Date__c < Today];
    	List<UserLogin> userfrozenlist = [select IsFrozen from UserLogin where userId in :usersNIBP 
                                          and IsFrozen = False]; 
        List<UserLogin> userfrozenupdatelist = new List<UserLogin>();
        for(UserLogin u1:userfrozenlist){
            u1.IsFrozen = True;
            userfrozenupdatelist.add(u1);
        }
        if(userfrozenupdatelist.size() > 0){
            update userfrozenupdatelist;
        }
        
    } 
    
}