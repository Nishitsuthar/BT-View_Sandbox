public Class OrderEntryReleaseWrapper
{
    //
    // Version 6 - Version 4.5 with changes to support rollups 
    // 20180209 JV - Correction to noLineUpdate object
    // 20180209 JV - Code to prevent cascading Shipping Address changes to shipped Line Items 
    // Verions 4.5 - Based on go live version. Changes from Version 4 to handle OEL metric record type
    //      have been added.
    //
    // 06-Jan-2021          Rekha           SW items invoice Hold    SW_ITEMS_INVOICE_HOLD
    // 12-Jan-2021			Srikanth   		SO Changes			     SO_CHANGES_Jan_2021	
    public Order_Entry_Release__c oer {get; set;}
    public Boolean hasErrors {get; set;}
    public Integer oelCount {get; set;}
    public List<String> validationErrors = new List<String>();
    public List<OrderEntryLineWrapper> oelwList = new List<OrderEntryLineWrapper>();
    public Boolean hasPushedChanges = false;
    public Boolean isUpdated = false;
    // 20180208 - Removed "Partially Shipped" from the following set; changed "Confirmation Pending" to "Confirmation Requested" 
    //Added Invoiced - ENP
    public Set<String> noLineUpdate = new Set<String>{'Confirmation Requested','Cancelled', 'Cancellation Requested', 'Cancellation Confirmation Pending',  'Cancellation Confirmed', 
        'Cancellation Integration Requested', 'Shipped', 'Complete','Invoiced'};
    //Added Invoiced - ENP
    public Set<String> oelHasShipped = new Set<String> {'Shipped', 'Complete', 'Invoiced'};//SO_CHANGES_Jan_2021
    //assined to zero by end 
    public Integer lastUsedLineNumber=0;
    //Added Planned and Approved-to-Ship - ENP
    public Set<String> preIntegrationStatus = new Set<String>{'Draft', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed','Planned', 'Approved-to-Ship'};
    public Set<String> preConfirmationStatus = new Set<String> {'Draft','Pre-Release Review', 'Confirmation Pending','Planned','Change Requested'};
    
    
    public OrderEntryReleaseWrapper(Order_Entry_Release__c oerIn)
    {
        this.oer = oerIn;
        this.hasErrors = false;
    } 
    
    public void addValidationError(String validationError)
    {
        validationErrors.add(validationError);
        hasErrors = true;
    } 
    
    public void addOrderEntryLine(Order_Entry_Line__c oel)
    {       
        // *** Version 4 - Change to handle OEL Metric Record Type
        //  Maintains support for calls using previous method signature 
        //  defaulting OEL record type to Imperial
        addOrderEntryLine(oel, 'IGU_Imperial');
    }
    
    // *** Version 4 - Change to handle OEL Metric Record Type    
    public void addOrderEntryLine(Order_Entry_Line__c oel, String oelRecordType)
    {       
        oelwList.add(new OrderEntryLineWrapper(oel, oelRecordType));
        oelCount = oelwList.size();
    }
    
/*    public void addOrderEntryLine(Order_Entry_Line__c oel)
    {       
        oelwList.add(new OrderEntryLineWrapper(oel));
        oelCount = oelwList.size(); 
    } */
    
    public void copyShippingInfoToLines (Boolean overRideEdits)
    {

        for (OrderEntryLineWrapper oelw : oelwList)
        {
            // JV - 20180208 Added check to prevent changes to Line Item once it has begun to ship
            if (!noLineUpdate.contains(oelw.oel.Status__c) && !oelHasShipped.contains(oelw.oel.Status__c))
            {
                if (overRideEdits || oelw.oel.Use_Account_Shipping_Address__c)
                {
                    oelw.isUpdated = true;
                    oelw.oel.Shipping_Account__c = oer.Shipping_Account__c;
                    oelw.oel.Shipping_City__c = oer.Shipping_City__c;
                    oelw.oel.Shipping_Country__c = oer.Shipping_Country__c; 
                    oelw.oel.Shipping_Name__c = oer.Shipping_Name__c; 
                    oelw.oel.Shipping_Postal_Code__c = oer.Shipping_Postal_Code__c; 
                    oelw.oel.Shipping_State_Province__c = oer.Shipping_State_Province__c; 
                    oelw.oel.Shipping_Street_1__c = oer.Shipping_Street_1__c; 
                    oelw.oel.Shipping_Street_2__c = oer.Shipping_Street_2__c; 
                    oelw.oel.Shipping_Street_3__c = oer.Shipping_Street_3__c;           
                }
            }
        }
    }
    
    public void setLineFields (String fieldName, Date fieldValue)
    {
        for (OrderEntryLineWrapper oelw : oelwList)     
        {
            if (!noLineUpdate.contains(oelw.oel.Status__c))
            {
                oelw.isUpdated = true;
                if (fieldName == 'Request Date')
                {
                    oelw.oel.Request_Date__c = fieldValue;
                }
                if (fieldName == 'Committed Date')
                {
                    oelw.oel.Scheduled_Ship_Date__c = fieldValue;
                }
                // JV - 20180208 Added code for Promised Date
                if (fieldName == 'Promised Date')
                {
                    oelw.oel.Promised_Date__c = fieldValue;
                }
            }
        }
    }

    public void setLineFields (String fieldName, String fieldValue)
    {
        for (OrderEntryLineWrapper oelw : oelwList)
        {
            if (!noLineUpdate.contains(oelw.oel.Status__c))
            {
                oelw.isUpdated = true;
                if (fieldName == 'Status')              
                {
                    // JV - 20171020 Changed 'oer.Status__c' to fieldValue in the following Statement
                    oelw.oel.Status__c = fieldValue;
                }
                if (fieldName == 'Integration Status')
                {
                    oelw.oel.Integration_Status__c = fieldValue;
                }
                if (fieldName == 'Trigger Source')
                {
                    oelw.oel.Trigger_Source__c = fieldValue;
                }
                if (fieldName == 'Change Type Requested')
                {
                    oelw.oel.Trigger_Source__c = fieldValue;
                }
            }           
        }
    }
    
    /*public String getNewStatus()
    {
        //
        // After change to the Order Entry Lines for this Order Entry Release
        // derive the Status of Order Release from the statuses of the set of all Order Entry LInes
        //
        String newStatus = oer.Status__c; // Default New Status = Current Status
        Boolean isCancelled = true;
        Boolean isComplete = true;
        Boolean isPreProd = true;
        Boolean isPartiallyShipped = false;
        Boolean isInProduction = false;
        Boolean isShipped = true;
        if (oelwList.size() == 0)
        {
            return newStatus;
        }
        for (OrderEntryLineWrapper oelw : oelwList)
        {
            if (oelw.oel == null)
            {
                System.debug('**************** Status Error: null entry in table');
            }
            if (!oelw.oel.Status__c.contains('Cancel'))
            {
                isCancelled = false;                        
                if (oelw.oel.Status__c != 'Complete')
                {
                    isComplete = false;
                    if (oelw.oel.Status__c != 'Shipped')                            
                    {
                        isShipped = false;
                        if (oelw.oel.Status__c == 'Partially Shipped')
                        {
                            isPartiallyShipped = true;
                        }
                        else
                        {                                   
                            if (oelw.oel.Status__c != 'Pre-Production')
                            {
                                isPreProd = false;
                                if (oelw.oel.Status__c == 'In Production')
                                {
                                    isInProduction = true;
                                }
                            }
                        }   
                    }
                    else
                    {
                        isPartiallyShipped = true;
                    }
                }
            }
        }
        if (isCancelled)
        {
            newStatus = 'Cancelled';
        }
        else
        {
            if (isComplete)
            {
                newStatus = 'Complete'; 
            }rtMap.get(oel.RecordTypeId).DeveloperName.contains('IGU')
            else
            {
                if (isShipped)
                {
                    newStatus = 'Shipped';  
                }
                else
                {
                    if (isPartiallyShipped)
                    {
                        newStatus = 'Partially Shipped';    
                    }
                    else
                    {
                        if (isInProduction)
                        {
                            newStatus = 'In Production';    
                        }
                        else
                        {
                            if (isPreProd)
                            {
                                newStatus = 'Pre-Production';   
                            }
                        }
                    }
                }                       
            }
        }
        return newStatus;   
    }*/
    
    public String getNewStatus()
    {
        //
        // After change to the Order Entry Lines for this Order Entry Release
        // derive the Status of Order Release from the statuses of the set of all Order Entry LInes
        //
        String newStatus = oer.Status__c; // Default New Status = Current Status
        Boolean isCancelled = true;
        Boolean isComplete = true;
        Boolean isPreProd = true;
        Boolean isPartiallyShipped = false;
        Boolean isInProduction = false;
        Boolean isShipped = true;
        //Added by ENP
        Boolean isPlanned = true;
        Boolean isApprovedtoShip = true;
        Boolean isBooked = true;
        Boolean isInvoiced = true;
        Boolean oelSSPlanned = false;  //SW_ITEMS_INVOICE_HOLD
        Boolean oelSSBooked = false;  //SW_ITEMS_INVOICE_HOLD
        Boolean oelSSInvoiced = false;//SW_ITEMS_INVOICE_HOLD
        Boolean oelSSHold = false;//SW_ITEMS_INVOICE_HOLD
        Boolean oelSSHoldRequested = false;//SW_ITEMS_INVOICE_HOLD
        Boolean oelSSHoldRelRequested = false;//SW_ITEMS_INVOICE_HOLD
        Boolean oelSSCngIntReq = false;//SW_ITEMS_INVOICE_HOLD
        Boolean isHold = true;
        Boolean isError = true;
        if (oelwList.size() == 0)
        {
            return newStatus;
        }
        for (OrderEntryLineWrapper oelw : oelwList)
        {
            System.debug('@@igurepeat ');
            if (oelw.oel == null)
            {
                System.debug('**************** Status Error: null entry in table');
            }           
            if (oelw.oel.Status__c!=null && !oelw.oel.Status__c.contains('Cancelled'))
            {
                isCancelled = false;
                //Added by ENP - START
                if(oelw.RecordType.containsIgnoreCase(Label.CSS_Hardware)){
                    if (oelw.oel.Status__c != 'Planned'){                       
                        isPlanned= false;
                    }
                    if (oelw.oel.Status__c != 'Approved-to-Ship'){
                            isApprovedtoShip = false;
                    }
                    if (oelw.oel.Status__c != 'Hold'){
                            isHold = false;
                    }
                    if (oelw.oel.Status__c != 'Integration Error'){
                            isError = false;
                    }                   
                    isBooked = false;
                    isInvoiced = false;
                    
                }               
                else if(oelw.RecordType.containsIgnoreCase(Label.CSS_Software)){
                    if (oelw.oel.Status__c != 'Planned'){ 
                        isPlanned= false;
                    }
                    if (oelw.oel.Status__c != 'Booked'){
                        isBooked= false;
                    }
                    if (oelw.oel.Status__c != 'Invoiced'){
                        isInvoiced = false;                                
                    }
                    //SW_ITEMS_INVOICE_HOLD
                    if (oelw.oel.Status__c == 'Planned'){    
                        
                        oelSSPlanned= true;
                    }
                    if (oelw.oel.Status__c == 'Hold'){    
                        
                        oelSSHold= true;
                    }
                    if (oelw.oel.Status__c == 'Booked'){    
                        
                        oelSSBooked= true;
                    }
                    if (oelw.oel.Status__c == 'Invoiced'){
                        
                        oelSSInvoiced = true;                                
                    } 
                    if (oelw.oel.Status__c == 'Hold Release Requested'){
                        
                        oelSSHoldRelRequested = true;                                
                    }
                    if (oelw.oel.Status__c == 'Hold Requested'){
                        
                        oelSSHoldRequested = true;                                
                    }
                    
                    isApprovedtoShip = false;
                    isHold = false; 
                    isError = false; 
                }
                //Added by enp narasimha
                else if(oelw.RecordType.containsIgnoreCase('IGU')){
                    isPlanned= false;
                    isApprovedtoShip = false;
                    isBooked= false;
                    isInvoiced = false; 
                    isHold = false;
                    isError = false;                   
                }
                //Added by ENP - END
                if (oelw.oel.Status__c != 'Complete')
                {
                    isComplete = false;
                    if (oelw.oel.Status__c != 'Shipped')                            
                    {
                        isShipped = false;
                        if (oelw.oel.Status__c == 'Partially Shipped')
                        {
                            isPartiallyShipped = true;
                        }
                        else
                        {                                   
                            system.debug('@@iguoer '+oelw.oel.Status__c);
                            if (oelw.oel.Status__c != 'Pre-Production')
                            {
                                isPreProd = false;
                                if (oelw.oel.Status__c == 'In Production')
                                {
                                    isInProduction = true;
                                }
                            }
                        }   
                    }
                    else
                    {
                        isPartiallyShipped = true;
                    }
                	}
            }
        }
        
        if (isCancelled)
        {
            newStatus = 'Cancelled';
        }
        else
        {
            //SW_ITEMS_INVOICE_HOLD
         /*    if(oelSSInvoiced && oelSSBooked && oelSSPlanned ){
               newStatus = 'Planned';  
            }*/
            if(oelSSInvoiced && oelSSBooked && !oelSSPlanned && !oelSSHold && !oelSSHoldRequested && !oelSSHoldRelRequested){
               newStatus = 'Booked';  
            } 
            
            
            if (isComplete)
            {
                newStatus = 'Complete'; 
            }
            else
            {
                if (isShipped)
                {
                    newStatus = 'Shipped';  
                }
                else
                {
                    if (isPartiallyShipped)
                    {
                        newStatus = 'Partially Shipped';    
                    }
                    else
                    {
                        if (isInProduction)
                        {
                            newStatus = 'In Production';    
                        }
                        else
                        {
                            system.debug('@@iguoer'+isplanned+''+ispreprod);
                           if (isPreProd)
                            {
                                newStatus = 'Pre-Production';   
                            }
                            //Added by ENP - START
                            else{
                                if (isPlanned) {
                                    newStatus = 'Planned';
                                }
                                else{
                                    if (isApprovedtoShip){
                                        newStatus = 'Approved-to-Ship';
                                    }
                                    else{
                                        if(isBooked){
                                            newStatus = 'Booked';                                           
                                        }
                                        else {
                                            if(isInvoiced){
                                                newStatus = 'Invoiced';                                             
                                            }
                                            else {
                                            if(isHold){
                                                newStatus = 'Hold';                                             
                                            }
                                            else {
                                            if(isError){
                                                newStatus = 'Integration Error';                                             
                                            }
                                            }
                                            }
                                        }
                                        
                                    }                                   
                                }
                            }
                            //Added by ENP - END
                        }
                    }                       
                }
            }
        }
        return newStatus;
    }
    
    public void setIntegrationScope(String scope)
    {
        if (oer.Integration_Scope__c == null)
        {
            oer.Integration_Scope__c = scope;
        }
        else
        {
            if (oer.Integration_Scope__c != 'Release and Line Items')
            {
                if (oer.Integration_Scope__c != scope)
                {
                    oer.Integration_Scope__c = 'Release and Line Items';
                }
            }
        }
    }
    
    public Boolean allLinesPreConfirmation()
    {
        Boolean result = true;
        for (OrderEntryLineWrapper oelw : oelwList)
        {
            if (!preConfirmationStatus.contains(oelw.oel.Status__c))
            {
                return false;
            }
        }
        return true;
    }
    
    public Boolean allLinesPreIntegration()
    {
        Boolean result = true;
        for (OrderEntryLineWrapper oelw : oelwList)
        {
            if (!preIntegrationStatus.contains(oelw.oel.Status__c))
            {
                return false;
            }
        }
        return true;
    }
   
    public void reCalculateRollups()
    {
        // Method added in V.6
        
        Decimal IGUTotalArea = 0.0;
        Decimal IGUTotalAreaM = 0.0;
        Decimal IGUCount = 0.0;
        
        Decimal totalPrice = 0.0;
        Decimal IGUOpenCount = 0.0;
        Decimal IGUOpenArea = 0.0;
        Decimal IGUOpenAreaM = 0.0;
        Decimal openExtendedPrice = 0.0;
        //Added by ENP - START
        //Control Panels
        Decimal cpQty = 0;
        Decimal cpPrice = 0.0;
        //Control Sensors
        Decimal csQty = 0;
        Decimal csPrice = 0.0;
        //Trunk Cables
        Decimal tcQty = 0;
        Decimal tcPrice = 0.0;
        //Drop Cables
        Decimal dcQty = 0;
        Decimal dcPrice = 0.0;
        //IGU Cables
        Decimal iguQty = 0;
        Decimal iguPrice = 0.0;
        //Window Controller
        Decimal wcQty = 0;
        Decimal wcPrice = 0.0;
        //Terminator 
        Decimal tecQty = 0;
        Decimal tecPrice = 0.0;
        //Added by ENP - END
        Decimal cssTotalQty = 0;
        
        
        for (OrderEntryLineWrapper oelw : oelwList)
        {       
            Order_Entry_Line__c oel = oelw.oel;
            //System.debug('@@##$$%%'+oel.Product_Name__c);
            if(oel.Status__c != 'Cancelled')
            {
                
                totalPrice += oel.Extended_Price__c;
                if(!Test.isRunningTest())
                openExtendedPrice += (oel.Open_Quantity__c * oel.Unit_Price__c).setScale(2);// Added by ENP
                if (oelw.RecordType.contains('IGU'))                
                {
                    {
                        
                        IGUCount += oel.Quantity__c;
                        IGUOpenCount += oel.Open_Quantity__c;
                        IGUOpenArea += oel.Unit_Area_Sq_Ft__c * oel.Open_Quantity__c;
                        IGUTotalArea += oel.Area_Sq_Ft__c;
                        
                        if (oel.Total_Area_Sq_m__c != null)
                        {
                            IGUTotalAreaM += oel.Total_Area_Sq_M__c;
                            IGUOpenAreaM += oel.Unit_Area_Sq_M__c * oel.Open_Quantity__c;
                        }
                    }
                }
                else{
                    System.debug('@@##$$%%'+oel.Product_Component_Type__c);
                    if(oel.Quantity__c!=null && oel.Unit_Price__c!=null){
                        if(oel.Product_Component_Type__c!=null && oel.Product_Component_Type__c == 'Control Panel'){                
                            cpQty += oel.Quantity__c;
                            cpPrice += oel.Unit_Price__c * oel.Quantity__c;                       
                        }
                        if(oel.Product_Component_Type__c!=null && oel.Product_Component_Type__c == 'Sensor'){               
                            csQty += oel.Quantity__c;
                            csPrice += oel.Unit_Price__c* oel.Quantity__c;                       
                        }
                        if(oel.Product_Component_Type__c!=null && oel.Product_Component_Type__c == 'Window Controller'){               
                            wcQty += oel.Quantity__c;
                            wcPrice += oel.Unit_Price__c * oel.Quantity__c;                       
                        }
                        if(oel.Product_Component_Type__c!=null && oel.Product_Component_Type__c == 'Trunk Cable'){               
                            tcQty += oel.Quantity__c;
                            tcPrice += oel.Unit_Price__c * oel.Quantity__c;                       
                        }
                        if(oel.Product_Component_Type__c!=null && oel.Product_Component_Type__c == 'Drop Cable'){               
                            dcQty += oel.Quantity__c;
                            dcPrice += oel.Unit_Price__c * oel.Quantity__c;                       
                        }
                        if(oel.Product_Component_Type__c!=null && oel.Product_Component_Type__c == 'IGU Cable'){               
                            iguQty += oel.Quantity__c;
                            iguPrice += oel.Unit_Price__c * oel.Quantity__c;                       
                        }
                        if(oel.Product_Component_Type__c!=null && oel.Product_Component_Type__c == 'Connector, Terminator, and Other'){               
                            tecQty += oel.Quantity__c;
                            tecPrice += oel.Unit_Price__c * oel.Quantity__c;                       
                        }
                    }  
                    if(oel.Quantity__c!=null) {
                        cssTotalQty+= oel.Quantity__c;
                    }                 
                }
            }
        }
        if (oer.RecordType.DeveloperName.contains('IGU')){
            if (IGUCount != oer.IGU_Count__c)
            {
                oer.IGU_Count__c = IGUCount;
                isUpdated = true;
            }
            if (IGUOpenCount != oer.IGU_Open_Count__c)
            {
                oer.IGU_Open_Count__c = IGUOpenCount;
                isUpdated = true;
            }
            
            if (IGUTotalArea != oer.IGU_Area_Sq_Ft__c)
            {
                oer.IGU_Area_Sq_Ft__c = IGUTotalArea;
                isUpdated = true;
            }
            
            if (IGUOpenArea != oer.IGU_Open_Area_Sq_Ft__c)
            {
                oer.IGU_Open_Area_Sq_Ft__c = IGUOpenArea;
                isUpdated = true;
            }
            
            if (IGUTotalAreaM != oer.IGU_Area_Sq_M__c)
            { 
                oer.IGU_Area_Sq_M__c = IGUTotalAreaM;
                isUpdated = true;
            }
            
            if(IGUOpenAreaM != oer.IGU_Open_Area_Sq_M__c)
            {
                oer.IGU_Open_Area_Sq_M__c = IGUOpenAreaM;
                isUpdated = true;
            }           
            /*if (totalPrice != oer.Extended_Price_Total__c){
                oer.Extended_Price_Total__c = totalPrice;
                isUpdated = true;
            }*/
            
        }
        //Added by ENP - START
        else{
            if (oer.Control_Panel_Qty__c != cpQty || oer.Control_Panel_Total_Price__c != cpPrice){
                oer.Control_Panel_Total_Price__c = cpPrice;
                oer.Control_Panel_Qty__c = cpQty;
                isUpdated = true;   
            }
            if (oer.Sensor_Total_Quantity__c != csQty || oer.Sensor_Total_Price__c != csPrice){
                oer.Sensor_Total_Quantity__c = csQty;
                oer.Sensor_Total_Price__c = csPrice;
                isUpdated = true;   
            }
            if (oer.IGU_Cables_Total_Qty__c != iguQty || oer.IGU_Cables_Total_Price__c != iguPrice){
                oer.IGU_Cables_Total_Qty__c = iguQty;
                oer.IGU_Cables_Total_Price__c = iguPrice;
                isUpdated = true;   
            }
            if (oer.Drop_Cables_Total_Qty__c != dcQty || oer.Drop_Cables_Total_Price__c != dcPrice){
                oer.Drop_Cables_Total_Qty__c = dcQty;
                oer.Drop_Cables_Total_Price__c = dcPrice;
                isUpdated = true;   
            }   
            if (oer.Trunk_Cables_Total_Qty__c != tcQty || oer.Trunk_Cables_Total_Price__c != tcPrice){
                oer.Trunk_Cables_Total_Qty__c = tcQty;
                oer.Trunk_Cables_Total_Price__c = tcPrice;
                isUpdated = true;   
            }
            if (oer.Terminator_and_Connectors_Total_Qty__c != tecQty || oer.Terminator_and_Connectors_Total_Price__c != tecPrice){
                oer.Terminator_and_Connectors_Total_Qty__c = tecQty;
                oer.Terminator_and_Connectors_Total_Price__c = tecPrice;
                isUpdated = true;   
            }
            if (oer.Window_Controller_Total_Qty__c != wcQty || oer.Window_Controller_Total_Price__c != wcPrice){
                oer.Window_Controller_Total_Qty__c = wcQty;
                oer.Window_Controller_Total_Price__c = wcPrice;
                isUpdated = true;   
            }
            if(oer.CSS_Total_Rollup_Qty__c != cssTotalQty) {
                oer.CSS_Total_Rollup_Qty__c = cssTotalQty;
                 isUpdated = true;
            }
            //Added by ENP - END
        }
        //Added by enp
        if (oer.Extended_Price_Open__c != openExtendedPrice)
        {
            oer.Extended_Price_Open__c = openExtendedPrice;
            isUpdated = true;
        }
        if(totalPrice != oer.Extended_Price_Total__c){
            oer.Extended_Price_Total__c = totalPrice;
            isUpdated = true;
        }           
        return;
    }
}