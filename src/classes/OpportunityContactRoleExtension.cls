public class OpportunityContactRoleExtension{

    /*
        A List Type Collection that will hold
        all the Opportuniy Contact Roles
    */
    public List<OpportunityContactRole> ContactRoles{
        get;
        set;
    }
    
    public OpportunityContactRoleExtension(
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
        ContactRoles = 
            [
                SELECT 
                    Contact.Name,
                    Contact.Email,
                    Role
                FROM   
                    OpportunityContactRole
                WHERE  
                    OpportunityId = :((Opportunity)controller.getRecord()).Id
                AND Role in('Glazing Contractor', 'Low Voltage Electrician', 'Electrician', 'General Contractor')
            ];
            System.debug(ContactRoles.size());
                }
}