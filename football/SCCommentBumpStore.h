//
//  SCCommentBumpStore.h
//  football
//
//  Created by Andy Chen on 8/17/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCCommentBumpStoreDelegate<NSObject>

@optional
- (void)didPostCommentBump:(NSDictionary *)data;
- (void)failedToPostCommentBump:(NSDictionary *)data;

@end

@interface SCCommentBumpStore : NSObject<NSURLSessionDelegate>

@property (weak) id <SCCommentBumpStoreDelegate> delegate;

- (void)postCommentBumpForComment:(NSString *)commentId isRemoved:(BOOL)isRemoved;

@end
