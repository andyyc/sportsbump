//
//  SCCommentTableViewCell.m
//  football
//
//  Created by Andy Chen on 7/25/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCCommentTableViewCell.h"

@implementation SCCommentTableViewCell

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

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  float indentPoints = self.indentationLevel * 10;
  
  self.cellView.frame = CGRectMake(indentPoints,
                                      self.cellView.frame.origin.y,
                                      self.cellView.frame.size.width - indentPoints,
                                      self.cellView.frame.size.height);
}

@end
