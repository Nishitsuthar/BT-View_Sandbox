global class OneTimeBatchSKUGenerator implements Database.Batchable<sObject>, Database.stateful 
{
    //
    // NOTE - The CreateProductSKU Trigger must be inactivated before running this job
    //
    Global Map<String,String> generationMap;
    Global Map<String,String> colorMap;
    Global Map<String,String> paneMap;
    Global Map<String,String> shapeMap;
    Global Map<String,String> lamiMap;  
    Global String productSKU; 
    Global String query;
    Global Integer recordsProcessed = 0;
    Global Integer validationErrors = 0;
    Global Integer recordsUpdated = 0;
    
    global OneTimeBatchSKUGenerator()
    {
        generationMap  = SKU_Trigger_Helper.loadMap('Generation');
        colorMap = SKU_Trigger_Helper.loadMap('Color');
        paneMap = SKU_Trigger_Helper.loadMap('Panes');
        shapeMap = SKU_Trigger_Helper.loadMap('Shape');
        lamiMap = SKU_Trigger_Helper.loadMap('Laminate');
        query = 'SELECT Id, Family, ProductCode, Generation__c, Laminate__c, Inboard_Lite__c, Shape__c, Panes__c, SKU_Sequence__c, Product_SKU__c ' + 
            'FROM Product2 WHERE Family =  \'IGU\' OR Family = \'VIEW\'' ;
    }
    
    /*
     * Method name  : start
     * Description  : Batch Class start Method - collects the Product2 IGU records to be passed
                      to the interface method execute
     * Return Type  : Database.QueryLocator
     * Parameter    : Database.BatchableContext
    */
     
    global Database.QueryLocator start(Database.BatchableContext BC)  {  
        return Database.getQueryLocator(query);
    }  

    global void execute(Database.BatchableContext BC,List<Product2> IGUList)   
    {
        //
        // Validate the fields used to generate the "intelligent" part of the SKU (first 5 characters)
        //
        Boolean validationError;
        for (product2 prod : IGUList)
        {
            validationError = false;
            recordsProcessed++;
            if (prod.Generation__c == null || !generationMap.containsKey(prod.Generation__c.toUpperCase()))
            {
                validationError = true;
                System.debug('***Validation Error: Generation = ' + prod.Generation__c);
            }
            
            if (prod.Laminate__c == null || !lamiMap.containsKey(prod.Laminate__c.toUpperCase()))
            {
                validationError = true;
                System.debug('***Validation Error: Laminate = ' + prod.Laminate__c );
            }

            if (prod.Inboard_Lite__c == null || !colorMap.containsKey(prod.Inboard_Lite__c.toUpperCase()))
            {
                validationError = true;
                System.debug('***Validation Error: Color = ' + prod.Inboard_Lite__c);
            }
            
            if (prod.Shape__c == null || !shapeMap.containsKey(prod.Shape__c.toUpperCase()))
            {
                validationError = true;
                System.debug('***Validation Error: Shape = ' + prod.Shape__c);
            }
            
            if (prod.Panes__c == null || !paneMap.containsKey(prod.Panes__c.toUpperCase()))
            {
                validationError = true;
                System.debug('***Validation Error: Panes = ' + prod.Panes__c);
            }
            if (validationError)
            {
                System.debug('*** Product Id ' + String.valueOf(prod.ID) + ' validation error.');
                validationErrors++;
            }
            else
            {
                productSKU = generationMap.get(prod.Generation__c.toUpperCase());
                productSKU = productSKU + lamiMap.get(prod.Laminate__c.toUpperCase());
                productSKU = productSKU + colorMap.get(prod.Inboard_Lite__c.toUpperCase());
                productSKU = productSKU + shapeMap.get(prod.Shape__c.toUpperCase());
                productSKU = productSKU + paneMap.get(prod.Panes__c.toUpperCase());
                productSKU = productSKU + '-' + SKU_Trigger_Helper.toBase36(Integer.valueOf(prod.SKU_Sequence__c),4);
                if (prod.Product_SKU__c == null)
                {               
                    prod.Product_SKU__c = productSKU;
                }
                recordsUpdated++;
            }
        }
        update IGUList;     
    }
    
    global void finish(Database.BatchableContext BC) 
    {   
        System.Debug('OneTimeBatchSKUGenerator Finished');
        System.Debug('Records Processed: ' + String.valueOf(recordsProcessed));
        System.Debug('Validation Errors: ' + String.valueOf(validationErrors));
        System.Debug('Records Updated: ' + String.valueOf(recordsUpdated));
    }
}