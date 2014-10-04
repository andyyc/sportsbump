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
#import "SCFeed.h"
#import "SCFeedStore.h"
#import "SCPostTableViewController.h"

@interface SCFeedTableViewController ()

@property (nonatomic, strong) SCFeedStore *feedStore;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) SCFeedItemTableViewCell *dummyCell;
@property (strong, nonatomic) SCFeedItemTableViewCell *dummyCellWithImage;

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
  _feedStore = [[SCFeedStore alloc] init];
  _feedStore.delegate = self;
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(_fetchFeedWithFeedStore)
                forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self _fetchFeedWithFeedStore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCPlay *play = self.feedStore.feed.items[indexPath.row];
  SCFeedItemTableViewCell *dummyCell = [self _dummyCellForPlay:play];
  
  [self configureCell:dummyCell forRowAtIndexPath:indexPath];
  [dummyCell layoutIfNeeded];
  
  CGSize size = [dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  
  return size.height+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.feedStore.feed.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCFeedItemTableViewCell *cell;
  SCPlay *play = self.feedStore.feed.items[indexPath.row];
  
  if (play.team && play.teamIcon) {
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedItemCellWithImage" forIndexPath:indexPath];
  } else {
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedItemCell" forIndexPath:indexPath];
  }
  
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  if (play.team && play.teamIcon) {
    NSString *teamIconURLString = [NSString stringWithFormat:kFormatBaseURL, play.teamIcon];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:teamIconURLString]];
  }
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapVideo:)];
  [cell.videoLabel setUserInteractionEnabled:YES];
  [cell.videoLabel addGestureRecognizer:tapGestureRecognizer];

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  // check if indexPath.row is last row
  // Perform operation to load new Cell's.
  if (indexPath.row == [self.feedStore.feed.items count] - 1) {
    [self.feedStore fetchNextFeed];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"FeedToPostSegue" sender:self];
}

- (void)configureCell:(SCFeedItemTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCPlay *play = self.feedStore.feed.items[indexPath.row];
  
  // Configure the cell...
  cell.feedText.text = play.text;
  if (play.videoUrl) {
    cell.videoLabel.text = @"🎥";
  } else {
    cell.videoLabel.text = @"";
  }
  
  cell.createdTimeAgo.text = createdTimeAgo(play.createdAt);
 
}

#pragma mark - Private

- (void)_fetchFeedWithFeedStore
{
  [_feedStore fetchFeed];
}

- (void) _handleTapVideo:(UITapGestureRecognizer *)gesture
{
  CGPoint location = [gesture locationInView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
  SCPlay *play = self.feedStore.feed.items[indexPath.row];
  
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

- (SCFeedItemTableViewCell *)_dummyCellForPlay:(SCPlay *)play
{
  if (play.team && play.teamIcon) {
    if (!_dummyCellWithImage) {
      _dummyCellWithImage = (SCFeedItemTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"FeedItemCellWithImage"];
    }
    return _dummyCellWithImage;
  } else {
    if (!_dummyCell) {
      _dummyCell = (SCFeedItemTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"FeedItemCell"];
    }
    return _dummyCell;
  }
}

#pragma mark - MPMoviePlayer

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
  
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:MPMoviePlayerPlaybackDidFinishNotification
   object:_moviePlayer];
  
  [_moviePlayer.view removeFromSuperview];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"FeedToPostSegue"]) {
    SCPostTableViewController *postTableViewController = [segue destinationViewController];
    
    NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
    SCPlay *play = self.feedStore.feed.items[selectedRow.row];
    postTableViewController.titleText = play.text;
    postTableViewController.videoUrl = play.videoUrl;
    postTableViewController.createdDate = play.createdAt;
    postTableViewController.postId = [play.postId integerValue];
  }
}

#pragma mark - SCFeedStoreDelegate

- (void)didFinishFetchingFeed:(SCFeedStore *)feedStore
{
  [self.refreshControl endRefreshing];
  [self.tableView reloadData];
}

- (void)didFailFetchingFeed:(SCFeedStore *)feedStore
{
  [self.refreshControl endRefreshing];
}

- (void)feedStore:(SCFeedStore *)feedStore didFinishFetchingNextInsertedIndices:(NSArray *)insertedIndices
{
  NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
  
  for (NSNumber *index in insertedIndices) {
    [insertIndexPaths addObject:[NSIndexPath indexPathForRow:[index intValue] inSection:0]];
  }
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
  [self.tableView endUpdates];
}

@end
