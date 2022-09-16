public class VG_UserDataWrapper {
 public SObject record {get; set;}
  public EC_UserData__c userData {get; set;}

  public VG_UserDataWrapper(SObject record, EC_UserData__c userData){
    this.record = record;
    this.userData = userData;
  }
}