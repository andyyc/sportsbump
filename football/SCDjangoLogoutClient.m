//
//  SCDjangoLogoutClient.m
//  football
//
//  Created by Andy Chen on 9/20/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCDjangoLogoutClient.h"

@interface SCDjangoLogoutClient()

// Private properties
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation SCDjangoLogoutClient

- (id)initWithURL:(NSString *)logoutUrl
{
  self = [super init];
  if (self) {
    _requestURL = [NSURL URLWithString:logoutUrl];
  }
  
  return self;
}

- (void)logout
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults removeObjectForKey:@"username"];
  [userDefaults removeObjectForKey:@"key"];
  [userDefaults synchronize];
  
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_requestURL];
  
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
                                          [_delegate logoutSuccessWithResponse:httpResp andBody:jsonDict];
                                        });
                                      } else {
                                        // alert for error saving / updating note
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          if ([_delegate respondsToSelector:@selector(logoutFailedWithResponse:andBody:)]) {
                                            [_delegate logoutFailedWithResponse:httpResp andBody:jsonDict];
                                          }
                                        });
                                      }
                                    }];
  
  [dataTask resume];
}

@end
