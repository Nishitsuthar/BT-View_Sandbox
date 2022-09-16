public class VG_UserHierarchyWrapper {
 public  User mUsr {get; set;}
    public  User usr{get; set;}
    public  List<User> subordinates {get; set;}

    public VG_UserHierarchyWrapper(User mUsr, User usr, List<User> subordinates){
    this.mUsr = mUsr;
    this.usr = usr;
    this.subordinates=subordinates;
  }
}