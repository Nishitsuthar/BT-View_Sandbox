@istest (SEEALLDATA = false)
private class opportunityProductEntryTests {

  static testMethod void theTests(){
      
    boolean SalesProfile = false;
    Id CurUserid;

      
      List<SalesSupportDirector__c> abc = new List<SalesSupportDirector__c>();
    abc.add(new SalesSupportDirector__c(Name = 'Atlanta/Carolinas',User_Name__c = 'Brian Horton'));
    abc.add(new SalesSupportDirector__c(Name = 'Bay Area',User_Name__c = 'Namrata Vora'));
    abc.add(new SalesSupportDirector__c(Name = 'Chicago',User_Name__c = 'Mike Lane'));
    abc.add(new SalesSupportDirector__c(Name = 'Dallas',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'New York',User_Name__c = 'Brian Klansky'));
    abc.add(new SalesSupportDirector__c(Name = 'Hawaii',User_Name__c = 'Lance Murata'));
    abc.add(new SalesSupportDirector__c(Name = 'Houston',User_Name__c = 'Mahesh Tharoor'));
    abc.add(new SalesSupportDirector__c(Name = 'International',User_Name__c = 'Erich Klawuhn'));
    abc.add(new SalesSupportDirector__c(Name = 'Pacific Northwest',User_Name__c = 'Brad Baker'));
    abc.add(new SalesSupportDirector__c(Name = 'Memphis/Mid-South',User_Name__c = 'Brian Horton'));
    insert abc;
    
     Customer_Success_Manager__c csm = new Customer_Success_Manager__c(Name = 'Atlanta/Carolinas', User_Name__c = 'Becky Ohlin');
     insert csm;
     User Usracc = [SELECT id,Name,Profile.Name from USER where id=:userInfo.GetUserId()];
     Id usrId = Usracc.Id;
    
     Account acc=VTestDataUtility_OE.getTestAccount();
     insert acc;
      /* Opportunity Opp =VTestDataUtility_OE.getTestOpportunity(acc.id);
       insert opp;*/
     Id OppRecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Qualified Opportunity').getRecordTypeId();

     Opportunity opp = new Opportunity();
       
        opp.RecordTypeId = OppRecTypId;
        opp.Name = 'Test OppOE1';
        opp.AccountId = acc.Id;
        opp.closeDate = Date.today() + 10;
        opp.StageName = 'Pre-Qualifying-Open';
        opp.Project_Address__c = 'Test address';
        opp.Basis_of_Design__c = 'View';
        opp.Construction_Type__c ='Renovation';
        opp.Install_Status__c = 'None';
        opp.Project_City__c = 'Sanjose';
        opp.Project_State__c = 'CA';
        opp.Project_Country__c = 'United States';
      
        opp.Install_Type__c = 'Sales';
        opp.Support_Region__c = 'Atlanta/Carolinas';
        opp.Target_SE__c = usrId; 
        opp.Construction_Type__c = 'Renovation';
        opp.Project_Building_Size__c = '< 10K';
        opp.Project_Stage__c = 'Land Acquisition';
        opp.Market_Segment__c = 'Multi-Family';
        opp.LeadSource = 'Legacy';
        opp.Approx_glass_quantity__c = 10;
       insert Opp;
       
       Product2 prd2=VTestDataUtility_OE.getTestProduct();
       insert prd2;
       
       if(prd2.Spacer__c != null){
       prd2.Generation__c = '2';
       prd2.Spacer__c = '1/2" 90% Argon';
       prd2.Inboard_Thickness__c = '6MM';
       Update Prd2;
       SalesProfile = True;
       }
       Pricebook2 pb2=VTestDataUtility_OE.getTestPriceBook();
       insert pb2;
       Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
       update standardPricebook;

      // PricebookEntry pbe=VTestDataUtility_OE.getTestPricebookEntry(prd2.id,pb2.id);
       // PricebookEntry pbe=VTestDataUtility_OE.getTestPricebookEntry();
       PricebookEntry pbe = new PricebookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = prd2.Id, UnitPrice = 10, isActive = true);

      insert pbe;
     //  System.assertNotEquals(null,pbe.id);
       OpportunityLineItem oli =VTestDataUtility_OE.getTestOpportunityLineItem(Opp.id,pbe.id);
       insert oli;
     OpportunityLineItemSchedule olis= VTestDataUtility_OE.getTestOpportunityLineItemSchedule(oli.id);
    // insert olis;
        // load the page       
        PageReference pageRef = Page.opportunityProductEntry;
        pageRef.getParameters().put('Id',opp.id);
        Test.setCurrentPageReference(pageRef);
        
        // load the extension
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(opp));
          
        // test 'getChosenCurrency' method
        if(UserInfo.isMultiCurrencyOrganization())
            System.assert(oPEE.getChosenCurrency()!='');
        else
            System.assertEquals(oPEE.getChosenCurrency(),'');

        // we know that there is at least one line item, so we confirm
        System.debug('<<<<'+oPEE.ShoppingCart);
        Integer startCount = oPEE.ShoppingCart.size();
        System.debug('>>>> StartCount' + startCount);
        system.assert(startCount>0);
        
        
        //test search functionality without finding anything
        oPEE.searchString = 'IGU1';
        oPEE.updateAvailableList();
        system.assert(oPEE.AvailableProducts.size()==0);
        
        //test remove from shopping cart
        oPEE.toUnselect = oli.PricebookEntryId;
        oPEE.removeFromShoppingCart();
        system.assert(oPEE.shoppingCart.size()==startCount-1);
        
        //test save and reload extension
        oPEE.onSave();
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(opp));
        System.debug('After removing one oli and click on save' + oPEE.shoppingCart.size());
        System.debug('StartCount >>' + startcount);
        system.assert(oPEE.shoppingCart.size()==startCount-1);
        
        // test search again, this time we will find something
        oPEE.searchString = oli.PricebookEntry.Name;
        oPEE.updateAvailableList();
        
        system.assert(oPEE.AvailableProducts.size()>0);   
        
        IF(oPEE.AvailableProducts.size()<0){
            oPEE.ChangePricebook();
        } 
       
        // test add to Shopping Cart function
        oPEE.toSelect = oPEE.AvailableProducts[0].Id;
        oPEE.addToShoppingCart();
        system.assert(oPEE.shoppingCart.size()==startCount);
                
        // test save method - WITHOUT quanitities and amounts entered and confirm that error message is displayed
        oPEE.onSave();
        system.assert(ApexPages.getMessages().size()>0);
        
           
        // add required info and try save again
        System.debug('oPEE shopping cart' + oPEE.ShoppingCart);
        
        System.debug('oPEE shopping cart size' + oPEE.ShoppingCart.size());

        for(OpportunityLineItem o : oPEE.ShoppingCart){
        if(o.quantity == 0 || o.unitprice == 0 || o.quantity == null || o.unitprice == null){
            o.quantity = 5;
            o.unitprice = 300;}
        }
        oPEE.onSave();
        
        // query line items to confirm that the save worked
        opportunityLineItem[] oli2 = [select Id from opportunityLineItem where OpportunityId = :oli.OpportunityId];
        System.debug('?????oli2'+ oli2);
        System.debug('>>>>>>oli2'+ oli2.size());
        System.debug('<<<<<<startcount'+ startCount);
        
      //  system.assert(oli2.size()==startCount);
        
        // test on new Opp (no pricebook selected) to make sure redirect is happening
       
       Opportunity newOpp = new Opportunity(Name='New Opp',stageName='Pipeline',Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Project_City__c='Sunnyvale',Amount=10,closeDate=System.Today()+30,AccountId=oli.Opportunity.AccountId);
       insert(newOpp);
        
        
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp));    
        oPEE.priceBookCheck();
                
        // final quick check of cancel button
        
       System.assert(oPEE.onCancel()!=NULL);
      
        
        ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        pageRef = Page.opportunityProductRedirect;
        pageRef.getParameters().put('Id',oli2[0].Id);
      
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        opportunityProductRedirectExtension oPRE = new opportunityProductRedirectExtension(new ApexPages.StandardController(oli2[0]));
       
        System.assert(oPRE.redirect()!=null);
            
      
    }
    
      
    
    
}