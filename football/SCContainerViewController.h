//
//  SCContainerViewController.h
//  football
//
//  Created by Andy Chen on 7/22/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGame.h"

@interface SCContainerViewController : UIViewController

@property (nonatomic, strong) SCGame *game;

- (void)selectedGameSegmentIndex:(NSInteger)index;

@end
