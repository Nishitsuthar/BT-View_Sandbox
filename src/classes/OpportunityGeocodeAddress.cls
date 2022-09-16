public class OpportunityGeocodeAddress {
// static variable to determine if geocoding has already occurred
@TestVisible public static Boolean geocodingCalled = false;
// wrapper method to prevent calling future methods from an existing future context
public static void DoAddressGeocode(id opportunityId) {
  if (geocodingCalled || System.isFuture()) {
    System.debug(LoggingLevel.WARN,
    '***Address Geocoding Future Method Already Called - Aborting...');
    return;
  }
  // if not being called from future context, geocode the address
  geocodingCalled = true;
    if(!SmartsheetUtil.isSmartsheetSyncJobContext) {
  		geocodeAddress(opportunityId);
    }
}
    
// we need a future method to call Google Geocoding API from Salesforce 
@future (callout=true)
@TestVisible static private void geocodeAddress(id opportunityId)
{ 
        Google_API_Key__c k = Google_API_Key__c.getOrgDefaults();
  // Key for Google Maps Geocoding API
    String geocodingKey = k.API_Key__c;
    //String geocodingKey = 'AIzaSyDYJ8ITpK7ynwxniBkc1LqDCl9KlRX21Zc';
    double latitude;
    double longitude;
  // get the passed in address 
  Opportunity geoAccount = [SELECT Project_Address__c, Project_City__c, Project_State__c, Project_Country__c,
Project_Zip_Code__c
    FROM Opportunity
    WHERE id = :opportunityId];
    
  // check that we have enough information to geocode the address
  if ((geoAccount.Project_Address__c == null) || (geoAccount.Project_City__c == null)) {
    System.debug(LoggingLevel.WARN,'Insufficient Data to Geocode Address');
    return;
  }
  //create a string for the address to pass to Google Geocoding API
  String geoAddress = '';
  if (geoAccount.Project_Address__c != null)
    geoAddress += geoAccount.Project_Address__c + ', ';
  if (geoAccount.Project_City__c != null)
    geoAddress += geoAccount.Project_City__c + ', ';
  if (geoAccount.Project_State__c != null)
    geoAddress += geoAccount.Project_State__c + ', ';
  if (geoAccount.Project_Country__c != null)
    geoAddress += geoAccount.Project_Country__c + ', ';
  if (geoAccount.Project_Zip_Code__c != null)
    geoAddress += geoAccount.Project_Zip_Code__c;
  
  //encode the string so we can pass it as part of URL
  geoAddress = EncodingUtil.urlEncode(geoAddress, 'UTF-8');
  // build and make the callout to the Geocoding API
  Http http = new Http();
  HttpRequest request = new HttpRequest();
  request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + geoAddress + '&key=' + geocodingKey
    + '&sensor=false');
  request.setMethod('GET');
  request.setTimeout(60000);
  try {
    //make the http callout
    HttpResponse response = http.send(request);
    //parse JSON to extract co-ordinates
    JSONParser responseParser = JSON.createParser(response.getBody());
    //initialize co-ordinates
  latitude = null;
    longitude = null;
    while (responseParser.nextToken() != null) {
      if ((responseParser.getCurrentToken() == JSONToken.FIELD_NAME) &&
      (responseParser.getText() == 'location')) {
        responseParser.nextToken();
        while (responseParser.nextToken() != JSONToken.END_OBJECT) {
         String locationText = responseParser.getText();
         responseParser.nextToken();
         if (locationText == 'lat')
           latitude = responseParser.getDoubleValue();
         else if (locationText == 'lng')
           longitude = responseParser.getDoubleValue();
        }
      }
    }
    // update co-ordinates on address if we get them back
    if (latitude != null) {
      geoAccount.GeoLocation__Latitude__s = latitude;
      geoAccount.GeoLocation__Longitude__s = longitude;
      update geoAccount;
    }
  } catch
(Exception e) {
    System.debug(LoggingLevel.ERROR, 'Error Geocoding Address - ' + e.getMessage());
  }
}
}