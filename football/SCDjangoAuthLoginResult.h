//
//  SCDjangoAuthLoginResult.h
//  football
//
//  Created by Andy Chen on 7/29/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDjangoAuthLoginResult : NSObject

@property (nonatomic, strong) NSString *loginFailureReason;
@property (nonatomic, strong) NSDictionary *responseHeaders;
@property (nonatomic, strong) NSURLResponse *serverResponse;
@property (nonatomic, assign) NSInteger statusCode;

+ (SCDjangoAuthLoginResult *)loginResultFromResponse:(NSURLResponse *)response;

@end