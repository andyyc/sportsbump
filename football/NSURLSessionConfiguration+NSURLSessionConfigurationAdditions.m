//
//  NSURLSessionConfiguration+NSURLSessionConfigurationAdditions.m
//  football
//
//  Created by Andy Chen on 8/19/14.
//  Copyright (c) 2014 ;. All rights reserved.
//

#import "NSURLSessionConfiguration+NSURLSessionConfigurationAdditions.h"

@implementation NSURLSessionConfiguration (NSURLSessionConfigurationAdditions)

+ (NSURLSessionConfiguration *)sessionConfigurationWithToken
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
  
  if (key.length > 0) {
    NSString *tokenValue = [NSString stringWithFormat:@"Token %@", key];
    [configuration setHTTPAdditionalHeaders:@{@"Authorization":tokenValue}];
  }
  
  return configuration;
}

@end
