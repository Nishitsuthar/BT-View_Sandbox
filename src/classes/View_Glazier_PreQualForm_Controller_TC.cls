@isTest(SeeAllData=true)
public class View_Glazier_PreQualForm_Controller_TC {
     public static testMethod void test1() {
        Account accRec = new Account();
        accRec.Name = 'test';
        accRec.Billing_Address__c = 'rjy';
        accRec.BillingCity = 'City';
        accRec.BillingCountry = 'country';
        accRec.BillingPostalCode = '3333';
        insert accRec; 
        system.debug('accRec....'+accRec);
        
        contact con = new contact();
        con.AccountId = accRec.id;
        con.LastName = 'raj';
        con.Email = 'abc@gmail.com';
        insert con;
        system.debug('con....'+con);
        
        buildertek__Pre_Qual__c prequal = new buildertek__Pre_Qual__c();
        prequal.buildertek__Account__c = accRec.id;
        prequal.buildertek__Alternate_Name__c = 'TEST';
        prequal.buildertek__State__c = 'rjy';
        prequal.buildertek__Box_Folder_Id__c = '163036706177';
        prequal.buildertek__Qualification_Stage__c = 'Email Received';
        prequal.Contact_Email__c = 'abcd@gmail.com';
        prequal.Contractor_License_Number1__c = 'TEST1';
        prequal.Contractor_License_Number2__c = 'TEST2';
        prequal.Contractor_License_Number3__c = 'TEST3';
        prequal.Contractor_License_Provice_Territory2__c = 'AB';
        prequal.Contractor_License_Provice_Territory1__c = 'BC';
        prequal.Contractor_License_Provice_Territory3__c = 'MB';
        prequal.Contract_License_State_1__c = 'AL';
        prequal.Contract_License_State_2__c = 'AL';
        prequal.Contract_License_State_3__c = 'AL';
        prequal.If_yes_name_of_full_time_safety_represe__c = 'test';

        insert prequal;
        system.debug('prequal....'+prequal);
        
     
        
        buildertek__Past_Project__c proj = new buildertek__Past_Project__c();
        proj.buildertek__Contact_Name__c = 'test';
        proj.buildertek__Contact_Email__c = 'abc@gmail.com';
        proj.buildertek__Pre_Qual__c = prequal.id;
        insert proj; 
        update proj;
        system.debug('proj....'+proj);
    
        
        buildertek__References__c ref = new buildertek__References__c();
        ref.buildertek__Company_Name__c  = 'test1';
        ref.buildertek__Email__c = 'xyz@gmail.com';
        ref.buildertek__Pre_Qual__c = prequal.id;
        insert ref;
        update ref;
        system.debug('ref....'+ref);
        
        
        buildertek__Box_Settings__c box = new buildertek__Box_Settings__c();
        box.buildertek__Access_Token__c = 'x3nbZQcPwhBNWSsCtEir6YaC5CIiLGiM';
        box.buildertek__API_Key__c = '3WatdV5wN6sKmHWNJltkOCSLkUwfasO8';
        box.buildertek__Client_Secret__c = 'XA9Eskirfnlqy1cMCegM52docJdODIYV';
        box.buildertek__Client_Id__c = 'tbuhd7qwlvkob08sp3yjpphlgwnpd754';
        box.buildertek__Enterprise_ID__c = '841079817';
        box.buildertek__Refresh_Token__c =  null;
        box.Name = 'TEST API';
        insert box;
        system.debug('box....'+box);
        
       
     View_Glazier_PreQualForm_Controller.getFieldSet('LVE_Canada_General_Information', 'buildertek__Pre_Qual__c');
      View_Glazier_PreQualForm_Controller.RetrieveFieldsets();
         Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockClassResponceGenarator());
        Test.stopTest();
     View_Glazier_PreQualForm_Controller.savePreQualData('test', prequal.id,proj.id,proj.id,proj.id,ref.id,ref.id,ref.id );
           View_Glazier_PreQualForm_Controller.saveFile(prequal.Id,'Test','Sample Text','pdf',prequal.Id);
         View_Glazier_PreQualForm_Controller.saveTheFile(prequal.Id,'Test','Sample Text','pdf');
           View_Glazier_PreQualForm_Controller.checkEnableBox();

    }
      /*  public static testMethod void View_LVE_PreQualForm_Canada(){   
             Account accRec = [select id,name from Account limit 1];
        List<buildertek__Past_Project__c> proj = [select id,name from buildertek__Past_Project__c limit 1];
        List<buildertek__References__c> ref = [select id,name from buildertek__References__c limit 1];
            List <buildertek__Pre_Qual__c>prequal = [select id,name from buildertek__Pre_Qual__c limit 1];
        
      View_Glazier_PreQualForm_Controller.getFieldSet('LVE_Canada_General_Information', 'buildertek__Pre_Qual__c');
      View_Glazier_PreQualForm_Controller.getFieldSet('LVE_Canada_Company_Information', 'buildertek__Pre_Qual__c');
      View_Glazier_PreQualForm_Controller.getFieldSet('LVE_Canada_Key_Management', 'buildertek__Pre_Qual__c');
      View_Glazier_PreQualForm_Controller.getFieldSet('LVE_Canada_LVE_Team', 'buildertek__Pre_Qual__c');
      View_Glazier_PreQualForm_Controller.getFieldSet('LVE_Canada_Contract_Licence_Numbers', 'buildertek__Pre_Qual__c');

      View_Glazier_PreQualForm_Controller.RetrieveFieldsets();
               //View_LVE_PreQualForm_Canada_Controller.savePreQualData('{"Id":"'+accRec.id+'","Name":"Goutham.BTVIEW"}','{"Id":"'+prequal[0].id+'"}','{"Id":"'+proj[0].id+'"}','{"Id":"'+proj[0].id+'"}','{"Id":"'+proj[0].id+'"}','{"Id":"'+ref[0].id+'"}','{"Id":"'+ref[0].id+'"}','{"Id":"'+ref[0].id+'"}');
          
        }*/
        

}