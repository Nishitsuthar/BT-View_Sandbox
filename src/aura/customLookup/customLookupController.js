({
  
	keyPressController : function(component, event, helper) {
        // get the search Input keyword  
      
		var getInputkeyWord;
        var searchtype = component.get("v.Searchrecordtype");
        if(searchtype === 'Contact'){
            component.set("v.showConSpinner",true); 
			getInputkeyWord = component.get("v.SearchKeyWordCon");           
        }else{
            component.set("v.showSpinner",true); 
            getInputkeyWord = component.get("v.SearchKeyWordAcc");
        }
      // check if getInputKeyWord size id more then 0 then open the lookup result List and 
      // call the helper 
      // else close the lookup result List part.   
        if( getInputkeyWord.length > 1 ){
            if(searchtype === 'Contact'){
           var forOpen = component.find("searchRes1"); 
            }
            else
            {
             var forOpen = component.find("searchRes");
            }
           // alert(forOpen);
              $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
            
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
         
	},
  
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
      
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField");
        var lookUpTarget1 = component.find("lookupField1");
        var pillTarget1 = component.find("lookup-pill1");
        
        component.set("v.SearchKeyWordAcc",'');
        component.set("v.SearchKeyWordCon",'');
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
        
         $A.util.addClass(pillTarget1, 'slds-hide');
         $A.util.removeClass(pillTarget1, 'slds-show');
        
         $A.util.addClass(lookUpTarget1, 'slds-show');
         $A.util.removeClass(lookUpTarget1, 'slds-hide');
      
        
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
        component.set("v.listOfSearchRecordsACC", null );
        
         var compEvent = component.getEvent("cleartable");
     compEvent.fire();
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
  //   alert(component.get("v.Searchrecordtype"));
    // get the selected Account record from the COMPONETN event 
    if(component.get("v.Searchrecordtype")=='Contact')
    {
       var selectedContactRec = event.getParam("contactByEvent");
	   component.set("v.selectedRecord" , selectedContactRec); 
    }
        else
        {
            
          var  selectedAccountRecord =event.getParam("AccountByEvent");
          component.set("v.selectedAccountRecord" , selectedAccountRecord); 
        }
        
        console.log('selectedAccountRecord'+selectedAccountRecord);
        console.log('selectedContactRec'+selectedContactRec);
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
      
        
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
        
        
        var forclose1 = component.find("lookup-pill1");
           $A.util.addClass(forclose1, 'slds-show');
           $A.util.removeClass(forclose1, 'slds-hide');
      
        
        var forclose1 = component.find("searchRes1");
           $A.util.addClass(forclose1, 'slds-is-close');
           $A.util.removeClass(forclose1, 'slds-is-open');
        
        var lookUpTarget1 = component.find("lookupField1");
            $A.util.addClass(lookUpTarget1, 'slds-hide');
            $A.util.removeClass(lookUpTarget1, 'slds-show');  
        
        
        
      
	},
  // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
 // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    
    clearvalues : function(component,event,helper)
    {
        
        
        component.set("v.SearchKeyWordAcc",'');
        component.set("v.SearchKeyWordCon",'');
          var a = component.get('c.clear');
        $A.enqueueAction(a);
        
    }
})