public class CreateQuoteCtrl {
    
    public String selCont {get; set;}
    public List<SelectOption> contOptions {get; set;}
    public Quote qtRec {get; set;}
    public List<Item> qlisList {get; set;}
    public List<QuoteLineItem> qliList {get; set;}
    public Integer rowToRemove {get;set;}
    public Boolean showError {get;set;}
    Id oppId = ApexPages.currentPage().getParameters().get('oppid');
    Opportunity opp;
    public String oppPbId {get;set;}
    public String qPbId {get;set;}
    public String pName{ get; set; }
    
    public createQuoteCtrl() {
        showError = false;
        contOptions = new List<SelectOption>();
        qlisList  = new List<Item>();
        qtRec = new Quote();
        qtRec.OpportunityId = oppId;
        opp = [select Name, Pricebook2Id, OwnerId from Opportunity where id = :oppId];
        oppPbId = opp.Pricebook2Id;
        qtRec.Name = opp.Name;
        qtRec.Salesperson__c = opp.OwnerId;
        qtRec.ExpirationDate = Date.today().addMonths(2);
        qtRec.Pricebook2Id = opp.Pricebook2Id;
        qliList = new List<QuoteLineItem>();
        queryContOptions();
        queryProducts(new Set<String>{'All-In'});
    }
    
    public PageReference doSave() {
        qtRec.ContactId = selCont;
        qtRec.Partner_Contact__c = selCont;
        qtRec.Partner_Account__c = [select AccountId from Contact where id = : selCont].Accountid;
        upsert qtRec;
        
        Set<Id> prodIds = new Set<Id>();
        for(Item i :qlisList) {
            i.qli.QuoteId = qtRec.id;
            i.qli.Unit_of_Measure__c = '';
            prodIds.add(i.qli.Product2Id);
        }
        
        List<PricebookEntry> pbeList = [select Product2Id,Product2.Name, Pricebook2Id from PricebookEntry 
                where Product2Id in :prodIds and Pricebook2Id = :opp.Pricebook2Id];
        
        Map<Id, Id> mapProdPbId = new Map<Id, Id>();
        for(PricebookEntry pbe :pbeList) {
            mapProdPbId.put(pbe.Product2Id, pbe.id);
        }
        
        for(Item i :qlisList) {
            if(mapProdPbId != null && mapProdPbId.containsKey(i.qli.Product2Id)) {
                i.qli.PricebookEntryId = mapProdPbId.get(i.qli.Product2Id);
                qliList.add(i.qli); 
            }
        }
        try {
            insert qliList;
        }catch(DMLException de) {
            Integer numErrors = de.getNumDml();
            for( Integer i=0 ; i<numErrors;i++){
                if(de.getDMLType(0).equals(StatusCode.REQUIRED_FIELD_MISSING)){
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This quote has some products that do not have price defined for the selected pricebook '+(de.getDmlIndex(i)+1)));
                }
            }
            return null;
        } 
        catch(Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        return new PageReference('/' + qtRec.id).setRedirect(true);
    }
    
    public void filterProducts() {
        qliList = new List<QuoteLineItem>();
        qlisList  = new List<Item>();
        Set<String> typeSet = new Set<String>();
        if(qtRec.Quote_Type__c != null) {
            //****COMMENTING THIS LINE AS PART OF BOS REFERENCE CHANGES.
            // if(qtRec.Quote_Type__c.contains('BOS')) {    
                //typeSet = returnFamilySet('BOS');
            //}
            if(qtRec.Quote_Type__c.contains('CSS')) {    
                typeSet = returnFamilySet('CSS');
            } else if(qtRec.Quote_Type__c.contains('Glass')) {
                typeSet = returnFamilySet('Glass');
            } else if(qtRec.Quote_Type__c.contains('All-In')) {
                typeSet.add('All-In');
            }
        }
        queryProducts(typeSet);
    }
    
    public void onChangeProd() {
        System.debug('In Method::::'+qlisList);
    }
    
    public Set<String> returnFamilySet(String type) {
        Map<String, Quote_Type_Mapping__c> mcs = Quote_Type_Mapping__c.getAll();
        Set<String> familySet = new Set<String>();
        if(mcs != null && mcs.containsKey(type)) {
            String family = mcs.get(type).Product_Family__c;
            for(String fName :family.split(',')) {
                familySet.add(fName.trim());
            }
        } 
        return familySet;     
    }
    
    public void queryProducts(Set<String> family) {
        String q = 'Select UnitPrice, ListPrice, Product2Id,Product2.Name, Product2.Family, PricebookEntryId, Quantity, Amount_Rollup__c, Quantity_Rollup__c From OpportunityLineItem where OpportunityId = :oppId and Product2.isActive = true ';
        if(!family.contains('All-In')) {
            q += ' and Product2.Family in :family ';
        }
        List<OpportunityLineItem> oliList = Database.query(q);
        for(OpportunityLineItem oli :oliList) {
            QuoteLineItem qli = new QuoteLineItem(
                Unit_of_Measure__c = oli.Product2.Name, 
                Product2Id = oli.Product2Id, 
                UnitPrice = oli.UnitPrice, 
                PricebookEntryId = oli.PricebookEntryId, 
                Quantity = oli.Quantity, 
                Product_Family__c = oli.Product2.Family, 
                Amount_Rollup__c = true, 
                Quantity_Rollup__c = oli.Quantity_Rollup__c
            );
            qlisList.add(new Item(qli, oli.ListPrice));
        }
    }
    
    public void queryContOptions() {
        List<OpportunityContactRole> contRoleList = [select ContactId, Contact.Name from OpportunityContactRole where OpportunityId = :oppId];
        
        if(contRoleList != null && contRoleList.size() > 0) {
            for(OpportunityContactRole cr : contRoleList) {
                contOptions.add(new SelectOption(cr.ContactId, cr.Contact.Name));
            }
        } else {
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'There is no Contact Role on the Opportunity.'));
            showError = true;
        }
    }
    
    public void removeRowFromList(){
        qlisList.remove(rowToRemove);
    }

    public void addNewRowToList(){
        QuoteLineItem qli = new QuoteLineItem (Amount_Rollup__c = true, Quantity_Rollup__c = true);
        qlisList.add(new Item(qli, 0));
    }
    
    public PageReference backToOpp() {
        return new PageReference('/' + oppId);
    }
    
    public class Item{
        public QuoteLineItem qli{get;set;}
        public Decimal listPrice{get;set;}
        
        public Item(QuoteLineItem line, Decimal p){
            qli = line;
            listPrice = p;
        }
    }
}