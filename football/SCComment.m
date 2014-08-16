//
//  SCComment.m
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCComment.h"

@implementation SCComment

-(instancetype) initWithJson:(NSDictionary *)json
{
  if (self = [super init]) {
    _commentId = json[@"id"];
    _username = json[@"author_name"];
    _text = json[@"text"];
    _points = json[@"points"];
    _postId = json[@"post"];
    _created = [self _stringToDate:json[@"created_at"]];
  }
  
  return self;
}

- (NSDate *)_stringToDate:(NSString *)date
{
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; //iso 8601 format
  return [dateFormat dateFromString:date];
}

@end
