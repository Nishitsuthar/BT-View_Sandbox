public class FeedItemTriggerHandler {
    
    public static void updateFeedItems(list<FeedItem> feedItemList){
        system.debug('entered to method ');
        String communityId = Network.getNetworkId();
        List<String> feedItemIds = new List<String>();
        for(FeedItem fi : feedItemList){
            if((fi.ParentId != null && String.valueOf(fi.ParentId).startsWith('0WO'))){
            feedItemIds.add(fi.Id);
            }
        }
        system.debug('feedIds '+ feedItemIds);
        ConnectApi.BatchResult[] results = ConnectApi.ChatterFeeds.getFeedElementBatch(communityId, feedItemIds);
        for (ConnectApi.BatchResult result : results) {
            
            Map<Id, Id> mentionUserIdToId = new Map<Id, Id>();
            if (result.isSuccess()) {
                Object theResult = result.getResult();
                
                if (theResult instanceof ConnectApi.FeedItem) {
                    ConnectApi.FeedItem item = (ConnectApi.FeedItem) theResult;
                    
                    for (ConnectApi.MessageSegment segment : item.body.messageSegments) {
                        if (segment instanceof ConnectApi.MentionSegment) {
                            ConnectApi.MentionSegment mentionOutput = (ConnectApi.MentionSegment) segment;
                            mentionUserIdToId.put(mentionOutput.record.id , mentionOutput.record.id );
                        }
                    }
                    mentionUserIdToId.put(UserInfo.getUserId(), UserInfo.getUserId());
                    system.debug('mention User Ids '+ mentionUserIdToId);
                    ConnectApi.FeedItemInput input = ConnectApiHelper.createFeedItemInputFromBody(item.body);
                    
                    
                    modifyInput(input, item.Id, mentionUserIdToId);
                    
                    ConnectApi.ChatterFeeds.updateFeedElement(communityId, item.id, input);
                    
                }
                
                else {
                    
                    // Do nothing. Posting other feed element types isn't supported.
                    
                }
                
            }
            
            else {
                
                System.debug('Failure in batch feed element retrieval: ' + result.getErrorMessage());
                
            }
            
        }
    }
    
    public static void modifyInput(ConnectApi.FeedItemInput input, Id feedItemId, Map<Id, Id> mentionUserIdsMap ) {
        
        Feeditem feedRec = [Select Id, ParentId from FeedItem where Id =: feedItemId Limit 1 ];
        List<EntitySubscription> entityRec = [Select Id, ParentId, subscriberId, NetWorkId from EntitySubscription where ParentId =: feedRec.ParentId ];
        
        for(EntitySubscription rec : entityRec ){
            if(!mentionUserIdsMap.containsKey(rec.subscriberId)){
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = rec.subscriberId; // Set @mention
                input.body.messageSegments.add(mentionSegmentInput);
            }
        }
        
    }
    
}