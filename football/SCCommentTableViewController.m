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
@property (strong, nonatomic) SCCommentTableViewCell *dummyCell;
@property (strong, nonatomic) SCCommentTableViewCell *dummyCellCollapsed;
@property (strong, nonatomic) NSMutableArray *collapsedComments;

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
  _collapsedComments = [[NSMutableArray alloc] init];
  
  for (int i=0; i<_commentThread.commentIndex.count; i++) {
    _collapsedComments[i] = @NO;
  }
  
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
    return self.commentThread.commentIndex.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCCommentTableViewCell *cell = [self _reusableCellForIndexPath:indexPath];
  
  // Configure the cell...
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(toggleArrowTapped:)];
  // Specify that the gesture must be a single tap
  tapRecognizer.numberOfTapsRequired = 1;
  
  // Add the tap gesture recognizer to the view
  [cell.usernameView addGestureRecognizer:tapRecognizer];
  
  return cell;
}

- (void)toggleArrowTapped:(UIGestureRecognizer *)gesture
{
  NSLog(@"tapped");
  CGPoint location = [gesture locationInView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
  
  // self.collapsedComments[indexPath.row] = [NSNumber numberWithBool:![self.collapsedComments[indexPath.row] boolValue]];
  NSArray *toggledIndices = [self.commentThread toggleCommentStartingAtIndex:indexPath.row
                                                           collapsedComments:self.collapsedComments];
  
  NSMutableArray *toggledIndexPaths = [[NSMutableArray alloc] init];
  
  for (NSNumber *toggledIndex in toggledIndices) {
    [toggledIndexPaths addObject:[NSIndexPath indexPathForRow:[toggledIndex integerValue] inSection:0]];
  }
  
  [self.tableView beginUpdates];
  [self.tableView reloadRowsAtIndexPaths:toggledIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
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
  return [(SCComment *)self.commentThread.commentIndex[indexPath.row] depth];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCCommentTableViewCell *dummyCell = [self _dummyCellCollapsed:[self.collapsedComments[indexPath.row] boolValue]];
  
  [self configureCell:dummyCell forRowAtIndexPath:indexPath];
  [dummyCell layoutIfNeeded];
  
  CGSize size = [dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  
  return size.height+1;
}

- (void)configureCell:(SCCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCComment *comment = self.commentThread.commentIndex[indexPath.row];
  
  cell.commentText.text = comment.text;
  cell.username.text = comment.username;
  cell.props.text = @"1000";
  cell.toggleArrow.text = @"▾";
}

- (SCCommentTableViewCell *)_reusableCellForIndexPath:(NSIndexPath *)indexPath
{
  SCCommentTableViewCell *cell;
  
  if (![self.collapsedComments[indexPath.row] boolValue]) {
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
  } else {
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCellNoText" forIndexPath:indexPath];
  }
  
  return cell;
}

- (SCCommentTableViewCell *)_dummyCellCollapsed:(BOOL)isCollapsed
{
  if (!isCollapsed) {
    if (!_dummyCell) {
      _dummyCell = (SCCommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    }
    return _dummyCell;
  } else {
    if (!_dummyCellCollapsed) {
      _dummyCellCollapsed = (SCCommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CommentCellNoText"];
    }
    return _dummyCellCollapsed;
  }
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
