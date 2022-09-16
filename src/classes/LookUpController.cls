public class LookUpController {
    @AuraEnabled
 public static List<Contact> fetchContact(String searchKeyWord) {
  String searchKey = searchKeyWord + '%';
  List<Contact> returnList = new List <Contact> ();
  List<Contact> contactLst = [select id, Name,Account.Name,AccountID from Contact where Name LIKE: searchKey limit 20];
 
  for (Contact c: contactLst) {
     returnList.add(c);
     }
  return returnList;
 }
      @AuraEnabled
 public static List<Account> fetchAccounts(String searchKeyWord) {
  String searchKey = searchKeyWord + '%';
  List<Account> returnList = new List <Account> ();
  List<Account> contactLst = [select id, Name from Account where Name LIKE: searchKey limit 20];
 
  for (Account c: contactLst) {
     returnList.add(c);
     }
     system.debug('returnList'+returnList);
  return returnList;
 }
}