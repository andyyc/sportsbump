//
//  SCHighlightViewController.m
//  football
//
//  Created by Andy Chen on 7/10/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCHighlightViewController.h"

@interface SCHighlightViewController ()

@end

@implementation SCHighlightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  NSString *fullURL = self.play[@"video"];
  NSURL *url = [NSURL URLWithString:fullURL];
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
  [self.webView loadRequest:requestObj];
  self.webView.scrollView.scrollEnabled = NO;
  self.playLabel.text = self.play[@"text"];
  self.navigationItem.title = @"Highlight";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
