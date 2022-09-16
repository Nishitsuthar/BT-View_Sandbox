public class QuoteTriggerHandler {
     /* =================================================================================================
       	Description          : Changed the decimal values for designPrice calculation
       	Modification History : Rekha Talluri 20200616
		Modification History : Srikanth 11/Aug/2020 - Price Change on 218 line
    ====================================================================================================*/ 
        public void sumWinningInfoToRelatedOppty(List<SBQQ__Quote__c> quoteList) {
        Set<Id> bidQuoteRecordtypes = new Set<Id>();
        Map<String, RecordTypeInfo> mapRT = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName();
        bidQuoteRecordtypes.add(mapRT.get('Budgetary_Estimate').getRecordTypeId());
        bidQuoteRecordtypes.add(mapRT.get('Bid_Quote_Locked_Record_Type').getRecordTypeId());
        bidQuoteRecordtypes.add(mapRT.get('Bid_Quote_Locked_Approved').getRecordTypeId());

        System.debug('>>>bidQuoteRecordtypes: '+bidQuoteRecordtypes);
        System.debug('>>>quoteList: '+quoteList);
        Set<Id> opptyId = new Set<Id>();
        for(SBQQ__Quote__c quoteObj : quoteList) {
            if(quoteObj.Related_Opportunity__c != null) {
              opptyId.add(quoteObj.Related_Opportunity__c);
            }
        }
        system.debug('>>> opptyId: '+opptyId);
        List<Opportunity> relatedOpptyList = new List<Opportunity>();
        relatedOpptyList = [Select id, 
                                 RecordTypeId,
                                 (Select id, 
                                         Total_Sq_Feet__c, 
                                         Total_IGU_s_QL__c,
                                         IGU_Total_Amount__c,
                                         BOS_Total_Amount__c,
                                         Exclude_Sync__c
                                   from POC_Budgetary_Estimates__r 
                                   where RecordTypeId IN :bidQuoteRecordtypes
                                   AND Bid_Status__c = 'Won Bid' AND Exclude_Sync__c = false) 
                           from opportunity 
                           where Id IN :opptyId];
         system.debug('>>>relatedOpptyList: '+relatedOpptyList);  
         for(Opportunity opptyObj :relatedOpptyList) {
            decimal totalSqFeet = 0;
            decimal totalIGU = 0;
            decimal totalIGUAmt = 0;
            decimal totalBOSAmt = 0;
            Id opptyMOUSingleRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MOU Single Project Opportunity').getRecordTypeId();
            Id opptyProjectRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
            if(opptyObj.RecordTypeId  == opptyMOUSingleRecordtype || opptyObj.RecordTypeId  == opptyProjectRecordtype) {
                for(SBQQ__Quote__c quoteObj : opptyObj.POC_Budgetary_Estimates__r) {
                    if(quoteObj.Total_Sq_Feet__c != null) {
                        totalSqFeet += quoteObj.Total_Sq_Feet__c;
                    }
                    if(quoteObj.Total_IGU_s_QL__c != null) {
                        totalIGU += quoteObj.Total_IGU_s_QL__c;
                    }
                    if(quoteObj.IGU_Total_Amount__c!= null) {
                        totalIGUAmt += quoteObj.IGU_Total_Amount__c;
                    }
                    if(quoteObj.BOS_Total_Amount__c!= null) {
                        totalBOSAmt += quoteObj.BOS_Total_Amount__c;
                    }
                }
              opptyObj.Winning_Projects_Total_Sq_Ft__c = totalSqFeet;
              opptyObj.Winning_Total_of_IGUs__c = totalIGU;
              opptyObj.IGU_Total_Amount__c = totalIGUAmt;
              opptyObj.Bos_Total_Amount__c = totalBOSAmt;
          }
        }
        system.debug('>>>relatedOpptyList: '+relatedOpptyList);
        if(!Test.isRunningTest())
            update relatedOpptyList;
    }

    /* =================================================================================================
       Description          : calculateBaseCommission is called each time a Quotes are Updated. It
                            : recalculates variable Total Sales Commission for Pricing Quotes 
                            : and if Quote is Primary, for its Opportunity
       @params              : triggerNew - Trigger.New Context; triggerOldmap - Trigger.oldMap Context
       @return              : none 
       Modification History : Jim VanderWall 20190107 - Added method  
    ====================================================================================================*/ 
    
    public void calculateBaseCommission(List<SBQQ__Quote__c> triggerNew, Map<Id, SBQQ__Quote__c> triggerOldMap) {
        Date designWinDate;
        List<SBQQ__Quote__c> pricingApprovals = new List<SBQQ__Quote__c>();
        Set<Id> opptyIds = new Set<Id>();
        Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
        Map<Id, Opportunity> updateOpptys = new Map<Id, Opportunity>();
        List<Sales_Commission_Rate__c> commissionRates = new  List<Sales_Commission_Rate__c>();
        
        Map<String, RecordTypeInfo> mapRT = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName();
        Set<Id> pricingApprovalRecordtypes = new Set<Id>();
        pricingApprovalRecordtypes.add(mapRT.get('Pricing_Quote').getRecordTypeId());
        pricingApprovalRecordtypes.add(mapRT.get('Pricing_Approval_Locked_Record_Type').getRecordTypeId());
        pricingApprovalRecordtypes.add(mapRT.get('Pricing_Approval_Locked_Approved').getRecordTypeId());
        
        for(SBQQ__Quote__c qte : triggerNew) {
            if (pricingApprovalRecordTypes.contains(qte.RecordTypeId)) 
            {
                pricingApprovals.add(qte);
                if (qte.SBQQ__Opportunity2__c != null) {
                    opptyIds.add(qte.SBQQ__Opportunity2__c);
                }
            }
        }
        if (pricingApprovals.size() > 0) {
            // Get the Oppotunities corresponding to the Pricing Approvals
            for(Opportunity oppty : [SELECT Id, Design_Win_Date__c, Total_Sales_Commission__c, Lock_Total_Sales_Commission__c FROM Opportunity where Id IN :opptyIds ]) {
                opptyMap.put(oppty.Id, oppty);
            }
            System.debug('Pricing Approvals: ' + String.valueOf(pricingApprovals));
            // Load the Active Sales Commission Rates; Sort with most recent Rate Schedules, then by the Rate sequence number
            commissionRates = [SELECT Id, Sales_Commission_Rate_Schedule__r.Active__c, Sales_Commission_Rate_Schedule__r.Starting_Date__c, 
                Sales_Commission_Rate_Schedule__r.Ending_Date__c, Active__c, From_Discount__c, To_Discount__c, Sales_Commission_Rate__c, Sales_Commission_Rate_Schedule__c,
                Sequence__c FROM Sales_Commission_Rate__c WHERE Sales_Commission_Rate_Schedule__r.Active__c = TRUE AND Active__c = TRUE 
                ORDER BY Sales_Commission_Rate_Schedule__r.Starting_Date__c DESC, Sequence__c];
            // System.debug('SCR: ' + String.valueOf(commissionRates));

            if (commissionRates.size() > 0) {   
                for (SBQQ__Quote__c qte : pricingApprovals) {
                    if (qte.SBQQ__Opportunity2__c != null && opptyMap.get(qte.SBQQ__Opportunity2__c).Design_Win_Date__c != null) {
                        designWinDate = opptyMap.get(qte.SBQQ__Opportunity2__c).Design_Win_Date__c;
                    }
                    else {
                        designWinDate = Date.today();
                    }
                    System.debug('Design Win Date: ' + String.valueOf(designWinDate));
                    Decimal applicableRate = -1.0;
                    for (Sales_Commission_Rate__c scr : commissionRates) {
                        if ((designWinDate >= scr.Sales_Commission_Rate_Schedule__r.Starting_Date__c && (scr.Sales_Commission_Rate_Schedule__r.Ending_Date__c == null ||  
                            designWinDate < scr.Sales_Commission_Rate_Schedule__r.Ending_Date__c)) && qte.SBQQ__AverageCustomerDiscount__c >= scr.From_Discount__c && 
                            qte.SBQQ__AverageCustomerDiscount__c < scr.To_Discount__c) 
                        {
                            applicableRate = scr.Sales_Commission_Rate__c;
                            break;
                        }                   
                    }
                    if (applicableRate >= 0.0) {
                        qte.Est_Total_Sales_Commission__c = applicableRate;
                        if (qte.SBQQ__Primary__c && qte.SBQQ__Opportunity2__c != null && !opptyMap.get(qte.SBQQ__Opportunity2__c).Lock_Total_Sales_Commission__c) {
                            opptyMap.get(qte.SBQQ__Opportunity2__c).Total_Sales_Commission__c = applicableRate;
                            updateOpptys.put(opptyMap.get(qte.SBQQ__Opportunity2__c).Id, opptyMap.get(qte.SBQQ__Opportunity2__c));
                        }
                    }                                       
                }
                if (updateOpptys.size() > 0 )
                {
                    update updateOpptys.values();
                }
            }            
        }       
    }
    
    /* ============================================================================================ 
       Description          : processQuoteRecords get calles each time when Quote Inserted/Updated.
       @params              : newQuoteList - Holds the Trigger.New Context
                            : oldQuoteList - Holds the Trigger.Old Context
       @return              : none 
       Modification History : ENP Solutionz. 30/09/2018      
    ===============================================================================================*/ 
    public void processQuoteRecords(List<SBQQ__Quote__c> newQuoteList, List <SBQQ__Quote__c> oldQuoteList) {
        List<SBQQ__Quote__c>  effectedQuotes = new List<SBQQ__Quote__c>();
        for (SBQQ__Quote__c obj: newQuoteList) {
            // if trigger contect is update, then process the records only where 
            //      BOS_Total_Sq_Ft__c,Total_IGU_s_QL__c and Are_you_using_Plenum__c are chnaged
            if (trigger.IsUpdate) {
                Map <Id,SBQQ__Quote__c> oldQuoteMap = new Map <Id,SBQQ__Quote__c> (oldQuoteList);
                if ((oldQuoteMap.get(obj.Id).Total_IGU_s_QL__c != obj.Total_IGU_s_QL__c) 
                    || (oldQuoteMap.get(obj.Id).BOS_Total_Sq_Ft__c != obj.BOS_Total_Sq_Ft__c)
                    || (oldQuoteMap.get(obj.Id).Are_you_using_Plenum__c != obj.Are_you_using_Plenum__c)){                    
                    effectedQuotes.add(obj);                                        
                }
            }
            //Insert Call
            else{               
                //Call Method Only when Sqft and Quantity not null
                if (obj.Total_IGU_s_QL__c != null || obj.BOS_Total_Sq_Ft__c != null){
                    effectedQuotes.add(obj);                                
                }
            }       
        } 
        //Check size of the processes list and call calculateBOSBaseTotalPrice when size>0
        if(effectedQuotes.size()>0){    
            calculateBOSBaseTotalPrice(effectedQuotes);
        }
    }
    
    /* ============================================================================================ 
       Description          : Processes upadated quote lines to recalulate the BOS Base price per SqFt on Quote Object(CPQ Quote).
       @params              : List SBQQ__Quote__c
       @return              : none 
        Modification History : ENP Solutionz. 30/09/2018  
       TO DO: make code to behave more dynamic - use custom settings
    ===============================================================================================*/ 
    private static void calculateBOSBaseTotalPrice(List<SBQQ__Quote__c> newQuoteList) {
        list<SBQQ__Quote__c> updateQuoteList = new list<SBQQ__Quote__c>();
        decimal squareFt=0.0;
        decimal price = 0.0;
        decimal baseTotalPrice = 0.0;
        decimal quantity=0.0;       
        decimal cost = 0.0;     
        decimal correctedQuantity=0.0;
        decimal spcorrectedQuantity =0.0;
        decimal conncorrectedQuantity=0.0;
        decimal fwcorrectedQuantity=0.0;
        decimal termcorrectedQuantity=0.0;
        for( SBQQ__Quote__c obj: newQuoteList){   
            System.debug('quantity@@@@'+ obj.Total_IGU_s_QL__c );
            System.debug('squareFt@@@@'+ obj.BOS_Total_Sq_Ft__c); 
            if(obj.Total_IGU_s_QL__c!=null && obj.BOS_Total_Sq_Ft__c!=null && obj.Total_IGU_s_QL__c>0 && obj.BOS_Total_Sq_Ft__c>0){
                quantity = obj.Total_IGU_s_QL__c;
                squareFt = obj.BOS_Total_Sq_Ft__c;              
                System.debug('quantity@@@@'+quantity );
                System.debug('squareFt@@@@'+squareFt);                
                //Control Panel: $21700 * Round(Q / 200, 0)
                decimal qua=0;
                //***COMMENTING THIS UP TO DO ROUNDUP - 03/29 - ENP SOLUTIONZ
                //qua=Math.Round(quantity / 200)==0?1:Math.Round(quantity / 200);
                qua=Math.Ceil(quantity / 200)==0?1:Math.Ceil(quantity / 200);
              //  price  += (21700* qua) + (2480 *1)+ 175 * quantity+ 62.37;      
              //price += (23684.6* qua) + (2480 *1)+ 188.66 * quantity+ 491.51 * quantity / 18 + 62.37;
              price += (23684.6* qua) + (3354.35 *1) + 188.66 * quantity + 491.51 * quantity / 18 + 62.37;     
                /*price  +=  (21700* Math.Round(quantity / 200))
                                                        + (2480 *1)
                                                        + 175 * quantity
                                                        + 62.37;*/
                system.debug('base price before Cables Added $$$$$$$$'+price);
                if(obj.Are_you_using_Plenum__c!='Yes'){
                    //Non-Plenum: $5.22 * Q * 64%
                    //Non-Plenum: $6.54 * Q * 33%
                    //Non-Plenum: $8.73 * Q * 3%
                    //Non-Plenum: $7.09 * Q * 10%
                    //Non-Plenum: $8.41 * Q * 38%
                    //Non-Plenum: $10.59 * Q * 18%
                    //Non-Plenum: $13.51 * Q * 14%
                    //Non-Plenum: $19.24 * Q * 17%
                    //Non-Plenum: $39.35 * Q * 3%
                    //Non-Plenum: $15.26 * Q * 15%
                    //Non-Plenum: $18.36 * Q * 57%
                    //Non-Plenum: $22.23 * Q * 12%
                    //Non-Plenum: $28.02 * Q * 7%
                    //Non-Plenum: $36.24 * Q * 6%
                    //Non-Plenum: $90.97 * Q * 3%
               //     price  += (5.22 * quantity *0.64);                    
               //     price  += (6.54 * quantity *0.33);
               //     price  += (8.73 * quantity *0.03);
               //     price  += (7.09 * quantity *0.1);
               //     price  += (8.41 * quantity *0.38);
               //     price  += (10.59 * quantity *0.18);
               //     price  += (13.51 * quantity *0.14);
               //     price  += (19.24 * quantity *0.17);
               //     price  += (39.35 * quantity *0.03);
               //     price  += (15.26 * quantity *0.15);
               //     price  += (18.36 * quantity *0.57);
               //     price  += (22.23 * quantity *0.12);
               //     price  += (28.02 * quantity *0.07);
               //     price  += (36.24 * quantity *0.06);
               //     price  += (90.97 * quantity *0.03);
               price += (6.62 * quantity *0.64);
    			price += (6.54 * quantity *0.33);
				price += (15.01 * quantity *0.03);
				price += (7.74 * quantity *0.1);
				price += (8.3 * quantity *0.38);
				price += (12.19 * quantity *0.18);
				price += (18.31 * quantity *0.14);
				price += (26.74 * quantity *0.17);
				price += (45.36 * quantity *0.03);
				price += (17.51 * quantity *0.15);
				price += (20.04 * quantity *0.57);
				price += (22.86 * quantity *0.12);
				price += (31.14 * quantity *0.07);
				price += (35.34 * quantity *0.06);
				price += (99.27 * quantity *0.03);     
                }
                else{
                    
                    //Plenum: $7.77 * Q * 64%
                    //Plenum: $12.67 * Q * 33%
                    //Plenum: $20.84 * Q * 3%
                    //Plenum: $9.25 * Q * 10%
                    //Plenum: $14.16 * Q * 38%
                    //Plenum: $22.33 * Q * 18%
                    //Plenum: $33.22 * Q * 14%
                    //Plenum: $54.73 * Q * 17%
                    //Plenum: $129.84 * Q * 3%
                    //Plenum: $22.06 * Q * 15%
                    //Plenum: $34.61 * Q * 57%
                    //Plenum: $55.53 * Q * 12%
                    //Plenum: $83.01 * Q * 7%
                    //Plenum: $124.65 * Q * 6%
                    //Plenum: $565.84 * Q * 3%              
                    
                    //price +=  (7.77 * quantity *0.64);
                  	  price += (8.31 * quantity *0.64);
                    system.debug('7.77'+price);
                   // price += (12.67 * quantity *0.33);
                  	 price += (7.43 * quantity *0.33);
                    system.debug('7.77'+price);
                  //  price += (20.84 * quantity *0.03);
              		  price += (25.71 * quantity *0.03);
                    system.debug('7.77'+price);
                  //  price += (9.25 * quantity *0.1);
               		   price += (9.01 * quantity *0.1);
                    system.debug('7.77'+price);
                 //   price += (14.16 * quantity *0.38);
               		  price += (12.33 * quantity *0.38);
                    system.debug('7.77'+price);
                  //  price += (22.33 * quantity *0.18);
               		   price += (25.8 * quantity *0.18);
                    system.debug('7.77'+price);
                 //   price += (33.22 * quantity *0.14);
               		  price += (34.11 * quantity *0.14);
                    system.debug('7.77'+price);
                 //   price += (54.73 * quantity *0.17);
              		   price += (50.39 * quantity *0.17);
                    system.debug('7.77'+price);
                 //   price += (129.84 * quantity *0.03);
               		  price += (141.69 * quantity *0.03);
                    system.debug('7.77'+price);
                 //   price += (22.06 * quantity *0.15);
               		  price += (23.28 * quantity *0.15);
                    system.debug('7.77'+price);
                 //   price += (34.61 * quantity *0.57);
                	 price += (34.26 * quantity *0.57);
                    system.debug('7.77'+price);
                //    price += (55.53 * quantity *0.12);
             		   price += (55.95 * quantity *0.12);
                    system.debug('7.77'+price);
                //    price += (83.01 * quantity *0.07);
              		 price += (98.16 * quantity *0.07);
                    system.debug('7.77'+price);
                //    price += (124.65 * quantity *0.06);
              		  price += (164.03 * quantity *0.06);
                    system.debug('7.77'+price);
                //    price += (565.84 * quantity *0.03);
              		  price += (306.56 * quantity *0.03);
                    system.debug('7.77'+price);
                }
                
               system.debug('base price after Cables Added $$$$$$$$'+price);
                
                //Quantity = 0.8212354 + 0.000524782 * Q - 0.00002741968 * SF
                //Corrected Quantity = If(Quantity <= 0, 0, RoundUp(Quantity))
                //Price = $1.69 * Corrected Quantity                
                decimal etherQuantity = 0.8212354 + 0.000524782 * quantity - 0.00002741968 * squareFt;
                system.debug('etherQuantity @@@@'+etherQuantity);
                if(etherQuantity <=0)
                    correctedQuantity = 0;
                     else 
                        //correctedQuantity = Math.Round(etherQuantity);
                        correctedQuantity = etherQuantity.Round(roundingMode.UP);
                system.debug('correctedQuantity Ethernet Cables @@@@'+correctedQuantity );              
                price += (1.69 * correctedQuantity);
                
                system.debug('base price after ethernet Cables Added $$$$$$$$'+price);
                
                //Quantity = -1.449388 + 0.02378056 * Q + 0.00006241036 * SF
                //Corrected Quantity = If(Quantity <= 0, 0, RoundUp(Quantity))
                //Price = $658.3 * Corrected Quantity
            
                decimal spquantity = -1.449388 + 0.02378056 * quantity + 0.00006241036 * squareFt;
                system.debug('spquantity @@@@'+spquantity);
                if(spquantity <=0)
                    spcorrectedQuantity = 0;
                     else 
                        //spcorrectedQuantity = Math.Round(spquantity);      
                        spcorrectedQuantity = spquantity.round(roundingMode.UP);
                system.debug('spcorrectedQuantity Spool Cables @@@@'+spcorrectedQuantity);     
                price += (658.3 * spcorrectedQuantity);
                
                
                system.debug('base price after spool Cables Added $$$$$$$$'+price);
                
                //Quantity = -19.77954498 + 0.537521643 * Q + 0.006898383 * SF
                //Corrected Quantity = If(Quantity <= 0, 0, RoundUp(Quantity))
                //Price = $14.06 * Corrected Quantity
                
                decimal connquantity = -19.77954498 + 0.537521643 * quantity + 0.006898383 * squareFt;
                system.debug('connquantity @@@@'+connquantity);
                if(connquantity <=0)
                    conncorrectedQuantity = 0;
                     else 
                        //conncorrectedQuantity = Math.Round(connquantity);
                          conncorrectedQuantity = connquantity.round(roundingMode.UP);
                system.debug('conncorrectedQuantity Connecters @@@@'+conncorrectedQuantity);      
                price += (14.06 * conncorrectedQuantity);
                
                system.debug('base price after Connectors Added $$$$$$$$'+price);

                //Quantity = -1.99998355 + 0.12356664 * Q - 0.00107345 * SF
                //Corrected Quantity = If(Quantity <= 0, 0, RoundUp(Quantity))
                //Price = $10.89 * Corrected Quantity
            
                decimal fwquantity = -1.99998355  + 0.12356664 * quantity - 0.00107345 * squareFt;
                system.debug('fwquantity @@@@'+fwquantity);
                if(fwquantity <=0)
                    fwcorrectedQuantity = 0;
                     else 
                        //fwcorrectedQuantity  = Math.Round(fwquantity);
                          fwcorrectedQuantity  = fwquantity.round(roundingMode.UP);
                    
                system.debug('fwcorrectedQuantity Spool Cables @@@@'+fwcorrectedQuantity);
                price += (10.89 * fwcorrectedQuantity );
                
                system.debug('base price after Field Wireable Added $$$$$$$$'+price);
                
               //Quantity = 2.86800223 + 0.121352527 * Q - 0.003602871 * SF
               //Corrected Quantity = If(Quantity <= 0, 0, RoundUp(Quantity))
               //Price = $5.79 * Corrected Quantity
           
                decimal termquantity = 2.86800223  + 0.121352527 * quantity - 0.003602871 * squareFt;
                system.debug('termquantity @@@@'+termquantity);
                if(termquantity <=0)
                    termcorrectedQuantity = 0;
                     else 
                        //termcorrectedQuantity = Math.Round(termquantity);
                          termcorrectedQuantity = termquantity.round(roundingMode.UP);
                    
                system.debug('termcorrectedQuantity Cables @@@@'+termcorrectedQuantity);
                price += (5.79 * termcorrectedQuantity);
                
                decimal hardwarePriceTotal = price;
                
                system.debug('base price after terminator Added $$$$$$$$'+price);
                system.debug('Hardware Price Added $$$$$$$$'+hardwarePriceTotal);
                
                //Design
                //Cost = Max($18.305 * Q, $10000)
                //Price = Cost / (1 - 88%)
                //MS : Changed the code to capture 89.249 % instead of 88%
                //Corrected Price = If(Price / SF > $25, $25 * SF, Price)
                
               cost = math.max(18.305 * quantity, 10000);
               system.debug('cost @@@@'+cost);
             // decimal designPrice = (cost/ (1-0.89249));
                decimal designPrice = (cost/ (1-0.839225));
                system.debug('designPrice @@@@'+designPrice);
                system.debug('designPrice/squareFt @@@@'+designPrice/squareFt);
                if((designPrice / squareFt)>25)
                    price += 25 * squareFt;
                        else price += designPrice;   
                        
                decimal designPriceTotal = price - hardwarePriceTotal;        
                system.debug('base price after Design Added $$$$$$$$'+price); 
                system.debug('Design Price Added $$$$$$$$'+designPriceTotal);
         
                
                
                
                //Commissioning
                //Price = $115 * Q
                system.debug('Commissioning Price @@@@'+115*quantity);
                price += (115*quantity);
                
                decimal commissioningPriceTotal = price -(hardwarePriceTotal + designPriceTotal);                    
                system.debug('base price after Commissioning Added $$$$$$$$'+price);
                system.debug('Commissioning Price $$$$'+commissioningPriceTotal);
                
                //Software
                //Price = $42 * SF
                system.debug('Softwate Price @@@@'+42*squareFt);
               // price += (42*squareFt);
                
                decimal softwarePriceTotal;
                  if((hardwarePriceTotal/squareFt + designPriceTotal/squareFt + commissioningPriceTotal/squareFt) > 46)
                                      softwarePriceTotal=((2*(88-(hardwarePriceTotal/squareFt + designPriceTotal/squareFt + commissioningPriceTotal/squareFt))+42)/3);
                                      else softwarePriceTotal=42;
                                      price += (softwarePriceTotal*squareFt);
                                      
                system.debug('base price after Software Added $$$$$$$$'+price); 
                system.debug('Software Price Added $$$$$$'+softwarePriceTotal);
                                     
                if(price!=null){
                    //obj.Target_BOS_Price_Per_Sq_Ft__c = (price/squareFt) *obj.Conversion_Rate_on_create__c; 
                    obj.Target_BOS_Price_Per_Sq_Ft__c = (price/squareFt - 3) *obj.Conversion_Rate_on_create__c;                 
                }
                system.debug('Target_BOS_Price_Per_Sq_Ft__c>>>'+obj.Target_BOS_Price_Per_Sq_Ft__c);
            }   
        }   	
    }
}