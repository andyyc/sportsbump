//
//  SCScoreboard.h
//  football
//
//  Created by Andy Chen on 8/16/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCGame.h"

@interface SCScoreboard : NSObject

@property(strong, nonatomic) NSMutableArray *sectionsByDate;
@property(strong, nonatomic) NSMutableDictionary *dateToGamesMap;

- (instancetype)initWithGamesArray:(NSArray *)gamesArray;
- (NSArray *)gamesForSection:(NSInteger)section;
- (SCGame *)gameForSection:(NSInteger)section andRow:(NSInteger)row;

@end
