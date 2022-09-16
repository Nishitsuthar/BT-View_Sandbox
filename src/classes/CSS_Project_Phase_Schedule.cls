global class CSS_Project_Phase_Schedule Implements Schedulable
    {
        @readonly
        global void execute(SchedulableContext sc)
        {
            set<string> refIds=new set<string>();
            set<Id> oerIds=new set<Id>();
            Map<Id,list<Order_Entry_Line__c>> preOERMapCount = new Map<Id,list<Order_Entry_Line__c> >(); 
            Map<Id,list<Order_Entry_Line__c>> postOerMapCount=new Map<Id,list<Order_Entry_Line__c>>(); 
            Map<string,Order_Entry_Line__c> finalMapRef=new Map<string,Order_Entry_Line__c>();
            for(Project_Phase__c p:[SELECT id,Customer_reference_Id__c,Order_Entry_Release__c FROM Project_Phase__c])
            {
                refIds.add(p.Customer_reference_Id__c);
            }
            list<Order_Entry_Line__c> alloels=[SELECT ID,Status__c,Order_Entry_Release__c,Order_Entry_Release__r.Status__c,Reference_ID__c FROM Order_Entry_Line__c Where Reference_ID__c in:refIds];
            for(Order_Entry_Line__c oel: alloels)
            {
                if(!oel.Status__c.contains('cancel'))
               {
                    oerIds.add(oel.Order_Entry_Release__c);
                }
            }
            for(Order_Entry_Line__c oel:[SELECT ID,Order_Entry_Release__c,Order_Entry_Release__r.Status__c,Reference_ID__c FROM Order_Entry_Line__c Where Order_Entry_Release__c in : oerIds])
            {
               if(!oel.Order_Entry_Release__r.Status__c.contains('cancel'))
               {
                    if(oel.Order_Entry_Release__r.Status__c == 'Draft'){
                        if(!preOERMapCount.containskey(oel.Order_Entry_Release__c))
                        preOERMapCount.put(oel.Order_Entry_Release__c,new list<Order_Entry_Line__c>{oel});
                        else
                        preOERMapCount.get(oel.Order_Entry_Release__c).add(oel);
                    }
                    else
                    {
                        if(!postOerMapCount.containskey(oel.Order_Entry_Release__c))
                        postOerMapCount.put(oel.Order_Entry_Release__c,new list<Order_Entry_Line__c>{oel});
                        else
                        postOerMapCount.get(oel.Order_Entry_Release__c).add(oel);
                    }
               }
            }
            for(Order_Entry_Line__c oel: alloels)
            {
              if(!oel.Status__c.contains('cancel') && oel.Reference_ID__c!=null)
                {
                    if(!finalMapRef.containskey(oel.Reference_ID__c))
                    {                        
                        finalMapRef.put(oel.Reference_ID__c,oel);
                    }
                    else{
                        if(!postOerMapCount.containskey(finalMapRef.get(oel.Reference_ID__c).Order_Entry_Release__c) && 
                            postOerMapCount.containskey(oel.Order_Entry_Release__c))
                                finalMapRef.put(oel.Reference_ID__c,oel);
                        if(postOerMapCount.containskey(finalMapRef.get(oel.Reference_ID__c).Order_Entry_Release__c) && 
                            postOerMapCount.containskey(oel.Order_Entry_Release__c) && postOerMapCount.get(oel.Order_Entry_Release__c).size()>
                            postOerMapCount.get(finalMapRef.get(oel.Reference_ID__c).Order_Entry_Release__c).size())
                            
                                finalMapRef.put(oel.Reference_ID__c,oel);
                            if(preOerMapCount.containskey(finalMapRef.get(oel.Reference_ID__c).Order_Entry_Release__c) && 
                            preOerMapCount.containskey(oel.Order_Entry_Release__c) && preOerMapCount.get(oel.Order_Entry_Release__c).size()>
                            preOerMapCount.get(finalMapRef.get(oel.Reference_ID__c).Order_Entry_Release__c).size())
                            
                                finalMapRef.put(oel.Reference_ID__c,oel);
                    }
                    
                }
            }
            system.debug('@@schd'+finalMapRef);
            CSSProjectPhasebatch batch=new CSSProjectPhasebatch(finalMapRef);
            database.executebatch(batch,200);
        }
        
    }