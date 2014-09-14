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
#import "SCLoginViewController.h"
#import "SCCommentComposerViewController.h"
#import "SCGame.h"
#import "SCCommentBumpStore.h"

@interface SCCommentTableViewController ()

@property (strong, nonatomic) SCCommentThread *commentThread;
@property (strong, nonatomic) SCCommentTableViewCell *dummyCell;
@property (strong, nonatomic) SCCommentTableViewCell *dummyCellCollapsed;
@property (strong, nonatomic) NSMutableArray *collapsedComments;
@property (strong, nonatomic) SCCommentStore *commentStore;
@property (strong, nonatomic) SCCommentBumpStore *commentBumpStore;

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
  
  _commentStore = [[SCCommentStore alloc] init];
  _commentStore.delegate = self;
  _commentBumpStore = [[SCCommentBumpStore alloc] init];
  _commentBumpStore.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [_commentStore fetchCommentsForGameKey:self.game.gamekey];
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
  
  UITapGestureRecognizer *tapArrowRecognizer = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(toggleArrowTapped:)];
  tapArrowRecognizer.numberOfTapsRequired = 1;
  [cell.usernameView addGestureRecognizer:tapArrowRecognizer];
  
  UITapGestureRecognizer *tapPointsRecognizer = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(pointsTapped:)];
  tapPointsRecognizer.numberOfTapsRequired = 1;
  [cell.points setUserInteractionEnabled:YES];
  [cell.points addGestureRecognizer:tapPointsRecognizer];
  
  // Disable highlighting
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return cell;
}

- (void)toggleArrowTapped:(UIGestureRecognizer *)gesture
{
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
  [self.tableView reloadRowsAtIndexPaths:toggledIndexPaths withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];
}

- (void)pointsTapped:(UITapGestureRecognizer *)gesture
{
  CGPoint location = [gesture locationInView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
  SCComment *comment = self.commentThread.commentIndex[indexPath.row];
  
  [_commentBumpStore postCommentBumpForComment:comment.commentId isRemoved:comment.hasBumped];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  BOOL loggedIn = [userDefaults objectForKey:@"key"] != nil && [userDefaults objectForKey:@"username"] != nil;
  
  if (!loggedIn) {
    [self performSegueWithIdentifier:@"CommentToLoginSegue" sender:self];
  } else {
    [self performSegueWithIdentifier:@"CommentToComposerSegue" sender:self];
  }
}

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
  
  return size.height;
}

- (void)configureCell:(SCCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  SCComment *comment = self.commentThread.commentIndex[indexPath.row];
  
  cell.commentText.text = comment.text;
  cell.username.text = comment.username;
  cell.points.text = [NSString stringWithFormat:@"%d 👊", comment.points];
  
  if (comment.hasBumped) {
    cell.points.textColor = [UIColor blackColor];
    cell.points.alpha = 1.0;
  } else {
    cell.points.textColor = [UIColor lightGrayColor];
    cell.points.alpha = 0.5;
  }
  
  if (comment.shouldHideCommentText) {
    cell.toggleArrow.text = @"▸";
  } else {
    cell.toggleArrow.text = @"▾";
  }
  cell.timePosted.text = [NSString stringWithFormat:@"∙ %@", [comment createdTimeAgo]];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"CommentToComposerSegue"]) {
    UINavigationController *navController = [segue destinationViewController];
    SCCommentComposerViewController *composerViewController = [navController viewControllers][0];
    
    if ([sender isKindOfClass:[UIButton class]]) {
      // user tapped add comment
      SCComment *parentCommentForGameThread = [[SCComment alloc] init];
      parentCommentForGameThread.postId = self.game.postId;
      parentCommentForGameThread.text = self.game.name;
      composerViewController.comment = parentCommentForGameThread;
    } else {
      NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
      composerViewController.comment = self.commentThread.commentIndex[selectedRow.row];
    }
  }
}

#pragma mark - IBAction

- (IBAction)didTapAddComment:(id)sender
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *key = [userDefaults objectForKey:@"key"];
  BOOL loggedIn = key && key.length > 0;
  
  if (!loggedIn) {
    [self performSegueWithIdentifier:@"CommentToLoginSegue" sender:sender];
  } else {
    [self performSegueWithIdentifier:@"CommentToComposerSegue" sender:sender];
  }
}

#pragma mark - SCCommentStoreDelegate

- (void)didFetchComments:(NSArray *)data
{
  _commentThread = [[SCCommentThread alloc] initWithArray:data];
  _collapsedComments = [[NSMutableArray alloc] init];
  
  for (int i=0; i<_commentThread.commentIndex.count; i++) {
    _collapsedComments[i] = @NO;
  }
  
  [self.tableView reloadData];
}

#pragma mark - SCCommentBumpStoreDelegate

- (void)didPostCommentBump:(NSDictionary *)data
{
  NSString *commentId = data[@"comment"];
  NSNumber *commentIndex = self.commentThread.commentIdToCommentIndexMap[commentId];
  SCComment *comment = self.commentThread.commentIdToDataMap[commentId];
  BOOL isBumpRemoved = [data[@"is_removed"] boolValue];
  if (isBumpRemoved) {
    comment.points -= 1;
  } else {
    comment.points += 1;
  }
  
  comment.hasBumped = !isBumpRemoved;
  
  NSIndexPath *commentIndexPath = [NSIndexPath indexPathForRow:[commentIndex intValue] inSection:0];
  
  [self.tableView beginUpdates];
  [self.tableView reloadRowsAtIndexPaths:@[commentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
  [self.tableView endUpdates];
}

- (void)failedToPostCommentBump:(NSDictionary *)data
{
  // do nothing
}

@end
