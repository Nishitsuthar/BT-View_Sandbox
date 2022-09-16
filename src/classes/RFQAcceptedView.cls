public without sharing class RFQAcceptedView{ 
    public String rfqToVendorId{ get; set; }
    
    public String guestUserSite{ get; set; }
    
    public String rfqMessage{ get; set; }
    
    public Boolean rfqStatus{ get; set; }
    
    public Boolean reloadPage{get; set;}
    
    public List<buildertek__RFQ_To_Vendor__c> rfqToVendorList{ get; set; }
    
    public buildertek__RFQ_Template_Settings__c rfqTemplateSettings;
    
    public RFQAcceptedView(){
        if (ApexPages.currentPage().getParameters().get('id').escapeHtml4() != null && Boolean.valueOf(ApexPages.currentPage().getParameters().get('status').escapeHtml4()) != null){
          	
            
          /* if(ApexPages.currentPage().getParameters().get('rfqTovendorStatus').escapeHtml4() == 'Accepted' || ApexPages.currentPage().getParameters().get('rfqTovendorStatus').escapeHtml4()== 'Rejected'){
                reloadPage = true;
            }*/
            
            rfqTemplateSettings = buildertek__RFQ_Template_Settings__c.getOrgDefaults();
            rfqToVendorId = ApexPages.currentPage().getParameters().get('id').escapeHtml4();
            rfqStatus = Boolean.valueOf(ApexPages.currentPage().getParameters().get('status').escapeHtml4());
            rfqToVendorList = [Select Id, Name, buildertek__RFQ__c,buildertek__RFQ__r.buildertek__Status__c,buildertek__Status__c ,buildertek__Contact__c
                               FROM buildertek__RFQ_To_Vendor__c
                               WHERE Id = :rfqToVendorId
                               Limit 1];
            
            system.debug('rfqToVendorList'+rfqToVendorList);
            system.debug('rfqStatus'+rfqStatus);
            
           	//reloadPage = true;
           /* if(rfqToVendorList[0].buildertek__Status__c == 'Accepted' || rfqToVendorList[0].buildertek__Status__c == 'Rejected'){
                reloadPage = false;
            }*/
            
            if(rfqToVendorList.size()>0 && rfqToVendorList[0].buildertek__RFQ__c != null &&
               (rfqToVendorList[0].buildertek__RFQ__r.buildertek__Status__c == 'Awarded' || rfqToVendorList[0].buildertek__RFQ__r.buildertek__Status__c == 'Accepted') && 
               (rfqToVendorList[0].buildertek__Status__c != 'Awarded' || rfqToVendorList[0].buildertek__Status__c != 'Accepted')){
                   rfqMessage = 'This RFQ was Awarded to another vendor';
               }
            else if(rfqToVendorList.size()>0 && rfqToVendorList[0].buildertek__Status__c == 'Accepted'){
                rfqMessage = 'You have already submitted a bid for this RFQ';
            }
            else if(rfqToVendorList.size()>0 && rfqToVendorList[0].buildertek__Status__c == 'Rejected'){
                rfqMessage = 'This RFQ has been Rejected!';
            }
            
            
        }
    }
    
    public void updateRFQ(){
        try{
            buildertek__RFQ_To_Vendor__c rfqrerec;
            rfqrerec = [Select Id, Name, buildertek__RFQ__c,buildertek__RFQ__r.buildertek__Due_Date__c
                               FROM buildertek__RFQ_To_Vendor__c where Id = :rfqToVendorId];
            system.debug('duedate'+rfqrerec.buildertek__RFQ__r.buildertek__Due_Date__c);
            system.debug('system.today()'+system.today());
            system.debug('rfqrerec'+rfqrerec);
            if(rfqrerec.buildertek__RFQ__r.buildertek__Due_Date__c < system.today()){
                rfqMessage = 'You can not Accept/Reject this RFQ , because the Due Date of this RFQ is expired. Please Contact System Administrate.';
            }else{
            List<buildertek__RFQ_To_Vendor__c> rfqToVendorListDup = [Select Id, Name, buildertek__RFQ__c,buildertek__RFQ__r.buildertek__Status__c,
            buildertek__Status__c ,buildertek__Contact__c
                               FROM buildertek__RFQ_To_Vendor__c
                               WHERE Id = :rfqToVendorId
                               Limit 1];


                               
            system.debug(rfqToVendorListDup[0].buildertek__RFQ__r.buildertek__Status__c);
            system.debug(rfqToVendorListDup[0].buildertek__Status__c);
            if(rfqToVendorListDup.size()>0 && rfqToVendorListDup[0].buildertek__RFQ__c != null &&
               (rfqToVendorListDup[0].buildertek__RFQ__r.buildertek__Status__c != 'Awarded' || rfqToVendorListDup[0].buildertek__RFQ__r.buildertek__Status__c != 'Accepted') &&
               rfqToVendorListDup[0].buildertek__Status__c != 'Rejected' && rfqToVendorListDup[0].buildertek__Status__c != 'Accepted'){

                               
                buildertek__RFQ__c rfqrec = [select id,Name,buildertek__Project__c,buildertek__Project__r.Name,
                buildertek__Project__r.OwnerId,buildertek__Project__r.Owner.Email
                from buildertek__RFQ__c where Id =: rfqToVendorListDup[0].buildertek__RFQ__c ];
    
                string toemailadd='';
                if(rfqrec.buildertek__Project__c!=null){
                    toemailadd = rfqrec.buildertek__Project__r.Owner.Email;
                    System.debug('toemailadd--->'+toemailadd);
                }
    


                   Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                   message.toAddresses = new String[]{rfqTemplateSettings.buildertek__Inbound_Email_Address__c};
                       message.optOutPolicy = 'FILTER';
                   if (rfqStatus == true){
                       message.subject = 'Accept [ref:' + rfqToVendorId + ']';
                       message.plainTextBody = 'Accepted';
                       rfqMessage = 'Thank-You for accepting our RFQ. We look forward to working with you!';
                   	//rfqMessage = rfqToVendorListDup[0].buildertek__RFQ__r.buildertek__Status__c +'_'+rfqToVendorListDup[0].buildertek__Status__c;
                   } else{
                       message.subject = 'Decline [ref:' + rfqToVendorId + ']';
                       message.plainTextBody = 'Rejected';
                       rfqMessage = 'You have Rejected!';
                   }
                   
                   Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
                       Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);



                    if (rfqStatus == true && (rfqrec.buildertek__Project__c!=null)){    

                        string theTemplate;

                        theTemplate = [SELECT Id
                        FROM EmailTemplate
                        WHERE Name  = 'Award Accept Manager Email'].Id;        
            
                        system.debug('theTemplate>'+theTemplate);
            
                        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();    
                        Messaging.SingleEmailMessage message1= new        Messaging.SingleEmailMessage();
            
                        message1.toAddresses = new String[] { toemailadd};
                        message1.setTemplateID(theTemplate);     
                        message1.setSaveAsActivity(false);
                        message1.setWhatId(rfqToVendorId);
                        //message1.setSubject('New RFI Notification - [ref:'+newrfi.Id+']');
                        message1.setTargetObjectId(rfqToVendorListDup[0].buildertek__Contact__c);
                        messageList.add(message1);
            
                        Savepoint sp = Database.setSavepoint();
            
                        Messaging.sendEmail(messageList);
            
                        Database.rollback(sp);
                        try{ 
            
                            //List<string> CCAdresses = new List<string>();                    
                            //CCAdresses.add('sowndarya.nittala@diligentforcelabs.com'); 
                
                            List<Messaging.SingleEmailMessage> actualMessageList = new List<Messaging.SingleEmailMessage>();
                
                            // loop through the previous message list and set the email fields
                            for (Messaging.SingleEmailMessage email : messageList) {
                            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                            emailToSend.setToAddresses(email.getToAddresses());
                            emailToSend.setHTMLBody(email.getHTMLBody());
                            emailToSend.setSaveAsActivity(false);
                            emailToSend.setSubject(email.getSubject());
                            //emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                            emailToSend.setFileAttachments(email.getFileAttachments());
                            //emailToSend.setCcAddresses(CCAdresses);
                            actualMessageList.add(emailToSend);
                            system.debug('emailToSend--->'+emailToSend);
                            }
                
                
                            Messaging.SendEmailResult [] serList = Messaging.sendEmail(actualMessageList);           
                            System.debug('The email was sent successfully.');
                        }catch(Exception e){
                            System.debug('The email failed to send: ');             
                        }                
               
    
    
                    }

                   
                       

                   // reloadPage = true;
               }else if(rfqToVendorListDup.size()>0 && rfqToVendorListDup[0].buildertek__Status__c == 'Accepted'){
                   rfqMessage = 'You have already submitted a bid for this RFQ';
               } else if(rfqToVendorListDup.size()>0 && rfqToVendorListDup[0].buildertek__Status__c == 'Rejected'){
                   rfqMessage = 'This RFQ has been Rejected!';
               }else if(rfqToVendorListDup.size()>0 && rfqToVendorListDup[0].buildertek__RFQ__c != null && 
                        (rfqToVendorListDup[0].buildertek__RFQ__r.buildertek__Status__c == 'Awarded' || rfqToVendorListDup[0].buildertek__RFQ__r.buildertek__Status__c == 'Accepted') && 
                        (rfqToVendorListDup[0].buildertek__Status__c != 'Awarded' || rfqToVendorListDup[0].buildertek__Status__c != 'Accepted')){
                            rfqMessage = 'This RFQ was Awarded to another vendor';
                        }
           }
        }catch(Exception e){
            
        }
    }


}