public class opportunityContactRolePicklist {	
 @Auraenabled
  public static List<OpportunityContactRole> getOpportunityContactRoles(Id oppId){
      system.debug('--in controller method oppId is'+oppId);
     
      //system.debug('--'+[SELECT ContactId,Role, Id,OpportunityId FROM OpportunityContactRole where OpportunityId =: oppId]);
           return ([SELECT Contact.Name,ContactId,Role, Id,OpportunityId FROM OpportunityContactRole where OpportunityId =: oppId]);
  }
}