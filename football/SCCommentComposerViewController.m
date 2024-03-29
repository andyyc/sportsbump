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
#import "SCDateHelpers.h"

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
  self.parentCommentText.text = self.comment.text;
  CGSize sizeThatFitsTextView = [self.parentCommentText sizeThatFits:CGSizeMake(self.parentCommentText.frame.size.width, MAXFLOAT)];
  self.parentCommentTextHeightConstraint.constant = ceilf(sizeThatFitsTextView.height);
  self.parentCommentUsername.text = self.comment.username;
  
  if (self.comment.username) {
    self.parentCommentPoints.text = [NSString stringWithFormat:@"%d 👊", self.comment.points];
  } else {
    self.parentCommentPoints.text = nil;
  }
  
  NSString *createdTimeAgoString = createdTimeAgo(self.comment.createdAt);
  if (createdTimeAgoString) {
    self.parentCommentCreatedTime.text = [NSString stringWithFormat:@"∙ %@", createdTimeAgoString];
  } else {
    self.parentCommentCreatedTime.text = nil;
  }
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
