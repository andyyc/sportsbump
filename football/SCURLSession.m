//
//  SCURLSession.m
//  football
//
//  Created by Andy Chen on 8/31/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCURLSession.h"
#import "NSURLSessionConfiguration+NSURLSessionConfigurationAdditions.h"

@interface SCURLSession()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SCURLSession

- (instancetype)init
{
  if (self=[super init]) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration sessionConfigurationWithToken];
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  }
  
  return self;
}

- (NSURLSessionDataTask *)dataTaskWithAuthenticatedRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
  return [self.session dataTaskWithRequest:request
                         completionHandler:^(NSData *data,
                                             NSURLResponse *response,
                                             NSError *error)
          {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            
            if (httpResp.statusCode == 401) {
              // user not authenticated
              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"key"];
//              NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:completionHandler];
//              [task resume];
            } else {
              completionHandler(data, response, error);
            }
          }];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
  NSLog(@"hello");
}

@end
