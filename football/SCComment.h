//
//  SCComment.h
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCComment : NSObject

@property (assign, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *props;
@property (strong, nonatomic) SCComment *parent;
@property (strong, nonatomic) NSArray *children;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger depth;


-(instancetype) initWithCommentId:(NSString *)commentId
                         username:(NSString *)username
                             text:(NSString *)text;

@end
