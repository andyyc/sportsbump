//
//  SCGame.m
//  football
//
//  Created by Andy Chen on 8/16/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCGame.h"

@implementation SCGame

- (instancetype)initWithJson:(NSDictionary *)json
{
  if (self = [super init]) {
    _name = json[@"name"];
    _score = json[@"score"];
    _dayOfWeek = json[@"day_of_week"];
    _awayTeam = json[@"away_team"];
    _homeTeam = json[@"home_team"];
    _homeTeamIcon = json[@"home_team_icon"];
    _awayTeamIcon = json[@"away_team_icon"];
    _week = [json[@"week"] intValue];
    _gameId = [json[@"id"] intValue];
    _gamekey = json[@"gamekey"];
    _postId = [json[@"post"] intValue];
    _date = [self _stringToDate:json[@"date"]];
  }
  
  return self;
}

- (NSDate *)_stringToDate:(NSString *)date
{
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd"]; //iso 8601 format
  return [dateFormat dateFromString:date];
}

@end
