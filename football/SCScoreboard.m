//
//  SCScoreboard.m
//  football
//
//  Created by Andy Chen on 8/16/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCScoreboard.h"
#import "SCGame.h"

@implementation SCScoreboard

- (instancetype)initWithGamesArray:(NSArray *)gamesArray
{
  if (self = [super init]) {
    _dateToGamesMap = [[NSMutableDictionary alloc] init];
    _sectionsByDate = [[NSMutableArray alloc] init];
    
    for (NSDictionary *gameJson in gamesArray) {
      SCGame *game = [[SCGame alloc] initWithJson:gameJson];
      NSDate *gameDate = game.date;
      
      if (!_dateToGamesMap[gameDate]) {
        _dateToGamesMap[gameDate] = [[NSMutableArray alloc] init];
        [_sectionsByDate addObject:gameDate];
      }
      
      [_dateToGamesMap[gameDate] addObject:game];
    }
  }
  
  return self;
}

- (SCGame *)gameForSection:(NSInteger)section andRow:(NSInteger)row
{
  NSDate *date = _sectionsByDate[section];
  return _dateToGamesMap[date][row];
}

- (NSArray *)gamesForSection:(NSInteger)section
{
  NSDate *date = _sectionsByDate[section];
  return _dateToGamesMap[date];
}

@end
