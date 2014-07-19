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

NSString *URL_SCORES = @"http://localhost:8888/api/scores";

@interface SCScoreboardViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *dateScrollView;
@property (strong, nonatomic) NSArray *dateChoices;
@property (strong, nonatomic) NSMutableArray *dateChoicesViews;
@property (strong, nonatomic) SCScoreboardTableViewController *scoreboardTableViewController;

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
  self.dateChoices = @[@"Week 1", @"Week 2", @"Week 3", @"Week 4"];
  self.dateChoicesViews = [[NSMutableArray alloc] init];
  
  for (NSInteger i = 0; i < self.dateChoices.count; ++i) {
    [self.dateChoicesViews addObject:[NSNull null]];
  }
  
  if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_SCORES]];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  operation.responseSerializer = [AFJSONResponseSerializer serializer];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    self.scoreboardTableViewController.scores = responseObject;
    [self.scoreboardTableViewController.tableView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Request Failed: %@, %@", error, error.userInfo);
  }];
  
  [operation start];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  CGSize dateScrollViewSize = self.dateScrollView.frame.size;
  self.dateScrollView.contentSize = CGSizeMake(dateScrollViewSize.width * self.dateChoices.count, dateScrollViewSize.height);
  
  [self loadVisiblePages];
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
  for (NSInteger i=lastPage+1; i<self.dateChoices.count; i++) {
    [self purgePage:i];
  }
}

- (NSInteger)currentPage {
  CGFloat pageWidth = self.dateScrollView.frame.size.width;
  NSInteger page = floor((self.dateScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
  
  return page;
}

- (void)loadPage:(NSInteger)page {
  if (page < 0 || page >= self.dateChoices.count) {
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
    newPageView.text = self.dateChoices[page];
    newPageView.textAlignment = NSTextAlignmentCenter;
    [self.dateScrollView addSubview:newPageView];
    [self.dateChoicesViews replaceObjectAtIndex:page withObject:newPageView];
  }
}

- (void)purgePage:(NSInteger)page {
  if (page < 0 || page >= self.dateChoices.count) {
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
    gameViewController.game = [(SCScoreboardTableViewController *)sender scores][section][@"games"][row];
  }
}

#pragma mark - Private

- (void)_fetchAndReloadScoreboardForDate:(NSInteger)date
{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_SCORES]];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  operation.responseSerializer = [AFJSONResponseSerializer serializer];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    self.scoreboardTableViewController.scores = responseObject;
    [self.scoreboardTableViewController.tableView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Request Failed: %@, %@", error, error.userInfo);
  }];
  
  [operation start];
}

@end
