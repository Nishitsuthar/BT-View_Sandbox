public class UpdateEmployeeRecord {
    
    @AuraEnabled
   
    public static String updateEmployeeDetails(String SSRecordId){
        string recordId = SSRecordId;
        system.debug('recordId:: '+recordId );
        String errorMessage = '';
    
       SmartSheet_Exceptions__c SSE= [select Department__c, Employee_Id__c, Error_Message__c, 
        Hire_Date__c,   Latest_Rejoin_Date__c,Status__c,Physical_Location__c, Supervisor_Id__c, Employee_Email_Id__c 
        from SmartSheet_Exceptions__c where Id=:recordId and Status__c!='Completed' ];
        
        if(SSE != null){
            // if employee does not exist in salesforce
            if(!(SSE.Error_Message__c == null)){
            if(SSE.Error_Message__c.contains('Employee Details Not Found in Salesforce')){
                //Need Clarification on this
                return 'Employee Details not found in sfdc';
            }
            }
            
                        
            if(SSE.Employee_Id__c != null || SSE.Employee_Id__c != ''){
                
                User u = [select id,LastName, FirstName,Title, email, Hire_Date__c , Employee_Office_Location__c,ManagerId,Employee_Department__c,Employee_ID__c from User where Employee_ID__c =: SSE.Employee_Id__c ];
                system.debug('Employee Detials are :: ' +u);
                if(u == null) {
                    system.debug('Getting employee details with emp email id::');
                    u = [select id,LastName, FirstName,Title, email, Hire_Date__c , Employee_Office_Location__c,ManagerId,Employee_Department__c,Employee_ID__c from User where Email =: SSE.Employee_Email_Id__c];
                }
                
                if(!(SSE.Department__c == null || SSE.Department__c == '' )){
                if(VerifyPicklistValues('User', 'Employee_Department__c', SSE.Department__c)){
                    u.Employee_Department__c = SSE.Department__c;
                    SSE.Department__c = '';
                }
                else {
                    errorMessage += ' :: Dept Name not Found :: ';
                }
                }
                system.debug('Checking Location :: ' +SSE.Physical_Location__c);
                String strValue = SSE.Physical_Location__c;
                if(!(strValue == null || strValue == '' )){
                if(VerifyPicklistValues('User', 'Employee_Office_Location__c', SSE.Physical_Location__c)) {
                    u.Employee_Office_Location__c = SSE.Physical_Location__c;
                    SSE.Physical_Location__c = '';
                }
                
                else {
                    errorMessage += ' :: Location Not Found :: ';
                }
                }
                system.debug('Supervisor ID :: ' + SSE.Supervisor_Id__c);
                if(!(SSE.Supervisor_Id__c == null || SSE.Supervisor_Id__c == '')) {
                    User supUser = [select id,Employee_ID__c from User where Employee_ID__c =: SSE.Supervisor_Id__c];
                    if(supUser != null) {
                        u.ManagerId = supUser.Employee_ID__c;
                        SSE.Supervisor_Id__c = '';
                    }
                    
                    else {
                        errorMessage += ':: Supervisor Id not Found :: ';
                    }
                }
                system.debug('Hire Date :: ' +(SSE.Hire_Date__c));
                if(!(SSE.Hire_Date__c == null)){
                    u.Hire_Date__c = SSE.Hire_Date__c;
                    SSE.Hire_Date__c = null;
                    
                }             
                
                if(!(SSE.Latest_Rejoin_Date__c == null)){
                    u.Latest_Rejoining_Date__c = SSE.Latest_Rejoin_Date__c;
                    SSE.Latest_Rejoin_Date__c = null;
                }
                
                system.debug('Updating Employee Details :: '+u);
                update u;
            }
            if(errorMessage == '') {
                SSE.Status__c = 'Completed';
            }
            else{
                SSE.Status__c = 'Failed';
            }
            SSE.Error_Message__c = errorMessage;
            update SSE;
        
        }
        
        return 'Success';
        
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
}