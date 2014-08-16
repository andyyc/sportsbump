//
//  SCCommentComposerViewController.m
//  football
//
//  Created by Andy Chen on 8/10/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCCommentComposerViewController.h"
#import "SCComment.h"
#import "SCCommentStore.h"

@interface SCCommentComposerViewController ()

@end

@implementation SCCommentComposerViewController

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
  [self.inputText becomeFirstResponder];
  // Do any additional setup after loading the view.
  self.parentCommentPoints.text = [self.comment.points stringValue];
  self.parentCommentText.text = self.comment.text;
  self.parentCommentUsername.text =  self.comment.username;
  self.parentCommentCreatedTime.text = @"10m ago";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSubmit:(id)sender
{
  SCCommentStore *commentStore = [[SCCommentStore alloc] init];
  commentStore.delegate = self;
  
  [commentStore postCommentText:self.inputText.text forPost:self.comment.postId andParent:self.comment];
}

- (IBAction)didTapCancel:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SCCommentStoreDelegate

- (void)didPostComment:(NSDictionary *)data
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
