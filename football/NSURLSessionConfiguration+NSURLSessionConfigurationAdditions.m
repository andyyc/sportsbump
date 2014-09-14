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
  NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
  
  headerDict[@"Content-Type"] = @"application/json";
  
  if (key.length > 0) {
    NSString *tokenValue = [NSString stringWithFormat:@"Token %@", key];
    headerDict[@"Authorization"] = tokenValue;
  }
  
  [configuration setHTTPAdditionalHeaders:headerDict];
  
  return configuration;
}

@end
