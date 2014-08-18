//
//  SCComment.h
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCComment : NSObject

@property (strong, nonatomic) NSString *commentId;
@property (assign, nonatomic) NSInteger postId;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) NSInteger points;
@property (assign, nonatomic) BOOL hasBumped;
@property (strong, nonatomic) NSDate * created;
@property (strong, nonatomic) SCComment *parent;
@property (strong, nonatomic) NSArray *children;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger depth;
@property (assign, nonatomic) BOOL shouldHideCommentText;

- (instancetype)initWithJson:(NSDictionary *)json;
- (NSString *)createdTimeAgo;

@end
