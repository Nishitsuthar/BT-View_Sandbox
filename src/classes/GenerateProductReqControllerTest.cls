@isTest
public class GenerateProductReqControllerTest {
    
    Public static TestMethod void createProductRequestandLines()
    {
        Account act = new account();
        act.Name = 'View Control HW Spare Parts Inventory';
        act.CurrencyIsoCode = 'USD' ;
        act.Oracle_Customer_Number__c = '123211';
        act.ShippingStreet = '7845 Center Street SW';
        act.ShippingCity   = 'Tumwater';
        act.ShippingState   = 'WA';
        act.ShippingPostalCode  = 'WA';
        act.ShippingCountry ='USA';
        Insert act;
        
        contact contlst = new contact();
        contlst.AccountId = act.id;
        contlst.CurrencyIsoCode = 'USD' ;
        contlst.FirstName='Test';
        contlst.LastName = 'Test Product';
        contlst.MobilePhone = '(763) 516-2499';
        contlst.Phone='(763) 516-2499';
        contlst.Email = 'testcontact@test.com';
        Insert contlst;
                
        Date myDateTime1 = Date.newInstance(2019,10, 20);
                   
        Opportunity opplst = new Opportunity();
        opplst.Name  = 'Test Generate Product';
        opplst.AccountId = act.id;
        opplst.stagename  = 'Bid/Quote';
        opplst.Opportunity_Type__c  = 'Opportunity';
        opplst.Support_Region__c  = 'Bay Area';
        opplst.CloseDate  = myDateTime1;
        opplst.Install_Type__c = 'Sales';
        opplst.Construction_Type__c = 'New Construction';
        opplst.Basis_of_Design__c = 'View';
        opplst.Service_Contract__c = 'Standard Warranty';
        opplst.Market_Segment__c = 'Aviation';
        opplst.Project_Address__c = '7845 Center Street SW';
        opplst.Project_City__c = 'CA';
        opplst.Project_State__c = 'CA';
        opplst.Project_Country__c = 'USA';
        opplst.Project_Zip_Code__c = '68114';
        opplst.CHW_Warranty_Date__c = myDateTime1;
        //opplst.IGU_Warranty_Date__c = myDateTime1;
        Insert opplst;
        
        Building__c blst = new Building__c();
        blst.name = 'TestBuild12';
        blst.CurrencyIsoCode = 'USD';
        Insert blst;
        
        Building_Account__c balst = new Building_Account__c();
        balst.Name   = 'Test Cust Site Rec';
        balst.Account__c = act.id;
        balst.Building__c = blst.id;
        balst.Opportunity__c = opplst.id;
        balst.Stocking_Location__c = false;
        Insert balst;
              
        Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
        
        Product2 newProduct;
        newProduct = new Product2(Name = 'CABLE 2, WC1.6 IGU CABLE, SML CONN-F 5P, SML CONN-M 5PK',
                                   IsActive = true, Family= 'CSS', ProductCode = '380-101522',
                                  Product_SKU__c = '380-101522',
                                  Component_Type__c = '', Controls_Type__c = 'System Hardware',CurrencyIsoCode = 'USD'
                                );
        Insert newProduct;
        
        List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
        for (Product2 prod : [SELECT Id, Product_SKU__c, Name, Generation__c, Shape__c, Inboard_Lite__c,
                         Laminate__c, ProductCode, Family FROM Product2])
        {
            Decimal price = XMath.getRandomInt(1000) * 0.1;
            pbeList.Add(new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = prod.Id,
                                           UnitPrice = price, isActive = true));
        }
        insert pbeList;
        
       list<schema.Location> trunkloc = new list<schema.Location>();
        trunkloc.add(new schema.Location(Name = 'TestprodreqTrunk',
                          LocationType = 'Trunk', IsInventoryLocation = true
                          //Create_Product_Request_for_Trunk_Stock__c = true 
                               ));
        Insert trunkloc;
                       
        case lstcase = new case();
        lstcase.Status = 'New';
        lstcase.AccountId = act.id;
        lstcase.Opportunity__c = opplst.id;
        lstcase.Type = 'System Behavior Issue';
        lstcase.Priority = 'P3';
        Insert lstcase;
                
        Date myDateissue = Date.newInstance(2019,9,30);
        Date reqDDate = Date.newInstance(2030,10,3);
        
        list<Issue__c> objissue = new list<Issue__c>();
        objissue.add(new Issue__c(Issue_Status__c = 'Open', Case__c = lstcase.id, Date_Identified__c = myDateissue,
                               Product_Replacement__c = true, Product__c = newProduct.id,
                               Quantity__c = 1, Trunk__c = trunkloc[0].id,
                               Requested_Delivery_Date__c = reqDDate,
                               Product_Under_Warranty__c = 'Yes'
                                  // Failure_Component__c = 'IGU Cable',
                                  //, Failure_Mode_Under_Warranty__c = 'Yes'
                               //,Failure_Mode_of_Customer_Objection__c = true
                                 ));
        
       objissue.add( new Issue__c(Issue_Status__c = 'Open',  Case__c = lstcase.id, Date_Identified__c = myDateissue,
                               Product_Replacement__c = true, Product__c = newProduct.id, Quantity__c = 1,
                                  Requested_Delivery_Date__c = reqDDate,Product_Under_Warranty__c = 'Yes'
                               // Failure_Component__c = 'IGU Cable',  Trunk__c = trunkloc.id,
                                  //,Failure_Mode_Under_Warranty__c = 'Yes',
                               // Failure_Mode_of_Customer_Objection__c = true
                              ));
        Insert objissue;
        
        Failure_Mode__c objFM ;
        objFM = new Failure_Mode__c(Name = 'Loose Connection', Failure_Component__c = 'IGU Cable', 
                                    In_Warranty__c = true, 
                                    //Check_Trade__c = true, 
                                    Applicable_To__c = 'Field');
        Insert objFM;
        
        Issue_Failure_Mode__c issueFM;
        issueFM = new Issue_Failure_Mode__c(Failure_Mode__c = objFM.id, Issue__c = objissue[0].id,
                                            Failure_Component__c = 'IGU Cable' );
        Insert issueFM;
        
        Issue_Failure_Mode__c issueFM1;
        issueFM1 = new Issue_Failure_Mode__c(Failure_Mode__c = objFM.id, Issue__c = objissue[1].id,
                                            Failure_Component__c = 'IGU Cable' );
        Insert issueFM1;
        Test.startTest();
        
        GenerateProductReqController.getIssues(lstcase.id);
        GenerateProductReqController.createProductRequestandLines(objissue,lstcase.id);
        Test.stopTest();
        
    }
}