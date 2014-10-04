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
#define URL_NEXT_FEED kBaseURL @"/api/feed?last_created_at=%@"

@implementation SCFeedStore

- (void)fetchFeed
{
  SCURLSession *session = [[SCURLSession alloc] init];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_FEED]];
  
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

- (void)fetchNextFeed
{
  SCPlay *play = [self.feed.items lastObject];
  
  if (!play) {
    return;
  }
  
  SCURLSession *session = [[SCURLSession alloc] init];
  NSURL *nextFeed = [NSURL URLWithString:[NSString stringWithFormat:URL_NEXT_FEED, play.createdAtRaw]];
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
                                          [self.delegate feedStore:self didFinishFetchingNextInsertedIndices:insertedIndices];
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
