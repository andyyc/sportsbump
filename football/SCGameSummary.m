//
//  SCGameSummary.m
//  football
//
//  Created by Andy Chen on 8/17/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCGameSummary.h"
#import "SCPlay.h"

@implementation SCGameSummary

- (instancetype)initWithJson:(NSArray *)jsonArray
{
  if (self = [super init]) {
    _quartersToPlaysMap = [[NSMutableDictionary alloc] init];
    _quarters = [[NSMutableArray alloc] init];

    for (NSDictionary *playJson in jsonArray) {
      SCPlay *play = [[SCPlay alloc] initWithJson:playJson];
      
      if (!_quartersToPlaysMap[play.quarter]) {
        _quartersToPlaysMap[play.quarter] = [[NSMutableArray alloc] init];
        [_quarters addObject:play.quarter];
      }
      [_quartersToPlaysMap[play.quarter] addObject:play];
    }
  }
  
  return self;
}

- (NSArray *)playsForSection:(NSInteger)section
{
  if (_quarters.count > 0) {
    NSString *quarter = _quarters[section];
    return _quartersToPlaysMap[quarter];
  }
  
  return nil;
}

@end
