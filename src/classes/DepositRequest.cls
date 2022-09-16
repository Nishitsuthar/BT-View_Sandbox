public class DepositRequest {
    
    @auraEnabled
    Public static string onLoadPickistVal(String quoteId){
        
        List<Customer_Purchase_Order__c> customerPOList= new List<Customer_Purchase_Order__c>();
        List<String> customerPOValues = new List<String>();
        
        invoiceWrapper iwp = new invoiceWrapper();
        List<SBQQ__Quote__c> QuoteRec = [SELECT Id,SBQQ__Account__r.Name,CurrencyIsoCode,Related_Opportunity__r.Name,Name,SBQQ__Account__r.BillingStreet,SBQQ__Account__r.BillingCity,SBQQ__Account__r.BillingCountry,SBQQ__Account__r.BillingState,SBQQ__Account__r.BillingPostalCode,Related_Opportunity__r.Opportunity_ID__c,SBQQ__Account__r.Oracle_Customer_Number__c
                                         FROM SBQQ__Quote__c WHERE Id = :quoteId];
        if(QuoteRec.size()>0){
            iwp.ProjectID = QuoteRec[0].Related_Opportunity__r.Opportunity_ID__c;
            iwp.CustomerID = QuoteRec[0].SBQQ__Account__r.Oracle_Customer_Number__c;
            iwp.CurrencyIsoCode = QuoteRec[0].CurrencyIsoCode;
            iwp.Quote = QuoteRec[0].Id;
            iwp.Opportunity = QuoteRec[0].Related_Opportunity__c;
            iwp.BillingStreet = QuoteRec[0].SBQQ__Account__r.BillingStreet;
            iwp.BillingCity = QuoteRec[0].SBQQ__Account__r.BillingCity;
            //iwp.BillingCountry = QuoteRec[0].SBQQ__Account__r.BillingCountry;
            if(QuoteRec[0].SBQQ__Account__r.BillingCountry != NULL)
				iwp.BillingCountry = AddressUtils.getStandardName(QuoteRec[0].SBQQ__Account__r.BillingCountry);
            iwp.BillingState = QuoteRec[0].SBQQ__Account__r.BillingState;
            iwp.BillingZip = QuoteRec[0].SBQQ__Account__r.BillingPostalCode;
            iwp.BillToAccount = QuoteRec[0].SBQQ__Account__r.Name;
            System.debug('QuoteRec[0].Related_Opportunity__c--->' +QuoteRec[0].Related_Opportunity__c);
            if(QuoteRec[0].Related_Opportunity__c != null){
            customerPOList = [select id, Name from Customer_Purchase_Order__c where Opportunity__c =: QuoteRec[0].Related_Opportunity__c];
                for(Customer_Purchase_Order__c cpo : customerPOList){
                   customerPOValues.add(cpo.name); 
                }
                iwp.customerPOAllValues= customerPOValues;
                System.debug('iwp.customerPOAllValues--->' +customerPOValues+ 'customerPOList----> '+customerPOList);
            }

        }
        
        list<string> termsOER= new list<string>();             
        Schema.DescribeFieldResult fieldResult13 = Order_Entry_Release__c.Payment_Terms__c.getDescribe();
        List<Schema.PicklistEntry> ple13 = fieldResult13.getPicklistValues();             
        termsOER.add('-- None --');             
        for(Schema.PicklistEntry s:ple13)
        {               
            termsOER.add(s.getLabel());                       
        }              
        iwp.varPicklist = termsOER;
        return Json.serialize(iwp);
    }
    
    @auraEnabled
    Public static string saveInvoice(String invoice1, String termsPickList, String CPOname, String Currencycd){
                System.debug('----CPOname--------->' +CPOname);
                System.debug('----invoice1--------->' +invoice1);
        //Invoice__c invoice = (Invoice__c)invoice1; 
        invoiceWrapper iw = new invoiceWrapper();
        
        try{
            Invoice__c objInvoice = (Invoice__c)json.deserialize(invoice1, Invoice__c.class);
            Id invoiceRecordtype = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Deposit_Request').getRecordTypeId();
            System.debug('---invoiceRecordtype--->' +invoiceRecordtype);
            System.debug('--------objInvoice-----------' +objInvoice);
            
            iw.successMessage = '';
            objInvoice.Terms__c = termsPickList;
            objInvoice.Customer_PO_Number__c = CPOname;
            objInvoice.RecordTypeId = invoiceRecordtype;
            objInvoice.CurrencyIsoCode = Currencycd;
            Insert objInvoice;
            System.debug('invoice---->' +objInvoice);
            iw.success = true;
            iw.invoice = objInvoice;
            iw.successMessage = 'Deposit Request is created';
            
            System.debug('successMessage' +iw.successMessage);

            iw.errorMessage ='';
        }
       catch(exception e){
           iw.success = false;
            
           System.debug('---In Exp log' +e.getMessage());
           iw.errorMessage = e.getMessage();
        }
        
        return Json.serialize(iw);
        
    }
    
    
    public class invoiceWrapper {
        String successMessage;
        List<String> varPicklist;
        List<String> customerPOAllValues;
        String errorMessage;
        Invoice__c invoice;
        String ProjectID;
        String CustomerID;        
        String Quote;
        String Opportunity;
        String BillingStreet;
        String BillingCity;
        String BillingCountry;
        String BillingState;
        String BillingZip;
        String BillToAccount;
        String CurrencyIsoCode;
        Boolean success;
    }
}