//
//  SCScrollViewContainer.m
//  football
//
//  Created by Andy Chen on 7/19/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCScrollViewContainer.h"

@implementation SCScrollViewContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
  UIView *view = [super hitTest:point withEvent:event];
  if (view == self) {
    return self.scrollView;
  }
  return view;
}

@end
