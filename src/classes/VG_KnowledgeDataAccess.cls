public with sharing class VG_KnowledgeDataAccess
{
   
    public static List<SObject> getKnowledgeArticleByNumber(List<String> articleNumbers)
    {
        List<SObject> articleList = [SELECT ID FROM KnowledgeArticle WHERE ArticleNumber IN :articleNumbers];
        
        if (articleList == null)
        {
            articleList = new List<SObject>();
        }
        return articleList;
    }
    
    @AuraEnabled
    public static Knowledge_Article__kav getKnowledgeArticleInfo(Id recordIds)
    {
            Knowledge_Article__kav ArticleVersionInfo = [SELECT Id, Title, UrlName, ArticleNumber, KnowledgeArticleId,Phone__c,Website__c,Hours__c
                                                          FROM Knowledge_Article__kav
                                                           WHERE Id  =:recordIds];
        return ArticleVersionInfo;
    }
    
    @AuraEnabled
    public static TopicWithAssignmentInfo getKnowledgeArticleInfoWithParent(Id recordIds) {
        //get all parent topic info
        string commId = [Select Id from Network where Name = 'My View'].Id;
        
        Set<Id> AllParentTopicIds = new Set<Id>();
        
        ConnectApi.ManagedTopicCollection mtCollection = ConnectAPI.ManagedTopics.getManagedTopics(commId, ConnectApi.ManagedTopicType.Navigational);
        for(ConnectApi.ManagedTopic mtopic : mtCollection.managedTopics) {
            AllParentTopicIds.add(mtopic.topic.Id);
        }
        
        List<TopicAssignment> associatedTopicAssignments = [
            SELECT Id, EntityId, TopicId, Topic.Name
            FROM TopicAssignment
        	WHERE EntityId = :recordIds
        	AND TopicId IN :AllParentTopicIds
        ];
        
        TopicWithAssignmentInfo topicWithAssignment = new TopicWithAssignmentInfo();
    	topicWithAssignment.assignmentInfo = associatedTopicAssignments.size() > 0 ? associatedTopicAssignments[0] : null;
        topicWithAssignment.articleInfo = [SELECT Id, Title FROM Knowledge_Article__kav WHERE Id = :recordIds];
        
        return topicWithAssignment;
    }
   
    public class TopicWithAssignmentInfo {
    	@AuraEnabled
        public Knowledge_Article__kav articleInfo{get;set;}
        @AuraEnabled
        public TopicAssignment assignmentInfo{get;set;}
    }
    
    @AuraEnabled
    public static Knowledge_Article__kav getQandAKnowledgeArticleInfo(Id recordIds)
    {
            Knowledge_Article__kav ArticleVersionInfo = [SELECT Id, Title, UrlName, ArticleNumber,Q_A__c, KnowledgeArticleId,Phone__c,Website__c,Hours__c
                                                          FROM Knowledge_Article__kav
                                                           WHERE Id  =:recordIds];
        system.debug('@@ ArticleVersionInfo'+ArticleVersionInfo);
         system.debug('@@ ArticleVersionInfo Q_A__c'+ArticleVersionInfo.Q_A__c);
        if(ArticleVersionInfo!= null && ArticleVersionInfo.Q_A__c!=null){
         List<Knowledge_Article__kav> QandAArticleVersionInfoList = [SELECT Id, Title, UrlName, ArticleNumber,Question1__c,Answer1__c, KnowledgeArticleId,Phone__c,Website__c,Hours__c  FROM Knowledge_Article__kav WHERE Id  =:ArticleVersionInfo.Q_A__c];
                                                         
       system.debug('@@ QandAArticleVersionInfoList'+QandAArticleVersionInfoList);
     /*   QandAWrapper QandAWrap = new QandAWrapper();
        QandAWrap.add(q)*/
            if(!QandAArticleVersionInfoList.isEmpty() && QandAArticleVersionInfoList.size()>0)
        return QandAArticleVersionInfoList[0]; return null;             
            
        }
        return null;
    }
   /* public class QandAWrapper{
        @AuraEnabled
        public  string question{get;set;}
        @AuraEnabled
        public  string answer{get;set;}
        
        public QandAWrapper(string question,string answer){
            this.question = question;
            this.answer = answer;
        }
    }*/
    @AuraEnabled
    public static Map<Id, SObject> getKnowledgeArticleVersionMapByIds(List<Id> recordIds)
    {
        Map<Id, SObject> mapObject = new Map<Id, SObject>([SELECT Id, Title, UrlName, ArticleNumber, KnowledgeArticleId
                                                           FROM KnowledgeArticleVersion
                                                           WHERE Id IN :recordIds]);
        
        if (mapObject == null)
        {
            mapObject = new Map<Id, SObject>();
        }
        return mapObject;
    }
    
    public static List<SObject> getArticlesByUrlName(String urlName, String lang)
    {
        String soql = 'SELECT ID,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE UrlName = :urlName AND Language = \''
            + String.escapeSingleQuotes(lang) + '\' AND ' +  'PublishStatus = \'Online\'';
        return Database.query(soql);
    }
    
    public static List<SObject> getArticlesByLanguageAndType(String selectFields, String lang, String articletypes)
    {
        String sWhere = ' WHERE publishStatus=\'Online\' AND language=\'' + lang + '\'';
        sWhere += String.isBlank(articleTypes) ? '' : ' AND ArticleType IN (' + articleTypes + ') ';
        String qStr = 'SELECT ' + selectFields + ' FROM KnowledgeArticleVersion ' + sWhere;
        return  Database.query(qStr);
    }
    
    public static  Map<Id, SObject> getMapByArticles(List<Id> articleIds)
    {
        system.debug('----article id---'+articleIds);
        Map<Id, SObject> sObjectMap = new Map<Id, SObject>();
        if (articleIds == null || articleIds.isEmpty())
        {
            return sObjectMap;
        }
        String sObjectName = articleIds[0].getSobjectType().getDescribe().getName();
        String soql = 'SELECT Id, Title, KnowledgeArticleId, ArticleNumber,  LastPublishedDate, Summary, Language,UrlName';
        Schema.sobjectfield field = Schema.sObjectType.KnowledgeArticleVersion.fields.getMap().get('MasterVersionId');
        if (field != null) {
            soql = soql + ',MasterVersionId';
        }
        soql += ', (SELECT Id, DataCategoryName, DataCategoryGroupName FROM DataCategorySelections)';
        soql += ' FROM ' + sObjectName + ' WHERE Id IN :articleIds';
        system.debug('---soqlid--'+soql);
        return new Map<Id, SObject>((List<SObject>) Database.query(soql));
    }
    
    public static List<SObject> findKnowledgeArticleVersion(String queryString, String sLimit, String sFields,
                                                            String sWhere)
    {
         System.debug('queryString----'+queryString);
         System.debug('sLimit----'+sLimit);
         System.debug('sFields----'+sFields);
         System.debug('sWhere----'+sWhere);
        String tmp1 = '';
        
        String titleWhere = '';
        Set<String> ss = new Set<String>();
        for (String s : queryString.split(' ')) {
            String reference='\'%' + String.escapeSingleQuotes(s.trim()) + '%\'';
            titleWhere += ' Title LIKE '+reference;
            titleWhere += ' AND ';
            ss.add(s);
        }
        
        titleWhere = titleWhere.removeEnd('AND ');
        titleWhere = String.isNotBlank(titleWhere) ? ' AND '+titleWhere+' ' : '';
        
        System.debug('titleWhere'+titleWhere);
       
        List<SObject> Allrecords = new List<SObject>();
        // Query for all KnowledgeArticleVersion with Title matching search string
        if (String.isNotBlank(titleWhere)) {
            String mainQuery = 'SELECT '+sFields+' FROM KnowledgeArticleVersion '+ sWhere + titleWhere + sLimit;
            Allrecords = Database.Query(mainQuery);
        }
     	
        try {
            Integer recordLimit = Integer.ValueOf(sLimit.replace('LIMIT', '').deleteWhitespace());
            if (Allrecords.size() < recordLimit){
                
                String qStr = 'FIND {' + queryString + '*} IN ALL FIELDS' + ' RETURNING KnowledgeArticleVersion( ID,Title, ArticleNumber, Language,UrlName,LastPublishedDate,ValidationStatus '
                    + sWhere +' ) ' + sLimit + ' UPDATE TRACKING';
                
                System.debug('search query:'+qStr);
                List<List<SObject>> results = Search.query(qStr);
                System.debug('search query reult:'+results[0]);
                //if(results[0]== null || results[0].isEmpty()) return results[0];  
                    
                Integer differenceCount = recordLimit - Allrecords.size();
                
                List<SObject> nonRelevant = new List<SObject>();    
                Integer recordsAdded = 0;
                for (SObject eachObj : results[0]) {
                        
                    if (recordsAdded == differenceCount) { break;    
                    }
                    
                    if (!Allrecords.contains(eachObj)) {
                        boolean relevant = false;
                    
                        for (string h : ss) {
                            knowledgeArticleVersion versionInst =  (KnowledgeArticleVersion) eachObj;
                            if (versionInst.title.containsIgnoreCase(h)) {
								relevant = true;
                            }
                        }
                        
                        if (relevant) {
                            Allrecords.add(eachObj);
                        	recordsAdded ++;
                        } else {
                            nonRelevant.add(eachObj);
                        }
                        
                    }
                }
                
                if (Allrecords.size() < recordLimit) {
                    differenceCount = recordLimit - Allrecords.size();
                    recordsAdded = 0;
                    
                    for (SObject eachObj : nonRelevant) {
                        if (differenceCount == recordsAdded) break;
                        
                        if (!Allrecords.contains(eachObj)) {
                            Allrecords.add(eachObj); recordsAdded ++;
                        }
                    }
                }
                System.debug('Allrecords count'+Allrecords.size());
            }
        
            
            Allrecords.addAll(getArticleVersionsFromTopics(queryString, sFields, Allrecords));
            System.debug('update all records size'+Allrecords.size());
            return Allrecords; 
        
        //List<SObject> combinedResultList = new List<SObject>();
        //combinedResultList.addAll(results[0]);
        
            
            
            
         /*   for(SObject obj : results[0]) {
                
                
                
                tmp1 += '\'' + obj.id + '\', ';
            }
            
            tmp1 = String.isNotBlank(tmp1) ? tmp1.left(tmp1.lastIndexOf(',')) : '';
            
            String sQry = 'select '+sFields+',(SELECT Id, Topic.Name from TopicAssignments) from KnowledgeArticleVersion where id in ('+tmp1+')';*/
            //System.debug('sQry:'+qStr);
          //  return (List<SObject>) Database.query(sQry);

          
           
          //method to query the article version from Topic search
          //combinedResultList.addAll(getArticleVersionsFromTopics(queryString, sFields, combinedResultList));
          //System.debug(results[0].size() + '-- combined size--'+combinedResultList.size());
          //return results[0];
          //return combinedResultList;
        } catch (Exception e) {
            System.debug('Exception in search'+e+'---'+e.getLineNumber());
            return new List<SObject>();
        }
    }
    
    /*
	* To query Article Verstions from the Topic search String
	* Params: String queryString, String sFields
	*/
   @TestVisible
    private static List<SObject> getArticleVersionsFromTopics(String queryString, String sFields, List<SObject> partialResult) {
        System.debug('get article version from topics started');
        String searchTopic = '%'+ queryString+'%';    
        Set<Id> allUniqueTopicId = new Set<Id>();
        for(Topic eachTopic :[SELECT Id, Name From topic where name LIKE :searchTopic]) {
            allUniqueTopicId.add(eachTopic.Id);
        }
        
        TopicAssignment[] assignmentList = [SELECT EntityId FROM TopicAssignment WHERE TopicId IN :allUniqueTopicId LIMIT 1000];
        List<Id> assignmentListIds = new List<Id>();
	    for (TopicAssignment ta : assignmentList) assignmentListIds.add(ta.EntityId);
        
        String query = 'SELECT ' +sFields+ ' FROM KnowledgeArticleVersion WHERE Id IN :assignmentListIds AND PublishStatus = \'Online\' ORDER BY LastPublishedDate DESC LIMIT 1000';
        
        Integer i = 0;
        List<SObject> recordFromTopicSearch = new List<SObject>();
        for(SObject eachObject : Database.query(query)) {
            if (i == 5) { break; }
            if (!partialResult.contains(eachObject)) {
                recordFromTopicSearch.add(eachObject); i++;
            }
        }
        System.debug('Unique records are: '+recordFromTopicSearch);
        
        return recordFromTopicSearch;
    }
    
    public static List<SObject> getArticleTypeVersion(String lang, Id kaId, String objectName, String selectStatement,
                                                      Set<String> selectFields)
    {
        String  soql = selectStatement + ' FROM ' + objectName +
            ' WHERE Language = \'' + String.escapeSingleQuotes(lang) +
            '\' AND ' +  'PublishStatus = \'Online\' AND ' +
            'KnowledgeArticleId = \'' + String.escapeSingleQuotes(kaId) +
            '\' UPDATE VIEWSTAT';
        
        
        return (List<SObject>) Database.query(soql);
    }
    
    public static List<SObject> getArticleTypeByArticleNumbers(String articleNums, String articleType) {
        List<SObject> articleList = new List<SObject>();
        String namespace = VG_Constants.NAMESPACE_PREFIX;
        articleType = namespace + articleType;
        if(String.isBlank(articleNums)) 
        {
            return articleList;
        }
        Set<String> fieldSet = Schema.getGlobalDescribe().get(articleType).getDescribe().fields.getMap().keySet();
        
        
        String soql = 'SELECT ';
        for(String fieldName : fieldSet) {
            soql += fieldName + ', ';
        }
        soql = soql.left(soql.lastIndexOf(','));
        soql += ' FROM '  + articleType + ' WHERE publishStatus=\'Online\' AND language=\'' + UserInfo.getLanguage() + '\'' + ' AND ArticleNumber IN (' + articleNums + ') '; 
            
        articleList = (List<SObject>) Database.query(soql);return articleList;
        
    }
}