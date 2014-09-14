//
//  SCURLSession.h
//  football
//
//  Created by Andy Chen on 8/31/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCURLSession : NSObject<NSURLSessionDelegate>

- (NSURLSessionDataTask *)dataTaskWithAuthenticatedRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
