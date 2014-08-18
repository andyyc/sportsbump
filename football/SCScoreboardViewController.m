//
//  SCScoreboardViewController.m
//  football
//
//  Created by Andy Chen on 7/19/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCScoreboardViewController.h"
#import "AFNetworking.h"
#import "SCScoreboardTableViewController.h"
#import "SCGameViewController.h"
#import "SCScoreboardTableViewController.h"
#import "SCScoreboard.h"

NSString *URL_SCORES = @"http://localhost:8888/api/week/%@";
NSString *URL_WEEK_CHOICES = @"http://localhost:8888/api/week-choices";

@interface SCScoreboardViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *dateScrollView;
@property (strong, nonatomic) NSArray *weekChoices;
@property (strong, nonatomic) NSArray *weekChoiceIds;
@property (strong, nonatomic) NSMutableArray *dateChoicesViews;
@property (strong, nonatomic) SCScoreboardTableViewController *scoreboardTableViewController;
@property (strong, nonatomic) AFHTTPRequestOperation *fetchScoreboardForDateOperation;

@end

@implementation SCScoreboardViewController

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
  self.navigationItem.title = @"Scores";
  self.dateChoicesViews = [[NSMutableArray alloc] init];
  [self _fetchWeekChoices];
  
  if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

#pragma mark - dateScrollView

- (void)loadVisiblePages {
  // First, determine which page is currently visible
  NSInteger page = [self currentPage];
  
  // Work out which pages you want to load
  NSInteger firstPage = page - 1;
  NSInteger lastPage = page + 1;
  
  // Purge anything before the first page
  for (NSInteger i=0; i<firstPage; i++) {
    [self purgePage:i];
  }
  for (NSInteger i=firstPage; i<=lastPage; i++) {
    [self loadPage:i];
  }
  for (NSInteger i=lastPage+1; i<self.weekChoices.count; i++) {
    [self purgePage:i];
  }
}

- (NSInteger)currentPage {
  CGFloat pageWidth = self.dateScrollView.frame.size.width;
  NSInteger page = floor((self.dateScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
  
  return page;
}

- (void)loadPage:(NSInteger)page {
  if (page < 0 || page >= self.weekChoices.count) {
    // If it's outside the range of what we have to display, then do nothing
    return;
  }
  
  // Load an individual page, first checking if you've already loaded it
  UIView *pageView = [self.dateChoicesViews objectAtIndex:page];
  if ((NSNull *)pageView == [NSNull null]) {
    CGRect frame = self.dateScrollView.bounds;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0.0f;
    // frame = CGRectInset(frame, 20.0f, 0.0f);
    
    UILabel *newPageView = [[UILabel alloc] initWithFrame:frame];
    newPageView.text = self.weekChoices[page];
    newPageView.textAlignment = NSTextAlignmentCenter;
    [self.dateScrollView addSubview:newPageView];
    [self.dateChoicesViews replaceObjectAtIndex:page withObject:newPageView];
  }
}

- (void)purgePage:(NSInteger)page {
  if (page < 0 || page >= self.weekChoices.count) {
    // If it's outside the range of what you have to display, then do nothing
    return;
  }
  
  // Remove a page from the scroll view and reset the container array
  UIView *pageView = [self.dateChoicesViews objectAtIndex:page];
  if ((NSNull*)pageView != [NSNull null]) {
    [pageView removeFromSuperview];
    [self.dateChoicesViews replaceObjectAtIndex:page withObject:[NSNull null]];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // Load the pages that are now on screen
  [self loadVisiblePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  // Load the pages that are now on screen
  [self _fetchAndReloadScoreboardForDate:[self currentPage]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"ScoreboardContainerToScoreboardSegue"]) {
    self.scoreboardTableViewController = segue.destinationViewController;
  } else if ([segue.identifier isEqualToString:@"ScoreboardToGameSegue"]) {
    NSIndexPath *selectedRow = [self.scoreboardTableViewController.tableView indexPathForSelectedRow];
    NSInteger section = selectedRow.section;
    NSInteger row = selectedRow.row;
    
    SCGameViewController *gameViewController = [segue destinationViewController];
    SCScoreboardTableViewController *scoreboardTableViewController = sender;
    gameViewController.game = [scoreboardTableViewController.scoreboard gameForSection:section andRow:row];
  }
}

#pragma mark - Private

- (void)_fetchWeekChoices
{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_WEEK_CHOICES]];
  AFHTTPRequestOperation *dateChoicesOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  dateChoicesOperation.responseSerializer = [AFJSONResponseSerializer serializer];
  [dateChoicesOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    self.weekChoices = responseObject[@"week_choices"];
    self.weekChoiceIds = responseObject[@"week_choice_ids"];
    CGSize dateScrollViewSize = self.dateScrollView.frame.size;
    self.dateScrollView.contentSize = CGSizeMake(dateScrollViewSize.width * self.weekChoices.count, dateScrollViewSize.height);
    
    for (NSInteger i = 0; i < self.weekChoices.count; ++i) {
      [self.dateChoicesViews addObject:[NSNull null]];
    }
    [self loadVisiblePages];
    [self _fetchAndReloadScoreboardForDate:0];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Request Failed: %@, %@", error, error.userInfo);
  }];
  
  [dateChoicesOperation start];
}

- (void)_fetchAndReloadScoreboardForDate:(NSInteger)date
{
  NSString *dateChoiceId = self.weekChoiceIds[date];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:URL_SCORES, dateChoiceId]]];
  if (self.fetchScoreboardForDateOperation != nil) {
    [self.fetchScoreboardForDateOperation cancel];
    self.fetchScoreboardForDateOperation = nil;
  }
  
  self.fetchScoreboardForDateOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  self.fetchScoreboardForDateOperation.responseSerializer = [AFJSONResponseSerializer serializer];
  
  __weak __typeof__(self) weakSelf = self;
  [self.fetchScoreboardForDateOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    __typeof__(self) strongSelf = weakSelf;
    strongSelf.scoreboardTableViewController.scoreboard = [[SCScoreboard alloc] initWithGamesArray:responseObject];
    [strongSelf.scoreboardTableViewController.tableView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Request Failed: %@, %@", error, error.userInfo);
  }];
  
  [self.fetchScoreboardForDateOperation start];
}

@end
