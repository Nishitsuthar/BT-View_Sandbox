@isTest(seeAllData = true)
public class CaseTriggerTest{ 
static testMethod void TestCase(){ 
    Id OppRecTypId = [select id from RecordType where name='Opportunity'].id;
    Id locRecTypId = [select id from RecordType where name='location'].id;
    Id CaseRecTypId = [select id from RecordType where name='Support Case'].id;
    Id AccId = [select Id from Account limit 1].id;
    Id CampId = [select Id from Campaign limit 1].id;
    Id ContId = [select Id from Contact limit 1].id;
    
    Contact con = new Contact(LastName ='test', AccountId = AccId );
    insert con;
    
    Opportunity opp1 = new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp8',AccountId=AccId ,StageName='Discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Install_Status__c='Service',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5));
    insert opp1;
    
    //SVMXC__Site__c loc1 = new SVMXC__Site__c(Name ='Testloc8',SVMXC__Account__c=AccId,Location_Status__c='Service',SVMXC__Street__c='Test street',SVMXC__City__c='Sunnyvale',SVMXC__Country__c='United States',SVMXC__Zip__c='95132');
    //insert loc1;
    
    Opportunity opp2 = new Opportunity(RecordTypeId=OppRecTypId,Name ='TestOpp9',AccountId=AccId ,StageName='Discovery',CampaignId=CampId,Basis_of_Design__c='View',Support_Region__c='Atlanta/Carolinas',Opportunity_Type__c='Opportunity',Construction_Type__c='Renovation',Market_Segment__c='Commercial',Market_Sub_Segment__c='Owner',Install_Type__c='Sales',Install_Status__c='Service',Project_City__c='Sunnyvale',CloseDate=Date.today().addDays(5));
    insert opp2;
    
    List<Case> cs = new List<Case>();
               cs.Add(New Case(RecordTypeId=CaseRecTypId,Opportunity__c=opp1.Id,Contact = con, Subject='test', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test', Origin= 'Email'));
               cs.Add(New Case(RecordTypeId=CaseRecTypId,Opportunity__c=opp1.Id,Contact= con, Subject='test1', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test1', Origin= 'Email'));
               cs.Add(New Case(RecordTypeId=CaseRecTypId,Opportunity__c=opp1.Id,Contact= con, Subject='test2', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test2', Origin= 'Email'));
               cs.Add(New Case(RecordTypeId=CaseRecTypId,Opportunity__c=opp1.Id,Contact= con, Subject='test3', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test3', Origin= 'Email'));
                
               //cs.Add(New Case(RecordTypeId=CaseRecTypId,SVMXC__Site__c=Loc1.Id,Contact= con,Subject='test4', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test4', Origin= 'Email'));  
              
                cs.Add(New Case(RecordTypeId=CaseRecTypId,Contact= con,Subject='test4', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test4', Origin= 'Email'));  
              
               cs.Add(New Case(RecordTypeId='0120L0000009730',Opportunity__c=opp1.Id,Contact= con, Subject='test3', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test3', Origin= 'Email'));  //Added by ENP
               cs.Add(New Case(RecordTypeId='012E0000000seQ0',Opportunity__c=opp1.Id,Contact= con, Subject='test3', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test3', Origin= 'Email'));  //Added by ENP 
               cs.Add(New Case(RecordTypeId='012E0000000oR5Z',Opportunity__c=opp1.Id,Contact= con, Subject='test3', Status ='New', Est_Cmpl_Date__c= Date.today().addDays(5), Description = 'Test3', Origin= 'Email'));  //Added by ENP
    insert cs;
    for(Case c : cs){
        c.Opportunity__c = opp2.Id;
       // c.SVMXC__Site__c = loc1.Id;
    }
    update cs;
    AggregateResult[] groupedResults = [SELECT COUNT(Id), Opportunity__c FROM Case where Opportunity__c =:opp1.id GROUP BY Opportunity__c];
   // AggregateResult[] groupedResults2 = [SELECT COUNT(Id), SVMXC__Site__c FROM Case where SVMXC__Site__c =:loc1.id GROUP BY SVMXC__Site__c];
    delete cs;
}
}