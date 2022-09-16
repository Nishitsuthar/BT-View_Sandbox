public class DataMig_InitializeObjDefs {
    public static void DataMig_InitializeObjDefs1(){

    }
    /* where ever * / is present remove the space between
 public static void initializeObjects(List<String> objectNames){
        
        //TO DO: Add Source Flag to Object Def and Field Def objects, 
        //add string array and boolean parameters to function
        //to allow list of object api names and source indicator to be passed in.  
        
        //Declare List for In Scope Object Fields
        List<FieldDef__c> fldDefs = new List<FieldDef__c>();
        
        //Declare Map for Field Properties
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
        
        //Declare String for In Scope Object API Names. 
        //Should Contain BOTH Source and Destination Objects.
        /*String[] objectNames = new String[]{
            'DMT_SourceA__c',
            'DMT_SourceB__c',
            'DMT_SourceC__c',
            'DMT_DestA__c',
            'DMT_DestB__c',
            'DMT_DestC__c'
       };* /
           
		//Retrieve Object Details for In Scope Objects
        Schema.DescribeSobjectResult[] schemaObjects = Schema.describeSObjects(objectNames);
        //Declare list of  to Avaoid govern limts 
        //List<ObjectDef__c> listofObjDefs = new List<ObjectDef__c>();
		  //Declare Instance of ObjectDef Object
        	ObjectDef__c objDef = new ObjectDef__c();
 
        //Iterate through Schema Describe Result Array of Object Details
    	for(Schema.DescribeSobjectResult sobj: schemaObjects){ 
          
            //Insure ID is Initially NULL
            objDef.ID = Null;
            //get count of records for every object
            integer count= database.countQuery('select count() from '+sobj.getName());
					
            //Set ObjectDef attributes from Current Schema Describe Result    
            objDef.APIName__c = sobj.getName();
            objDef.Name = sobj.getName();//sobj.getLabel();
            objDef.SFObjectTypeID__c = sobj.getKeyPrefix(); 
            objDef.Migrate__c = True; 
			ObjDef.Source_Object_RecordCount__c = count;
			//Insert current Object Definition and Obtain ID for use in Field Definition Inserts
			//Insert within for loop. Small number of objects. If larger rewrite limit DB calls.
			insert objDef;
            //listofObjDefs.add(objDef);
            //Get Fields for Current Object
         	fieldMap = sobj.fields.getMap();
        
     //Insert listofObjDefs;
    // for(ObjectDef__c objDefRec : listofObjDefs){
            //Iterate through Field Map Keys (Field Names)
            for( String field: fieldMap.keyset() ){
                
                //Get Field Schema Describe Result for Current Field
                Schema.DescribeFieldResult dr = fieldMap.get(field).getDescribe();
                
                //Add New Field Definition to List
                fldDefs.add(new FieldDef__c (
                       	Name = objDef.Name+'.'+dr.getLabel().abbreviate(80),
                    	APIName__c = dr.getName(),
                    	Object__c = objDef.Id,  //Set FK ID for Current Object Definition
                    	SFFieldTypeID__c = dr.getType().name(),  //Get Datatype for Current Field 
                    	Migrate__c = True 
                )); 
            }
        }
        //insert Field Definitions
        insert fldDefs;
        
        system.debug('fldDefs: '+fldDefs);
        //Handle Picklist Value Definitions
        for (FieldDef__c fldDef : fldDefs){
            system.debug('fldDefinside loop'+fldDef);
            if (fldDef.SFFieldTypeID__c == 'Picklist'){
                List<string> objName = new List<string>();
              
           		objName.add(fldDef.Name.substringBefore('.'));
				system.debug('objName: '+ objName);
                //Get Schema info for current object
                Schema.DescribeSobjectResult[] schemaObj = Schema.describeSObjects(objName);
                
                //Iterate through schema info
                for (DescribeSObjectResult descRes: schemaObj){
                    
                    //obtain field tokens for current object
                    Map<String, Schema.SObjectField> fsMap = 
                        new Map<String, Schema.SObjectField>(descRes.fields.getMap());
                    
                    //Iterate through field info
                    for (String fieldName: fsMap.keySet()){
                        
                        //Isolate current Field info
                        if (fldDef.APIName__c == fieldName){
                            
                            //Obtain Describe Results for Field
                            Schema.DescribeFieldResult descFRes = fsMap.get(fieldName).getDescribe();
                            
                            //Obtain Picklist Values and store in List
                            List<Schema.PicklistEntry> pListEntries = 
                                new List<Schema.PicklistEntry>(descFRes.getPicklistValues());
                            
                            //Create List to hold new Pick List Value Definition records
                            List<PickListValueDef__c> pLVDef = new List<PickListValueDef__c>();
                            
                            //Iterate through picklist values storing new PickList Value Defs for each
                            for (Schema.PickListEntry pListEntry: pListEntries){
                                pLVDef.add(new PickListValueDef__c(
                                    FieldDef__c = fldDef.Id, 
                                    PicklistValue__c = pListEntry.getValue(), 
                                    Name = (fldDef.Name +'_'+pListEntry.getValue()).abbreviate(80)
                                ));
                            }
                            
                            //Insert Picklist Value Definitions
                            insert pLVDef;
                        }
                    }
                }
            }
        }
    }
    
 
    public static void initializeMappings(List<String> objDefNames){

        
        //Retrieve Object Defs with Migrate Checkbox Checked and 
        //DO NOT Have a Corresponding Object Map Record
       /* List<ObjectDef__c> objDefs = new List<ObjectDef__c>([
            	SELECT ID, Name FROM ObjectDef__c 
            	WHERE Migrate__c = True AND ObjectDef__c.ID NOT IN (
                	SELECT SourceObject__c FROM ObjectMapping__c)
        ]);* /
        Set<Id> objDefId = new Set<Id>();
        List<ObjectDef__c> objDefs = new List<ObjectDef__c>([
            	SELECT ID, Name FROM ObjectDef__c 
            	WHERE Migrate__c = True AND ObjectDef__c.Name =: objDefNames
        ]);
        for(ObjectDef__c objDefrec : objDefs ){
            objDefId.add(objDefrec.Id);
        }
        
        //For the Collected Object Defs, Retrieve Field Defs 
        //with Migrate Checkbox Checked and 
        //DO NOT have a Corresponding Field Map Record and 
        //DO HAVE the Object Def Migrate Checked
        List<FieldDef__c> fldDefs = new List<FieldDef__c>([
            SELECT ID, NAME, Object__c FROM FieldDef__c 
            WHERE Migrate__c = True AND Object__c =: objDefId]); //in (SELECT ID FROM ObjectDef__c WHERE Migrate__c = True AND Id =:objDefs.Id )]);// AND ID NOT IN (SELECT SourceField__c FROM FieldMapping__c)]);
        
        List<ObjectMapping__c> objMaps = new List<ObjectMapping__c>();
        List<FieldMapping__c> fldMaps = new List<FieldMapping__c>();
         
        //Create New Object Mapping Record for each Object. 
        //Leave Destination Object Null.
        // TO DO: Need to check for existing Object Map when 
        // new Field Defs are marked Migrate to insure 
        // they are included in the FieldDefs Collection 
        // and that duplicate Object Maps are not created.
        for(ObjectDef__c objDef : objDefs){
            
   			objMaps.add(
                new ObjectMapping__c(
                    SourceObject__c = objDef.Id, 
                    Name = objDef.Name +' Map'
                )); 
        }
        
        //upsert Object Mapping Records
        upsert objMaps;
        List<RecordTypeMapping__c> recordTypeRecList = new List<RecordTypeMapping__c>();
        Set<Id> objMappingIds = new Set<Id>();
        for(ObjectMapping__c objMap : objMaps){
            objMappingIds.add(objMap.Id);
        }
        List<ObjectMapping__c> objMappingList = [Select id, SourceObject__c, SourceObject__r.Name, SourceObject__r.APIName__c from ObjectMapping__c where Id =: objMappingIds ];
        for (ObjectMapping__c objMap : objMappingList){
            //String srcObjectName = objMap.SourceObject__r.APIName__c;
            
            for(RecordType recdType : [SELECT Id, Name, DeveloperName , sObjectType from RecordType where sObjectType =: objMap.SourceObject__r.APIName__c]){
               
                recordTypeRecList.add(
                		new RecordTypeMapping__c(
                            Name = objMap.SourceObject__r.APIName__c + recdType.Name , 
                        	ObjectMapping__c = objMap.Id,
                        	SourceRecordTypeID__c = recdType.Id,
                            SrcObjRecTypeName__c = recdType.Name,
                            SrcObjRecType_DevName__c = recdType.DeveloperName,
                            SourceObjectName__c = objMap.SourceObject__r.APIName__c 
                        ));
                 
            }
             system.debug('recordtype Mappings'+ recordTypeRecList);
            //Create New Field Mapping Record for each Field. 
            //Leave Destination Field Null.
            for(FieldDef__c fldDef : fldDefs){
                
                if(fldDef.Object__c == objMap.SourceObject__c){
                	fldMaps.add(
                        new FieldMapping__c(
                            Name = fldDef.Name + ' Map', 
                            ObjectMapping__c = objMap.Id, 
                            SourceField__c = fldDef.Id 
                        ));
                    
                }
			}
           
        } 
        //upsert Field Mapping Records
        upsert fldMaps;
        //upsert RecordTypeMapping Records
        Insert recordTypeRecList;
        
        
        //Handle Picklist Value Mappings
        List<PicklistValueDef__c> pLVDs = new List<PicklistValueDef__c>([
            SELECT Id, Name, PicklistValue__c, FieldDef__c, FieldDef__r.Migrate__c
            FROM PicklistValueDef__c
            WHERE FieldDef__r.Migrate__c = True]);
        
        List<PicklistValueMapping__c> pLVMs= new List<PicklistValueMapping__c>();
        
        for (PicklistValueDef__c pLVD : pLVDs){
            pLVMs.add(
                new PicklistValueMapping__c(
                    Name =pLVD.Name.abbreviate(75)+' Map', 
                    SourcePicklistValue__c = pLVD.Id 
                ));
        }
        
        //Upsert Picklist Value Mappings
        upsert pLVMs; 
    }
    
    
    
    
    
    
    
     /* Source Object List
      		'SVMXC__Site__c',//Location
            'SVMX_Location_Contact_Role__c',//Location - Contact Role
            'SVMX_Location_Related_Opportunities__c',//Location-Related Opportunities
            'SVMXC__PM_Plan__c',//Preventative Maintenance Plan
            'SVMXC__Service_Order__c',//Work Order
            'SVMXC__Service_Order_Dependency__c',//Work Order Dependency
            'SVMXC__Service_Order_Line__c',//Work Detail
            'SVMXC__Work_Order_Resource__c',//Work Order Resource
            'Site_Task__c',//Site Task
            'Halo_Profile__c',//Halo Profile
            'IGU_Defects__c',//IGU Defects
            'IGU_Quality_Detail__c',//IGU Quality Detail
            'SVMXC__Parts_Request__c',//Parts Request
            'SVMXC__Parts_Request_Line__c',//Parts Request Line
            'SVMXC__RMA_Shipment_Order__c',//Parts Order
            'SVMXC__RMA_Shipment_Line__c',//Parts Order Line
            'SVMXC__Service_Group__c',//Service Team
            'SVMXC__Product_Stock__c',// Stock
            'SVMXC__Stock_History__c',//Stock History
            'Work_Order_Comments__c',//Work Order Comments
            'Network_Connections__c',//Network Connection
            'Control_Panel__c',//Control Panel
            'Port_Forwarding__c',//Port Forwarding
            'VPN_Profile__c',//VPN Profile',
            'SVMXC__Service_Group_Members__c',//Technician/Equipment
            'SVMXC__SM_Appointment_Window__c',//Appointment Window
            'Case'//Case* /
    
   */
}