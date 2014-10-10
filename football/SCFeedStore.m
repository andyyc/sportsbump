//
//  SCFeedStore.m
//  football
//
//  Created by Andy Chen on 9/28/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCFeedStore.h"
#import "SCFeed.h"
#import "SCURLSession.h"
#import "SCPlay.h"

#define URL_FEED kBaseURL @"/api/feed"
#define URL_OLDER_FEED kBaseURL @"/api/feed?last_created_at=%@"
#define URL_NEWER_FEED kBaseURL @"/api/feed?most_recent_created_at=%@"

@implementation SCFeedStore

- (void)fetchFeed
{
  SCURLSession *session = [[SCURLSession alloc] init];
  NSURL *requestURL;
  
  if ([_feed count] > 0) {
    SCPlay *firstPlay = _feed.items.firstObject;
    requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_NEWER_FEED, firstPlay.createdAtRaw]];
  } else {
    requestURL = [NSURL URLWithString:URL_FEED];
  }
  
  NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
  NSURLSessionDataTask *dataTask = [session dataTaskWithAuthenticatedRequest:request
                                                           completionHandler:^(NSData *data,
                                                                               NSURLResponse *response,
                                                                               NSError *error)
                                    {
                                      NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                      NSError *responseError;
                                      NSArray* jsonArray = [NSJSONSerialization
                                                                JSONObjectWithData:data
                                                                options:kNilOptions
                                                                error:&responseError];
                                      
                                      if (!error && httpResp.statusCode == 200) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          // End the refreshing
                                          
                                          if (_feed) {
                                            NSArray *insertedIndices = [_feed addJson:jsonArray atIndex:0];
                                            
                                            if ([insertedIndices count] < [jsonArray count]) {
                                              // this means there was overlap, if no overlap, reload the entire feed
                                              [self.delegate feedStore:self didFinishFetchingFeedInsertedIndices:insertedIndices];
                                              return;
                                            }
                                          }
                                          
                                          _feed = [[SCFeed alloc] initWithJson:jsonArray];
                                          [self.delegate didFinishFetchingFeed:self];
                                        });
                                      } else {
                                        // alert for error saving
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          // End the refreshing
                                          [self.delegate didFailFetchingFeed:self];
                                        });
                                      }
                                    }];
  
  [dataTask resume];
}

- (void)fetchOlderFeed
{
  SCPlay *play = [self.feed.items lastObject];
  
  if (!play) {
    return;
  }
  
  SCURLSession *session = [[SCURLSession alloc] init];
  NSURL *nextFeed = [NSURL URLWithString:[NSString stringWithFormat:URL_OLDER_FEED, play.createdAtRaw]];
  NSURLRequest *request = [NSURLRequest requestWithURL:nextFeed];
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithAuthenticatedRequest:request
                                                           completionHandler:^(NSData *data,
                                                                               NSURLResponse *response,
                                                                               NSError *error)
                                    {
                                      NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                      NSError *responseError;
                                      NSArray* jsonArray = [NSJSONSerialization
                                                                JSONObjectWithData:data
                                                                options:kNilOptions
                                                                error:&responseError];
                                      
                                      if (!error && httpResp.statusCode == 200) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          // End the refreshing
                                          NSArray *insertedIndices = [_feed addJson:jsonArray];
                                          [self.delegate feedStore:self didFinishFetchingFeedInsertedIndices:insertedIndices];
                                        });
                                      } else {
                                        // alert for error saving
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          // End the refreshing
                                        });
                                      }
                                    }];
  
  [dataTask resume];
}


@end
