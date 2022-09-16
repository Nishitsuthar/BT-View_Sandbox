public with sharing class VG_NetworkDataAccess
{
    public static List<Network> getDetailById(List<Id> networkIds)
    {
        //if (!test.isRunningTest()) {
            return [Select urlPathPrefix from Network where Id IN :networkIds];
        //}
        //return null;
    }


}