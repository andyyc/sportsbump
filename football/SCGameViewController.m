//
//  SCGameViewController.m
//  football
//
//  Created by Andy Chen on 7/18/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCGameViewController.h"
#import "AFNetworking.h"
#import "SCGameTableViewController.h"
#import "SCHighlightViewController.h"

NSString *URL_GAME = @"http://localhost:8888/api/game/1";

@interface SCGameViewController ()

@property (strong, nonatomic) SCGameTableViewController *gameSummaryTableViewController;

@end

@implementation SCGameViewController

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
  self.navigationItem.title = self.game[@"name"];
  self.scoreLabel.text = self.game[@"score"];
  self.timeLabel.text = self.game[@"time"];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_GAME]];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  operation.responseSerializer = [AFJSONResponseSerializer serializer];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    self.game = responseObject;
    self.navigationItem.title = self.game[@"name"];
    self.scoreLabel.text = self.game[@"score"];
    self.timeLabel.text = self.game[@"time"];
    self.gameSummaryTableViewController.summary = self.game[@"summary"];
    
    [self.gameSummaryTableViewController.tableView reloadData];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"GameContainerToGameSummarySegue"]) {
    self.gameSummaryTableViewController = segue.destinationViewController;
  } else if([[segue identifier] isEqualToString:@"PlayToHighlightSegue"]){
    NSIndexPath *selectedRow = [self.gameSummaryTableViewController.tableView indexPathForSelectedRow];
    NSInteger section = selectedRow.section;
    NSInteger row = selectedRow.row;
    SCHighlightViewController *highlightViewController = [segue destinationViewController];
    highlightViewController.play = self.gameSummaryTableViewController.summary[section][@"plays"][row];
  }
}


@end
