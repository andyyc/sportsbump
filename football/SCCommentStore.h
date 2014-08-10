//
//  SCCommentStore.h
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCCommentStoreDelegate<NSObject>

- (void)didFetchComments:(NSDictionary *)data;

@end

@interface SCCommentStore : NSObject<NSURLSessionDelegate>

@property (weak) id <SCCommentStoreDelegate> delegate;

- (void)fetchCommentsForGameKey:(NSString *)gameKey;

@end
