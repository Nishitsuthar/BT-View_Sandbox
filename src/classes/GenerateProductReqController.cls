public class GenerateProductReqController {

    @AuraEnabled
    public static List<Issue__c> getIssues(Id caseId) {
        List<Issue__c> issueList= new List<Issue__c>();
        issueList=[SELECT id,Name,Description__c,Requested_Delivery_Date__c,Quantity__c,Issue_Status__c,Product__c,Product__r.Product_SKU__c,Shipping_Country__c,Shipping_State_Province__c,
                                Shipping_City__c,Shipping_Postal_Code__c,Product__r.Name,Product_Code__c,Shipping_Name__c,Shipping_Street_1__c,Shipping_Street_2__c,
                                Shipping_Street_3__c, Order_Type__c,Product_Replacement__c,Product__r.Family,Product_Under_Warranty__c,Warranty_Type__c, Trunk__c,Trunk__r.Name,
                                Shipping_Contact_Name__c, Shipping_Contact_Number__c
                    FROM Issue__c 
                    WHERE Case__c=:caseId AND Issue_Status__c = 'Approved' AND Product_Replacement__c = TRUE 
                    AND Product_Request__c = NULL AND Product__r.Family = 'CSS' AND Warranty_Type__c = 'Warranty'];
                                         
        return issueList;
    }
    
    @AuraEnabled
    public static ResultWrapper createProductRequestandLines(List<Issue__c> issueList,Id caseId) {
        ResultWrapper objResult = new ResultWrapper();
        Savepoint sp;
        try{
            sp = Database.setSavepoint();
            system.debug('issueList' + issueList);
            system.debug('caseId' + caseId);
            Case caseRecord = [SELECT id,Opportunity__c,AccountId,Opportunity__r.Name,Opportunity_ID__c,
                                Account.Name, Account.ShippingAddress,Account.ShippingStreet, Account.ShippingCity,Account.ShippingState, 
                                Account.ShippingPostalCode, Account.ShippingCountry
                                FROM Case where id=:caseId];
            system.debug(caseRecord);
            Account viewInvAcct = [SELECT Id FROM Account WHERE Name = 'View Control HW Spare Parts Inventory' LIMIT 1];
            system.debug('caseRecord.Account.Name==='+caseRecord.Account.Name);
            system.debug('caseRecord.Account.ShippingAddress==='+caseRecord.Account.ShippingAddress);
            AddressLines caseAddrLines = new AddressLines(caseRecord.Account.Name, caseRecord.Account.ShippingAddress);
            Map<String, List<Issue__c>> map_address_Issues = new Map<String, List<Issue__c>>();
            Map<String, AddressWrapper> map_addrKey_Address = new Map<String, AddressWrapper>();
            Map<String, ShippingInfo> map_addrKey_ShippingInfo = new Map<String, ShippingInfo>();
            Map<String, Date> map_addrKey_ReqDelDate = new Map<String, Date>();
            Map<String, Boolean> map_addrKey_IsTrunk = new Map<String, Boolean>();
            for(Issue__c eachIssue : issueList) {
                String addrKey;
                system.debug(eachIssue);
                AddressWrapper addrWrapper;
                if(eachIssue.Trunk__c != NULL) {
                    addrWrapper = new AddressWrapper(viewInvAcct.Id, 'View Control HW Spare Parts Inventory', eachIssue.Shipping_Street_1__c, eachIssue.Shipping_Street_2__c,
                                                    eachIssue.Shipping_Street_3__c, eachIssue.Shipping_City__c, eachIssue.Shipping_State_Province__c,
                                                    eachIssue.Shipping_Country__c, eachIssue.Shipping_Postal_Code__c);
                    /*
                    addrKey = eachIssue.Shipping_Name__c + ':' + eachIssue.Shipping_Street_1__c;
                    if(eachIssue.Shipping_Street_2__c != NULL){ addrKey+= ':' + eachIssue.Shipping_Street_2__c;}
                    if(eachIssue.Shipping_Street_3__c != NULL){ addrKey+= ':' + eachIssue.Shipping_Street_3__c;}
                    if(eachIssue.Shipping_City__c != NULL){ addrKey+= ':' + eachIssue.Shipping_City__c;}
                    if(eachIssue.Shipping_State_Province__c != NULL){ addrKey+= ':' + eachIssue.Shipping_State_Province__c;}
                    if(eachIssue.Shipping_Country__c != NULL){ addrKey+= ':' + AddressUtils.getStandardName(eachIssue.Shipping_Country__c);}
                    if(eachIssue.Shipping_Postal_Code__c != NULL){ addrKey+= ':' + eachIssue.Shipping_Postal_Code__c;}
                    */
                } else {
                    //AddressLines addrLines = new AddressLines(caseRecord.Account.Name, caseRecord.Account.ShippingAddress);
                    addrWrapper = new AddressWrapper(caseRecord.AccountId, eachIssue.Shipping_Name__c, eachIssue.Shipping_Street_1__c, eachIssue.Shipping_Street_2__c,
                                                    eachIssue.Shipping_Street_3__c, eachIssue.Shipping_City__c, eachIssue.Shipping_State_Province__c,
                                                    eachIssue.Shipping_Country__c, eachIssue.Shipping_Postal_Code__c);
                    /*
                    addrWrapper = new AddressWrapper(caseRecord.AccountId, caseRecord.Account.Name, addrLines.street1, addrLines.street2,
                                                    addrLines.street3, addrLines.city, addrLines.stateProvince,
                                                    AddressUtils.getStandardName(addrLines.country), addrLines.postalCode);
                    
                    addrKey = caseRecord.Account.Name + ':' + caseRecord.Account.ShippingStreet;
                    if(caseRecord.Account.ShippingCity != NULL){ addrKey+= ':' + caseRecord.Account.ShippingCity;}
                    if(caseRecord.Account.ShippingState != NULL){ addrKey+= ':' + caseRecord.Account.ShippingState;}
                    if(caseRecord.Account.ShippingCountry != NULL){ addrKey+= ':' + AddressUtils.getStandardName(caseRecord.Account.ShippingCountry);}
                    if(caseRecord.Account.ShippingPostalCode != NULL){ addrKey+= ':' + caseRecord.Account.ShippingPostalCode;}
                    */
                }
                addrKey = eachIssue.Shipping_Name__c + ':' + eachIssue.Shipping_Street_1__c;
                if(eachIssue.Shipping_Street_2__c != NULL){ addrKey+= ':' + eachIssue.Shipping_Street_2__c;}
                if(eachIssue.Shipping_Street_3__c != NULL){ addrKey+= ':' + eachIssue.Shipping_Street_3__c;}
                if(eachIssue.Shipping_City__c != NULL){ addrKey+= ':' + eachIssue.Shipping_City__c;}
                if(eachIssue.Shipping_State_Province__c != NULL){ addrKey+= ':' + eachIssue.Shipping_State_Province__c;}
                if(eachIssue.Shipping_Country__c != NULL){ addrKey+= ':' + AddressUtils.getStandardName(eachIssue.Shipping_Country__c);}
                if(eachIssue.Shipping_Postal_Code__c != NULL){ addrKey+= ':' + eachIssue.Shipping_Postal_Code__c;}
                if(map_address_Issues.containsKey(addrKey)){
                    map_address_Issues.get(addrKey).add(eachIssue);
                } else {
                    map_address_Issues.put(addrKey, new List<Issue__c>{eachIssue});
                    map_addrKey_Address.put(addrKey, addrWrapper);
                    map_addrKey_ShippingInfo.put(addrKey, new ShippingInfo(eachIssue.Shipping_Contact_Name__c, eachIssue.Shipping_Contact_Number__c));
                }
                if(eachIssue.Requested_Delivery_Date__c != NULL) {
                    if(map_addrKey_ReqDelDate.containsKey(addrKey)){
                        if(eachIssue.Requested_Delivery_Date__c < map_addrKey_ReqDelDate.get(addrKey)){
                            map_addrKey_ReqDelDate.put(addrKey, eachIssue.Requested_Delivery_Date__c);
                        }
                    } else {
                        map_addrKey_ReqDelDate.put(addrKey, eachIssue.Requested_Delivery_Date__c);
                    }
                }
                if(eachIssue.Trunk__c != NULL) {
                    map_addrKey_IsTrunk.put(addrKey, TRUE);
                } else {
                    map_addrKey_IsTrunk.put(addrKey, FALSE);
                }
            }
            system.debug('map_address_Issues:' + map_address_Issues);
            
            List<ProductRequest> prList = new List<ProductRequest>();
            for(String eachAddrKey : map_address_Issues.keySet()) {
                ProductRequest pr=new ProductRequest();
                pr.CaseId=caseId;
                pr.Status='Order Processing';
                pr.Type__c='Control Hardware';
                prList.add(pr);
            }

            if(prList.size() > 0) {
                insert prList;
                system.debug('Product Requests After Insert:' + prList);
            }

            Map<Id, String> map_PR_AddrKey = new Map<Id, String>();
            Map<Id, AddressWrapper> map_PR_AddrWrapper = new Map<Id, AddressWrapper>();
            List<String> addressKeys = new List<String>();
            addressKeys.addAll(map_address_Issues.keySet());
            for(Integer Indx =0; Indx < addressKeys.size(); Indx++) {
                map_PR_AddrKey.put(prList[Indx].Id, addressKeys[Indx]);
                if(map_addrKey_Address.containsKey(addressKeys[Indx])) {
                    map_PR_AddrWrapper.put(prList[Indx].Id, map_addrKey_Address.get(addressKeys[Indx]));
                }
            }

            system.debug('map_PR_AddrKey:' + map_PR_AddrKey);
            system.debug('map_PR_AddrWrapper:' + map_PR_AddrWrapper);

            List<ProductRequestLineItem> priList= new List<ProductRequestLineItem>();
            List<Issue__c> issuesUpdated = new List<Issue__c>();
            for(ProductRequest eachPr : prList) {
                if(map_PR_AddrKey.containsKey(eachPr.Id) && map_address_Issues.containsKey(map_PR_AddrKey.get(eachPr.Id))) {
                    for(Issue__c eachIssue : map_address_Issues.get(map_PR_AddrKey.get(eachPr.Id))) {
                        ProductRequestLineItem pril= new ProductRequestLineItem();
                        pril.ParentId=eachPr.id;
                        pril.Product2Id=eachIssue.Product__c;
                        pril.QuantityRequested = eachIssue.Quantity__c == null ? 0 : eachIssue.Quantity__c;
                        pril.Issue__c=eachIssue.id;
                        pril.Order_Type__c=eachIssue.Order_Type__c;
                        priList.add(pril);
                        eachIssue.Product_Request__c=eachPr.id;
                        issuesUpdated.add(eachIssue);
                    }
                }
            }

            if(priList.size() > 0) {
                insert priList;
            }

            Map<Id, Id> map_issueId_PLId = new Map<Id,Id>();
            Map<Id, List<ProductRequestLineItem>> map_PRId_PRLineItems = new Map<Id, List<ProductRequestLineItem>>();
            for(ProductRequestLineItem eachPrLi : priList) {
                if(map_PRId_PRLineItems.containsKey(eachPrLi.ParentId)){
                    map_PRId_PRLineItems.get(eachPrLi.ParentId).add(eachPrLi);
                }else{
                    map_PRId_PRLineItems.put(eachPrLi.ParentId, new List<ProductRequestLineItem>{eachPrLi});
                }

                map_issueId_PLId.put(eachPrLi.Issue__c, eachPrLi.Id);
            }

            system.debug('priList:' + priList);
            

            Map<Id, Issue__c> map_PRLineItem_Issue = new Map<Id, Issue__c>();
            for(Integer Indx = 0; Indx < priList.size(); Indx++) {
                map_PRLineItem_Issue.put(priList[Indx].Id, issuesUpdated[Indx]);
            }

            system.debug('map_PRLineItem_Issue:' + map_PRLineItem_Issue);
            
            List<Order_Entry_Release__c> newOERs = new List<Order_Entry_Release__c>();
            Map<Id, Order_Entry_Release__c> map_PR_OER = new Map<Id, Order_Entry_Release__c>();
            Integer counter = 0;
            for(ProductRequest eachPr : prList) {
                Order_Entry_Release__c oer = new Order_Entry_Release__c();
                oer.Opportunity__c = caseRecord.Opportunity__c;
                oer.Auto_Book_Order__c=true;
                oer.Billing_Account__c=caseRecord.AccountId;
                oer.Name= formatName(caseRecord.Opportunity__c, counter);
                oer.Order_Type__c='Warranty Replacement';
                oer.RecordTypeId='0120h000000QiWlAAK';
                oer.Release_Name__c= 'Parts Request for ' +caseRecord.Opportunity__r.Name;
                oer.Requestor__c = UserInfo.getUserId();
                if(map_PR_AddrKey.containsKey(eachPr.Id) && map_addrKey_ReqDelDate.containsKey(map_PR_AddrKey.get(eachPr.Id))) {
                    oer.Request_Date__c = map_addrKey_ReqDelDate.get(map_PR_AddrKey.get(eachPr.Id));
                    //oer.Promised_Date__c = map_addrKey_ReqDelDate.get(map_PR_AddrKey.get(eachPr.Id));
                    if(Date.today().daysBetween(oer.Request_Date__c) > 5) {
                        oer.Scheduled_Ship_Date__c = oer.Request_Date__c.addDays(-5);
                    } else {
                        oer.Scheduled_Ship_Date__c = Date.today();
                    }
                    oer.Promised_Date__c = oer.Request_Date__c;
                    //oer.Scheduled_Ship_Date__c = map_addrKey_ReqDelDate.get(map_PR_AddrKey.get(eachPr.Id));
                } else {
                    oer.Request_Date__c=Date.today();
                    oer.Scheduled_Ship_Date__c=date.today();
                    oer.Promised_Date__c=Date.today();
                }
                if(map_addrKey_ShippingInfo.containsKey(map_PR_AddrKey.get(eachPr.Id))) {
                    oer.Shipping_Contact_Name__c = map_addrKey_ShippingInfo.get(map_PR_AddrKey.get(eachPr.Id)).contactName;
                    oer.Shipping_Contact_Number__c = map_addrKey_ShippingInfo.get(map_PR_AddrKey.get(eachPr.Id)).contactNumber;
                    
                }
                oer.Sold_to_Account__c=caseRecord.AccountId;
                oer.Shipping_Account__c=caseRecord.AccountId;
                oer.Shipping_Name__c = caseRecord.Account.Name;
                oer.Freight__c = 'Non-Billable';
                /*
                oer.Shipping_Street_1__c = caseAddrLines.street1;
                oer.Shipping_Street_2__c = caseAddrLines.street2;
                oer.Shipping_Street_3__c = caseAddrLines.street3;
                oer.Shipping_City__c = caseAddrLines.city;
                oer.Shipping_State_Province__c = caseAddrLines.stateProvince;
                oer.Shipping_Postal_Code__c = caseAddrLines.postalCode;
                oer.Shipping_Country__c = AddressUtils.getStandardName(caseAddrLines.country);
                */
                if(map_PR_AddrWrapper.containsKey(eachPr.Id)) {
                    oer.Shipping_Street_1__c = map_PR_AddrWrapper.get(eachPr.Id).street1;
                    oer.Shipping_Street_2__c = map_PR_AddrWrapper.get(eachPr.Id).street2;
                    oer.Shipping_Street_3__c = map_PR_AddrWrapper.get(eachPr.Id).street3;
                    oer.Shipping_City__c = map_PR_AddrWrapper.get(eachPr.Id).city;
                    oer.Shipping_State_Province__c = map_PR_AddrWrapper.get(eachPr.Id).state;
                    oer.Shipping_Postal_Code__c = map_PR_AddrWrapper.get(eachPr.Id).postalCode;
                    oer.Shipping_Country__c = map_PR_AddrWrapper.get(eachPr.Id).country;
                }
                if(map_PR_AddrKey.containsKey(eachPr.Id) && map_addrKey_IsTrunk.containsKey(map_PR_AddrKey.get(eachPr.Id)) && map_addrKey_IsTrunk.get(map_PR_AddrKey.get(eachPr.Id)) && map_PR_AddrWrapper.containsKey(eachPr.Id)) {
                    oer.Deliver_To_Account__c = map_PR_AddrWrapper.get(eachPr.Id).accId;
                    oer.Deliver_To_Name__c = map_PR_AddrWrapper.get(eachPr.Id).name;
                    oer.Deliver_To_Street_1__c = map_PR_AddrWrapper.get(eachPr.Id).street1;
                    oer.Deliver_To_Street_2__c = map_PR_AddrWrapper.get(eachPr.Id).street2;
                    oer.Deliver_To_Street_3__c = map_PR_AddrWrapper.get(eachPr.Id).street3;
                    oer.Deliver_To_City__c = map_PR_AddrWrapper.get(eachPr.Id).city;
                    oer.Deliver_To_State_Province__c = map_PR_AddrWrapper.get(eachPr.Id).state;
                    oer.Deliver_To_Postal_Code__c = map_PR_AddrWrapper.get(eachPr.Id).postalCode;
                    oer.Deliver_To_Country__c = map_PR_AddrWrapper.get(eachPr.Id).country;
                }
                newOERs.add(oer);
                map_PR_OER.put(eachPr.Id, oer);
                counter+= 1;
            }
            system.debug('map_PR_OER:' + map_PR_OER);
            if(newOERs.size() > 0) {
                insert newOERs;
            }
            system.debug('newOERs:' + newOERs);

            Set<Id> prIds = new Set<Id>();
            Map<Id, Id> map_PRId_OERId = new Map<Id, Id>();
            for(Integer Indx = 0; Indx < newOERs.size(); Indx++) {
                prList[Indx].Order_Entry_Release__c = newOERs[Indx].Id;
                map_PRId_OERId.put(prList[Indx].Id, newOERs[Indx].Id);
                prIds.add(prList[Indx].Id);
            }
            update prList;
            if(prIds.size() > 0) {
                prList = [SELECT Id, ProductRequestNumber FROM ProductRequest WHERE Id IN :prIds];
            }

            List<Order_Entry_Line__c> oliList= new List<Order_Entry_Line__c>();
            for(ProductRequest eachPr : prList) {
                if(map_PRId_PRLineItems.containsKey(eachPr.Id) && map_PR_OER.containsKey(eachPr.Id)) {   
                    for(ProductRequestLineItem eachPRL : map_PRId_PRLineItems.get(eachPr.Id)) {
                        Order_Entry_Line__c oli= new Order_Entry_Line__c();
                        oli.Order_Entry_Release__c=map_PR_OER.get(eachPr.Id).id;
                        oli.Product__c=eachPRL.Product2Id;
                        oli.Quantity__c=eachPRL.QuantityRequested;
                        oli.Reference_ID__c = eachPr.ProductRequestNumber;
                        oli.Customer_Reference_Description__c = 'Parts Request - '+ eachPr.ProductRequestNumber;
                        oli.RecordTypeId='0120h000000QiWjAAK';
                        oli.Use_Account_Shipping_Address__c = TRUE;
                        if(map_PRLineItem_Issue.containsKey(eachPRL.Id)){
                            oli.SKU__c=map_PRLineItem_Issue.get(eachPRL.Id).Product__r.Product_SKU__c;
                            /*
                            if(map_PR_AddrKey.containsKey(eachPr.Id) && map_addrKey_ReqDelDate.containsKey(map_PR_AddrKey.get(eachPr.Id))) {
                                oli.Request_Date__c = map_addrKey_ReqDelDate.get(map_PR_AddrKey.get(eachPr.Id));
                                oli.Promised_Date__c = map_addrKey_ReqDelDate.get(map_PR_AddrKey.get(eachPr.Id));
                                oli.Scheduled_Ship_Date__c = map_addrKey_ReqDelDate.get(map_PR_AddrKey.get(eachPr.Id));
                            } else {
                                oli.Request_Date__c=Date.today();
                                oli.Scheduled_Ship_Date__c=date.today();
                                oli.Promised_Date__c=Date.today();
                            }
                            */
                            //Dates
                            oli.Request_Date__c = map_PRLineItem_Issue.get(eachPRL.Id).Requested_Delivery_Date__c;
                            if(Date.today().daysBetween(oli.Request_Date__c) > 5) {
                                oli.Scheduled_Ship_Date__c = oli.Request_Date__c.addDays(-5);
                            } else {
                                oli.Scheduled_Ship_Date__c = Date.today();
                            }
                            oli.Promised_Date__c = oli.Request_Date__c;
                            if(map_PRLineItem_Issue.get(eachPRL.Id).Trunk__c != null) {
                                oli.Deliver_To_Account__c = viewInvAcct.Id;
                                oli.Deliver_To_Name__c = map_PRLineItem_Issue.get(eachPRL.Id).Shipping_Name__c;
                                oli.Deliver_To_Street_1__c = map_PRLineItem_Issue.get(eachPRL.Id).Shipping_Street_1__c;
                                oli.Deliver_To_Street_2__c = map_PRLineItem_Issue.get(eachPRL.Id).Shipping_Street_2__c;
                                oli.Deliver_To_Street_3__c = map_PRLineItem_Issue.get(eachPRL.Id).Shipping_Street_3__c;
                                oli.Deliver_To_City__c = map_PRLineItem_Issue.get(eachPRL.Id).Shipping_City__c;
                                oli.Deliver_To_State_Province__c = map_PRLineItem_Issue.get(eachPRL.Id).Shipping_State_Province__c;
                                oli.Deliver_To_Country__c = AddressUtils.getStandardName(map_PRLineItem_Issue.get(eachPRL.Id).shipping_Country__c);
                                oli.Deliver_To_Postal_Code__c = map_PRLineItem_Issue.get(eachPRL.Id).Shipping_Postal_Code__c;
                            } //else {
                                //oli.Deliver_To_Account__c = caseRecord.AccountId;
                                /*
                                oli.Deliver_To_Name__c = caseRecord.Account.Name;
                                oli.Deliver_To_Street_1__c = caseAddrLines.street1;
                                oli.Deliver_To_Street_2__c = caseAddrLines.street2;
                                oli.Deliver_To_Street_3__c = caseAddrLines.street3;
                                oli.Deliver_To_City__c = caseAddrLines.city;
                                oli.Deliver_To_State_Province__c = caseAddrLines.stateProvince;
                                oli.Deliver_To_Country__c = AddressUtils.getStandardName(caseAddrLines.country);
                                oli.Deliver_To_Postal_Code__c = caseAddrLines.postalCode;*/
                            //}
                            
                        }  
                        oliList.add(oli);
                    }       
                }
            }
            system.debug('oliList:' + oliList);
            if(oliList.size() > 0) {
                system.debug('oliList2:');
                insert oliList;
            }
            
            if(issuesUpdated.size() > 0) {
                for(Issue__c eachIssue : issuesUpdated) {
                    eachIssue.Issue_Status__c = 'Order Processing';
                    if(eachIssue.Product_Request__c != NULL && map_PRId_OERId.containsKey(eachIssue.Product_Request__c)){
                        eachIssue.Order_Entry_Release__c = map_PRId_OERId.get(eachIssue.Product_Request__c);
                    }
                    if(map_issueId_PLId.containsKey(eachIssue.Id)) {
                        eachIssue.Product_Request_Line_Item__c = map_issueId_PLId.get(eachIssue.Id);
                    }
                }
                update issuesUpdated;
            }
            
            system.debug('issuesUpdated:' + issuesUpdated);
            
            List<Issue__c> updatedIssues = new List<Issue__c>();
            for(Issue__c eachIssue : issueList) {
                eachIssue.Issue_Status__c = 'Order Processing';
                updatedIssues.add(eachIssue);
            }
            update updatedIssues;

            system.debug('oliList:' + oliList);
            objResult.message = 'ProductRequests have been successfully created';
            objResult.hasError = false;
            system.debug('Product Lines '+ objResult);
            return objResult;
        }
        catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            //throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage());    
            Database.RollBack(sp);
            system.debug('Error line Number---'+e.getLineNumber());
            /*
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                System.debug(e.getDMLMessage(i)); 
            }
            //*/
            //if(e.getNumDml() != null)
            objResult.message = e.getMessage();//e.getMessage();
            //objResult.message = 'Something went wrong. Please contact administrator.';//e.getMessage();
            objResult.hasError = true;
            system.debug('Product Lines Exception '+ objResult);
            return objResult;
        }
        
    }
    
    public class ShippingInfo{
        @AuraEnabled
        public string contactName{get;set;}
        @AuraEnabled
        public string contactNumber{get;set;}
        
        public ShippingInfo(String contactName, String contactNumber){
            this.contactName = contactName;
            this.contactNumber = contactNumber;
        }
    }
    
    public class ResultWrapper{
        @AuraEnabled
        public string message{get;set;}
        @AuraEnabled
        public string prId{get;set;}
        @AuraEnabled
        public string oerId{get;set;}
        @AuraEnabled
        public boolean hasError{get;set;}
    }

    class AddressWrapper{
        @AuraEnabled
        public string accId{get;set;}
        @AuraEnabled
        public string name{get;set;}
        @AuraEnabled
        public string street1{get;set;}
        @AuraEnabled
        public string street2{get;set;}
        @AuraEnabled
        public string street3{get;set;}
        @AuraEnabled
        public string city{get;set;}
        @AuraEnabled
        public string state{get;set;}
        @AuraEnabled
        public string country{get;set;}
        @AuraEnabled
        public string postalCode{get;set;}

        public AddressWrapper(Id accId, String name, String street1, String street2, String street3, String city, String state, String country, String postalCode) {
            this.accId = accId;
            this.name = name;
            this.street1 = street1;
            this.street2 = street2;
            this.street3 = street3;
            this.city = city;
            this.state = state;
            this.country = country;
            this.postalCode = postalCode;
            
        }
    }
    
     public static String formatName(Id oppRecId, Integer counter){
        Integer maxOERNumber = 0;
        Integer oerNum;
        String oerNumStr;
        Opportunity oppRec = [SELECT Id,Opportunity_Id__c FROM Opportunity WHERE Id =: oppRecId];
        for (Order_Entry_Release__c oer : [SELECT Id, CurrencyISOCode, name, Release_Name__c FROM Order_Entry_Release__c 
            WHERE Opportunity__c = : oppRec.Id])
        {
            
            oerNumStr = oer.Name.SubStringAfterLast('-');
            if (oerNumStr != null)
            { 
                oerNum = Integer.valueOf(oerNumStr);
                if (oerNum > maxOERNumber) maxOERNumber = oerNum;
            }
        }
        maxOERNumber++;
        maxOERNumber+= counter;
        oerNumStr = String.valueOf(maxOERNumber);
        if (oerNumStr.length() == 1)
        {
            oerNumStr= '00' + oerNumStr;
        }
        else
        {
            if (oerNumStr.length() == 2)
            {
                oerNumStr = '0' + oerNumStr;
            }
        }
        return oppRec.Opportunity_Id__c + '-' + oerNumStr;
    }
}