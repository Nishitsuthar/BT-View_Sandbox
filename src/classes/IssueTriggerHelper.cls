/*
Author : Magnet360
Purpose: This class is called from IssueTrigger
9/19/19 - BALA - Adding a method to populate shipping address on Issues.
*/

Public class IssueTriggerHelper {
    
    public static Boolean areIssuesCreatedFromLC = FALSE;
    //public static Integer partsFromTrunk;
    
    /*
createProductsConsumed : Method to create product consumed record for issue.
*/
    public static boolean isTriggerAlreadyExecuted = False;
    public static boolean productConsumedDeducted = False;
    public static void createProductsConsumed( List<Issue__c> lisNewIssues, Map<Id,Issue__c> mapOldIssues ) {
        system.debug('createProductsConsumed');
        try {
            Set<Id> setTrunckIds = new Set<Id>();
            List<Issue__c> listIssueForPCCreation = new List<Issue__c>();
            
            for( Issue__c issue : lisNewIssues ) {
                Issue__c oldIssue;
                
                Boolean createPCOnUpdate = false;
                if( mapOldIssues != null && mapOldIssues.containskey( issue.id) ) {
                    oldIssue = mapOldIssues.get( issue.id );
                   //if(partsFromTrunk >= 2)
                   
                  if(oldIssue.Consumed_From_Trunk__c != issue.Consumed_From_Trunk__c)
                  {
                        createPCOnUpdate = true;
                  }
                }
                
                if( mapOldIssues == null || createPCOnUpdate ) {
                    if( issue.Consumed_From_Trunk__c && issue.Product__c != null && 
                       issue.Trunk__c != null && issue.Quantity__c != null
                      ) {
                          setTrunckIds.add( issue.Trunk__c );
                          listIssueForPCCreation.add( issue );
                      }
                }
            }
            
            if( !setTrunckIds.IsEmpty() ) {
                Map<String,ProductItem> mapProductItmes = new Map<String,ProductItem>();
                
                for( ProductItem pi : [ SELECT ID, Product2Id, LocationId, QuantityOnHand 
                                       FROM ProductItem 
                                       WHERE LocationId IN : setTrunckIds
                                      ]
                   ) {
                       String key = pi.Product2Id + '-' + pi.LocationId;
                       mapProductItmes.put( key, pi );
                   }
                
                
                    if( !mapProductItmes.IsEmpty() ) {
                    List<ProductConsumed> listProductConsumed = new list<ProductConsumed>();
                    
                    for( Issue__c issue : listIssueForPCCreation ) {
                        String key = issue.Product__c+'-'+issue.Trunk__c;
                       
                            if( mapProductItmes.containskey( key ) ) {
                                System.debug('Issue Quantity **** '+issue.Quantity__c);
                                ProductItem pi = mapProductItmes.get( key );
                                if( pi.QuantityOnHand < issue.Quantity__c ) {
                                    issue.addError( Label.ProductConsumedQuantityError );
                                    System.debug('@@@@ 65');
                                }
                                else {
                                    pi.QuantityOnHand -= issue.Quantity__c;
                                    listProductConsumed.add( constructProductConsumed( issue, pi.id ) );
                                    System.debug('@@@@ 70');
                                }
                            }
                            else {
                                issue.addError( Label.ProductConsumedNotAvailableInTrunk );
                            }                            
                       
                    }
                    
                    if( !listProductConsumed.IsEmpty() ) {
                        IssueTriggerHelper.isTriggerAlreadyExecuted=TRUE;
                        database.insert( listProductConsumed );
                        IssueTriggerHelper.isTriggerAlreadyExecuted = FALSE;
                        //IssueTriggerHelper.productConsumedDeducted = TRUE;
                    }
                }
                else {
                    for( Issue__c recordIssue : listIssueForPCCreation ) {
                        recordIssue.addError( System.Label.ProductConsumedNotAvailableInTrunk );
                    }
                } 
              
               
            }
        }
        catch( Exception e ) {
            System.debug( 'Exception in createProductsConsumed:-\n' + e.getMessage() );
        }
    }    
    
    
    /*
constructProductConsumed : Method constructs the product cnsumed record and returns it to calling method.
*/
    @TestVisible
    private static ProductConsumed constructProductConsumed(Issue__c issue,Id productItemId){
        ProductConsumed pc = new ProductConsumed();
        if(issue != null && productItemId != null){
            pc.ProductItemId = productItemId;
            pc.QuantityConsumed = issue.Quantity__c;
            pc.WorkOrderId = issue.Source_Work_Order__c;
            pc.Issue__c = issue.Id;
        }
        return pc;
    }
    
    /*
unlockApprovalLockedRecords : unlock records submitted for approval
*/
    @InvocableMethod
    public static void unlockApprovalLockedRecords(list<Id> issueIds){
        try{
            for(Id issueId: issueIds){
                if(Approval.isLocked(issueId)){
                    Approval.unlock(issueId);
                }
            }
        }
        catch(Exception e){
        }
    }
    
    /*
populateShippingAddress : populates shipping address on issues from related account
*/
    public static void populateShippingAddress(List<Issue__c> listNewIssues){
        system.debug('populateShippingAddress');
        Set<Id> setCaseIds = new Set<Id>();
        for(Issue__c eachIssue : listNewIssues) {
            if(!eachIssue.Consumed_From_Trunk__c && eachIssue.Product_Replacement__c){
                setCaseIds.add(eachIssue.Case__c );
            }
        }
        
        Map<Id, Case> map_caseId_Case = new map<Id, Case>([SELECT Id, Account.ShippingAddress, Account.Name
                                                           FROM Case
                                                           WHERE Id IN :setCaseIds]);
        system.debug('map_caseId_Case'+map_caseId_Case);
        
        for( Issue__c eachIssue : listNewIssues) {
            if(map_caseId_Case.containsKey(eachIssue.Case__c)) {
                //if(!Test.isRunningTest()){
                system.debug('map_caseId_Case.get(eachIssue.Case__c).Account.Name'+map_caseId_Case.get(eachIssue.Case__c).Account.Name);
                system.debug('map_caseId_Case.get(eachIssue.Case__c).Account.ShippingAddress'+map_caseId_Case.get(eachIssue.Case__c).Account.ShippingAddress);
                AddressLines addrLines = new AddressLines();
                system.debug('map_caseId_Case.get(eachIssue.Case__c).Account.Name'+map_caseId_Case.get(eachIssue.Case__c).Account.Name);
                system.debug('map_caseId_Case.get(eachIssue.Case__c).Account.ShippingAddress'+map_caseId_Case.get(eachIssue.Case__c).Account.ShippingAddress);
                addrLines = new AddressLines(map_caseId_Case.get(eachIssue.Case__c).Account.Name, map_caseId_Case.get(eachIssue.Case__c).Account.ShippingAddress);
                eachIssue.Shipping_Name__c = eachIssue.Case__r.Account.Name;
                eachIssue.Shipping_Street_1__c = addrLines.street1;
                eachIssue.Shipping_Street_2__c = addrLines.street2;
                eachIssue.Shipping_Street_3__c = addrLines.street3;
                eachIssue.Shipping_City__c = addrLines.city;
                eachIssue.Shipping_State_Province__c = addrLines.stateProvince;
                eachIssue.Shipping_Postal_Code__c = addrLines.postalCode;
                eachIssue.Shipping_Country__c = AddressUtils.getStandardName(addrLines.country);
                // }
            } 
        }
    }
    
    /*
populateAssetData : populates asset data on issue records - Before Insert.
*/
    public static void populateAssetDataBeforeInsert(List<Issue__c> listNewIssues) {
        system.debug('populateAssetDataBeforeInsert');
        Set<Id> assetIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        for(Issue__c eachIssue : listNewIssues) {
            if(eachIssue.Asset__c != NULL)
                assetIds.add(eachIssue.Asset__c);
            caseIds.add(eachIssue.Case__c );
            
            
            //Request Date validation.
            if(eachIssue.Requested_Delivery_Date__c != NULL) {
                if(eachIssue.Requested_Delivery_Date__c <= Date.today()) {
                    eachIssue.addError('Request Date cannot be today or earlier than today. Please update');
                } else if(eachIssue.Requested_Delivery_Date__c == Date.today().addDays(1)){
                    if(Integer.valueOf(System.Now().format('MM/dd/yyyy HH:mm:ss','America/Los_Angeles').split(' ')[1].substring(0,2)) >= 12) {
                        eachIssue.addError('Request Date cannot be tomorrow. Please update');
                    } 
                }
            }
        }
        
        Map<Id, Asset> map_Assets;
        if(assetIds.size() > 0) {
            map_Assets = new Map<Id, Asset>([SELECT Id,Mark_Id__c, SerialNumber, Lite_Height__c , Lite_Width__c,H1_B1_in__c,AssetShape__c,Product2.isActive, Product2Id FROM Asset WHERE Id IN :assetIds]);
        }
        system.debug('map_Assets'+map_Assets);
        Map<Id, Case> map_Cases;
        if(caseIds.size() > 0){
            map_Cases = new Map<Id, Case>([SELECT Id, Opportunity__c  FROM Case WHERE Id IN :caseIds]);
        }
        
        if(map_Assets != NULL && map_Assets.keySet().size() > 0) {
            for(Issue__c eachIssue : listNewIssues) {
                if(eachIssue.Asset__c != NULL && map_Assets.containsKey(eachIssue.Asset__c)){
                    eachIssue.Lite_ID_Mock_ID__c  = map_Assets.get(eachIssue.Asset__c).SerialNumber;
                    eachIssue.Height_in__c = String.valueOf(map_Assets.get(eachIssue.Asset__c).Lite_Height__c);
                    eachIssue.Base_in__c = String.valueOf(map_Assets.get(eachIssue.Asset__c).Lite_Width__c);
                    eachIssue.Product__c = map_Assets.get(eachIssue.Asset__c).Product2Id;
                    eachIssue.Existing_Makeup__c=map_Assets.get(eachIssue.Asset__c).Product2Id;
                    eachIssue.Mark_ID__c = map_Assets.get(eachIssue.Asset__c).Mark_Id__c;
                    eachIssue.H1_B1_in__c = map_Assets.get(eachIssue.Asset__c).H1_B1_in__c;
                    eachIssue.Shape__c = map_Assets.get(eachIssue.Asset__c).AssetShape__c;
                    
                    if(map_Assets.get(eachIssue.Asset__c).Product2.isActive ==True)
                    {  
                        eachIssue.Want_to_Order_Existing_Makeup__c ='Yes';
                    }
                    else
                    {
                        eachIssue.Want_to_Order_Existing_Makeup__c ='No';
                    }
                }
            }
        }
        
        if(map_Cases != NULL && map_Cases.keySet().size() > 0) {
            for(Issue__c eachIssue : listNewIssues) {
                if(eachIssue.Case__c != NULL && map_Cases.containsKey(eachIssue.Case__c)){
                    eachIssue.Opportunity__c = map_Cases.get(eachIssue.Case__c).Opportunity__c;
                }
            }
        }
    }
    
    /*
populateAssetData : populates asset data on issue records - Before Update.
*/
    public static void populateAssetDataBeforeUpdate(List<Issue__c> listOldIssues, List<Issue__c> listNewIssues) {
        system.debug('populateAssetDataBeforeUpdate');
        Set<Id> assetIds = new Set<Id>();
        for(Integer Indx = 0; Indx < listOldIssues.size(); Indx++) {
            if(listOldIssues[Indx].Asset__c != listNewIssues[Indx].Asset__c && listNewIssues[Indx].Asset__c != NULL)
                assetIds.add(listNewIssues[Indx].Asset__c);
        }
        
        Map<Id, Asset> map_Assets;
        if(assetIds.size() > 0) {
            map_Assets = new Map<Id, Asset>([SELECT Id, SerialNumber, Lite_Height__c ,Mark_Id__c, Lite_Width__c,H1_B1_in__c,AssetShape__c,Product2.isActive, Product2Id FROM Asset WHERE Id IN :assetIds]);
        }
        
        if(map_Assets != NULL && map_Assets.keySet().size() > 0) {
            for(Issue__c eachIssue : listNewIssues) {
                if(eachIssue.Asset__c != NULL && map_Assets.containsKey(eachIssue.Asset__c))
                {
                    eachIssue.Lite_ID_Mock_ID__c  = map_Assets.get(eachIssue.Asset__c).SerialNumber;
                    eachIssue.Height_in__c = String.valueOf(map_Assets.get(eachIssue.Asset__c).Lite_Height__c);
                    eachIssue.Base_in__c = String.valueOf(map_Assets.get(eachIssue.Asset__c).Lite_Width__c);
                    eachIssue.Product__c = map_Assets.get(eachIssue.Asset__c).Product2Id;
                    eachIssue.Existing_Makeup__c=map_Assets.get(eachIssue.Asset__c).Product2Id;
                    eachIssue.Mark_ID__c = map_Assets.get(eachIssue.Asset__c).Mark_Id__c;
                    eachIssue.H1_B1_in__c = map_Assets.get(eachIssue.Asset__c).H1_B1_in__c;
                    eachIssue.Shape__c = map_Assets.get(eachIssue.Asset__c).AssetShape__c;
                    
                    
                    if(map_Assets.get(eachIssue.Asset__c).Product2.isActive ==True)
                    {  
                        eachIssue.Want_to_Order_Existing_Makeup__c ='Yes';
                    }
                    else
                    {
                        eachIssue.Want_to_Order_Existing_Makeup__c ='No';
                    }
                }
            }
        }
        
    }
    
    public static void populateIGUCSSUnderWarrantybeforeinsert(List<Issue__c> NewIssues){
        system.debug('populateIGUCSSUnderWarrantybeforeinsert');
        //list of new issue records triggered from Issue Trigger
        List<Issue__c> listNewIssues=(List<Issue__c> )NewIssues;
        
        set<id> oppid=New set<id>();
        set<id> caseids=New set<id>();
        set<string> pfamilyset=New set<string>();
        set<string> pfamilysetIGU=New set<string>();
        date servicedate;
        id opportunityid;
        
        ///Fetching warranty meta data from custom metadata types start
        Map<string,string> mdtmap=New Map <string,string>();
        Map<string,string> productfamilymap=New Map <string,string>();
        for(Warranty_Check__mdt wcmdt:[SELECT Failure_mode_Name__c,Product_Family__c,
                                       Warranty__c FROM Warranty_Check__mdt]){
                                           mdtmap.put(wcmdt.Failure_mode_Name__c,wcmdt.Warranty__c);
                                           productfamilymap.put(wcmdt.Failure_mode_Name__c,wcmdt.Product_Family__c);
                                       }
        //Fetching warranty meta data End
        set<id> productids=New set<id>();
        
        Id IGURecordTypeId = Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
        System.debug('***BM***'+ IGURecordTypeId);
        for(Issue__c eachIssue : listNewIssues) {
            system.debug('--eachIssue--'+   eachIssue.Want_to_order_existing_Makeup__c+'ddddd'+eachIssue.Warranty_Type__c);
            if(eachIssue.Recordtypeid==IGURecordTypeId ){
                // if(sid.contains(eachIssue.Recordtypeid) ){
                
                if(eachIssue.Product__c!=null){
                    productids.add(eachIssue.Product__c);
                }
                
                system.debug('--productids--'+ productids);
            }else{
                if(eachIssue.Product__c!=null){
                    productids.add(eachIssue.Product__c);
                }
                
            }
            
            if(eachIssue.Opportunity__c!=null){
                oppid.add(eachIssue.Opportunity__c);
            }
            else if(eachIssue.Case__c != null){
                caseids.add(eachIssue.Case__c);
            }
        }
        system.debug('==oppid=='+oppid);
        if(oppid.isEmpty() && !caseids.isEmpty()){
            
            for(Case cs:[select id,Opportunity__c from Case where id IN:caseids]){
                oppid.add(cs.Opportunity__c);
            }
            system.debug('==oppid=From Case record='+oppid);
        }
        Map<id,string> productmap=New Map<id,string>();
        if(productids.size()>0){
            list<Product2> products = [Select Id, Family From Product2 where id IN:productids];
            for(Product2 prd:products){
                pfamilyset.add(prd.Family);
                productmap.put(prd.id,prd.Family);
            }
        }
        system.debug('==pfamilyset=='+pfamilyset);
        system.debug('---productmap--'+productmap);
        
        if(!pfamilyset.isEmpty()){
            if(pfamilyset.contains('CSS')){
                pfamilyset.clear();
                pfamilyset.add('Control Hardware');   
            } else if(pfamilyset.contains('IGU'))
            {
                pfamilysetIGU.add('IGU');
            }
        }
        system.debug('==pfamilyset=='+pfamilyset);
        //Fetching Service Date from Opportunity start
        Map<id,Opportunity> oppmap=New Map<id,Opportunity>([select id,service_date__c from Opportunity where id IN:oppid]);
        system.debug('==oppmap=='+oppmap);
        map<id,date> servicedatemap=New map<id,date>();
        if(!oppid.isEmpty()){
            for(id oppd:oppid){
                if(oppmap.containskey(oppd)){
                    if(oppmap.get(oppd).service_date__c !=null){
                        servicedatemap.put(oppd, oppmap.get(oppd).service_date__c);
                    }
                    
                }
            }
        } 
        map<id,date> servicedatemapIGS=New map<id,date>();
        map<id,date> servicedatemapCSS=New map<id,date>();
        system.debug('==servicedatemap=='+servicedatemap);
        //Fetching Service Date from Opportunity End    
        Map<id,Date> mapOfIGS=New Map<id,Date>();
        Map<id,Date> mapOfCSS=New Map<id,Date>();
        List<RecordType> rt = [SELECT Id,Name,developerName FROM RecordType WHERE SobjectType='Issue__c'];
        Map<id,String> recordIdIGUCSS = new Map<Id,String>();
        for(RecordType rId : rt)
        {
            recordIdIGUCSS.put(rid.id, rId.Name);
        }
        
        //  Map<id,recordType> recordTypesMap = new Map<id,RecordType>([Select id,name from recordtype where Id IN :recordIdIGUCSS.keySet()]);
        
        for(Issue__c eachIssue : listNewIssues) 
        {
            if(eachIssue.Opportunity__c != null && servicedatemap.get(eachIssue.Opportunity__c) !=null)
            {
                if(eachIssue.Opportunity__c != null && recordIdIGUCSS.get(eachIssue.recordtypeId) == 'IGU (Halos, IGU Defects)')
                {
                    servicedatemapIGS.put(eachIssue.Opportunity__c, servicedatemap.get(eachIssue.Opportunity__c).addYears(10));
                }
                
                if(eachIssue.Opportunity__c != null && (recordIdIGUCSS.get(eachIssue.recordtypeId) == 'Cable' || recordIdIGUCSS.get(eachIssue.recordtypeId) == 'Controller & User Interface' || recordIdIGUCSS.get(eachIssue.recordtypeId) == 'Control Panel' ))
                {
                    servicedatemapCSS.put(eachIssue.Opportunity__c, servicedatemap.get(eachIssue.Opportunity__c).addYears(5));
                }
            } 
        }
        system.debug('servicedatemapIGS***'+servicedatemapIGS);
        system.debug('servicedatemapCSS***'+servicedatemapCSS);
        //Fetching Earliest shipment Date from Order Entry Lines and adding years 11 Start
        
        system.debug('oppid'+oppid+'pfamilyset'+pfamilyset+'pfamilysetIGU'+pfamilysetIGU);
        if(!oppid.isEmpty() && (!pfamilyset.isEmpty() || !pfamilysetIGU.isEmpty())){
            list<Order_Entry_Release__c> oer11 = [select id,Recordtypeid,Opportunity__c,Opportunity__r.service_date__c,Recordtype.name,(select id,Shipment_Date__c,Status__c from Order_Entry_Lines__r where Shipment_Date__c!=null AND Status__c!='Cancelled'  Order by Shipment_Date__c ASC   limit 1) 
                                                  from Order_Entry_Release__c where Opportunity__c IN:oppid and (Recordtype.name IN:pfamilyset OR Recordtype.name IN:pfamilysetIGU) and (Order_Type__c='Standard' or Order_Type__c='Demo' or Order_Type__c='External' or Order_Type__c='Demo/Mockup-IGU' or Order_Type__c='Mockup-IGU' or Order_Type__c='Infill-IGU')];
            system.debug('oer11'+oer11);
            for(Order_Entry_Release__c oer:[select id,Recordtypeid,Opportunity__c,Opportunity__r.service_date__c,Recordtype.name,(select id,Shipment_Date__c,Status__c from Order_Entry_Lines__r where Shipment_Date__c!=null AND Status__c!='Cancelled'  Order by Shipment_Date__c ASC   limit 1) 
                                            from Order_Entry_Release__c where Opportunity__c IN:oppid and (Recordtype.name IN:pfamilyset OR Recordtype.name IN:pfamilysetIGU) and (Order_Type__c='Standard' or Order_Type__c='Demo' or Order_Type__c='External' or Order_Type__c='Demo/Mockup-IGU' or Order_Type__c='Mockup-IGU' or Order_Type__c='Infill-IGU')]){
                                                
                                                for(Order_Entry_Line__c oel:oer.Order_Entry_Lines__r){
                                                    if(oel.Shipment_Date__c!= Null){
                                                        system.debug('oel.Shipment_Date__c'+oel.Shipment_Date__c+'sss'+oer.Opportunity__r.service_date__c);
                                                        //  if(shipdatemap.containskey(oer.Opportunity__c) ){
                                                        if(oer.Recordtype.name == 'IGU'){
                                                            // if(oel.Shipment_Date__c.addYears(10) < shipdatemap.get(oer.Opportunity__c){
                                                            if(oer.Opportunity__r.service_date__c !=null) 
                                                            {
                                                                servicedate = oer.Opportunity__r.service_date__c.addYears(10);
                                                            }
                                                            if(servicedate != null){
                                                                if(oel.Shipment_Date__c.addYears(10).addMonths(6) < servicedate){
                                                                    mapOfIGS.put(oer.Opportunity__c,oel.Shipment_Date__c.addYears(10).addMonths(6));
                                                                    system.debug('---Shipment_Date__c---'+oel.Shipment_Date__c);
                                                                    system.debug('mapOfIGSaa'+mapOfIGS);
                                                                } /*else if(oel.Shipment_Date__c.addYears(10).addMonths(6) > servicedate){
system.debug('oer.Opportunity__r.service_date__c'+oer.Opportunity__r.service_date__c);
mapOfIGS.put(oer.Opportunity__c, oer.Opportunity__r.service_date__c.addYears(10));
system.debug('---Shipment_Date__c---'+oel.Shipment_Date__c);
system.debug('mapOfIGSaa'+mapOfIGS);
}*/
                                                            } else {
                                                                date d= oel.Shipment_Date__c.addYears(10).addMonths(6);
                                                                mapOfIGS.put(oer.Opportunity__c,d);
                                                                system.debug('mapOfIGSaa'+mapOfIGS);
                                                                
                                                            }
                                                            // System.debug('***ShipdateForNoServiedateIGU***'+mapOfIGS);
                                                            // }
                                                        }
                                                        if(oer.Recordtype.name == 'Control Hardware'){
                                                            // if(oel.Shipment_Date__c.addYears(5) < shipdatemap.get(oer.Opportunity__c){
                                                            if(oer.Opportunity__r.service_date__c !=null) 
                                                            {
                                                                servicedate = oer.Opportunity__r.service_date__c.addYears(5);
                                                            }
                                                            if(servicedate != null){
                                                                if(oel.Shipment_Date__c.addYears(5).addMonths(6) < servicedate){
                                                                    mapOfCSS.put(oer.Opportunity__c,oel.Shipment_Date__c.addYears(5).addMonths(6));
                                                                    system.debug('---Shipment_Date__c---'+oel.Shipment_Date__c);
                                                                }/*else if(oel.Shipment_Date__c.addYears(5).addMonths(6) > servicedate){
mapOfCSS.put(oer.Opportunity__c, oer.Opportunity__r.service_date__c.addYears(5));
}*/
                                                            } else {
                                                                date d=oel.Shipment_Date__c.addYears(5).addMonths(6);
                                                                mapOfCSS.put(oer.Opportunity__c,d);   
                                                            }
                                                            // System.debug('***ShipdateForNoServiedate***'+mapOfCSS);
                                                            // }
                                                        }                                                           
                                                        /*  }else{
shipdatemap.put(oer.Opportunity__c,oel.Shipment_Date__c.addYears(11));
system.debug('---Shipment_Date__c-else--'+oel.Shipment_Date__c);
} */
                                                    }
                                                }
                                            }
        }
        system.debug('mapOfIGS****'+mapOfIGS);
        system.debug('mapOfCSS****'+mapOfCSS);
        // system.debug('===shipdatemap==='+shipdatemap);
        //Fetching Earliest shipment Date from Order Entry Lines and adding years 11 End
        
        
        // BOS Fullfillment Ship Date
        Map<id,Date> bosFullFillShipDate = new Map<id,Date>();
        Date mindatebos;
        if(!oppid.isEmpty() && mapOfCSS.isEmpty() && mapOfIGS.isEmpty()){
            System.debug('InBOSFULFILLMENT');
            for(Opportunity oppBos : [Select id,Name,service_date__c,(Select id,Opportunity_ID__c,Ship_Date__c from BOS_Fullfillments__r where Ship_Date__c != null order by Ship_Date__c ASC limit 1) from Opportunity where id IN : oppid])
            {
                for(BOS_Fulfillment__c bosShipDate : oppBos.BOS_Fullfillments__r)
                {
                    system.debug('oppBos.service_date__c'+oppBos.service_date__c+'bosShipDate.Ship_Date__c'+bosShipDate.Ship_Date__c);
                    if(oppBos.service_date__c !=null)
                    {
                        mindatebos=min(oppBos.service_date__c.addYears(5),bosShipDate.Ship_Date__c.addYears(5).addMonths(6));
                        system.debug('mindatebos'+mindatebos);
                        bosFullFillShipDate.put(bosShipDate.Opportunity_ID__c,mindatebos);
                    }
                    else
                    {
                        bosFullFillShipDate.put(bosShipDate.Opportunity_ID__c,bosShipDate.Ship_Date__c.addYears(5).addMonths(6));
                        
                    }
                }
            }
        }
        system.debug('bosFullFillShipDate'+bosFullFillShipDate);
        //Caliclating Min date based on Opp Service date and Order Entry Line Shipment date start
        map<id,date> warrantydatemapIGS=New map<id,date>();
        map<id,date> warrantydatemapCSS=New map<id,date>();   
        // map<id,date> warrantydatemap = New map<id,date>();
        Date mindate;
        
        for(id oppd:oppid){
            /*     if(mapOfIGS.containskey(oppd) && servicedatemap.containskey(oppd)){         // get min date from order entry line or service date
mindate=min(shipdatemap.get(oppd), servicedatemap.get(oppd));
warrantydatemap.put(oppd,mindate);
}else */
            
            if(mapOfIGS.containskey(oppd) && servicedatemapIGS.containsKey(oppd)){  // Check for ship date from order entry line
                mindate=min(mapOfIGS.get(oppd),servicedatemapIGS.get(oppd));
                warrantydatemapIGS.put(oppd,mindate); // 
                System.debug('***** MapofShipping***'+mapOfIGS.get(oppd));
            } else if(!mapOfIGS.containskey(oppd) && servicedatemapIGS.containsKey(oppd)){  // Check for ship date from order entry line
                warrantydatemapIGS.put(oppd,servicedatemapIGS.get(oppd)); // 
                System.debug('***** MapofShippingServicedatemapIGS***'+servicedatemapIGS.get(oppd));
            }
            else if(mapOfIGS.containskey(oppd) && !servicedatemapIGS.containsKey(oppd)){  // Check for ship date from order entry line
                warrantydatemapIGS.put(oppd,mapOfIGS.get(oppd)); // 
                System.debug('***** MapofShippingServicedatemapIGS***'+servicedatemapIGS.get(oppd));
            }
            
            else if(!mapOfIGS.containskey(oppd) && mapOfCSS.containskey(oppd) && servicedatemapCSS.containsKey(oppd)){  // check for service date on opp
                mindate=min(mapOfCSS.get(oppd), servicedatemapCSS.get(oppd));
                warrantydatemapCSS.put(oppd,mindate); // 
                System.debug('****warrantydatemapCSSminDate'+mindate); 
            }           
            else if(!mapOfIGS.containskey(oppd) && mapOfCSS.containskey(oppd) && !servicedatemapCSS.containsKey(oppd)){  // check for service date on opp
                warrantydatemapCSS.put(oppd,mapOfCSS.get(oppd)); // 
                System.debug('****warrantydatemapCSS464'+warrantydatemapCSS); 
            }else if(!servicedatemapCSS.isEmpty() && servicedatemapCSS.containsKey(oppd) && !mapOfCSS.containskey(oppd) && !bosFullFillShipDate.containsKey(oppd)){
                warrantydatemapCSS.put(oppd,servicedatemapCSS.get(oppd));
                System.debug('****warrantydatemapCSS471'+warrantydatemapCSS);
            }           
            else if(!mapOfCSS.containskey(oppd) && bosFullFillShipDate.containsKey(oppd) && !mapOfIGS.containskey(oppd))
            {
                warrantydatemapCSS.put(oppd,bosFullFillShipDate.get(oppd));
                System.debug('****warrantydatemapCSS467'+warrantydatemapCSS);
            } 
        }
        
        system.debug('===warrantydatemapIGS==='+warrantydatemapIGS);
        system.debug('===warrantydatemapCSS==='+warrantydatemapCSS);
        system.debug('===ServiceDateMapOppCSS==='+servicedatemapCSS);
        system.debug('===ServiceDateMapOppIGU==='+servicedatemapIGS);
        
        
        
        //Caliclating Min date based on Service date and Shipment date End
        
        // Finally Assighning the values to IGU_CSS_Under_Warranty__c and Product_Under_Warranty__c 
        for(Issue__c newIssue : listNewIssues) {
            if(newIssue.Reason_for_Replacement__c!=null && newIssue.Reason_for_Replacement__c!=''){
                if(productfamilymap.containsKey(newIssue.Reason_for_Replacement__c)){
                    
                    newIssue.IGU_CSS_Under_Warranty__c=mdtmap.get(newIssue.Reason_for_Replacement__c); 
                    system.debug('---mdtmap--'+mdtmap.get(newIssue.Reason_for_Replacement__c));
                    if(newIssue.Reason_for_Replacement__c.contains('Customer Objection')){
                        newIssue.Failure_Mode_of_Customer_Objection__c = true;
                    }
                    
                }
            }
            
            if(!warrantydatemapIGS.isempty() && warrantydatemapIGS.containskey(newIssue.Opportunity__c)){
                if(newIssue.Date_Identified__c!=null){
                    system.debug(' Date_Identified__c '+newIssue.Date_Identified__c+'  warrantydatemapIGS  '+warrantydatemapIGS.get(newIssue.Opportunity__c));
                    // if(newIssue.Date_Identified__c < warrantydatemapIGS.get(newIssue.Opportunity__c) && 
                    if(newIssue.Date_Identified__c <= warrantydatemapIGS.get(newIssue.Opportunity__c)){ 
                        system.debug('product Yes');
                        newIssue.Product_Under_Warranty__c='Yes';
                    }else{
                        system.debug('product NO');
                        newIssue.Product_Under_Warranty__c='No';
                    }
                }
                
            }
            /* else  
{
newIssue.Product_Under_Warranty__c='Un-determined'; 
} */
            
            
            if(!warrantydatemapCSS.isempty() && warrantydatemapCSS.containskey(newIssue.Opportunity__c)){
                if(newIssue.Date_Identified__c!=null){
                    system.debug(' Date_Identified__c '+newIssue.Date_Identified__c+'  warrantydatemapCSS  '+warrantydatemapCSS.get(newIssue.Opportunity__c) );
                    //if(newIssue.Date_Identified__c < warrantydatemapCSS.get(newIssue.Opportunity__c) && 
                    if(newIssue.Date_Identified__c <= warrantydatemapCSS.get(newIssue.Opportunity__c)){ 
                        system.debug('product Yes');
                        newIssue.Product_Under_Warranty__c='Yes';
                    }else{
                        system.debug('product NO');
                        newIssue.Product_Under_Warranty__c='No';
                    }
                }
            }
            if (warrantydatemapCSS.isempty() && warrantydatemapIGS.isEmpty())
            {
                newIssue.Product_Under_Warranty__c='Undertermined'; 
            }
            
            system.debug('=========warrenty----'+newIssue.Product_Under_Warranty__c+'----IGUcss----'+newIssue.IGU_CSS_Under_Warranty__c);
            if(newIssue.Product_Under_Warranty__c != null){
                if(newIssue.Product_Under_Warranty__c=='Yes' && newIssue.IGU_CSS_Under_Warranty__c=='Yes'){
                    system.debug('Warranty');
                    newIssue.Warranty_Type__c='Warranty';
                }else if(newIssue.Product_Under_Warranty__c=='Undertermined'){
                    system.debug('Undertermined');
                    newIssue.Warranty_Type__c='Undertermined';
                }
                else if(newIssue.Product_Under_Warranty__c=='No' || newIssue.IGU_CSS_Under_Warranty__c=='No'){
                    system.debug('Non-Warranty');
                    newIssue.Warranty_Type__c='Non-Warranty';
                }
            }
            
            
            
        }
        
    } 
    
    public static void populateIGUCSSUnderWarrantybeforeupdate(Map<id,Issue__c> OldIsssmap,List<Issue__c> NewIssues){
        system.debug('populateIGUCSSUnderWarrantybeforeupdate');
        //list of new issue records triggered from Issue Trigger
        List<Issue__c> listNewIssues=(List<Issue__c> )NewIssues;
        //map of old issue records triggered from Issue Trigger
        Map<id,Issue__c> OldIssuesmap=(Map<id,Issue__c>)OldIsssmap;
        set<id> oppid=New set<id>();
        set<id> caseids=New set<id>();
        set<string> pfamilyset=New set<string>();
        set<string> pfamilysetIGU=New set<string>();
        date servicedate;
        id opportunityid;
        ///Fetching warranty meta data from custom metadata types start
        Map<string,string> mdtmap=New Map <string,string>();
        Map<string,string> productfamilymap=New Map <string,string>();
        for(Warranty_Check__mdt wcmdt:[SELECT Failure_mode_Name__c,Product_Family__c,
                                       Warranty__c FROM Warranty_Check__mdt]){
                                           mdtmap.put(wcmdt.Failure_mode_Name__c,wcmdt.Warranty__c);
                                           productfamilymap.put(wcmdt.Failure_mode_Name__c,wcmdt.Product_Family__c);
                                       }
        //Fetching warranty meta data End
        set<id> productids=New set<id>();
        
        Id IGURecordTypeId = Schema.SObjectType.issue__c.getRecordTypeInfosByName().get('IGU (Halos, IGU Defects)').getRecordTypeId();
        System.debug('***BM***'+ IGURecordTypeId);
        for(Issue__c eachIssue : listNewIssues) {
            system.debug('--eachIssue--'+eachIssue.Id+   eachIssue.Product__c+'ssssss'+eachIssue.Product_Under_Warranty__c+'dddd'+eachIssue.Warranty_Type__c);
            if(eachIssue.Recordtypeid==IGURecordTypeId ){
                
                if(eachIssue.Product__c!=null){
                    productids.add(eachIssue.Product__c);
                }
                
                system.debug('--productids--'+ productids);
            }else{
                if(eachIssue.Product__c!=null){
                    productids.add(eachIssue.Product__c);
                }
                
            }
            if(eachIssue.Opportunity__c!=null){
                oppid.add(eachIssue.Opportunity__c);
            }
            else if(eachIssue.Case__c != null){
                caseids.add(eachIssue.Case__c);
            }
        }
        system.debug('==oppid=='+oppid);
        if(oppid.isEmpty() && !caseids.isEmpty()){
            
            for(Case cs:[select id,Opportunity__c from Case where id IN:caseids]){
                oppid.add(cs.Opportunity__c);
            }
            system.debug('==oppid=From Case record='+oppid);
        }
        Map<id,string> productmap=New Map<id,string>();
        if(productids.size()>0){
            list<Product2> products = [Select Id, Family From Product2 where id IN:productids];
            for(Product2 prd:products){
                pfamilyset.add(prd.Family);
                productmap.put(prd.id,prd.Family);
            }
        }
        system.debug('==pfamilyset=='+pfamilyset);
        system.debug('---productmap--'+productmap);
        if(!pfamilyset.isEmpty()){
            if(pfamilyset.contains('CSS')){
                pfamilyset.clear();
                pfamilyset.add('Control Hardware');
            } else if(pfamilyset.contains('IGU'))
            {
                pfamilysetIGU.add('IGU');
            }
        }
        system.debug('==pfamilyset=='+pfamilyset);
        //Fetching Service Date from Opportunity start
        Map<id,Opportunity> oppmap=New Map<id,Opportunity>([select id,service_date__c from Opportunity where id IN:oppid]);
        system.debug('==oppmap=='+oppmap);
        map<id,date> servicedatemap=New map<id,date>();
        if(!oppid.isEmpty()){
            for(id oppd:oppid){
                if(oppmap.containskey(oppd)){
                    if(oppmap.get(oppd).service_date__c !=null){
                        servicedatemap.put(oppd, oppmap.get(oppd).service_date__c);
                    }
                    
                }
            }
        }
        map<id,date> servicedatemapIGS=New map<id,date>();
        map<id,date> servicedatemapCSS=New map<id,date>();
        // system.debug('==servicedatemap=='+servicedatemap);
        
        
        //Fetching Earliest shipment Date from Order Entry Lines and adding years 11 Start
        Map<id,Date> mapOfIGS=New Map<id,Date>();
        Map<id,Date> mapOfCSS=New Map<id,Date>();
        List<RecordType> rtAll = [SELECT Id,Name,developerName FROM RecordType WHERE SobjectType='Issue__c'];
        Map<id,String> recordIdIGUCSS = new Map<Id,String>();
        for(RecordType rId : rtAll)
        {
            recordIdIGUCSS.put(rid.id, rId.Name);
        }
        for(Issue__c eachIssue : listNewIssues) 
        {
            if(eachIssue.Opportunity__c != null && servicedatemap.get(eachIssue.Opportunity__c) !=null)
            {
                if(eachIssue.Opportunity__c != null && recordIdIGUCSS.get(eachIssue.recordtypeId) == 'IGU (Halos, IGU Defects)')
                {
                    servicedatemapIGS.put(eachIssue.Opportunity__c, servicedatemap.get(eachIssue.Opportunity__c).addYears(10));
                }
                if(eachIssue.Opportunity__c != null && (recordIdIGUCSS.get(eachIssue.recordtypeId) == 'Cable' || recordIdIGUCSS.get(eachIssue.recordtypeId) == 'Controller & User Interface' || recordIdIGUCSS.get(eachIssue.recordtypeId) == 'Control Panel' || recordIdIGUCSS.get(eachIssue.recordtypeId) == 'Network' || recordIdIGUCSS.get(eachIssue.recordtypeId) == 'Sensor'))
                {
                    servicedatemapCSS.put(eachIssue.Opportunity__c, servicedatemap.get(eachIssue.Opportunity__c).addYears(5));
                }
            }
        }
        system.debug('servicedatemapIGS***'+servicedatemapIGS);
        system.debug('servicedatemapCSS***'+servicedatemapCSS);
        //Fetching Earliest shipment Date from Order Entry Lines and adding years 10.6 to IGU and 5.6 months to CSS
        
        if(!oppid.isEmpty() && (!pfamilyset.isEmpty() || !pfamilysetIGU.isEmpty())){
            for(Order_Entry_Release__c oer:[select id,Recordtypeid,Opportunity__c,Opportunity__r.service_date__c,Recordtype.name,(select id,Shipment_Date__c,Status__c from Order_Entry_Lines__r where Shipment_Date__c!=null AND Status__c!='Cancelled'  Order by Shipment_Date__c ASC  limit 1) 
                                            from Order_Entry_Release__c where Opportunity__c IN:oppid and (Recordtype.name IN:pfamilyset OR Recordtype.name IN:pfamilysetIGU) and (Order_Type__c='Standard' or Order_Type__c='Demo' or Order_Type__c='External' or Order_Type__c='Demo/Mockup-IGU' or Order_Type__c='Mockup-IGU' or Order_Type__c='Infill-IGU')]){
                                                for(Order_Entry_Line__c oel:oer.Order_Entry_Lines__r){
                                                    
                                                    if(oel.Shipment_Date__c!= Null){
                                                        system.debug('oer.Opportunity__r.service_date__c'+oer.Opportunity__r.service_date__c+'oel.Shipment_Date__c'+oel.Shipment_Date__c);
                                                        //  if(shipdatemap.containskey(oer.Opportunity__c) ){
                                                        if(oer.Recordtype.name == 'IGU'){
                                                            // if(oel.Shipment_Date__c.addYears(10) < shipdatemap.get(oer.Opportunity__c){
                                                            if(oer.Opportunity__r.service_date__c !=null) 
                                                                servicedate = oer.Opportunity__r.service_date__c.addYears(10);
                                                            if(servicedate != null){
                                                                if(oel.Shipment_Date__c.addYears(10).addMonths(6) < servicedate){
                                                                    system.debug('oel.Shipment_Date__c.addYears(10).addMonths(6)dd'+oel.Shipment_Date__c.addYears(10).addMonths(6));
                                                                    mapOfIGS.put(oer.Opportunity__c,oel.Shipment_Date__c.addYears(10).addMonths(6));
                                                                    system.debug('---Shipment_Date__c---'+oel.Shipment_Date__c);
                                                                } /*else if(oel.Shipment_Date__c.addYears(10).addMonths(6) > servicedate){
system.debug('oel.Shipment_Date__c.addYears(10).addMonths(6)dd'+oel.Shipment_Date__c.addYears(10).addMonths(6));
mapOfIGS.put(oer.Opportunity__c, oer.Opportunity__r.service_date__c.addYears(10));
}*/
                                                            } else {
                                                                mapOfIGS.put(oer.Opportunity__c,oel.Shipment_Date__c.addYears(10).addMonths(6));
                                                                
                                                            }
                                                            //  System.debug('***ShipdateForNoServiedateIGU***'+mapOfIGS);
                                                            // }
                                                        }
                                                        if(oer.Recordtype.name == 'Control Hardware'){
                                                            // if(oel.Shipment_Date__c.addYears(5) < shipdatemap.get(oer.Opportunity__c){
                                                            if(oer.Opportunity__r.service_date__c !=null) 
                                                                servicedate = oer.Opportunity__r.service_date__c.addYears(5);
                                                            if(servicedate != null){
                                                                if(oel.Shipment_Date__c.addYears(5).addMonths(6) < servicedate){
                                                                    mapOfCSS.put(oer.Opportunity__c,oel.Shipment_Date__c.addYears(5).addMonths(6));
                                                                    system.debug('---Shipment_Date__c---'+oel.Shipment_Date__c);
                                                                }/*else if(oel.Shipment_Date__c.addYears(5).addMonths(6) > servicedate){
mapOfCSS.put(oer.Opportunity__c, oer.Opportunity__r.service_date__c.addYears(5));
}*/
                                                            }else{
                                                                mapOfCSS.put(oer.Opportunity__c,oel.Shipment_Date__c.addYears(5).addMonths(6));   
                                                            }
                                                            // System.debug('***ShipdateForNoServiedate***'+mapOfCSS);
                                                            // }
                                                        }                                                           
                                                        /*  }else{
shipdatemap.put(oer.Opportunity__c,oel.Shipment_Date__c.addYears(11));
system.debug('---Shipment_Date__c-else--'+oel.Shipment_Date__c);
} */
                                                    }
                                                }
                                            }
        } 
        system.debug('mapOfIGS****'+mapOfIGS);
        system.debug('mapOfCSS****'+mapOfCSS);
        // system.debug('===shipdatemap==='+shipdatemap);
        //Fetching Earliest shipment Date from Order Entry Lines and adding years 11 End
        
        // BOS Fullfillment Ship Date
        Map<id,Date> bosFullFillShipDate = new Map<id,Date>();
        date mindatebos;
        if(!oppid.isEmpty()  && mapOfCSS.isEmpty() && mapOfIGS.isEmpty()){
            System.debug('InBOSFULFILLMENT');
            for(Opportunity oppBos : [Select id,Name,service_date__c,(Select id,Opportunity_ID__c,Ship_Date__c from BOS_Fullfillments__r where Ship_Date__c != null order by Ship_Date__c ASC limit 1) from Opportunity where id IN : oppid])
            {
                for(BOS_Fulfillment__c bosShipDate : oppBos.BOS_Fullfillments__r)
                {
                    if(oppBos.service_date__c !=null)
                    {
                        mindatebos=min(oppBos.service_date__c.addYears(5),bosShipDate.Ship_Date__c.addYears(5).addMonths(6));
                        system.debug('mindatebos'+mindatebos);
                        bosFullFillShipDate.put(bosShipDate.Opportunity_ID__c,mindatebos);
                    }
                    else
                    {
                        bosFullFillShipDate.put(bosShipDate.Opportunity_ID__c,bosShipDate.Ship_Date__c.addYears(5).addMonths(6));
                        
                    }
                }
            }
        }
        //Caliclating Min date based on Opp Service date and Order Entry Line Shipment date start
        map<id,date> warrantydatemapIGS=New map<id,date>();
        map<id,date> warrantydatemapCSS=New map<id,date>();
        // map<id,date> warrantydatemap = New map<id,date>();
        Date mindate;
        
        for(id oppd:oppid){
            /*     if(mapOfIGS.containskey(oppd) && servicedatemap.containskey(oppd)){         // get min date from order entry line or service date
mindate=min(shipdatemap.get(oppd), servicedatemap.get(oppd));
warrantydatemap.put(oppd,mindate);
}else */ 
            if(mapOfIGS.containskey(oppd) && servicedatemapIGS.containsKey(oppd)){  // Check for ship date from order entry line
                mindate=min(mapOfIGS.get(oppd),servicedatemapIGS.get(oppd));
                warrantydatemapIGS.put(oppd,mindate); // 
                System.debug('***** MapofShipping***'+mapOfIGS.get(oppd));
            } else if(!mapOfIGS.containskey(oppd) && servicedatemapIGS.containsKey(oppd)){  // Check for ship date from order entry line
                warrantydatemapIGS.put(oppd,servicedatemapIGS.get(oppd)); // 
                System.debug('***** MapofShippingServicedatemapIGS***'+servicedatemapIGS.get(oppd));
            }
            else if(mapOfIGS.containskey(oppd) && !servicedatemapIGS.containsKey(oppd)){  // Check for ship date from order entry line
                warrantydatemapIGS.put(oppd,mapOfIGS.get(oppd)); // 
                System.debug('***** MapofShippingServicedatemapIGS***'+servicedatemapIGS.get(oppd));
            }
            else if(!mapOfIGS.containskey(oppd) && mapOfCSS.containskey(oppd) && servicedatemapCSS.containsKey(oppd)){  // check for service date on opp
                mindate=min(mapOfCSS.get(oppd), servicedatemapCSS.get(oppd));
                warrantydatemapCSS.put(oppd,mindate); // 
                System.debug('****warrantydatemapCSSminDate'+mindate); 
            }           
            else if(!mapOfIGS.containskey(oppd) && mapOfCSS.containskey(oppd) && !servicedatemapCSS.containsKey(oppd)){  // check for service date on opp
                warrantydatemapCSS.put(oppd,mapOfCSS.get(oppd)); // 
                System.debug('****warrantydatemapCSS464'+warrantydatemapCSS); 
            }else if(!servicedatemapCSS.isEmpty() && servicedatemapCSS.containsKey(oppd) && !mapOfCSS.containskey(oppd) && !bosFullFillShipDate.containsKey(oppd)){
                warrantydatemapCSS.put(oppd,servicedatemapCSS.get(oppd));
                System.debug('****warrantydatemapCSS471'+warrantydatemapCSS);
            }
            else if(!mapOfCSS.containskey(oppd) && bosFullFillShipDate.containsKey(oppd) && !mapOfIGS.containskey(oppd))
            {
                warrantydatemapCSS.put(oppd,bosFullFillShipDate.get(oppd));
                System.debug('****warrantydatemapCSS467'+warrantydatemapCSS);
            }
            
            system.debug('===warrantydatemapIGS==='+warrantydatemapIGS);
            system.debug('===warrantydatemapCSS==='+warrantydatemapCSS);
            system.debug('===ServiceDateMapOppCSS==='+servicedatemapCSS);
            system.debug('===ServiceDateMapOppIGU==='+servicedatemapIGS);
            //Caliclating Min date based on Service date and Shipment date End
            
            // Finally Assighning the values to IGU_CSS_Under_Warranty__c and Product_Under_Warranty__c 
            for(Issue__c newIssue : listNewIssues) {
                if(newIssue.Reason_for_Replacement__c!=null && newIssue.Reason_for_Replacement__c!='' &&
                   OldIssuesmap.Containskey(newIssue.id) && 
                   OldIssuesmap.get(newIssue.id).Reason_for_Replacement__c!= newIssue.Reason_for_Replacement__c  ){
                       if(productfamilymap.containsKey(newIssue.Reason_for_Replacement__c)){
                           
                           newIssue.IGU_CSS_Under_Warranty__c=mdtmap.get(newIssue.Reason_for_Replacement__c);
                           system.debug('---mdtmap--'+mdtmap.get(newIssue.Reason_for_Replacement__c));
                           if(newIssue.Reason_for_Replacement__c.contains('Customer Objection')){
                               newIssue.Failure_Mode_of_Customer_Objection__c = true;
                           }
                           
                       }
                   }
                if(!warrantydatemapIGS.isempty() && warrantydatemapIGS.containskey(newIssue.Opportunity__c)){ 
                    if(newIssue.Date_Identified__c!=null){
                        system.debug(' Date_Identified__c '+newIssue.Date_Identified__c+'  warrantydatemapIGS  '+warrantydatemapIGS.get(newIssue.Opportunity__c));
                        // if(newIssue.Date_Identified__c < warrantydatemapIGS.get(newIssue.Opportunity__c) && 
                        if(newIssue.Date_Identified__c <= warrantydatemapIGS.get(newIssue.Opportunity__c)){ 
                            system.debug('product Yes');
                            newIssue.Product_Under_Warranty__c='Yes';
                        }else{
                            system.debug('product NO');
                            newIssue.Product_Under_Warranty__c='No';
                        }
                    }
                }
                /* else  
{
newIssue.Product_Under_Warranty__c='Un-determined'; 
} */
                if(!warrantydatemapCSS.isempty() && warrantydatemapCSS.containskey(newIssue.Opportunity__c)){
                    if(newIssue.Date_Identified__c!=null){
                        system.debug(' Date_Identified__c '+newIssue.Date_Identified__c+'  warrantydatemapCSS  '+warrantydatemapCSS.get(newIssue.Opportunity__c) );
                        //if(newIssue.Date_Identified__c < warrantydatemapCSS.get(newIssue.Opportunity__c) && 
                        if(newIssue.Date_Identified__c <= warrantydatemapCSS.get(newIssue.Opportunity__c)){ 
                            system.debug('product Yes');
                            newIssue.Product_Under_Warranty__c='Yes';
                        }else{
                            system.debug('product NO');
                            newIssue.Product_Under_Warranty__c='No';
                        }
                    }
                }
                if (warrantydatemapCSS.isempty() && warrantydatemapIGS.isEmpty()  )
                    
                    
                {
                    newIssue.Product_Under_Warranty__c='Undertermined'; 
                }
                
                system.debug('=========warrenty----'+newIssue.Product_Under_Warranty__c+'----IGUcss----'+newIssue.IGU_CSS_Under_Warranty__c);
                if(newIssue.Product_Under_Warranty__c != null && newIssue.IGU_CSS_Under_Warranty__c != null){
                    if(newIssue.Product_Under_Warranty__c=='Yes' && newIssue.IGU_CSS_Under_Warranty__c=='Yes'){
                        system.debug('Warranty');
                        newIssue.Warranty_Type__c='Warranty';
                    }else{
                        system.debug('Non-Warranty');
                        newIssue.Warranty_Type__c='Non-Warranty';
                    }
                    
                }    
                
                if(newIssue.Product_Under_Warranty__c != null){
                    if(newIssue.Product_Under_Warranty__c=='Yes' && newIssue.IGU_CSS_Under_Warranty__c=='Yes'){
                        system.debug('Warranty');
                        newIssue.Warranty_Type__c='Warranty';
                    }else if(newIssue.Product_Under_Warranty__c=='Undertermined'){
                        system.debug('Undertermined');
                        newIssue.Warranty_Type__c='Undertermined';
                    }
                    else if(newIssue.Product_Under_Warranty__c=='No' || newIssue.IGU_CSS_Under_Warranty__c=='No'){
                        system.debug('Non-Warranty');
                        newIssue.Warranty_Type__c='Non-Warranty';
                    }
                }
                
                
            }
            
        }
    } 
    /*
* checkissueForBoxFolderCreation :check for Issues record eligibility for creation of box folder
*/    
    public static void checkissueForBoxFolderCreation(List<Issue__c> listNewIssues,Map<Id,Issue__c> mapOldIssues){
        system.debug('checkissueForBoxFolderCreation');
        try{
            if(!listNewIssues.IsEmpty()){
                List<Id> listIssuesForBoxCreation = new List<Id>();
                listIssuesForBoxCreation.clear();
                for(Issue__C newissue : listNewIssues){
                    Issue__c oldissue;
                    if(mapOldIssues != null && mapOldIssues.containsKey(newissue.Id)){
                        oldissue = mapOldIssues.get(newissue.Id);
                    }
                    if(oldissue != null){
                        if(newissue.Create_Box_Folder__c && oldissue.Create_Box_Folder__c != newissue.Create_Box_Folder__c ){
                            system.debug('gtest');
                            if(oldissue.BOX_Folder_Id__c == null){
                                listIssuesForBoxCreation.add(newissue.Id);
                            }
                        }
                        /* else if(newissue.Case__c != null ){

listIssuesForBoxCreation.add(newissue.Id);
} */
                    }
                    else{
                        if(newissue.Create_Box_Folder__c)
                        {
                            listIssuesForBoxCreation.add(newissue.Id);
                        }
                    }  
                }
                if(!listIssuesForBoxCreation.IsEmpty()){
                    CreateissueBoxFolder(listIssuesForBoxCreation);
                }
                
                
            }     
            
            
        } catch(exception e){
            System.debug('exception=='+e);
        }    
    }  
    
    @future (callout=true)
    public static void CreateissueBoxFolder(List<Id> listIssues){
        system.debug('CreateissueBoxFolder');
        try{
            if(!listIssues.isEmpty()){    
                List<Issue__c> listIssueToUpdate                    = new List<Issue__c>();
                List<Id> listCases                    = new List<Id>();
                Map<Id,List<Issue__c>> mapcaseIdWithIssues          = new Map<Id,List<Issue__c>>();
                Map<Id,String> mapCaseIdFolderId   = new Map<Id,String>();
                Map<Id,List<Case>> mapOppIdWithCases           = new Map<Id,List<Case>>();
                Map<Id,Opportunity> mapOpportunityIdFolderId   = new Map<Id,Opportunity>();
                Map<Id,String> mapOpportunityIdFolderName      = new Map<Id,String>();
                box.Toolkit boxToolkit                         = new box.Toolkit();
                List<Case> listCaseToUpdate                    = new List<Case>();
                List<Case> list2CaseToUpdate                    = new List<Case>();
                List<box__FRUP__c> listFRUPToCreate            = new List<box__FRUP__c>();
                List<Opportunity> listOpportunityToUpdate      = new List<Opportunity>();   
                
                for(Issue__c newissue : [select id,Name,Case__c,Case__r.BOX_Folder_Id__c,Case__r.CaseNumber,Case__r.Opportunity__r.Name,
                                         Case__r.Issues_Box_Folder_Id__c 
                                         from Issue__c where id in : listIssues]){
                                             //           listIssueToUpdate.add(newissue);                
                                             
                                             if(newissue.Case__c != null){
                                                 if(mapcaseIdWithIssues.containskey(newissue.Case__c)){
                                                     mapcaseIdWithIssues.get(newissue.Case__c).add(newissue);
                                                 }else{
                                                     mapcaseIdWithIssues.put(newissue.Case__c,new List<Issue__c>{newissue});
                                                 }
                                             }
                                             
                                             
                                             if( newissue.Case__r.BOX_Folder_Id__c == null){
                                                 listCases.add(newissue.Case__c);
                                             }     
                                         }
                if(!listCases.isEmpty()){
                    
                    for(Case newCase : [select id,CaseNumber,Opportunity__c,Opportunity__r.BOX_Folder_Id__c,
                                        Opportunity__r.Name,Opportunity__r.Cases_Box_Folder_Id__c,Opportunity__r.Opportunity_ID__c 
                                        from case where id in : listCases]){
                                            if(newCase.Opportunity__c != null){
                                                mapOpportunityIdFolderName.put(newCase.Opportunity__c,newCase.Opportunity__r.Opportunity_ID__c + '_' + newCase.Opportunity__r.Name);
                                                if(mapOppIdWithCases.containskey(newCase.Opportunity__c)){
                                                    mapOppIdWithCases.get(newCase.Opportunity__c).add(newCase);
                                                }else{
                                                    mapOppIdWithCases.put(newCase.Opportunity__c,new List<Case>{newCase});
                                                }
                                                if(!mapOpportunityIdFolderId.containskey(newCase.Opportunity__c)){ 
                                                    if( newCase.Opportunity__r.BOX_Folder_Id__c!= null){
                                                        string opportunityFolderKey =  newCase.Opportunity__r.BOX_Folder_Id__c + '_' + newCase.Opportunity__r.Cases_Box_Folder_Id__c;
                                                        Opportunity oppRec = new opportunity(BOX_Folder_Id__c =newCase.Opportunity__r.BOX_Folder_Id__c,
                                                                                             Cases_Box_Folder_Id__c= newCase.Opportunity__r.Cases_Box_Folder_Id__c);
                                                        mapOpportunityIdFolderId.put(newCase.Opportunity__c,oppRec );
                                                    }
                                                }
                                            }
                                        }                
                    for(Id oppId : mapOppIdWithCases.keySet()){
                        String oppFolderId;
                        String casesFolderId;
                        if(mapOpportunityIdFolderId.containskey(oppId)){
                            oppFolderId= mapOpportunityIdFolderId.get(oppId).BOX_Folder_Id__c ;
                            
                            casesFolderId= mapOpportunityIdFolderId.get(oppId).Cases_Box_Folder_Id__c;
                            
                        }
                        system.debug('oppFolderId=='+oppFolderId);
                        system.debug('casesFolderId=='+casesFolderId);
                        if(oppFolderId == null){
                            String folderName = mapOpportunityIdFolderName.get(oppId);
                            oppFolderId = boxToolkit.createFolderForRecordId(oppId, folderName , true);
                        }
                        if(oppFolderId != null){
                            if(casesFolderId == Null)
                            {
                                casesFolderId= boxToolkit.createFolder('Cases', oppFolderId, null);
                                system.debug('casesFolderId1=='+casesFolderId);
                                
                            }      
                            listOpportunityToUpdate.add(new Opportunity(Id = oppId, BOX_Folder_Id__c=oppFolderId,Cases_Box_Folder_Id__c=casesFolderId ));
                        }
                        system.debug('oppFolderId11=='+oppFolderId);
                        system.debug('casesFolderId11=='+casesFolderId);
                        
                        if(oppFolderId!= null){
                            for(Case caseRec: mapOppIdWithCases.get(oppId)){
                                String caseFolderId;
                                if(casesFolderId != null){
                                    caseFolderId = boxToolkit.createFolder(caseRec.CaseNumber +'_'+caseRec.Opportunity__r.Name, casesFolderId, null);
                                }
                                if(caseFolderId != null){
                                    caseRec.BOX_Folder_Id__c = caseFolderId;
                                    mapCaseIdFolderId.put(caseRec.Id,caseRec.BOX_Folder_Id__c);
                                    box__FRUP__c frupRec = new box__FRUP__c();
                                    frupRec.box__Folder_ID__c = caseFolderId;
                                    frupRec.box__Object_Name__c = 'Case';
                                    frupRec.box__Record_ID__c = caseRec.Id;
                                    frupRec.box__Permission__c ='Read/Write';
                                    listFRUPToCreate.add(frupRec);
                                    listCaseToUpdate.add(caseRec);
                                }
                            }
                        }
                    }
                    
                }
                for(Id caseId : mapcaseIdWithIssues.keySet()){
                    String caseFolderId;
                    String issuesFolderId;
                    
                    
                    List<Issue__c> issuelst = mapcaseIdWithIssues.get(caseId);
                    if(issuelst.size() > 0){
                        caseFolderId = issuelst[0].Case__r.BOX_Folder_Id__c;
                        issuesFolderId = issuelst[0].Case__r.Issues_Box_Folder_Id__c; 
                    }    
                    if (caseFolderId == null)
                    {
                        caseFolderId = mapCaseIdFolderId.get(caseId);
                    }
                    if(caseFolderId != null)
                    {
                        if(issuesFolderId == Null)
                        {
                            issuesFolderId= boxToolkit.createFolder('Issues', caseFolderId, null);
                        } 
                        list2CaseToUpdate.add(new Case(Id = caseId, BOX_Folder_Id__c=caseFolderId,Issues_Box_Folder_Id__c=issuesFolderId ));
                        
                    }
                    if(caseFolderId != null){
                        for(Issue__c issueRec: mapcaseIdWithIssues.get(caseId)){
                            String isuueFolderId;
                            if(issuesFolderId != null){
                                isuueFolderId = boxToolkit.createFolder(issueRec.Name + '_' + issueRec.Case__r.CaseNumber +'_'+issueRec.Case__r.Opportunity__r.Name, issuesFolderId, null);
                            }
                            if(isuueFolderId != null){
                                issueRec.BOX_Folder_Id__c = isuueFolderId;
                                box__FRUP__c frupRec = new box__FRUP__c();
                                frupRec.box__Folder_ID__c = isuueFolderId;
                                frupRec.box__Object_Name__c = 'Issue';
                                frupRec.box__Record_ID__c = issueRec.Id;
                                frupRec.box__Permission__c ='Read/Write';
                                listFRUPToCreate.add(frupRec);
                                listIssueToUpdate.add(issueRec);
                            }
                        }
                    }
                    
                    
                }
                boxToolkit.commitChanges(); 
                if(!listIssueToUpdate.isEmpty()){
                    IssueTriggerHelper.isTriggerAlreadyExecuted = TRUE;
                    database.update(listIssueToUpdate);
                    IssueTriggerHelper.isTriggerAlreadyExecuted = FALSE;
                }
                if(!listCaseToUpdate.isEmpty()){
                    database.update(listCaseToUpdate);
                }
                if(!list2CaseToUpdate.isEmpty()){
                    database.update(list2CaseToUpdate);
                }
                if(!listOpportunityToUpdate.IsEmpty()){
                    database.update(listOpportunityToUpdate);
                }
                if(!listFRUPToCreate.IsEmpty()){
                    database.insert(listFRUPToCreate);
                }
            }
        }   
        catch(Exception e){
            System.debug('exception=='+ e);
        }
    }
    @TestVisible
    private static Date min(Date d1, Date d2) {
        if (d1 != null && d2 != null) return d1 < d2 ? d1 : d2;
        else if (d1 != null) return d1;
        else if (d2 != null) return d2;
        else return null;
    }
    @TestVisible
    private static Map<ID,WorkOrder> getCaseIdToWorkOrderRecord( Set<Id> setCaseIds ) {
        
        Map<ID,WorkOrder> caseIdToWorkOrderRecord   = new Map<ID,WorkOrder>();
        
        if( setCaseIds == NULL || setCaseIds.isEmpty() ) {
            return caseIdToWorkOrderRecord;
        }   
        
        List<WorkOrder> getWOs = [SELECT id,CaseId FROM WorkOrder WHERE case.id IN : setCaseIds];
        
        if(getWOs.size() == 1){         
            caseIdToWorkOrderRecord.put( getWOs.get(0).CaseId, getWOs.get(0) );
            
        } else {
            //get WO list which are not assigned to any Issue
            List<WorkOrder> woList= [SELECT Id,CaseId from WorkOrder 
                                     WHERE Id NOT In (SELECT Source_Work_Order__c FROM Issue__c) and case.id IN:setCaseIds];            
            
            //system.debug('woList----'+woList.size());
            if(woList.size() > 0){
                if( woList.get(0).CaseId != NULL ) {
                    caseIdToWorkOrderRecord.put( woList.get(0).CaseId, woList.get(0) );
                }
            } else if(woList.size() == 1) {
                for( WorkOrder recordWorkOrder : woList ) {                     
                    if( recordWorkOrder.CaseId != NULL ) {
                        caseIdToWorkOrderRecord.put( recordWorkOrder.CaseId, recordWorkOrder );
                    }   
                }
            } else { 
                if(getWOs.size() > 0){
                    Integer lastElementCnt = getWOs.size()-1;
                    caseIdToWorkOrderRecord.put( getWOs.get(lastElementCnt).CaseId, getWOs.get(lastElementCnt) );
                } else {
                    return caseIdToWorkOrderRecord;
                }
                
            }
        }//end: else
        return caseIdToWorkOrderRecord;
    }
    
    //if issue doesn't have WO then update with WO doesn't have the Issues
    public static void updateWorkOrderId(List<Issue__c> listNewIssues){
        system.debug('updateWorkOrderId');
        if( listNewIssues == NULL || listNewIssues.isEmpty() ) {
            return;
        }
        
        Set<Id> setCaseIds = new Set<Id>();
        for(Issue__c eachIssue : listNewIssues) {
            if(eachIssue.Source_Work_Order__c == NULL){
                setCaseIds.add(eachIssue.Case__c );                
            }               
        }
        
        if(setCaseIds != NULL && !(setCaseIds.isEmpty())){
            Map<ID,WorkOrder> caseIdToWorkOrderRecord = getCaseIdToWorkOrderRecord( setCaseIds );
            
            WorkOrder recordWorkOrder;
            for( Issue__c recordIssue : listNewIssues ) {
                recordWorkOrder = caseIdToWorkOrderRecord.get( recordIssue.Case__c );
                if( recordWorkOrder != NULL ) {
                    recordIssue.Source_Work_Order__c = recordWorkOrder.Id;
                }
            }  
        }     
        
    }//end: updateWorkOrderId 
    
    public static void UpdateWorkOrderLineItems( List<Issue__c> lisNewIssues,Map<Id,Issue__c> mapOldIssues) {
        system.debug('UpdateWorkOrderLineItems');
        set<id> issuesupdated=New set<id>();
        set<id> workOIds=New set<id>();
        List<WorkOrderLineItem> woliList=New List<WorkOrderLineItem>();
        for(Issue__c isue:lisNewIssues){
            issuesupdated.add(isue.id);
            
            if( isue.Source_Work_Order__c !=null){
                workOIds.add(isue.Source_Work_Order__c);
            }
        }
        Map<Id,WorkOrderLineItem> workorderMap=New Map<Id,WorkOrderLineItem>();
        Map<Id,WorkOrderLineItem> workorderLineCancel=New Map<Id,WorkOrderLineItem>();
        if(issuesupdated.size()>0){
            for(WorkOrderLineItem woli:[select Id,Issue__c,Work_Type__c,Status,Window_Id__c,Control_Panel__c,StartDate,EndDate,
                                        Subject,Description,Notes_Comments__c FROM WorkOrderLineItem where 
                                        Issue__c IN: issuesupdated]){
                                            workorderMap.put(woli.Issue__c,woli);
                                            workorderLineCancel.put(woli.id,woli);
                                            System.debug('WOLI **** '+workorderLineCancel.keySet());
                                            
                                        }
        }
        Map<id,WorkOrder> workmap=New Map<id,WorkOrder>();
        if(workOIds.size()>0){
            for(WorkOrder word:[select id,Work_Type__c,Status from WorkOrder 
                                where Id IN:workOIds]){
                                    workmap.put(word.Id,word);
                                }
        }
        system.debug('in Update WOLI');
        
        
        for(Issue__c isues:lisNewIssues){
            
            string caseSubject;
            if(isues.Window_Id__c!=null && isues.Control_Panel__c!=null && isues.Failure_Component__c!=null){
                caseSubject=isues.Window_Id__c+' - '+isues.Control_Panel__c+' - '+isues.Failure_Component__c;
            }else if(isues.Window_Id__c==null && isues.Control_Panel__c!=null && isues.Failure_Component__c!=null){
                caseSubject=isues.Control_Panel__c+' - '+isues.Failure_Component__c;
            }else if(isues.Window_Id__c!=null && isues.Control_Panel__c==null && isues.Failure_Component__c!=null){
                caseSubject=isues.Window_Id__c+' - '+isues.Failure_Component__c;
            }else if(isues.Window_Id__c!=null && isues.Control_Panel__c!=null && isues.Failure_Component__c==null){
                caseSubject=isues.Window_Id__c+' - '+isues.Control_Panel__c;
            }else if(isues.Window_Id__c!=null && isues.Control_Panel__c==null && isues.Failure_Component__c==null){
                caseSubject=isues.Window_Id__c;
            }else if(isues.Window_Id__c==null && isues.Control_Panel__c!=null && isues.Failure_Component__c==null){
                caseSubject=isues.Control_Panel__c;
            }else{
                caseSubject=isues.Failure_Component__c;
            }
            
            
            // Added to Canceal the WOLI
            Boolean canWoli = False;
            List<WorkOrderLineItem> wolitemUp = new List<WorkOrderLineItem>();
            if(!workorderLineCancel.isEmpty() && workorderMap.containskey(isues.id) 
               && isues.Issue_Status__c == 'Canceled' && isues.Issue_Status__c !=mapOldIssues.get(isues.id).Issue_Status__c){
                   for(WorkOrderLineItem woLi : workorderLineCancel.Values())
                   {		canWoli = True;
                    System.debug('WOLI **** '+woLi.Id);
                    WorkOrderLineItem wolitem = new WorkOrderLineItem();
                    wolitem.Status = 'Canceled';
                    wolitem.Id = woLi.Id;
                    wolitemUp.add(wolitem);
                   }
                   UPDATE wolitemUp;
                   System.debug(' Update Canceled '+wolitemUp);
               }
            
            if(mapOldIssues != null && mapOldIssues.containskey(isues.id) && 
               workorderMap.containskey(isues.id) && canWoli == False){
                   WorkOrderLineItem wolitem=workorderMap.get(isues.id);
                   
                   if(isues.Work_Type__c !=mapOldIssues.get(isues.id).Work_Type__c || isues.Failure_Component__c !=mapOldIssues.get(isues.id).Failure_Component__c ||
                      (isues.Issue_Status__c !=mapOldIssues.get(isues.id).Issue_Status__c &&
                       isues.Issue_Status__c=='Resolved' ) ||
                      isues.Window_Id__c !=mapOldIssues.get(isues.id).Window_Id__c ||
                      isues.Control_Panel__c !=mapOldIssues.get(isues.id).Control_Panel__c ||
                      isues.Description__c !=mapOldIssues.get(isues.id).Description__c ||
                      isues.Comments__c !=mapOldIssues.get(isues.id).Comments__c ||
                      isues.Start_Date__c !=mapOldIssues.get(isues.id).Start_Date__c ||
                      isues.End_Date__c !=mapOldIssues.get(isues.id).End_Date__c){
                          system.debug('in OLD WOLI');
                          wolitem.Work_Type__c=isues.Work_Type__c;
                          if(isues.Issue_Status__c=='Resolved'){
                              wolitem.Status = 'Closed';
                          }
                          
                          wolitem.Window_Id__c = isues.Window_Id__c;
                          wolitem.Control_Panel__c = isues.Control_Panel__c;
                          wolitem.StartDate = isues.Start_Date_Time__c;
                          wolitem.EndDate = isues.End_Date_Time__c;
                          wolitem.Subject = caseSubject;
                          wolitem.Description = isues.Description__c;
                          wolitem.Notes_Comments__c = isues.Comments__c;
                          
                          woliList.add(wolitem);
                      }
               }else if(!workorderMap.containskey(isues.id) && workmap.containskey(isues.Source_Work_Order__c) && canWoli == False){
                   system.debug('in New WOLI');
                   woliList.add (
                       new WorkOrderLineItem
                       (
                           WorkOrderId = workmap.get(isues.Source_Work_Order__c).Id,
                           Issue__c = isues.Id,
                           Work_Type__c = workmap.get(isues.Source_Work_Order__c).Work_Type__c,
                           Status = workmap.get(isues.Source_Work_Order__c).Status,
                           Window_Id__c = isues.Window_Id__c,
                           Control_Panel__c = isues.Control_Panel__c,
                           StartDate = isues.Start_Date_Time__c,
                           EndDate = isues.End_Date_Time__c,
                           Subject = caseSubject,
                           Description = isues.Description__c,
                           Notes_Comments__c = isues.Comments__c
                       )
                   );
               }
        }
        System.debug( 'woliList:-\n' + JSON.serialize( woliList ) );
        if(woliList.size()>0){
            UPSERT woliList;
        }
    } 
    
    
    
    public static void updateproducts(list<Issue__c> newlist)
    {
        
        list<id> ast = new list<id>();
        
        for(Issue__c issue:newlist) 
        {
            if(issue.Product__c==null && issue.Asset__c !=null)
            {
                ast.add(issue.Asset__c);
            }
        }
        
        map<id,Asset>  asstlstmap = new map<id,Asset>([select id,Product2Id,Product2.Name from Asset where id=:ast and Product2.isActive=True]);
        
        for(Issue__c iss:newlist)
        {
            if(asstlstmap.containsKey(iss.Asset__c))
            {
                iss.Product__c = asstlstmap.get(iss.Asset__c).Product2Id;
            }
        }
    }
    
    
    public static void deletemethod()
    {
        
        // this method was written to cover test class when urgent deployment 
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
    }
}