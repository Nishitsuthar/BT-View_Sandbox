@isTest
public class CaseCommentTest{
    static testMethod void TestComment(){
       
     Case parentcase = new Case();
     parentcase.subject = 'TEST';
     parentcase.description='testdes';
     parentcase.status='New';
     parentcase.Priority = 'P3';
     insert parentcase;
     
      Case childcase = new Case();
     childcase.subject = 'TEST';
     childcase.description='testdes';
     childcase.status='New';
     childcase.ParentId=parentcase.id;
     childcase.Priority = 'P3';
     insert childcase;
     
      Case childcase2 = new Case();
     childcase2.description='testdes';
     childcase2.status='New';
     childcase2.ParentId=parentcase.id;
     childcase2.Priority = 'P3';
     insert childcase2;
     
        List<CaseComment> cs = new List<CaseComment>();
             
               
               cs.Add(New casecomment(parentId=childcase.id,CommentBody = 'Test1'));
                 cs.Add(New casecomment(parentId=parentcase.id,CommentBody = 'Test1'));
                  cs.Add(New casecomment(parentId=childcase2.id));
     insert cs;
     
     
        
    }
}