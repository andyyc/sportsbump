//
//  SCFeedItemTableViewCell.m
//  football
//
//  Created by Andy Chen on 9/27/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCFeedItemTableViewCell.h"

@implementation SCFeedItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
