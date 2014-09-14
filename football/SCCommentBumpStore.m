//
//  SCCommentBumpStore.m
//  football
//
//  Created by Andy Chen on 8/17/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCCommentBumpStore.h"
#import "NSURLSessionConfiguration+NSURLSessionConfigurationAdditions.h"

#ifdef DEBUG

#define COMMENT_BUMP_URL @"http://localhost:8888/api/comment-bump/"

#else

#define COMMENT_BUMP_URL @"http://sportschub.com/api/comment-bump/"

#endif

@implementation SCCommentBumpStore

- (void)postCommentBumpForComment:(NSString *)commentId isRemoved:(BOOL)isRemoved
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration sessionConfigurationWithToken];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:COMMENT_BUMP_URL]];
  [request setHTTPMethod:@"POST"];
  NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc]
                                         initWithDictionary:@{@"comment":commentId,
                                                              @"is_removed":@(isRemoved),
                                                              }];
  
  NSError *error;
  NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:&error];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:postData];
  
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
                                      
                                      if (!error && (httpResp.statusCode == 201 || httpResp.statusCode == 200)) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          [_delegate didPostCommentBump:jsonDict];
                                        });
                                      } else {
                                        // alert for error saving / updating note
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          [_delegate failedToPostCommentBump:jsonDict];
                                        });
                                      }
                                    }];
  
  [dataTask resume];
}

@end
