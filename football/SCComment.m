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
    _points = [json[@"points_derived"] integerValue];
    _postId = [json[@"post"] integerValue];
    _created = [self _stringToDate:json[@"created_at"]];
    _hasBumped = [json[@"has_bumped"] boolValue];
  }
  
  return self;
}

- (NSDate *)_stringToDate:(NSString *)date
{
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; //iso 8601 format
  return [dateFormat dateFromString:date];
}

- (NSString *)createdTimeAgo
{
  if (!self.created) {
    return nil;
  }
  
  NSTimeInterval createdTimeFromNowSeconds = [self.created timeIntervalSinceNow];
  
  // Get the system calendar
  NSCalendar *sysCalendar = [NSCalendar currentCalendar];
  
  // Create the NSDates
  NSDate *date1 = [[NSDate alloc] init];
  NSDate *date2 = [[NSDate alloc] initWithTimeInterval:createdTimeFromNowSeconds sinceDate:date1];
  
  // Get conversion to months, days, hours, minutes
  unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents *dateComponents = [sysCalendar components:unitFlags fromDate:date2  toDate:date1  options:0];

  if ([dateComponents year] > 0) {
    return [NSString stringWithFormat:@"%dy", [dateComponents year]];
  } else if ([dateComponents month] > 0) {
    return [NSString stringWithFormat:@"%dm", [dateComponents month]];
  } else if ([dateComponents day] > 0) {
    return [NSString stringWithFormat:@"%dd", [dateComponents day]];
  } else if ([dateComponents hour] > 0) {
    return [NSString stringWithFormat:@"%dh", [dateComponents hour]];
  } else if ([dateComponents minute] > 0) {
    return [NSString stringWithFormat:@"%dm", [dateComponents minute]];
  } else if ([dateComponents second] > 0) {
    return [NSString stringWithFormat:@"%ds", [dateComponents second]];
  }
  
  return nil;
}

@end
