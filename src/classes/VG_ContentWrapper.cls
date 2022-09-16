public with sharing class VG_ContentWrapper {
  public SObject content {get; set;}
  public List<SObject> articles {get; set;}
  public boolean hasPendingTask;
  public VG_ContentWrapper(List<SObject> articles, SObject content, boolean hasPendingTask) {
    this.articles = articles;
    this.content = content;
    this.hasPendingTask = hasPendingTask;
  }
}