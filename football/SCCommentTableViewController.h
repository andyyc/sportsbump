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

@interface SCCommentTableViewController : UITableViewController<SCCommentStoreDelegate, SCCommentBumpStoreDelegate>

@property (nonatomic, strong) SCGame *game;

- (void)didFetchComments:(NSArray *)data;

@end
