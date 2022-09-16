public class LogIssuesCmpController {
    private static final Integer SEARCH_RESULTS_LIMIT = 20;
    @AuraEnabled
    public static String getLogIssueDetails( String strCaseId ) {
        
        
        Response response = new Response();
        if( String.isBlank( strCaseId ) ) {
            response.setStatus( FALSE, 'Case id is missing.' );
        }
        else {
            try {
                response.logIssueCommonWrapper.initializeDefaultStates( strCaseId );
                response.listOfLogIssueWrappers=null;
                response.listOfLogIssueWrappersCSS = new List<LogIssueWrapper>();
                LogIssueWrapper wrap=New LogIssueWrapper();
                wrap.Lite_Mockid='';
                wrap.Liteid='';
                wrap.Mockid='';
                wrap.markID='';
                wrap.prodQty= 0;
                wrap.sel_Resp_Entity='';
                wrap.failuremodedeatils=false;
                wrap.reason_replacement='';
                wrap.recordTypeId='';
                wrap.failureComponent='';
                wrap.cssProdListPrice='';
                wrap.existingMakeUpID='';
                wrap.existingMakeUpDesc='';
                wrap.height='';
                wrap.base='';
                wrap.shape='';
                wrap.newMakeUpID='';
                wrap.newMakeUpname='';
                //wrap.prodDescription='';
                wrap.productnamecss='';
                wrap.requestedDate=null;
                wrap.productidcss='';
                wrap.Create_box_Folder=FALSE;
                wrap.Replaced_SWC = '';
                wrap.Lite_Damaged = '';
                wrap.Replaced_WC = '';
                wrap.Visible_BB_Damage = '';
                wrap.Replaced_IGU_Cable ='';
                wrap.Reflection_Color_Observed = '';
                wrap.Reflection_Color_Degree = '';
                wrap.failuremodedeatils = false;
                wrap.failurecomponentlist=New List<Failure_Components__mdt>();
                wrap.failureComponentOpts=New List<string>();
                wrap.OrderExtMakeup='';
                wrap.rmaIs = false;
                response.listOfLogIssueWrappersCSS.add(wrap);
                response.setStatus( TRUE, '' );
            }
            catch( Exception e ) {
                response.setStatus( FALSE, e.getMessage() );
            }
        }
        return JSON.serialize( response );
    }
    
    public class Response {
        
        public Boolean isSucceeded;
        
        public String message;
        public List<Issue__c> listOfApprovalIssues;
        public LogIssueCommonWrapper logIssueCommonWrapper;
        public Map<String,List<String>> recordTypeNameToListOfFailureComponents;
        public List<LogIssueWrapper> listOfLogIssueWrappers;
        public List<LogIssueWrapper> listOfLogIssueWrappersCSS;
        public List<Asset> listOfAssetSearchedResults;
        public list<Contact> listOfContactsSearchedResults;
        public List<SearchResultWrapper> listOfprodSearchedResults;
        public Response() {
            
            this.isSucceeded = FALSE;
            this.message = '';
            this.listOfApprovalIssues = new List<Issue__c>();
            this.logIssueCommonWrapper = new LogIssueCommonWrapper();
            this.listOfLogIssueWrappers = new List<LogIssueWrapper>(); 
            this.listOfLogIssueWrappersCSS = new List<LogIssueWrapper>();
            this.listOfAssetSearchedResults = new List<Asset>();
            this.listOfContactsSearchedResults = new List<Contact>();
            this.listOfprodSearchedResults=New List<SearchResultWrapper>();
            this.recordTypeNameToListOfFailureComponents = new Map<String,List<String>>();
            for( Failure_Components__mdt  fc : [ SELECT Failure_Component_Name__c, Record_Type_Name__c
                                                FROM Failure_Components__mdt
                                                WHERE
                                                Record_Type_Name__c != NULL
                                                AND
                                                Failure_Component_Name__c != NULL
                                                ORDER By Record_Type_Name__c] ) {
                                                    if( !recordTypeNameToListOfFailureComponents.containsKey( fc.Record_Type_Name__c ) ) {
                                                        this.recordTypeNameToListOfFailureComponents.put( fc.Record_Type_Name__c.toLowerCase(), new List<String>() );
                                                    }
                                                    this.recordTypeNameToListOfFailureComponents.get( fc.Record_Type_Name__c.toLowerCase() ).add( fc.Failure_Component_Name__c );
                                                }
            system.debug('recordTypeNameToListOfFailureComponents'+recordTypeNameToListOfFailureComponents);
        }
        
        public void setStatus( Boolean isSucceeded, String message ) {
            
            this.isSucceeded = isSucceeded;
            this.message = message;
        }
    }
    
    public class LogIssueCommonWrapper {
        
        public String selectedIssueType;
        
        public Case recordCase;
        
        public Account recordAccount;
        
        public Opportunity recordOpportunity;
        
        public List<String> listOfIGUReplacements;
        public List<String> listOfownershippicklist;
        public List<String> listOfCSSReplacements;
        public List<Failure_Mode__c> listOfFailureModeResults;
        public Boolean orderReplacement;
        
        public Boolean RMA;
        
        public Boolean isQuoteToContactEditable;
        
        Public string common_Lite_Mockid;
        Public string common_Mockid;
        Public string common_Assetid;
        Public string common_Liteid;
        Public string common_height;
        Public string common_h1_B1;
        Public string common_base;
        Public string common_shape;
        Public string common_existingMakeUpID;
        Public string common_existingMakeUpDesc;
        Public string common_sel_Resp_Entity;
        Public string common_reason_replacement;
        Public string common_lite_height;
        Public string common_lite_width;
        public Date requestDate;
        
        public Boolean showLiteID;
        public Boolean showMockID;
        Public string quoteToContactname;
        Public string quoteToContactPhone;
        Public string quoteToContactEmail;
        Public string quoteToContactid;
        
        Public string shipToContactname;
        Public string shipToContactPhone;
        Public string shipToContactEmail;
        Public string shipToContactid;
        
        Public string Shipping_Street_1;
        Public string Shipping_Street_2;
        Public string Shipping_City;
        Public string Shipping_State_Province;
        Public string Shipping_Country;
        Public string Shipping_Postal_Code;
        
        Public Boolean rmaIs;
        Public String iguId;
        
        public LogIssueCommonWrapper() {
            this.common_Assetid='';
            this.selectedIssueType = '';
            this.recordCase = new Case();
            this.recordAccount = new Account();
            this.recordOpportunity = new Opportunity();
            this.common_Mockid='';
            this.common_lite_height='';
            this.common_lite_width='';
            this.listOfIGUReplacements = new List<String>();
            this.listOfownershippicklist=new List<string>();
            this.listOfCSSReplacements = new List<String>();
            this.listOfFailureModeResults = new List<Failure_Mode__c>();
            this.common_Lite_Mockid = '';
            this.common_Liteid = '';
            this.common_height = '';
            this.common_h1_B1='';
            this.common_base = '';
            this.common_shape = '';
            this.common_existingMakeUpID = '';
            this.common_existingMakeUpDesc = '';
            this.common_sel_Resp_Entity = '';
            this.common_reason_replacement = '';
			this.iguId = '';            
            this.orderReplacement = TRUE;
            this.RMA = FALSE;
            this.rmaIs = False;
            
            this.showLiteID = FALSE;
            this.showMockID = FALSE;
            
            this.quoteToContactname='';
            this.quoteToContactPhone='';
            this.quoteToContactEmail='';
            this.quoteToContactid='';
            
            this.shipToContactname='';
            this.shipToContactPhone='';
            this.shipToContactEmail='';
            this.shipToContactid='';
            
            this.Shipping_Street_1='';
            this.Shipping_Street_2='';
            this.Shipping_City='';
            this.Shipping_State_Province='';
            this.Shipping_Country='';
            this.Shipping_Postal_Code='';
            
            
        }
        
        public void initializeDefaultStates( String strCaseId ) {
            
            this.setIGUReplacements();
            this.setCSSReplacements();
            this.setfailuremodelist();
            this.setListOfResponsibleEntities();
            this.fetchInitialRecords( strCaseId );
            
        }
        
        private void fetchInitialRecords( String strCaseId ) {
            
            try {
                this.recordCase = [ SELECT Id,CaseNumber, Intelligence_Start_Date__c,AccountId, Account.Name, ContactId,
                                   Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, 
                                   Account.ShippingPostalCode,Account.ShippingStreet, Contact.Phone, Contact.Email,
                                   Contact.MobilePhone, Contact.Name, Opportunity__c, Customer_Site__c,
                                   Opportunity__r.Name,Opportunity__r.IGU_Pigtail_Style__c,Opportunity__r.Sales_Ops_Owner__r.Name,Opportunity__r.Pricebook2Id, Customer_Site__r.Name,Opportunity__r.CurrencyIsoCode
                                   FROM Case 
                                   WHERE ID =: strCaseId 
                                   LIMIT 1
                                  ];
                This.quoteToContactname=this.recordCase.Contact.Name;
                This.quoteToContactid=this.recordCase.Contactid;
                This.quoteToContactPhone=this.recordCase.Contact.Phone;
                This.quoteToContactEmail=this.recordCase.Contact.Email;
                
                This.shipToContactname=this.recordCase.Contact.Name;
                This.shipToContactid=this.recordCase.Contactid;
                This.shipToContactPhone=this.recordCase.Contact.Phone;
                This.shipToContactEmail=this.recordCase.Contact.Email;
                
                this.Shipping_Street_1=this.recordCase.Account.ShippingStreet;
                this.Shipping_Street_2='';
                this.Shipping_City=this.recordCase.Account.ShippingCity;
                this.Shipping_State_Province=this.recordCase.Account.ShippingState;
                this.Shipping_Country=this.recordCase.Account.ShippingCountry;
                this.Shipping_Postal_Code=this.recordCase.Account.ShippingPostalCode;
                
                this.recordAccount = new Account
                    (
                        Id = this.recordCase.AccountId,
                        ShippingStreet = this.recordCase.Account.ShippingStreet,
                        ShippingCity = this.recordCase.Account.ShippingCity,
                        ShippingState = this.recordCase.Account.ShippingState,
                        ShippingCountry = this.recordCase.Account.ShippingCountry,
                        ShippingPostalCode = this.recordCase.Account.ShippingPostalCode
                    );
            }
            catch( Exception e ) {
                System.debug(e.getMessage() );
            }
        }
        
        private void setIGUReplacements() {
            
            this.listOfIGUReplacements = new List<String>();
            
            for( Warranty_Check__mdt wc : [ SELECT Id, Failure_mode_Name__c, Warranty__c 
                                           FROM Warranty_Check__mdt WHERE Product_Family__c = 'IGU' ORDER by 
                                           Failure_mode_Name__c] 
               ) {
                   system.debug('IGU'+wc.Failure_mode_Name__c );
                   this.listOfIGUReplacements.add( wc.Failure_mode_Name__c );
               }
        }
        private void setListOfResponsibleEntities() {
            
            this.listOfownershippicklist = new List<String>();
            for( Schema.PicklistEntry picklistEntry : Issue__c.Ownership__c.getDescribe().getPicklistValues() ) {
                if( picklistEntry.isActive() ) {
                    this.listOfownershippicklist.add( picklistEntry.getValue() );
                }
            }
            System.debug( 'this.listOfownershippicklist:-\n' + JSON.serialize( this.listOfownershippicklist ) );
        }
        private void setfailuremodelist() {
            
            this.listOfFailureModeResults = new List<Failure_Mode__c>();
            
            this.listOfFailureModeResults = [ SELECT ID, Name FROM Failure_Mode__c where Failure_Component__c ='IGU' Order by Name];
            //  this.listOfFailureModeResults.sort();
            
        }
        private void setCSSReplacements() {
            
            this.listOfCSSReplacements = new List<String>();
            for( Warranty_Check__mdt wc : [ SELECT Id, Failure_mode_Name__c, Warranty__c 
                                           FROM Warranty_Check__mdt WHERE Product_Family__c = 'CSS' ORDER by
                                           Failure_mode_Name__c] 
               ) {
                   system.debug('CSS'+wc.Failure_mode_Name__c );
                   this.listOfCSSReplacements.add( wc.Failure_mode_Name__c );
               }
        }
    }
    
    @AuraEnabled
    
    public static List<Failure_Mode__c> getFailureModeDetails(){
        
        List<Failure_Mode__c> lstExpense=[SELECT ID, Name FROM Failure_Mode__c  Order by Name];
        
        return lstExpense;
        
    }
    public class SearchResultWrapper {
        
        public String id;
        
        public String value;
        
        public Double listPrice;
        
        public String description;
        
        public SearchResultWrapper( String id, String value, Double listPrice, String description ) {
            
            
            this.id = id;
            this.value = value;
            this.listPrice = listPrice;
            this.description = description;
        }
    }
    public class LogIssueWrapper {
        public string Lite_Mockid;
        public string Assetid;
        public string Liteid;
        //public string IGU_ID_Provided__c;
        public string Mockid;
        public string markID;
        public string sel_Resp_Entity;
        public string reason_replacement;
        Public Integer prodQty;
        public Boolean showliteid;
        public string recordTypeId;
        public string failureComponent;
        public string cssProdListPrice;
        public List<Failure_Components__mdt> failurecomponentlist;
        public List<String> listOfSelectedFailureModes;
        public List<string> failureComponentOpts;
        public Boolean Create_box_Folder;
        
        public string Lite_Damaged;
        public string Replaced_SWC;
        public string Replaced_WC;
        public string Visible_BB_Damage;
        public string Replaced_IGU_Cable;
        public string Reflection_Color_Observed;
        public string Reflection_Color_Degree;
        public boolean failuremodedeatils;
        public string Shipping_Container;
        public string Shipping_Instructions;
        
        public string existingMakeUpID;
        public string existingMakeUpDesc;
        public string height;
        public string base;
        public string H1_B1;
        public string Lite_height;
        public string Lite_width;
        public string shape;
        public string OrderExtMakeup;
        public string newMakeUpID;
        public string newMakeUpname;
        //public string prodDescription;
        public string newMakeUpProduct_SKU;
        public string newMakeUpProductCode;
        public string productidcss;
        public string productnamecss;
        public string failurmodeid;
        public Date requestedDate;
        public boolean consumables;
        public boolean spareparts;
        public boolean rmaIs;
        
        public string replacedSWC;
        public string replacedWC;
        public string replacedIGU;
        public string liteDamage;
        
        public string verticallyPositionedIGU;
        public string backGrundLghtIGU;
        public string inspected10ft;
        public string visibleDbDamage;
        
        public List<string> namesOfSFM;
        
        public Map<string,List<String>> sfmMap;
        
        
        public LogIssueWrapper(){
            this.Shipping_Container='';
            this.Shipping_Instructions='';
            This.Lite_Mockid='';
            this.Lite_height='';
            this.Lite_width='';
            //this.IGU_ID_Provided__c='';
            this.Assetid='';
            This.newMakeUpProduct_SKU='';
            This.newMakeUpProductCode ='';
            This.Liteid='';
            This.Mockid='';
            This.markID='';
            This.sel_Resp_Entity='';
            This.reason_replacement='';
            This.prodQty= 0;
            this.showliteid=FALSE;
            this.Lite_Damaged='';
            this.Replaced_SWC='';
            this.Replaced_WC='';
            this.Visible_BB_Damage='';
            this.Replaced_IGU_Cable='';
            this.Reflection_Color_Observed='';
            this.Reflection_Color_Degree='';
            this.failuremodedeatils=false;
            this.recordTypeId='';
            this.failureComponent='';
            this.cssProdListPrice='';
            this.existingMakeUpID='';
            this.existingMakeUpDesc='';
            This.OrderExtMakeup='';
            this.height='';
            this.base='';
            this.shape='';
            this.H1_B1='';
            This.newMakeUpID='';
            This.newMakeUpname='';
            //This.prodDescription='';
            This.productidcss='';
            This.productnamecss='';
            this.Create_box_Folder=FALSE;
            this.failurecomponentlist=New List<Failure_Components__mdt>();
            this.failureComponentOpts=New List<string>();
            this.listOfSelectedFailureModes=New List<string>();
            this.failurmodeid='';
			this.consumables = false;            
            this.spareparts = false;
            this.rmaIs = false;
            
            this.replacedSWC='';
            this.replacedWC='';
            this.replacedIGU = '';
            this.liteDamage = '';
            
            this.verticallyPositionedIGU='';
            this.backGrundLghtIGU='';
            this.inspected10ft = '';
            this.visibleDbDamage = '';
            
            this.namesOfSFM = new List<string>();
            this.sfmMap = new Map<string,List<string>>();
            sfmMap.put('Non-Tinting - Intermittent Tinting',new List<string>{'replacedSWC','replacedWC','replacedIGU'});
            sfmMap.put('Non-Tinting',new List<string>{'replacedSWC','replacedWC','replacedIGU'});
            sfmMap.put('Obstruction in Field of View - Spontaneous Breakage',new List<string>{'liteDamage'});
            sfmMap.put('OOS Scratches - S1/S4',new List<string>{'inspected10ft','backGrundLghtIGU','verticallyPositionedIGU'});
            sfmMap.put('OOS Scratches - S3 / Other',new List<string>{'inspected10ft','backGrundLghtIGU','verticallyPositionedIGU'});
            sfmMap.put('Non-Uniformity - Within Lite',new List<string>{'visibleDbDamage'});
            sfmMap.put('Non-Uniformity - L2L',new List<string>{'visibleDbDamage'});

        }
    }
    
    @AuraEnabled
    public static String searchProductRecords( String strSearchKeyword, String strOpportunityPricebook2Id,string pfamily ) {
        
        System.debug( 'searchRecords-strSearchKeyword:-\n' + strSearchKeyword );
        System.debug( 'searchRecords-strOpportunityPricebook2Id:-\n' + strOpportunityPricebook2Id );
        
        Response response = new Response();
        if( String.isBlank( strSearchKeyword ) || String.isBlank( strOpportunityPricebook2Id ) ) {
            response.setStatus( FALSE, 'Sorry, search keyword details were missing.' );
        }
        else {
            strSearchKeyword = '%' + strSearchKeyword + '%';
            
            System.debug( 'After strSearchKeyword:-\n' + strSearchKeyword );
            System.debug( ' pfamily:-\n' + pfamily );
            
            try {
                List<Product2> listOfProducts = [ SELECT ID, Name, Product_SKU__c, ProductCode, Family, 
                                                 (
                                                     SELECT ID, UnitPrice
                                                     FROM PriceBookEntries
                                                     WHERE 
                                                     PriceBook2Id = :strOpportunityPricebook2Id
                                                     LIMIT 1
                                                 )
                                                 FROM Product2 
                                                 WHERE
                                                 IsActive = TRUE
                                                 AND
                                                 Family=:pfamily
                                                 AND
                                                 (
                                                     Name LIKE : strSearchKeyword
                                                     OR
                                                     Product_SKU__c LIKE : strSearchKeyword
                                                     OR
                                                     ProductCode LIKE : strSearchKeyword
                                                     OR
                                                     Description LIKE : strSearchKeyword
                                                 )
                                                 ORDER BY Name LIMIT : 10
                                                ];
                System.debug( 'searchProductRecords-listOfProducts:-\n' + JSON.serialize( listOfProducts ) );
                for( Product2 recordProduct : listOfProducts ) {
                    
                    Double listPrice = 0.00;
                    if( !recordProduct.PriceBookEntries.isEmpty() ) {
                        listPrice = recordProduct.PriceBookEntries.get( 0 ).UnitPrice;
                    }
                    
                    response.listOfprodSearchedResults.add
                        ( 
                            new SearchResultWrapper
                            (
                                recordProduct.Id,
                                recordProduct.Name,
                                listPrice,
                                recordProduct.Name + ' - ' + recordProduct.Product_SKU__c + ' - ' + recordProduct.Family
                            )
                        );
                }
                response.setStatus( !response.listOfprodSearchedResults.isEmpty(), '' );
            }
            catch( Exception e ) {
                System.debug( 'Exception in searchProductRecords:-\n' + e.getMessage() );
                response.setStatus( FALSE, 'Sorry, an error occurred while getting products.' );
            }
        }
        System.debug( 'searchRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String searchAssetRecords( String strSearchKeyword,string opportunityid ) {
        
        System.debug( 'searchAssetRecords-strSearchKeyword:-\n' + strSearchKeyword );
        
        Response response = new Response();
        if( String.isBlank( strSearchKeyword ) ) {
            response.setStatus( FALSE, 'Sorry, search Lite Id keyword was missing.' );
        }
        else {
            strSearchKeyword = '%'+strSearchKeyword + '%';
            System.debug( 'After strSearchKeyword:-\n' + strSearchKeyword );
            
            try {
                response.listOfAssetSearchedResults = [ SELECT ID, Name, Lite_Height__c, Lite_Width__c,
                                                       SerialNumber, Shape__c, Product2Id, Product2.Name
                                                       FROM Asset
                                                       WHERE
                                                       Opportunity__c =:opportunityid 
                                                       AND
                                                       (SerialNumber LIKE : strSearchKeyword
                                                        OR
                                                        Lite_Id__c LIKE : strSearchKeyword)
                                                       ORDER BY SerialNumber 
                                                       LIMIT : SEARCH_RESULTS_LIMIT
                                                      ];
                response.setStatus( !response.listOfAssetSearchedResults.isEmpty(), '' );
            }
            catch( Exception e ) {
                System.debug( 'Exception in searchAssetRecords:-\n' + e.getMessage() );
                response.setStatus( FALSE, 'Sorry, an error occurred while getting Assets.' );
            }
        }
        System.debug( 'searchAssetRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String searchContactRecords( String strSearchKeyword ,String strCaseId,string conid) {
        
        System.debug( 'searchContactRecords-strSearchKeyword:-\n' + strSearchKeyword );
        
        Response response = new Response();
        if( String.isBlank( strSearchKeyword ) ) {
            response.setStatus( FALSE, 'Sorry, search Contact keyword was missing.' );
        }
        else {
            strSearchKeyword = strSearchKeyword + '%';
            System.debug( 'After strSearchKeyword:-\n' + strSearchKeyword );
            System.debug( 'After strCaseId:-\n' + strCaseId );
            System.debug( 'After conid:-\n' + conid );
            set<id> conidset=New set<id>();
            conidset.add(conid);
            for(OpportunityContactRole ccrole:[SELECT ContactID FROM OpportunityContactRole
                                               WHERE OpportunityId =: strCaseId ]){
                                                   conidset.add(ccrole.ContactID);   
                                               }
            try {
                response.listOfContactsSearchedResults = [ SELECT ID, Name,Email,Phone
                                                          FROM Contact
                                                          WHERE
                                                          (Name LIKE : strSearchKeyword
                                                           OR
                                                           FirstName LIKE : strSearchKeyword
                                                           OR
                                                           LastName LIKE : strSearchKeyword)
                                                          AND
                                                          ID IN : conidset
                                                          ORDER BY Name 
                                                          LIMIT : SEARCH_RESULTS_LIMIT
                                                         ];
                response.setStatus( !response.listOfContactsSearchedResults.isEmpty(), '' );
            }
            catch( Exception e ) {
                System.debug( 'Exception in searchContactRecords:-\n' + e.getMessage() );
                response.setStatus( FALSE, 'Sorry, an error occurred while getting Assets.' );
            }
        }
        System.debug( 'searchContactRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    
    
    @AuraEnabled
    public static list<issue__c> createIssue(String issueWrapperObjStr){
        list<issue__c> issuestoinsert=New list<issue__c>();
        response response = (response)JSON.deserialize(issueWrapperObjStr, response.class);
        system.debug('--response--'+response);
        system.debug('--response--'+response.logIssueCommonWrapper);
        
        system.debug('--response--'+response.listOfLogIssueWrappers.size());
        set<string> FMids=New set<string>();
        for(Failure_Mode__c fm:[select id,Name From Failure_Mode__c where Failure_Component__c=:'IGU' 
                                And Name LIKE 'Customer%']){
                                    system.debug('in loop---'+fm.Id);
                                    FMids.add(fm.Id);
                                }
        system.debug('FMids----'+FMids);
        for(LogIssueWrapper iss:response.listOfLogIssueWrappers){
            Boolean CustomerObjection=false;
            for(string st:iss.listOfSelectedFailureModes){
                system.debug('not contains----'+st);
                if(FMids.contains(st)){
                    system.debug('contains----');
                    CustomerObjection=True;
                }
            }
            issue__c newIssue=new issue__c();
            newIssue.Case__c = response.logIssueCommonWrapper.recordCase.id;
            if(CustomerObjection){
                newIssue.Failure_Mode_of_Customer_Objection__c=True;
            }
            newIssue.RecordTypeId = Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
            newIssue.Failure_Component__c = 'IGU';
            newIssue.Opportunity__c=response.logIssueCommonWrapper.recordCase.Opportunity__c;
            newIssue.Asset__c = iss.Assetid;
            newIssue.Create_Box_Folder__c = iss.Create_box_Folder;
            newIssue.Ownership__c = iss.sel_Resp_Entity;
            
            newIssue.Replaced_SWC__c=iss.replacedSWC;
            newIssue.Replaced_WC__c = iss.replacedWC;
            newIssue.Replaced_IGU_Cable__c = iss.replacedIGU;
            newIssue.Lite_Damaged__c = iss.liteDamage;
            
            newIssue.From_approx_10ft_3_m__c = iss.inspected10ft;
            newIssue.Uniform_background_lighting_that_simulat__c = iss.backGrundLghtIGU;
            newIssue.Vertically_positioned_at_90_deg_viewing__c = iss.verticallyPositionedIGU;
            
            
            newIssue.Customer_Account__c=response.logIssueCommonWrapper.recordCase.AccountId;
            newIssue.Shipping_Contact_Name__c = response.logIssueCommonWrapper.shipToContactname;
            newIssue.Shipping_Contact_Number__c=response.logIssueCommonWrapper.shipToContactPhone;
            newIssue.Shipping_Contact_Email__c=response.logIssueCommonWrapper.shipToContactEmail;
            newIssue.Customer_Contact__c = response.logIssueCommonWrapper.quoteToContactid;
            newIssue.Shipping_Street_1__c = response.logIssueCommonWrapper.Shipping_Street_1;
            newIssue.Shipping_Street_2__c = response.logIssueCommonWrapper.Shipping_Street_2;
            newIssue.Shipping_City__c = response.logIssueCommonWrapper.Shipping_City;
            newIssue.Shipping_State_Province__c = response.logIssueCommonWrapper.Shipping_State_Province;
            if (response.logIssueCommonWrapper.Shipping_Country != null)
            	newIssue.Shipping_Country__c = AddressUtils.getStandardName(response.logIssueCommonWrapper.Shipping_Country);
            newIssue.Shipping_Postal_Code__c = response.logIssueCommonWrapper.Shipping_Postal_Code;
            if(iss.Lite_Mockid == 'Lite ID' || iss.Lite_Mockid == 'Mock ID') {
                newIssue.IGU_ID_Provided__c=iss.Lite_Mockid;
                newIssue.Lite_ID_Mock_ID__c = iss.Liteid;
            }
            newIssue.Start_Date__c=Date.today();   
            newIssue.Mark_ID__c = iss.markID;
            newIssue.Shipping_Instructions__c = iss.Shipping_Instructions;
            newIssue.Shipping_Container__c = iss.Shipping_Container;         
            newIssue.Height_in__c = iss.Lite_height;
            newIssue.Base_in__c = iss.Lite_width;
            newIssue.Existing_Makeup__c = iss.existingMakeUpID;
            newIssue.Shape__c = iss.shape;
            newIssue.Want_to_order_existing_Makeup__c=iss.OrderExtMakeup;
            system.debug('OrderExtMakeup=='+iss.OrderExtMakeup);
            if(iss.OrderExtMakeup == 'Yes') {
                newIssue.Product__c = iss.existingMakeUpID;
                
            }else {
                newIssue.Product__c = iss.newMakeUpID;
            }
            newIssue.Replaced_SWC__c=iss.replacedSWC;
            newIssue.Lite_Damaged__c=iss.liteDamage;
            newIssue.Replaced_WC__c  = iss.replacedWC;
            newIssue.Visible_BB_Damage__c = iss.visibleDbDamage;
            newIssue.Replaced_IGU_Cable__c = iss.replacedIGU;
            newIssue.Reflection_Color_Observed__c = iss.Reflection_Color_Observed;
            newIssue.Reflection_Color_Degree__c = iss.Reflection_Color_Degree;
            newIssue.Work_Type__c='Troubleshooting';      
            newIssue.Quantity__c = iss.prodQty;
            newIssue.H1_B1_in__c = iss.H1_B1;
            if(iss.consumables == null)
                newIssue.Consumables__c = false;
            else
                newIssue.Consumables__c = iss.consumables;
            
            if(iss.spareparts == null)
                newIssue.Spare_parts__c = false;
            else
                newIssue.Spare_parts__c = iss.spareparts;
            
            system.debug('---newIssue.Spare_parts__c---'+iss.spareparts);
            
            
            system.debug('---newIssue.Product_Return__c---'+iss.rmaIs);
            newIssue.Date_Identified__c = Date.today();
            newIssue.Requested_Delivery_Date__c = iss.requestedDate;
            newIssue.Product_Replacement__c = response.logIssueCommonWrapper.orderReplacement;
            //newIssue.Product_Return__c = response.logIssueCommonWrapper.RMA; 
            
            newIssue.Product_Return__c = response.logIssueCommonWrapper.RMA ? response.logIssueCommonWrapper.RMA : iss.rmaIs;
            // newIssue.Product_Return__c = iss.rmaIs;
            if(iss.reason_replacement != '') {
                newIssue.Reason_for_Replacement__c = iss.reason_replacement;
            }
            issuestoinsert.add(newIssue);
        }
        
        
        system.debug('--issuestoinsert-'+json.serializePretty(issuestoinsert));
        system.debug('--issuestoinsert size--'+issuestoinsert.size());
        list<issue__c> issuesinserted=New list<issue__c>();
        set<id> issueids=New set<id>();
        if(issuestoinsert.size()>0){
            IssueTriggerHelper.areIssuesCreatedFromLC = TRUE;
            //Try{
            insert issuestoinsert;
            system.debug('--inserted---');
            /*}Catch(Exception e){
system.debug('exception during insert-'+e.getMessage()); 
}*/
            IssueTriggerHelper.areIssuesCreatedFromLC = FALSE;
            integer index =0;
            List<Issue_Failure_Mode__c> listOfFailureModes = new List<Issue_Failure_Mode__c>();
            for(LogIssueWrapper iss:response.listOfLogIssueWrappers){
                for(string fmid: iss.listOfSelectedFailureModes){
                    listOfFailureModes.add( 
                        new Issue_Failure_Mode__c
                        ( 
                            Issue__c = issuestoinsert[index].Id, 
                            Failure_Mode__c = fmid,
                            Failure_Component__c='IGU'
                        )
                    );
                    
                }
                issueids.add(issuestoinsert[index].Id);
                index++;
            }
            system.debug('--listOfFailureModes--'+listOfFailureModes);
            if(listOfFailureModes.size()>0){
                system.debug('--listOfFailureModes.size()--'+listOfFailureModes.size());
                Database.insert( listOfFailureModes, false );
                
            }
            system.debug('--listOfFailureModes-after-'+listOfFailureModes);
            // submitIssuesForApprovalAndOrder(issuestoinsert, response.logIssueCommonWrapper.recordCase.Id);
            
            return [SELECT id,Asset__c,Replaced_SWC__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Case__r.Accountid,Shipping_Container__c,Shipping_Instructions__c,Product_SKU__c,Name,In_Approval__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                    Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                    Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                    Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                    Height_in__c,Base_in__c,IGU_ID_Provided__c,Lite_ID_Mock_ID__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c
                    FROM Issue__c  where id=:issueids order by Name ASC]; // return all fields of above issues
        }
        return null;
    }
    @AuraEnabled
    public static issueWrapper updateIssue(List<Issue__c> issuesList){
        Set<Id> issueIds = new Set<Id>();
        if (issuesList != null && issuesList.size() > 0 ) {
            for(issue__c eachIssue : issuesList) {
                issueIds.add(eachIssue.Id);
            }
            
            if (issuesList.size() > 0) {
                try {
                    update issuesList;
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
                
            }
            if (issueIds.size() > 0) {
                List<Issue__c> issueLst = [SELECT id,Replaced_SWC__c,Replaced_WC__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Product_SKU__c,Asset__c,In_Approval__c,Name,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                           Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                           Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                           Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,Shipping_Instructions__c,Shipping_Container__c,
                                           Height_in__c,Base_in__c,IGU_ID_Provided__c,Lite_ID_Mock_ID__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c,(select Id,Failure_Mode__c,Failure_Mode__r.Name from Defect_Root_Causes__r)
                                           FROM Issue__c  where id=:issueids];
                
                issueWrapper wrapper = new issueWrapper();
                for(Issue__c iss:issueLst){
                    issueWithFailures wrap = new issueWithFailures();
                    wrap.issueRec = iss;
                    for(Issue_Failure_Mode__c dr:iss.Defect_Root_Causes__r){
                        wrap.selectedFailures.add(dr.Failure_Mode__c);
                        wrap.selectedFailuresNames.add(dr.Failure_Mode__r.Name);
                    }
                    wrapper.issuesLst.add(wrap);
                }
                return  wrapper;
            }    
        }
        
        return null;
    }
    @AuraEnabled
    public static void  saveopenissues( list<Issue__c> issuesList,String SelectedNewFailureModes){
        system.debug('>>>> SelectedNewFailureModes '+SelectedNewFailureModes);
        Map<String,List<String>> failuremodes = (Map<String,List<String>>)JSON.deserialize(SelectedNewFailureModes, Map<String,List<String>>.class);
        try{
            delete([select id from Issue_Failure_Mode__c where Issue__c in:failuremodes.keyset()]);
        }catch(exception e){}
        List<Issue_Failure_Mode__c> listOfFailureModes = new List<Issue_Failure_Mode__c>(); 
        for(String eachIssueId :failuremodes.keyset()){
            
            for(String eachFailure :failuremodes.get(eachIssueId)){
                listOfFailureModes.add( new Issue_Failure_Mode__c
                                       ( 
                                           Issue__c = eachIssueId, 
                                           Failure_Mode__c = eachFailure
                                           //     Failure_Component__c=iss.failureComponent
                                       ));
                
            }
            
        }
        if(!listOfFailureModes.isEmpty()){
            database.insert(listOfFailureModes,false);
        }
        try{
            update issuesList;
        }
        catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            throw new AuraHandledException( e.getMessage());    
        }
    }
    @AuraEnabled
    public static issueWrapper fetchopenissues( string caseid){
        
        List<Issue__c> issueLst = [SELECT id,Asset__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Case__r.Accountid,Product_SKU__c,In_Approval__c,RecordType.Name,Name,Consumables__c,Spare_Parts__c,Product_Return__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                   Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                   Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                   Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,Shipping_Instructions__c,Shipping_Container__c,
                                   Height_in__c,Base_in__c,(select Id,Failure_Mode__c,Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,Lite_ID_Mock_ID__c,BOX_Folder_Id__c,Reverse_Shipment_Info__c,FA_Status__c
                                   FROM Issue__c  where Case__c=:caseid and issue_status__c='Open' AND
                                   Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId()];
        issueWrapper wrapper = new issueWrapper();
        for(Issue__c iss:issueLst){
            issueWithFailures wrap = new issueWithFailures();
            wrap.issueRec = iss;
            wrap.newMakeUpname = iss.Product__r.Name;
            wrap.prodDescription = iss.Product__r.Name == null ? '' : iss.Product__r.Name;
            for(Issue_Failure_Mode__c dr:iss.Defect_Root_Causes__r){
                wrap.selectedFailures.add(dr.Failure_Mode__c);
                wrap.selectedFailuresNames.add(dr.Failure_Mode__r.Name);
                if(wrap.updateSfmMap.containsKey(dr.Failure_Mode__r.Name)){
                    wrap.provideFMDetails = true;
                }
                
            }
            wrapper.issuesLst.add(wrap);
        }
        return  wrapper;
        
    }
    @AuraEnabled
    public static list<Issue__c> fetchopenissuesForIGU( string caseid){
        
        return [SELECT id,Name,Asset__c,Replaced_SWC__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Product_SKU__c,Consumables__c,Spare_Parts__c,In_Approval__c,Product_Return__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,Shipping_Instructions__c,Shipping_Container__c,
                Height_in__c,Base_in__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,Lite_ID_Mock_ID__c,BOX_Folder_Id__c,Reverse_Shipment_Info__c,FA_Status__c
                FROM Issue__c  where Case__c=:caseid and (issue_status__c='Open' OR issue_status__c='Replacement Rejected') AND
                Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId()]; 
        
    }
    @AuraEnabled
    public static list<Issue__c> fetchopenCSSissues( string caseid){
        
        return [SELECT id,Name,Asset__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Shipping_Container__c,Product_SKU__c,In_Approval__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                Shipping_Contact_Name__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r), Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                Height_in__c,Base_in__c,IGU_ID_Provided__c,Lite_ID_Mock_ID__c,toLabel(RecordType.Name),Failure_Component__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c
                FROM Issue__c  where Case__c=:caseid and issue_status__c='Open' AND
                ( Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId()
                 OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Control Panel').getRecordTypeId()
                 OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Controller & User Interface').getRecordTypeId()
                 OR  Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Network').getRecordTypeId()
                 OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Sensor').getRecordTypeId()
                 OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('RTLS').getRecordTypeId()
                  OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Mounting Hardware').getRecordTypeId())]; //View Display and View Sense 19-Mar
        
    }
    
    @AuraEnabled
    public static issueWrapper fetchopenCSSissuesForCHW( string caseid){
        List<Issue__c> issLst = [SELECT id,Replaced_SWC__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Asset__c,Want_to_Order_Existing_Makeup__c,Case__r.Accountid,Shipping_Container__c,Shipping_Instructions__c,Product_SKU__c,In_Approval__c,Name,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                 Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                 Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                 Shipping_Contact_Name__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r), Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                                 Height_in__c,Base_in__c,IGU_ID_Provided__c,Lite_ID_Mock_ID__c,toLabel(RecordType.Name),Failure_Component__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c
                                 FROM Issue__c  where Case__c=:caseid and (issue_status__c='Open') AND
                                 ( Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId()
                                  OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Control Panel').getRecordTypeId()
                                  OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Controller & User Interface').getRecordTypeId()
                                  OR  Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Network').getRecordTypeId()
                                  OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Sensor').getRecordTypeId() 
                                  OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('RTLS').getRecordTypeId() 
                                  OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Mounting Hardware').getRecordTypeId())]; //View Display and View Sense 19-Mar
        issueWrapper wrapper = new issueWrapper();
        for(Issue__c iss:issLst){
            issueWithFailures wrap = new issueWithFailures();
            wrap.issueRec = iss;
            wrap.newMakeUpname = iss.Product__r.Name;
            for(Issue_Failure_Mode__c dr:iss.Defect_Root_Causes__r){
                wrap.selectedFailures.add(dr.Failure_Mode__c);
                wrap.selectedFailuresNames.add(dr.Failure_Mode__r.Name);
            }
            wrapper.chwIssueLst.add(wrap);
        }
        return  wrapper;
        
        
    }
    
    @AuraEnabled
    public static issueWrapper fetchlatestRecsfromissue( string issueliststring){
        List<Issue__c> issues=New List<Issue__c>();
        Set<Id> issueIds = new Set<Id>();
        system.debug('==issueliststring=='+issueliststring);
        List<Issue__c> issueRecs=(List<Issue__c>)JSON.deserialize(issueliststring, List<Issue__c>.class);
        system.debug('==issueRecs=='+issueRecs);
        for(issue__c eachIssue : issueRecs) {
            issueIds.add(eachIssue.Id);
        }
        system.debug('==issueIds=='+issueIds);
        issues= [SELECT id,Name,Replaced_SWC__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Asset__c,Want_to_Order_Existing_Makeup__c,Shipping_Container__c,Shipping_Instructions__c,Product_SKU__c,In_Approval__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                 Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                 Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                 Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                 Height_in__c,Base_in__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,Lite_ID_Mock_ID__c,RecordType.Name,Failure_Component__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c
                 FROM Issue__c  where id=:issueids order by Name ASC];
        
        issueWrapper wrapper = new issueWrapper();
        for(Issue__c iss:issues){
            issueWithFailures wrap = new issueWithFailures();
            wrap.issueRec = iss;
            wrap.newMakeUpname = iss.Product__r.Name;
            wrap.prodDescription = iss.Existing_Makeup__r.Name;
            for(Issue_Failure_Mode__c dr:iss.Defect_Root_Causes__r){
                wrap.selectedFailures.add(dr.Failure_Mode__c);
                wrap.selectedFailuresNames.add(dr.Failure_Mode__r.Name);
                
            }
            if(iss.RecordType.Name == 'Cable' || iss.RecordType.Name == 'Control Panel' 
               || iss.RecordType.Name == 'Controller & User Interface' || iss.RecordType.Name == 'Network' 
               || iss.RecordType.Name == 'Sensor' || iss.RecordType.Name == 'RTLS' || iss.RecordType.Name == 'Mounting Hardware'){
                   wrapper.chwIssueLst.add(wrap);
               }//View Display and View Sense 3-Mar
            if(iss.RecordType.Name == 'IGU (Halos, IGU Defects)'){
                wrapper.issuesLst.add(wrap);
            }
            
        }
        return  wrapper;
        
    }
    @AuraEnabled
    public static list<issue__c> createcssIssue(String issueWrapperObjStr){
        system.debug('in createcssIssue'+issueWrapperObjStr);
        list<issue__c> issuestoinsert=New list<issue__c>();
        Response r = (Response)JSON.deserialize(issueWrapperObjStr, Response.class);
        system.debug('--response--'+r);
        system.debug('--response--'+r.logIssueCommonWrapper);
        if(r.listOfLogIssueWrappersCSS!=null && !r.listOfLogIssueWrappersCSS.isEmpty()){
            system.debug('--response--'+r.listOfLogIssueWrappersCSS.size());
            
            
            for(LogIssueWrapper iss:r.listOfLogIssueWrappersCSS){
                issue__c newIssue=new issue__c();
                newIssue.Start_Date__c=Date.today();
                newIssue.Case__c = r.logIssueCommonWrapper.recordCase.id;
                newIssue.RecordTypeId = iss.recordTypeId;
                newIssue.Failure_Component__c = iss.failureComponent;
                
                if(iss.spareparts==null)
                {
                    newIssue.Create_Box_Folder__c = False;
                }
                else{
                    newIssue.Create_Box_Folder__c= iss.Create_box_Folder;
                }
                if(iss.consumables == null)
                    newIssue.Consumables__c = false;
                else
                    newIssue.Consumables__c = iss.consumables;
                if(iss.spareparts==null)
                {
                    newIssue.Spare_parts__c = False;
                }
                else
                {
                    newIssue.Spare_parts__c = iss.spareparts;    
                }
                //newIssue.Product_Return__c = iss.rmaIs;
                newIssue.Ownership__c = iss.sel_Resp_Entity;
                newIssue.Opportunity__c=r.logIssueCommonWrapper.recordCase.Opportunity__c;
                newIssue.Customer_Account__c=r.logIssueCommonWrapper.recordCase.AccountId;
                newIssue.Shipping_Contact_Name__c = r.logIssueCommonWrapper.shipToContactname;
                newIssue.Shipping_Contact_Number__c=r.logIssueCommonWrapper.shipToContactPhone;
                newIssue.Shipping_Contact_Email__c=r.logIssueCommonWrapper.shipToContactEmail;
                newIssue.Customer_Contact__c = r.logIssueCommonWrapper.quoteToContactid;
                newIssue.Shipping_Street_1__c = r.logIssueCommonWrapper.Shipping_Street_1;
                newIssue.Shipping_Street_2__c = r.logIssueCommonWrapper.Shipping_Street_2;
                newIssue.Shipping_City__c = r.logIssueCommonWrapper.Shipping_City;
                newIssue.Shipping_State_Province__c = r.logIssueCommonWrapper.Shipping_State_Province;
                if (r.logIssueCommonWrapper.Shipping_Country != null)
                	newIssue.Shipping_Country__c = AddressUtils.getStandardName(r.logIssueCommonWrapper.Shipping_Country);
                newIssue.Shipping_Postal_Code__c = r.logIssueCommonWrapper.Shipping_Postal_Code;
                newIssue.Product__c = iss.productidcss;
                newIssue.Quantity__c = iss.prodQty;
                newIssue.Date_Identified__c = Date.today();
                newIssue.Requested_Delivery_Date__c = iss.requestedDate;
                newIssue.Product_Replacement__c = r.logIssueCommonWrapper.orderReplacement;
                newIssue.Product_Return__c = r.logIssueCommonWrapper.RMA ? r.logIssueCommonWrapper.RMA : iss.rmaIs; 
                //  newIssue.Product_Return__c = iss.rmaIs;
                newIssue.Replaced_SWC__c=iss.replacedSWC;
                newIssue.Lite_Damaged__c=iss.liteDamage;
                newIssue.Replaced_WC__c  = iss.replacedWC;
                newIssue.Visible_BB_Damage__c = iss.visibleDbDamage;
                newIssue.Replaced_IGU_Cable__c = iss.replacedIGU;
                newIssue.Reflection_Color_Observed__c = iss.Reflection_Color_Observed;
                newIssue.Reflection_Color_Degree__c = iss.Reflection_Color_Degree;
                newIssue.Work_Type__c='Troubleshooting';
                
                newIssue.From_approx_10ft_3_m__c = iss.inspected10ft;
                newIssue.Uniform_background_lighting_that_simulat__c = iss.backGrundLghtIGU;
                newIssue.Vertically_positioned_at_90_deg_viewing__c = iss.verticallyPositionedIGU;
                
                if(iss.reason_replacement != '') {
                    newIssue.Reason_for_Replacement__c = iss.reason_replacement;
                }
                issuestoinsert.add(newIssue);
            }
        }
        system.debug('--issuestoinsert-'+issuestoinsert);
        system.debug('--issuestoinsert size--'+issuestoinsert.size());
        list<issue__c> issuesinserted=New list<issue__c>();
        set<id> issueids=New set<id>();
        if(issuestoinsert.size()>0){
            IssueTriggerHelper.areIssuesCreatedFromLC = TRUE;
            //Try{
            insert issuestoinsert;
            //}Catch(Exception e){
            //system.debug('exception during insert-'+e.getMessage()); 
            // }
            IssueTriggerHelper.areIssuesCreatedFromLC = FALSE;
            for(issue__c is:issuestoinsert){
                issueids.add(is.Id);
            }
            integer index =0;
            List<Issue_Failure_Mode__c> listOfFailureModes = new List<Issue_Failure_Mode__c>();
            for(LogIssueWrapper iss:r.listOfLogIssueWrappersCSS){
                system.debug('');
                for(string fmid: iss.listOfSelectedFailureModes){
                    
                    listOfFailureModes.add( 
                        new Issue_Failure_Mode__c
                        ( 
                            Issue__c = issuestoinsert[index].Id, 
                            Failure_Mode__c = fmid,
                            Failure_Component__c=iss.failureComponent
                        )
                    );
                    issueids.add(issuestoinsert[index].Id);
                }
                index++;
            }
            
            
            if(listOfFailureModes.size()>0){
                system.debug('--listOfFailureModes.size()--'+listOfFailureModes.size());
                Database.insert( listOfFailureModes, false );
                
            }
            
            
            issuesinserted=[SELECT id,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Name,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Asset__c,Want_to_Order_Existing_Makeup__c,Shipping_Container__c,Shipping_Instructions__c,Product_SKU__c,In_Approval__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                            Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                            Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                            Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                            Height_in__c,Base_in__c,IGU_ID_Provided__c,Lite_ID_Mock_ID__c,toLabel(RecordType.Name),Failure_Component__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c
                            FROM Issue__c  where id=:issueids];
            system.debug('--issueids---'+issueids);
            
            return issuesinserted;
        }
        return null;
    }
    

     @AuraEnabled
    public static submitResponseWrap submitIssuesForApprovalAndOrder2 (string issueRecsstr, String caseId,boolean isSetIGU){
        Set<Id> issueIds = new Set<Id>();
        list<Id> lstissueIds = new list<Id>();
        Id caseids;
        //try {
        system.debug('==issueRecsstr=='+issueRecsstr);
        // List<Issue__c> issueRecs=new List<Issue__c>();
        List<Issue__c> issueRecs=(List<Issue__c>)JSON.deserialize(issueRecsstr, List<Issue__c>.class);
        // List<issueandFMwrapper> issueRecss=(List<issueandFMwrapper>)JSON.deserialize(issueRecsstr, List<issueandFMwrapper>.class);
        system.debug('==issueRecs=='+issueRecs);
        //  system.debug('==issueRecs=='+issueRecss);
        system.debug('==issueRecs=='+issueRecs.size());
        if(issueRecs.size()>0){
            IssueTriggerHelper.areIssuesCreatedFromLC = True;
            update issueRecs;
            IssueTriggerHelper.areIssuesCreatedFromLC = false;
        }        
        for(issue__c eachIssue : issueRecs) {
            issueIds.add(eachIssue.Id);
            lstissueIds.add(eachIssue.Id);
            caseids=eachIssue.Case__c;
        }
        
        if(issueIds.size() > 0) {
            issueRecs = [SELECT Id,Shipping_Country__c,Trunk__c,Case__r.Accountid, RecordTypeId,Issue_Status__c, Name, Product__c, Product__r.Family, Warranty_Type__c FROM issue__c WHERE Id IN :issueIds];
        }
        system.debug('issueIds:'+issueIds);//View Display and View Sense 3-Mar
        Set<Id> cssRecordIs = new Set<Id>{Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId(),
            Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Sensor').getRecordTypeId(),
            Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('RTLS').getRecordTypeId(),
            Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Mounting Hardware').getRecordTypeId(),
            Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Connector').getRecordTypeId()};
                Set<Id> iguRecordIs = new Set<Id>{Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId()};
                    List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        for(issue__c eachIssue : issueRecs) {
            system.debug('eachIssue.Trunk__c'+eachIssue.Trunk__c+'eachIssue.Shipping_Country__c'+eachIssue.Shipping_Country__c+'eachIssue.Case__r.Accountid'+eachIssue.Case__r.Accountid);
            
                Approval.ProcessSubmitRequest apprReq =  new Approval.ProcessSubmitRequest();
            apprReq.setObjectId(eachIssue.id);
            apprReq.setSubmitterId(Userinfo.getUserId()); 
            apprReq.setSkipEntryCriteria(true);
            apprReq.setComments( system.label.Approval_Comments_from_LC );
            
            system.debug('apprReq--'+apprReq);
            requests.add( apprReq );
            system.debug('requests--'+requests);
            
        }
        
            Approval.ProcessResult[] processResults = Approval.process( requests, false );
            System.debug( 'processResults:-\n' + JSON.serialize( processResults ) );
        Boolean aprRes = true;
        for(Approval.ProcessResult p:processResults){
            submitResponseWrap resWrap = (submitResponseWrap) JSON.deserialize(JSON.serialize(p), submitResponseWrap.class);
            if(!resWrap.success){
                aprRes = resWrap.success;
            }
        }
        createProductRequests( caseids );
        List<Issue__c> updatedIssues = [SELECT id,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Asset__c,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Case__r.Accountid,Shipping_Container__c,Shipping_Instructions__c,Product_SKU__c,Name,In_Approval__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                        Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                        Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                        Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                                        Height_in__c,Base_in__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,Lite_ID_Mock_ID__c,RecordType.Name,Failure_Component__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Reverse_Shipment_Info__c,FA_Status__c
                                        FROM Issue__c  where id=:issueIds];
        submitResponseWrap wrapper = new submitResponseWrap();
        wrapper.success = aprRes;
        wrapper.updatedList = updatedIssues;
        return wrapper;
        //return updatedIssues;
          /*  }
        catch ( Exception e ) {
           throw new AuraHandledException(e.getMessage());

            
        }*/
    }
    
    @AuraEnabled
    public static submitResponseWrap submitIssuesForApprovalAndOrder(string issueRecsstr, String caseId,List<Issue__c> issueLst, string selectedModeMap,string issueCommonHeader){
        Set<Id> issueIds = new Set<Id>();
        list<Id> lstissueIds = new list<Id>();
        
        
        system.debug('selectedModeMap'+selectedModeMap);
        Id caseids;
        if(selectedModeMap!=null)
        {
        updateIssueWithModes(issueLst,selectedModeMap);
        }
        //try {
        system.debug('==issueRecsstr=='+issueRecsstr);
        // List<Issue__c> issueRecs=new List<Issue__c>();
        List<Issue__c> issueRecs=(List<Issue__c>)JSON.deserialize(issueRecsstr, List<Issue__c>.class);
        
        // BM
       // System.debug(' Common Case Info before '+issueCommonHeader);
        LogIssueCommonWrapper caseCommon = (LogIssueCommonWrapper)JSON.deserialize(issueCommonHeader, LogIssueCommonWrapper.class);
        System.debug(' Common Case Info after '+caseCommon);
        List<Issue__c> updateIssueShippingAddress = new List<Issue__c>();
        
        // List<issueandFMwrapper> issueRecss=(List<issueandFMwrapper>)JSON.deserialize(issueRecsstr, List<issueandFMwrapper>.class);
        system.debug('==issueRecs=='+issueRecs);
        //  system.debug('==issueRecs=='+issueRecss);
        system.debug('==issueRecs=='+issueRecs.size());
        if(issueRecs.size()>0){
            IssueTriggerHelper.areIssuesCreatedFromLC = True;
            update issueRecs;
            IssueTriggerHelper.areIssuesCreatedFromLC = false;
        }        
        for(issue__c eachIssue : issueRecs) {
            issueIds.add(eachIssue.Id);
            lstissueIds.add(eachIssue.Id);
            caseids=eachIssue.Case__c;
            System.debug('--caseids-- '+caseids);
            // Update shipping address on Issue with Case.Account.ShippingAddress
           eachIssue.Shipping_Street_1__c = caseCommon.Shipping_Street_1;
                            //eachIssue.Shipping_Street_2__c = caseCommon[0].Shipping_Street_2;
            eachIssue.Shipping_City__c = caseCommon.Shipping_City;
            eachIssue.Shipping_State_Province__c = caseCommon.Shipping_State_Province;
            eachIssue.Shipping_Postal_Code__c = caseCommon.Shipping_Postal_Code;
            
            if (caseCommon.Shipping_Country != null) 
            	eachIssue.Shipping_Country__c = AddressUtils.getStandardName(caseCommon.Shipping_Country);
           updateIssueShippingAddress.add(eachIssue);
            
        }
            system.debug('Issues Each '+updateIssueShippingAddress);
        
        // BM
        if(!updateIssueShippingAddress.isEmpty())
            UPDATE updateIssueShippingAddress;  
        
        // BM End of Shipping address
        
        if(issueIds.size() > 0) {
            issueRecs = [SELECT Id,Shipping_Country__c,Trunk__c,Case__r.Accountid, RecordTypeId,Issue_Status__c, Name, Product__c, Product__r.Family, Warranty_Type__c FROM issue__c WHERE Id IN :issueIds];
        }
        system.debug('issueIds:'+issueIds);
        //View Display and View Sense 3-Mar
        Set<Id> cssRecordIs = new Set<Id>{Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId(),
            Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Sensor').getRecordTypeId(),
            Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('RTLS').getRecordTypeId(),
            Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Mounting Hardware').getRecordTypeId(),
            Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Connector').getRecordTypeId()};
                Set<Id> iguRecordIs = new Set<Id>{Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId()};
                    List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        for(issue__c eachIssue : issueRecs) {
            system.debug('eachIssue.Trunk__c'+eachIssue.Trunk__c+'eachIssue.Shipping_Country__c'+eachIssue.Shipping_Country__c+'eachIssue.Case__r.Accountid'+eachIssue.Case__r.Accountid);
            
                Approval.ProcessSubmitRequest apprReq =  new Approval.ProcessSubmitRequest();
            apprReq.setObjectId(eachIssue.id);
            apprReq.setSubmitterId(Userinfo.getUserId()); 
            apprReq.setSkipEntryCriteria(true);
            apprReq.setComments( system.label.Approval_Comments_from_LC );
            
            system.debug('apprReq--'+apprReq);
            requests.add( apprReq );
            system.debug('requests--'+requests);
            
        }
        
            Approval.ProcessResult[] processResults = Approval.process( requests, false );
            System.debug( 'processResults:-\n' + JSON.serialize( processResults ) );
        Boolean aprRes = true;
        for(Approval.ProcessResult p:processResults){
            submitResponseWrap resWrap = (submitResponseWrap) JSON.deserialize(JSON.serialize(p), submitResponseWrap.class);
            if(!resWrap.success){
                aprRes = resWrap.success;
            }
        }
        //createProductRequests( caseids );
        createProductRequests( caseId );
        
        List<Issue__c> updatedIssues = [SELECT id,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Asset__c,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Case__r.Accountid,Shipping_Container__c,Shipping_Instructions__c,Product_SKU__c,Name,In_Approval__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                        Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                        Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                        Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                                        Height_in__c,Base_in__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,Lite_ID_Mock_ID__c,RecordType.Name,Failure_Component__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c
                                        FROM Issue__c  where id=:issueIds];
        submitResponseWrap wrapper = new submitResponseWrap();
        wrapper.success = aprRes;
        wrapper.updatedList = updatedIssues;
        
        
        
        return wrapper;
        //return updatedIssues;
          /*  }
        catch ( Exception e ) {
           throw new AuraHandledException(e.getMessage());

            
        }*/
    }
    @Future( callout = true )
    public static void createProductRequests( Id caseId ) {
        
        List<Issue__c> listOfIssuesForProductRequests = GenerateProductReqController.getIssues( caseId );
        System.debug( 'createProductRequests-listOfIssuesForProductRequests:-\n' + JSON.serialize( listOfIssuesForProductRequests ) );
        GenerateProductReqController.ResultWrapper resultWrapper = GenerateProductReqController.createProductRequestandLines( listOfIssuesForProductRequests, caseId );
        System.debug( 'createProductRequests-resultWrapper:-\n' + JSON.serialize( resultWrapper ) );
    }
    
    @AuraEnabled
    public static List<Issue__c> getprocessStatus(list<Id> issueidslist){
        set<Id> issueids=New set<Id>();
        issueids.addall(issueidslist);
        List<Issue__c> issuelist=New List<Issue__c>();
        issuelist= [Select Id, Name,Issue_Status__c,Product__r.Name,Lite_ID_Mock_ID__c,Quantity__c,
                    Requested_Delivery_Date__c,Reason_for_Replacement__c,BOX_Folder_Id__c,
                    Existing_Makeup__r.Name,(select Failure_Mode__r.Name from Defect_Root_Causes__r) 
                    From Issue__c where Id IN:issueids FOR UPDATE];
        return issuelist;
        
    }
    @AuraEnabled
    public static List<RecordType> getCSSRecordTypes(){
        //View Display and View Sense 3-Mar
        List<String> cssRecTypeNames = new List<String>{'Cable', 'Connector', 'Control Panel', 'Sensor','RTLS', 'Controller & User Interface', 'Network' , 'Mounting Hardware'};
            
            List<RecordType> cSSIssueRecTypes = [SELECT Id, Name from RecordType WHERE sObjectType='issue__c' AND isActive=True AND Name IN :cssRecTypeNames];
        
        return cSSIssueRecTypes;
        
    }
    
    @AuraEnabled
    public static List<String>  dogetFailureComponents(String recTypeNameIs){
        List<String> valuesAre = new List<String>();
        for(Failure_Components__mdt failureCompRecs: [SELECT Id, Failure_Component_Name__c FROM
                                                      Failure_Components__mdt WHERE Record_Type_Name__c = :recTypeNameIs]){
                                                          
                                                          valuesAre.add(failureCompRecs.Failure_Component_Name__c);
                                                      }
        
        
        
        
        return  valuesAre;
    }
    
    @AuraEnabled
    public static string  getFailureComponents(String issueWrapperObjStr){
        system.debug('==issueWrapperObjStr=='+issueWrapperObjStr);
        list<LogIssueWrapper> issueWrapperObjlist = (list<LogIssueWrapper>)JSON.deserialize(issueWrapperObjStr, list<LogIssueWrapper>.class);
        system.debug('==issueWrapperObjlist=='+issueWrapperObjlist);
        //LogIssueWrapper issueWrapperObjlist = (LogIssueWrapper)JSON.deserialize(issueWrapperObjStr, LogIssueWrapper.class);
        // Response response = new Response();
        // response.listOfLogIssueWrappersCSS=issueWrapperObjlist;
        List<RecordType> rtypes = [select id,name from recordtype where SobjectType='Issue__c' and IsActive=True];
        map<id,string> recordtypemap=New map<id,string>();
        for(RecordType rt: rtypes){
            recordtypemap.put(rt.id,rt.name);
        }
        system.debug('--recordtypemap--'+recordtypemap);
        for(LogIssueWrapper wrap:issueWrapperObjlist){
            system.debug('in loop');
            if( wrap.recordTypeId != '' && recordtypemap.containskey(wrap.recordTypeId)) {
                system.debug('in loop 2'+recordtypemap.get(wrap.recordTypeId));
                wrap.failureComponentOpts=new list<string>();
                for(Failure_Components__mdt failureCompRecs: [SELECT Id, Failure_Component_Name__c FROM
                                                              Failure_Components__mdt WHERE Record_Type_Name__c = :recordtypemap.get(wrap.recordTypeId)]){
                                                                  system.debug('in loop Failure_Component_Name__c-----'+failureCompRecs.Failure_Component_Name__c);
                                                                  
                                                                  wrap.failureComponentOpts.add(failureCompRecs.Failure_Component_Name__c);
                                                              }
            } 
        }
        
        system.debug('--issueWrapperObjlist--'+issueWrapperObjlist);
        return   JSON.serialize(issueWrapperObjlist)  ;
    }
    @AuraEnabled
    public static logIssueCommonWrapper populateQuoteToContact(String issueWrapperObjStr, String contactId){
        logIssueCommonWrapper issueWrapperObj = (logIssueCommonWrapper)JSON.deserialize(issueWrapperObjStr, logIssueCommonWrapper.class);
        if(contactId != NULL & contactId != '') {
            Contact contactRec = [SELECT Id, Name, Phone, MobilePhone, Email FROM Contact WHERE Id = :contactId];
            
            issueWrapperObj.quoteToContactid = contactRec.Id;
            issueWrapperObj.quoteToContactname = contactRec.name;
            if(contactRec.phone != NULL) {
                issueWrapperObj.quoteToContactPhone = contactRec.phone;
            } else {
                issueWrapperObj.quoteToContactPhone = contactRec.MobilePhone;
            }
            issueWrapperObj.quoteToContactEmail = contactRec.email;
        }
        return issueWrapperObj;
    }
    public class issueandFMwrapper{
        public Issue__c issuerec{get;set;}
        public list<failuremodeswrap> LineItemList {get;set;}
        
        public issueandFMwrapper(Issue__c issuerec){
            this.issuerec=issuerec;
            this.LineItemList =new List<failuremodeswrap>();
        }
        
    }
    public class failuremodeswrap
    {
        public Issue_Failure_Mode__c Field1 {get; set;}
        
        public failuremodeswrap (Issue_Failure_Mode__c f1)
        {
            Field1 = f1;
            
        }
    }
    
    @AuraEnabled
    public static list<Issue__c> resolveIssuesLCForIGU( string caseid){
        system.debug('---caseid---'+caseid);
        
        List<Issue__c> issueList = new List<Issue__c>();
        
        List<Issue__c> issueData = [SELECT id,Asset__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Case__r.Accountid,Product_SKU__c,In_Approval__c,Shipping_Container__c,Shipping_Instructions__c,Name,RecordType.Name,Consumables__c,Spare_Parts__c,Product_Return__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                    Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                    Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                    Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                                    Height_in__c,Base_in__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,RMA_FA_Status__c,Lite_ID_Mock_ID__c,LiteID__c,BOX_Folder_Id__c,Reverse_Shipment_Info__c,FA_Status__c
                                    FROM Issue__c  where Case__c=:caseid and issue_status__c IN ('Open','Order Processing','Order Shipped','Replacement Rejected') AND
                                    Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId()];
        
        system.debug('---issueDATA---'+issueData.size()+'===='+issueData);
        
        for(Issue__c iss : issueData){
            system.debug('---issueDATA---'+iss.Issue_Status__c);
            //&& (iss.Product_Return__c == true && iss.Product_Replacement__c == false) || (iss.RecordType.Name == 'IGU (Halos, IGU Defects)'
            if((iss.Issue_Status__c == 'Open' ) 
               || iss.Issue_Status__c == 'Order Shipped'|| iss.Issue_Status__c == 'Replacement Rejected' ){
                   issueList.add(iss);                
               }
        }
        system.debug('--issueList---'+issueList);
        return issueList;
        
    }
    
    @AuraEnabled
    public static list<Issue__c> resolveIssuesLCForCSS( string caseid){
        system.debug('ssss'+caseid);
        List<Issue__c> issueList = new List<Issue__c>();
        List<Issue__c> issueData =  [SELECT id,Name,Asset__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Shipping_Container__c,Shipping_Instructions__c,Product_SKU__c,In_Approval__c,Recordtype.Name,Consumables__c,Spare_Parts__c,Order_Entry_Release__R.Status__c,Product_Return__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                     Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                     Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                     Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                                     Height_in__c,Base_in__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,RMA_FA_Status__c,Lite_ID_Mock_ID__c,BOX_Folder_Id__c,Reverse_Shipment_Info__c,FA_Status__c
                                     FROM Issue__c  where Case__c=:caseid and issue_status__c IN ('Open','Order Processing','Order Shipped','Order Shipped','Replacement Rejected')
                                     AND
                                     ( Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Cable').getRecordTypeId()
                                      OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Control Panel').getRecordTypeId()
                                      OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Controller & User Interface').getRecordTypeId()
                                      OR  Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Network').getRecordTypeId()
                                      OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Sensor').getRecordTypeId()
                                      OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('RTLS').getRecordTypeId()
                                      OR Recordtypeid =:Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('Mounting Hardware').getRecordTypeId())]; //View Display and View Sense 3-Mar
        
        system.debug('issueData'+issueData);
        for(Issue__c iss : issueData){
            system.debug('iss.Issue_Status__c '+iss.Issue_Status__c +'ids'+iss.id);
            // && (iss.Product_Return__c==True  && iss.Product_Replacement__c==False)
            if((iss.Issue_Status__c == 'Open') 
                || iss.Issue_Status__c == 'Order Shipped' || iss.Issue_Status__c == 'Replacement Rejected'){
                   issueList.add(iss);                
               }
        }
        system.debug('issueList'+issueList);
        return issueList;//;
    }
    
    @AuraEnabled
    public static issueWrapper saveissues(List<Issue__c> issuesList){
      system.debug('saveissues'+issuesList);  
        list<id> issid = new list<id>();
        try{
            update issuesList;
           issueWrapper wrapper = new issueWrapper();
        for(Issue__c iss:issuesList){
            
            
           issid.add(iss.id); 
            
        }
            List<Issue__c> issueLst1 = [SELECT id,Asset__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Case__r.Accountid,Product_SKU__c,In_Approval__c,RecordType.Name,Name,Consumables__c,Spare_Parts__c,Product_Return__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                   Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                   Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                   Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,Shipping_Instructions__c,Shipping_Container__c,
                                   Height_in__c,Base_in__c,(select Id,Failure_Mode__c,Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,Lite_ID_Mock_ID__c,BOX_Folder_Id__c,Reverse_Shipment_Info__c,FA_Status__c
                                   FROM Issue__c  where id=:issid];
        
           for(Issue__c iss:issueLst1){
            
            issueWithFailures wrap = new issueWithFailures();
            wrap.issueRec = iss;
            wrap.newMakeUpname = iss.Product__r.Name;
            wrap.prodDescription = iss.Product__r.Name == null ? '' : iss.Product__r.Name;
            for(Issue_Failure_Mode__c dr:iss.Defect_Root_Causes__r){
                wrap.selectedFailures.add(dr.Failure_Mode__c);
                wrap.selectedFailuresNames.add(dr.Failure_Mode__r.Name);
            }
            wrapper.issuesLst.add(wrap);
        }
        return  wrapper;
        
        }
        catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            system.debug('line e1361');
            throw new AuraHandledException( e.getMessage());    
        }
    }
    public class issueWrapper{
        @AuraEnabled public case caseRec;
        @AuraEnabled public List<issueWithFailures> issuesLst;
        @AuraEnabled public List<issueWithFailures> chwIssueLst;
        @AuraEnabled public List<String> IGUReasonsForReplacement;
        public issueWrapper(){
            issuesLst = new List<issueWithFailures>();
            chwIssueLst = new List<issueWithFailures>();
            IGUReasonsForReplacement = new List<String>();
            
        }
        
    }
    
    public class issueWithFailures{
        
        @AuraEnabled public Issue__c issueRec;
        @AuraEnabled public Boolean selected;
        @AuraEnabled public string prodDescription;
        @AuraEnabled public string wantToOrderExisting;
        @AuraEnabled public string newMarkUp;
        @AuraEnabled public string newMakeUpname;
        @AuraEnabled public string newMakeUpProduct_SKU;
        @AuraEnabled public string newMakeUpProductCode;
        @AuraEnabled public string FMDetails;
        @AuraEnabled public List<String> selectedFailures;
        @AuraEnabled public List<String> selectedFailuresNames;
        @AuraEnabled public Map<string,List<String>> updateSfmMap;
        @AuraEnabled public Boolean provideFMDetails;
        public issueWithFailures(){
            selectedFailures = new List<String>();
            selectedFailuresNames = new List<String>();
            selected = false;
            provideFMDetails = false;
            updateSfmMap = new Map<string,List<string>>();
            updateSfmMap.put('Non-Tinting - Intermittent Tinting',new List<string>{'Replaced_SWC__c','Replaced_WC__c','Replaced_IGU_Cable__c'});
            updateSfmMap.put('Non-Tinting',new List<string>{'Replaced_SWC__c','Replaced_WC__c','Replaced_IGU_Cable__c'});
            updateSfmMap.put('Obstruction in Field of View - Spontaneous Breakage',new List<string>{'Lite_Damaged__c'});
            updateSfmMap.put('OOS Scratches - S1/S4',new List<string>{'From_approx_10ft_3_m__c','Uniform_background_lighting_that_simulat__c','Vertically_positioned_at_90_deg_viewing__c'});
            updateSfmMap.put('OOS Scratches - S3 / Other',new List<string>{'From_approx_10ft_3_m__c','Uniform_background_lighting_that_simulat__c','Vertically_positioned_at_90_deg_viewing__c'});
            updateSfmMap.put('Non-Uniformity - Within Lite',new List<string>{'Visible_BB_Damage__c'});
            updateSfmMap.put('Non-Uniformity - L2L',new List<string>{'Visible_BB_Damage__c'});
        }
    }
    public class submitResponseWrap{
        @AuraEnabled public Boolean success;
        @AuraEnabled public List<Issue__c> updatedList;
        public submitResponseWrap(){
            updatedList = new List<Issue__c>();
        }
    }
    
    public class failureMap{
        public String key;
        public List<String> value;
    }
    
    @AuraEnabled
    public static List<Issue__c> updateIssueWithModes(List<Issue__c> issueLst, string selectedModeMap){
        List<Issue__c> updatedIssues = New List<Issue__c>();
        system.debug('selectedModeMap'+selectedModeMap);
        Set<String> modestoDelete = new Set<String>();
        Set<String> issIds = new Set<String>();
        Map<String,Set<String>> failureMap = new Map<String,Set<String>>();
       system.debug('issueLstissueLst'+issueLst); 
        List<failureMap> failMap = (List<failureMap>) JSON.deserialize(selectedModeMap, List<failureMap>.class);
        system.debug('----failMap'+failMap);
        if(issueLst.size()>0){
            
            for(Issue__c is:issueLst){
                issIds.add(is.Id);
                modestoDelete.add(is.Id);
            }
            List<Issue_Failure_Mode__c> deletef = new List<Issue_Failure_Mode__c>();
            List<Issue_Failure_Mode__c> failMode = [SELECT Id,Issue__c,Failure_Mode__c FROM Issue_Failure_Mode__c WHERE Issue__c in:issIds];
          system.debug('failMode----'+failMode);
            for(Issue_Failure_Mode__c f:failMode){
                if(failureMap.containsKey(f.Issue__c)){
                    Set<String> mLst = failureMap.get(f.Issue__c);
                    mLst.add(f.Failure_Mode__c);
                    failureMap.put(f.Issue__c,mLst);
                }else{
                    failureMap.put(f.Issue__c,new Set<String>{f.Failure_Mode__c});
                }
                system.debug('====failureMap'+failureMap);
                for(failureMap fm:failMap){
                    if(fm.key == f.Issue__c){
                        Set<String> deleteFM = new Set<String>();
                        deleteFM.addAll(fm.value);
                        if(!deleteFM.contains(f.Failure_Mode__c)){
                            deletef.add(f);
                        }
                    }
                    
                }
            }
            if(deletef.size()>0){
                delete deletef;
            }
            IssueTriggerHelper.areIssuesCreatedFromLC = True;
            system.debug('issueLstissueLst'+issueLst);
            update issueLst;  
            IssueTriggerHelper.areIssuesCreatedFromLC = false;
        }
       List<Issue_Failure_Mode__c> modesLst = new List<Issue_Failure_Mode__c>();
        for(failureMap fm:failMap){
            if(failureMap.containsKey(fm.key)){
                Set<String> selectedFailSet = new Set<String>();
                selectedFailSet.addAll(fm.value);
                for(string s:fm.value){
                    if(!failureMap.get(fm.key).contains(s)){
                        Issue_Failure_Mode__c m = new Issue_Failure_Mode__c();
                        m.Issue__c =fm.key;
                        m.Failure_Mode__c = s;
                       modesLst.add(m); 
                    }
                }
               
                
            }else{
                for(string s:fm.value){
                    Issue_Failure_Mode__c m = new Issue_Failure_Mode__c();
                    m.Issue__c =fm.key;
                    m.Failure_Mode__c = s;
                    modesLst.add(m); 
                } 
            }
        }
        if(modesLst.size()>0){
            insert modesLst;
        }
        /*if(modeLstToDelteMap.size()>0){
            List<Issue_Failure_Mode__c> ddelte = [SELECT Id,Failure_Mode__c,Issue__c FROM Issue_Failure_Mode__c WHERE Issue__c IN:modeLstToDelteMap.KeySet() AND  Failure_Mode__c IN:modeLstToDelteMap.values()];
            if(ddelte.size()>0){
              delete ddelte;  
            }
        }*/
        updatedIssues= [SELECT id,Name,Asset__c,From_approx_10ft_3_m__c,Uniform_background_lighting_that_simulat__c,Vertically_positioned_at_90_deg_viewing__c,Visible_BB_Damage__c,Replaced_SWC__c,Replaced_WC__c,Replaced_IGU_Cable__c,Lite_Damaged__c,Want_to_Order_Existing_Makeup__c,Shipping_Container__c,Shipping_Instructions__c,Product_SKU__c,In_Approval__c,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                        Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                        Shipping_Street_3__c,Existing_Makeup__c, Existing_Makeup__r.Name,Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                        Shipping_Contact_Name__c, Shipping_Contact_Number__c,Shipping_Contact_Email__c,Customer_Contact__c,Create_Box_Folder__c,Ownership__c,Mark_ID__c,Reason_for_Replacement__c,
                        Height_in__c,Base_in__c,(select Failure_Mode__r.Name from Defect_Root_Causes__r),IGU_ID_Provided__c,Lite_ID_Mock_ID__c,RecordType.Name,Failure_Component__c,BOX_Folder_Id__c,Consumables__c,Spare_Parts__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c
                        FROM Issue__c  where id=:issIds];
        return updatedIssues;
        
    }
    
    @AuraEnabled
    public static string isproductactive(string product)
    {

        String active;
        try{
        system.debug('product'+product+'active'+active);       
        Asset  ass  = [select id,name,Product2.IsActive from Asset where Name=:product];
        system.debug('ass.Product2.IsActive'+ass.Product2.IsActive);
        active = string.valueOf(ass.Product2.IsActive);

        system.debug('active'+active);
        }catch(exception e){}
        return active;
    }
    
    @AuraEnabled
    public static Issue__c getIssueInfo(string issId){
        return [SELECT Id,Issue_Status__c,Product_Replacement__c,Product_Return__c FROM Issue__c where id=:issId LIMIT 1];
    }
    @AuraEnabled
    public static list<Issue__c> fetchIssuesSubmittedForApproval( list<string> strJsonOfListOfApprovalIssues ) {
            
        System.debug( 'strJsonOfListOfApprovalIssues:-\n' + strJsonOfListOfApprovalIssues );
        List<Issue__c> submitesissues = New List<Issue__c>();
        
        
            try {
                system.debug('enetr 1461');
              //  response.listOfApprovalIssues = ( List<Issue__c> ) 
               //                                 JSON.deserialize( strJsonOfListOfApprovalIssues, List<Issue__c>.class );
              //  System.debug( 'before-response.listOfApprovalIssues:-\n' + JSON.serialize( response.listOfApprovalIssues ) );
             //   if( response.listOfApprovalIssues == NULL || response.listOfApprovalIssues.isEmpty() ) {
            //        response.setStatus( false, System.Label.Issues_Not_Submitted_For_Approval_Found_Try_Again );
            //    }
                submitesissues = [ SELECT ID, Name, Window_ID__c,case__r.account.Name,In_Approval__c, Control_Panel__c, Comments__c,
                                                  Start_Date__c, Case_Account_Name__c,End_Date__c, Issue_Status__c,
                                                  Work_Type__c, Failure_Component__c, RecordTypeId, Product__c,
                                                  Requested_Delivery_Date__c, RecordType.Name, Product__r.Name,
                                                  Warranty_Type__c,Product_Replacement__c,WC_ID__c,Dev__c,Product_Return__c,Reverse_Shipment_Info__c,FA_Status__c,RMA_FA_Status__c
                                                  FROM Issue__c
                                                  WHERE   ID IN : strJsonOfListOfApprovalIssues
                                                  FOR UPDATE
                                                ];
             //   system.debug('response.listOfApprovalIssues'+response.listOfApprovalIssues);
              
            }
            catch( Exception e ) {
                System.debug( 'Exception in fetchIssuesSubmittedForApproval:-\n' + e.getMessage() );
              //  response.setStatus( false, System.Label.Issues_Not_Submitted_For_Approval_Found + e.getMessage() );
            }
       
     //   System.debug( 'fetchIssuesSubmittedForApproval-response:-\n' + JSON.serialize( response ) );
        return submitesissues;
    }
    
}