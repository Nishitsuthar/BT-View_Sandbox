public with sharing class VG_DataCategoryService {
   public static Map<String, List<DataCategoryWrapper>> dataCategoryWrapperMap = new Map<String, List<DataCategoryWrapper>>();
    
  @auraEnabled
  public static Map<String, List<DataCategoryWrapper>> retrieveAllDataCategories(){
    List<String> objTypes = new List<String>{'KnowledgeArticleVersion'};
    List<DataCategoryGroupSobjectTypePair> pairs =
      new List<DataCategoryGroupSobjectTypePair>();
    for(DescribeDataCategoryGroupResult singleResult :
        Schema.describeDataCategoryGroups(objTypes)) {
      DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
      p.setSobject(singleResult.getSobject());
      p.setDataCategoryGroupName(singleResult.getName());
      pairs.add(p);
    }

    for (DescribeDataCategoryGroupStructureResult singleResult :Schema.describeDataCategoryGroupStructures(pairs, false)) {
      for(DataCategory category : singleResult.getTopCategories()) {
        buildDCWrappers(singleResult.getName(), null, category, category.getChildCategories());
      }
    }
      System.debug('dataCategoryWrapperMap'+dataCategoryWrapperMap);
     return dataCategoryWrapperMap;
  }

  private static void buildDCWrappers(String groupName, DataCategory parentCategory, DataCategory category, List<DataCategory> childCatagories){
    if(dataCategoryWrapperMap.containsKey(groupName)) {
      dataCategoryWrapperMap.get(groupName).add(new DataCategoryWrapper(parentCategory, category, childCatagories));
    } else {
      dataCategoryWrapperMap.put(groupName, new List<DataCategoryWrapper> {(new DataCategoryWrapper(parentCategory, category, childCatagories))});
    }
  }

  public  class DataCategoryWrapper {
    public String parentName {get; set;}
    public DataCategory category {get; set;}
    public String name {get; set;}

   
    
    public DataCategoryWrapper(DataCategory parent, DataCategory category, List<DataCategory> childCategories){
      this.parentName = parent != null ? parent.getName() : null;
      this.category = category;
      this.name = category.getName();
    }
  }
}