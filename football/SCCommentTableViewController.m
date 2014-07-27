//
//  SCCommentTableViewController.m
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCCommentTableViewController.h"
#import "SCCommentStore.h"
#import "SCCommentThread.h"
#import "SCCommentTableViewCell.h"

@interface SCCommentTableViewController ()

@property (strong, nonatomic) SCCommentThread *commentThread;
@property (nonatomic, strong) SCCommentTableViewCell *dummyCell;

@end

@implementation SCCommentTableViewController

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
  NSDictionary *commentThreadDictionary = @{
    @"comment_id_tree": @{
        @"roots": @[@"1", @"2", @"3"],
        @"edges": @{
          @"1" : @[@"4"],
          @"2" : @[@"5", @"6"],
          @"5" : @[@"7"],
        }
    },
    @"comment_id_to_data" : @{
        @"1": @{@"comment_id": @"1", @"username": @"andy", @"text": @"andy's comment"},
        @"2": @{@"comment_id": @"2", @"username": @"bob", @"text": @"bob's comment"},
        @"3": @{@"comment_id": @"3", @"username": @"charles", @"text": @"charles's comment"},
        @"4": @{@"comment_id": @"4", @"username": @"david", @"text": @"david's comment"},
        @"5": @{@"comment_id": @"5", @"username": @"emily", @"text": @"emily's comment"},
        @"6": @{@"comment_id": @"6", @"username": @"frank", @"text": @"frank's comment"},
        @"7": @{@"comment_id": @"7", @"username": @"grace", @"text": @"grace's comment"},
    }
  };
  
  _commentThread = [[SCCommentThread alloc] initWithDictionary:commentThreadDictionary];
  NSLog(@"");
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
    return self.commentThread.commentIndex.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
  
  // Configure the cell...
  [self configureCell:cell forRowAtIndexPath:indexPath];
  return cell;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  UIView *view = [[UIView alloc] init];
  
  return view;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger row = indexPath.row;
  
  return [(SCComment *)self.commentThread.commentIndex[row] depth];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self configureCell:self.dummyCell forRowAtIndexPath:indexPath];
  [self.dummyCell layoutIfNeeded];
  
  CGSize size = [self.dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  return size.height+1;
}

- (void)configureCell:(SCCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger row = indexPath.row;
  SCComment *comment = self.commentThread.commentIndex[row];
  
  cell.text.text = comment.text;
  cell.username.text = comment.username;
  cell.props.text = @"1000";
  cell.toggleArrow.text = @"▾";
}

- (SCCommentTableViewCell *)dummyCell
{
  if (!_dummyCell)
  {
    _dummyCell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
  }
  return _dummyCell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  return UITableViewAutomaticDimension;
//}

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
