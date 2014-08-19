//
//  SCDjangoRegisterClient.m
//  football
//
//  Created by Andy Chen on 7/30/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCDjangoRegisterClient.h"
#import "NSURLSessionConfiguration+NSURLSessionConfigurationAdditions.h"

@interface SCDjangoRegisterClient()<NSURLSessionDelegate>

// Private properties
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *repeatPassword;
@property (nonatomic, strong) NSString *csrfToken;

@end

@implementation SCDjangoRegisterClient

- (id)initWithURL:(NSString *)registerUrl forUsername:(NSString *)username andEmail:(NSString *)email andPassword:(NSString *)password andRepeatPassword:(NSString *)repeatPassword
{
  self = [super init];
  if (!self) {
    return nil;
  }
  
  _username = username;
  _email = email;
  _password = password;
  _repeatPassword = repeatPassword;
  _requestURL = registerUrl;
  _responseData = [[NSMutableData alloc] initWithCapacity:512];
  
  return self;
}

- (void)register
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration sessionConfigurationWithToken];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestURL]];
  [request setHTTPMethod:@"POST"];
  NSDictionary *params = @{@"username": self.username,
                           @"email": self.email,
                           @"password": self.password,
                           };
  
  NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
  [request setHTTPBody:postData];
  
  NSURLSessionDataTask *dataTask =
    [session
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
          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
          [userDefaults setObject:jsonDict[@"username"] forKey:@"username"];
          [userDefaults setObject:jsonDict[@"key"]  forKey:@"key"];
          [userDefaults synchronize];
          [_delegate registerSuccessWithResponse:httpResp andBody:jsonDict];
        });
      } else {
        // alert for error saving / updating note
        dispatch_async(dispatch_get_main_queue(), ^{
          [_delegate registerFailedWithResponse:httpResp andBody:jsonDict];
        });
      }
    }];
  
  [dataTask resume];
}



@end
