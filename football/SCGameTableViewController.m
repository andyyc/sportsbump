//
//  SCGameTableViewController.m
//  football
//
//  Created by Andy Chen on 7/9/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCGameTableViewController.h"
#import "SCGameTableViewCell.h"
#import "SCHighlightViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFNetworking.h"

NSString *URL_GAME_SUMMARY = @"http://localhost:8888/api/game/%@";

@interface SCGameTableViewController ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation SCGameTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:URL_GAME_SUMMARY, self.game[@"gamekey"]]]];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  operation.responseSerializer = [AFJSONResponseSerializer serializer];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"%@", responseObject);
    self.game = responseObject;
    self.summary = self.game[@"summary"];
    [self.tableView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Request Failed: %@, %@", error, error.userInfo);
  }];
  
  [operation start];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return self.summary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return ((NSArray *)self.summary[section][@"plays"]).count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Configure the cell...
  long row = [indexPath row];
  long section = [indexPath section];
  
  NSDictionary *play = self.summary[section][@"plays"][row];
  SCGameTableViewCell *playCell;
  
  if (play[@"video"] && [(NSString *)play[@"video"] length] > 0) {
    playCell = [tableView dequeueReusableCellWithIdentifier:@"PlayCellWithVideo" forIndexPath:indexPath];
    playCell.videoLabel.text = @"🎥";
  } else {
    playCell = [tableView dequeueReusableCellWithIdentifier:@"PlayCell" forIndexPath:indexPath];
    playCell.videoLabel.text = @"";
  }
  
  playCell.timeLabel.text = play[@"time"];
  
  if (play[@"down"] && [(NSString *)play[@"down"] length] > 0) {
    playCell.playLabel.text = [NSString stringWithFormat:@"%@. %@", play[@"down"], play[@"text"]];
  } else {
    playCell.playLabel.text = play[@"text"];
  }
  
  return playCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return self.summary[section][@"quarter"];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // [self.parentViewController performSegueWithIdentifier:@"PlayToHighlightSegue" sender:self];
  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;
  NSDictionary *play = self.summary[section][@"plays"][row];
  NSURL *videoUrl = [NSURL URLWithString:play[@"video"]];
  
  _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
  
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

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
  MPMoviePlayerController *player = [notification object];
  
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:MPMoviePlayerPlaybackDidFinishNotification
   object:player];
  
  [player.view removeFromSuperview];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
}


@end
