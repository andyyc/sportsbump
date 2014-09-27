//
//  SCFeedTableViewController.m
//  football
//
//  Created by Andy Chen on 9/25/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCFeedTableViewController.h"
#import "SCURLSession.h"
#import "SCPlay.h"
#import "SCFeedItemTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SCDateHelpers.h"

#define URL_FEED kBaseURL @"/api/feed"

@interface SCFeedTableViewController ()

@property (nonatomic, strong) NSMutableArray *feed;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation SCFeedTableViewController

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
  self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  _feed = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self _fetchFeed];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.feed.count;
}

#pragma mark - Private

- (void)_fetchFeed
{
  SCURLSession *session = [[SCURLSession alloc] init];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_FEED]];
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithAuthenticatedRequest:request
                                                           completionHandler:^(NSData *data,
                                                                               NSURLResponse *response,
                                                                               NSError *error)
                                    {
                                      NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                      NSError *responseError;
                                      NSDictionary* jsonDict = [NSJSONSerialization
                                                                 JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                 error:&responseError];
                                      
                                      if (!error && httpResp.statusCode == 200) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          NSLog(@"%@", jsonDict);
                                          _feed = [[NSMutableArray alloc] init];
                                          for (NSDictionary *jsonPlay in jsonDict[@"results"]) {
                                            [self.feed addObject:[[SCPlay alloc] initWithJson:jsonPlay]];
                                          }
//                                          self.weekChoices = jsonDict[@"week_choices"];
//                                          self.weekChoiceIds = jsonDict[@"week_choice_ids"];
//                                          CGSize dateScrollViewSize = self.dateScrollView.frame.size;
//                                          self.dateScrollView.contentSize = CGSizeMake(dateScrollViewSize.width * self.weekChoices.count, dateScrollViewSize.height);
//                                          
//                                          for (NSInteger i = 0; i < self.weekChoices.count; ++i) {
//                                            [self.dateChoicesViews addObject:[NSNull null]];
//                                          }
//                                          [self loadVisiblePages];
//                                          [self _fetchAndReloadScoreboardForDate:0];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCFeedItemTableViewCell *cell;
  SCPlay *play = self.feed[indexPath.row];

  if (play.team) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"FeedItemCellWithImage" forIndexPath:indexPath];
    NSString *teamIconURLString = [NSString stringWithFormat:kFormatBaseURL, play.teamIcon];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:teamIconURLString]];
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"FeedItemCell" forIndexPath:indexPath];
  }
  
  // Configure the cell...
  cell.feedText.text = play.text;
  if (play.videoUrl) {
    cell.videoLabel.text = @"🎥";
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapVideo:)];
    [cell.videoLabel setUserInteractionEnabled:YES];
    [cell.videoLabel addGestureRecognizer:tapGestureRecognizer];
  } else {
    cell.videoLabel.text = @"";
  }
  
  cell.createdTimeAgo.text = createdTimeAgo(play.createdAt);

  return cell;
}

- (void) _handleTapVideo:(UITapGestureRecognizer *)gesture
{
  CGPoint location = [gesture locationInView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
  SCPlay *play = self.feed[indexPath.row];
  
  _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:play.videoUrl];
  
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
