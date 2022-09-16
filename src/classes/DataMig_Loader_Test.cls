@isTest
public class DataMig_Loader_Test {
    public static testmethod void DummyTestMethod()
    {
        SVMXC_Site_To_Building_Acc_Batch.SVMXC_Site_To_Building_Acc_Batch1();
        SVMXC_Servic_To_WorkOrder_Batch.SVMXC_Servic_To_WorkOrder_Batch1();
        SVMXC_Servic_To_WorkOrderLin_Batch.SVMXC_Servic_To_WorkOrderLin_Batch1();
        DataMig_Loader.DataMig_Loader1();
    }
    /* where ever * / is present remove the space between and the Srikanth
    public static testmethod void migrate_SVMXC_Site_To_Building_Acc_TestMeth()
    {
        Account lstacct = new Account();
        lstacct.name = 'test';
        lstacct.CurrencyIsoCode = 'USD';
        Insert lstacct;
        
        Date myDateTime1 = Date.newInstance(2019,9, 29);
        
        Opportunity opplst = new Opportunity();
        opplst.Name  = 'TestDKBOppty056';
        opplst.AccountId = lstacct.id;
        opplst.stagename  = 'Pre-Qualifying-Developing';
        opplst.Opportunity_Type__c  = 'Opportunity';
        opplst.Support_Region__c  = 'Chicago';
        opplst.CloseDate  = myDateTime1;
        opplst.Install_Type__c = 'Sales';
        opplst.Construction_Type__c = 'New Construction';
        opplst.Basis_of_Design__c = 'No';
        opplst.Service_Contract__c = 'Standard Warranty';
        opplst.Market_Segment__c = 'Aviation';
        opplst.Project_Address__c = '746 N 77TH AVE';
        opplst.Project_City__c = 'Omaha';
        opplst.Project_State__c = 'NE';
        opplst.Project_Country__c = 'United States';
        opplst.Project_Zip_Code__c = '68114';
        Insert opplst;
        
        Building__c blst = new Building__c();
        blst.name = 'TestBuild12';
        blst.DataMig_ExternalId__c = opplst.id;
        blst.CurrencyIsoCode = 'USD';
        Insert blst;
        
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'SVMXC__Site__c';
        sobjdef.APIName__c = 'SVMXC__Site__c';
        sobjdef.SFObjectTypeID__c = 'a2e';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'Building_Account__c';
        dobjdef.APIName__c = 'Building_Account__c';
        dobjdef.SFObjectTypeID__c = 'aBW';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        //--define source object's fields
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'SVMXC__Site__c.Account';
        sfielddef.APIName__c = 'SVMXC__Account__c';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'REFERENCE';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'SVMXC__Site__c.Country';
        sfielddef1.APIName__c = 'SVMXC__Country__c';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'PICKLIST';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        FieldDef__c sfielddef2 = new FieldDef__c();
        sfielddef2.name = 'SVMXC__Site__c.Location Name';
        sfielddef2.APIName__c = 'Name';
        sfielddef2.Migrate__c = true;
        sfielddef2.Object__c = sobjdef.id;
        sfielddef2.SFFieldTypeID__c = 'STRING';
        sfielddef2.CurrencyIsoCode =  'USD';
        Insert sfielddef2;
        
        FieldDef__c sfielddef3 = new FieldDef__c();
        sfielddef3.name = 'SVMXC__Site__c.Project Name';
        sfielddef3.APIName__c = 'Opportunity__c';
        sfielddef3.Migrate__c = true;
        sfielddef3.Object__c = sobjdef.id;
        sfielddef3.SFFieldTypeID__c = 'REFERENCE';
        sfielddef3.CurrencyIsoCode =  'USD';
        Insert sfielddef3;
        
        FieldDef__c sfielddef4 = new FieldDef__c();
        sfielddef4.name = 'SVMXC__Site__c.Record ID';
        sfielddef4.APIName__c = 'Id';
        sfielddef4.Migrate__c = true;
        sfielddef4.Object__c = sobjdef.id;
        sfielddef4.SFFieldTypeID__c = 'ID';
        sfielddef4.CurrencyIsoCode =  'USD';
        Insert sfielddef4;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'Building_Account__c.Account';
        dfielddef.APIName__c = 'Account__c';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'REFERENCE';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        FieldDef__c dfielddef1 = new FieldDef__c();        
        dfielddef1.name = 'Building_Account__c.Country';
        dfielddef1.APIName__c = 'Country__c';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'PICKLIST';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        FieldDef__c dfielddef2 = new FieldDef__c();
        dfielddef2.name = 'Building_Account__c.Building Account Name';
        dfielddef2.APIName__c = 'Name';
        dfielddef2.Migrate__c = true;
        dfielddef2.Object__c = dobjdef.id;
        dfielddef2.SFFieldTypeID__c = 'STRING';
        dfielddef2.CurrencyIsoCode =  'USD';
        Insert dfielddef2;
        
        FieldDef__c dfielddef3 = new FieldDef__c();
        dfielddef3.name = 'Building_Account__c.Project Name';
        dfielddef3.APIName__c = 'Opportunity__c';
        dfielddef3.Migrate__c = true;
        dfielddef3.Object__c = dobjdef.id;
        dfielddef3.SFFieldTypeID__c = 'REFERENCE';
        dfielddef3.CurrencyIsoCode =  'USD';
        Insert dfielddef3;
        
        FieldDef__c dfielddef4 = new FieldDef__c();
        dfielddef4.name = 'Building_Account__c.DataMig_ExternalId';
        dfielddef4.APIName__c = 'DataMig_ExternalId__c';
        dfielddef4.Migrate__c = true;
        dfielddef4.Object__c = dobjdef.id;
        dfielddef4.SFFieldTypeID__c = 'TEXT';
        dfielddef4.CurrencyIsoCode =  'USD';
        Insert dfielddef4;
        
        FieldDef__c dfielddef5 = new FieldDef__c();
        dfielddef5.name = 'Building_Account__c.Building';
        dfielddef5.APIName__c = 'Building__c';
        dfielddef5.Migrate__c = true;
        dfielddef5.Object__c = dobjdef.id;
        dfielddef5.SFFieldTypeID__c = 'REFERENCE';
        dfielddef5.CurrencyIsoCode =  'USD';
        Insert dfielddef5;
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'SVMXC__Site__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Site__c.Account Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef.id ,
                                         // DestinationFieldName__c = 'Account__c',
                                         WhereOperator__c = null, WhereValue__c = null
                                        ));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Site__c.Country Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef1.id,
                                         DestinationField__c = dfielddef1.id ,
                                         // DestinationFieldName__c = 'Country__c',            
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Site__c.Location Name Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef2.id,
                                         DestinationField__c = dfielddef2.id ,
                                         // DestinationFieldName__c = 'Name',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Site__c.Project Name Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef4.id,
                                         DestinationField__c = dfielddef4.id ,
                                         // DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Site__c.Project Name Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef3.id,
                                         DestinationField__c = dfielddef3.id ,
                                         //DestinationFieldName__c = 'Opportunity__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        Insert fieldmap;
        fieldmap[0].DestinationFieldName__c = 'Account__c';
        fieldmap[1].DestinationFieldName__c = 'Country__c';
        fieldmap[2].DestinationFieldName__c = 'Name';
        fieldmap[3].DestinationFieldName__c = 'DataMig_ExternalId__c';
        fieldmap[4].DestinationFieldName__c ='Opportunity__c';
        Update fieldmap;
        
        PicklistValueDef__c spicklstdef = new PicklistValueDef__c();
        spicklstdef.name = 'SVMXC__Site__c.Country_American Samoa';
        spicklstdef.FieldDef__c = sfielddef1.id;
        spicklstdef.PicklistValue__c = 'American Samoa';
        Insert spicklstdef;
        
        PicklistValueDef__c dpicklstdef = new PicklistValueDef__c();
        dpicklstdef.name = 'Building_Account__c.Country_American Samoa';
        dpicklstdef.FieldDef__c = dfielddef1.id;
        dpicklstdef.PicklistValue__c = 'American Samoa';
        Insert dpicklstdef;
        
        PicklistValueMapping__c picklstmap = new PicklistValueMapping__c();
        picklstmap.Name = 'SVMXC__Site__c.Country_American Samoa Map';
        //picklstmap.DestinationPickListName__c = 'American Samoa';
        picklstmap.DestinationPicklistValue__c = dpicklstdef.Id;
        picklstmap.SourcePicklistValue__c = spicklstdef.Id;
        Insert picklstmap;
        
        picklstmap.DestinationPickListName__c = 'American Samoa';
        Update picklstmap;
        
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        list<SVMXC__Site__c> lstsite = new list<SVMXC__Site__c>();
        lstsite.add(new SVMXC__Site__c(Name='test2C', SVMXC__Account__c = lstacct.id,
                                       SVMXC__Country__c = 'American Samoa', CurrencyIsoCode = 'USD',
                                       SVMXC__Street__c = 'test street1', SVMXC__Zip__c = '111111',
                                       Opportunity__c =  opplst.id));
        Insert lstsite;
        
        DataMig_Loader.generateCode();
        
        test.startTest();
        SVMXC_Site_To_Building_Acc_Batch job1 = new SVMXC_Site_To_Building_Acc_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c =jobId );
        Insert dataMigStepLogRec;
        test.stopTest();
    }
    
    Public Static TestMethod Void migrate_SVMXC_Servic_To_WorkOrder_Test()
    {
        Account lstacct = new Account();
        lstacct.name = 'TestSO';
        lstacct.CurrencyIsoCode = 'USD';
        Insert lstacct;
        
        case lstcase = new case();
        lstcase.Status = 'New';
        Insert lstcase;
        
        list<SVMXC__Site__c> lstsite = new list<SVMXC__Site__c>();
        lstsite.add(new SVMXC__Site__c(Name='test2C', SVMXC__Account__c = lstacct.id,
                                       SVMXC__Country__c = 'American Samoa', CurrencyIsoCode = 'USD',
                                       SVMXC__Street__c = 'test street1', SVMXC__Zip__c = '111111' ));
        Insert lstsite;
        
        list<SVMXC__Service_Order__c> ssobj = new list<SVMXC__Service_Order__c>();
        ssobj.add(new SVMXC__Service_Order__c(CurrencyIsoCode = 'USD',SVMXC__Company__c = lstacct.id,
                                              SVMXC__Case__c = lstcase.id, SVMXC__Site__c = lstsite[0].id));
        Insert ssobj;
        
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'SVMXC__Service_Order__c';
        sobjdef.APIName__c = 'SVMXC__Service_Order__c';
        sobjdef.SFObjectTypeID__c = 'a2W';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'WorkOrder';
        dobjdef.APIName__c = 'WorkOrder';
        dobjdef.SFObjectTypeID__c = '0Wo';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        //--define source object's fields
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'SVMXC__Service_Order__c.SVMXC__Company__c';
        sfielddef.APIName__c = 'SVMXC__Company__c';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'REFERENCE';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'SVMXC__Service_Order__c.CurrencyIsoCode';
        sfielddef1.APIName__c = 'CurrencyIsoCode';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'PICKLIST';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        FieldDef__c sfielddef2 = new FieldDef__c();
        sfielddef2.name = 'SVMXC__Service_Order__c.SVMXC__Case__c';
        sfielddef2.APIName__c = 'SVMXC__Case__c';
        sfielddef2.Migrate__c = true;
        sfielddef2.Object__c = sobjdef.id;
        sfielddef2.SFFieldTypeID__c = 'REFERENCE';
        sfielddef2.CurrencyIsoCode =  'USD';
        Insert sfielddef2;
        
        FieldDef__c sfielddef3 = new FieldDef__c();
        sfielddef3.name = 'SVMXC__Service_Order__c.Record ID';
        sfielddef3.APIName__c = 'Id';
        sfielddef3.Migrate__c = true;
        sfielddef3.Object__c = sobjdef.id;
        sfielddef3.SFFieldTypeID__c = 'ID';
        sfielddef3.CurrencyIsoCode =  'USD';
        Insert sfielddef3;
        
        FieldDef__c sfielddef4 = new FieldDef__c();
        sfielddef4.name = 'SVMXC__Service_Order__c.Record ID';
        sfielddef4.APIName__c = 'Id';
        sfielddef4.Migrate__c = true;
        sfielddef4.Object__c = sobjdef.id;
        sfielddef4.SFFieldTypeID__c = 'ID';
        sfielddef4.CurrencyIsoCode =  'USD';
        Insert sfielddef4;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'WorkOrder.AccountId';
        dfielddef.APIName__c = 'AccountId';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'REFERENCE';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        FieldDef__c dfielddef1 = new FieldDef__c();        
        dfielddef1.name = 'WorkOrder.CurrencyIsoCode';
        dfielddef1.APIName__c = 'CurrencyIsoCode';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'PICKLIST';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        FieldDef__c dfielddef2 = new FieldDef__c();
        dfielddef2.name = 'WorkOrder.CaseId';
        dfielddef2.APIName__c = 'CaseId';
        dfielddef2.Migrate__c = true;
        dfielddef2.Object__c = dobjdef.id;
        dfielddef2.SFFieldTypeID__c = 'REFERENCE';
        dfielddef2.CurrencyIsoCode =  'USD';
        Insert dfielddef2;
        
        FieldDef__c dfielddef4 = new FieldDef__c();
        dfielddef4.name = 'WorkOrder.DataMig_ExternalId';
        dfielddef4.APIName__c = 'DataMig_ExternalId__c';
        dfielddef4.Migrate__c = true;
        dfielddef4.Object__c = dobjdef.id;
        dfielddef4.SFFieldTypeID__c = 'TEXT';
        dfielddef4.CurrencyIsoCode =  'USD';
        Insert dfielddef4;
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'SVMXC__Service_Order__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.SVMXC__Case__c Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef2.id,
                                         DestinationField__c = dfielddef2.id ,
                                         DestinationFieldName__c = 'CaseId',
                                         WhereOperator__c = null, WhereValue__c = null
                                        ));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.CurrencyIsoCode Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef1.id,
                                         DestinationField__c = dfielddef1.id ,
                                         DestinationFieldName__c = 'CurrencyIsoCode',            
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.SVMXC__Company__c Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef.id ,
                                         DestinationFieldName__c = 'AccountId',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.Record Id Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef4.id,
                                         DestinationField__c = dfielddef4.id ,
                                         DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        
        Insert fieldmap;
        
        PicklistValueDef__c spicklstdef = new PicklistValueDef__c();
        spicklstdef.name = 'SVMXC__Service_Order__c.CurrencyIsoCode_USD';
        spicklstdef.FieldDef__c = sfielddef1.id;
        spicklstdef.PicklistValue__c = 'USD';
        Insert spicklstdef;
        
        PicklistValueDef__c dpicklstdef = new PicklistValueDef__c();
        dpicklstdef.name = 'WorkOrder.CurrencyIsoCode_USD';
        dpicklstdef.FieldDef__c = dfielddef1.id;
        dpicklstdef.PicklistValue__c = 'USD';
        Insert dpicklstdef;
        
        PicklistValueMapping__c picklstmap = new PicklistValueMapping__c();
        picklstmap.Name = 'SVMXC__Service_Order__c.CurrencyIsoCode_USD Map';
        picklstmap.DestinationPickListName__c = 'USD';
        picklstmap.DestinationPicklistValue__c = dpicklstdef.Id;
        picklstmap.SourcePicklistValue__c = spicklstdef.Id;
        Insert picklstmap;
        
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec1';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec1';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog1';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec1';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        test.startTest();
        SVMXC_Servic_To_WorkOrder_Batch job1 = new SVMXC_Servic_To_WorkOrder_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject1', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c = jobId );
        Insert dataMigStepLogRec;
        test.stopTest();  
    }
    
    Public Static TestMethod Void migrate_SVMXC_Servic_To_WOLin_Test()
    {
        Account lstacct = new Account();
        lstacct.name = 'TestSO1';
        lstacct.CurrencyIsoCode = 'USD';
        Insert lstacct;
        
        case lstcase = new case();
        lstcase.Status = 'New';
        Insert lstcase;
        
        list<SVMXC__Site__c> lstsite = new list<SVMXC__Site__c>();
        lstsite.add(new SVMXC__Site__c(Name='test3C', SVMXC__Account__c = lstacct.id,
                                       SVMXC__Country__c = 'American Samoa', CurrencyIsoCode = 'USD',
                                       SVMXC__Street__c = 'test street2', SVMXC__Zip__c = '111111' ));
        Insert lstsite;
        
        ObjectDef__c srcParentDef = new ObjectDef__c();
        srcParentDef.Name = 'SVMXC__Service_Order__c';
        srcParentDef.APIName__c = 'SVMXC__Service_Order__c';
        srcParentDef.SFObjectTypeID__c = 'a2W';
        srcParentDef.Migrate__c = true;
        Insert srcParentDef;
        
        ObjectDef__c destParentDef = new ObjectDef__c();
        destParentDef.Name = 'WorkOrder';
        destParentDef.APIName__c = 'WorkOrder';
        destParentDef.SFObjectTypeID__c = '0Wo';
        destParentDef.Migrate__c = false;
        Insert destParentDef;
        
        //--define source object's fields
        FieldDef__c srcParentfielddef = new FieldDef__c();
        srcParentfielddef.name = 'SVMXC__Service_Order__c.SVMXC__Company__c';
        srcParentfielddef.APIName__c = 'SVMXC__Company__c';
        srcParentfielddef.Migrate__c = true;
        srcParentfielddef.Object__c = srcParentDef.id;
        srcParentfielddef.SFFieldTypeID__c = 'REFERENCE';
        srcParentfielddef.CurrencyIsoCode =  'USD';
        Insert srcParentfielddef;
        
        FieldDef__c srcParentfielddef1 = new FieldDef__c();
        srcParentfielddef1.name = 'SVMXC__Service_Order__c.CurrencyIsoCode';
        srcParentfielddef1.APIName__c = 'CurrencyIsoCode';
        srcParentfielddef1.Migrate__c = true;
        srcParentfielddef1.Object__c = srcParentDef.id;
        srcParentfielddef1.SFFieldTypeID__c = 'PICKLIST';
        srcParentfielddef1.CurrencyIsoCode =  'USD';
        Insert srcParentfielddef1;
        
        FieldDef__c srcParentfielddef2 = new FieldDef__c();
        srcParentfielddef2.name = 'SVMXC__Service_Order__c.SVMXC__Case__c';
        srcParentfielddef2.APIName__c = 'SVMXC__Case__c';
        srcParentfielddef2.Migrate__c = true;
        srcParentfielddef2.Object__c = srcParentDef.id;
        srcParentfielddef2.SFFieldTypeID__c = 'REFERENCE';
        srcParentfielddef2.CurrencyIsoCode =  'USD';
        Insert srcParentfielddef2;
        
        FieldDef__c srcParentfielddef3 = new FieldDef__c();
        srcParentfielddef3.name = 'SVMXC__Service_Order__c.Record ID';
        srcParentfielddef3.APIName__c = 'Id';
        srcParentfielddef3.Migrate__c = true;
        srcParentfielddef3.Object__c = srcParentDef.id;
        srcParentfielddef3.SFFieldTypeID__c = 'ID';
        srcParentfielddef3.CurrencyIsoCode =  'USD';
        Insert srcParentfielddef3;
        
        FieldDef__c srcParentfielddef4 = new FieldDef__c();
        srcParentfielddef4.name = 'SVMXC__Service_Order__c.Record ID';
        srcParentfielddef4.APIName__c = 'Id';
        srcParentfielddef4.Migrate__c = true;
        srcParentfielddef4.Object__c = srcParentDef.id;
        srcParentfielddef4.SFFieldTypeID__c = 'ID';
        srcParentfielddef4.CurrencyIsoCode =  'USD';
        Insert srcParentfielddef4;
        
        //--define destination object's fields
        FieldDef__c destParentFiledDef = new FieldDef__c();
        destParentFiledDef.name = 'WorkOrder.AccountId';
        destParentFiledDef.APIName__c = 'AccountId';
        destParentFiledDef.Migrate__c = true;
        destParentFiledDef.Object__c = destParentDef.id;
        destParentFiledDef.SFFieldTypeID__c = 'REFERENCE';
        destParentFiledDef.CurrencyIsoCode =  'USD';
        Insert destParentFiledDef;
        
        FieldDef__c destParentFiledDef1 = new FieldDef__c();        
        destParentFiledDef1.name = 'WorkOrder.CurrencyIsoCode';
        destParentFiledDef1.APIName__c = 'CurrencyIsoCode';
        destParentFiledDef1.Migrate__c = true;
        destParentFiledDef1.Object__c = destParentDef.id;
        destParentFiledDef1.SFFieldTypeID__c = 'PICKLIST';
        destParentFiledDef1.CurrencyIsoCode =  'USD';
        Insert destParentFiledDef1;
        
        FieldDef__c destParentFiledDef2 = new FieldDef__c();
        destParentFiledDef2.name = 'WorkOrder.CaseId';
        destParentFiledDef2.APIName__c = 'CaseId';
        destParentFiledDef2.Migrate__c = true;
        destParentFiledDef2.Object__c = destParentDef.id;
        destParentFiledDef2.SFFieldTypeID__c = 'REFERENCE';
        destParentFiledDef2.CurrencyIsoCode =  'USD';
        Insert destParentFiledDef2;
        
        FieldDef__c destParentFiledDef3 = new FieldDef__c();
        destParentFiledDef3.name = 'WorkOrder.DataMig_ExternalId';
        destParentFiledDef3.APIName__c = 'DataMig_ExternalId__c';
        destParentFiledDef3.Migrate__c = true;
        destParentFiledDef3.Object__c = destParentDef.id;
        destParentFiledDef3.SFFieldTypeID__c = 'TEXT';
        destParentFiledDef3.CurrencyIsoCode =  'USD';
        Insert destParentFiledDef3;
        
        //--Source and destination Object Mapping
        ObjectMapping__c srcParentObjMap = new ObjectMapping__c();
        srcParentObjMap.name = 'SVMXC__Service_Order__c Map';
        srcParentObjMap.SourceObject__c = srcParentDef.id;
        srcParentObjMap.DestinationObject__c = destParentDef.id;
        Insert srcParentObjMap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> srcToDesFieldmap = new list<FieldMapping__c>();
        srcToDesFieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.SVMXC__Case__c Map', ObjectMapping__c = srcParentObjMap.id,
                                                 SourceField__c = srcParentfielddef2.id,
                                                 DestinationField__c = destParentFiledDef2.id ,
                                                 DestinationFieldName__c = 'CaseId',
                                                 WhereOperator__c = null, WhereValue__c = null
                                                ));
        srcToDesFieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.CurrencyIsoCode Map', ObjectMapping__c = srcParentObjMap.id,
                                                 SourceField__c = srcParentfielddef1.id,
                                                 DestinationField__c = destParentFiledDef1.id ,
                                                 DestinationFieldName__c = 'CurrencyIsoCode',            
                                                 WhereOperator__c = null, WhereValue__c = null));
        srcToDesFieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.SVMXC__Company__c Map', ObjectMapping__c = srcParentObjMap.id,
                                                 SourceField__c = srcParentfielddef.id,
                                                 DestinationField__c = destParentFiledDef.id ,
                                                 DestinationFieldName__c = 'AccountId',
                                                 WhereOperator__c = null, WhereValue__c = null));
        srcToDesFieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.Record Id Map', ObjectMapping__c = srcParentObjMap.id,
                                                 SourceField__c = srcParentfielddef4.id,
                                                 DestinationField__c = destParentFiledDef3.id ,
                                                 DestinationFieldName__c = 'DataMig_ExternalId__c',
                                                 WhereOperator__c = null, WhereValue__c = null));
        
        Insert srcToDesFieldmap;
        
        
        
        list<SVMXC__Service_Order__c> srcParentObj = new list<SVMXC__Service_Order__c>();
        srcParentObj.add(new SVMXC__Service_Order__c(CurrencyIsoCode = 'USD',SVMXC__Company__c = lstacct.id,
                                                     SVMXC__Case__c = lstcase.id, SVMXC__Site__c = lstsite[0].id));
        Insert srcParentObj;
        
        list<WorkOrder> destParentObj = new list<WorkOrder>();
        destParentObj.add(new WorkOrder(CurrencyIsoCode = 'USD', CaseId = lstcase.Id,
                                        AccountId = lstacct.Id));
        Insert destParentObj;
        
        DataMigProcStepDef__c parentProStepDef = new DataMigProcStepDef__c();
        parentProStepDef.name = 'DataMigProcStepDef rec1';
        parentProStepDef.ObjectMapping__c = srcParentObjMap.id;
        parentProStepDef.SOQLLimitBufferPct__c = 20.00;
        parentProStepDef.StepSequence__c = 1;
        parentProStepDef.HeapSizeLimitBufferPct__c = 20.00;
        Insert parentProStepDef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime parentmyDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime parentmyDT = Datetime.now();
        DataMigProcLog__c srcDataMigProLogs = new DataMigProcLog__c();
        srcDataMigProLogs.name = 'DataMigProcLog rec1';
        srcDataMigProLogs.StartDateTime__c = parentmyDT;
        srcDataMigProLogs.EndDateTime__c = parentmyDateTime;
        srcDataMigProLogs.StatusDetail__c = 'Test DataMigProCLog1';
        Insert srcDataMigProLogs;
        
        DataMigStepLog__c srcDataMigStepLog = new DataMigStepLog__c();
        srcDataMigStepLog.Name = 'DataMigStepLog rec1';
        srcDataMigStepLog.DataMigProc__c = srcDataMigProLogs.id;
        srcDataMigStepLog.DataMigProcStepDef__c = parentProStepDef.id;
        Insert srcDataMigStepLog;
        
        DataMigStepRecLog__c parentDataMigStepRecLog = new DataMigStepRecLog__c();
        parentDataMigStepRecLog.DataMigStep__c = srcDataMigStepLog.Id;
        parentDataMigStepRecLog.DestinationObject__c = destParentDef.Id;
        parentDataMigStepRecLog.DestinationRecordID__c = String.ValueOf(destParentObj[0].Id);
        parentDataMigStepRecLog.SourceObject__c = srcParentDef.Id ;
        parentDataMigStepRecLog.SourceRecordID__c = String.valueOf(srcParentObj[0].Id) ;
        parentDataMigStepRecLog.ErrorMessage__c = 'Success';
        Insert parentDataMigStepRecLog;
        
        list<SVMXC__Service_Order_Line__c> ssolobj = new list<SVMXC__Service_Order_Line__c>();
        ssolobj.add( new SVMXC__Service_Order_Line__c(//CurrencyIsoCode = 'USD',
            SVMXC__Service_Order__c = srcParentObj[0].id));
        Insert ssolobj;
        
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'SVMXC__Service_Order_Line__c';
        sobjdef.APIName__c = 'SVMXC__Service_Order_Line__c';
        sobjdef.SFObjectTypeID__c = 'a2V';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'WorkOrderLineItem';
        dobjdef.APIName__c = 'WorkOrderLineItem';
        dobjdef.SFObjectTypeID__c = '1WL';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        //--define source object's fields
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'SVMXC__Service_Order_Line__c.Work Order';
        sfielddef.APIName__c = 'SVMXC__Service_Order__c';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'REFERENCE';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'SVMXC__Service_Order_Line__c.Record ID';
        sfielddef1.APIName__c = 'Id';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'ID';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'WorkOrderLineItem.Work Order ID';
        dfielddef.APIName__c = 'WorkOrderId';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'REFERENCE';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        
        
        FieldDef__c dfielddef1 = new FieldDef__c();
        dfielddef1.name = 'WorkOrderLineItem.DataMig_ExternalId';
        dfielddef1.APIName__c = 'DataMig_ExternalId__c';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'TEXT';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'SVMXC__Service_Order_Line__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order_Line__c.Work Order Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef.id ,
                                         DestinationFieldName__c = 'WorkOrderId',
                                         WhereOperator__c = null, WhereValue__c = null));     
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order_Line__c.Record ID Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef1.id,
                                         DestinationField__c = dfielddef1.id ,
                                         DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        Insert fieldmap;    
        
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec2';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec2';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog2';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec2';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        test.startTest();
        SVMXC_Servic_To_WorkOrderLin_Batch job1 = new SVMXC_Servic_To_WorkOrderLin_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject2', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c = jobId );
        Insert dataMigStepLogRec;
        test.stopTest();
    }
    /*
    Public Static TestMethod Void migrate_SVMXC_Servic_To_Case_Test()
    {
        Account lstacct = new Account();
        lstacct.name = 'TestSO1';
        lstacct.CurrencyIsoCode = 'USD';
        Insert lstacct;
        
        case lstcase = new case();
        lstcase.Status = 'New';
        Insert lstcase;
        
        list<SVMXC__Site__c> lstsite = new list<SVMXC__Site__c>();
        lstsite.add(new SVMXC__Site__c(Name='test3C', SVMXC__Account__c = lstacct.id,
                                       SVMXC__Country__c = 'American Samoa', CurrencyIsoCode = 'USD',
                                       SVMXC__Street__c = 'test street2', SVMXC__Zip__c = '111111' ));
        Insert lstsite;
        
        list<SVMXC__Service_Order__c> ssobj = new list<SVMXC__Service_Order__c>();
        ssobj.add(new SVMXC__Service_Order__c(CurrencyIsoCode = 'USD',SVMXC__Company__c = lstacct.id,
                                              SVMXC__Case__c = lstcase.id, SVMXC__Site__c = lstsite[0].id));
        Insert ssobj;
        
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'SVMXC__Service_Order__c';
        sobjdef.APIName__c = 'SVMXC__Service_Order__c';
        sobjdef.SFObjectTypeID__c = 'a2W';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'Case';
        dobjdef.APIName__c = 'Case';
        dobjdef.SFObjectTypeID__c = '500';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'SVMXC__Service_Order__c.SVMXC__Company__c';
        sfielddef.APIName__c = 'SVMXC__Company__c';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'REFERENCE';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef4 = new FieldDef__c();
        sfielddef4.name = 'SVMXC__Service_Order__c.Order Status';
        sfielddef4.APIName__c = 'SVMXC__Order_Status__c';
        sfielddef4.Migrate__c = true;
        sfielddef4.Object__c = sobjdef.id;
        sfielddef4.SFFieldTypeID__c = 'PICKLIST';
        sfielddef4.CurrencyIsoCode =  'USD';
        Insert sfielddef4;
        
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'SVMXC__Service_Order__c.CurrencyIsoCode';
        sfielddef1.APIName__c = 'CurrencyIsoCode';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'PICKLIST';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        FieldDef__c sfielddef3 = new FieldDef__c();
        sfielddef3.name = 'SVMXC__Service_Order__c.Record ID';
        sfielddef3.APIName__c = 'Id';
        sfielddef3.Migrate__c = true;
        sfielddef3.Object__c = sobjdef.id;
        sfielddef3.SFFieldTypeID__c = 'Id';
        sfielddef3.CurrencyIsoCode =  'USD';
        Insert sfielddef3;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'Case.Account ID';
        dfielddef.APIName__c = 'AccountId';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'REFERENCE';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        FieldDef__c dfielddef1 = new FieldDef__c();        
        dfielddef1.name = 'Case.Case Currency';
        dfielddef1.APIName__c = 'CurrencyIsoCode';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'PICKLIST';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        FieldDef__c dfielddef2 = new FieldDef__c();
        dfielddef2.name = 'Case.Status';
        dfielddef2.APIName__c = 'Status';
        dfielddef2.Migrate__c = true;
        dfielddef2.Object__c = dobjdef.id;
        dfielddef2.SFFieldTypeID__c = 'PICKLIST';
        dfielddef2.CurrencyIsoCode =  'USD';
        Insert dfielddef2;
        
        FieldDef__c dfielddef3 = new FieldDef__c();
        dfielddef3.name = 'Case.DataMig ExternalId';
        dfielddef3.APIName__c = 'DataMig_ExternalId__c';
        dfielddef3.Migrate__c = true;
        dfielddef3.Object__c = dobjdef.id;
        dfielddef3.SFFieldTypeID__c = 'TEXT';
        dfielddef3.CurrencyIsoCode =  'USD';
        Insert dfielddef3;
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'SVMXC__Service_Order__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.CurrencyIsoCode Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef1.id,
                                         DestinationField__c = dfielddef1.id ,
                                         DestinationFieldName__c = 'CurrencyIsoCode',            
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.SVMXC__Company__c Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef.id ,
                                         DestinationFieldName__c = 'AccountId',
                                         WhereOperator__c = null, WhereValue__c = null));  
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order__c.SVMXC__Company__c Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef4.id,
                                         DestinationField__c = dfielddef2.id ,
                                         DestinationFieldName__c = 'Status',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'SVMXC__Service_Order_Line__c.Record ID Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef3.id,
                                         DestinationField__c = dfielddef3.id ,
                                         DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        Insert fieldmap;
        
        PicklistValueDef__c spicklstdef = new PicklistValueDef__c();
        spicklstdef.name = 'SVMXC__Service_Order__c.CurrencyIsoCode_USD';
        spicklstdef.FieldDef__c = sfielddef1.id;
        spicklstdef.PicklistValue__c = 'USD';
        Insert spicklstdef;
        
        PicklistValueDef__c dpicklstdef = new PicklistValueDef__c();
        dpicklstdef.name = 'Case.CurrencyIsoCode_USD';
        dpicklstdef.FieldDef__c = dfielddef1.id;
        dpicklstdef.PicklistValue__c = 'USD';
        Insert dpicklstdef;
        
        PicklistValueMapping__c picklstmap = new PicklistValueMapping__c();
        picklstmap.Name = 'SVMXC__Service_Order__c.CurrencyIsoCode_USD Map';
        picklstmap.DestinationPickListName__c = 'USD';
        picklstmap.DestinationPicklistValue__c = dpicklstdef.Id;
        picklstmap.SourcePicklistValue__c = spicklstdef.Id;
        Insert picklstmap;
        
        PicklistValueDef__c srcStatusPL = new PicklistValueDef__c();
        srcStatusPL.name = 'SVMXC__Service_Order__c.Order Status';
        srcStatusPL.FieldDef__c = sfielddef4.id;
        srcStatusPL.PicklistValue__c = 'Open';
        Insert srcStatusPL;
        
        PicklistValueDef__c destStatusPL = new PicklistValueDef__c();
        destStatusPL.name = 'Case.Status';
        destStatusPL.FieldDef__c = dfielddef2.id;
        destStatusPL.PicklistValue__c = 'New';
        Insert destStatusPL;
        
        PicklistValueMapping__c statusPLMap = new PicklistValueMapping__c();
        statusPLMap.Name = 'SVMXC__Service_Order__c.Order Status Map';
        statusPLMap.DestinationPickListName__c = 'New';
        statusPLMap.DestinationPicklistValue__c = destStatusPL.Id;
        statusPLMap.SourcePicklistValue__c = srcStatusPL.Id;
        Insert statusPLMap;
        
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec2';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec2';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog2';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec2';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        test.startTest();
        SVMXC_Servic_To_Case_Batch job1 = new SVMXC_Servic_To_Case_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject2', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c = jobId );
        Insert dataMigStepLogRec;
        test.stopTest();
        
    }
    * /
    public static TestMethod void migrate_Customer_Inc_To_Case_Test()
    {
        Account lstacct = new Account();
        lstacct.name = 'test05';
        lstacct.CurrencyIsoCode = 'USD';
        Insert lstacct;
        
        Date myDateTime1 = Date.newInstance(2019,9, 29);
        
        Opportunity opplst = new Opportunity();
        opplst.Name  = 'TestDKBOppty056';
        opplst.AccountId = lstacct.id;
        opplst.stagename  = 'Pre-Qualifying-Developing';
        opplst.Opportunity_Type__c  = 'Opportunity';
        opplst.Support_Region__c  = 'Chicago';
        opplst.CloseDate  = myDateTime1;
        opplst.Install_Type__c = 'Sales';
        opplst.Construction_Type__c = 'New Construction';
        opplst.Basis_of_Design__c = 'No';
        opplst.Service_Contract__c = 'Standard Warranty';
        opplst.Market_Segment__c = 'Aviation';
        opplst.Project_Address__c = '746 N 77TH AVE';
        opplst.Project_City__c = 'Omaha';
        opplst.Project_State__c = 'NE';
        opplst.Project_Country__c = 'United States';
        opplst.Project_Zip_Code__c = '68114';
        Insert opplst;
        
        list<Customer_Incident__c> Custlst = new list<Customer_Incident__c>();
        Custlst.add(new Customer_Incident__c (Customer_Account__c = lstacct.id, Opportunity__c = opplst.id,
                                              Replacement_Needed__c = 'No', CurrencyIsoCode = 'USD',
                                              Customer_Contact_Name__c = 'Test DataMig',
                                              Customer_E_Mail_Signatory__c = 'xyz@view.com',
                                              Shipping_Address__c = '746 N 77TH AVE,Omaha,NE,United States,68114',
                                              Shipping_Container__c = 'Wood Crate'));
        Insert Custlst;
        
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'Customer_Incident__c';
        sobjdef.APIName__c = 'Customer_Incident__c';
        sobjdef.SFObjectTypeID__c = 'a6w';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'Case';
        dobjdef.APIName__c = 'Case';
        dobjdef.SFObjectTypeID__c = '500';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        //--define source object's fields
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'Customer_Incident__c.Customer Account';
        sfielddef.APIName__c = 'Customer_Account__c';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'REFERENCE';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'Customer_Incident__c.Replacement Needed';
        sfielddef1.APIName__c = 'Replacement_Needed__c';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'PICKLIST';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        FieldDef__c sfielddef2 = new FieldDef__c();
        sfielddef2.name = 'Customer_Incident__c.CurrencyIsoCode';
        sfielddef2.APIName__c = 'CurrencyIsoCode';
        sfielddef2.Migrate__c = true;
        sfielddef2.Object__c = sobjdef.id;
        sfielddef2.SFFieldTypeID__c = 'PICKLIST';
        sfielddef2.CurrencyIsoCode =  'USD';
        Insert sfielddef2;
        
        FieldDef__c sfielddef3 = new FieldDef__c();
        sfielddef3.name = 'Customer_Incident__c.Customer Contact Name';
        sfielddef3.APIName__c = 'Customer_Contact_Name__c';
        sfielddef3.Migrate__c = true;
        sfielddef3.Object__c = sobjdef.id;
        sfielddef3.SFFieldTypeID__c = 'STRING';
        sfielddef3.CurrencyIsoCode =  'USD';
        Insert sfielddef3;
        
        FieldDef__c sfielddef4 = new FieldDef__c();
        sfielddef4.name = 'Customer_Incident__c.Customer E Mail Signatory';
        sfielddef4.APIName__c = 'Customer_E_Mail_Signatory__c';
        sfielddef4.Migrate__c = true;
        sfielddef4.Object__c = sobjdef.id;
        sfielddef4.SFFieldTypeID__c = 'EMAIL';
        sfielddef4.CurrencyIsoCode =  'USD';
        Insert sfielddef4;
        
        FieldDef__c sfielddef5 = new FieldDef__c();
        sfielddef5.name = 'Customer_Incident__c.Shipping Address';
        sfielddef5.APIName__c = 'Shipping_Address__c';
        sfielddef5.Migrate__c = true;
        sfielddef5.Object__c = sobjdef.id;
        sfielddef5.SFFieldTypeID__c = 'TEXTAREA';
        sfielddef5.CurrencyIsoCode =  'USD';
        Insert sfielddef5;
        
        FieldDef__c sfielddef6 = new FieldDef__c();
        sfielddef6.name = 'Customer_Incident__c.Shipping Container';
        sfielddef6.APIName__c = 'Shipping_Container__c';
        sfielddef6.Migrate__c = true;
        sfielddef6.Object__c = sobjdef.id;
        sfielddef6.SFFieldTypeID__c = 'PICKLIST';
        sfielddef6.CurrencyIsoCode =  'USD';
        Insert sfielddef6;
        
        FieldDef__c sfielddef7 = new FieldDef__c();
        sfielddef7.name = 'Customer_Incident__c.Opportunity';
        sfielddef7.APIName__c = 'Opportunity__c';
        sfielddef7.Migrate__c = true;
        sfielddef7.Object__c = sobjdef.id;
        sfielddef7.SFFieldTypeID__c = 'REFERENCE';
        sfielddef7.CurrencyIsoCode =  'USD';
        Insert sfielddef7;
        
        FieldDef__c sfielddef8 = new FieldDef__c();
        sfielddef8.name = 'Customer_Incident__c.Status';
        sfielddef8.APIName__c = 'Status__c';
        sfielddef8.Migrate__c = true;
        sfielddef8.Object__c = sobjdef.id;
        sfielddef8.SFFieldTypeID__c = 'PICKLIST';
        sfielddef8.CurrencyIsoCode =  'USD';
        Insert sfielddef8;
        
        FieldDef__c sfielddef9 = new FieldDef__c();
        sfielddef9.name = 'Customer_Incident__c.Record ID';
        sfielddef9.APIName__c = 'Id';
        sfielddef9.Migrate__c = true;
        sfielddef9.Object__c = sobjdef.id;
        sfielddef9.SFFieldTypeID__c = 'ID';
        sfielddef9.CurrencyIsoCode = 'USD';
        Insert sfielddef9;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'Case.Account ID';
        dfielddef.APIName__c = 'AccountId';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'REFERENCE';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        FieldDef__c dfielddef1 = new FieldDef__c();        
        dfielddef1.name = 'Case.Case Currency';
        dfielddef1.APIName__c = 'CurrencyIsoCode';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'PICKLIST';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        FieldDef__c dfielddef2 = new FieldDef__c();
        dfielddef2.name = 'Case.Status';
        dfielddef2.APIName__c = 'Status';
        dfielddef2.Migrate__c = true;
        dfielddef2.Object__c = dobjdef.id;
        dfielddef2.SFFieldTypeID__c = 'PICKLIST';
        dfielddef2.CurrencyIsoCode =  'USD';
        Insert dfielddef2;
        
        FieldDef__c dfielddef3 = new FieldDef__c();
        dfielddef3.name = 'Case.Opportunity';
        dfielddef3.APIName__c = 'Opportunity__c';
        dfielddef3.Migrate__c = true;
        dfielddef3.Object__c = dobjdef.id;
        dfielddef3.SFFieldTypeID__c = 'REFERENCE';
        dfielddef3.CurrencyIsoCode =  'USD';
        Insert dfielddef3;
        
        FieldDef__c dfielddef4 = new FieldDef__c();
        dfielddef4.name = 'Case.DataMig ExternalId';
        dfielddef4.APIName__c = 'DataMig_ExternalId__c';
        dfielddef4.Migrate__c = true;
        dfielddef4.Object__c = dobjdef.id;
        dfielddef4.SFFieldTypeID__c = 'TEXT';
        dfielddef4.CurrencyIsoCode =  'USD';
        Insert dfielddef4;
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'Customer_Incident__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'Customer_Incident__c.Account Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef.id ,
                                         DestinationFieldName__c = 'AccountId',
                                         WhereOperator__c = null, WhereValue__c = null
                                        ));
        fieldmap.add(new FieldMapping__c(name = 'Customer_Incident__c.Opportunity Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef7.id,
                                         DestinationField__c = dfielddef3.id ,
                                         DestinationFieldName__c = 'Opportunity__c',            
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Customer_Incident__c.Currency ISO Code Map',
                                         ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef2.id,
                                         DestinationField__c = dfielddef1.id ,
                                         DestinationFieldName__c = 'CurrencyIsoCode',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Customer_Incident__c.Status Map',
                                         ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef8.id,
                                         DestinationField__c = dfielddef2.id ,
                                         DestinationFieldName__c = 'Status',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Customer_Incident__c.Record ID Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef9.id,
                                         DestinationField__c = dfielddef4.id ,
                                         DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        Insert fieldmap;
        // fieldmap[0].DestinationFieldName__c = 'AccountId';
        
        
        PicklistValueDef__c spicklstdef = new PicklistValueDef__c();
        spicklstdef.name = 'Customer_Incident__c.CurrencyIsoCode_USD';
        spicklstdef.FieldDef__c = sfielddef2.id;
        spicklstdef.PicklistValue__c = 'USD';
        Insert spicklstdef;
        
        PicklistValueDef__c dpicklstdef = new PicklistValueDef__c();
        dpicklstdef.name = 'Case.CurrencyIsoCode_USD';
        dpicklstdef.FieldDef__c = dfielddef1.id;
        dpicklstdef.PicklistValue__c = 'USD';
        Insert dpicklstdef;
        
        PicklistValueMapping__c picklstmap = new PicklistValueMapping__c();
        picklstmap.Name = 'Customer_Incident__c.CurrencyIsoCode_USD Map';
        picklstmap.DestinationPickListName__c = 'USD';
        picklstmap.DestinationPicklistValue__c = dpicklstdef.Id;
        picklstmap.SourcePicklistValue__c = spicklstdef.Id;
        Insert picklstmap;   
        
        PicklistValueDef__c spicklstdef1 = new PicklistValueDef__c();
        spicklstdef1.name = 'Customer_Incident__c.Status';
        spicklstdef1.FieldDef__c = sfielddef8.id;
        spicklstdef1.PicklistValue__c = 'Draft';
        Insert spicklstdef1;
        
        PicklistValueDef__c dpicklstdef1 = new PicklistValueDef__c();
        dpicklstdef1.name = 'Case.Status';
        dpicklstdef1.FieldDef__c = dfielddef2.id;
        dpicklstdef1.PicklistValue__c = 'New';
        Insert dpicklstdef1;
        
        PicklistValueMapping__c picklstmap1 = new PicklistValueMapping__c();
        picklstmap1.Name = 'Customer_Incident__c.Staus Map';
        picklstmap1.DestinationPickListName__c = 'New';
        picklstmap1.DestinationPicklistValue__c = dpicklstdef1.Id;
        picklstmap1.SourcePicklistValue__c = spicklstdef1.Id;
        Insert picklstmap1;  
        
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec2';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec2';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog2';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec2';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        test.startTest();
        Customer_Inc_To_Case_Batch job1 = new Customer_Inc_To_Case_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject2', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c = jobId );
        Insert dataMigStepLogRec;
        test.stopTest();
        
    }
  	/*	
    public static TestMethod void migrate_Halo_Profile_To_Issue_Test()
    {
        Account lstacct = new Account();
        lstacct.name = 'test';
        lstacct.CurrencyIsoCode = 'USD';
        Insert lstacct;
        
        Date myDateTime1 = Date.newInstance(2019,9, 29);
        
        Opportunity opplst = new Opportunity();
        opplst.Name  = 'TestDKBOppty056';
        opplst.AccountId = lstacct.id;
        opplst.stagename  = 'Pre-Qualifying-Developing';
        opplst.Opportunity_Type__c  = 'Opportunity';
        opplst.Support_Region__c  = 'Chicago';
        opplst.CloseDate  = myDateTime1;
        opplst.Install_Type__c = 'Sales';
        opplst.Construction_Type__c = 'New Construction';
        opplst.Basis_of_Design__c = 'No';
        opplst.Service_Contract__c = 'Standard Warranty';
        opplst.Market_Segment__c = 'Aviation';
        opplst.Project_Address__c = '746 N 77TH AVE';
        opplst.Project_City__c = 'Omaha';
        opplst.Project_State__c = 'NE';
        opplst.Project_Country__c = 'United States';
        opplst.Project_Zip_Code__c = '68114';
        Insert opplst;
        
        SVMXC__Site__c lstsite = new SVMXC__Site__c();
        lstsite.Name ='test2C';
        lstsite.SVMXC__Account__c = lstacct.id;
        lstsite.SVMXC__Country__c = 'American Samoa';
        lstsite.CurrencyIsoCode = 'USD';  
        lstsite.SVMXC__Street__c = 'test street1';
        lstsite.SVMXC__Zip__c = '111111';
        lstsite.Opportunity__c =  opplst.id;
        Insert lstsite;
        
        case lstcase = new case();
        lstcase.Status = 'New';
        Insert lstcase;
        
        SVMXC__Service_Order__c ssobj = new SVMXC__Service_Order__c();
        ssobj.CurrencyIsoCode = 'USD';
        ssobj.SVMXC__Company__c = lstacct.id;
        ssobj.SVMXC__Case__c = lstcase.id;
        ssobj.SVMXC__Site__c = lstsite.id;
        Insert ssobj;        
        
        list<Halo_Profile__c> hplst = new list<Halo_Profile__c>();
        Date myDateTime2 = Date.newInstance(2019,9, 19);
        hplst.add( new Halo_Profile__c(Date_Identified__c = myDateTime2,
                                       Location__c = lstsite.id,
                                       Source_WO__c = ssobj.id
                                      ));
        Insert hplst;
        
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'Halo_Profile__c';
        sobjdef.APIName__c = 'Halo_Profile__c';
        sobjdef.SFObjectTypeID__c = 'a62';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'Issue__c';
        dobjdef.APIName__c = 'Issue__c';
        dobjdef.SFObjectTypeID__c = 'aAy';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        //--define source object's fields
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'Halo_Profile__c.Date Identified';
        sfielddef.APIName__c = 'Date_Identified__c';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'DATE';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'Halo_Profile__c.Currency ISO Code';
        sfielddef1.APIName__c = 'CurrencyIsoCode';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'PICKLIST';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        FieldDef__c sfielddef2 = new FieldDef__c();
        sfielddef2.name = 'Halo_Profile__c.Location';
        sfielddef2.APIName__c = 'Location__c';
        sfielddef2.Migrate__c = true;
        sfielddef2.Object__c = sobjdef.id;
        sfielddef2.SFFieldTypeID__c = 'REFERENCE';
        sfielddef2.CurrencyIsoCode =  'USD';
        Insert sfielddef2;
        
        FieldDef__c sfielddef3 = new FieldDef__c();
        sfielddef3.name = 'Halo_Profile__c.Source WO';
        sfielddef3.APIName__c = 'Source_WO__c';
        sfielddef3.Migrate__c = true;
        sfielddef3.Object__c = sobjdef.id;
        sfielddef3.SFFieldTypeID__c = 'REFERENCE';
        sfielddef3.CurrencyIsoCode =  'USD';
        Insert sfielddef3;
        
        FieldDef__c sfielddef4 = new FieldDef__c();
        sfielddef4.name = 'Halo_Profile__c.Record ID';
        sfielddef4.APIName__c = 'Id';
        sfielddef4.Migrate__c = true;
        sfielddef4.Object__c = sobjdef.id;
        sfielddef4.SFFieldTypeID__c = 'ID';
        sfielddef4.CurrencyIsoCode =  'USD';
        Insert sfielddef4;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'Issue__c.Date Identified';
        dfielddef.APIName__c = 'Date_Identified__c';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'DATE';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        FieldDef__c dfielddef1 = new FieldDef__c();
        dfielddef1.name = 'Issue__c.Currency ISO Code';
        dfielddef1.APIName__c = 'CurrencyIsoCode';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'PICKLIST';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        FieldDef__c dfielddef2 = new FieldDef__c();
        dfielddef2.name = 'Issue__c.Source Work Order';
        dfielddef2.APIName__c = 'Source_Work_Order__c';
        dfielddef2.Migrate__c = true;
        dfielddef2.Object__c = dobjdef.id;
        dfielddef2.SFFieldTypeID__c = 'REFERENCE';
        dfielddef2.CurrencyIsoCode =  'USD';
        Insert dfielddef2;
        
        FieldDef__c dfielddef3 = new FieldDef__c();
        dfielddef3.name = 'Issue__c.Failure Category';
        dfielddef3.APIName__c = 'Failure_Category__c';
        dfielddef3.Migrate__c = true;
        dfielddef3.Object__c = dobjdef.id;
        dfielddef3.SFFieldTypeID__c = 'PICKLIST';
        dfielddef3.CurrencyIsoCode =  'USD';
        Insert dfielddef3;
        
        FieldDef__c dfielddef4 = new FieldDef__c();
        dfielddef4.name = 'Issue__c.Case';
        dfielddef4.APIName__c = 'Case__c';
        dfielddef4.Migrate__c = true;
        dfielddef4.Object__c = dobjdef.id;
        dfielddef4.SFFieldTypeID__c = 'REFERENCE';
        dfielddef4.CurrencyIsoCode =  'USD';
        Insert dfielddef4;
        
        FieldDef__c dfielddef5 = new FieldDef__c();
        dfielddef5.name = 'Issue__c.DataMig_ExternalId';
        dfielddef5.APIName__c = 'DataMig_ExternalId__c';
        dfielddef5.Migrate__c = true;
        dfielddef5.Object__c = dobjdef.id;
        dfielddef5.SFFieldTypeID__c = 'TEXT';
        dfielddef5.CurrencyIsoCode =  'USD';
        Insert dfielddef5;
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'Halo_Profile__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'Halo_Profile__c.Date Identified Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef.id ,
                                         DestinationFieldName__c = 'Date_Identified__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Halo_Profile__c.Source WO Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef3.id,
                                         DestinationField__c = dfielddef2.id ,
                                         DestinationFieldName__c = 'Source_Work_Order__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Halo_Profile__c.Project Name Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef4.id,
                                         DestinationField__c = dfielddef5.id ,
                                         DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        Insert fieldmap;    
        
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec2';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec2';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog2';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec2';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        test.startTest();
        Halo_Profile_To_Issue_Batch job1 = new Halo_Profile_To_Issue_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject2', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c = jobId );
        Insert dataMigStepLogRec;
        test.stopTest();
        
    }
    */
    /*
    Public Static TestMethod void migrate_IGU_Defects_To_Issue_Test()
    {
        Account lstacct = new Account();
        lstacct.name = 'test056';
        lstacct.CurrencyIsoCode = 'USD';
        Insert lstacct;
        
        Date myDateTime1 = Date.newInstance(2019,9, 29);
        
        Opportunity opplst = new Opportunity();
        opplst.Name  = 'TestDKBOppty057';
        opplst.AccountId = lstacct.id;
        opplst.stagename  = 'Pre-Qualifying-Developing';
        opplst.Opportunity_Type__c  = 'Opportunity';
        opplst.Support_Region__c  = 'Chicago';
        opplst.CloseDate  = myDateTime1;
        opplst.Install_Type__c = 'Sales';
        opplst.Construction_Type__c = 'New Construction';
        opplst.Basis_of_Design__c = 'No';
        opplst.Service_Contract__c = 'Standard Warranty';
        opplst.Market_Segment__c = 'Aviation';
        opplst.Project_Address__c = '746 N 77TH AVE';
        opplst.Project_City__c = 'Omaha';
        opplst.Project_State__c = 'NE';
        opplst.Project_Country__c = 'United States';
        opplst.Project_Zip_Code__c = '68114';
        Insert opplst;
        
        SVMXC__Site__c lstsite = new SVMXC__Site__c();
        lstsite.Name ='test8C';
        lstsite.SVMXC__Account__c = lstacct.id;
        lstsite.SVMXC__Country__c = 'American Samoa';
        lstsite.CurrencyIsoCode = 'USD';  
        lstsite.SVMXC__Street__c = 'test street1';
        lstsite.SVMXC__Zip__c = '111111';
        lstsite.Opportunity__c =  opplst.id;
        Insert lstsite;
        
        case lstcase = new case();
        lstcase.Status = 'New';
        Insert lstcase;
        
        SVMXC__Service_Order__c ssobj = new SVMXC__Service_Order__c();
        ssobj.CurrencyIsoCode = 'USD';
        ssobj.SVMXC__Company__c = lstacct.id;
        ssobj.SVMXC__Case__c = lstcase.id;
        ssobj.SVMXC__Site__c = lstsite.id;
        Insert ssobj;  
        
        Date myDateTime2 = Date.newInstance(2019,9, 29);        
        IGU_Defects__c IGUlist = new IGU_Defects__c();
        IGUlist.Date__c   = myDateTime2;
        IGUlist.Work_Order__c = ssobj.id;
        IGUlist.Location__c = lstsite.id;
        Insert IGUlist;
        
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'IGU_Defects__c';
        sobjdef.APIName__c = 'IGU_Defects__c';
        sobjdef.SFObjectTypeID__c = 'a6k';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'Issue__c';
        dobjdef.APIName__c = 'Issue__c';
        dobjdef.SFObjectTypeID__c = 'aAy';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        //--define source object's fields
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'IGU_Defects__c.Date';
        sfielddef.APIName__c = 'Date__c';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'DATE';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'IGU_Defects__c.Currency ISO Code';
        sfielddef1.APIName__c = 'CurrencyIsoCode';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'PICKLIST';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        FieldDef__c sfielddef2 = new FieldDef__c();
        sfielddef2.name = 'IGU_Defects__c.Location';
        sfielddef2.APIName__c = 'Location__c';
        sfielddef2.Migrate__c = true;
        sfielddef2.Object__c = sobjdef.id;
        sfielddef2.SFFieldTypeID__c = 'REFERENCE';
        sfielddef2.CurrencyIsoCode =  'USD';
        Insert sfielddef2;
        
        FieldDef__c sfielddef3 = new FieldDef__c();
        sfielddef3.name = 'IGU_Defects__c.Work Order';
        sfielddef3.APIName__c = 'Work_Order__c';
        sfielddef3.Migrate__c = true;
        sfielddef3.Object__c = sobjdef.id;
        sfielddef3.SFFieldTypeID__c = 'REFERENCE';
        sfielddef3.CurrencyIsoCode =  'USD';
        Insert sfielddef3;
        
        FieldDef__c sfielddef4 = new FieldDef__c();
        sfielddef4.name = 'IGU_Defects__c.Record ID';
        sfielddef4.APIName__c = 'Id';
        sfielddef4.Migrate__c = true;
        sfielddef4.Object__c = sobjdef.id;
        sfielddef4.SFFieldTypeID__c = 'ID';
        sfielddef4.CurrencyIsoCode =  'USD';
        Insert sfielddef4;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'Issue__c.Date Identified';
        dfielddef.APIName__c = 'Date_Identified__c';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'DATE';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        FieldDef__c dfielddef1 = new FieldDef__c();
        dfielddef1.name = 'Issue__c.Currency ISO Code';
        dfielddef1.APIName__c = 'CurrencyIsoCode';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'PICKLIST';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        FieldDef__c dfielddef2 = new FieldDef__c();
        dfielddef2.name = 'Issue__c.Source Work Order';
        dfielddef2.APIName__c = 'Source_Work_Order__c';
        dfielddef2.Migrate__c = true;
        dfielddef2.Object__c = dobjdef.id;
        dfielddef2.SFFieldTypeID__c = 'REFERENCE';
        dfielddef2.CurrencyIsoCode =  'USD';
        Insert dfielddef2;
        
        FieldDef__c dfielddef3 = new FieldDef__c();
        dfielddef3.name = 'Issue__c.Failure Category';
        dfielddef3.APIName__c = 'Failure_Category__c';
        dfielddef3.Migrate__c = true;
        dfielddef3.Object__c = dobjdef.id;
        dfielddef3.SFFieldTypeID__c = 'PICKLIST';
        dfielddef3.CurrencyIsoCode =  'USD';
        Insert dfielddef3;
        
        FieldDef__c dfielddef4 = new FieldDef__c();
        dfielddef4.name = 'Issue__c.Case';
        dfielddef4.APIName__c = 'Case__c';
        dfielddef4.Migrate__c = true;
        dfielddef4.Object__c = dobjdef.id;
        dfielddef4.SFFieldTypeID__c = 'REFERENCE';
        dfielddef4.CurrencyIsoCode =  'USD';
        Insert dfielddef4;
        
        FieldDef__c dfielddef5 = new FieldDef__c();
        dfielddef5.name = 'Issue__c.DataMig_ExternalId';
        dfielddef5.APIName__c = 'DataMig_ExternalId__c';
        dfielddef5.Migrate__c = true;
        dfielddef5.Object__c = dobjdef.id;
        dfielddef5.SFFieldTypeID__c = 'TEXT';
        dfielddef5.CurrencyIsoCode =  'USD';
        Insert dfielddef5;
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'IGU_Defects__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'IGU_Defects__c.Date Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef.id ,
                                         DestinationFieldName__c = 'Date_Identified__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'IGU_Defects__c.Work Order Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef3.id,
                                         DestinationField__c = dfielddef2.id ,
                                         DestinationFieldName__c = 'Source_Work_Order__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'IGU_Defects__c.Project Name Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef4.id,
                                         DestinationField__c = dfielddef5.id ,
                                         DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        Insert fieldmap;    
        
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec2';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec2';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog2';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec2';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        test.startTest();
        IGU_Defects_To_Issue_Batch job1 = new IGU_Defects_To_Issue_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject2', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c = jobId );
        Insert dataMigStepLogRec;
        test.stopTest();
        
    }
    * /
    
    Public Static TestMethod void migrate_IGU_Replacem_To_Issue_Test()
    {
        Account lstacct = new Account();
        lstacct.name = 'test06';
        lstacct.CurrencyIsoCode = 'USD';
        Insert lstacct;
        
        Date myDateTime1 = Date.newInstance(2019,9, 29);
        
        Opportunity opplst = new Opportunity();
        opplst.Name  = 'TestDKBOppty057';
        opplst.AccountId = lstacct.id;
        opplst.stagename  = 'Pre-Qualifying-Developing';
        opplst.Opportunity_Type__c  = 'Opportunity';
        opplst.Support_Region__c  = 'Chicago';
        opplst.CloseDate  = myDateTime1;
        opplst.Install_Type__c = 'Sales';
        opplst.Construction_Type__c = 'New Construction';
        opplst.Basis_of_Design__c = 'No';
        opplst.Service_Contract__c = 'Standard Warranty';
        opplst.Market_Segment__c = 'Aviation';
        opplst.Project_Address__c = '746 N 77TH AVE';
        opplst.Project_City__c = 'Omaha';
        opplst.Project_State__c = 'NE';
        opplst.Project_Country__c = 'United States';
        opplst.Project_Zip_Code__c = '68114';
        Insert opplst;
        
        Customer_Incident__c Custlst = new Customer_Incident__c();
        Custlst.Customer_Account__c = lstacct.id;
        Custlst.Opportunity__c = opplst.id;
        Custlst.Replacement_Needed__c = 'No';
        Custlst.CurrencyIsoCode = 'USD';
        Custlst.Customer_Contact_Name__c = 'Test DataMig1';
        Custlst.Customer_E_Mail_Signatory__c = 'xyz1@view.com';
        Custlst.Shipping_Address__c = '746 N 77TH AVE,Omaha,NE,United States,68114';
        Custlst.Shipping_Container__c = 'Wood Crate';
        Insert Custlst;
        
        Date myDateTime2 = Date.newInstance(2019,9, 29);
        IGU_Replacement_RMA__c IGUlist = new IGU_Replacement_RMA__c();
        IGUlist.Customer_Incident_Reference__c = Custlst.id ;  //Master-Detail(Customer Incident)
        IGUlist.Observation_Date__c = myDateTime2;
        IGUlist.Failure_Reason__c = 'Broken/Damaged';
        IGUlist.Failure_Category__c = 'Aesthetic';
        IGUlist.Failure_Type__c = 'During Transit';
        IGUlist.Warranty_Type__c = 'Non-Warranty';
        IGUlist.Ownership__c = 'Customer';
        IGUlist.Observation_Description__c = 'Test Data Migrate';
        IGUlist.Lite_damaged__c = 'Both';
        IGUlist.Quantity__c = 1;
        IGUlist.IGU_Id_Provided__c = 'Lite ID';
        IGUlist.Lite_Mock_ID__c = '123456';
        IGUlist.CurrencyIsoCode = 'USD';
        Insert IGUlist;
        
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'IGU_Replacement_RMA__c';
        sobjdef.APIName__c = 'IGU_Replacement_RMA__c';
        sobjdef.SFObjectTypeID__c = 'a6x';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'Issue__c';
        dobjdef.APIName__c = 'Issue__c';
        dobjdef.SFObjectTypeID__c = 'aAy';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        //--define source object's fields
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'IGU_Replacement_RMA__c.Customer Incident Reference';
        sfielddef.APIName__c = 'Customer_Incident_Reference__c';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'REFERENCE';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'IGU_Replacement_RMA__c.Currency ISO Code';
        sfielddef1.APIName__c = 'CurrencyIsoCode';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'PICKLIST';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        
        FieldDef__c sfielddef4 = new FieldDef__c();
        sfielddef4.name = 'IGU_Replacement_RMA__c.Record ID';
        sfielddef4.APIName__c = 'Id';
        sfielddef4.Migrate__c = true;
        sfielddef4.Object__c = sobjdef.id;
        sfielddef4.SFFieldTypeID__c = 'ID';
        sfielddef4.CurrencyIsoCode =  'USD';
        Insert sfielddef4;
        
        FieldDef__c sfielddef5 = new FieldDef__c();
        sfielddef5.name = 'IGU_Replacement_RMA__c.Failure Category';
        sfielddef5.APIName__c = 'Failure_Category__c';
        sfielddef5.Migrate__c = true;
        sfielddef5.Object__c = dobjdef.id;
        sfielddef5.SFFieldTypeID__c = 'PICKLIST';
        sfielddef5.CurrencyIsoCode =  'USD';
        Insert sfielddef5;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'Issue__c.Date Identified';
        dfielddef.APIName__c = 'Date_Identified__c';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'DATE';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        FieldDef__c dfielddef1 = new FieldDef__c();
        dfielddef1.name = 'Issue__c.Currency ISO Code';
        dfielddef1.APIName__c = 'CurrencyIsoCode';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'PICKLIST';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        FieldDef__c dfielddef2 = new FieldDef__c();
        dfielddef2.name = 'Issue__c.Source Work Order';
        dfielddef2.APIName__c = 'Source_Work_Order__c';
        dfielddef2.Migrate__c = true;
        dfielddef2.Object__c = dobjdef.id;
        dfielddef2.SFFieldTypeID__c = 'REFERENCE';
        dfielddef2.CurrencyIsoCode =  'USD';
        Insert dfielddef2;
        
        FieldDef__c dfielddef3 = new FieldDef__c();
        dfielddef3.name = 'Issue__c.Failure Category';
        dfielddef3.APIName__c = 'Failure_Category__c';
        dfielddef3.Migrate__c = true;
        dfielddef3.Object__c = dobjdef.id;
        dfielddef3.SFFieldTypeID__c = 'PICKLIST';
        dfielddef3.CurrencyIsoCode =  'USD';
        Insert dfielddef3;
        
        FieldDef__c dfielddef4 = new FieldDef__c();
        dfielddef4.name = 'Issue__c.Case';
        dfielddef4.APIName__c = 'Case__c';
        dfielddef4.Migrate__c = true;
        dfielddef4.Object__c = dobjdef.id;
        dfielddef4.SFFieldTypeID__c = 'REFERENCE';
        dfielddef4.CurrencyIsoCode =  'USD';
        Insert dfielddef4;
        
        FieldDef__c dfielddef5 = new FieldDef__c();
        dfielddef5.name = 'Issue__c.DataMig_ExternalId';
        dfielddef5.APIName__c = 'DataMig_ExternalId__c';
        dfielddef5.Migrate__c = true;
        dfielddef5.Object__c = dobjdef.id;
        dfielddef5.SFFieldTypeID__c = 'TEXT';
        dfielddef5.CurrencyIsoCode =  'USD';
        Insert dfielddef5;
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'IGU_Replacement_RMA__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'IGU_Replacement_RMA__c.Customer Incident Ref Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef4.id ,
                                         DestinationFieldName__c = 'Case__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        
        fieldmap.add(new FieldMapping__c(name = 'IGU_Replacement_RMA__c.Record ID Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef4.id,
                                         DestinationField__c = dfielddef5.id ,
                                         DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        
        Insert fieldmap;    
        
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec2';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec2';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog2';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec2';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        test.startTest();
        IGU_Replacem_To_Issue_Batch job1 = new IGU_Replacem_To_Issue_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject2', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c = jobId );
        Insert dataMigStepLogRec;
        test.stopTest();
        
    }
    
    Public Static TestMethod void migrate_Asset_To_Asset_Test()
    {
        
        Account act = new account();
        act.Name = 'Test Generate Product Req Ac';
        act.CurrencyIsoCode = 'USD' ;
        act.Oracle_Customer_Number__c = '123211';
        act.ShippingStreet = '7845 Center Street SW';
        act.ShippingCity   = 'Tumwater';
        act.ShippingState   = 'WA';
        act.ShippingPostalCode  = 'WA';
        act.ShippingCountry ='USA';
        Insert act;
        
        contact contlst = new contact();
      	contlst.AccountId = act.id;
        contlst.CurrencyIsoCode = 'USD' ;
        contlst.LastName = 'Test Product';
        contlst.MobilePhone = '(763) 516-2499';
        Insert contlst;
                
        Date myDateTime1 = Date.newInstance(2019,10, 20);
                   
        Opportunity opplst = new Opportunity();
        opplst.Name  = 'Test Generate Product';
		opplst.AccountId = act.id;
		opplst.stagename  = 'Bid/Quote';
		opplst.Opportunity_Type__c  = 'Opportunity';
		opplst.Support_Region__c  = 'Bay Area';
		opplst.CloseDate  = myDateTime1;
		opplst.Install_Type__c = 'Sales';
		opplst.Construction_Type__c = 'New Construction';
		opplst.Basis_of_Design__c = 'View';
		opplst.Service_Contract__c = 'Standard Warranty';
		opplst.Market_Segment__c = 'Aviation';
        opplst.Project_Address__c = '7845 Center Street SW';
        opplst.Project_City__c = 'CA';
		opplst.Project_State__c = 'CA';
        opplst.Project_Country__c = 'United States';
        opplst.Project_Zip_Code__c = '68114';
        opplst.CHW_Warranty_Date__c = myDateTime1;
        opplst.Project_Number__c = '5203';
        //opplst.IGU_Warranty_Date__c = 
        Insert opplst;
        
        Pricebook2 standardPricebook = new Pricebook2 (Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
        
        Product2 newProduct;
       /* newProduct = new Product2(Name = 'Gen3 1" OAT Rec 6MM EC #2 CLR T, EB-M, 1/2" ARG, 6MM CLR T, Keyed M8',
                                  IsActive = true, Family= 'IGU', ProductCode = '963-000155',
                                  Product_SKU__c = '30112-018J', 
                                  Old_Part_Number__c = '864-000001-143',
                                  //Component_Type__c = 'Connector, Terminator, and Other',
                                  //Controls_Type__c = 'System Hardware',
                                  CurrencyIsoCode = 'USD'
        						);* /
        newProduct = new Product2(Name = 'Cable Assembly 2.5mm ID, 5.5mm OD Plug to Wire Leads Flat 6.0'+' (1.83m)',
                                  IsActive = true, Family= 'CSS', ProductCode = '380-101507',Product_SKU__c ='380-101507',
                                  //StockKeepingUnit = '380-101507',
                                  Component_Type__c = 'IGU Cable', Controls_Type__c = 'System Hardware',CurrencyIsoCode = 'USD'
        						);
        Insert newProduct;
        
        List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
        for (Product2 prod : [SELECT Id, Product_SKU__c, Name, Generation__c, Shape__c, Inboard_Lite__c,
                         Laminate__c, ProductCode, Family FROM Product2])
        {
            Decimal price = XMath.getRandomInt(1000) * 0.1;
            pbeList.Add(new PriceBookEntry(PriceBook2Id = standardPriceBook.Id, Product2Id = prod.Id,
                                           UnitPrice = price, isActive = true));
        }
        insert pbeList;
        
        DateTime myDateTime2 = DateTime.newInstance(2019,9,1, 4,44,08); //8/1/2019 4:44 AM
        Asset__c assobj;
       	assobj = new Asset__c(CurrencyIsoCode = 'USD', Actual_Area__c = '5616', BB_Distance__c = 58.5000, 
				Current_Step__c = 'Shipped', Customer_Reference__c = 'Mt Vernon Presbyterian CI 000573 (17059136-011)',
				H1__c = 0.0000,IGU_Shipped_Date__c = myDateTime2, Lite_Height__c = 96.0000, Lite_Id__c = '17491`50`71`17`0',
				Lite_Width__c = 58.5000, Opportunity__c = opplst.id, Opportunity_ID__c = opplst.id, 
                Product__c = newProduct.id, Shape__c = 'SH000', Shipment_Number__c = 3686.0000, SKU__c = '380-101507', //'963-000155', 
				SKUDescription__c = 'Gen3 1" OAT Rec 6MM EC #2 CLR T, EB-M, 1/2" ARG, 6MM CLR T, Keyed M8',
				Unity_Type__c = 'Product',W1__c = 0.0000);
        Insert assobj;
       
        //--define source and destination objects
        ObjectDef__c sobjdef = new ObjectDef__c();
        sobjdef.Name = 'Asset__c';
        sobjdef.APIName__c = 'Asset__c';
        sobjdef.SFObjectTypeID__c = 'a3a';
        sobjdef.Migrate__c = true;
        Insert sobjdef;
        
        ObjectDef__c dobjdef = new ObjectDef__c();
        dobjdef.Name = 'Asset';
        dobjdef.APIName__c = 'Asset';
        dobjdef.SFObjectTypeID__c = '02i';
        dobjdef.Migrate__c = false;
        Insert dobjdef;
        
        //--define source object's fields
        FieldDef__c sfielddef = new FieldDef__c();
        sfielddef.name = 'Asset__c.Assets Name';
        sfielddef.APIName__c = 'Name';
        sfielddef.Migrate__c = true;
        sfielddef.Object__c = sobjdef.id;
        sfielddef.SFFieldTypeID__c = 'STRING';
        sfielddef.CurrencyIsoCode =  'USD';
        Insert sfielddef;
        
        FieldDef__c sfielddef1 = new FieldDef__c();
        sfielddef1.name = 'Asset__c.Currency ISO Code';
        sfielddef1.APIName__c = 'CurrencyIsoCode';
        sfielddef1.Migrate__c = true;
        sfielddef1.Object__c = sobjdef.id;
        sfielddef1.SFFieldTypeID__c = 'PICKLIST';
        sfielddef1.CurrencyIsoCode =  'USD';
        Insert sfielddef1;
        
        FieldDef__c sfielddef2 = new FieldDef__c();
        sfielddef2.name = 'Asset__c.Lite Id';
        sfielddef2.APIName__c = 'Lite_Id__c';
        sfielddef2.Migrate__c = true;
        sfielddef2.Object__c = sobjdef.id;
        sfielddef2.SFFieldTypeID__c = 'STRING';
        sfielddef2.CurrencyIsoCode =  'USD';
        Insert sfielddef2;
        
        FieldDef__c sfielddef3 = new FieldDef__c();
        sfielddef3.name = 'Asset__c.SKUDescription';
        sfielddef3.APIName__c = 'SKUDescription__c';
        sfielddef3.Migrate__c = true;
        sfielddef3.Object__c = sobjdef.id;
        sfielddef3.SFFieldTypeID__c = 'STRING';
        sfielddef3.CurrencyIsoCode =  'USD';
        Insert sfielddef3;
        
        FieldDef__c sfielddef4 = new FieldDef__c();
        sfielddef4.name = 'Asset__c.Record ID';
        sfielddef4.APIName__c = 'Id';
        sfielddef4.Migrate__c = true;
        sfielddef4.Object__c = sobjdef.id;
        sfielddef4.SFFieldTypeID__c = 'ID';
        sfielddef4.CurrencyIsoCode =  'USD';
        Insert sfielddef4;
        
        FieldDef__c sfielddef5 = new FieldDef__c();
        sfielddef5.name = 'Asset__c.Opportunity';
        sfielddef5.APIName__c = 'Opportunity__c';
        sfielddef5.Migrate__c = true;
        sfielddef5.Object__c = sobjdef.id;
        sfielddef5.SFFieldTypeID__c = 'REFERENCE';
        sfielddef5.CurrencyIsoCode =  'USD';
        Insert sfielddef5;
        
        FieldDef__c sfielddef6 = new FieldDef__c();
        sfielddef6.name = 'Asset__c.Product';
        sfielddef6.APIName__c = 'Product__c';
        sfielddef6.Migrate__c = true;
        sfielddef6.Object__c = sobjdef.id;
        sfielddef6.SFFieldTypeID__c = 'REFERENCE';
        sfielddef6.CurrencyIsoCode =  'USD';
        Insert sfielddef6;
        
        FieldDef__c sfielddef7 = new FieldDef__c();
        sfielddef7.name = 'Asset__c.SKU';
        sfielddef7.APIName__c = 'SKU__c';
        sfielddef7.Migrate__c = true;
        sfielddef7.Object__c = sobjdef.id;
        sfielddef7.SFFieldTypeID__c = 'STRING';
        sfielddef7.CurrencyIsoCode =  'USD';
        Insert sfielddef7;
        
        FieldDef__c sfielddef8 = new FieldDef__c();
        sfielddef8.name = 'Asset__c.Current Step';
        sfielddef8.APIName__c = 'Current_Step__c';
        sfielddef8.Migrate__c = true;
        sfielddef8.Object__c = sobjdef.id;
        sfielddef8.SFFieldTypeID__c = 'PICKLIST';
        sfielddef8.CurrencyIsoCode =  'USD';
        Insert sfielddef8;
        
        //--define destination object's fields
        FieldDef__c dfielddef = new FieldDef__c();
        dfielddef.name = 'Asset.Source Reccord Name';
        //dfielddef.APIName__c = 'Source_Record_Name__c';
        dfielddef.APIName__c = 'Name';
        dfielddef.Migrate__c = true;
        dfielddef.Object__c = dobjdef.id;
        dfielddef.SFFieldTypeID__c = 'STRING';
        dfielddef.CurrencyIsoCode =  'USD';
        Insert dfielddef;
        
        FieldDef__c dfielddef1 = new FieldDef__c();
        dfielddef1.name = 'Asset.Currency ISO Code';
        dfielddef1.APIName__c = 'CurrencyIsoCode';
        dfielddef1.Migrate__c = true;
        dfielddef1.Object__c = dobjdef.id;
        dfielddef1.SFFieldTypeID__c = 'PICKLIST';
        dfielddef1.CurrencyIsoCode =  'USD';
        Insert dfielddef1;
        
        FieldDef__c dfielddef2 = new FieldDef__c();
        dfielddef2.name = 'Asset.Lite Id';
        dfielddef2.APIName__c = 'Lite_Id__c';
        dfielddef2.Migrate__c = true;
        dfielddef2.Object__c = dobjdef.id;
        dfielddef2.SFFieldTypeID__c = 'STRING';
        dfielddef2.CurrencyIsoCode =  'USD';
        Insert dfielddef2;
        
        FieldDef__c dfielddef3 = new FieldDef__c();
        dfielddef3.name = 'Asset.SKUDescription';
        dfielddef3.APIName__c = 'SKUDescription__c';
        dfielddef3.Migrate__c = true;
        dfielddef3.Object__c = dobjdef.id;
        dfielddef3.SFFieldTypeID__c = 'STRING';
        dfielddef3.CurrencyIsoCode =  'USD';
        Insert dfielddef3;
        
        FieldDef__c dfielddef4 = new FieldDef__c();
        dfielddef4.name = 'Asset.DataMig_ExternalId';
        dfielddef4.APIName__c = 'DataMig_ExternalId__c';
        dfielddef4.Migrate__c = true;
        dfielddef4.Object__c = dobjdef.id;
        dfielddef4.SFFieldTypeID__c = 'TEXT';
        dfielddef4.CurrencyIsoCode =  'USD';
        Insert dfielddef4;
               
        FieldDef__c dfielddef5 = new FieldDef__c();
        dfielddef5.name = 'Asset.Opportunity';
        dfielddef5.APIName__c = 'Opportunity__c';
        dfielddef5.Migrate__c = true;
        dfielddef5.Object__c = dobjdef.id;
        dfielddef5.SFFieldTypeID__c = 'REFERENCE';
        dfielddef5.CurrencyIsoCode =  'USD';
        Insert dfielddef5;
        
        FieldDef__c dfielddef6 = new FieldDef__c();
        dfielddef6.name = 'Asset.Product Id';
        dfielddef6.APIName__c = 'Product2Id';
        dfielddef6.Migrate__c = true;
        dfielddef6.Object__c = dobjdef.id;
        dfielddef6.SFFieldTypeID__c = 'REFERENCE';
        dfielddef6.CurrencyIsoCode =  'USD';
        Insert dfielddef6;
        
        FieldDef__c dfielddef7 = new FieldDef__c();
        dfielddef7.name = 'Asset.SKU';
        dfielddef7.APIName__c = 'SKU__c';
        dfielddef7.Migrate__c = true;
        dfielddef7.Object__c = dobjdef.id;
        dfielddef7.SFFieldTypeID__c = 'STRING';
        dfielddef7.CurrencyIsoCode =  'USD';
        Insert dfielddef7;
        
        FieldDef__c dfielddef8 = new FieldDef__c();
        dfielddef8.name = 'Asset.Status';
        dfielddef8.APIName__c = 'Status';
        dfielddef8.Migrate__c = true;
        dfielddef8.Object__c = dobjdef.id;
        dfielddef8.SFFieldTypeID__c = 'PICKLIST';
        dfielddef8.CurrencyIsoCode =  'USD';
        Insert dfielddef8;
        
        FieldDef__c dfielddef9 = new FieldDef__c();
        dfielddef9.name = 'Asset.Account Id';
        dfielddef9.APIName__c = 'AccountId';
        dfielddef9.Migrate__c = true;
        dfielddef9.Object__c = dobjdef.id;
        dfielddef9.SFFieldTypeID__c = 'REFERENCE';
        dfielddef9.CurrencyIsoCode =  'USD';
        Insert dfielddef9;
        
        //--Source and destination Object Mapping
        ObjectMapping__c objmap = new ObjectMapping__c();
        objmap.name = 'Asset__c Map';
        objmap.SourceObject__c = sobjdef.id;
        objmap.DestinationObject__c = dobjdef.id;
        Insert objmap;
        
        //--Source and destination field Mappings
        list<FieldMapping__c> fieldmap = new list<FieldMapping__c>();
        fieldmap.add(new FieldMapping__c(name = 'Asset__c.Assets Name Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef.id,
                                         DestinationField__c = dfielddef.id ,
                                         DestinationFieldName__c = 'Name', //'Source_Reccord_Name__c',
                                         WhereOperator__c = null, WhereValue__c = null));
         fieldmap.add(new FieldMapping__c(name = 'Asset__c.Currency ISO Code Map',
                                         ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef1.id,
                                         DestinationField__c = dfielddef1.id ,
                                         DestinationFieldName__c = 'CurrencyIsoCode',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Asset__c.Lite Id Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef2.id,
                                         DestinationField__c = dfielddef2.id ,
                                         DestinationFieldName__c = 'Lite_Id__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Asset__c.SKUDescription Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef3.id,
                                         DestinationField__c = dfielddef3.id ,
                                         DestinationFieldName__c = 'SKUDescription__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Asset__c.Record ID Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef4.id,
                                         DestinationField__c = dfielddef4.id ,
                                         DestinationFieldName__c = 'DataMig_ExternalId__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Asset__c.Opportunity Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef5.id,
                                         DestinationField__c = dfielddef5.id ,
                                         DestinationFieldName__c = 'Opportunity__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Asset__c.Product Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef6.id,
                                         DestinationField__c = dfielddef6.id ,
                                         DestinationFieldName__c = 'Product2Id',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Asset__c.SKU Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef7.id,
                                         DestinationField__c = dfielddef7.id ,
                                         DestinationFieldName__c = 'SKU__c',
                                         WhereOperator__c = null, WhereValue__c = null));
        fieldmap.add(new FieldMapping__c(name = 'Asset__c.Current Step Map', ObjectMapping__c = objmap.id,
                                         SourceField__c = sfielddef8.id,
                                         DestinationField__c = dfielddef8.id ,
                                         DestinationFieldName__c = 'Status',
                                         WhereOperator__c = null, WhereValue__c = null));
        Insert fieldmap; 
        
        PicklistValueDef__c spicklstdef = new PicklistValueDef__c();
        spicklstdef.name = 'Asset__c.CurrencyIsoCode_USD';
        spicklstdef.FieldDef__c = sfielddef1.id;
        spicklstdef.PicklistValue__c = 'USD';
        Insert spicklstdef;
        
        PicklistValueDef__c dpicklstdef = new PicklistValueDef__c();
        dpicklstdef.name = 'Asset.CurrencyIsoCode_USD';
        dpicklstdef.FieldDef__c = dfielddef1.id;
        dpicklstdef.PicklistValue__c = 'USD';
        Insert dpicklstdef;
        
        PicklistValueMapping__c picklstmap = new PicklistValueMapping__c();
        picklstmap.Name = 'Asset__c.CurrencyIsoCode_USD Map';
        picklstmap.DestinationPickListName__c = 'USD';
        picklstmap.DestinationPicklistValue__c = dpicklstdef.Id;
        picklstmap.SourcePicklistValue__c = spicklstdef.Id;
        Insert picklstmap;   
        
        PicklistValueDef__c spicklstdef1 = new PicklistValueDef__c();
        spicklstdef1.name = 'Asset__c.Current Step_Shipped';
        spicklstdef1.FieldDef__c = sfielddef8.id;
        spicklstdef1.PicklistValue__c = 'Shipped';
        Insert spicklstdef1;
        
        PicklistValueDef__c dpicklstdef1 = new PicklistValueDef__c();
        dpicklstdef1.name = 'Asset.Status_Shipped';
        dpicklstdef1.FieldDef__c = dfielddef8.id;
        dpicklstdef1.PicklistValue__c = 'Shipped';
        Insert dpicklstdef1;
        
        PicklistValueMapping__c picklstmap1 = new PicklistValueMapping__c();
        picklstmap1.Name = 'Asset__c.Current Step_Shipped Map';
        picklstmap1.DestinationPickListName__c = 'Shipped';
        picklstmap1.DestinationPicklistValue__c = dpicklstdef1.Id;
        picklstmap1.SourcePicklistValue__c = spicklstdef1.Id;
        Insert picklstmap1;  
                
        DataMigProcStepDef__c dmprocstepdef = new DataMigProcStepDef__c();
        dmprocstepdef.name = 'DataMigProcStepDef rec2';
        dmprocstepdef.ObjectMapping__c = objmap.id;
        dmprocstepdef.SOQLLimitBufferPct__c = 20.00;
        dmprocstepdef.StepSequence__c = 1;
        dmprocstepdef.HeapSizeLimitBufferPct__c = 20.00;
        Insert dmprocstepdef;
        
        //2019-09-12 09:44:08  2019, 9, 12, 10:44:08
        DateTime myDateTime = DateTime.newInstance(2019, 9, 12, 3,44,08);
        Datetime myDT = Datetime.now();
        DataMigProcLog__c dmproclog = new DataMigProcLog__c();
        dmproclog.name = 'DataMigProcLog rec2';
        dmproclog.StartDateTime__c = myDT;
        dmproclog.EndDateTime__c = myDateTime;
        dmproclog.StatusDetail__c = 'Test DataMigProCLog2';
        Insert dmproclog;
        
        DataMigStepLog__c dmsteplog = new DataMigStepLog__c();
        dmsteplog.Name = 'DataMigStepLog rec2';
        dmsteplog.DataMigProc__c = dmproclog.id;
        dmsteplog.DataMigProcStepDef__c = dmprocstepdef.id;
        Insert dmsteplog;
        
        test.startTest();
        Asset_To_Asset_Batch job1 = new Asset_To_Asset_Batch();
        id jobId = Database.executeBatch( job1 );
        DataMigStepLog__c dataMigStepLogRec = new DataMigStepLog__c(Name = 'sampleObject2', DataMigProcStepDef__c = dmprocstepdef.Id, DataMig_Batch_Job_Id__c = jobId );
        Insert dataMigStepLogRec;
        test.stopTest();
        
    }
    */
}