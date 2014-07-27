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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
