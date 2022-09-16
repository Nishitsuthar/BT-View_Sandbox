@isTest
public class Order_Entry_BulkLoadExt_Test
{
    
    static testMethod void TestMethod1()
    {
        Test.startTest();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        
        Order_Entry_Release__c testOER = oetd.oerList[0];
        testOER.System_of_Measurement__c = 'Metric' ;
        String testData1 =  '1315872-01\t14D\t3\t14 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-02\t14E\t4\t58 12/16\tX\t22 12/16\t\t\t\r\n' +
                            '1315872-03\t14F\t5\t28 10/16\tX\t117      \t\t\t\r\n' +
                            '1315872-04\t15A\t6\t47 14/16\tX\t117      \t\t\t\r\n' +
                            '1315872-05\t15B\t17\t58 12/16\tX\t117      \t\t\t\r\n' +
                            '1315872-06\t15C\t2\t58 12/16\tX\t22 12/16\t302      \t54 12/16\t\r\n' +
                            '1315872-07\t15D\t2\t17 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-08\t15B-1\t11\t58 12/16\tX\t55 14/16\t46      \t\t\r\n' +
                            '1315872-09\t15E\t7\t53  6/16\tX\t117      \t1      \t108 13/16\t\r\n' +
                            '1315872-10\t16A\t8\t12  7/16\tX\t93      \t\t\tY\r\n' +
                            '1315872-11\t16B\t9\t53  6/16\tX\t13      \t\t\tY\r\n' +
                            '1315872-12\t16C\t5\t58 12/16\tX\t12 12/16\t\t\tY\r\n' +
                            '1315872-13\t16D\t11\t13      \tX\t117      \t\t\tY\r\n';   
                            
        String testData2 =  '1315872-01\t14D\t\t\tX\t125      \t\t\t\r\n' +
                            '1315872-02\t14E\t4\t58 12/16\tX\t22 12/16\t\t\t\r\n' +
                            '1315872-03\t14F\t5\t28 10/16\tX\t117      \t\t\t\r\n' +
                            '1315872-04\t15A\t6\t47 14/16\tX\t117      \t\t\t\r\n' +
                            '1315872-05\t15B\t17\t58 12/16\tX\t117      \t\t\t\r\n' +
                            '1315872-06\t15C\t2\t58 12/16\tX\t22 12/16\t302      \t54 12/16\t\r\n' +
                            '1315872-07\t15D\t2\t17 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-08\t15B-1\t11\t58 12/16\tX\t55 14/16\t46      \t\t\r\n' +
                            '1315872-09\t15E\t7\t53  6/16\tX\t117      \t1      \t108 13/16\t\r\n' +
                            '1315872-10\t16A\t8\t12  7/16\tX\t93      \t\t\tY\r\n' +
                            '1315872-11\t16B\t9\t53  6/16\tX\t13      \t\t\tY\r\n' +
                            '1315872-12\t16C\t5\t58 12/16\tX\t12 12/16\t\t\tY\r\n' +
                            '1315872-13\t16D\t11\t13      \tX\t117      \t\t\tY\r\n';   
        //Test.startTest();
        PageReference pageRef = Page.Load_OEL;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(testOer.Id));
        List <Order_Entry_Line__c> newOELList = new List <Order_Entry_Line__c>();
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();      
        for (String key : paramMap.keySet())
        {
            System.debug('*** Key = ' + key + '; Value = ' + paramMap.get(key));
        }
        
        Order_Entry_BulkLoadExt oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.excelData = testData1;
        oeBLExt.load(); 
        
        oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.excelData = testData2;
        try 
        {
            oeBLExt.load(); 
        }
        catch (Exception ex)
        {
            System.debug('*** Exception = ' + ex.getMessage());
        }    
        //Test.stopTest();
        
    }
    
        static testMethod void TestMethod2()
    {
        Test.startTest();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        
        Order_Entry_Release__c testOER = oetd.oerList[0];
        String testData1 =  '380-101509-05\tI-66P\t60 \t\t\t\r\n' +
                            '380-101509-08\tI-76P\t80 \t\t\t\r\n' ; 
                            
        String testData2 =  '380-P00000-IGU\tI-66P\t60 \t\t\t\r\n' +
                            '380-101510-10\tI-66P\t90 \t\t\t\r\n' ;
                            
        //Test.startTest();
        PageReference pageRef = Page.Load_OEL;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(testOer.Id));
        List <Order_Entry_Line__c> newOELList = new List <Order_Entry_Line__c>();
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();      
        for (String key : paramMap.keySet())
        {
            System.debug('*** Key = ' + key + '; Value = ' + paramMap.get(key));
        }
        
        Order_Entry_BulkLoadExt oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.excelData = testData1;
        oeBLExt.load(); 
         oeBLExt.load();
        //oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.excelData = testData2;
        try 
        {
            oeBLExt.load(); 
        }
        catch (Exception ex)
        {
            System.debug('*** Exception = ' + ex.getMessage());
        }
           
        
        
       //Added by ENP 
        //oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.getProductSelections();
        
       //Added by ENP 
        //oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.cancel();
        //Added by Narasimha
       Order_Entry_PartiallyLoadExt patialLoad= new Order_Entry_PartiallyLoadExt(new ApexPages.StandardSetController(newOELList));
        patialLoad.excelData = testData1;
        patialLoad.load(); 
        patialLoad.excelData = testData2;
        try 
        {
            patialLoad.load(); 
        }
        catch (Exception ex)
        {
            System.debug('*** Exception = ' + ex.getMessage());
        }
        patialLoad.getProductSelections();
        patialLoad.cancel();
        

    }
    
    
   //Added by ENP - Start
    static testMethod void TestMethod_IGU_CancelReq()
    {
        Test.startTest();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        
        Order_Entry_Release__c testOER = oetd.oerList[0];
        testOER.System_of_Measurement__c = 'Metric' ;
        String testData1 =  '1315872-01\t14D\t3\t14 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-02\t14E\t4\t58 12/16\tX\t22 12/16\t\t\t\r\n' +
                            '1315872-03\t14F\t5\t28 10/16\tX\t117      \t\t\t\r\n' +
                            '1315872-04\t15A\t6\t47 14/16\tX\t117      \t\t\t\r\n' +
                            '1315872-05\t15B\t17\t58 12/16\tX\t117      \t\t\t\r\n' +
                            '1315872-06\t15C\t2\t58 12/16\tX\t22 12/16\t302      \t54 12/16\t\r\n' +
                            '1315872-07\t15D\t2\t17 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-08\t15B-1\t11\t58 12/16\tX\t55 14/16\t46      \t\t\r\n' +
                            '1315872-09\t15E\t7\t53  6/16\tX\t117      \t1      \t108 13/16\t\r\n' +
                            '1315872-10\t16A\t8\t12  7/16\tX\t93      \t\t\tY\r\n' +
                            '1315872-11\t16B\t9\t53  6/16\tX\t13      \t\t\tY\r\n' +
                            '1315872-12\t16C\t5\t58 12/16\tX\t12 12/16\t\t\tY\r\n' +
                            '1315872-13\t16D\t11\t13      \tX\t117      \t\t\tY\r\n';   
                            
        String testData2 =  '1315872-01\t14D\t\t\tX\t125      \t\t\t\r\n' +
                            '1315872-02\t14E\t4\t58 12/16\tX\t22 12/16\t\t\t\r\n' +
                            '1315872-03\t14F\t5\t28 10/16\tX\t117      \t\t\t\r\n' +
                            '1315872-04\t15A\t6\t47 14/16\tX\t117      \t\t\t\r\n' +
                            '1315872-05\t15B\t17\t58 12/16\tX\t117      \t\t\t\r\n' +
                            '1315872-06\t15C\t2\t58 12/16\tX\t22 12/16\t302      \t54 12/16\t\r\n' +
                            '1315872-07\t15D\t2\t17 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-08\t15B-1\t11\t58 12/16\tX\t55 14/16\t46      \t\t\r\n' +
                            '1315872-09\t15E\t7\t53  6/16\tX\t117      \t1      \t108 13/16\t\r\n' +
                            '1315872-10\t16A\t8\t12  7/16\tX\t93      \t\t\tY\r\n' +
                            '1315872-11\t16B\t9\t53  6/16\tX\t13      \t\t\tY\r\n' +
                            '1315872-12\t16C\t5\t58 12/16\tX\t12 12/16\t\t\tY\r\n' +
                            '1315872-13\t16D\t11\t13      \tX\t117      \t\t\tY\r\n';   
        //Test.startTest();
        
        testOER = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c, Scheduled_Ship_Date__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :testOER.Id LIMIT 1];
      
        
        testOER.Status__c='Cancellation Requested';
        testOER.Cancellation_Reason__c='System Design Change';
        update testOER;
        
        PageReference pageRef = Page.Load_OEL;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(testOer.Id));
        List <Order_Entry_Line__c> newOELList = new List <Order_Entry_Line__c>();
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();      
        for (String key : paramMap.keySet())
        {
            System.debug('*** Key = ' + key + '; Value = ' + paramMap.get(key));
        }
        
        Order_Entry_BulkLoadExt oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.excelData = testData1;
        
        try{
          oeBLExt.load(); 
        }catch(Exception excp){}
        
        //oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.excelData = testData2;
        try 
        {
            oeBLExt.load(); 
        }
        catch (Exception ex)
        {
            System.debug('*** Exception = ' + ex.getMessage());
        }    
        Order_Entry_PartiallyLoadExt patialLoad= new Order_Entry_PartiallyLoadExt(new ApexPages.StandardSetController(newOELList));
        patialLoad.excelData = testData1;
        try{
        patialLoad.load(); 
        }
        catch(Exception excp){}
        patialLoad.excelData = testData2;
        try 
        {
            patialLoad.load(); 
        }
        catch (Exception ex)
        {
            System.debug('*** Exception = ' + ex.getMessage());
        }
        
    }
    //  
   
    //Added by ENP - Start
    static testMethod void testMethod_SFDCQuote()
    {
        Test.startTest();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','SFDC');
        
        Order_Entry_Release__c testOER = oetd.oerList[0];
        testOER.System_of_Measurement__c = 'Metric' ;
        String testData1 =  '1315872-01\t14D\t3\t14 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-02\t14E\t4\t58 12/16\tX\t22 12/16\t\t\t\r\n' +
                            '1315872-03\t14F\t5\t28 10/16\tX\t117      \t\t\t\r\n' +
                            '1315872-04\t15A\t6\t47 14/16\tX\t117      \t\t\t\r\n' +
                            '1315872-05\t15B\t17\t58 12/16\tX\t117      \t\t\t\r\n' +
                            '1315872-06\t15C\t2\t58 12/16\tX\t22 12/16\t302      \t54 12/16\t\r\n' +
                            '1315872-07\t15D\t2\t17 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-08\t15B-1\t11\t58 12/16\tX\t55 14/16\t46      \t\t\r\n' +
                            '1315872-09\t15E\t7\t53  6/16\tX\t117      \t1      \t108 13/16\t\r\n' +
                            '1315872-10\t16A\t8\t12  7/16\tX\t93      \t\t\tY\r\n' +
                            '1315872-11\t16B\t9\t53  6/16\tX\t13      \t\t\tY\r\n' +
                            '1315872-12\t16C\t5\t58 12/16\tX\t12 12/16\t\t\tY\r\n' +
                            '1315872-13\t16D\t11\t13      \tX\t117      \t\t\tY\r\n';   
                            
        String testData2 =  '1315872-01\t14D\t\t\tX\t125      \t\t\t\r\n' +
                            '1315872-02\t14E\t4\t58 12/16\tX\t22 12/16\t\t\t\r\n' +
                            '1315872-03\t14F\t5\t28 10/16\tX\t117      \t\t\t\r\n' +
                            '1315872-04\t15A\t6\t47 14/16\tX\t117      \t\t\t\r\n' +
                            '1315872-05\t15B\t17\t58 12/16\tX\t117      \t\t\t\r\n' +
                            '1315872-06\t15C\t2\t58 12/16\tX\t22 12/16\t302      \t54 12/16\t\r\n' +
                            '1315872-07\t15D\t2\t17 13/16\tX\t93      \t\t\t\r\n' +
                            '1315872-08\t15B-1\t11\t58 12/16\tX\t55 14/16\t46      \t\t\r\n' +
                            '1315872-09\t15E\t7\t53  6/16\tX\t117      \t1      \t108 13/16\t\r\n' +
                            '1315872-10\t16A\t8\t12  7/16\tX\t93      \t\t\tY\r\n' +
                            '1315872-11\t16B\t9\t53  6/16\tX\t13      \t\t\tY\r\n' +
                            '1315872-12\t16C\t5\t58 12/16\tX\t12 12/16\t\t\tY\r\n' +
                            '1315872-13\t16D\t11\t13      \tX\t117      \t\t\tY\r\n';   
        //Test.startTest();
        PageReference pageRef = Page.Load_OEL;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(testOer.Id));
        List <Order_Entry_Line__c> newOELList = new List <Order_Entry_Line__c>();
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();      
        for (String key : paramMap.keySet())
        {
            System.debug('*** Key = ' + key + '; Value = ' + paramMap.get(key));
        }
        
        Order_Entry_BulkLoadExt oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.excelData = testData1;
        oeBLExt.load(); 

        //oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        oeBLExt.excelData = testData2;
        try 
        {
            oeBLExt.load(); 
        }
        catch (Exception ex)
        {
            System.debug('*** Exception = ' + ex.getMessage());
        }    
        Order_Entry_PartiallyLoadExt patialLoad= new Order_Entry_PartiallyLoadExt(new ApexPages.StandardSetController(newOELList));
        patialLoad.excelData = testData1;
        
        patialLoad.load(); 
        
        patialLoad.excelData = testData2;
        try 
        {
            patialLoad.load(); 
        }
        catch (Exception ex)
        {
            System.debug('*** Exception = ' + ex.getMessage());
        }
        
        
    }
    //
    
     //Added by ENP - Start
    static testMethod void testMethod_createOELs_loader()
    {
        Test.startTest();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Hardware);
        Order_Entry_Line__c testOEL;
        Order_Entry_Release__c testOER = oetd.oerList[0];
        testOER.System_of_Measurement__c = 'Metric' ;
        update testOER;
        Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1,Label.CSS_Hardware);
        testOEL = [SELECT Id, loader__c,Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c,Integration_Action_Requested__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testOER.Id LIMIT 1];
        testOEL.loader__c=true;
        update testOEL;
       
        PageReference pageRef = Page.Load_OEL;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(testOER.Id));
        List <Order_Entry_Line__c> newOELList = new List <Order_Entry_Line__c>();
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();      
        for (String key : paramMap.keySet())
        {
            System.debug('*** Key = ' + key + '; Value = ' + paramMap.get(key));
        }
        
        Order_Entry_BulkLoadExt oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        Order_Entry_PartiallyLoadExt patialLoad= new Order_Entry_PartiallyLoadExt(new ApexPages.StandardSetController(newOELList));
        String testData1 =  '380-101509-05\tI-66P\t60 \t\t\t\r\n' +
                            '380-101509-08\tI-76P\t80 \t\t\t\r\n' ; 
        oeBLExt.excelData = testData1;
        try 
        {
            oeBLExt.load(); 
        }
        catch (Exception ex)
        {
            System.debug('*** Exception = ' + ex.getMessage());
        }    
        
    }
    //
    
    static testMethod void testMethod_SoftServOER()
    {
        Test.startTest();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ',Label.CSS_Software);
        Order_Entry_Line__c testOEL;
        Order_Entry_Release__c testOER = oetd.oerList[0];
                
        PageReference pageRef = Page.Load_OEL;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(testOER.Id));
        List <Order_Entry_Line__c> newOELList = new List <Order_Entry_Line__c>();
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();      
        for (String key : paramMap.keySet())
        {
            System.debug('*** Key = ' + key + '; Value = ' + paramMap.get(key));
        }
        
        Order_Entry_BulkLoadExt oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        Order_Entry_PartiallyLoadExt patialLoad= new Order_Entry_PartiallyLoadExt(new ApexPages.StandardSetController(newOELList));
        
        
    }
    //
    
        static testMethod void testMethod_ProductFamily()
    {
        Test.startTest();
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};        
        OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
        Test.stopTest();
        List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ');
        Order_Entry_Line__c testOEL;
        Order_Entry_Release__c testOER = oetd.oerList[0];
        
         Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 1);
         testOEL = [SELECT Id, loader__c, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Status__c, Trigger_Source__c,Integration_Action_Requested__c, CPQ_Quote_Line__c, Product__r.Family, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testOER.Id LIMIT 1];
        //********COMMENTING THIS AS PART OF BOS REFERENCE UPDATE WITH CSS
        //testOEL.Product__r.Family='BOS';
        testOEL.Product__r.Family='CSS';
        update testOEL;
                
        PageReference pageRef = Page.Load_OEL;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(testOER.Id));
        List <Order_Entry_Line__c> newOELList = new List <Order_Entry_Line__c>();
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();      
        for (String key : paramMap.keySet())
        {
            System.debug('*** Key = ' + key + '; Value = ' + paramMap.get(key));
        }
        
        Order_Entry_BulkLoadExt oeBLExt = new Order_Entry_BulkLoadExt(new ApexPages.StandardSetController(newOELList));
        Order_Entry_PartiallyLoadExt patialLoad= new Order_Entry_PartiallyLoadExt(new ApexPages.StandardSetController(newOELList));     
    }
 
    
}