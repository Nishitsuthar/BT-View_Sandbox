public class CreateSubCaseController{
   
   public Id caseId {get; set;}
   //public List<SelectOptions> recTypeList {get; set;}
   public Id selectedId {get; set;}
   
   //Constructor
   public CreateSubCaseController(ApexPages.StandardController controller) {
       this.caseId = controller.getId();
   }
   
   //this method returns the Select Option list
   public List<SelectOption> getTypeList() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', 'Select'));
       options.add(new SelectOption('012E0000000oR5Z', 'Engineering Case'));
       options.add(new SelectOption('012E0000000seQ0', 'Field Service Case'));
       options.add(new SelectOption('0120L0000009730', 'Intelligence Case'));
     
      return options;
   }
   
   //method called when a record type is selected from page (actionSupport)
   public PageReference onSelectRecType(){
      //Querying Case object to retrieve record of the Case whose sub case we are creating
      List<Case> caseList = new List<Case>();
      caseList = [SELECT Id, AccountId, Account.Name, CaseNumber, ContactId,Description, Est_Cmpl_Date__c, Opportunity__c,
                  Opportunity__r.Name, Priority, RecordTypeId, Status, Subject, Origin, Owner.Email FROM Case WHERE Id = :caseId];
                  
      Case c = new Case();
      if(caseList.size() > 0){
         c = caseList[0];
      }
      String oppId = c.Opportunity__c == null ? '': c.Opportunity__c;
      String oppName = c.Opportunity__c == null ? '' : c.Opportunity__r.Name;
      //String siteId = c.SVMXC__Site__c == null ? '' : c.SVMXC__Site__c;
      //String siteName = c.SVMXC__Site__r.name == null ? '' : c.SVMXC__Site__r.name;
      
      //sub Case to be created
      /*Case subCase = new Case();
      
      subCase.AccountId = c.AccountId; 
      subCase.Est_Cmpl_Date__c = c.Est_Cmpl_Date__c; 
      
      subCase.Opportunity__c = c.Opportunity__c; 
      //subCase.RecordTypeId = '012E0000000oR5Z'; 
      subCase.Origin = c.Origin; 
      //subCase.OwnerId= '00GE0000003Yro3'; 
      subCase.ParentOwnerEmailId__c = c.Owner.Email; 
      subCase.ParentId = c.Id; */
      
      Id recType;
      
      if(selectedId == null ){//
         ApexPages.Message eMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Record Type.');
         ApexPages.addMessage(eMsg);
         return null;
      } 
      
      if(selectedId == '0120L0000009730'){ //Intelligence Case
         recType = '0120L0000009730';
         //owner = '005E0000005TNU1IAO';
      } else if(selectedId == '012E0000000seQ0'){  //Field Service Support Case
           recType = '012E0000000seQ0';
           //owner = '00G0L000003pr0A';
      } else if(selectedId == '012E0000000oR5Z'){  //Engineering Case
           recType = '012E0000000oR5Z';
           //owner = '00GE0000003Yro3';
      }
      
      //Querying User to find Name of the Owner
      /*List<User> uList = new List<User>([Select Id, Name From User Where Id = :owner]);
      User u = new User();
      if(uList.size() > 0){
         u = uList[0];     '&cas1_lkid=' + owner + '&cas1=' + u.Name
      }*/
      
      String url = '/500/e?cas21=1&' + '&RecordType=' + recType + '&cas11=' + c.Origin + '&cas28_lkid=' + c.Id + '&cas28=' + c.CaseNumber + '&retURL=%2F' + c.Id + 
                   '&00NE0000006HdLi=' + c.Owner.Email  ;
      
      url = oppId == null? url: url + '&CF00NE0000003Zu5H_lkid=' + oppId + '&CF00NE0000003Zu5H=' + oppName + '&CF00NE0000003Zu5H_lktp=006' ;
      url = c.AccountId == null ? url: url + 'cas4_lkid=' + c.AccountId + '&cas4=' + c.Account.Name;
      url = c.Est_Cmpl_Date__c == null? url: url + '&00NE0000005k5Ew=' + c.Est_Cmpl_Date__c.format();
     
      
       if(selectedId == '012E0000000seQ0'){ //Field Service Support Case
        // url = url + '/&cas14=/' + EncodingUtil.URLEncode(c.Subject,'UTF-8') ;
         url = url + '&cas14=' + EncodingUtil.URLEncode(c.Subject,'UTF-8') ;
         system.debug('The value for first debug:' + url); 
      } 
      
      if(selectedId == '012E0000000seQ0' || selectedId == '0120L0000009730' || selectedId == '012E0000000oR5Z'){ //Field Service Support Case or Intelligence Case
        // url = url + '&CF00NE0000004toNh_lkid=' + siteId + '&CF00NE0000004toNh=' + siteName ;
         system.debug('The value for second debug: ' + url);
      }
      if(selectedId == '012E0000000seQ0' || selectedId == '012E0000000oR5Z'){
         
          system.debug('The value for third debug: ' + url);
      }
      system.debug('The value just before pgRef: ' + url);
      PageReference pgRef = new PageReference(url);
      system.debug('The value for fourth debug: ' + url);
      return pgRef;
      //return null;
   }
}