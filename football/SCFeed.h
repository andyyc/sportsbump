//
//  SCFeed.h
//  football
//
//  Created by Andy Chen on 9/28/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFeed : NSObject

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *itemIdMapToItem;

- (instancetype)initWithJson:(NSArray *)jsonArray;
- (NSArray *)addJson:(NSArray *)jsonArray;

@end
