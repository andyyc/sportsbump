//
//  SCPostTableViewController.h
//  football
//
//  Created by Andy Chen on 9/30/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCCommentTableViewController.h"

@interface SCPostTableViewController : SCCommentTableViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UIView  *headerContainingView;

@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSURL *videoUrl;

@end
