//
//  SCDjangoLoginClient.h
//  football
//
//  Created by Andy Chen on 8/3/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCDjangoLoginClientDelegate<NSObject>

- (void)loginSuccessWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data;

@optional
- (void)loginFailedWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data;

@end

@interface SCDjangoLoginClient : NSObject<NSURLSessionDelegate>

@property (weak) id <SCDjangoLoginClientDelegate> delegate;

@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, strong) NSMutableData *responseData;

- (id)initWithURL:(NSString *)loginURL forUsername:(NSString *)username andPassword:(NSString *)password;
- (void)login;

@end
