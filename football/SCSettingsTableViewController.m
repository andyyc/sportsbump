//
//  SCSettingsTableViewController.m
//  football
//
//  Created by Andy Chen on 9/18/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCSettingsTableViewController.h"
#import "SCDjangoLogoutClient.h"
#import "SCLoginViewController.h"

#ifdef DEBUG

#define LOGOUT_URL @"http://localhost:8888/rest-auth/logout/"

#else

#define LOGOUT_URL @"http://sportschub.com/rest-auth/logout/"

#endif

@interface SCSettingsTableViewController ()<SCDjangoLogoutClientDelegate>

@end

@implementation SCSettingsTableViewController

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

- (void)viewWillAppear:(BOOL)animated
{
  [self.tableView reloadData];
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
  if ([self _isLoggedIn]) {
    return 2;
  } else {
    return 1;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  if ([self _isLoggedIn]) {
    if (section == 0) {
      return 1;
    } else {
      return 1;
    }
  } else {
    return 1;
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  
    // Configure the cell...
  int section = indexPath.section;
  int row = indexPath.row;
  
  if ([self _isLoggedIn]) {
    if (section == 0) {
      switch (row) {
        case 0:
          cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
          cell.userInteractionEnabled = NO;
          break;
      }
    } else if (section == 1) {
      
    }
  } else {
    if (section == 0) {
      if (row == 0) {
        cell.textLabel.text = @"Login";
        cell.userInteractionEnabled = YES;
      }
    }
  }
  
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  int section = indexPath.section;
  int row = indexPath.row;

  if ([self _isLoggedIn]) {
    if (section == 1) {
      if (row == 0) {
        SCDjangoLogoutClient *logoutClient = [[SCDjangoLogoutClient alloc] initWithURL:LOGOUT_URL];
        logoutClient.delegate = self;
        [logoutClient logout];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView reloadData];
      }
    }
  } else {
    if (section == 0) {
      if (row == 0) {
        [self performSegueWithIdentifier:@"SettingsToLoginSegue" sender:self];
      }
    }
  }
}

#pragma mark - SCDjangoLogoutClientDelegate

- (void)logoutSuccessWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data
{
  NSLog(@"logout successful");
}

- (void)logoutFailedWithResponse:(NSHTTPURLResponse *)response andBody:(NSDictionary *)data
{
  NSLog(@"logout failed. response:%@", response);
}

- (BOOL)_isLoggedIn
{
  NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
  
  return username.length > 0;
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
