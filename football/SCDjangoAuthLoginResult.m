//
//  SCDjangoAuthLoginResult.m
//  football
//
//  Created by Andy Chen on 7/29/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCDjangoAuthLoginResult.h"

@implementation SCDjangoAuthLoginResult

+ (SCDjangoAuthLoginResult *)loginResultFromResponse:(NSURLResponse *)response {
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  
  SCDjangoAuthLoginResult *resultObject = [[SCDjangoAuthLoginResult alloc] init];
  resultObject.responseHeaders = [httpResponse allHeaderFields];
  resultObject.serverResponse = response;
  resultObject.statusCode = [httpResponse statusCode];
  
  return resultObject;
}

@end