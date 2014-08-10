//
//  SCDjangoRegisterClient.m
//  football
//
//  Created by Andy Chen on 7/30/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCDjangoRegisterClient.h"
#import "AFNetworking.h"

@interface SCDjangoRegisterClient()

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
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
  
  NSDictionary *params = @{@"username": self.username,
                           @"email": self.email,
                           @"password": self.password,
                           };
  
  // register again
  [manager POST:self.requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"success");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:responseObject[@"username"] forKey:@"username"];
    [userDefaults setObject:responseObject[@"email"] forKey:@"email"];
    [userDefaults setObject:responseObject[@"key"]  forKey:@"key"];
    [userDefaults synchronize];
  } failure:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSHTTPURLResponse *urlResponse = operation.response;
    
    if (urlResponse.statusCode == 400) {
      // missing fields
    } else {
      // some other error
    }
    NSLog(@"%@", [NSString stringWithUTF8String:[operation.responseData bytes]]);
    if (operation.response.statusCode == 400) {
      NSLog(@"error more info");
    }
  }];
  /*
  [manager GET:self.requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSHTTPURLResponse *urlResponse = operation.response;
    
    if (urlResponse.statusCode == 200) {
      if (!_csrfToken) {
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[urlResponse allHeaderFields] forURL:[NSURL URLWithString:self.requestURL]];
        
        // Django defaults to CSRF protection, so we need to get the token to send back in the request
        NSHTTPCookie *csrfCookie;
        for (NSHTTPCookie *cookie in cookies) {
          if ([cookie.name isEqualToString:@"csrftoken"]) {
            csrfCookie = cookie;
          }
        }
        
        NSDictionary *params = @{@"username": self.username,
                                 @"email": self.email,
                                 @"password1": self.password,
                                 @"password2": self.repeatPassword,
                                 @"csrfmiddlewaretoken": csrfCookie.value
                                 };
        
        // register again
        [manager POST:self.requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"success");
          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
          [userDefaults setObject:self.username forKey:@"username"];
          [userDefaults setObject:self.email forKey:@"email"];
          [userDefaults synchronize];
        } failure:^(AFHTTPRequestOperation *operation, id responseObject){
          NSLog(@"error registering");
        }];
      }
      
      // We're logged in and good to go
//      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//      
//      [userDefaults synchronize];
//      if ([_delegate respondsToSelector:@selector(loginSuccessful:)]) {
//        [_delegate loginSuccessful:resultObject];
//      }
//      [[NSNotificationCenter defaultCenter] postNotificationName:DjangoAuthClientDidLoginSuccessfully object:resultObject];
    } else {
      // failed
    }
//    else if (resultObject.statusCode == 401) {      
//      // Check to see if we've already made an attempt to log in and failed
//      if ([[resultObject.responseHeaders objectForKey:@"Auth-Response"] isEqualToString:@"Login failed"]) {
//        resultObject.loginFailureReason = kDjangoAuthClientLoginFailureInvalidCredentials;
//        if ([_delegate respondsToSelector:@selector(loginFailed:)]) {
//          [_delegate loginFailed:resultObject];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:DjangoAuthClientDidFailToLogin object:resultObject];
//      }
//      else {
//        // Initial login attempt
//        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:resultObject.responseHeaders forURL:self.requestURL];
//        
//        // Django defaults to CSRF protection, so we need to get the token to send back in the request
//        NSHTTPCookie *csrfCookie;
//        for (NSHTTPCookie *cookie in cookies) {
//          if ([cookie.name isEqualToString:@"csrftoken"]) {
//            csrfCookie = cookie;
//          }
//        }
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.requestURL];
//        [request setHTTPMethod:@"POST"];
//        
//        NSString *authString = [NSString stringWithFormat:@"username=%@;password=%@;csrfmiddlewaretoken=%@;", _username, _password, csrfCookie.value, nil];
//        [request setHTTPBody:[authString dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [self makeLoginRequest:request];
//      }
//    }
//    else if (resultObject.statusCode == 403) {
//      // Login failed because the user's account is inactive
//      resultObject.loginFailureReason = kDjangoAuthClientLoginFailureInactiveAccount;
//      if ([_delegate respondsToSelector:@selector(loginFailed:)]) {
//        [_delegate loginFailed:resultObject];
//      }
//    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
   */
}



@end
