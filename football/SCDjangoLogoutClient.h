//
//  SCDjangoLogoutClient.h
//  football
//
//  Created by Andy Chen on 9/20/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//  SCDjangoLoginClient.h
//  football
//
//  Created by Andy Chen on 8/3/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCDjangoLogoutClientDelegate<NSObject>

- (void)logoutSuccessWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data;

@optional
- (void)logoutFailedWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data;

@end

@interface SCDjangoLogoutClient : NSObject<NSURLSessionDelegate>

@property (weak) id <SCDjangoLogoutClientDelegate> delegate;

@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, strong) NSMutableData *responseData;

- (id)initWithURL:(NSString *)logoutUrl;
- (void)logout;

@end
