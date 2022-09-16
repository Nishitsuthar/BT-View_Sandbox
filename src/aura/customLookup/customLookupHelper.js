({
    searchHelper : function(component,event,getInputkeyWord) {
        var action;
        var searchtype = component.get("v.Searchrecordtype");
        if(searchtype === 'Contact'){
            action  = component.get("c.fetchContact");
        }else{
            action  = component.get("c.fetchAccounts");      
        }
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                    component.set("v.showSpinner",false); 
                    component.set("v.showConSpinner",false); 
                    
                }else{
                    component.set("v.Message", 'Search Result...');
                    component.set("v.showSpinner",false); 
                    component.set("v.showConSpinner",false); 
                   
                }
                if(searchtype ==='Contact'){
                     component.set("v.listOfSearchRecords", storeResponse);
                    component.set("v.listOfSearchRecordsACC", []);  
                }else{
                     component.set("v.listOfSearchRecords", []);
                    component.set("v.listOfSearchRecordsACC", storeResponse);    
                    console.log('console.log'+JSON.stringify(storeResponse));
                }
               component.set("v.showSpinner",false); 
                component.set("v.showConSpinner",false); 
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
})