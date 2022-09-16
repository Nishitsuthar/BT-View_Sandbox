public class CreateAssetFromLite implements Database.Batchable<sObject>{  
    
public Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        String lId = 'Select id,Asset_Created__c,Lite_Id__c,Order_Entry_Line__c,Shipment_Line__c,Shipment_Line_Reference__c from Lite_Id__c WHERE Order_Entry_Line__c != NULL AND Asset_Created__c !=\'Yes\' AND Asset_Created__c !=\'Initial\' AND Asset_Created__c !=\'Error\' AND Asset_Created__c !=\'Yes-Already exists\'';
        return Database.getQueryLocator(lId);
    }
    
    public void execute(Database.BatchableContext BC, List<Lite_Id__c> scope)
    {
        Set<String> liteIdstoUpdate = new Set<String>();
        List<String> liteIdstoUpdateAlreadyHasAsset = new List<String>();
        Set<String> liteFromScope = new Set<String>();
        List<Lite_Id__c> getLiteIds = new List<Lite_Id__c>();
        List<Lite_Id__c> getLiteIdsOld = new List<Lite_Id__c>();
        Map<String,Lite_Id__c> liteMapQ = new Map<String,Lite_Id__c>();
        Map<String,Asset> assetMap = new Map<String,Asset>();
        Map<String,Asset> assetMapOld = new Map<String,Asset>();
        Set<String> oelRefFromLite = new Set<String>();
        for(Lite_Id__c liId : scope)
        {
            liteFromScope.add(liId.Lite_Id__c);
            oelRefFromLite.add(liId.Order_Entry_Line__c);
            System.debug('Lite Id 24 '+liId.Lite_Id__c + 'OEL Lines '+liId.Order_Entry_Line__c);
        }
        
        List<Asset> allAsset = new List<Asset>([Select id,Name,SerialNumber from Asset WHERE Name IN : liteFromScope]);
        List<Lite_Id__c> allLiteCreate = new List<Lite_Id__c>([Select id,Asset_Created__c,Lite_Id__c,Asset_Id__c,Order_Entry_Line__c,Shipment_Line__c,Shipment_Line_Reference__c 
                                        from Lite_Id__c where Lite_Id__c IN: liteFromScope AND Asset_Created__c !='Error']);
        for(Asset forAsset : allAsset)
        {
            assetMap.put(forAsset.Name,null);
        }
        System.debug(' Asset Map size '+assetMap.Size());
        for(Lite_Id__c liDetail : allLiteCreate)
        {
            
            if(!assetMap.containskey(liDetail.Lite_Id__c))
            {
                liteIdstoUpdate.add(liDetail.Lite_Id__c);
                System.debug(' OEL Ref '+liDetail.Order_Entry_Line__c);
               
            }
            //(assetMap.containskey(liDetail.Lite_Id__c))
            else
            {
                liteIdstoUpdateAlreadyHasAsset.add(liDetail.Lite_Id__c);
            }
           
        }
        System.debug('liteIdstoUpdate Size '+liteIdstoUpdate.size());
        System.debug('liteIdstoUpdateAlreadyHasAsset Size '+liteIdstoUpdateAlreadyHasAsset.size());
        if(!liteIdstoUpdate.isEmpty())
            getLiteIds = [Select id,Asset_Created__c,Lite_Id__c,Asset_Id__c,Order_Entry_Line__c,Shipment_Line__c,Shipment_Line_Reference__c 
                                        from Lite_Id__c where Lite_Id__c IN: liteIdstoUpdate AND Asset_Created__c !='Error'];
        for(lite_id__c liId : getLiteIds)
        {
            if(liId.Order_Entry_Line__c != '' && liId.Order_Entry_Line__c != null)
            	liteMapQ.put(liId.Lite_Id__c, liId);
           // oelRefFromLite.add(liId.Order_Entry_Line__c);
            System.debug('OEL Ref 58 '+liId.Order_Entry_Line__c);
        }
        
        if(!liteIdstoUpdateAlreadyHasAsset.isEmpty())
        {
            getLiteIdsOld = [Select id,Asset_Created__c,Lite_Id__c,Asset_Id__c,Order_Entry_Line__c,Shipment_Line__c,Shipment_Line_Reference__c 
                                        from Lite_Id__c where Lite_Id__c IN: liteIdstoUpdateAlreadyHasAsset AND Asset_Created__c !='Error'];

            List<Asset> oldAssetIds = new List<Asset>([Select id,Name,SerialNumber from Asset where Name IN:liteIdstoUpdateAlreadyHasAsset]);

            for(Asset asstIn : oldAssetIds)
            {
                assetMapOld.put(asstIn.Name,asstIn);
            }
        }
        
        System.debug(' Lite Id Size for Asset Creation '+scope.size());
        System.debug('Size to insert  '+getLiteIds.Size() + 'Size to Update '+getLiteIdsOld.size() + 'Map new Size '+liteMapQ.Size());
        List<Lite_Id__c> updateLiteId = new List<Lite_Id__c>();
        List<Lite_Id__c> updateLiteId2 = new List<Lite_Id__c>();
        List<Asset> assetToCreate = new List<Asset>();
        List<String> shpLine = new List<String>();
        //Set<String> oelRefFromLite = new Set<String>();
        List<Lite_Id__c> forLite = new List<Lite_Id__c>();
        Map<String,Shipment_Line__c> shipLineDetails = new Map<String,Shipment_Line__c>();
        Map<String,String> liteDetails = new Map<String,String>();
        Map<String,String> liteDetails1 = new Map<String,String>();
        Map<String,Asset> addAssetIdsNew = new Map<String,Asset>();
        Map<Lite_Id__c,String> newMapLite = new Map<Lite_Id__c,String>();
        
        for(Lite_Id__c lIdFor : liteMapQ.values())
        {
                shpLine.add(String.valueof(lIdFor.Shipment_Line_Reference__c));
               // oelRefFromLite.add(String.valueof(lIdFor.Order_Entry_Line__c));
            	System.debug('OEL Ref line '+lIdFor.Order_Entry_Line__c);
                liteDetails.put(lIdFor.Order_Entry_Line__c,lIdFor.Lite_Id__c);
            	liteDetails1.put(lIdFor.Lite_Id__c,lIdFor.Lite_Id__c);
                if(lIdFor.Order_Entry_Line__c != null)
                {
                    forLite.add(lIdFor);
                    newMapLite.put(lIdFor,null);
                }
        }                
        // Shipment and Shipment Line info to updated on Asset 
        
        if(!shpLine.isEmpty())
        {
            List<Shipment_Line__c> shiLine = new List<Shipment_Line__c>([Select id,Shipment_Line_External_Reference__c,Shipment__r.Ship_Date__c,
                                                                         Shipment__r.Delivery_Number__c,Order_Entry_Line__c from Shipment_Line__c 
                                                                         WHERE Shipment_Line_External_Reference__c IN:shpLine]);
            for(Shipment_Line__c sh : shiLine)
            {
                shipLineDetails.put(sh.Order_Entry_Line__c, sh);
                System.debug(' Shipment and Shipment Line info '+shipLineDetails.values());
            }
            
        }
        
        // Asset Creation from Order Entry Line details 
        
        List<Order_Entry_Line__c> oelToAsset = new List<Order_Entry_Line__c>();
        Map<String,Order_Entry_Line__c> oelMap = new Map<String,Order_Entry_Line__c>();
        List<Asset> createAsset =new List<Asset>();
        
        System.debug('OEL Ref '+ oelRefFromLite);
        if(oelRefFromLite.Size() >= 1)
        {
            
            oelToAsset = [Select id,Name,Order_Entry_Release__r.Billing_Account__c,CurrencyIsoCode,H1_integration__c,Height_Intergration__c,Base_Integration__c,
                          Mark_Ids__c,Order_Entry_Release__r.Opportunity__c,Order_Entry_Release__c,Product__c,Part_Number__c,Product_Name__c,
                          Product_SKU__c,Shape__c,W1_integration__c,System_of_Measurement__c,Product__r.Family from Order_Entry_Line__c where Name  IN: oelRefFromLite];
            
            for(Order_Entry_Line__c oel : oelToAsset)
            {
                oelMap.put(oel.Name,oel);
                
            }
            System.debug('Size '+oelMap.size());
            
        }
        
       if(!oelToAsset.isEmpty())
        {
            
            //for(Lite_Id__c oelAsst : newMapLite.keySet())
            for(Lite_Id__c oelAsst : liteMapQ.values())
            { System.debug('OEL Reference '+oelAsst.Order_Entry_Line__c);
                System.debug(' Lite Id \'s '+ oelAsst.Lite_Id__c +' OEL '+oelAsst.Order_Entry_Line__c);
               if(liteDetails1.containsKey(oelAsst.Lite_Id__c))
                {
                    Asset assetData = new Asset();
                    assetData.AccountId = oelMap.get(oelAsst.Order_Entry_Line__c).Order_Entry_Release__r.Billing_Account__c;
                    assetData.Opportunity__c = oelMap.get(oelAsst.Order_Entry_Line__c).Order_Entry_Release__r.Opportunity__c;
                    assetData.Product2Id = oelMap.get(oelAsst.Order_Entry_Line__c).Product__c != null ? oelMap.get(oelAsst.Order_Entry_Line__c).Product__c : NULL;
                    assetData.Name = liteDetails1.get(oelAsst.Lite_Id__c);
                    assetData.Status = 'Shipped';
                    assetData.Quantity = 1.00;
                    assetData.Lite_Height__c = oelMap.get(oelAsst.Order_Entry_Line__c).Height_Intergration__c;
                    assetData.SerialNumber = liteDetails1.get(oelAsst.Lite_Id__c);
                    assetData.Lite_Width__c = oelMap.get(oelAsst.Order_Entry_Line__c).Base_Integration__c != null ? oelMap.get(oelAsst.Order_Entry_Line__c).Base_Integration__c : null;
                    assetData.Mark_Id__c = oelMap.get(oelAsst.Order_Entry_Line__c).Mark_Ids__c != null ? oelMap.get(oelAsst.Order_Entry_Line__c).Mark_Ids__c: null;
                    assetData.Order_Entry_Release__c = oelMap.get(oelAsst.Order_Entry_Line__c).Order_Entry_Release__c != null ? oelMap.get(oelAsst.Order_Entry_Line__c).Order_Entry_Release__c : null;
                    // assetData.ProductCode = oelMap.get(oelAsst.Order_Entry_Line__c).Part_Number__c; // Field is not writeable: Asset.ProductCode
                    // assetData.ProductDescription = oelMap.get(oelAsst.Order_Entry_Line__c).Product_Name__c; // Field is not writeable: Asset.ProductDescription
                    // assetData.ProductFamily = 'IGU'; // Field is not writeable: Asset.ProductFamily
                    // assetData.STOCKKEEPINGUNIT = oelMap.get(oelAsst.Order_Entry_Line__c).Product_SKU__c; // Field is not writeable: Asset.StockKeepingUnit
                    assetData.SKU__c = oelMap.get(oelAsst.Order_Entry_Line__c).Product_SKU__c;
                    assetData.Shape__c = oelMap.get(oelAsst.Order_Entry_Line__c).Shape__c;
                    assetData.System_of_Measurement__c = oelMap.get(oelAsst.Order_Entry_Line__c).System_of_Measurement__c;
                    
                    assetData.W1__C = oelMap.get(oelAsst.Order_Entry_Line__c).W1_integration__c != '0' ? Decimal.valueOf(oelMap.get(oelAsst.Order_Entry_Line__c).W1_integration__c) : NULL;
                    assetData.H1__c = oelMap.get(oelAsst.Order_Entry_Line__c).H1_Integration__c != '0' ? Decimal.valueOf(oelMap.get(oelAsst.Order_Entry_Line__c).H1_Integration__c) : NULL;
                    
                    
                    assetData.Shipment_Number__c = shipLineDetails.containsKey(oelAsst.Order_Entry_Line__c) ?  shipLineDetails.get(oelAsst.Order_Entry_Line__c).Shipment__r.Delivery_Number__c : '';
                    assetData.IGU_Shipped_Date__c = shipLineDetails.containsKey(oelAsst.Order_Entry_Line__c) ? shipLineDetails.get(oelAsst.Order_Entry_Line__c).Shipment__r.Ship_Date__c : NULL;
                    createAsset.add(assetData);
                   
                    
               }
                
            }
            System.debug('181 Inserted Size '+createAsset.size());
            if(!createAsset.isEmpty())
            {
                
                INSERT createAsset;
                for(integer i =0; i < createAsset.size();i++ )
                {
                    System.debug('188 **** '+createAsset[i]);
                }
                //System.debug('180 **** '+createAsset.size());
            }
                for(Asset assertId : [Select id,name,SerialNumber from Asset where ID IN:createAsset])
                {
                    addAssetIdsNew.put(assertId.name,assertId);
                }
                System.debug('asset ids '+addAssetIdsNew.Size());

                for(Lite_Id__c lIdFor1 : liteMapQ.values())
                {
                    if(addAssetIdsNew.containsKey(lIdFor1.Lite_Id__c))
                    {
                        lIdFor1.Asset_Created__c = 'Yes';
                        lIdFor1.Asset_Id__c = addAssetIdsNew.get(lIdFor1.Lite_Id__c).Id;
                        updateLiteId2.add(lIdFor1);
                        
                    }
  
                }
                if(!updateLiteId2.IsEmpty())
                    System.debug('200 update lite id '+updateLiteId2.size());
                    UPDATE updateLiteId2;
                
               
           }
                 
       // }
        
        if(!getLiteIdsOld.isEmpty())
            {
              for(Lite_Id__c lIdFor2 : getLiteIdsOld)
                {
                    if(assetMapOld.containsKey(lIdFor2.Lite_Id__c))
                    {
                        lIdFor2.Asset_Created__c = 'Yes-Already exists';
                        lIdFor2.Asset_Id__c = assetMapOld.get(lIdFor2.Lite_Id__c).Id;
                        updateLiteId.add(lIdFor2); 
                    }
  
                }
                
                if(!updateLiteId.isEmpty())
                {
                    System.debug('233 Update '+updateLiteId.size());
                    UPDATE updateLiteId;
                }   
            }
        
    }
    
    public void finish(Database.BatchableContext BC)
    {    
        
    } 
}