public class VG_TestDataUtils {
    public static User createUser(){
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		 User u = new User(Alias = 'sysadmin', Email='sysadmin@view.com',
				 EmailEncodingKey='UTF-8', LastName='Admin', LanguageLocaleKey='en_US',
				 LocaleSidKey='en_US', ProfileId = p.Id,
				 FirstName = 'Sys',
				 TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuser@view.com');
		 return u;
	}
    /*public static Account createAccount(){
		return new Account(
			Name = 'Test Account'
		);
	}

	public static Contact createContact(Id accountId){
		return new Contact(
			LastName = 'Contact Last Name',
			AccountId = accountId
		);
	}


	public static Task createTask(){
		return new Task(
			Subject = 'Call'
		);
	}

	public static FeedItem createFeedItem(Id parentId){
		return new FeedItem(
			ParentId = parentId,
			Body = 'Test Body'
		);
	}

	public static Id getNetworkId(Id userId)
	{
	    List<NetworkMember> membershipList = [SELECT networkID, memberID
	                                            FROM NetworkMember
                                              WHERE memberID = :userId];
		Id networkID = null;
		if (!membershipList.isEmpty())
		{
			networkID = membershipList[0].networkId;
		}
		return networkID;
	}

	public static List<EC_Settings__c> createECSettings()
	{
		List<EC_Settings__c> ecSettingsList = new List<EC_Settings__c>();
		EC_Settings__c  currentSetting = null;
		currentSetting = new EC_Settings__c();
		currentSetting.Name = 'Search1';
		currentSetting.Text1__c = 'Policies_and_Procedures__kav';
		currentSetting.Type__c = 'Search';
		ecSettingsList.add(currentSetting);

		currentSetting = new EC_Settings__c();
		currentSetting.Name = 'Default1';
		currentSetting.Text1__c = 'Employee Community User';
		currentSetting.Type__c = 'DefaultProfile';
		ecSettingsList.add(currentSetting);

		currentSetting = new EC_Settings__c();
		currentSetting.Name = 'Default2';
		currentSetting.Text1__c = 'United States';
		currentSetting.Type__c = 'DefaultCountry';
		ecSettingsList.add(currentSetting);

		currentSetting = new EC_Settings__c();
		currentSetting.Name = 'Default3';
		currentSetting.Text1__c = 'en_US';
		currentSetting.Type__c = 'DefaultLocale';

		currentSetting = new EC_Settings__c();
		currentSetting.Name = 'Default4';
		currentSetting.Text1__c = 'Internal URL';
		currentSetting.Type__c = VG_Constants.EC_SALESFORCE_INTERNAL_URL;


		ecSettingsList.add(currentSetting);

	    return ecSettingsList;
	}*/
/*
	public static List<FAQ__kav> getKnowledgeArticles()
	{
		List<FAQ__kav> knowledgeArticleList = new List<FAQ__kav>();

		FAQ__kav testFaq = new FAQ__kav();
        testFaq.Title = 'Test FAQ Title';
        testFaq.Summary = 'Test FAQ Summary';
        testFaq.URLName = 'testarticleurl';
        knowledgeArticleList.add(testFaq);

        testFaq = new FAQ__kav();
        testFaq.Title = 'Test FAQ Title2';
        testFaq.Summary = 'Test FAQ Summary2';
        testFaq.URLName = 'testarticleurltwo';
        knowledgeArticleList.add(testFaq);

		return knowledgeArticleList;
	}
*/
	/*public static List<EC_UserData__c> getUserData()
	{
        List<EC_UserData__c> userDataList = new List<EC_UserData__c>();
        EC_UserData__c userData = new EC_UserData__c();
        String bookmarkRecordType = Schema.SObjectType.EC_UserData__c.getRecordTypeInfosByName().get('Bookmark').getRecordTypeId();
        userData.recordTypeId = bookmarkRecordType;
        userDataList.add(userData);

        String alertRecordType = Schema.SObjectType.EC_UserData__c.getRecordTypeInfosByName().get('Alert').getRecordTypeId();
        userData = new EC_UserData__c();
        userData.recordTypeId = alertRecordType;
        userDataList.add(userData);

	    String recentlyViewedRecordType = Schema.SObjectType.EC_UserData__c.getRecordTypeInfosByName().get('Recently Viewed').getRecordTypeId();
        userData = new EC_UserData__c();
        userData.recordTypeId = recentlyViewedRecordType;
        userDataList.add(userData);

	    String recognitionRecordType = Schema.SObjectType.EC_UserData__c.getRecordTypeInfosByName().get('Recognition').getRecordTypeId();
        userData = new EC_UserData__c();
        userData.recordTypeId = recognitionRecordType;
        userDataList.add(userData);

	    return userDataList;
	}*/
/*
	public static Policies_and_Procedures__kav buildProcedureArticle() {
		String rand = String.valueOf(Math.Mod(Math.Round((Math.Random() * 10000)),10000));
		Policies_and_Procedures__kav prodArticle = new Policies_and_Procedures__kav(Summary = 'Intro'+ rand
			, IsVisibleInPkb = true
			, Title = 'Procedure Title' + rand
			, UrlName = 'artcleURLForProcdure' + rand
			, Language = 'en_US');
		return prodArticle;
	}*/

	/*public static FAQ__kav buildFAQArticle() {
    String rand = String.valueOf(Math.Mod(Math.Round((Math.Random() * 10000)),10000));
    FAQ__kav faqArticle = new FAQ__kav(Summary = 'Intro' + rand
      , IsVisibleInPkb = true
      , Title = 'How To Title' + rand
      , UrlName = 'artcleURLForFAQ' + rand
      , Language = 'en_US');
    return faqArticle;
  }*/

	/*public static Event createEvent(String typeOfEvent){
		return new Event(
			Type = typeOfEvent,
			DurationInMinutes = 10,
			ActivityDateTime = System.now()
		);
	}
	
	public static CollaborationGroup createCollaborationGroup()
	{
	    CollaborationGroup cGroup = new CollaborationGroup();
	    cGroup.CanHaveGuests = false;
	    cGroup.CollaborationType = 'Public';
	    cGroup.Name = String.valueOf(Math.random());
	    cGroup.Description = cGroup.Name + ' Description';
	    return cGroup;
	}
	
	public static Topic createTopic()
	{
	    Topic topicItem = new Topic();
	    topicItem.Name = String.valueOf(Math.random());
	    topicItem.NetworkId = Network.getNetworkId();
	    return topicItem;
	}*/

}