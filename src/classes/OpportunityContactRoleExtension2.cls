public class OpportunityContactRoleExtension2 {
 public List<OpportunityContactRole> ContactRoles{get;set;}
    
    public OpportunityContactRoleExtension2(
        ApexPages.StandardController controller
    ){  
        /*
            Query the Database to retrieve all
            the Contact Roles of the Opportunity
            in Context
            
            This will help retrieve the Current 
            Opportunity:
            Opportunity currentOppty = 
                (Opportunity)controller.getRecord();
            
        */
        id caseId=((Case)controller.getRecord()).Id;
        Id oppId = [select Id, Opportunity__c from Case where Id=:caseId].Opportunity__c;
        
        ContactRoles = 
            [
                SELECT 
                    Contact.Name,
                    Contact.Email,
                    Role,
                    Contact.Phone
                FROM   
                    OpportunityContactRole
                WHERE  
                    OpportunityId = :oppId
               /* AND Role in('Glazing Contractor', 'Low Voltage Electrician', 'Electrician', 'General Contractor')*/
            ];
            System.debug(ContactRoles.size());
                }
}