public with sharing class VG_Settings {
  public static final Map<String, EC_Settings__c> EC_SETTINGS = EC_Settings__c.getAll();

  // Retrieve a map based on the fieldName of the Custom Setting:EC_Settings__c
  public static Map<String, List<EC_Settings__c>> getSettingsByType(String type, String name) {
    Map<String, List<EC_Settings__c>> valueByType =
      new Map<String, List<EC_Settings__c>>();
    if(EC_SETTINGS == null || EC_SETTINGS.isEmpty()) return valueByType;

    String fieldName = String.isNotBlank(name) ? name : 'name';
    for(EC_Settings__c hrcs : EC_SETTINGS.values()){
      if(hrcs.Type__c.equalsIgnoreCase(type)){
        String key = String.valueOf(hrcs.get(fieldName));

        if(valueByType.containsKey(key)) {

          valueByType.get(key).add(hrcs);
        } else {
          valueByType.put(key, new List<EC_Settings__c> {hrcs});
        }
      }
    }
    return valueByType;
  }
}