//
//  SCLoginViewController.h
//  football
//
//  Created by Andy Chen on 7/29/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDjangoLoginClient.h"

@interface SCLoginViewController : UIViewController<SCDjangoLoginClientDelegate>

@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) SCDjangoLoginClient *authClient;

- (IBAction)didTapSubmitButton:(id)sender;
- (IBAction)didTapCancelButton:(id)sender;

- (void)loginSuccessWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data;
- (void)loginFailedWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data;

@end
