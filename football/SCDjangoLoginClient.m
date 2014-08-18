//
//  SCDjangoLoginClient.m
//  football
//
//  Created by Andy Chen on 8/3/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCDjangoLoginClient.h"

@interface SCDjangoLoginClient()

// Private properties
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation SCDjangoLoginClient

- (id)initWithURL:(NSString *)loginURL forUsername:(NSString *)username andPassword:(NSString *)password
{
  self = [super init];
  if (self) {
    _requestURL = [NSURL URLWithString:loginURL];
    _username = username;
    _password = password;
  }
  
  return self;
}

- (void)login
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_requestURL];
  [request setHTTPMethod:@"POST"];
  NSDictionary *postDictionary = @{@"username": self.username,
                                   @"password": self.password,
                                   };
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
    
    if (!error && httpResp.statusCode == 200) {
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setObject:self.username forKey:@"username"];
      [userDefaults setObject:jsonDict[@"key"] forKey:@"key"];
      [userDefaults synchronize];
      dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate loginSuccessWithResponse:httpResp andBody:jsonDict];
      });
    } else {
      // alert for error saving / updating note
      dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate loginFailedWithResponse:httpResp andBody:jsonDict];
      });
    }
  }];
  
  [dataTask resume];
}

@end
