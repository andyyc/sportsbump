//
//  SCGameTableViewController.h
//  football
//
//  Created by Andy Chen on 7/9/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGame.h"
#import "SCGameSummary.h"

@interface SCGameTableViewController : UITableViewController

@property (nonatomic, strong) SCGameSummary *summary;
@property (nonatomic, strong) SCGame *game;

@end
