//
//  SCDjangoRegisterClient.h
//  football
//
//  Created by Andy Chen on 7/30/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCDjangoRegisterClientDelegate<NSObject>

- (void)registerSuccessWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data;

@optional
- (void)registerFailedWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data;

@end

@interface SCDjangoRegisterClient : NSObject

@property (weak) id <SCDjangoRegisterClientDelegate> delegate;
@property (nonatomic, strong) NSString *requestURL;
@property (nonatomic, strong) NSMutableData *responseData;

- (id)initWithURL:(NSString *)registerUrl forUsername:(NSString *)username andEmail:(NSString *)email andPassword:(NSString *)password andRepeatPassword:(NSString *)repeatPassword;
- (void)register;

@end
