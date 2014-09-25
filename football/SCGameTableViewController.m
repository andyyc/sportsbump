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
#import "NSURLSessionConfiguration+NSURLSessionConfigurationAdditions.h"
#import "SCGame.h"
#import "SCPlay.h"

#ifdef DEBUG

NSString *URL_GAME_SUMMARY = @"http://localhost:8888/api/plays/?gamekey=%@";

#else

NSString *URL_GAME_SUMMARY = @"http://sportschub.com/api/plays/?gamekey=%@";

#endif

@interface SCGameTableViewController ()<NSURLSessionDelegate>

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
  
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration sessionConfigurationWithToken];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:URL_GAME_SUMMARY, self.game.gamekey]]];

  
  NSURLSessionDataTask *dataTask =
  [session
   dataTaskWithRequest:request
   completionHandler:^(NSData *data,
                       NSURLResponse *response,
                       NSError *error)
   {
     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
     NSError *responseError;
     NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&responseError];
     
     if (!error && httpResp.statusCode == 200) {
       dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"%@", jsonDict);
         self.summary = [[SCGameSummary alloc] initWithJson:jsonDict];
         [self.tableView reloadData];
       });
     } else {
       // alert for error saving / updating note
       dispatch_async(dispatch_get_main_queue(), ^{
       });
     }
   }];
  
  [dataTask resume];
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
  return self.summary.quarters.count > 0 ? self.summary.quarters.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [[self.summary playsForSection:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Configure the cell...
  long row = [indexPath row];
  long section = [indexPath section];
  
  SCPlay *play = [self.summary playsForSection:section][row];
  SCGameTableViewCell *playCell;
  
  if (play.videoUrl) {
    playCell = [tableView dequeueReusableCellWithIdentifier:@"PlayCellWithVideo" forIndexPath:indexPath];
    playCell.videoLabel.text = @"🎥";
  } else {
    playCell = [tableView dequeueReusableCellWithIdentifier:@"PlayCell" forIndexPath:indexPath];
    playCell.videoLabel.text = @"";
  }
  
  playCell.timeLabel.text = play.time;
  
  if (play.down && play.down.length > 0) {
    playCell.playLabel.text = [NSString stringWithFormat:@"%@. %@", play.down, play.text];
  } else {
    playCell.playLabel.text = play.text;
  }
  
  return playCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (self.summary.quarters.count > 0) {
    if ([self.summary.quarters[section] isEqualToString:@"1"]) {
      return @"1st Quarter";
    } else if ([self.summary.quarters[section] isEqualToString:@"2"]) {
      return @"2nd Quarter";
    } else if ([self.summary.quarters[section] isEqualToString:@"3"]) {
      return @"3rd Quarter";
    } else if ([self.summary.quarters[section] isEqualToString:@"4"]) {
      return @"4th Quarter";
    } else if ([self.summary.quarters[section] isEqualToString:@"5"]) {
      return @"Overtime";
    }
  }
  
  return nil;
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // [self.parentViewController performSegueWithIdentifier:@"PlayToHighlightSegue" sender:self];
  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;
  SCPlay *play = [self.summary playsForSection:section][row];
  
  _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:play.videoUrl];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:_moviePlayer];
  
  _moviePlayer.controlStyle = MPMovieControlStyleDefault;
  _moviePlayer.shouldAutoplay = YES;
  [self.view addSubview:_moviePlayer.view];
  [_moviePlayer setFullscreen:YES animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  UIView *view = [[UIView alloc] init];
  
  return view;
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
