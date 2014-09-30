//
//  SCFeed.m
//  football
//
//  Created by Andy Chen on 9/28/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCFeed.h"
#import "SCPlay.h"

@implementation SCFeed

- (instancetype)initWithJson:(NSArray *)jsonArray
{
  if (self = [super init]) {
    _items = [[NSMutableArray alloc] init];
    _itemIdMapToItem = [[NSMutableDictionary alloc] init];
    [self addJson:jsonArray];
  }
  
  return self;
}

- (NSArray *)addJson:(NSArray *)jsonArray
{
  return [self _addResultsJsonToItems:jsonArray];
}

- (NSArray *)_addResultsJsonToItems:(NSArray *)results
{
  NSMutableArray *insertedIndices = [[NSMutableArray alloc] init];
  
  for (NSDictionary *jsonPlay in results) {
    SCPlay *play = [[SCPlay alloc] initWithJson:jsonPlay];
    
    if (_itemIdMapToItem[play.playId] == nil) {
      [insertedIndices addObject:@(_items.count)];
      [_items addObject:play];
      _itemIdMapToItem[play.playId] = play;
    }
  }
  
  return insertedIndices;
}

@end
