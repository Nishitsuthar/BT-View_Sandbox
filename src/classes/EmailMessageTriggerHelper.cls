public class EmailMessageTriggerHelper{
    
    //this methd is called from the trigger EmailMessageTrigger.
    /*if parentid type = EmailMessage and emailmessage.parentid type = case, clone the attachment, set parent id = id of case and insert the attachment.
     If attachment of same name exists, then append current date to the attachment name*/
    @future
    public static void afterInsertMethod (Map<Id, Id> eMsgIdToCaseIdMap){
    
       system.debug('eMsgIdToCaseIdMap--'+eMsgIdToCaseIdMap);
       
       //List of Attachments whose Parent is the EmailMessage in eMsgIdToCaseIdMap
       List<Attachment> attList = new List<Attachment>();
       
       if(eMsgIdToCaseIdMap.keySet().size() > 0){
          attList = [ Select Id, Name, ParentId, Body, BodyLength, ContentType, Description, IsPrivate, OwnerId From Attachment Where ParentId in :eMsgIdToCaseIdMap.keySet() ];
       }
       system.debug('attList--'+attList);
       
       //Querying Cases, which are Parents of EmailMessage in eMsgIdToCaseIdMap
       Map<Id, Case> caseMap; 
       
       if(eMsgIdToCaseIdMap.keySet().size() > 0){
          caseMap = new Map<Id, Case>([ Select Id, (Select Id, Name From Attachments) From Case Where Id In :eMsgIdToCaseIdMap.values() ]);
       }
       system.debug('caseMap--'+caseMap);
       
       //list of attachments to be inserted
       List<Attachment> toBeInserted = new List<Attachment>();
       
       if(attList.size() > 0){
          for(Attachment a :attList){
             Attachment temp = new Attachment();
             temp = a.clone();
             system.debug('temp--'+temp);
             temp.ParentId = eMsgIdToCaseIdMap.get(a.ParentId);
             //checking whether this case already has an Attachment with the same name
             if(caseMap.get(temp.ParentId).Attachments.size() > 0){
                for(Attachment at :caseMap.get(temp.ParentId).Attachments){
                   if(a.Name == at.Name){
                      temp.Name = temp.Name + ' ' + system.now().format();
                   }
                }
             }
             tobeInserted.add(temp);
          }
       }
       system.debug('tobeInserted--'+tobeInserted);
       
       if(toBeInserted.size() > 0){
          try{
             insert toBeInserted;
          } catch(DMLException e){
               system.debug('error--'+e.getMessage());
          }
       }
       
    }
    
}