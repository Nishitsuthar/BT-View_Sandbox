global class ShiptmentLineDetailsOnLiteIdBatch implements Database.Batchable<Sobject>,schedulable
{
    
    global ShiptmentLineDetailsOnLiteIdBatch() 
    {
    }
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String getLiteRec = 'Select id,Asset_Created__c,Lite_Id__c,Order_Entry_Line__c,Shipment_Line__c,Shipment_Line_Reference__c from Lite_Id__c WHERE Asset_Created__c = \'Initial\''; 
        return Database.getQueryLocator(getLiteRec);
    }
    
    global void execute(Database.BatchableContext BC, List<Lite_Id__c> scope) {
        System.debug(' Scope of Lite Id '+ scope);
        // Update Lite Id 
        
        Map<String,String> liteMap = new Map<String,String>();
        List<String> shipRef = new List<String>();
        List<String> liteName = new List<String>();
        Set<String> liteSet = new Set<String>();
        //List<SmartSheet_Exceptions__c> smartExcep = new List<SmartSheet_Exceptions__c>();
        Set<Id> liteIds = new Set<Id>();
        List<Lite_Id__c> errUp = new List<Lite_Id__c>();
        
        for(Lite_Id__c lDetails : scope)
        {
            if(lDetails.Lite_Id__c != '' && lDetails.Shipment_Line_Reference__c !='')
            {
                shipRef.add(lDetails.Shipment_Line_Reference__c);
               // liteMap.put(lDetails.Lite_Id__c, lDetails.Shipment_Line_Reference__c);
                liteName.add(lDetails.Lite_Id__c);
                System.debug(' not null lite id and SHipment line '+ lDetails.Lite_Id__c + 'Shipment Line '+lDetails.Shipment_Line_Reference__c);
            }
            
            if(lDetails.Shipment_Line_Reference__c =='' || lDetails.Shipment_Line_Reference__c == null) 
            {
             	liteIds.add(lDetails.Id);
                /*
                System.debug(' null Shipment_Line_Reference__c '+ lDetails.Shipment_Line_Reference__c );
                SmartSheet_Exceptions__c excep = new SmartSheet_Exceptions__c();
                excep.Asset_Lite_Id__c = lDetails.Lite_Id__c;
                excep.Error_Message__c = ' Shipment Line Reference Dont exist on Lite Id ' + lDetails.Id;
                excep.RecordTypeId = Schema.SObjectType.SmartSheet_Exceptions__c.getRecordTypeInfosByName().get('Assert Creation Exception').getRecordTypeId();
                smartExcep.add(excep);
                
				*/                
            }
            
            if(lDetails.Shipment_Line_Reference__c != null)
            {
                liteSet.add(lDetails.Shipment_Line_Reference__c); 
            }
            
        }
        
        if(!liteIds.isEmpty())
        {
            List<Lite_Id__c> updateLites = new List<Lite_Id__c>();
            updateLites = [Select id,Asset_Created__c from Lite_Id__c where Id IN: liteIds];
            System.debug(' Shipment line reference '+updateLites + ' Lite Id\'s ' + liteIds);
            for(Lite_Id__c erUp : updateLites)
            {
                Lite_Id__c liId = new Lite_Id__c();
                liId.Asset_Created__c = 'Error';
                liId.Error_Message__c = ' Shipment Line Reference Dont exist on Lite Id ';
                liId.Id = erUp.id;
                errUp.add(liId);
            }
        }
        
        if(!errUp.isEmpty())
        {
            UPDATE errUp;
        }
        
        if(shipRef.size() > 0)
        {
            List<Lite_Id__c> litIdUp = new List<Lite_Id__c>();
            litIdUp = [Select id,Shipment_Line_Reference__c,Asset_Created__c,Lite_Id__c,Order_Entry_Line__c 
                       			From Lite_Id__c WHERE Asset_Created__c != 'Error' AND Asset_Created__c !='Yes' AND Asset_Created__c !='Yes-Already exists' AND Shipment_Line_Reference__c IN:shipRef LIMIT 5000];
            ShipmentLineDetailsOnLiteIdClass.updateLiteIdDetails(shipRef,litIdUp);
        }
        
        if(!liteSet.isEmpty())
        {	
            List<Lite_Id__c> updateAssetStatus = new List<Lite_Id__c>();
           // List<String> liteIdShliRef = new List<String>();
            Map<String,Shipment_Line__c> createExcep = new Map<String,Shipment_Line__c>();
            List<Shipment_Line__c> shipDetails = [Select id,Shipment_Line_External_Reference__c,Order_Entry_Line__c,Shipment__c from Shipment_Line__c 
                                        												        WHERE Shipment_Line_External_Reference__c IN: liteSet];
            
            for(Shipment_Line__c shl : shipDetails)
            {
                createExcep.put(shl.Shipment_Line_External_Reference__c,shl);
            }
            for(Lite_Id__c li : scope)
            {
              if(!createExcep.containsKey(li.Shipment_Line_Reference__c) && li.Shipment_Line_Reference__c != null)
            {
                updateAssetStatus.add(li); // Add this and check in line 100
                //liteIdShliRef.add(li.Shipment_Line_Reference__c);
            }  
            }
            
            /*
            List<Lite_Id__c> upLiteId = new List<Lite_Id__c>();
            upLiteId = [Select id,Shipment_Line_Reference__c,Asset_Created__c,Lite_Id__c From Lite_Id__c WHERE Shipment_Line_Reference__c IN:liteIdShliRef];
            */
            System.debug(' shipment line didn\'t found ');
            if(!updateAssetStatus.isEmpty())
            	ShipmentLineDetailsOnLiteIdClass.afterInsertExceptionToCreate(updateAssetStatus);
        }
        /*
        if(!smartExcep.isEmpty())
        {
            INSERT smartExcep;
            
            System.debug(' Smartsheet excep Id '+ smartExcep);
        } */
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
        CreateAssetFromLite createAsset = new CreateAssetFromLite();
        	database.executebatch(createAsset,200);
    }
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new ShiptmentLineDetailsOnLiteIdBatch());
    }
    
}