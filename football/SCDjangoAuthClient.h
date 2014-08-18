//
//  SCDjangoAuthClient.h
//  football
//
//  Created by Andy Chen on 7/29/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notifications
extern NSString * const DjangoAuthClientDidLoginSuccessfully;
extern NSString * const DjangoAuthClientDidFailToLogin;
extern NSString * const DjangoAuthClientDidFailToCreateConnectionToAuthURL;

// Login failure reasons
extern NSString *const kDjangoAuthClientLoginFailureInvalidCredentials;
extern NSString *const kDjangoAuthClientLoginFailureInactiveAccount;

@class SCDjangoAuthLoginResult;

// Delegate definition
@protocol SCDjangoAuthClientDelegate <NSObject>

@optional
- (void)loginSuccessful:(SCDjangoAuthLoginResult *)result;
- (void)loginFailed:(SCDjangoAuthLoginResult*)result;

@end

// Client class definition
@interface SCDjangoAuthClient : NSObject <NSURLConnectionDelegate>

@property (unsafe_unretained) id <SCDjangoAuthClientDelegate> delegate;

@property (nonatomic, copy) NSData *requestBodyData;
@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, strong) NSMutableData *responseData;

- (id)initWithURL:(NSString *)loginURL forUsername:(NSString *)username andPassword:(NSString *)password;
- (void)login;

@end