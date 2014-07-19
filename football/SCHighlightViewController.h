//
//  SCHighlightViewController.h
//  football
//
//  Created by Andy Chen on 7/10/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHighlightViewController : UIViewController

@property (nonatomic, strong) NSDictionary *play;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;

@end
