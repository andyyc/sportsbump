//
//  SCCommentStore.m
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCCommentStore.h"

#define COMMENTS_URL @"http://localhost:8888/api/comments/"

@implementation SCCommentStore

- (void)fetchCommentsForGameKey:(NSString *)gameKey
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSString *commentsUrl = [NSString stringWithFormat:@"%@?gamekey=%@", COMMENTS_URL, gameKey];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:commentsUrl]];
  
  [request setHTTPMethod:@"GET"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  NSURLSessionDataTask *dataTask = [session
                                    dataTaskWithRequest:request
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error)
                                    {
                                      NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                      NSError *responseError;
                                      NSDictionary* jsonDict = [NSJSONSerialization
                                                                JSONObjectWithData:data
                                                                options:kNilOptions
                                                                error:&responseError];
                                      
                                      if (!error && httpResp.statusCode == 200) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          [_delegate didFetchComments:jsonDict];
                                        });
                                      } else {
                                      }
                                    }];
  
  [dataTask resume];
}

@end
