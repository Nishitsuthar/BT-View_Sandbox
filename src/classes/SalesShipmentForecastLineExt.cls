/*** Controller ***/
public class SalesShipmentForecastLineExt {
    //public List<SalesForeCastLineWrapper> sfWrap {get;set;}
    public list<Sales_Shipment_Forecast_Line__c> sflines {get;set;}
    public Integer rowIndex {get;set;}
    public Integer rowIndex1 {get;set;}
    public Sales_Shipment_Forecast_Line__c defualtLine {get;set;}
    public Sales_Shipment_Forecast_Line__c con {get;set;}
    public Sales_Shipment_Forecast__c ssf{get; set;}
    public Boolean isError{get;set;}
    public String ProductFamily{get;set;}
    public String insertOption{get;set;}
    public Boolean beforeSave{get;set;}
    public Boolean afterSave{get;set;}
    public String nextProductFamily{get;set;}
    public List<Sales_Shipment_Forecast_Line__c> listSFL {get; set;}
    public List<Sales_Shipment_Forecast_Line__c> igulistSFL {get; set;}
    public List<Sales_Shipment_Forecast_Line__c> csslistSFL {get; set;}
    public Boolean showLines{get;set;}
    public Boolean showInsertOptions{get;set;}
    public Boolean autoSchedule{get;set;}
    public Date requestDate{get;set;}
    public integer noofShipments{get;set;}
    public String frequence{get;set;}
    public Boolean iscontinue{get;set;}
    public Boolean isNone{get;set;}
    String salesForecastId = '';
    public Id sfLineId{get;set;}
    public Id oppId{get;set;}
    public opportunity opp;
    public date oldgroundate;
    public boolean notfirst;
    
    public SalesShipmentForecastLineExt(){
        
    }
    public SalesShipmentForecastLineExt(ApexPages.StandardSetController controller){
        if(ApexPages.currentPage().getParameters().containskey('oldId')){
            notfirst=true;
            salesForecastId = ApexPages.currentPage().getParameters().get('oldId');
        }
        else{
            salesForecastId = ApexPages.currentPage().getParameters().get('Id');
            notfirst=false;
        }
        defualtLine= new Sales_Shipment_Forecast_Line__c();
        //sfWrap = new List<SalesForeCastLineWrapper>();
        sflines =new list<Sales_Shipment_Forecast_Line__c>();
        igulistSFL =new list<Sales_Shipment_Forecast_Line__c>();
        csslistSFL =new list<Sales_Shipment_Forecast_Line__c>();
        iscontinue=false;
        
        ssf=[select Id,Forecast_Date__c,Groundbreaking_Date__c,First_Request_Date_IGU__c,First_Request_Date_CSS__c,First_IGU_Shipment_Percentage__c,First_CSS_Shipment_Percentage__c,Opportunity__c,Opportunity__r.currencyisocode,Opportunity__r.IGU_Amount_Roll_Up__c,Opportunity__r.CSS_Amount_Roll_Up__c,Opportunity__r.Project_Glass_Quantity__c from Sales_Shipment_Forecast__c where id =: salesForecastId];
        oppId=ssf.Opportunity__c;
        oldgroundate= ssf.Groundbreaking_Date__c;
        opp=[select id,Ground_Breaking_Date__c, First_Request_Date_CSS__c, First_Request_Date_IGU__c from opportunity where Id=: oppId];
        listSFL =  [select Id,Status__c,Shipment_SqFt__c,Shipment_Amount__c,Product_Family__c,currencyisocode, Request_Date__c, Shipment_Percentage__c from Sales_Shipment_Forecast_Line__c 
                    where Sales_Shipment_Forecast__c=:salesForecastId and Status__c='Active' ORDER BY Product_Family__c,Request_Date__c ASC];
        isNone=true;
        ProductFamily = 'None';
        if(ApexPages.currentPage().getParameters().containskey('pf')){
            afterSave = true;
            beforeSave = false;
            //ProductFamily=ApexPages.currentPage().getParameters().get('pf');
            //nextProductFamily=ApexPages.currentPage().getParameters().get('pf');
            //addSFLine();
            
            
        }
        else{
            beforeSave = true;
            afterSave = false;
            
        }
        
        
        
        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('IGU','Change IGU Shipment Forecast')); 
        options.add(new SelectOption('CSS','Change CSS Shipment Forecast'));
        options.add(new SelectOption('None','Current Shipment Forecast')); 
        return options; 
    }
    public List<SelectOption> getInsertOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Manual','Manual Entry')); 
        options.add(new SelectOption('Automatic','Automatic Schedule'));
        return options; 
    }
    public List<SelectOption> getFrequnceOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1','Monthly')); 
        options.add(new SelectOption('3','Quarterly'));
        return options; 
    }
    /*public class SalesForeCastLineWrapper{         
public Integer row {get;set;}
public Sales_Shipment_Forecast_Line__c ct {get;set;}             
public SalesForeCastLineWrapper(Sales_Shipment_Forecast_Line__c cons,Integer ro){
this.ct = cons;
this.row = ro;
}
}*/
    
    public void deleteRow() {
        
        system.debug('@@row'+rowIndex);
        system.debug('@@row'+sflines.size());
        if(sflines.size()> 1){
            sflines.remove(rowIndex);                
            
        }       
    }
    public void calculateLines(){
        decimal sfpercentage=0;
        decimal percentagesum=0;
        if(sflines!=null)       
            sflines.clear();
        if(noofShipments!=null && noofShipments>0)
            sfpercentage=100/noofShipments;
        
        showLines = true; 
        date firstredate=defualtLine.Request_Date__c;
        for(Integer i=1; i<=noofShipments; i++)  {
            
            Sales_Shipment_Forecast_Line__c sf = new Sales_Shipment_Forecast_Line__c(); // create new instance of object
            sf.Sales_Shipment_Forecast__c  = salesForecastId;
            sf.currencyisocode = ssf.opportunity__r.currencyisocode;
            if(i==noofShipments){
                sf.Shipment_Percentage__c=100-percentagesum;
            }else{
                sf.Shipment_Percentage__c=sfpercentage;
                percentagesum=percentagesum+sfpercentage;
            }
            sf.Request_Date__c=firstredate;
            if(firstredate!=null){
                sflines.add(sf);
                
                if(frequence!=null)
                    firstredate=firstredate.addMonths(Integer.valueof(frequence));
            }
            
        }
        populateAmount();
        
    }
    public void addRows(){
        populateAmount();
        showLines = true; 
        Sales_Shipment_Forecast_Line__c sf = new Sales_Shipment_Forecast_Line__c(); // create new instance of object
        sf.Sales_Shipment_Forecast__c  = salesForecastId;
        sf.currencyisocode = ssf.opportunity__r.currencyisocode;
        //sfWrap.add(new SalesForeCastLineWrapper(sf,sfWrap.size())); 
        sflines.add(sf);
        
    }
    
    public pagereference save(){
        pagereference p;
        string pf=ProductFamily;
        set<date> reqdts =new set<date>();
        
        if(ProductFamily == 'None')
        {
            if(notfirst && opp.Ground_Breaking_Date__c != ssf.Groundbreaking_Date__c){
                createSF();
                notfirst = false;
            }
            /* if(ssf.Groundbreaking_Date__c > ssf.First_Request_Date_IGU__c)
{
isError=true;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Groundbreaking Date should be earlier than the IGU request date.'));
return null;
}
if(ssf.Groundbreaking_Date__c > ssf.First_Request_Date_CSS__c)
{
isError=true;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Groundbreaking Date should be earlier than the CSS request date.'));
return null;
}*/
            if(ssf.Groundbreaking_Date__c > ssf.First_Request_Date_IGU__c   || ssf.Groundbreaking_Date__c > ssf.First_Request_Date_CSS__c)
            {
                isError=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Groundbreaking Date should be earlier than first request date.'));
                return null;
            }
            update ssf;
            Boolean oppUpdated = false;
            if(opp.Ground_Breaking_Date__c != ssf.Groundbreaking_Date__c){opp.Ground_Breaking_Date__c = ssf.Groundbreaking_Date__c; oppUpdated=true;}
            if(opp.First_Request_Date_CSS__c != ssf.First_Request_Date_CSS__c) {opp.First_Request_Date_CSS__c = ssf.First_Request_Date_CSS__c; oppUpdated=true;}
            if(opp.First_Request_Date_IGU__c != ssf.First_Request_Date_IGU__c) {opp.First_Request_Date_IGU__c = ssf.First_Request_Date_IGU__c; oppUpdated=true;}
            
            if(oppUpdated){update opp;}       
            
            
            string s=URL.getSalesforceBaseUrl().toExternalForm()+'/'+oppId;
            p= new pagereference (s);
            return p;
        }
        Decimal totalper=0.0;
        List<Sales_Shipment_Forecast_Line__c> ccList = new List<Sales_Shipment_Forecast_Line__c>();
        List<Sales_Shipment_Forecast_Line__c> deleteSFlList = new List<Sales_Shipment_Forecast_Line__c>();
        date headerDate;
        Decimal firstper;
        integer count=0;
        
        /*if(afterSave && nextProductFamily !=null){
pf=nextProductFamily;
iscontinue=false;
}
else
pf=ProductFamily;*/
        
        //for(SalesForeCastLineWrapper wrapper : sfWrap)
        system.debug('@@sflines'+sflines);
        for(Sales_Shipment_Forecast_Line__c sfl:sflines)
        {
            if(sfl.Shipment_Percentage__c == 0)
            {
                isError=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Shipment Percentage should be > 0'));
                return null;
            }
            
            if(sfl.Request_Date__c !=null && sfl.Shipment_Percentage__c >=0){
                if(!reqdts.contains(sfl.Request_Date__c))
                    reqdts.add(sfl.Request_Date__c);
                else{
                    isError=true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Each forecast line should have a unique Request Date. Please combine the lines with the same Request Date.'));
                    return null;
                }
                if(pf == 'IGU'){
                    sfl.Shipment_SqFt__c = ssf.Opportunity__r.Project_Glass_Quantity__c * sfl.Shipment_Percentage__c/100;
                    sfl.Shipment_Amount__c = ssf.Opportunity__r.IGU_Amount_Roll_Up__c * sfl.Shipment_Percentage__c/100;
                }
                if(pf == 'CSS')
                    sfl.Shipment_Amount__c = ssf.Opportunity__r.CSS_Amount_Roll_Up__c * sfl.Shipment_Percentage__c/100;
                
                if(count == 0){
                    headerDate=sfl.Request_Date__c;
                    firstper = sfl.Shipment_Percentage__c;
                    count++;
                }
                if(count > 0 && headerDate >= sfl.Request_Date__c){
                    headerDate=sfl.Request_Date__c;
                    firstper = sfl.Shipment_Percentage__c;
                }
                sfl.Product_Family__c=pf;
                totalper=totalper+sfl.Shipment_Percentage__c;
                ccList.add(sfl);
            }
        }
        if(!ccList.isEmpty() && totalper== 100)
        {
            
            isError=false;
            for(Sales_Shipment_Forecast_Line__c sfl: [select Id,Status__c,Product_Family__c from Sales_Shipment_Forecast_Line__c where Sales_Shipment_Forecast__c=:salesForecastId AND  Product_Family__c=:pf])
            {
                
                //sfl.Status__c='Inactive';
                deleteSFlList.add(sfl);
            }
            
            
            //Sales_Shipment_Forecast__c sf = [select id,Groundbreaking_Date__c,First_Request_Date_IGU__c,First_Request_Date_CSS__c from Sales_Shipment_Forecast__c where id=:salesForecastId];
            //sf.Groundbreaking_Date__c = ssf.Groundbreaking_Date__c;
            if(pf == 'IGU'){
                ssf.First_Request_Date_IGU__c=headerDate;
                ssf.First_IGU_Shipment_Percentage__c= firstper;
            }
            if(pf == 'CSS'){
                ssf.First_Request_Date_CSS__c=headerDate;
                ssf.First_CSS_Shipment_Percentage__c= firstper;
            }
            /*if(ssf.Groundbreaking_Date__c > ssf.First_Request_Date_IGU__c  )
{
isError=true;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Groundbreaking Date should be earlier than the IGU request date.'));
return null;
}
if(ssf.Groundbreaking_Date__c > ssf.First_Request_Date_CSS__c)
{
isError=true;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Groundbreaking Date should be earlier than the CSS request date.'));
return null;
}*/
            
            if(ssf.Groundbreaking_Date__c > ssf.First_Request_Date_IGU__c   || ssf.Groundbreaking_Date__c > ssf.First_Request_Date_CSS__c)
            {
                isError=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Groundbreaking Date should be earlier than first request date.'));
                return null;
            }
            try{
                
                if(!deleteSFlList.isEmpty())
                    delete deleteSFlList;
                upsert ccList;
            }
            catch(DMLException Ex){
                isError=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Ex.getDMLMessage(0)));
                return null;
            }
            
            try{
                system.debug('updatting ssf');
                update ssf;
                Boolean oppUpdated = false;
                if(opp.Ground_Breaking_Date__c != ssf.Groundbreaking_Date__c){opp.Ground_Breaking_Date__c = ssf.Groundbreaking_Date__c; oppUpdated = true; }
                if(opp.First_Request_Date_CSS__c != ssf.First_Request_Date_CSS__c) {opp.First_Request_Date_CSS__c = ssf.First_Request_Date_CSS__c; oppUpdated=true;}
                if(opp.First_Request_Date_IGU__c != ssf.First_Request_Date_IGU__c) {opp.First_Request_Date_IGU__c = ssf.First_Request_Date_IGU__c; oppUpdated=true;}
                if(oppUpdated) { update opp; }
                
            }
            catch(DMLException excp){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,excp.getdmlMessage(0)));
                return null;
            }
            
            if(!iscontinue){
                system.debug('@@red');
                string s=URL.getSalesforceBaseUrl().toExternalForm()+'/'+oppId;
                p=new pagereference (s);
                //p=new ApexPages.StandardController(Sales_Shipment_Forecast_Line__c).view();
                
                
            }
            
            return  p;
        }
        else{
            isError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Shipment Percentage should add up to 100'));
            return null;
        }
        
    }
    public void showInsertLinesOptions() {
        igulistSFL.clear();
        csslistSFL.clear();
        showLines = false;
        autoSchedule=false;
        insertOption='';
        if(ProductFamily != 'None')  {
            showInsertOptions=true;
            isNone=false;
            for(Sales_Shipment_Forecast_Line__c sfl:listSFL)
            {
                if(sfl.Product_Family__c == 'IGU')
                    igulistSFL.add(sfl);
                if(sfl.Product_Family__c == 'CSS')
                    csslistSFL.add(sfl);
                
            }
        }else{
            showInsertOptions=false;
            isNone=true;
        }
    }
    public void addSFLine() {
        
        if(insertOption=='Manual'){
            autoSchedule=false;
            if(sflines!=null)       
                sflines.clear();
            if(ProductFamily != 'None')  {      
                
                isNone=false;
                showLines = true;
                for(Sales_Shipment_Forecast_Line__c sfl:listSFL)
                {       Sales_Shipment_Forecast_Line__c sf = new Sales_Shipment_Forecast_Line__c();
                 sf.Request_Date__c=sfl.Request_Date__c;
                 sf.Sales_Shipment_Forecast__c  = salesForecastId;
                 sf.currencyisocode = sfl.currencyisocode;
                 sf.Shipment_Percentage__c=sfl.Shipment_Percentage__c;
                 sf.Shipment_SqFt__c=sfl.Shipment_SqFt__c;
                 sf.Shipment_Amount__c=sfl.Shipment_Amount__c;
                 
                 if(sfl.Product_Family__c == ProductFamily)
                     sflines.add(sf);
                }
                /*Sales_Shipment_Forecast_Line__c sf = new Sales_Shipment_Forecast_Line__c(); // create new instance of object
sf.Sales_Shipment_Forecast__c  = salesForecastId;
if(ProductFamily=='CSS'){
sf.Request_Date__c=ssf.First_Request_Date_CSS__c;
}
else if(ProductFamily=='IGU'){
sf.Request_Date__c=ssf.First_Request_Date_IGU__c;
}
sf.currencyisocode = ssf.opportunity__r.currencyisocode;
sflines.add(sf);*/
                
                
            }
            else{
                showLines = false;
                isNone=true;
            }
        }else{
            if(ProductFamily=='CSS'){
                defualtLine.Request_Date__c=ssf.First_Request_Date_CSS__c;
            }
            else if(ProductFamily=='IGU'){
                defualtLine.Request_Date__c=ssf.First_Request_Date_IGU__c;
            }
            autoSchedule=true;
            noofShipments=0;
            showLines = false;
        }
        
        
        
        
    }
    public void populateAmount()
    {
        //system.debug('@row'+rowIndex);
        //Sales_Shipment_Forecast_Line__c sfl= sflines.get(rowIndex);
        //system.debug('@per'+sfl.Shipment_Percentage__c);
        string wngmsg;
        for(Sales_Shipment_Forecast_Line__c sfl:sflines)
        {
            if(sfl.Shipment_Percentage__c !=null && sfl.Shipment_Percentage__c !=0){
                if(ProductFamily == 'IGU'){
                    sfl.Shipment_SqFt__c = ssf.Opportunity__r.Project_Glass_Quantity__c * sfl.Shipment_Percentage__c/100;
                    if(sfl.Shipment_SqFt__c > 30000)
                        wngmsg = 'One of the IGU shipment forecast line has a Shipment SqFt  over 30,000 SqFt. Please ensure it is accurate.';
                    sfl.Shipment_Amount__c = ssf.Opportunity__r.IGU_Amount_Roll_Up__c * sfl.Shipment_Percentage__c/100;
                }
                else
                    sfl.Shipment_Amount__c = ssf.Opportunity__r.CSS_Amount_Roll_Up__c * sfl.Shipment_Percentage__c/100;
                
            }
        }
        if(wngmsg != null && wngmsg!='')
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,wngmsg));
    }
    public void reclculateAmountandSftfromOpty(Set<Id> oppIds,Map<id,opportunity> newMap)
    {    
        List<Sales_Shipment_Forecast_Line__c> existingLines= new List<Sales_Shipment_Forecast_Line__c>();
        existingLines=[select Id,Status__c,Shipment_SqFt__c,Shipment_Amount__c,Sales_Shipment_Forecast__r.Opportunity__c,Product_Family__c,currencyisocode, Request_Date__c, Shipment_Percentage__c from Sales_Shipment_Forecast_Line__c 
                       where Sales_Shipment_Forecast__r.Opportunity__c in : oppIds and Status__c='Active' AND Sales_Shipment_Forecast__r.Status__c='Active'];
        for(Sales_Shipment_Forecast_Line__c sfl:existingLines)
        {
            if(sfl.Shipment_Percentage__c !=null && sfl.Shipment_Percentage__c !=0){
                if(sfl.Sales_Shipment_Forecast__c!=null){
                    Opportunity oppty= newMap.get(sfl.Sales_Shipment_Forecast__r.Opportunity__c);
                    if(sfl.Product_Family__c == 'IGU' && oppty!=null){
                        sfl.Shipment_SqFt__c = oppty.Project_Glass_Quantity__c * sfl.Shipment_Percentage__c/100;
                        sfl.Shipment_Amount__c = oppty.IGU_Amount_Roll_Up__c * sfl.Shipment_Percentage__c/100;
                    }
                    else if(oppty!=null)
                        sfl.Shipment_Amount__c = oppty.CSS_Amount_Roll_Up__c * sfl.Shipment_Percentage__c/100;
                }
            }
        }
        if(!existingLines.isEmpty()){
            update existingLines;
        }
    }
    public pagereference saveAndContinue(){
        afterSave = true;
        beforeSave = false; 
        iscontinue=true;    
        
        if(notfirst)
        {
            system.debug('@@createSF');
            createSF();
            notfirst = false;
        }
        pagereference p = save();
        system.debug('saveAndContinue isError>>'+isError);
        if(isError){
            beforeSave = true;
            afterSave = false;
            isError=false;
            system.debug('saveAndContinue isError>111>'+isError);
            return null;
            
        }
        
        if(ProductFamily == 'IGU'){
            nextProductFamily = 'CSS';        
        }
        else{
            nextProductFamily = 'IGU';
        }
        
        system.debug('@@return'+p);
        
        p= new pagereference ('/apex/EditSalesShipmentForecastLines');
        p.getParameters().put('Id',salesForecastId);
        p.getParameters().put('pf',nextProductFamily);
        
        p.setRedirect(true);
        
        return p;    
        //return null;
    }
    public void createSF()
    {
        Sales_Shipment_Forecast__c newssf = ssf.clone(false,false);
        newssf.Forecast_Date__c = system.today();
        insert newssf;
        salesForecastId = newssf.Id;
        for(Sales_Shipment_Forecast_Line__c sfl:sflines)
        {
            sfl.Sales_Shipment_Forecast__c=newssf.Id;
        }
        ssf = [select id,Forecast_Date__c,Groundbreaking_Date__c,First_Request_Date_IGU__c,First_Request_Date_CSS__c,First_IGU_Shipment_Percentage__c,First_CSS_Shipment_Percentage__c,Opportunity__c,Opportunity__r.currencyisocode,Opportunity__r.IGU_Amount_Roll_Up__c,Opportunity__r.CSS_Amount_Roll_Up__c,Opportunity__r.Project_Glass_Quantity__c from Sales_Shipment_Forecast__c where id=:newssf.Id];   
    }
    public pagereference cancel()
    {
        string s=URL.getSalesforceBaseUrl().toExternalForm()+'/'+oppId;
        pagereference p=new pagereference (s);
        return p;
    }
    
}