//
//  SCCommentTableViewCell.h
//  football
//
//  Created by Andy Chen on 7/25/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *props;
@property (weak, nonatomic) IBOutlet UILabel *toggleArrow;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end
