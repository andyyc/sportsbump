//
//  SCLoginViewController.m
//  football
//
//  Created by Andy Chen on 7/29/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCDjangoLoginClient.h"

#define LOGIN_URL @"http://localhost:8888/rest-auth/login/"

@interface SCLoginViewController ()

@end

@implementation SCLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSubmitButton:(id)sender
{
  if ([self _validateInputs]) {
    _authClient = [[SCDjangoLoginClient alloc] initWithURL:LOGIN_URL
                                              forUsername:_username.text
                                              andPassword:_password.text];
    _authClient.delegate = self;
    [_authClient login];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                    message:@"Enter a username and password. Sign up if you don't have one!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  }
}

- (IBAction)didTapCancelButton:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)_validateInputs {
  // Ensure that something has been entered in the username and password fields
  if (![_username.text isEqualToString:@""] && ![_password.text isEqualToString:@""]) {
    return YES;
  }
  
  return NO;
}

#pragma mark - SCDjangoLoginClientDelegate

- (void)loginSuccessWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginFailedWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                  message:@"Sorry! Wrong username or password."
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
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
