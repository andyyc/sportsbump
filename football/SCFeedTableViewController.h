//
//  SCFeedTableViewController.h
//  football
//
//  Created by Andy Chen on 9/25/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFeedStore.h"

@interface SCFeedTableViewController : UITableViewController<SCFeedStoreDelegate>

- (void)didFinishFetchingFeed:(SCFeedStore *)feedStore;
- (void)didFailFetchingFeed:(SCFeedStore *)feedStore;

- (void)feedStore:(SCFeedStore *)feedStore didFinishFetchingFeedInsertedIndices:(NSArray *)insertedIndices;

@end
