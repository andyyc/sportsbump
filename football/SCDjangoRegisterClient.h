//
//  SCDjangoRegisterClient.h
//  football
//
//  Created by Andy Chen on 7/30/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDjangoRegisterClient : NSObject

@property (nonatomic, strong) NSString *requestURL;
@property (nonatomic, strong) NSMutableData *responseData;

- (id)initWithURL:(NSString *)registerUrl forUsername:(NSString *)username andEmail:(NSString *)email andPassword:(NSString *)password andRepeatPassword:(NSString *)repeatPassword;
- (void)register;

@end
