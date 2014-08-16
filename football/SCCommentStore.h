//
//  SCCommentStore.h
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCComment;

@protocol SCCommentStoreDelegate<NSObject>

@optional
- (void)didFetchComments:(NSArray *)data;
- (void)didPostComment:(NSDictionary *)data;

@end

@interface SCCommentStore : NSObject<NSURLSessionDelegate>

@property (weak) id <SCCommentStoreDelegate> delegate;

- (void)fetchCommentsForGameKey:(NSString *)gameKey;

- (void)postCommentText:(NSString *)text forPost:(NSString *)postId andParent:(SCComment *)parent;

@end
