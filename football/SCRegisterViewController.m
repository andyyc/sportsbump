//
//  SCRegisterViewController.m
//  football
//
//  Created by Andy Chen on 7/30/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCRegisterViewController.h"
#import "SCDjangoRegisterClient.h"

#define REGISTER_URL @"http://localhost:8888/rest-auth/register/"

@interface SCRegisterViewController ()

@property (nonatomic, strong) SCDjangoRegisterClient *registerClient;

@end

@implementation SCRegisterViewController

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

- (IBAction)registerButtonTapped:(id)sender
{
  if (![self _validateUsername]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username required"
                                                    message:@"Enter a username."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  } else if (![self _validateEmail]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email required"
                                                    message:@"Enter an email.  We won't spam you, this will be used to retrieve your password."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  } else if (![self _validatePasswordMatch]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords don't match"
                                                    message:@"Please reenter your password."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  } else {
    _registerClient = [[SCDjangoRegisterClient alloc] initWithURL:REGISTER_URL forUsername:_username.text andEmail:_email.text andPassword:_password.text andRepeatPassword:_repeatPassword.text];
  //  _registerClient.delegate = self;
    [_registerClient register];
  }
}

- (BOOL)_validateUsername
{
  return self.username.text.length > 0;
}

- (BOOL)_validateEmail
{
  return self.email.text.length > 0;
}

- (BOOL)_validatePasswordMatch
{
  return [self.password.text isEqualToString:self.repeatPassword.text];
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
