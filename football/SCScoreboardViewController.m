//
//  SCScoreboardViewController.m
//  football
//
//  Created by Andy Chen on 7/19/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCScoreboardViewController.h"
#import "SCScoreboardTableViewController.h"
#import "SCGameViewController.h"
#import "SCScoreboardTableViewController.h"
#import "SCScoreboard.h"
#import "SCURLSession.h"

#define URL_SCORES kBaseURL @"/api/week/%@"
#define URL_WEEK_CHOICES kBaseURL @"/api/week-choices"

@interface SCScoreboardViewController ()
@property (weak, nonatomic) IBOutlet UIView *dateScrollViewContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *dateScrollView;
@property (assign, nonatomic) BOOL hasFetchedDate;
@property (assign, nonatomic) NSInteger currentWeek;
@property (strong, nonatomic) NSArray *weekChoices;
@property (strong, nonatomic) NSArray *weekChoiceIds;
@property (strong, nonatomic) NSMutableArray *dateChoicesViews;
@property (strong, nonatomic) SCScoreboardTableViewController *scoreboardTableViewController;
@property (strong, nonatomic) NSURLSessionDataTask *scoreboardDataTask;

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
  self.dateScrollViewContainer.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
  self.dateScrollViewContainer.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
  self.dateScrollViewContainer.layer.shadowRadius = 2.0f;
  self.dateScrollViewContainer.layer.shadowOpacity = 0.5f;
  
  self.navigationItem.title = @"Scores";
  self.dateChoicesViews = [[NSMutableArray alloc] init];
  
  if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if ([self hasFetchedDate]) {
    // only want to fetch the first time
    [self _fetchAndReloadScoreboardForDate:[self currentPage]];
  } else {
    [self _fetchWeekChoices];
  }
}

#pragma mark - dateScrollView

- (void)loadVisiblePages
{
  // First, determine which page is currently visible
  [self loadVisiblePagesAt:[self currentPage]];
}

- (void)loadVisiblePagesAt:(NSInteger)page
{
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

- (void)setCurrentPage:(NSInteger)page {
  CGFloat pageWidth = self.dateScrollView.frame.size.width;
  self.dateScrollView.contentOffset =  CGPointMake(pageWidth * page, 0);
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
  SCURLSession *session = [[SCURLSession alloc] init];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_WEEK_CHOICES]];
  
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
                                          self.weekChoices = jsonDict[@"week_choices"];
                                          self.weekChoiceIds = jsonDict[@"week_choice_ids"];
                                          self.currentWeek = [jsonDict[@"current_week"] integerValue];
                                          CGSize dateScrollViewSize = self.dateScrollView.frame.size;
                                          self.dateScrollView.contentSize = CGSizeMake(dateScrollViewSize.width * self.weekChoices.count, dateScrollViewSize.height);
                                          
                                          for (NSInteger i = 0; i < self.weekChoices.count; ++i) {
                                            [self.dateChoicesViews addObject:[NSNull null]];
                                          }
                                          [self setCurrentPage:self.currentWeek+5];
                                          [self loadVisiblePages];
                                          [self _fetchAndReloadScoreboardForDate:self.currentWeek+5];
                                        });
                                      } else {
                                        // alert for error saving / updating note
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                        });
                                      }
                                    }];

  
  [dataTask resume];
}

- (void)_fetchAndReloadScoreboardForDate:(NSInteger)date
{
  NSString *dateChoiceId = self.weekChoiceIds[date];
  
  SCURLSession *session = [[SCURLSession alloc] init];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:URL_SCORES, dateChoiceId]]];
  
  if (self.scoreboardDataTask) {
    [self.scoreboardDataTask cancel];
  }

  self.scoreboardDataTask = [session
                              dataTaskWithAuthenticatedRequest:request
                              completionHandler:^(NSData *data,
                                                  NSURLResponse *response,
                                                  NSError *error)
                              {
                                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                NSError *responseError;
                                NSArray* jsonDict = [NSJSONSerialization
                                                     JSONObjectWithData:data
                                                                options:kNilOptions
                                                                  error:&responseError];
                                
                                if (!error && httpResp.statusCode == 200) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                    self.scoreboardTableViewController.scoreboard = [[SCScoreboard alloc] initWithGamesArray:jsonDict];
                                    [self.scoreboardTableViewController.tableView reloadData];
                                    self.hasFetchedDate = YES;
                                  });
                                } else {
                                  // alert for error saving / updating note
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                  });
                                }
                              }];
  
  [self.scoreboardDataTask resume];
}

@end
