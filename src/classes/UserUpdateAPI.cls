@RestResource(urlMapping='/api/UserUpdateAPI')
global class UserUpdateAPI{

    @HTTPPost
    global static String doPost(){
         RestRequest req = RestContext.request;
         String reqBodyString = req.requestBody.toString();
		 system.debug('reqBodyString'+reqBodyString);
        system.debug('sussces');
         String EmployeeId = '';
         boolean isNoManagerID = false;
		 try
        {
         processhremployeedataparserctrl.Processhremployeedataparser  processedData = processhremployeedataparserctrl.parse(reqBodyString);
        //Employee_ID__c
        Map<String,User> Users = new Map<String,User>();
        Map<String,User> SupervisorUsers = new Map<String,User>();
        Map<String, Map<String,String>> userExceptions = new Map<String, Map<String, String>>();
        Map<String, Map<String,processhremployeedataparserctrl.Data>> userExceptions1 = new Map<String, Map<String, processhremployeedataparserctrl.Data>>();
        Map<String,String> userExceptionList = new Map<String,String>();
        Map<String,map<String,processhremployeedataparserctrl.Data>> userExceptionList1 = new Map<String,map<String,processhremployeedataparserctrl.Data>>();
        Map<String, String> userExceptionMessages = new Map<String, String>();
        Map<String, String> userExceptionMessages1 = new Map<String, String>();
       
        Map<String,processhremployeedataparserctrl.Data> UsersProcess = new Map<String,processhremployeedataparserctrl.Data>();
        Map<String,processhremployeedataparserctrl.Data> updateuserempid = new Map<String,processhremployeedataparserctrl.Data>();
       
        
        List<String> EmployeeIds = new List<String>();
        List<String> EmpEmailIds = new List<String>();
        List<String> SupervisorIds = new List<String>();
        list<user> updateingemplist= new list<user>();
            system.debug('processedData.data '+processedData.data +processedData);
      //  map<string,string>  = new map<string,string>();
        for(processhremployeedataparserctrl.Data each:processedData.data ){
            EmployeeIds.add(each.EMPLOYEE_NUMBER);            
            UsersProcess.put(each.EMPLOYEE_NUMBER,each);
            updateuserempid.put(each.EMAIL_ADDRESS,each);
            SupervisorIds.add(each.SUPERVISOR_ID);
        }
       // system.debug('updateuserempid'+'sss'+updateuserempid.get('seshu.korivi@gmail.com').EMAIL_ADDRESS);
        for(user uempup:[select id,LastName, FirstName,Title, email, Hire_Date__c , Employee_Office_Location__c,
                        ManagerId,Employee_Department__c,Employee_ID__c from User where Employee_ID__c=null and type__C != 'System User (Integration)' and IsActive=True])
        {
            
           // system.debug('uempup.email'+updateuserempid.get(uempup.email).EMAIL_ADDRESS);
            if(updateuserempid.containsKey(uempup.email))
            {
               // system.debug('ss'+updateuserempid.get(uempup.email).EMAIL_ADDRESS);
                uempup.Employee_ID__c = updateuserempid.get(uempup.email).EMPLOYEE_NUMBER;
                updateingemplist.add(uempup);
            }
            
        }
        
        update updateingemplist;
        
        
        system.debug('UsersProcess'+UsersProcess);      
        System.debug('Supervisors :: '+SupervisorIds);
        for(user u:[select id,Employee_ID__c from User where Employee_ID__c in:SupervisorIds]){
            SupervisorUsers.put(u.Employee_ID__c,u);
        }
        System.debug('Supervisors :: ' +SupervisorUsers );
        if(SupervisorUsers.isEmpty())
        {
            isNoManagerID = true;
        }
        
        list<User> ALlUsers = new list<User>();
        Map<String, User> UsersMap = new Map<String, User>();

        for(user u:[select id,LastName, FirstName,Title, email, Hire_Date__c , Employee_Office_Location__c,Profile.Name,
                        ManagerId,Manager.Employee_ID__c,Employee_Department__c,Employee_ID__c from User where Employee_ID__c in:EmployeeIds and type__C != 'System User (Integration)'])
        {
            UsersMap.put(u.Employee_ID__c, u);
        }
        // Check if employee Id is in Salesforce
    /*    for(String each : EmployeeIds)
        {
            User u = UsersMap.get(each);
            if(u == null)
            {
                EmpEmailIds.add(UsersProcess.get(each).EMAIL_ADDRESS+'%');
            }
            system.debug('Emp Email Ids: '+EmpEmailIds);
        }   */ 
        
        //get user details based on email if employee Id not found in salesforce
     /*   if(EmpEmailIds.size() != 0){
            system.debug('Getting values based on Email:::' +EmpEmailIds );
            for(user u:[select id,LastName, FirstName,Title, email, Hire_Date__c , Employee_Office_Location__c,
                        ManagerId,Employee_Department__c,Employee_ID__c from User where Email like :EmpEmailIds
                        and type__C != 'System User (Integration)'])
        	{
            	UsersMap.put(u.email, u);
        	}
            
            System.debug('Users Map ::'+UsersMap);
        }*/
        
		if(EmployeeIds.size() != 0 || EmpEmailIds.size() != 0)
        {			
            system.debug('Line 43 :::::: ');
            system.debug(EmployeeIds);
            system.debug('Starting update :::::::::::');
			for(String empId : EmployeeIds)
            {	
                System.debug('Employee ID: '+empId);
                String exceptionMessage = '';
                String exceptionMessage1 = '';
                User u = UsersMap.get(empId);
				if(u == null)
                {   
                  //  u = UsersMap.get(UsersProcess.get(empId).EMAIL_ADDRESS);
                   // system.debug('uuuuu'+u);
                   // If(u == null){                      
                     //   u = UsersMap.get(UsersProcess.get(empId).EMAIL_ADDRESS + '.invalid');
                   //  u = UsersMap.get(UsersProcess.get(empId).EMAIL_ADDRESS);
                 //  exceptionMessage += 'Employee Details Not Found in Salesforce';
                        
                        system.debug('UsersProcess.get(empId).EMAIL_ADDRESS'+UsersProcess.get(empId).EMAIL_ADDRESS+'updateuserempid'+updateuserempid);
                         userExceptionList1.put(UsersProcess.get(empId).EMAIL_ADDRESS,updateuserempid);
                        exceptionMessage1 += 'Employee Details Not Found in Salesforce';
                    
                    
                        
                        
                        
                    //}
                   // system.debug('uuuuu'+u);
                    //if still user details not found.. then write to exception object
                 /*   If(u == null){                        
                        userExceptionList.put(empId+'Employee Email Id',UsersProcess.get(empId).EMAIL_ADDRESS);
                        exceptionMessage += 'Employee Details Not Found in Salesforce';
                    }*/
                    
                 /*   if(u !=null){
                        System.debug('Emp Email ID 1'+UsersProcess.get(empId).EMAIL_ADDRESS);
                    	//upadate empId in salesfroce
                    	u.Employee_ID__c = empId;
                    	System.debug('Emp Email ID 2'+UsersProcess.get(empId).EMAIL_ADDRESS);
                    	System.debug('User Object :' +u);
                    	// write to exception object
                   		userExceptionList.put(empId+'Employee Email Id',UsersProcess.get(empId).EMAIL_ADDRESS);
                    	exceptionMessage += ': No Emp Id :';
                    }*/
                }
                if(u != null)
                {                    
                    system.debug('EMP ID:::::' +empId );
                   // userExceptionList.put(empId+'Employee Email Id', UsersProcess.get(empId).EMAIL_ADDRESS);                    
                    
				//	u.FirstName = UsersProcess.get(empId).FIRST_NAME;
                //	u.LastName = UsersProcess.get(empId).LAST_NAME;
                	//u.Email = UsersProcess.get(empId).EMAIL_ADDRESS;
                	u.Phone = UsersProcess.get(empId).WORK_PHONE;
                    u.Title = UsersProcess.get(empId).JOB_TITLE;
                    
                    if(UsersProcess.get(empId).EFFECTIVE_DATE_TO != null)
                	{
                    	u.Termination_Date__c = Date.valueOf(UsersProcess.get(empId).EFFECTIVE_DATE_TO);
                	}
                /*	else
                	{
                   		// write to exception object
                   		userExceptionList.put('EFFECTIVE_DATE_TO',UsersProcess.get(empId).EFFECTIVE_DATE_TO);
                    	exceptionMessage += ': No Termination Date :';
                	}*/
                    
					if(UsersProcess.get(empId).LATEST_REJOIN_DATE != null)
                	{
                    	u.Latest_Rejoining_Date__c = Date.valueOf(UsersProcess.get(empId).LATEST_REJOIN_DATE);
                	}
                /*	else
                	{
                   		// write to exception object
                   		userExceptionList.put(empId+'LATEST_REJOIN_DATE',UsersProcess.get(empId).LATEST_REJOIN_DATE);
                    	exceptionMessage += ': Invalid Latest Rejoin Date :';
                	}*/
                
                	if(UsersProcess.get(empId).EFFECTIVE_DATE_FROM != null)
                	{
                    	u.Hire_Date__c = Date.valueOf(UsersProcess.get(empId).EFFECTIVE_DATE_FROM);
                	}
              /*  	else
                	{
                   		// write to exception object
                   		userExceptionList.put(empId+'EFFECTIVE_DATE_FROM',UsersProcess.get(empId).EFFECTIVE_DATE_FROM);
                    	exceptionMessage += ': Invalid Hire Date :';
                	} */
                
					//u.Title = UsersProcess.get(empId).JOB_TITLE;			
					if(VerifyPicklistValues('User', 'Employee_Department__c' , 
                                        UsersProcess.get(empId).DEPT_EXPENSE_CODE 
                                        + ' - ' + UsersProcess.get(empId).DEPT_NAME ))
                	{				
						u.Employee_Department__c = UsersProcess.get(empId).DEPT_EXPENSE_CODE
                        	+ ' - ' + UsersProcess.get(empId).DEPT_NAME;			
					}
					else
                    {
                    	// write to exception object
                    	system.debug(': Dept Name not Found :');
						userExceptionList.put(empId+'Employee_Department__c', UsersProcess.get(empId).DEPT_EXPENSE_CODE 
                                       	 + ' - ' + UsersProcess.get(empId).DEPT_NAME);
                    	exceptionMessage += ' : Dept Name not Found : ';
					}
                
                	if(VerifyPicklistValues('User', 'Employee_Office_Location__c', UsersProcess.get(empId).REGION 
                                        	+' - '+ UsersProcess.get(empId).LOCATION )) 
                	{
                    	u.Employee_Office_Location__c = UsersProcess.get(empId).REGION + ' - ' 
                            + UsersProcess.get(empId).LOCATION;
                	}
                
                	else
                	{
                    	// write to exception object
                    	system.debug(': Location Not Found :');
                    	userExceptionList.put(empId+'LOCATION', UsersProcess.get(empId).REGION 
                                              + ' - ' + UsersProcess.get(empId).LOCATION);                   
                    	exceptionMessage += ' : Location Not Found : ';
                	}
				
                    if(!SupervisorUsers.isEmpty() && SupervisorUsers.get(UsersProcess.get(empId).SUPERVISOR_ID) != null){
                        if (SupervisorUsers.get(UsersProcess.get(empId).SUPERVISOR_ID).Employee_ID__c != u.Manager.Employee_ID__c){
                            if (u.Profile.Name == 'Intranet Basic Profile')
                                u.ManagerId = SupervisorUsers.get(UsersProcess.get(empId).SUPERVISOR_ID).Id;
                            else{
                                // write to exception object
                                userExceptionList.put(empId+'SUPERVISOR_ID', UsersProcess.get(empId).SUPERVISOR_ID);
                                exceptionMessage += ' : Change Supervisor on Non Intranet Basic Profile User : ';
                                system.debug(': Request to change Supervisor on Non Intranet Basic Profile User : ');
                            }    
                        }
                        
                    }
                    else{
                        // write to exception object
                        userExceptionList.put(empId+'SUPERVISOR_ID', UsersProcess.get(empId).SUPERVISOR_ID);
                        exceptionMessage += ' : Invalid or No Supervisor Id : ';
                        system.debug(': Invalid or No Supervisor Id : ');
                    }
                   		
				
					ALlUsers.add(u);
                	
                }   
                System.debug('User Exceptions:::  '+userExceptions);
                system.debug('exceptionMessage'+exceptionMessage);
                if( exceptionMessage!='' )
                {
                userExceptions.put(empId, userExceptionList);
                    system.debug('userExceptions'+userExceptions);
                userExceptionMessages.put(empId,exceptionMessage);
                    system.debug('userExceptionMessages'+userExceptionMessages);
                }
              //  userExceptions1.put(empId, userExceptionList1);
               // userExceptionMessages1.put(empId,exceptionMessage1);
			}      
            
		}
        // Handle if both emp ids and emp email id are not found in sfdc -- in few scenarios 
        else{
            
        }
        
       
            system.debug('ALlUsers'+ALlUsers);
            if(ALlUsers.size() > 0){
                update ALlUsers;
            }
        	 system.debug('userExceptions.size'+userExceptions.size());
            if(!userExceptions.isEmpty())
            {
                RecordUserException(userExceptions, userExceptionMessages);
                //return 'Exception in user Data';
            }
            system.debug('RecordUserEMPException1'+userExceptionList1);
            if(!userExceptionList1.isEmpty())
            {
                RecordUserEMPException1(userExceptionList1);
                //return 'Exception in user Data';
            }
            return 'success';
        }
        catch(exception e){
            if(!string.isBlank(reqBodyString))
            {
                system.debug('eeeee'+e.getMessage());
               return 'success'; 
                
            }
            else
            {
                system.debug('eeeee'+e.getMessage());
               return 'success'; 
            }
            
        	
        }
    }
    
    public static boolean VerifyPicklistValues(String objName, String fieldName, String keyWord){
        
        List<String> deptPle = new List<String>();		
		Schema.SObjectType s = Schema.getGlobalDescribe().get(objName);
		Schema.DescribeSObjectResult r = s.getDescribe();
		Map<String,Schema.SObjectField> fields = r.fields.getMap();
		Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
		List<Schema.PicklistEntry> empDeptPickListValues = fieldResult.getPicklistValues();
		
        for( Schema.PicklistEntry pickListVal : empDeptPickListValues) {            
            deptPle.add(pickListVal.getValue());
        } 
        //system.debug('return Value from Verify Picklist ::::::: ' + deptPle.indexOf(keyWord) != -1);
        if(deptPle.indexOf(keyWord) != -1)
        {
            system.debug('Key Value found in Verify Picklist ::::::: ' + keyWord);
            return true;
        }
        system.debug('Key Value NOT found in Verify Picklist ::::::: ' + keyWord);
        return false;
    }
    
    
    public static void RecordUserException(Map<String,Map<String,String>> userMap, Map<String,String> exceptionMessage){
        
        List<SmartSheet_Exceptions__c> sseList = new List<SmartSheet_Exceptions__c>();
        
        Id recordTypeId = Schema.SObjectType.SmartSheet_Exceptions__c.getRecordTypeInfosByDeveloperName()
                      .get('User_Update_Exception').getRecordTypeId();
        system.debug('Record Type ID  :::::: ' + recordTypeId);
        
        for(String EmployeeId : userMap.keySet()){
            Map<String, String> userDetails = userMap.get(EmployeeId);
            SmartSheet_Exceptions__c sse = new SmartSheet_Exceptions__c(RecordTypeId = recordTypeId);
            sse.Employee_Id__c = EmployeeId;            
            sse.Employee_Email_Id__c = userDetails.get(EmployeeId+'Employee Email Id');            
            if(userDetails.containsKey(EmployeeId+'EFFECTIVE_DATE_FROM')){
            	sse.Hire_Date__c = Date.valueOf(userDetails.get('EFFECTIVE_DATE_FROM'));    
            }
            sse.Department__c = userDetails.get(EmployeeId+'Employee_Department__c');            
            sse.Physical_Location__c = userDetails.get(EmployeeId+'LOCATION');
            
            sse.Supervisor_Id__c = userDetails.get(EmployeeId+'SUPERVISOR_ID');
            sse.Error_Message__c = exceptionMessage.get(EmployeeId);            
            if(userDetails.containsKey(EmployeeId+'LATEST_REJOIN_DATE')){
            	sse.Latest_Rejoin_Date__c = Date.valueOf(userDetails.get('LATEST_REJOIN_DATE')); 
            }            
            system.debug('LATEST_REJOIN_DATE : : Issue ');
            sseList.add(sse);
        }
		system.debug('sseList.size()'+sseList.size());
		if(sseList.size() > 0)
        {
            system.debug('sseList'+sseList);
            insert sseList;
            system.debug('sseList'+sseList);
        }        
    }
    
    public static void RecordUserEMPException1(Map<String,Map<String,processhremployeedataparserctrl.Data>> userMap){
        List<SmartSheet_Exceptions__c> sseList = new List<SmartSheet_Exceptions__c>();
        system.debug('userMap'+userMap);
        Id recordTypeId = Schema.SObjectType.SmartSheet_Exceptions__c.getRecordTypeInfosByDeveloperName()
                      .get('User_Update_Exception').getRecordTypeId();
        for(String EmployeeId : userMap.keySet()){
            system.debug('EmployeeId'+EmployeeId);
        //    Map<String, String> userDetails = userMap.get(EmployeeId);
            SmartSheet_Exceptions__c sse = new SmartSheet_Exceptions__c(RecordTypeId = recordTypeId);
            sse.Employee_Id__c = usermap.get(EmployeeId).get(EmployeeId).EMPLOYEE_NUMBER;
            sse.Employee_Email_Id__c = EmployeeId;//  userMap.get(EmployeeId).EMAIL_ADDRESS;
           sse.Department__c = userMap.get(EmployeeId).get(EmployeeId).DEPT_NAME;            
            sse.Physical_Location__c = userMap.get(EmployeeId).get(EmployeeId).LOCATION;
            sse.Supervisor_Id__c = userMap.get(EmployeeId).get(EmployeeId).SUPERVISOR_ID;
            sse.Error_Message__c = 'Employee Details Not Found in Salesforce';//userMap.get(EmployeeId);            
            sse.Latest_Rejoin_Date__c = Date.valueOf(userMap.get(EmployeeId).get(EmployeeId).LATEST_REJOIN_DATE); 
            sse.Hire_Date__c = Date.valueOf(userMap.get(EmployeeId).get(EmployeeId).EFFECTIVE_DATE_FROM);
            sseList.add(sse);
          //system.debug('sse.Employee_Id__c'+sse.Employee_Id__c+'sse.Employee_Id__c'+sse.Employee_Email_Id__c);        
        }
              
        if(sseList.size() > 0)
        {
            
            insert sseList;
            system.debug('sseList'+sseList);
        }
        
    }
    
    
}