/*Name: CreateOracleCustomer
 * Created By : Magnet 360
 * Purpose: This class is used in CreateOracleCustomer lightning app.
 *          Tt returns the account detail to component.
 *          It also save the account record based on update fromlightning component.
 */
public class CreateOracleCustomer {
    @auraEnabled
    /*
     * getAccountData : returns account deatil to component
     */
    public static Account getAccountData(String recordId){
        Account accountRecord = new Account();
        try{
            if(recordId != null){
                accountRecord =[select id,Name,Oracle_Integration_Status__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,
                                BillingCountry,ShippingStreet,ShippingCity,shippingPostalCode,shippingState,shippingCountry,Oracle_Customer_Number__c
                                from account 
                                where id =:recordId
                                limit 1];
                system.debug('accountRecordaccountRecord'+accountRecord.shippingPostalCode);
            }
        }
        catch(Exception e){
        }
        return accountRecord;
    }
    
    
    @auraEnabled
    /*
     * saveDetails : Updatesthe account to create oracle customer.
     */
    public static boolean saveDetails(Account accountRecord){
        Boolean result = false;
        try{
            Database.SaveResult saveResult = database.update(accountRecord);
            if (saveResult.isSuccess()) {
                result = true;
            }
        }
        catch(exception e){
        }
        return result;
    }
    
    @auraEnabled
    /*
     * To authorize profiles: Only Deal Desk and Sytem Admin should use this functionality
     */
    public static boolean getProfileData(){
        Id loggedProfileId  = userinfo.getProfileId();
        Boolean result      = false;
        for(Account_Profiles_Authorized__c field : Account_Profiles_Authorized__c.getAll().values()){
            if(field.ProfileId__c == loggedProfileId){
                result = field.IsAuthorized__c;
            }
        }
        return result;
    }
    
}