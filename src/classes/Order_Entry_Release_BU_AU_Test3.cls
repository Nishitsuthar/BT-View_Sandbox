@isTest
public class Order_Entry_Release_BU_AU_Test3

{
    // IGU
    // Update line
 static testMethod void testMethodOne()
    {
        //
        // Test Normal Order Entry Release Status Workflow Sequence - Draft to Pre-Production
        //
        System.debug('No.Of Queries Fired#'+Limits.getQueries());
        Map<String,Integer> entityCounts = new Map<String, Integer> {'AdminUsers' => 1, 'Users' => 1, 'Products' => 1,      
            'OpptyAccts' => 1, 'BillToAccts' => 1, 'ShipToAccts' => 1, 'SoldToAccts' => 1, 'ContactsPerAcct' => 1, 'OpptysPerOpptyAcct' => 1,
            'QuotesPerOppty' => 2, 'CPOsPerOppty' => 2};
        
            System.debug('   SOQL LIMITS '+Limits.getQueries());
            OETestData oetd = OETestDataFactory.createNonOrderData(entityCounts);
            
            System.debug('   SOQL LIMITS '+Limits.getQueries());
          
            List <Order_Entry_Release__c> oerList = OETestDataFactory.createOEReleases(oetd, 1, 'Imperial (US Standard)','CPQ','IGU');
            System.debug('   SOQL LIMITS '+Limits.getQueries());
        Test.startTest();
                   
         Map<Id,List<Order_Entry_Line__c>> oelMap = OETestDataFactory.createOELines(oetd, oerList, 2);
         
              
            OETestDataFactory.progressStatusTo(oetd.oelMap.keySet(), 'Pre-Production', oetd); 
           
           System.debug('   SOQL LIMITS - Inside Start Method One '+Limits.getQueries());
         List<Order_Entry_Line__c> updatedOELs = new List<Order_Entry_Line__c>();
        Order_Entry_Release__c testRel;
        list<Order_Entry_Line__c> testOEL;
          testRel = [SELECT Id, Name, Opportunity__c, Order_Entry_Release_Date__c, CPQ_Quote__c,              
            Request_Date__c, Promised_Date__c, Scheduled_Ship_Date__c, Sold_to_Account__c, Sold_To_Street_1__c, Sold_to_City__c,
            Sold_To_Postal_Code__c, Sold_To_State_Province__c, Sold_to_Country__c, 
            Shipping_Account__c, Shipping_Street_1__c, Shipping_City__c, Shipping_Name__c,
            Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c,
            Billing_Account__c, Billing_Street_1__c, Billing_City__c,
            Billing_Postal_Code__c, Billing_State_Province__c, Billing_Country__c, 
            System_of_Measurement__c, Status__c, Integration_Status__c, Trigger_Source__c, 
            Release_Name__c, Billing_Contact__c, Sold_To_Contact__c,Shipping_Contact__c, 
            Packing_Instructions__c FROM Order_Entry_Release__c WHERE Id = :oerList[0].Id LIMIT 1];    
     
            
       testOEL = [SELECT Id, Order_Entry_Release__c, Quantity__c, Base_In__c, Height_In__c, Base_Height_1_In__c, Shape__c, Line_Number__c,
                    RecordTypeId, Status__c,Integration_Action_Requested__c,Integration_Status__c, Trigger_Source__c, CPQ_Quote_Line__c, Product__c, Order_Line_Type__c, Mark_Ids__c , Shipping_Name__c, 
                    Shipping_Street_1__c, Shipping_Account__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State_Province__c, Shipping_Country__c, 
                    Use_Account_Shipping_Address__c,Installation_Type__c,Request_Date__c, Scheduled_Ship_Date__c, Promised_Date__c FROM Order_Entry_Line__c 
                    WHERE Order_Entry_Release__c = :testRel.Id];
        
        System.assertEquals(testRel.status__c,'Pre-Production');
        System.assertEquals(testOEL[0].status__c,'Pre-Production');       
           
          testRel.Status__c = 'Cancellation Requested';
               testRel.Trigger_Source__c='UI';
                testRel.Cancellation_Reason__c = 'Customer Requested';
                
         
             Update testRel ;
       
                
         System.debug('CPU Time ---> '+ Limits.getCpuTime() + ' **** '+ 'SOQL ---> '+Limits.getQueries());
        
        Test.stopTest();
        
        
    }
     
   
}