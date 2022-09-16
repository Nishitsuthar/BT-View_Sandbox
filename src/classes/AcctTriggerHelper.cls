public class AcctTriggerHelper
{
    // v.2 Adds code to handle inheritance of Account Tier
    
    static public List<Account> updateChildTree(List<Account> parents, boolean isDelete)
    {
        List<Account> childTree = new List<Account>();
        Map<Id, Account> parentMap = new Map<Id, Account>();
        List<Account> children = new List<Account>();
        boolean hasChildren = true;
        Integer level = 0;
        //
        // Create the Parent Map
        //
        for(Account parent: parents)
        {
            parentMap.put(parent.Id, parent);
        }
        while (hasChildren)
        {
            // v2 - Added Account Tier to selected fields
            children = [SELECT Id, Name, ParentId, Reporting_Parent__c, Account_Tier__c from Account where parentId in :parentMap.keyset()];
            if (children.size() > 0)
            {
                for (Account child : children)
                {       
                    // v.2 - Updates Account Tier from parent
                    child.Account_Tier__c = parentMap.get(child.parentId).Account_Tier__c;
                    if (!isDelete)
                    {
                        if (parentMap.get(child.parentId).Reporting_Parent__c != null)
                        {
                            child.Reporting_Parent__c = parentMap.get(child.parentId).Reporting_Parent__c;
                        }
                        else
                        {
                            child.Reporting_Parent__c = child.parentId;
                        }
                    }
                    else
                    {
                        child.Reporting_Parent__c = null; // Child has become new top level
                    }
                }
                isDelete = false;
                childTree.addAll(children);
                //
                // Create new parent map from children
                //
                parentMap.clear();
                for (Account child: children)
                {
                    parentMap.put(child.Id, child);
                }
            }
            else
            {
                hasChildren = false;
            }
        }                       
        return childTree;
    }
}