({
	 selectRecord : function(component, event, helper){ 
         
     
    if(component.get("v.Searchrecordtype") =='Contact')
    {
      var getSelectRecord = component.get("v.contactRec");
      var compEvent = component.getEvent("selectedContactEvent");
      compEvent.setParams({"contactByEvent" : getSelectRecord });  
     compEvent.fire();
    }
         else
         {
              var getSelectRecord = component.get("v.AccountRec");   
              var compEvent = component.getEvent("selectedContactEvent");
              compEvent.setParams({"AccountByEvent" : getSelectRecord });  
              compEvent.fire();
    
         }
    },
})