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

- (NSUInteger)count
{
  return [_items count];
}

- (NSArray *)addJson:(NSArray *)jsonArray
{
  return [self addJson:jsonArray atIndex:_items.count];
}

- (NSArray *)addJson:(NSArray *)jsonArray atIndex:(NSUInteger)index
{
  NSMutableArray *insertedIndices = [[NSMutableArray alloc] init];
  
  for (NSDictionary *jsonPlay in jsonArray) {
    SCPlay *play = [[SCPlay alloc] initWithJson:jsonPlay];
    
    if (_itemIdMapToItem[play.playId] == nil) {
      [_items insertObject:play atIndex:index];
      _itemIdMapToItem[play.playId] = play;
      [insertedIndices addObject:@(index)];
      index++;
    }
  }
  
  return insertedIndices;
}


@end
