//
//  SCGameTableViewCell.h
//  football
//
//  Created by Andy Chen on 7/9/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamIconView;

@end
