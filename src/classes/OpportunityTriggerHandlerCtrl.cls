/*
 *  Updated Date         Developer       Project             Tracking Id                         Requirement
 *  22-Feb-2021			Srikanth		OpptyDesignWinUpdates OpptyDesignWinUpdates				when the opportunity moves to DW, update Design_Win_Stickiness__c and Likelihood_to_Build__c to High
 */
public class OpportunityTriggerHandlerCtrl {
    public Static Boolean isUpdateDWSSWRecords = false;
    public static void beforeUpdate(Map<Id,Opportunity> newMap ,Map<Id,Opportunity> oldMap){
        Map<String,Set<String>> historyMap = getOpportunityHistory(newMap.KeySet());
        Map<String,List<String>> multiMap = new Map<String,List<String>>();
        List<String> validOppIds = new List<String>();
        for(Opportunity oppRec: newMap.values()){
            Opportunity oldOpportunity = oldMap.get(oppRec.id);
            Set<String> stageValues = historyMap.size()>0 ? historyMap.get(oppRec.Id) : new Set<String>();
            system.debug('First_Request_Date_IGU__c'+oppRec.First_Request_Date_IGU__c+'ss'+oldOpportunity.First_Request_Date_IGU__c+'qq'+oppRec.StageName+'ss'+oldOpportunity.StageName);
            if((Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosById().get(oppRec.RecordTypeId).getName() == 'MOU Single Project Opportunity')
               || (Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosById().get(oppRec.RecordTypeId).getName() == 'MOU Multi Project Opportunity')){
                   if(oppRec.StageName != oldOpportunity.StageName){
                       system.debug('stage'  +stageValues);
                       if(!stageValues.contains(oppRec.StageName) || (stageValues.size() == 0)){
                           if(oppRec.StageName == 'Closed: Won'){
                               oppRec.Design_Win_Date__c = Date.Today(); 
                               if(oppRec.Amount != Null)oppRec.Design_Win_Amount__c = oppRec.Amount; 
                               if(oppRec.First_Request_Date_IGU__c!= Null)oppRec.Original_First_Request_Date_IGU__c = oppRec.First_Request_Date_IGU__c; 
                               if(oppRec.Project_Glass_Quantity__c!= Null)oppRec.Design_Win_SF__c = oppRec.Project_Glass_Quantity__c;
                               oppRec.Design_Win_Stickiness__c = 'High';//OpptyDesignWinUpdates
                               oppRec.Likelihood_to_Build__c = 'High';//OpptyDesignWinUpdates
                           }
                           if(oppRec.StageName == 'Closed: Lost'){
                               oppRec.Design_Lost_Date__c = system.today();
                           } 
                           system.debug('oppRec.RecordTypeId'+oppRec.RecordTypeId+oppRec.StageName);
                           system.debug('line 31'+Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosById().get(oppRec.RecordTypeId).getName());
                           if(Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosById().get(oppRec.RecordTypeId).getName() == 'MOU Multi Project Opportunity'){
                               if(multiMap.containsKey(oppRec.StageName)){
                                   List<String> oppIds = multiMap.get(oppRec.StageName);
                                   oppIds.add(oppRec.Id);
                                   multiMap.put(oppRec.StageName, oppIds); 
                                   
                               }else{
                                   multiMap.put(oppRec.StageName, new List<String>{oppRec.Id});  
                               }
                           }
                       }
                   }
               }
            
            if((oppRec.First_Request_Date_IGU__c != oldOpportunity.First_Request_Date_IGU__c) 
               || (oppRec.First_Request_Date_CSS__c  !=oldOpportunity.First_Request_Date_CSS__c)){
                   validOppIds.add(oppRec.Id);
               }
            if(oppRec.Ground_Breaking_Confirmed__c == 'Confirmed' && (oppRec.Ground_Breaking_Confirmed__c != oldOpportunity.Ground_Breaking_Confirmed__c)){
                oppRec.Ground_Breaking_Confirmed_Date__c = system.today();
            }
            if((oppRec.IGU_P_O__c == 100.00) && (oldOpportunity.IGU_P_O__c != oppRec.IGU_P_O__c)){
                oppRec.Forecast_Risk_IGU__c = 'None (Order Booked)';            
            }
            if((oppRec.BOS_P_O__c == 100.00) && (oldOpportunity.BOS_P_O__c != oppRec.BOS_P_O__c)){
                oppRec.Forecast_Risk_CSS__c = 'None (Order Booked)';            
            }
            if((oppRec.IGU_P_O__c == 100.00 )&&(oppRec.BOS_P_O__c == 100.00) && ((oldOpportunity.BOS_P_O__c != oppRec.BOS_P_O__c) || (oldOpportunity.IGU_P_O__c != oppRec.IGU_P_O__c))){
                oppRec.Key_Project_HQ__c = False;            
            }
        }
        
        if(multiMap.size()>0){
            List<Opportunity> childOppRecds = new List<Opportunity>();
            Map<String,List<Opportunity>> childOppsToUpdate = updateChildOpps(multiMap);
            if(childOppsToUpdate.size()>0){
                for(String recds:childOppsToUpdate.keySet()){
                    childOppRecds.addAll(childOppsToUpdate.get(recds));
                }
                system.debug('childOppRecds');
                processChildRecords(JSON.serialize(childOppRecds));
                //Database.update(childOppRecds,false);
            }
        }
        if(validOppIds.size()>0){
            Map<string,Map<String,List<Order_Entry_Release__c>>> orderEntryDetails = checkOrderEntryRecds(validOppIds);
            if(orderEntryDetails.size()>0){
                for(String recId:validOppIds){
                    Map<String,List<Order_Entry_Release__c>> ordRec = orderEntryDetails.containsKey(recId) ? orderEntryDetails.get(recId) : new Map<String,List<Order_Entry_Release__c>>();
                    system.debug('ordRec'+ordRec);
                    if(ordRec.size()>0){
                        if(!ordRec.containsKey('IGU') //&& !(ordRec.get('IGU').size()>0)
                          ){
                            system.debug('line 80');
                            newMap.get(recId).Scheduled_Ship_Date_IGU__c = newMap.get(recId).First_Request_Date_IGU__c; 
                        }
                        system.debug('ordRec.containsKey'+ordRec.containsKey('Control_Hardware'));
                                    // system.debug('ordRec.get'+ordRec.get('Control_Hardware').size());
                        if(!ordRec.containsKey('Control Hardware')// && !(ordRec.get('Control_Hardware').size()>0)
                          ){
                            system.debug('line 85');
                            newMap.get(recId).Scheduled_Ship_Date_CSS__c = newMap.get(recId).First_Request_Date_CSS__c; 
                        }
                        
                    }
                }
            }
            
            else{
                system.debug('line 94');
                for(String recId:validOppIds){
                    newMap.get(recId).Scheduled_Ship_Date_IGU__c = newMap.get(recId).First_Request_Date_IGU__c;
                    newMap.get(recId).Scheduled_Ship_Date_CSS__c = newMap.get(recId).First_Request_Date_CSS__c;
                }
            }
            //  system.debug('newMap.get(recId).Scheduled_Ship_Date_IGU__c'+newMap.get(recId).Scheduled_Ship_Date_IGU__c);
        }
    }
    
    @future
    public static void processChildRecords(String records)
    {   
        List<Opportunity> deserializedOpportunitys = 
            (List<Opportunity>)JSON.deserialize(records, List<Opportunity>.class);
        DataBase.update(deserializedOpportunitys,false);
    }
    
    public static Map<String,List<Opportunity>> updateChildOpps(Map<String,List<String>> oppMap){
        Map<String,List<Opportunity>> oppWithChilOppMap = new Map<String,List<Opportunity>>();
        List<Id> oppIds = new List<Id>();
        for(String s:oppMap.KeySet()){
            oppIds.addAll(oppMap.get(s));
        }
        List<Opportunity> MultiOptyListwitChilds = [SELECT Id, MOU_Opportunity__c,Name,RecordTypeId, StageName, Design_Win_Date__c, 
                                                    Design_Lost_Date__c,Design_Win_Amount__c, Amount,Original_First_Request_Date_IGU__c,
                                                    First_Request_Date_IGU__c,Design_Win_SF__c,Project_Glass_Quantity__c 
                                                    FROM Opportunity 
                                                    WHERE MOU_Opportunity__c IN : oppIds 
                                                    AND RecordType.Name = 'Projects'];
        if(MultiOptyListwitChilds.size()>0){
            for(Opportunity rec:MultiOptyListwitChilds){
                if(oppWithChilOppMap.containsKey(rec.MOU_Opportunity__c)){
                    List<Opportunity> oppLst = oppWithChilOppMap.get(rec.MOU_Opportunity__c);
                    oppLst.add(rec);
                    oppWithChilOppMap.put(rec.MOU_Opportunity__c, oppLst);
                }else{
                    oppWithChilOppMap.put(rec.MOU_Opportunity__c, new List<Opportunity>{rec});
                }
            }
            for(String stageVal:oppMap.keySet()){
                for(String oppId:oppMap.get(stageVal)){
                    if(oppWithChilOppMap.containsKey(oppId)){
                        for(opportunity oppRec:oppWithChilOppMap.get(oppId)){
                            if(stageVal == 'Closed: Won'){
                                system.debug('won');
                                oppRec.Design_Win_Date__c = Date.Today();
                                if(oppRec.Amount != Null)oppRec.Design_Win_Amount__c = oppRec.Amount;
                                if(oppRec.First_Request_Date_IGU__c!= Null)oppRec.Original_First_Request_Date_IGU__c = oppRec.First_Request_Date_IGU__c;
                                if(oppRec.Project_Glass_Quantity__c!= Null)oppRec.Design_Win_SF__c = oppRec.Project_Glass_Quantity__c;
                            }
                            if(stageVal == 'Closed: Lost'){
                                system.debug('won');
                                oppRec.Design_Lost_Date__c = system.today();
                            }
                        }
                    }
                }
            }
        }
        return oppWithChilOppMap;
    }
    
    
    public static Map<String,Set<String>> getOpportunityHistory(Set<Id> oppIds){
        Map<String,Set<String>> oppStageMap = new Map<String,Set<String>>();
        
        List<OpportunityFieldHistory> oppfieldHisList=[SELECT Id, IsDeleted, OpportunityId, CreatedById, CreatedDate, 
                                                       Field,OldValue, NewValue 
                                                       FROM OpportunityFieldHistory 
                                                       WHERE OpportunityId IN: oppIds 
                                                       AND Field='StageName']; 
        system.debug('oppfieldHisList'+oppfieldHisList);
        for(OpportunityFieldHistory opphist: oppfieldHisList){
            if(oppStageMap.containsKey(opphist.OpportunityId)){   
                Set<String> stageset2 =  oppStageMap.get(opphist.OpportunityId);
                stageset2.add(String.valueOf(opphist.NewValue));                   
                oppStageMap.put(opphist.OpportunityId,stageset2);
            }else{ 
                oppStageMap.put(opphist.OpportunityId,new Set<String>{String.valueOf(opphist.NewValue)});
            }
        }
        system.debug('oppStageMap'+oppStageMap);
        return oppStageMap;
    }
    
    public static Map<string,Map<String,List<Order_Entry_Release__c>>> checkOrderEntryRecds(List<String> oppIds){
        Map<string,Map<String,List<Order_Entry_Release__c>>> ordrEntryReleaseMap = new Map<string,Map<String,List<Order_Entry_Release__c>>>();
        List<Order_Entry_Release__c> orderEntryList = [SELECT Id ,Opportunity__c,RecordType.Name
                                                       FROM Order_Entry_Release__c  
                                                       WHERE RecordType.Name IN ('IGU','Control Hardware') 
                                                       AND Status__c != 'Cancelled'
                                                       AND Opportunity__c IN :oppIds 
                                                       AND Scheduled_Ship_Date__c !=NULL 
                                                        AND Order_Type__c='Standard'];
        system.debug('orderEntryList'+orderEntryList);
        if(orderEntryList.size()>0){
            for(Order_Entry_Release__c rec :orderEntryList){
                if(ordrEntryReleaseMap.containsKey(rec.Opportunity__c)){
                    Map<String,List<Order_Entry_Release__c>> orrLstRecMap = ordrEntryReleaseMap.get(rec.Opportunity__c);
                    if(orrLstRecMap.containsKey(rec.RecordType.Name)){
                        List<Order_Entry_Release__c> oerLst = orrLstRecMap.get(rec.RecordType.Name);
                        oerLst.add(rec);
                    }else{
                        orrLstRecMap.put(rec.RecordType.Name, new List<Order_Entry_Release__c>{rec});
                    }
                    ordrEntryReleaseMap.put(rec.Opportunity__c,orrLstRecMap);
                }else{
                    Map<String,List<Order_Entry_Release__c>> ordrOppMap = new Map<String,List<Order_Entry_Release__c>>();
                    ordrOppMap.put(rec.RecordType.Name,new List<Order_Entry_Release__c>{rec}); 
                    ordrEntryReleaseMap.put(rec.Opportunity__c,ordrOppMap);
                }
            }
        }
        system.debug('ordrEntryReleaseMap'+ordrEntryReleaseMap);
        return ordrEntryReleaseMap;
    }
    
}