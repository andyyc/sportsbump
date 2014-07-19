//
//  SCGameViewController.h
//  football
//
//  Created by Andy Chen on 7/18/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGameViewController : UIViewController

@property (strong, nonatomic) NSDictionary *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
