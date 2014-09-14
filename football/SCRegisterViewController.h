//
//  SCRegisterViewController.h
//  football
//
//  Created by Andy Chen on 7/30/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDjangoRegisterClient.h"

@interface SCRegisterViewController : UIViewController<SCDjangoRegisterClientDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassword;

- (IBAction)registerButtonTapped:(id)sender;

@end
