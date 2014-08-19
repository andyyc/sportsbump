//
//  SCCommentStore.m
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCCommentStore.h"
#import "SCComment.h"
#import "NSURLSessionConfiguration+NSURLSessionConfigurationAdditions.h"

#define COMMENTS_URL @"http://localhost:8888/api/comments/"

@implementation SCCommentStore

- (void)fetchCommentsForGameKey:(NSString *)gameKey
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration sessionConfigurationWithToken];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSString *commentsUrl = [NSString stringWithFormat:@"%@?gamekey=%@", COMMENTS_URL, gameKey];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:commentsUrl]];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  NSURLSessionDataTask *dataTask = [session
                                    dataTaskWithRequest:request
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error)
                                    {
                                      NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                      NSError *responseError;
                                      NSArray* jsonDict = [NSJSONSerialization
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

- (void)postCommentText:(NSString *)text forPost:(NSInteger)postId andParent:(SCComment *)parent
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration sessionConfigurationWithToken];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:COMMENTS_URL]];
  [request setHTTPMethod:@"POST"];
  NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc]
                                         initWithDictionary:@{@"text":text,
                                                              @"post":@(postId),
                                                              }];
  if (parent.commentId) {
    postDictionary[@"parent"] = parent.commentId;
  }

  NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:nil];
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
                                      
                                      if (!error && httpResp.statusCode == 201) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          [_delegate didPostComment:jsonDict];
                                        });
                                      } else {
                                        // alert for error saving / updating note
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                        });
                                      }
                                    }];
  
  [dataTask resume];
}

@end
