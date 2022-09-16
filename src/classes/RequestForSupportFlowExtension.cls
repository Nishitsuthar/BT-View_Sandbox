public class RequestForSupportFlowExtension {
    //public final Flow.Interview.Request_for_Support createRequestForSupport{get; set;}
     public final Flow.Interview.Support_Requests createRequestForSupport{get; set;}

    public RequestForSupportFlowExtension(ApexPages.StandardController stdController) {}
    public String getFinishLoc() { 
    String fin = null;
        if(createRequestForSupport != null)
        {
        
        fin = (string) createRequestForSupport.vFinishId;
        system.debug('--->'+fin );
       // fin = 'qwer';
       
        }
         system.debug('--->14'+fin );
       // return fin;
        return createRequestForSupport == null? 'home/home.jsp' : fin;
    }
     Public PageReference getFinishPageRef(){
    // Id Ids = ApexPages.currentPage().getParameters().get('rfs');
        PageReference pageRef = new PageReference('/' + getfinishLoc());
       // PageReference pageRef = new PageReference('/' + Ids);
        System.debug('@@@'+ getfinishLoc());
        pageRef.setRedirect(true);
        return pageRef;
    }
}