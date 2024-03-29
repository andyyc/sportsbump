//
//  SCCommentThread.h
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCComment.h"

@interface SCCommentThread : NSObject

@property (strong, nonatomic) NSMutableArray *commentIndex;
@property (strong, nonatomic) NSMutableDictionary *commentIdToCommentIndexMap;
@property (strong, nonatomic) NSMutableDictionary *commentIdToDataMap;

- (instancetype)initWithArray:(NSArray *)commentArray;
- (NSArray *)toggleCommentStartingAtIndex:(NSInteger)index collapsedComments:(NSMutableArray *)collapsedComments;

@end
