//
//  SCGameViewController.m
//  football
//
//  Created by Andy Chen on 7/18/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCGameViewController.h"
#import "SCContainerViewController.h"
#import "SCHighlightViewController.h"
#import "NSURLSessionConfiguration+NSURLSessionConfigurationAdditions.h"

NSString *URL_GAME = @"http://localhost:8888/api/game/%@";

@interface SCGameViewController ()<NSURLSessionDelegate>

@property (strong, nonatomic)  SCContainerViewController* gameContainerViewController;

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
  self.navigationItem.title = self.game.name;
  self.scoreLabel.text = self.game.score;
  self.timeLabel.text = @"";
  
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration sessionConfigurationWithToken];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:URL_GAME, self.game.gamekey]]];
  
  NSURLSessionDataTask *dataTask =
    [session
     dataTaskWithRequest:request
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
           self.game = [[SCGame alloc] initWithJson:jsonDict];
           self.navigationItem.title = self.game.name;
           self.scoreLabel.text = self.game.score;
           self.timeLabel.text = @"";
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"GameToGameContainerSegue"]) {
    self.gameContainerViewController = segue.destinationViewController;
    self.gameContainerViewController.game = self.game;
  }
  /*
    else if([[segue identifier] isEqualToString:@"PlayToHighlightSegue"]){
    NSIndexPath *selectedRow = [self.gameSummaryTableViewController.tableView indexPathForSelectedRow];
    NSInteger section = selectedRow.section;
    NSInteger row = selectedRow.row;
    SCHighlightViewController *highlightViewController = [segue destinationViewController];
    highlightViewController.play = self.gameSummaryTableViewController.summary[section][@"plays"][row];
  */
}

#pragma mark - UISegmentedControl

- (IBAction)indexChanged:(UISegmentedControl *)sender
{
  [self.gameContainerViewController selectedGameSegmentIndex:self.segmentedControl.selectedSegmentIndex];
}


@end
