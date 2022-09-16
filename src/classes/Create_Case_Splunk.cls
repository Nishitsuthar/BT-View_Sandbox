/*
 *  Global call to be called from Splunk to create a case
 */

@RestResource(urlMapping='/createCaseFromSplunk/*')
global class Create_Case_Splunk {

    @HttpPost
    global static List<CaseResponse> doPost(List<CaseRequest> bodyParam)
    {  
        List<CaseResponse> caseResp = new List<CaseResponse>();
       
      
        List<CaseRequest> caseFromSp = bodyParam;
        System.debug(' Case Request '+caseFromSp);
        
        List<String> lIdsFromSplunk = new List<String>();
        
        for(CaseRequest lId : bodyParam)
        {
            if(lid.locationId !=null || lid.locationId !='')
            {
               lIdsFromSplunk.add(lId.locationId);
            }
        }
        System.debug(' L Id from Splunk '+lIdsFromSplunk);
        Map<String,Building_Account__c> customerSiteInfo = new Map<String,Building_Account__c>();
       
        List<Building_Account__c> customeSites = New List<Building_Account__c>([Select id,Building_Location_ID__c,Account__c,Opportunity__c from Building_Account__c WHERE Building_Location_ID__c IN:lIdsFromSplunk]);
        for(Building_Account__c bl : customeSites)
        {
			customerSiteInfo.put(bl.Building_Location_ID__c,bl);
        }
        
        List<Case> insertCase = new List<Case>();
        Id caseProductIssueRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Product Issue').getRecordTypeId();
        
      for(CaseRequest cr : caseFromSp)
        {
                 Case newCase = new Case();
       
                    newCase.Subject = cr.caseSubject;
        			newCase.RecordTypeId = caseProductIssueRT;
            		newCase.Customer_Site__c = customerSiteInfo.get(cr.locationId).Id;
            		newCase.Event_Id__c = cr.caseEventId;
                    newCase.Object_Reference__c = cr.caseObjectReference;
                    newCase.Description = cr.caseDescription;
            		newCase.AccountId = customerSiteInfo.get(cr.locationId).Account__c;
            		newCase.Priority = 'P3';
            		newCase.Splunk_Id__c = cr.splunkId;
        			
            	insertCase.add(newCase);
        }
          INSERT insertCase;
        
        
        					List<Case> insertCases = new List<Case>(insertCase);
        					List<Id> caseIds = new List<Id>();
        					List<String> caInNum = new List<String>();
        					List<String> allCaseInfo = new List<String>();
        
			for(Case ca : insertCases)
            {
                caseIds.add(ca.Id);
                
            }
        List<Case> caNew = new List<Case>([Select id,AccountId,Subject,RecordTypeId,Box_Folder_Id__c,Customer_Site__c,Event_Id__c,Object_Reference__c,Description,CaseNumber,Splunk_Id__c from Case where ID IN:caseIds]);
        	for(Case ca : caNew)
            {
               caInNum.add(ca.CaseNumber);
              
            }
         						
        List<caseData> casesResp = new List<caseData>();
        
        for (Case c : caNew) {
            casesResp.add(new caseData(c));
        }
        system.debug(casesResp);
        
        			caseResp.add(new CaseResponse('Successfully Created. ',casesResp,'200'));
              return  caseResp;
    }
    
    global Class CaseRequest
    {
        
        global String caseSubject;
        global String locationId;
        global String caseDescription;
        global String caseEventId;
        global String caseObjectReference;
        global String splunkId;
      
    }
    
    global class Document
    {
        public string name;
        public string docBody;
    }
    
    global Class CaseResponse
    {
        global String Message;
        global List<caseData> caseRes;
      
        global String Code;
        
       
	 global CaseResponse(String errMess,List<caseData> caRes ,String eCode)
                
        {
          Message =  errMess;
          caseRes =  caRes; 
          Code  =  eCode;
          
        }
    }
    
    global class caseData {
    public Id Id;
    public String accountId;
    public String caseSubject;
    public String recordTypeId;
    public String boxFolderId;
    public String customerSite;
    public String caseEventId;
    public String caseObjectReference;
    public String caseDescription;
    public String caseNumber;
    public String splunkId;
    
    
    caseData(SObject sob) {
       this.Id = sob.Id;
       this.accountId = (String) sob.get('AccountId');
       this.caseSubject = (String) sob.get('Subject');
       this.recordTypeId = (String) sob.get('RecordTypeId');   
       this.boxFolderId = (String) sob.get('Box_Folder_Id__c'); 
       this.customerSite = (String) sob.get('Customer_Site__c'); 
       this.caseEventId = (String) sob.get('Event_Id__c'); 
       this.caseObjectReference = (String) sob.get('Object_Reference__c'); 
       this.caseDescription = (String) sob.get('Description'); 
       this.caseNumber = (String) sob.get('CaseNumber'); 
       this.splunkId = (String) sob.get('Splunk_Id__c'); 

    }
}

    
}