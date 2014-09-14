//
//  SCGamesTableViewController.m
//  football
//
//  Created by Andy Chen on 7/9/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCScoreboardTableViewController.h"
#import "SCScoreboardTableViewCell.h"
#import "SCGameViewController.h"
#import "SCScoreboard.h"
#import "SCGame.h"
#import <SDWebImage/UIImageView+WebCache.h>

#ifdef DEBUG

NSString *STATIC_BASE_URL = @"http://localhost:8888%@";

#else

NSString *STATIC_BASE_URL = @"http://www.sportschub.com%@";

#endif

@interface SCScoreboardTableViewController ()

@end

@implementation SCScoreboardTableViewController

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
    return self.scoreboard.sectionsByDate.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  NSDate *date = self.scoreboard.sectionsByDate[section];
  return ((NSArray *)self.scoreboard.dateToGamesMap[date]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCScoreboardTableViewCell *gameCell = [tableView dequeueReusableCellWithIdentifier:@"GameCell" forIndexPath:indexPath];
    
    // Configure the cell...
  long row = [indexPath row];
  long section = [indexPath section];
  NSDate *date = self.scoreboard.sectionsByDate[section];
  NSArray *games = (NSArray *)self.scoreboard.dateToGamesMap[date];
  
  SCGame *game = games[row];
  
  gameCell.name.text = game.name;
  gameCell.score.text = game.score;
  gameCell.gameTime.text = nil;
  gameCell.awayTeam.text = game.awayTeam;
  gameCell.homeTeam.text = game.homeTeam;
  NSString *awayTeamIconURLString = [NSString stringWithFormat:STATIC_BASE_URL, game.awayTeamIcon];
  NSString *homeTeamIconURLString = [NSString stringWithFormat:STATIC_BASE_URL, game.homeTeamIcon];
  [gameCell.awayTeamIcon sd_setImageWithURL:[NSURL URLWithString:awayTeamIconURLString]];
  [gameCell.homeTeamIcon sd_setImageWithURL:[NSURL URLWithString:homeTeamIconURLString]];
  
  return gameCell;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"eeee MMM d"];
  NSDate *date = self.scoreboard.sectionsByDate[section];
  return [formatter stringFromDate:date];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.parentViewController performSegueWithIdentifier:@"ScoreboardToGameSegue" sender:self];
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
