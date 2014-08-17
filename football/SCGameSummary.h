//
//  SCGameSummary.h
//  football
//
//  Created by Andy Chen on 8/17/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCGameSummary : NSObject

@property (strong, nonatomic) NSMutableDictionary *quartersToPlaysMap;
@property (strong, nonatomic) NSMutableArray *quarters;

- (instancetype)initWithJson:(NSArray *)jsonArray;
- (NSArray *)playsForSection:(NSInteger)section;

@end
