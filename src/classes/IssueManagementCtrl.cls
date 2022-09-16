/*
    @ PURPOSE : 1. CONTROLS THE LIGHTNING COMPONENT => IssuesCreatedAndUpdate.xml
                2. PROVIDES SERVICE AND SAVES RESULTS INTO DB.
*/
public without sharing class IssueManagementCtrl {
    
    private static Set<String> setOfOpenIssueStatuses;
    private static Set<String> setOfSemiOpenIssueStatuses;
    
    private static final String GOOGLE_END_POINT_URL = 'https://maps.googleapis.com/maps/api/place';
    
    private static final String IGU_RECORD_TYPE_NAME = 'IGU (Halos, IGU Defects)';
    
    private static final Set<String> CLOSED_ISSUE_STATUSES = new Set<String>
                                                             {
                                                              'Resolved',
                                                              'Rejected',
                                                              'Canceled'
                                                             };
    
    private static final Integer SEARCH_RESULTS_LIMIT = 100;
    
    static {
            
        setOfOpenIssueStatuses = new Set<String>
                                 {
                                    'open'
                                 };
    }
    static {
            
        setOfSemiOpenIssueStatuses = new Set<String>
                                 {
                                    'Order Shipped','replacement rejected'
                                 };
    }
    
    public final static Set<String> CSS_RECORD_TYPES = new Set<String>
                                                       {
                                                        'cable', 'control panel',
                                                        'controller & user interface', 'network',
                                                        'sensor', 'connector'
                                                       };
                                                       
    public final static Set<String> PRODUCT_FAMILIES = new Set<String>{ 'CSS', 'IGU' };
    
    @AuraEnabled
    public static String getIssues( String strWorkOrderId ) {
        
        System.debug( 'getIssues-strWorkOrderId:-\n' + strWorkOrderId );
        
        Response response = new Response();
        if( String.isBlank( strWorkOrderId ) ) {
            response.setStatus( false, System.Label.Work_Order_Id_Not_Found);
        }
        else {
            response.setWorkOrder( strWorkOrderId );
            if( response.recordWorkOrder.Id == NULL ) {
                response.setStatus( false, System.Label.Work_Order_Id_Not_Found );
            }
            else {
                response.initializeStates();
                response.setListOfIssueAndPartWrappers();
                
                if( response.listOfIssueWrappers.isEmpty() && response.listOfIGUIssueWrappers.isEmpty() ) {
                    response.setStatus( false, System.Label.No_Issues_Are_Found );
                }
                else {
                    response.setStatus( true, 'Issues are fetched successfully.' );
                    if( response.listOfRecordTypes.isEmpty() ) {
                        response.setStatus( false, System.Label.Record_Types_Of_Issue_Are_Not_Found );
                    }
                }
            }
        }
        System.debug( 'getIssues-response:\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String getUpdatedIssuesOnly( String strWorkOrderId ) {
        
        System.debug( 'getUpdatedIssuesOnly-strWorkOrderId:-\n' + strWorkOrderId );
        
        Response response = new Response();
        if( String.isBlank( strWorkOrderId ) ) {
            response.setStatus( false, System.Label.Work_Order_Id_Not_Found );
        }
        else {
            response.setWorkOrder( strWorkOrderId );
            if( response.recordWorkOrder.Id == NULL ) {
                response.setStatus( false, System.Label.Work_Order_Not_Found );
            }
            else {
                response.setListOfIssueAndPartWrappers();
                response.setStatus( true, System.Label.Issues_Fetched_Successfully );
            }
        }
        System.debug( 'getUpdatedIssuesOnly-response:\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String searchContactRecords( String strSearchKeyword, String strOpportunityId, String strContactId ) {
        
        System.debug( 'searchContactRecords-strSearchKeyword:-\n' + strSearchKeyword );
        
        Response response = new Response();
        if( String.isBlank( strSearchKeyword ) ) {
            response.setStatus( false, System.Label.Search_Contact_Keyword_Missing );
        }
        else {
            strSearchKeyword = '%' + strSearchKeyword + '%';
            System.debug( 'After strSearchKeyword:-\n' + strSearchKeyword );
            
            try {
                response.listOfContactSearchedResults = searchContactFromOpportunityContactRoles( strSearchKeyword, strOpportunityId, strContactId );
                response.setStatus( !response.listOfContactSearchedResults.isEmpty(), '' );
            }
            catch( Exception e ) {
                System.debug( 'Exception in searchShipToContactRecords:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Error_Getting_Contacts + e.getMessage() );
            }
        }
        System.debug( 'searchContactRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String searchProductRecords( String searchKeyword, String opportunityPricebook2Id, String productFamily, String currencyIsoCode ) {
        
        System.debug( 'searchRecords-searchKeyword:-\n' + searchKeyword );
        System.debug( 'searchRecords-opportunityPricebook2Id:-\n' + opportunityPricebook2Id );
        
        Response response = new Response();
        if( String.isBlank( searchKeyword ) || String.isBlank( opportunityPricebook2Id ) || String.isBlank( productFamily ) ) {
            response.setStatus( false, System.Label.Search_Keyword_Missing );
        }
        else {
            searchKeyword = '%' + searchKeyword + '%';
            System.debug( 'After searchKeyword:-\n' + searchKeyword );
            
            try {
                List<Product2> listOfProducts = [ SELECT ID, Name, Product_SKU__c, ProductCode, Family, 
                                                  (
                                                   SELECT ID, UnitPrice
                                                   FROM PriceBookEntries
                                                   WHERE 
                                                   PriceBook2Id = :opportunityPricebook2Id
                                                    AND
                                                   CurrencyIsoCode =: currencyIsoCode
                                                    AND
                                                   IsActive = true
                                                   LIMIT 1
                                                  )
                                                  FROM Product2 
                                                  WHERE
                                                  IsActive = true
                                                    AND
                                                  Family = : productFamily
                                                    AND
                                                  (
                                                    Name LIKE : searchKeyword
                                                    OR
                                                    Product_SKU__c LIKE : searchKeyword
                                                    OR
                                                    ProductCode LIKE : searchKeyword
                                                    OR
                                                    Description LIKE : searchKeyword
                                                  )
                                                  ORDER BY Name LIMIT : SEARCH_RESULTS_LIMIT
                                                ];
                System.debug( 'searchProductRecords-listOfProducts:-\n' + JSON.serialize( listOfProducts ) );
                for( Product2 recordProduct : listOfProducts ) {
                    
                    if( !recordProduct.PriceBookEntries.isEmpty() ) {
                        Decimal listPrice;
                        if( !recordProduct.PriceBookEntries.isEmpty() ) {
                            listPrice = recordProduct.PriceBookEntries.get( 0 ).UnitPrice;
                        }
                        
                        String strListPrice;
                        if( listPrice != null ) {
                            strListPrice = currencyIsoCode + ' ' + listPrice.setScale( 2 );
                        }
                        
                        response.listOfSearchedResults.add
                                                       ( 
                                                        new SearchResultWrapper
                                                        (
                                                         recordProduct,
                                                         strListPrice                                                
                                                        )
                                                       );
                    }
                }
                if( response.listOfSearchedResults.isEmpty() ) {
                    response.setStatus( false, System.Label.Products_Not_Found );
                }
                else {
                    response.setStatus( true, '' );
                }
            }
            catch( Exception e ) {
                System.debug( 'Exception in searchProductRecords:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Error_Getting_Products + e.getMessage() );
            }
        }
        System.debug( 'searchRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
  
    @AuraEnabled  
    public static String searchDB(String searchText ){
                                      
                                      //searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
                                      String sText;
                                     // sText= searchText.replaceAll( '\\s+', '');                                    
                                     // searchText = '%' + sText + '%';                                      
                                      System.debug(' Search Text '+searchText);
        
                                      String productFamily ='CSS';
                                       searchText = '%' + searchText + '%';
            						  System.debug( 'After searchKeyword:-\n' + searchText );
                                                                              /*  
                                        String query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                                        ' FROM '+objectName+
                                        ' WHERE '+fld_API_Search+' LIKE '+searchText+
                                        ' LIMIT '+lim;
                                        */
        				Response response = new Response();
                    try
                    {
                        List<Product2> listOfProducts = [ SELECT ID, Name, Product_SKU__c, ProductCode, Family,Description, 
                                                         (SELECT ID, UnitPrice FROM PriceBookEntries WHERE PriceBook2Id != NULL AND  IsActive = true  LIMIT 1 ) 
                                                         FROM Product2  WHERE IsActive = true AND
                                                         Family = : productFamily
                                                         AND
                                                         (
                                                             Name LIKE : searchText
                                                             OR
                                                             Product_SKU__c LIKE : searchText
                                                             OR
                                                             ProductCode LIKE : searchText
                                                             OR
                                                             Description LIKE : searchText
                                                         ) AND 
                                                         Id IN (SELECT Product2Id FROM PricebookEntry)
                                                         ORDER BY Name LIMIT 100
                                                        ];
                        //  List<sObject> sobjList = Database.query(query); listOfSearchedResultsTrunk
                        // List<ResultWrapper> lstRet = new List<ResultWrapper>();
                        System.debug('@@@@@ PR List '+listOfProducts);
                        
                        for(Product2 pro : listOfProducts){
                            
                            response.listOfSearchedResultsTrunk.add( new SearchResultWrapper ( pro ) );
                            
                        }
                        
                        if( response.listOfSearchedResultsTrunk.isEmpty() ) {
                            response.setStatus( false, System.Label.Products_Not_Found );
                        }
                        else {
                            response.setStatus( true, '' );
                        }
                        
                    }
        catch( Exception e ) {
            System.debug( 'Exception in listOfSearchedResultsTrunk:-\n' + e.getMessage() );
            response.setStatus( false, System.Label.Error_Getting_Products + e.getMessage() );
        }
                                      
        
           return JSON.serialize(response);
                                  }
    
    
    @AuraEnabled
  public static String searchFailureModeRecords(String searchKeyword,String resonfail,String failureComponent,String jsonListOfFailureModeIDs  ) {
          
     System.debug( 'searchFailureModeRecords-searchKeyword:-\n' + searchKeyword );
        System.debug( 'searchFailureModeRecords-failureComponent:-\n' + failureComponent );
        System.debug( 'searchFailureModeRecords-jsonListOfFailureModeIDs:-\n' + jsonListOfFailureModeIDs );
      system.debug('resonfail'+resonfail);
        
        Response response = new Response();
        if( String.isBlank( failureComponent ) ) {
            response.setStatus( false, System.Label.Failure_Component_Missing );
        }
        else {
            try {
                List<String> listOfAlreadySelectedFailureModes = new List<String>();
                if( String.isNotBlank( jsonListOfFailureModeIDs ) ) {
                    try {
                        listOfAlreadySelectedFailureModes = ( List<String> ) JSON.deserialize( jsonListOfFailureModeIDs, List<String>.class );
                    }
                    catch( Exception e ) {
                        System.debug( 'Exception in searchFailureModeRecords:-\n' + e.getMessage() );
                    }
                }
                System.debug( 'searchFailureModeRecords-listOfAlreadySelectedFailureModes:-\n' + listOfAlreadySelectedFailureModes );
                
                response.listOfFailureModeWrappers = new List<FailureModeWrapper>();
                String strQuery = 'SELECT ID, Name, Failure_Component__c,' + 
                                  'In_Warranty__c, Ownership__c, Check_Entitlement__c,' +
                                  'Applicable_To__c, Check_Trade__c ' +
                                  'FROM Failure_Mode__c ' +
                                  'WHERE Failure_Component__c =: failureComponent ';
                
                /* this was commented on 22/7/2020 based on user feedback in future if failure modes need 
                 to display based on reason for replacement uncomment below code and kept it in above query */
                
             //   AND Reason_For_Replacement__c   includes (\''+resonfail+'\''
                
              // strQuery+= ')';
                if( String.isNotBlank( searchKeyword ) ) {
                    searchKeyword = '%' + searchKeyword + '%';
                    strQuery += ' AND Name LIKE : searchKeyword ';
                }
                strQuery += ' AND ( ID NOT IN : listOfAlreadySelectedFailureModes ) ORDER BY Name LIMIT : SEARCH_RESULTS_LIMIT';
                System.debug( 'strQuery:-\n' + strQuery );
                
                for( Failure_Mode__c fm : Database.query( strQuery ) ) {
                    response.listOfFailureModeWrappers.add( new FailureModeWrapper ( false, fm ) );
                }
                System.debug( 'searchFailureModeRecords-false:-\n' + JSON.serialize( response.listOfFailureModeWrappers ) );
                
                if( !listOfAlreadySelectedFailureModes.isEmpty() ) {
                    for( Failure_Mode__c fm : [ SELECT ID, Name, Failure_Component__c,
                                                In_Warranty__c, Ownership__c, Check_Entitlement__c,
                                                Applicable_To__c, Check_Trade__c
                                                FROM Failure_Mode__c 
                                                WHERE
                                                ID IN : listOfAlreadySelectedFailureModes
                                                ORDER BY Name LIMIT : SEARCH_RESULTS_LIMIT
                                              ]
                    ) {
                        response.listOfFailureModeWrappers.add( new FailureModeWrapper ( true, fm ) );
                    }
                }
                System.debug( 'searchFailureModeRecords-true:-\n' + JSON.serialize( response.listOfFailureModeWrappers ) );
                 if( response.listOfFailureModeWrappers.isEmpty() ) {
                    response.setStatus( false, System.Label.Failure_Modes_Not_Found );
                }
                else {
                    response.setStatus( true, '' );
                }
            }
            catch( Exception e ) {
                System.debug( 'Exception in searchFailureModeRecords:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Error_Getting_Failure_Modes + e.getMessage() );
            }
        }
        System.debug( 'searchFailureModeRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String searchTrunkRecords( String strSearchKeyword ) {
        
        System.debug( 'searchTrunkRecords-strSearchKeyword:-\n' + strSearchKeyword );
        
        Response response = new Response();
        if( String.isBlank( strSearchKeyword ) ) {
            response.setStatus( false, System.Label.Search_Trunk_Keyword_Missing );
        }
        else {
            strSearchKeyword = strSearchKeyword + '%';
            System.debug( 'After strSearchKeyword:-\n' + strSearchKeyword );
            
            try {
                response.listOfTrunkSearchResults = getListOfLocations( strSearchKeyword );
                response.setStatus( !response.listOfTrunkSearchResults.isEmpty(), '' );
            }
            catch( Exception e ) {
                System.debug( 'Exception in searchTrunkRecords:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Error_Occurred_Getting_Trunks + e.getMessage() );
            }
        }
        System.debug( 'searchTrunkRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String searchAssetRecords( String searchKeyword, String opportunityId ) {
        
        System.debug( 'searchAssetRecords-searchKeyword:-\n' + searchKeyword );
        
        Response response = new Response();
        if( String.isBlank( opportunityId ) ) {
            response.setStatus( false, System.Label.Opportunity_Id_Missing );
        }
        else {
            
            if( String.isBlank( searchKeyword ) ) {
                try {
                response.listOfAssetSearchedResults = [ SELECT ID, Name, Lite_Height__c, Lite_Width__c, H1__c, H1_B1_in__c, W1__c,
                                                        Lite_Id__c, SerialNumber, AssetShape__c, Mark_Id__c, Product2Id, Product2.Name,
                                                        ProductCode, ProductDescription, StockKeepingUnit
                                                        FROM Asset
                                                        WHERE
                                                        Opportunity__c =: opportunityId
                                                        ORDER BY SerialNumber 
                                                        LIMIT : SEARCH_RESULTS_LIMIT
                                                      ];
                    response.setStatus( !response.listOfAssetSearchedResults.isEmpty(), '' );
                }
                catch( Exception e ) {
                    System.debug( 'Exception in searchAssetRecords:-\n' + e.getMessage() );
                    response.setStatus( false, System.Label.Error_Getting_Assets + e.getMessage() );
                }
            }
            else{
                searchKeyword = '%' + searchKeyword + '%';
                System.debug( 'After searchKeyword:-\n' + searchKeyword ); 
                try {
                    response.listOfAssetSearchedResults = [ SELECT ID, Name, Lite_Height__c, Lite_Width__c, H1__c, H1_B1_in__c, W1__c,
                                                            Lite_Id__c, SerialNumber, AssetShape__c, Mark_Id__c, Product2Id, Product2.Name,
                                                            ProductCode, ProductDescription, StockKeepingUnit
                                                            FROM Asset
                                                            WHERE
                                                            Opportunity__c =: opportunityId
                                                            AND
                                                            ( 
                                                             SerialNumber LIKE : searchKeyword
                                                                OR
                                                             Lite_Id__c LIKE : searchKeyword
                                                                OR
                                                             StockKeepingUnit LIKE : searchKeyword
                                                                OR
                                                             Mark_Id__c LIKE : searchKeyword
                                                            )
                                                            ORDER BY SerialNumber 
                                                            LIMIT : SEARCH_RESULTS_LIMIT
                                                          ];
                
                    if( response.listOfAssetSearchedResults.isEmpty() ) {
                        response.setStatus( false, System.Label.Assets_Not_Found );
                    }
                    else {
                        response.setStatus( true, '' );
                    }
                }
                catch( Exception e ) {
                    System.debug( 'Exception in searchAssetRecords:-\n' + e.getMessage() );
                    response.setStatus( false, System.Label.Error_Getting_Assets + e.getMessage() );
                }
            }
        }
        System.debug( 'searchAssetRecords:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String updateIssues( String strWorkOrderId, String strJSONListOfIssuesWrappers ) {
        
        System.debug( 'updateIssues-strWorkOrderId:-\n' + strWorkOrderId );
        System.debug( 'updateIssues-strJSONListOfIssuesWrappers:-\n' + strJSONListOfIssuesWrappers );
        
        Response response = new Response();
        if( String.isBlank( strJSONListOfIssuesWrappers ) ) {
            response.setStatus( false, System.Label.Issues_Not_Found_For_Update );
        }
        else {
            try {
                response.listOfIssueWrappers = ( List<IssueManagementCtrlWrapper> ) 
                                                 JSON.deserialize( strJSONListOfIssuesWrappers, List<IssueManagementCtrlWrapper>.class );
            }
            catch( Exception e ) {
                System.debug( 'Exception in updateIssues conversion:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Invalid_Issues_Found_For_Update + e.getMessage() );
            }
            
            List<Issue__c> listOfIssues = getListOfIssues( response.listOfIssueWrappers );
            List<Issue_Failure_Mode__c> listOfIssueFailureModes = getListOfIssueFailureModes( response.listOfIssueWrappers );
            
            if( listOfIssues.isEmpty() ) {
                response.setStatus( false, System.Label.Issue_Not_Selected_For_Update );
            }
            else {
                try {
                    IssueTriggerHelper.areIssuesCreatedFromLC = TRUE;
                    UPDATE listOfIssues;
                    Database.insert( listOfIssueFailureModes, false );
                    response.setWorkOrder( strWorkOrderId );
                    if( response.recordWorkOrder.Id == NULL ) {
                        response.setStatus( false, System.Label.Work_Order_Not_Found );
                    }
                    else {
                        response.setListOfIssueAndPartWrappers();
                        if( listOfIssues.size() > 1 ) {
                            response.setStatus( true,   System.Label.Issues_Updated_Successfully );
                        }
                        else {
                            response.setStatus( true, System.Label.Issue_Updated_Successfully );
                        }
                    }
                }
                catch( Exception e ) {
                    System.debug( 'Exception in updateIssues:-\n' + e.getMessage() );
                    response.setStatus( false, System.Label.Error_Updating_Issues_Contact_System_Admin + e.getMessage() );
                }
                finally {
                    IssueTriggerHelper.areIssuesCreatedFromLC = FALSE;
                }
            }
        }
        System.debug( 'updateIssues-response:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String updatePartsRequested( String strWorkOrderId, String strJSONListOfPartsWrappers, Integer behaviorCode ) {
        
        System.debug( 'strWorkOrderId:-\n' + strWorkOrderId );
        System.debug( 'updatePartsRequested:-\n' + strJSONListOfPartsWrappers );
        System.debug( 'behaviorCode:-\n' + behaviorCode );
       // IssueTriggerHelper.partsFromTrunk = behaviorCode; // bm
        Response response = new Response();
        if( String.isBlank( strWorkOrderId ) ) {
            response.setStatus( false, System.Label.Work_Order_Not_Found );
        }
        else if( String.isBlank( strJSONListOfPartsWrappers ) ) {
            response.setStatus( false, System.Label.Part_Details_Not_Found_For_Request );
        }
        else {
            try {
                List<IssueManagementCtrlWrapper> listOfPartsWrappers;
                listOfPartsWrappers = ( List<IssueManagementCtrlWrapper> ) 
                                      JSON.deserialize( strJSONListOfPartsWrappers, List<IssueManagementCtrlWrapper>.class );
                
                if( listOfPartsWrappers == NULL || listOfPartsWrappers.isEmpty() ) {
                    response.setStatus( false, System.Label.Parts_Not_Requested_For_Update );
                }
                
                List<Issue__c> listOfPartsRequested = getListOfIssues( listOfPartsWrappers );
                List<Issue_Failure_Mode__c> listOfIssueFailureModes = getListOfIssueFailureModes( listOfPartsWrappers );
                
                IssueTriggerHelper.areIssuesCreatedFromLC = TRUE;
                UPDATE listOfPartsRequested;
                Database.insert( listOfIssueFailureModes, false );
                
                response.setWorkOrder( strWorkOrderId );
                response.setListOfIssueAndPartWrappers();
                
                if( listOfPartsRequested.size() > 1 ) {
                    if( behaviorCode == 1 ) {
                        response.setStatus( true, System.Label.Parts_Saved_Successfully );
                    }
                    else {
                        response.setStatus( true, System.Label.Parts_Submitted_For_Approval_Successfully );
                    }
                }
                else {
                    if( behaviorCode == 1 ) {
                        response.setStatus( true, System.Label.Part_Saved_Successfully );
                    }
                    else {
                        response.setStatus( true, System.Label.Part_Submitted_For_Approval_Successfully );
                    }
                }
                        
                if( behaviorCode > 1 ) {
                    Response issuesSubmitResponse = submitIssuesForApproval( listOfPartsRequested );
                    if( issuesSubmitResponse.isSucceeded ) {
                        System.debug( 'response.recordWorkOrder.CaseId:-\n' + response.recordWorkOrder.CaseId );
                        createProductRequests( response.recordWorkOrder.CaseId );
                    }
                    else {
                        response.setStatus( issuesSubmitResponse.isSucceeded, issuesSubmitResponse.message );
                    }
                }
            }
            catch( DmlException e ) {
                System.debug( 'DmlException in updatePartsRequested:-\n' + e.getMessage() );
                response.setStatus( false, getCustomMessageFromException( e.getMessage() ) );
            }
            catch( Exception e ) {
                System.debug( 'Exception in updatePartsRequested:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Invalid_Part_Details_Found_For_Request + e.getMessage() );
            }
            finally {
                IssueTriggerHelper.areIssuesCreatedFromLC = FALSE;
            }
        }
        System.debug( 'updatePartsRequested-response:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String fetchIssuesSubmittedForApproval( String strJsonOfListOfApprovalIssues ) {
            
        System.debug( 'strJsonOfListOfApprovalIssues:-\n' + strJsonOfListOfApprovalIssues );
        
        Response response = new Response();
        if( String.isBlank( strJsonOfListOfApprovalIssues ) ) {
            response.setStatus( false, System.Label.Issues_Not_Submitted_For_Approval_Found );
        }
        else {
            try {
                response.listOfApprovalIssues = ( List<Issue__c> ) 
                                                 JSON.deserialize( strJsonOfListOfApprovalIssues, List<Issue__c>.class );
                System.debug( 'before-response.listOfApprovalIssues:-\n' + JSON.serialize( response.listOfApprovalIssues ) );
                if( response.listOfApprovalIssues == NULL || response.listOfApprovalIssues.isEmpty() ) {
                    response.setStatus( false, System.Label.Issues_Not_Submitted_For_Approval_Found_Try_Again );
                }
                response.listOfApprovalIssues = [ SELECT ID, Name, Window_ID__c, Control_Panel__c, Comments__c,
                                                  Start_Date__c, End_Date__c, Issue_Status__c,
                                                  Work_Type__c, Failure_Component__c, RecordTypeId, Product__c,
                                                  Requested_Delivery_Date__c, RecordType.Name, Product__r.Name,
                                                  Warranty_Type__c,WC_ID__c,Dev__c,Product_Return__c,Reverse_Shipment_Info__c,RMA_FA_Status__c
                                                  FROM Issue__c
                                                  WHERE
                                                  Issue_Status__c != 'Open'
                                                    AND
                                                  ID IN : response.listOfApprovalIssues
                                                  FOR UPDATE
                                                ];
                if( response.listOfApprovalIssues.isEmpty() ) {
                    response.setStatus( false, System.Label.Issues_Not_Submitted_For_Approval_Found_Try_Again );
                }
                else {
                    response.setStatus( true, '' );
                }
            }
            catch( Exception e ) {
                System.debug( 'Exception in fetchIssuesSubmittedForApproval:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Issues_Not_Submitted_For_Approval_Found + e.getMessage() );
            }
        }
        System.debug( 'fetchIssuesSubmittedForApproval-response:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @Future( callout = true )
    public static void createProductRequests( Id caseId ) {
        
        List<Issue__c> listOfIssuesForProductRequests = GenerateProductReqController.getIssues( caseId );
        System.debug( 'createProductRequests-listOfIssuesForProductRequests:-\n' + JSON.serialize( listOfIssuesForProductRequests ) );
        GenerateProductReqController.ResultWrapper resultWrapper;
        resultWrapper = GenerateProductReqController.createProductRequestandLines( listOfIssuesForProductRequests, caseId );
        System.debug( 'createProductRequests-resultWrapper:-\n' + JSON.serialize( resultWrapper ) );
    }
    
    @AuraEnabled
    public static String updatePMIssueRecords( String strJSONListOfPMIssuesWrappers, Integer behaviorCode ) {
        
        System.debug( 'updatePMIssueRecords:-\n' + strJSONListOfPMIssuesWrappers );
        Response response = new Response();
        if( String.isBlank( strJSONListOfPMIssuesWrappers ) ) {
            response.setStatus( false, System.Label.Issues_Found_Invalid );
        }
        else {
            try {
                List<IssueManagementCtrlWrapper> listOfPMIssueWrappers;
                listOfPMIssueWrappers = ( List<IssueManagementCtrlWrapper> ) 
                                        JSON.deserialize( strJSONListOfPMIssuesWrappers, List<IssueManagementCtrlWrapper>.class );
                
                if( listOfPMIssueWrappers == NULL || listOfPMIssueWrappers.isEmpty() ) {
                    response.setStatus( false, System.Label.Issues_Not_Found_For_Update_Try_Again );
                }
                
                List<Issue__c> listOfPMIssues = getListOfIssues( listOfPMIssueWrappers );
                List<Issue_Failure_Mode__c> listOfIssueFailureModes = getListOfIssueFailureModes( listOfPMIssueWrappers );
                IssueTriggerHelper.areIssuesCreatedFromLC = TRUE;
                UPDATE listOfPMIssues;
                Database.insert( listOfIssueFailureModes, false );
                
                if( listOfPMIssues.size() > 1 ) {
                    if( behaviorCode == 1 ) {
                        response.setStatus( true,   System.Label.Issues_Saved_Successfully );
                    }
                    else {
                        response.setStatus( true, System.Label.Issues_Submitted_For_Approval_Successfully );
                    }
                }
                else {
                    if( behaviorCode == 1 ) {
                        response.setStatus( true,   System.Label.Issue_Saved_Successfully );
                    }
                    else {
                        response.setStatus( true, System.Label.Issue_Submitted_For_Approval_Successfully );
                    }
                }
                
                if( behaviorCode > 1 ) {
                    Response issuesSubmitResponse = submitIssuesForApproval( listOfPMIssues );
                    if( issuesSubmitResponse.isSucceeded == false ) {
                        response.setStatus( issuesSubmitResponse.isSucceeded, issuesSubmitResponse.message );
                    }
                }
            }
            catch( DmlException e ) {
                System.debug( 'DmlException in updatePMIssueRecords:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Error_Updating_Issues + e.getMessage() );
            }
            catch( Exception e ) {
                System.debug( 'Exception in updatePMIssueRecords:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Issues_Details_Found_For_Update_Invalid + e.getMessage() );
            }
            finally {
                IssueTriggerHelper.areIssuesCreatedFromLC = FALSE;
            }
        }
        System.debug( 'updatePMIssueRecords-response:-\n' + response );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String updateTradeIssueRecords( String strJSONListOfTradeIssuesWrappers ) {
        
        System.debug( 'updateTradeIssueRecords:-\n' + strJSONListOfTradeIssuesWrappers );
        Response response = new Response();
        if( String.isBlank( strJSONListOfTradeIssuesWrappers ) ) {
            response.setStatus( false, System.Label.Issues_Found_Invalid );
        }
        else {
            try {
                List<IssueManagementCtrlWrapper> listOfTradeIssueWrappers;
                listOfTradeIssueWrappers = ( List<IssueManagementCtrlWrapper> ) 
                                            JSON.deserialize( strJSONListOfTradeIssuesWrappers, List<IssueManagementCtrlWrapper>.class );
                
                if( listOfTradeIssueWrappers == NULL || listOfTradeIssueWrappers.isEmpty() ) {
                    response.setStatus( false, System.Label.Issues_Not_Found_For_Update_Try_Again );
                }
                
                List<Issue__c> listOfTradeIssues = getListOfIssues( listOfTradeIssueWrappers );
                IssueTriggerHelper.areIssuesCreatedFromLC = TRUE;
                UPDATE listOfTradeIssues;
                
                if( listOfTradeIssues.size() > 1 ) {
                    response.setStatus( true,   System.Label.Issues_Saved_Successfully );
                }
                else {
                    response.setStatus( true, System.Label.Issue_Saved_Successfully );
                }
            }
            catch( Exception e ) {
                System.debug( 'Exception in updateTradeIssueRecords:-\n' + e.getMessage() );
                response.setStatus( false, System.Label.Issues_Details_Found_For_Update_Invalid + e.getMessage() );
            } finally {
                IssueTriggerHelper.areIssuesCreatedFromLC = FALSE;
            }
        }
        System.debug( 'updateTradeIssueRecords-response:-\n' + response );
        return JSON.serialize( response ); 
    }
    
    @AuraEnabled
    public static String saveIssues( List<Issue__c> ListIssues ) {
        
        System.debug( 'saveIssues-ListIssues:-\n' + JSON.serialize( ListIssues ) );
        Response response = new Response();
        if( ListIssues == NULL || ListIssues.isEmpty() ) {
            response.setStatus( false,  System.Label.Issues_Not_Found_Try_Again );
        }
        else {
            Date dateToday = System.today();
            ID IGURecordTypeId = getIssueRecordTypeIdByName( IGU_RECORD_TYPE_NAME );
            
            for( Issue__c recordIssue : ListIssues ) {
                recordIssue.Start_Date__c = dateToday;
                recordIssue.Work_Type__c = 'Troubleshooting';
                
                if( recordIssue.RecordTypeId == IGURecordTypeId ) {
                    recordIssue.Failure_Component__c = 'IGU';
                }
            }
            
            try {
                IssueTriggerHelper.areIssuesCreatedFromLC = TRUE;
                INSERT ListIssues;
                if( ListIssues.size() > 1 ) {
                    response.setStatus( true, System.Label.Issues_Saved_Successfully );
                }
                else {
                    response.setStatus( true, System.Label.Issue_Saved_Successfully );
                }
            }
            catch( Exception e ) {
                System.debug( 'Exception in saveIssues:-\n' + e.getMessage() );
                System.debug( 'Exception in ListIssues:-\n' + JSON.serialize( ListIssues ) );
                response.setStatus( false, System.Label.Error_Saving_Issues + e.getMessage() );
            }
            finally {
                IssueTriggerHelper.areIssuesCreatedFromLC = FALSE;
            }
        }
        
        System.debug( 'saveIssues-response:-\n' + JSON.serialize( response ) );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String fetchPredictions( String searchKeyword ) {
        
        System.debug( 'fetchPredictions-searchKeyword:-\n' + searchKeyword );
        Response response = new Response();
        if( String.isBlank( searchKeyword ) ) {
            response.setStatus( false, System.Label.Provide_Location_Details );
        }
        else {
            String url = GOOGLE_END_POINT_URL + '/autocomplete/json?input=' + EncodingUtil.urlEncode( searchKeyword, 'UTF-8' ) + getKey();
            response.jsonPredictions = getGoogleResponse( url );
            
            if( String.isBlank( response.jsonPredictions ) ) {
                response.setStatus( false, System.Label.Details_Not_Found_For_This_Location );
            }
            else {
                response.setStatus( true, '' );
            }
        }
        System.debug( 'fetchPredictions-response:-\n' + response );
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String fetchPlaceDetails( String placeId ) {
        
        System.debug( 'fetchPlaceDetails-placeId:-\n' + placeId );
        Response response = new Response();
        if( String.isBlank( placeId ) ) {
            response.setStatus( false, System.Label.Provide_Location_From_List );
        }
        else {
            String url = GOOGLE_END_POINT_URL + '/details/json?placeid=' + EncodingUtil.urlEncode( placeId, 'UTF-8' ) + getKey();
            response.jsonPlaceDetails = getGoogleResponse( url );
            
            if( String.isBlank( response.jsonPlaceDetails ) ) {
                response.setStatus( false, System.Label.Details_Not_Found_For_This_Location );
            }
            else {
                response.setStatus( true, '' );
            }
        }
        System.debug( 'fetchPlaceDetails-response:-\n' + response );
        return JSON.serialize( response );
    }
    
    private static List<Schema.Location> getListOfLocations( String strSearchKeyWord ) {
        
        List<Schema.Location> locations = new List<Schema.Location>();
        locations = [ SELECT ID, Name
                      FROM Location
                      WHERE 
                      Name LIKE : strSearchKeyword
                        AND
                      LocationType = 'Trunk'
                      ORDER BY Name 
                      LIMIT : SEARCH_RESULTS_LIMIT
                    ];
        System.debug( 'locations:-\n' + JSON.serialize( locations ) );
        return locations;
    }
    
    private static void setProductIdToListPrice( Map<ID,String> productIdToListPrice, String strOpportunityPricebook2Id, String currencyIsoCode ) {
        
        System.debug( 'before-setProductIdToListPrice:-\n' + JSON.serialize( productIdToListPrice ) );
        if( productIdToListPrice == NULL || productIdToListPrice.isEmpty() || String.isBlank( strOpportunityPricebook2Id ) ) {
            return;
        }
        
        if( String.isBlank( currencyIsoCode ) ) {
            currencyIsoCode = 'USD';
        }
        
        List<Product2> listOfProductsWithPrices = [ SELECT ID, Name,
                                                    (
                                                     SELECT ID, UnitPrice 
                                                     FROM PriceBookEntries
                                                     WHERE 
                                                     PriceBook2Id = :strOpportunityPricebook2Id
                                                        AND
                                                     CurrencyIsoCode =: currencyIsoCode
                                                        AND
                                                     IsActive = true
                                                     LIMIT 1
                                                    )
                                                    FROM Product2 
                                                    WHERE 
                                                    ID IN : productIdToListPrice.keySet()
                                                        AND
                                                    Family IN : PRODUCT_FAMILIES
                                                 ];
                                                 
        System.debug( 'listOfProductsWithPrices:-\n' + JSON.serialize( listOfProductsWithPrices ) );
        Decimal listPrice;
        
        for( Product2 recordProduct : listOfProductsWithPrices ) {
            if( !recordProduct.PriceBookEntries.isEmpty() ) {
                
                listPrice = recordProduct.PriceBookEntries.get( 0 ).UnitPrice;
                if( listPrice != NULL ) {
                    listPrice = listPrice.setScale( 2 );
                }
                
                productIdToListPrice.put( recordProduct.ID, currencyIsoCode + ' ' + listPrice );
            }
        }
        System.debug( 'after-setProductIdToListPrice:-\n' + JSON.serialize( productIdToListPrice ) );
    }
    
    private static List<Issue__c> getListOfIssues( List<IssueManagementCtrlWrapper> listOfIssueWrappers ) {
            
        List<Issue__c> listOfSelectedIssues = new List<Issue__c>();
        if( listOfIssueWrappers != NULL && !listOfIssueWrappers.isEmpty() ) {
            for( IssueManagementCtrlWrapper wrapper : listOfIssueWrappers ) {
                listOfSelectedIssues.add( wrapper.recordIssue );
            }
        }
        System.debug( 'listOfSelectedIssues:-\n' + JSON.serialize( listOfSelectedIssues ) );
        return listOfSelectedIssues;
    }
    
    private static List<Issue_Failure_Mode__c> getListOfIssueFailureModes( List<IssueManagementCtrlWrapper> listOfIssueWrappers ) {
        
        List<Issue_Failure_Mode__c> listOfIssueFailureModes = new List<Issue_Failure_Mode__c>();
        if( listOfIssueWrappers != NULL && !listOfIssueWrappers.isEmpty() ) {
            
            for( IssueManagementCtrlWrapper wrapper : listOfIssueWrappers ) {
                for( String strFailureModeId : wrapper.listOfSelectedFailureModes ) {
                    listOfIssueFailureModes.add
                                            (
                                             new Issue_Failure_Mode__c
                                             (
                                              Failure_Mode__c = strFailureModeId,
                                              Issue__c = wrapper.recordIssue.Id,
                                              Failure_Component__c = wrapper.recordIssue.Failure_Component__c
                                             )
                                            );
                }
            }
        }
        System.debug( 'listOfIssueFailureModes:-\n' + JSON.serialize( listOfIssueFailureModes ) );
        return listOfIssueFailureModes;
    }
    
    @TestVisible    
    private static List<Contact> searchContactFromOpportunityContactRoles( String strSearchKeyword, String strOpportunityId, String strContactId ) {
        
        List<Contact> listOfContacts = new List<Contact>();
        if( String.isBlank( strSearchKeyword ) ) {
            return listOfContacts;
        }
        
        strSearchKeyword = strSearchKeyword + '%';
        
        Set<ID> setOfContactIds = new Set<ID>();
        if( String.isNotBlank( strOpportunityId ) ) {
            for( OpportunityContactRole ccr : [ SELECT ContactId FROM OpportunityContactRole
                                                WHERE OpportunityId =: strOpportunityId
                                              ] 
            ) {
               setOfContactIds.add( ccr.ContactId );
            }
            
            if( String.isNotBlank( strContactId ) && !setOfContactIds.contains( strContactId ) ) {
                setOfContactIds.add( strContactId );
            }
        }
        
        String query = 'SELECT ID, Name, Email, Phone, Title, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode ' +
                       'FROM Contact ' +
                       'WHERE Name LIKE : strSearchKeyword ';
                       
        if( String.isBlank( strOpportunityId ) ) {
            query += ' OR ID IN : setOfContactIds ';
        }
        else {
            query += ' AND ID IN : setOfContactIds ';
        }
        query += 'ORDER BY Name LIMIT : SEARCH_RESULTS_LIMIT';
        
        try {
            listOfContacts = Database.query( query );
        }
        catch( Exception e ) {
            System.debug( 'searchContactFromOpportunityContactRoles-Exception:-\n' + e.getMessage() );
        }
        System.debug( 'searchContactFromOpportunityContactRoles:-\n' + JSON.serialize( listOfContacts ) );
        return listOfContacts;
    }
    
    @TestVisible    
    private static Response submitIssuesForApproval( List<Issue__c> listOfIssuesForApproval ) {
    
        Response response = new Response();
        if( listOfIssuesForApproval == NULL || listOfIssuesForApproval.isEmpty() ) {
            response.setStatus( false, System.Label.Issues_Not_Found_For_Approval );
            return response;
        }
        
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        Approval.ProcessSubmitRequest req;
        
        for( Issue__c recordIssue : listOfIssuesForApproval ) {
            req = new Approval.ProcessSubmitRequest();
            req.setComments( System.Label.Approval_Comments_from_LC );
            req.setObjectId( recordIssue.Id );
            req.setSkipEntryCriteria( true );
            requests.add( req );
        }
        
        try {
            Approval.ProcessResult[] processResults = Approval.process( requests, false );
            System.debug( 'processResults:-\n' + JSON.serialize( processResults ) );
            response.setStatus( true, '' );
        }
        catch ( Exception e ) {
            System.debug( 'submitIssuesForApproval:-\n' + e.getMessage() );
            response.setStatus( false, System.Label.Error_Submitting_Issues_For_Approval + e.getMessage() );
        }
        System.debug( 'submitIssuesForApproval:-\n' + JSON.serialize( response ) );
        return response;
    }
    
    private static String getGoogleResponse( String strURL ) {
        
        HttpRequest req = new HttpRequest();
        req.setMethod( 'GET' );
        req.setEndpoint( strURL );
        req.setTimeout( 120000 );
        
        HttpResponse res = new HttpResponse();
        try {
            res = new Http().send( req );
        }
        catch( Exception e ) {
            System.debug( 'Exception in getResponse:-\n' + e.getMessage() );
        }
        String responseBody = res.getBody();
        System.debug( 'getGoogleResponse-responseBody:-\n' + responseBody );
        return responseBody;
    }
    
    private static string getKey() {
        
        Google_API_Key__c k = Google_API_Key__c.getOrgDefaults();
        String key = k.API_Key__c;
        String output = '&key=' + key;   
        System.debug( 'getKey:-\n' + output );
        return output;
    }
    
    private static ID getIssueRecordTypeIdByName( String issueRecordTypeName ) {
        
        ID issueRecordTypeId;
        try {
            issueRecordTypeId = SobjectType.Issue__c.getRecordTypeInfosByName().get( issueRecordTypeName ).getRecordTypeId();
        }
        catch( Exception e ) {
            System.debug( 'An exception occurred while fetching record type id for --> ' + issueRecordTypeName );
        }
        System.debug( 'getIssueRecordTypeIdByName-' + issueRecordTypeName + '-' + issueRecordTypeId );
        return issueRecordTypeId;
    }
    
    @TestVisible    
    private static String getCustomMessageFromException( String strExceptionMessage ) {
        
        System.debug( 'before:-\n' + strExceptionMessage );
        if( String.isBlank( strExceptionMessage ) ) {
            return strExceptionMessage;
        }
        
        if( strExceptionMessage.containsIgnoreCase( 'higher than quantity available in selected trunk' ) ) {
            strExceptionMessage = System.Label.Selected_Quantity_For_Product_Higher_Than_Quantity_Available_In_Selected_Trunk;
        }
        else if( strExceptionMessage.containsIgnoreCase( 'product is not available in the Trunk selected' ) ) {
            strExceptionMessage = System.Label.Product_Is_Not_Available_In_Selected_Trunk;
        }
        else if( strExceptionMessage.containsIgnoreCase( 'once a product has already been consumed' ) ) {
            strExceptionMessage = System.Label.Cannot_Update_Product_Quantity_And_Trunk_Once_Product_Is_Already_Consumed;
        }
        return strExceptionMessage;
    }
    
    public class FailureModeWrapper {
        
        public Boolean isSelected;
        
        public Failure_Mode__c recordFailureMode;
        
        public FailureModeWrapper() {
            
            this.isSelected = false;
            this.recordFailureMode = new Failure_Mode__c();
        }
        
        public FailureModeWrapper( Boolean isSelected, Failure_Mode__c recordFailureMode ) {
            
            this();
            this.isSelected = isSelected;
            this.recordFailureMode = recordFailureMode;
        }
    }
    
    public class IssueManagementCtrlWrapper {
        
        public Boolean isSelected;
        
        public Issue__c recordIssue;
        
        public Schema.Location recordTrunk;
        
        public String listPrice;
        
        public List<String> listOfSelectedFailureModes;
        public List<String> listOfSelectedFailureModesNames;
        
        public List<String> listOfFailureComponentValues;
        
        public List<String> listOfWorkTypeValues;
        
        public Map<string,List<String>> updateSfmMap;
        public boolean provideFMDetails;
        
        //public List<string> namesOfSFM;
        
        public IssueManagementCtrlWrapper() {
            
            this.isSelected = false;
            this.provideFMDetails = false;
            this.recordIssue = new Issue__c();
            this.recordTrunk = new Schema.Location();
            this.listOfSelectedFailureModesNames = new List<String>(); 
            this.listOfSelectedFailureModes = new List<String>();
            this.listOfFailureComponentValues = new List<String>();
            this.listOfWorkTypeValues = new List<String>();
            this.updateSfmMap = new Map<string,List<string>>();
            updateSfmMap.put('Non-Tinting - Intermittent Tinting',new List<string>{'Replaced_SWC__c','Replaced_WC__c','Replaced_IGU_Cable__c'});
            updateSfmMap.put('Non-Tinting',new List<string>{'Replaced_SWC__c','Replaced_WC__c','Replaced_IGU_Cable__c'});
            updateSfmMap.put('Obstruction in Field of View - Spontaneous Breakage',new List<string>{'Lite_Damaged__c'});
            updateSfmMap.put('OOS Scratches - S1/S4',new List<string>{'From_approx_10ft_3_m__c','Uniform_background_lighting_that_simulat__c','Vertically_positioned_at_90_deg_viewing__c'});
            updateSfmMap.put('OOS Scratches - S3 / Other',new List<string>{'From_approx_10ft_3_m__c','Uniform_background_lighting_that_simulat__c','Vertically_positioned_at_90_deg_viewing__c'});
            updateSfmMap.put('Non-Uniformity - Within Lite',new List<string>{'Visible_BB_Damage__c'});
            updateSfmMap.put('Non-Uniformity - L2L',new List<string>{'Visible_BB_Damage__c'});
            //this.namesOfSFM = new List<String>();
        }
        
        public IssueManagementCtrlWrapper( Boolean isSelected, Issue__c recordIssue ) {
            
            this();
            if( isSelected != NULL ) {
                this.isSelected = isSelected;
            }
            if( recordIssue != NULL ) {
                this.recordIssue = recordIssue;
            }
        }
    }
    
    public class Response {
        
        public Boolean isSucceeded;

        public String message;
        
        public String jsonPredictions;
        
        public String jsonPlaceDetails;
        
        public WorkOrder recordWorkOrder;
        
        public Issue__c recordCommonIssue;
        
        public String strAddress;
        
        public List<Issue__c> listOfApprovalIssues;
        
        public List<IssueManagementCtrlWrapper> listOfIssueWrappers;
        
        public List<IssueManagementCtrlWrapper> listOfIGUIssueWrappers;
        
        public List<IssueManagementCtrlWrapper> listOfPartRequestedWrappers;
        
        public List<IssueManagementCtrlWrapper> listOfPMIssueWrappers;
        
        public List<IssueManagementCtrlWrapper> listOfCHWTradeIssueWrappers;
        
        public List<IssueManagementCtrlWrapper> listOfIGUTradeIssueWrappers;
        
        public List<FailureModeWrapper> listOfFailureModeWrappers;
        
        public List<Contact> listOfContactSearchedResults;
        
        public List<Schema.Location> listOfTrunkSearchResults;
        
        public List<Asset> listOfAssetSearchedResults;
        
        public List<SearchResultWrapper> listOfSearchedResults;
        
        public List<SearchResultWrapper> listOfSearchedResultsTrunk;
        
        public List<SearchResultWrapper> listOfFailureModeResults;
        
        public List<SearchResultWrapper> listOfRecordTypes;
        
        public List<String> listOfFailureComponentValues;
        
        public List<String> listOfWorkTypeValues;
        
        public List<String> listOfCSSReplacements;
        
        public List<String> listOfIGUReplacements;
        
        public List<String> listOfResponsibleEntities;
        
        public List<String> listOfTradeSupportValues;
        
        public Map<String,List<String>> recordTypeNameToListOfFailureComponents;
        
        public Map<String,List<String>> recordTypeNameToListOfWorkTypes;
        
        public Work_Order_Settings__c recordWorkOrderSettings;
        
        public Response() {
            
            this.isSucceeded = false;
            this.message = '';
            this.jsonPredictions = '';
            
            this.recordWorkOrder = new WorkOrder();
            this.recordCommonIssue = new Issue__c();
            
            this.listOfApprovalIssues = new List<Issue__c>();
            this.listOfIssueWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfIGUIssueWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfPartRequestedWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfPMIssueWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfCHWTradeIssueWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfIGUTradeIssueWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfFailureModeWrappers = new List<FailureModeWrapper>();
            
            this.listOfContactSearchedResults = new List<Contact>();
            this.listOfSearchedResults = new List<SearchResultWrapper>();
            this.listOfSearchedResultsTrunk = new List<SearchResultWrapper>();
            this.listOfFailureModeResults = new List<SearchResultWrapper>();
            this.listOfTrunkSearchResults = new List<Schema.Location>();
            this.listOfAssetSearchedResults = new List<Asset>();
            
            this.listOfRecordTypes = new List<SearchResultWrapper>();
            
            this.listOfFailureComponentValues = new List<String>();
            this.listOfWorkTypeValues = new List<String>();
            this.listOfCSSReplacements = new List<String>();
            this.listOfIGUReplacements = new List<String>();
            this.listOfResponsibleEntities = new List<String>();
            this.listOfTradeSupportValues = new List<String>();
            
            this.recordTypeNameToListOfFailureComponents = new Map<String,List<String>>();
            this.recordTypeNameToListOfWorkTypes = new Map<String,List<String>>();
            
            this.recordWorkOrderSettings = new Work_Order_Settings__c();
        }
        
        public void setStatus( Boolean isSucceeded, String message ) {
            
            this.isSucceeded = isSucceeded;
            this.message = message;
        }
        
        public void setWorkOrder( String strWorkOrderId ) {
            
            if( String.isNotBlank( strWorkOrderId ) ) {
                try {
                    this.recordWorkOrder = [ SELECT ID, WorkOrderNumber, Status, CaseId, AccountId, Opportunity__c, Building_Accounts__c, 
                                             Building_Accounts__r.Name, Opportunity__r.Name,Opportunity__r.IGU_Pigtail_Style__c, Case.CaseNumber, Case.AccountId,
                                             Case.Opportunity__c, Account.Name, Address, Opportunity__r.Pricebook2Id,
                                             Opportunity__r.CurrencyIsoCode, Case.Contact.Id, Case.Contact.Name, 
                                             Case.Contact.Email, Case.Contact.Phone,
                                             Case.Account.ShippingStreet, Case.Account.ShippingCity, 
                                             Case.Account.ShippingState,
                                             Case.Account.ShippingPostalCode, Case.Account.ShippingCountry
                                             FROM WorkOrder 
                                             WHERE
                                             ID =: strWorkOrderId
                                             AND
                                             Status != 'Closed'
                                             LIMIT 1
                                           ];
                    System.debug( 'this.recordWorkOrder:-\n' + JSON.serialize( this.recordWorkOrder ) );
                    this.recordCommonIssue.Product_Replacement__c = true;
                    this.recordCommonIssue.Customer_Contact__c = this.recordWorkOrder.Case.Contact.Id;
                    this.recordCommonIssue.Shipping_Contact_Name__c = this.recordWorkOrder.Case.Contact.Name;
                    this.recordCommonIssue.Shipping_Contact_Email__c = this.recordWorkOrder.Case.Contact.Email;
                    this.recordCommonIssue.Shipping_Contact_Number__c = this.recordWorkOrder.Case.Contact.Phone;
                    this.recordCommonIssue.Shipping_Street_1__c = this.recordWorkOrder.Case.Account.ShippingStreet;
                    this.recordCommonIssue.Shipping_City__c = this.recordWorkOrder.Case.Account.ShippingCity;
                    this.recordCommonIssue.Shipping_State_Province__c = this.recordWorkOrder.Case.Account.ShippingState;
                    this.recordCommonIssue.Shipping_Postal_Code__c = this.recordWorkOrder.Case.Account.ShippingPostalCode;
                    this.recordCommonIssue.Shipping_Country__c = this.recordWorkOrder.Case.Account.ShippingCountry;
                }
                catch( Exception e ) {
                    System.debug( 'Exception in setWorkOrder:-\n' + e.getMessage() );
                    this.setStatus( false, 'Sorry, Work Order with this Id --> ' + strWorkOrderId + ' is not found.' + e.getMessage() );
                }
            }
        }
        
        public void initializeStates() {
                
            this.setTabsVisibility();
            this.setIssueRecordTypes();
            this.setListOfReasonForReplacementValues();
            this.setListOfFailureComponentValues();
            this.setListOfWorkTypeValues();
            this.setListOfResponsibleEntities();
            this.setListOfTradeSupportValues();
            this.setValuesBasedOnRecordTypes();
        }
        
        private void setTabsVisibility() {
            
            this.recordWorkOrderSettings = Work_Order_Settings__c.getInstance();
            System.debug( 'setTabsVisibility:-\n' + JSON.serialize( this.recordWorkOrderSettings ) );
            if( this.recordWorkOrderSettings == NULL ) {
                this.recordWorkOrderSettings = new Work_Order_Settings__c();
            }
        }
        
        public void setValuesBasedOnRecordTypes() {
            
            this.setRecordTypeNameToListOfFailureComponents();
            this.setRecordTypeNameToListOfWorkTypes();
        }
        
        private void setListOfFailureComponentValues() {
            
            this.listOfFailureComponentValues = new List<String>();
            for( Schema.PicklistEntry picklistEntry : Issue__c.Failure_Component__c.getDescribe().getPicklistValues() ) {
                if( picklistEntry.isActive() ) {
                    this.listOfFailureComponentValues.add( picklistEntry.getValue() );
                }
            }
            System.debug( 'this.listOfFailureComponentValues:-\n' + JSON.serialize( this.listOfFailureComponentValues ) );
        }
        
        private void setListOfWorkTypeValues() {
            
            this.listOfWorkTypeValues = new List<String>();
            for( Schema.PicklistEntry picklistEntry : Issue__c.Work_Type__c.getDescribe().getPicklistValues() ) {
                if( picklistEntry.isActive() ) {
                    this.listOfWorkTypeValues.add( picklistEntry.getValue() );
                }
            }
            System.debug( 'this.listOfWorkTypeValues:-\n' + JSON.serialize( this.listOfWorkTypeValues ) );
        }
        
        private void setListOfResponsibleEntities() {
            
            this.listOfResponsibleEntities = new List<String>();
            for( Schema.PicklistEntry picklistEntry : Issue__c.Ownership__c.getDescribe().getPicklistValues() ) {
                if( picklistEntry.isActive() ) {
                    this.listOfResponsibleEntities.add( picklistEntry.getValue() );
                }
            }
            System.debug( 'this.listOfResponsibleEntities:-\n' + JSON.serialize( this.listOfResponsibleEntities ) );
        }
        
        private void setListOfReasonForReplacementValues() {
            
            this.listOfCSSReplacements = new List<String>();
            this.listOfIGUReplacements = new List<String>();
            
            for( Warranty_Check__mdt  wc : [ SELECT Failure_mode_Name__c, Product_Family__c
                                             FROM Warranty_Check__mdt
                                             WHERE 
                                             Failure_mode_Name__c != NULL
                                                AND
                                             Product_Family__c != NULL
                                             ORDER By Failure_mode_Name__c
                                           ] ) {
                if( wc.Product_Family__c == 'IGU' ) {
                    this.listOfIGUReplacements.add( wc.Failure_mode_Name__c );
                }
                else if( wc.Product_Family__c == 'CSS' ) {
                    this.listOfCSSReplacements.add( wc.Failure_mode_Name__c );
                }
            }
            System.debug( 'this.listOfIGUReplacements:-\n' + JSON.serialize( this.listOfIGUReplacements ) );
            System.debug( 'this.listOfCSSReplacements:-\n' + JSON.serialize( this.listOfCSSReplacements ) );
        }
        
        private void setListOfTradeSupportValues() {
            
            this.listOfTradeSupportValues = new List<String>();
            for( Schema.PicklistEntry picklistEntry : Issue__c.Required_Trade__c.getDescribe().getPicklistValues() ) {
                if( picklistEntry.isActive() ) {
                    this.listOfTradeSupportValues.add( picklistEntry.getValue() );
                }
            }
            System.debug( 'this.listOfTradeSupportValues:-\n' + JSON.serialize( this.listOfTradeSupportValues ) );
        }
        
        private void setRecordTypeNameToListOfFailureComponents() {
    
            this.recordTypeNameToListOfFailureComponents = new Map<String,List<String>>();
            for( Failure_Components__mdt  fc : [ SELECT Failure_Component_Name__c, Record_Type_Name__c
                                                 FROM Failure_Components__mdt
                                                 WHERE 
                                                 Record_Type_Name__c != NULL
                                                    AND
                                                 Failure_Component_Name__c != NULL
                                                 ORDER By Record_Type_Name__c
                                               ] ) {
                if( !recordTypeNameToListOfFailureComponents.containsKey( fc.Record_Type_Name__c.toLowerCase() ) ) {
                    this.recordTypeNameToListOfFailureComponents.put( fc.Record_Type_Name__c.toLowerCase(), new List<String>() );
                }
                this.recordTypeNameToListOfFailureComponents.get( fc.Record_Type_Name__c.toLowerCase() ).add( fc.Failure_Component_Name__c );
            }
            System.debug( 'setRecordTypeNameToListOfFailureComponents:-\n' + JSON.serialize( this.recordTypeNameToListOfFailureComponents ) );
        }
        
        private void setRecordTypeNameToListOfWorkTypes() {
    
            this.recordTypeNameToListOfWorkTypes = new Map<String,List<String>>();
            for( Issue_Work_Type__mdt  iwt : [ SELECT Work_Type__c, Record_Type_Name__c
                                               FROM Issue_Work_Type__mdt
                                               WHERE 
                                               Record_Type_Name__c != NULL
                                                AND
                                               Work_Type__c != NULL
                                               ORDER By Record_Type_Name__c
                                             ] ) {
                if( !recordTypeNameToListOfWorkTypes.containsKey( iwt.Record_Type_Name__c.toLowerCase() ) ) {
                    this.recordTypeNameToListOfWorkTypes.put( iwt.Record_Type_Name__c.toLowerCase(), new List<String>() );
                }
                this.recordTypeNameToListOfWorkTypes.get( iwt.Record_Type_Name__c.toLowerCase() ).add( iwt.Work_Type__c );
            }
            System.debug( 'setRecordTypeNameToListOfWorkTypes:-\n' + JSON.serialize( this.recordTypeNameToListOfWorkTypes ) );
        }
        
        private void setIssueRecordTypes() {
            
            this.listOfRecordTypes = new List<SearchResultWrapper>();
            for( RecordTypeInfo rtInfo : Issue__c.SobjectType.getDescribe().getRecordTypeInfos() ) {
                if( rtInfo.isAvailable() && rtInfo.isActive() && !rtInfo.isMaster() ) {
                    this.listOfRecordTypes.add
                                           ( 
                                            new SearchResultWrapper
                                            (
                                             rtInfo.getRecordTypeId(),
                                             rtInfo.getName()
                                            )
                                           );
                }
            }
            System.debug( 'this.listOfRecordTypes:-\n' + JSON.serialize( this.listOfRecordTypes ) );
        }
        
        private void setMyDefaultTrunk() {
            
            this.listOfTrunkSearchResults = [ SELECT ID, Name
                                              FROM Location
                                              WHERE
                                              LocationType = 'Trunk'
                                                AND
                                              ID IN ( SELECT LocationId 
                                                      FROM ServiceResource
                                                      WHERE 
                                                      RelatedRecordId =: UserInfo.getUserId()
                                                        AND
                                                      IsActive = true
                                                    )
                                              LIMIT 1
                                            ];
            System.debug( 'setMyDefaultTrunk:-\n' + this.listOfTrunkSearchResults );
        }
        
        private void setListOfIssueAndPartWrappers() {
            
            if( this.recordWorkOrder.Id == NULL ) {
                return;
            }
            
            this.listOfIssueWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfPartRequestedWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfPMIssueWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfCHWTradeIssueWrappers = new List<IssueManagementCtrlWrapper>();
            this.listOfIGUTradeIssueWrappers = new List<IssueManagementCtrlWrapper>();
            
            Map<ID,String> productIdToListPrice = new Map<ID,String>();
            
            List<Issue__c> listOfAllIssues = [ SELECT ID, Name, Opportunity__c, Product__c, Start_Date__c, End_Date__c, Date_Identified__c, Issue_Status__c,
                                               Work_Type__c, Failure_Component__c, Comments__c, Description__c, 
                                               Consumed_From_Trunk__c, Trunk__c, Trunk__r.Name, 
                                               CAN_ID__c, Window_ID__c, Control_Panel__c, Quantity__c, Warranty_Type__c, Product_Replacement__c,
                                               RecordTypeId, Requested_Delivery_Date__c, Ownership__c,
                                               Consumables__c, Spare_Parts__c,
                                               Shipping_Address__c, Shipping_Contact_Name__c, Shipping_Contact_Number__c,
                                               Tint__c, Length_in_MM__c, Width_in_MM__c, Zone_Name__c, Lite_ID_Mock_ID__c,
                                               IGU_ID_Provided__c, X_From_Logo_in__c, Y_From_Logo_in__c,
                                               Logo_Location__c, Halo_Type__c, Intensity__c, Mitigation_Successful__c,
                                               Surface_Mitigated_From__c, Base_in__c,Height_in__c, Shape__c, Mark_ID__c, H1__c, H1_B1_in__c, W1__c,
                                               Product__r.Id, Product__r.Name, Product__r.Family, Existing_Makeup__c, Existing_Makeup__r.Name,
                                               Existing_Makeup__r.Family, Want_to_Order_Existing_Makeup__c,
                                               Reason_for_Replacement__c, Create_Box_Folder__c, BOX_Folder_Id__c,toLabel(RecordType.Name),
                                               Customer_Contact__c, Customer_Contact__r.Phone, Customer_Contact__r.Email,
                                               Shipping_Street_1__c, Shipping_Street_2__c, Shipping_City__c, Shipping_State_Province__c,
                                               Shipping_Country__c, Shipping_Postal_Code__c, Replacement_Needed__c,
                                               Replaced_SWC__c, Lite_Damaged__c, Replaced_WC__c, Visible_BB_Damage__c, 
                                               Replaced_IGU_Cable__c, Reflection_Color_Observed__c, Reflection_Color_Degree__c,
                                               Required_Trade__c, Trade_Support_Provided__c,Dev__c,WC_ID__c,Product_Return__c,Reverse_Shipment_Info__c,RMA_FA_Status__c,
                                               ( SELECT Failure_Mode__c, Failure_Mode__r.Name
                                                 FROM Defect_Root_Causes__r
                                                 WHERE Failure_Mode__c != NULL
                                               )
                                               FROM Issue__c
                                               WHERE 
                                               Source_Work_Order__c =: this.recordWorkOrder.Id
                                               ORDER BY Name
                                             ];
            System.debug( 'listOfAllIssues:-\n' + JSON.serialize( listOfAllIssues ) );
            
            if( !listOfAllIssues.isEmpty() ) {
                
                this.setValuesBasedOnRecordTypes();
                
                ID IGURecordTypeId = getIssueRecordTypeIdByName( IGU_RECORD_TYPE_NAME );
                this.setMyDefaultTrunk();
                Schema.Location loggedInUserTrunk = new Schema.Location();
                if( !this.listOfTrunkSearchResults.isEmpty() ) {
                    loggedInUserTrunk = this.listOfTrunkSearchResults.get( 0 );
                }
                
                IssueManagementCtrlWrapper recordIssueWrapper;
                Boolean isIssueInOpenStatus;
                
                for( Issue__c recordIssue : listOfAllIssues ) {
                    
                    isIssueInOpenStatus = false;
                    if( String.isBlank( recordIssue.Issue_Status__c ) ) {
                        isIssueInOpenStatus = true;
                    }
                    else if( setOfOpenIssueStatuses.contains( recordIssue.Issue_Status__c.toLowerCase() ) ) {
                        isIssueInOpenStatus = true;
                    }
                    
                    recordIssueWrapper = new IssueManagementCtrlWrapper( false, recordIssue );
                    recordIssueWrapper.listOfFailureComponentValues = this.recordTypeNameToListOfFailureComponents.get( recordIssue.RecordType.Name.toLowerCase() );
                    if( recordIssueWrapper.listOfFailureComponentValues != NULL && !recordIssueWrapper.listOfFailureComponentValues.isEmpty() ) {
                        recordIssueWrapper.listOfFailureComponentValues.sort();
                    }
                    
                    recordIssueWrapper.listOfWorkTypeValues = this.recordTypeNameToListOfWorkTypes.get( recordIssue.RecordType.Name.toLowerCase() );
                    if( recordIssueWrapper.listOfWorkTypeValues != NULL && !recordIssueWrapper.listOfWorkTypeValues.isEmpty() ) {
                        recordIssueWrapper.listOfWorkTypeValues.sort();
                    }
                    
                    if( recordIssue.Replacement_Needed__c == 'Yes' && isIssueInOpenStatus ) {
                        this.listOfPMIssueWrappers.add( recordIssueWrapper );
                    }
                    
                    if( IGURecordTypeId == recordIssue.RecordTypeId ) {
                        
                        if( isIssueInOpenStatus || recordIssue.Issue_Status__c=='Order Shipped' || recordIssue.Issue_Status__c=='Replacement Rejected') {
                            this.listOfIGUIssueWrappers.add( recordIssueWrapper );
                        }
                        
                        if( String.isNotBlank( recordIssue.Required_Trade__c ) && recordIssue.Trade_Support_Provided__c == FALSE ) {
                            listOfIGUTradeIssueWrappers.add( recordIssueWrapper );
                        }
                    }
                    else {
                        if( isIssueInOpenStatus ||recordIssue.Issue_Status__c =='Replacement Rejected' ||recordIssue.Issue_Status__c =='Order Shipped' ) {
                            this.listOfIssueWrappers.add( recordIssueWrapper );
                        }
                        
                        if( String.isNotBlank( recordIssue.Required_Trade__c ) && recordIssue.Trade_Support_Provided__c == FALSE ) {
                            listOfCHWTradeIssueWrappers.add( recordIssueWrapper );
                        }
                    }
                    
                    if( CSS_RECORD_TYPES.contains( recordIssue.RecordType.Name.toLowerCase() ) && 
                        recordIssue.Issue_Status__c != 'Resolved' &&
                        String.isNotBlank( recordIssue.Failure_Component__c )
                    ) {
                        if( recordIssueWrapper.recordIssue.Trunk__c == NULL ) {
                            recordIssueWrapper.recordTrunk = loggedInUserTrunk;
                        }
                        else {
                            recordIssueWrapper.recordTrunk = new Schema.Location
                                                             ( 
                                                              ID = recordIssueWrapper.recordIssue.Trunk__c,
                                                              Name = recordIssueWrapper.recordIssue.Trunk__r.Name
                                                             );
                        }
                        if( isIssueInOpenStatus ) {
                            this.listOfPartRequestedWrappers.add( recordIssueWrapper );
                        }
                    }
                    
                    if( recordIssue.Product__c != NULL ) {
                        productIdToListPrice.put( recordIssue.Product__c, null );
                    }
                    
                    // POPULATES ALREADY CREATED FAILURE MODES
                    recordIssueWrapper.listOfSelectedFailureModes = new List<String>();
                    for( Issue_Failure_Mode__c ifm : recordIssue.Defect_Root_Causes__r ) {
                        recordIssueWrapper.listOfSelectedFailureModes.add( ifm.Failure_Mode__c );
                        recordIssueWrapper.listOfSelectedFailureModesNames.add(ifm.Failure_Mode__r.Name);
                        if(recordIssueWrapper.updateSfmMap.containsKey(ifm.Failure_Mode__r.Name)){
                    		recordIssueWrapper.provideFMDetails = true;
                }
                    }
                }
                
                setProductIdToListPrice( productIdToListPrice,
                                         this.recordWorkOrder.Opportunity__r.PriceBook2Id,
                                         this.recordWorkOrder.Opportunity__r.CurrencyIsoCode 
                                       );
                
                for( IssueManagementCtrlWrapper wrapper : this.listOfPartRequestedWrappers ) {
                    wrapper.listPrice = productIdToListPrice.get( wrapper.recordIssue.Product__c );
                }
            }
        }
    }
    
    public class SearchResultWrapper {
        
        public String id;
        
        public String label;
        
        public String value;
        
        public String listPrice;
        
        public String description;
        
        public Product2 recordProduct;
        
        public SearchResultWrapper() {
            
            this.Value = '';
            this.label = '';
        }
        
        public SearchResultWrapper( String id, String value ) {
            
            this();
            this.id = id;
            this.value = value;
        }
        
        public SearchResultWrapper( Product2 recordProduct, String listPrice ) {
            
            this();
            this.recordProduct = recordProduct;
            this.listPrice = listPrice;
        }
        
        public SearchResultWrapper( Product2 recordProduct ) {
            
            this();
            this.recordProduct = recordProduct;
         }
        
        public void setOption( String label, String value ) {
            
            this.label = label;
            this.value = value;
        }
    }
    
    @AuraEnabled
    public static list<issue__c> fetchOrderIssues( String orderId, String pageSize, String pageNumber ) {
        
        system.debug('orderId-->' + orderId);
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        return [ SELECT Id,createddate,Name,Product__c, Product__r.Name,Failure_Component__c,Status__c,
                 Product_Under_Warranty__c,Manually_updated_Warranty_Type__c, Source_Work_Order__c,
                 Window_id__c, Control_Panel__c, Required_Trade__c,Work_Type__c,Issue_Status__c,RMA_FA_Status__c,
                 Consumed_From_Trunk__c, Comments__c,
                 Opportunity__c, Customer_Account__c,Shipping_Contact_Name__c, Shipping_Contact_Number__c, 
                 Requested_Delivery_Date__c,Quote__c from Issue__c 
                 WHERE Source_Work_Order__c =: orderId 
                 LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)
               ];
    }
    
    @AuraEnabled
    public static workorder getOrderDetails( ID orderId ) {
        
        return [ SELECT ID, Case.CaseNumber, Building_Accounts__r.Name, Opportunity__r.Name,Opportunity__r.IGU_Pigtail_Style__c,
                 Account.Name, Address, Requested_Onsite_Date__c
                 FROM workorder 
                 WHERE ID =: orderId LIMIT 1
               ];
    }
    
    @AuraEnabled
    public static Boolean isclosedcase( ID workorderid ) {
        
        System.debug( 'isclosedcase:-\n' + workorderid );
        
        List<WorkOrder> workOrd = [ SELECT ID, CaseId, Case.Status
                                    FROM WorkOrder 
                                    WHERE ID =: workorderid
                                        AND
                                    CaseId != null
                                        AND
                                    Case.Status != 'Closed'
                                    LIMIT 1
                                  ];
        return ( !workOrd.isEmpty() );
    }
    @AuraEnabled
    public static Issue__c getIssueInfo(string issId){
        return [SELECT Id,Issue_Status__c,Product_Replacement__c,Product_Return__c FROM Issue__c where id=:issId LIMIT 1];
    }
}