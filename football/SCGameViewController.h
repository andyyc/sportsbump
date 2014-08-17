//
//  SCGameViewController.h
//  football
//
//  Created by Andy Chen on 7/18/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGame.h"

@interface SCGameViewController : UIViewController

@property (strong, nonatomic) SCGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
