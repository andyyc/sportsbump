//
//  SCCommentTableViewController.h
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCommentStore.h"
#import "SCGame.h"
#import "SCCommentBumpStore.h"
#import "SCCommentThread.h"

@interface SCCommentTableViewController : UITableViewController<SCCommentStoreDelegate, SCCommentBumpStoreDelegate>

@property (strong, nonatomic) SCCommentThread *commentThread;
@property (assign, nonatomic) NSInteger postId;
@property (strong, nonatomic) NSString *titleText;

- (void)didFetchComments:(NSArray *)data;

@end
