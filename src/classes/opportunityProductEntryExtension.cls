// Updated Custom Labels Version 2.0  by NN 08/06/2018

// Product Entry screen
public with sharing class opportunityProductEntryExtension {
    
    public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    public String sGeneration {get;set;}
    public String sProductFamily {get;set;}
    public String sLaminate {get;set;}
    public String sPanes {get;set;}
    public String sShape {get;set;}
    public String sInboardLite {get;set;}
    public String sInboardTreatment {get;set;}  // added on 12/13/2016
    public String sBirdFriendly {get;set;} // added on 02/09/2017
    public String sOutboardLite {get;set;} // added on 03/27/2017
    public String sSpacer {get;set;} // added on 03/27/2017
    public String sInboardThickness {get;set;} // added on 03/27/2017
    
    public opportunityLineItem[] shoppingCart {get;set;}
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}   
    public User Currentusr {get;set;}
    public boolean SalesProfile {get;set;}
    public Id CurUserid {get;set;}
    
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get; set;}
    
    private Boolean forcePricebookSelection = false;
    
    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};
        //added by neelima 
    public List<SelectOption> Generation {get;set;}
    public List<SelectOption> ProductFamily {get;set;}
    public List<SelectOption> Laminate {get;set;}
    public List<SelectOption> Panes {get;set;}
    public List<SelectOption> Shape {get;set;}
    public List<SelectOption> InboardLite {get;set;}
    public List<SelectOption> InboardTreatment {get;set;}
    public List<SelectOption> BirdFriendly {get;set;}
    public List<SelectOption> OutboardLite {get;set;}
    public List<SelectOption> Spacer {get;set;}
    public List<SelectOption> InboardThickness {get;set;}
    
    
    //added to get picklist values and restrict Sales Profile 
    public List<SelectOption> getPickListValues(Schema.DescribeFieldResult departfield , String hidenValues,Boolean allValues){
        List<SelectOption> options = new List<SelectOption>();
        
        //Schema.DescribeFieldResult departfield =  Geography__c.Country__c.getDescribe();
        List<Schema.PicklistEntry> picklist = departfield.getPicklistValues();
        Set<String> setOfStrings = new Set<String>();
        if(String.ValueOf(hidenValues).contains(',')){
            setOfStrings.addAll(String.ValueOf(hidenValues).split(','));
        }else{
            setOfStrings.add( String.ValueOf(hidenValues));
        }
        options.add(new SelectOption('','--None--'));
        for( Schema.PicklistEntry f : picklist){ 
            if(allValues==false&&SalesProfile && setOfStrings.contains(f.getLabel())){   
                options.add(new SelectOption(f.getValue(),f.getLabel()));
            }
            else if(allValues==false&&!SalesProfile && setOfStrings.contains(f.getLabel())){
                options.add(new SelectOption(f.getValue(),f.getLabel()));
            } 
            else if(allValues&& setOfStrings.contains(f.getLabel())){
                //setOfSProductFamily.addAll(String.ValueOf(label.ProductFamily).split(','));
                options.add(new SelectOption(f.getValue(),f.getLabel()));
            }
        }    
        return options;
    }
    public opportunityProductEntryExtension(ApexPages.StandardController controller) 
    {
        // Add 4 lines on 2/1/2018 
        curUserid =  UserInfo.getUserID();
        CurrentUsr = [Select id, Profile.name from User where id =:curUserid ];
        checkProfile();
        
        // added neelima 6/28/2018
        Spacer = new List<SelectOption>();
        Generation = new List<SelectOption>();
        ProductFamily = new List<SelectOption>();
        Laminate = new List<SelectOption>();
        Panes = new List<SelectOption>();
        Shape = new List<SelectOption>();
        InboardLite = new List<SelectOption>();
        InboardTreatment = new List<SelectOption>();
        BirdFriendly = new List<SelectOption>();
        OutboardLite = new List<SelectOption>();
        InboardThickness = new List<SelectOption>();
        
        If(SalesProfile){
            Spacer = getPickListValues(Product2.Spacer__c.getDescribe(),label.Spacer,false);
        }
        else{
            Spacer = getPickListValues(Product2.Spacer__c.getDescribe(),label.SSpacer,false);
        }
        
        If(SalesProfile){
            InboardThickness = getPickListValues(Product2.Inboard_Thickness__c.getDescribe(),label.SInboardThickness,True);
        }
        else{
            InboardThickness = getPickListValues(Product2.Inboard_Thickness__c.getDescribe(),label.InboardThickness,True);
        }  
        If(SalesProfile){
            InboardLite = getPickListValues(Product2.Inboard_Lite__c.getDescribe(),label.SInboardLite,True);
        }
        else{
            InboardLite = getPickListValues(Product2.Inboard_Lite__c.getDescribe(),label.InboardLite,True);
        }  
        Generation = getPickListValues(Product2.Generation__c.getDescribe(),label.Generation,false);
        ProductFamily = getPickListValues(Product2.Family.getDescribe(),label.ProductFamily,true);
        If(SalesProfile){
            Laminate = getPickListValues(Product2.Laminate__c.getDescribe(),label.SLaminate,False);
        }
        else{
            Laminate = getPickListValues(Product2.Laminate__c.getDescribe(),label.Laminate,False);
        } 
        Panes = getPickListValues(Product2.Panes__c.getDescribe(),label.Panes,true);
        Shape = getPickListValues(Product2.Shape__c.getDescribe(),label.Shape,true);
        //InboardLite = getPickListValues(Product2.Inboard_Lite__c.getDescribe(),label.InboardLite,True);
        InboardTreatment = getPickListValues(Product2.Inboard_Treatment__c.getDescribe(),label.InboardTreatment,True);
        BirdFriendly = getPickListValues(Product2.Bird_Friendly__c.getDescribe(),label.BirdFriendly,False);
        OutboardLite = getPickListValues(Product2.Outboard_Lite__c.getDescribe(),label.OutboardLite,True);
        // Need to know if org has multiple currencies enabled
        multipleCurrencies = UserInfo.isMultiCurrencyOrganization();
        //System.assertNotEquals(true,multipleCurrencies );
        // Get information about the Opportunity being worked on
        if(multipleCurrencies){
            theOpp = database.query('select Id, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1');
        }
        else{
            theOpp = [select Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1];
        }
        // If products were previously selected need to put them in the "selected products" section to start with
        shoppingCart = [select Id, Quantity, TotalPrice, UnitPrice, Description, ServiceDate, Shipment_Type__c, PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id, PriceBookEntry.Product2.Generation__c, HasSchedule from opportunityLineItem where OpportunityId=:theOpp.Id AND PriceBookEntry.Product2.IsActive=True];
        
        // Check if Opp has a pricebook associated yet
        if(theOpp.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = new Pricebook2 (id=theOpp.Pricebook2Id,name=theOpp.Pricebook2.Name);//theOpp.Pricebook2;
        }
        
        //if(!forcePricebookSelection)
        //updateAvailableList();
    }
    
    // this is the 'action' method on the page
    public PageReference priceBookCheck()
    {
        // if the user needs to select a pricebook before we proceed we send them to standard pricebook selection screen
        if(forcePricebookSelection){        
            return changePricebook();
        }
        else{
            //if there is only one active pricebook we go with it and save the opp
            if(theOpp.pricebook2Id != theBook.Id){
                try{
                    theOpp.Pricebook2Id = theBook.Id;
                    update(theOpp);
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            return null;
        }
    }
    
    /* Check the profile to restrict specific picklist values  added 2/1/2018 */ 
    public void checkProfile(){
        If(CurrentUsr.Profile.Name == 'Sales Team'){
            SalesProfile = true;
        }
        else{
            SalesProfile = false;
        }
    }
    
    public String getChosenCurrency(){
        if(multipleCurrencies){
            return (String)theOpp.get('CurrencyIsoCode');
        }
        else{
            return '';
        }
    }
    
    public void updateAvailableList() {
        // We dynamically build a query string and exclude items already in the shopping cart
        String qString = 'select Id, Pricebook2Id, IsActive, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice, Product2.ProductCode,Product2.Generation__c,Product2.Laminate__c,Product2.Panes__c,Product2.Shape__c,Product2.Inboard_Lite__c,Product2.Inboard_Treatment__c,Product2.Bird_Friendly__c,Product2.Outboard_Lite__c, Product2.Spacer__c,Product2.Inboard_Thickness__c,Product2.Non_Standard_Product__c from PricebookEntry where Product2.IsActive = true and IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        
        if(multipleCurrencies){
            qstring += ' and CurrencyIsoCode = \'' + theOpp.get('currencyIsoCode') + '\'';
        }
        // note that we are looking for the search string entered by the user in the name OR description
        // modify this to search other fields if desired
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\' or Product2.ProductCode like \'%' + searchString + '%\')';
        }
        if (sGeneration!=null){
            qstring += ' and Product2.Generation__c = \'' + sGeneration + '\'';
        }
        if (sProductFamily!=null && sProductFamily=='IGU' ){   //added if condition by NN 06/25
            qstring += ' and Product2.Family = \'' + sProductFamily + '\'';
            qstring += ' and Product2.Non_Standard_Product__c=false';//introduced this line to filter on product 
            
        }
        else if(sProductFamily!=null){
            qstring += ' and Product2.Family = \'' + sProductFamily + '\'';
        }         
        if (sLaminate!=null){
            qstring += ' and Product2.Laminate__c = \'' + sLaminate + '\'';
        } 
        if (sPanes!=null){
            qstring += ' and Product2.Panes__c = \'' + sPanes + '\'';
        }
        if (sShape!=null){
            qstring += ' and Product2.Shape__c = \'' + sShape + '\'';
        }
        if (sInboardLite!=null){
            qstring += ' and Product2.Inboard_Lite__c = \'' + sInboardLite + '\'';
        }
        if (sInboardTreatment!=null){
            qstring += ' and Product2.Inboard_Treatment__c= \'' + sInboardTreatment + '\'';
        }
        if (sBirdFriendly !=null){
            qstring += ' and Product2.Bird_Friendly__c= \'' + sBirdFriendly + '\'';
        }
        if (sOutboardLite !=null){
            qstring += ' and Product2.Outboard_Lite__c= \'' + sOutboardLite + '\'';
        }
        if (sSpacer !=null){       
            // if(sSpacer =='1/2Argon') { sSpacer='1/2\" 90% Argon'; }
            //if(sSpacer == '1/2Air') { sSpacer='1/2\" Air + Cap Tubes';}
            qstring += ' and Product2.Spacer__c= \'' + sSpacer + '\'';   
        }
        if (sInboardThickness !=null){
            qstring += ' and Product2.Inboard_Thickness__c= \'' + sInboardThickness + '\'';
        }
        qString+= ' order by Product2.Name';
        //   qString+= ' limit 101';  -- commented 11/12/16
        
        AvailableProducts = database.query(qString);
        
        // We only display up to 100 results... if there are more than we let the user know (see vf page)
        /*  if(AvailableProducts.size()==101){   11/12/16
        AvailableProducts.remove(100);
        overLimit = true;
        }
        else{
        overLimit=false;
        } */
    } 
    
    public void addToShoppingCart(){
        // This function runs when a user hits "select" button next to a product
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice));
                break;
            }
        }
        updateAvailableList();  
    }
    
    
    public PageReference removeFromShoppingCart(){
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
        Integer count = 0;
        for(opportunityLineItem d : shoppingCart){
            if((String)d.PriceBookEntryId==toUnselect){
                if(d.Id!=null){
                    forDeletion.add(d);
                }
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
        updateAvailableList();
        return null;
    }
    
    public PageReference onSave(){
        // If previously selected products are now removed, we need to delete them
        if(forDeletion.size()>0){
            delete(forDeletion);
        }
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
            if(shoppingCart.size()>0){
                upsert(shoppingCart);
            }
        }
        catch(Exception e){
            // ApexPages.addMessages(e);
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter quantity'));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }  
        
        // After save return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onCancel(){
        // If user hits cancel we commit no changes and return them to the Opportunity   
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference changePricebook(){
        // This simply returns a PageReference to the standard Pricebook selection screen
        // Note that is uses retURL parameter to make sure the user is sent back after they choose
        
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);
        
        return ref;
    }
    
    
}