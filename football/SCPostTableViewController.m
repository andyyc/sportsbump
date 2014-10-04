//
//  SCPostTableViewController.m
//  football
//
//  Created by Andy Chen on 9/30/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCPostTableViewController.h"
#import "SCCommentComposerViewController.h"
#import "SCComment.h"
#import "SCcommentThread.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SCDateHelpers.h"

@interface SCPostTableViewController ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation SCPostTableViewController

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
  self.titleLabel.text = self.titleText;
  self.createdTimeAgoLabel.text = createdTimeAgo(self.createdDate);
  
  if (self.videoUrl) {
      self.videoLabel.text = @"🎥";
    } else {
      self.videoLabel.text = @"";
    }
  
  [self.titleLabel sizeToFit];
  CGRect frame = self.headerContainingView.frame;
  CGSize size = [self.headerContainingView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
  frame.size.height = size.height;
  self.headerContainingView.frame = frame;
  [self.tableView setTableHeaderView:self.headerContainingView];
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapVideo:)];
  [self.videoLabel setUserInteractionEnabled:YES];
  [self.videoLabel addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  BOOL loggedIn = [userDefaults objectForKey:@"key"] != nil && [userDefaults objectForKey:@"username"] != nil;
  
  if (!loggedIn) {
    [self performSegueWithIdentifier:@"PostToLoginSegue" sender:self];
  } else {
    [self performSegueWithIdentifier:@"PostToComposerSegue" sender:self];
  }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"PostToComposerSegue"]) {
    UINavigationController *navController = [segue destinationViewController];
    SCCommentComposerViewController *composerViewController = [navController viewControllers][0];
    
    if ([sender isKindOfClass:[UIButton class]]) {
      // user tapped add comment
      SCComment *parentCommentForGameThread = [[SCComment alloc] init];
      parentCommentForGameThread.postId = self.postId;
      parentCommentForGameThread.text = self.titleText;
      composerViewController.comment = parentCommentForGameThread;
    } else {
      // user tapped row
      NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
      composerViewController.comment = self.commentThread.commentIndex[selectedRow.row];
    }
  }
}

#pragma mark - IBAction

- (IBAction)didTapAddComment:(id)sender
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *key = [userDefaults objectForKey:@"key"];
  BOOL loggedIn = key && key.length > 0;
  
  if (!loggedIn) {
    [self performSegueWithIdentifier:@"PostToLoginSegue" sender:sender];
  } else {
    [self performSegueWithIdentifier:@"PostToComposerSegue" sender:sender];
  }
}

#pragma mark - private

- (void)_handleTapVideo:(UITapGestureRecognizer *)gesture
{
  _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoUrl];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:_moviePlayer];
  
  _moviePlayer.controlStyle = MPMovieControlStyleDefault;
  _moviePlayer.shouldAutoplay = YES;
  [self.view addSubview:_moviePlayer.view];
  [_moviePlayer setFullscreen:YES animated:YES];
}

#pragma mark - MPMoviePlayer

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
  
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:MPMoviePlayerPlaybackDidFinishNotification
   object:_moviePlayer];
  
  [_moviePlayer.view removeFromSuperview];
}

@end
