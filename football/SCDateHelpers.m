//
//  SCDateHelpers.m
//  football
//
//  Created by Andy Chen on 9/27/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCDateHelpers.h"

NSString *createdTimeAgo(NSDate *createdAt)
{
  if (!createdAt) {
    return nil;
  }
  
  NSTimeInterval createdTimeFromNowSeconds = [createdAt timeIntervalSinceNow];
  
  // Get the system calendar
  NSCalendar *sysCalendar = [NSCalendar currentCalendar];
  
  // Create the NSDates
  NSDate *date1 = [[NSDate alloc] init];
  NSDate *date2 = [[NSDate alloc] initWithTimeInterval:createdTimeFromNowSeconds sinceDate:date1];
  
  // Get conversion to months, days, hours, minutes
  unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents *dateComponents = [sysCalendar components:unitFlags fromDate:date2  toDate:date1  options:0];
  
  if ([dateComponents year] > 0) {
    return [NSString stringWithFormat:@"%ldy", (long)[dateComponents year]];
  } else if ([dateComponents month] > 0) {
    return [NSString stringWithFormat:@"%ldm", (long)[dateComponents month]];
  } else if ([dateComponents day] > 0) {
    return [NSString stringWithFormat:@"%ldd", (long)[dateComponents day]];
  } else if ([dateComponents hour] > 0) {
    return [NSString stringWithFormat:@"%ldh", (long)[dateComponents hour]];
  } else if ([dateComponents minute] > 0) {
    return [NSString stringWithFormat:@"%ldm", (long)[dateComponents minute]];
  } else if ([dateComponents second] > 0) {
    return [NSString stringWithFormat:@"%lds", (long)[dateComponents second]];
  } else if ([dateComponents second] <= 0) {
    return @"now";
  }
  
  return nil;
}

NSDate *stringToDate(NSString *date)
{
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; //iso 8601 format
  return [dateFormat dateFromString:date];
}

@implementation SCDateHelpers

@end
