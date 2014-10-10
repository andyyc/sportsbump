//
//  SCFeedStore.h
//  football
//
//  Created by Andy Chen on 9/28/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCFeed, SCFeedStore;

@protocol SCFeedStoreDelegate<NSObject>

- (void)didFinishFetchingFeed:(SCFeedStore *)feedStore;
- (void)didFailFetchingFeed:(SCFeedStore *)feedStore;

- (void)feedStore:(SCFeedStore *)feedStore didFinishFetchingFeedInsertedIndices:(NSArray *)insertedIndices;

@end

@interface SCFeedStore : NSObject

@property (strong, nonatomic) SCFeed *feed;
@property (nonatomic, weak) id <SCFeedStoreDelegate> delegate;

- (void)fetchFeed;
- (void)fetchOlderFeed;

@end
