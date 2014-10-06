//
//  SCFeedItemTableViewCell.h
//  football
//
//  Created by Andy Chen on 9/27/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCFeedItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *feedText;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeAgo;
@property (weak, nonatomic) IBOutlet UIView *detailRightColumnView;

@end
