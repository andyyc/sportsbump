//
//  SCContainerViewController.m
//  football
//
//  Created by Andy Chen on 7/22/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCContainerViewController.h"
#import "SCGameTableViewController.h"
#import "SCCommentTableViewController.h"

#define SegueIdentifierFirst @"GameContainerToPlayByPlaySegue"
#define SegueIdentifierSecond @"GameContainerToCommentsSegue"

@interface SCContainerViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) NSArray *segueIdentifiers;
@property (strong, nonatomic) NSMutableDictionary *identifierToViewControllerMap;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation SCContainerViewController

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
  self.transitionInProgress = NO;
  self.currentSegueIdentifier = SegueIdentifierFirst;
  self.segueIdentifiers = @[SegueIdentifierFirst, SegueIdentifierSecond];
  self.identifierToViewControllerMap = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                         SegueIdentifierFirst: [NSNull null],
                                                                                         SegueIdentifierSecond: [NSNull null]
                                                                                         }
                                        ];
  [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
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
  // Instead of creating new VCs on each seque we want to hang on to existing
  // instances if we have it. Remove the second condition of the following
  // two if statements to get new VC instances instead.
  if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
    SCCommentTableViewController *commentTableViewController = [segue destinationViewController];
    commentTableViewController.postId = self.game.postId;
    commentTableViewController.titleText = self.game.name;
  }
  
  if ([segue.destinationViewController respondsToSelector:@selector(setGame:)]) {
    [segue.destinationViewController performSelector:@selector(setGame:) withObject:self.game];
  }
  
  [self.identifierToViewControllerMap setValue:segue.destinationViewController forKey:segue.identifier];
  
  // If this is not the first time we're loading this.
  if ([self _currentViewController]) {
    [self swapFromViewController:[self _currentViewController] toViewController:segue.destinationViewController];
    return;
  }

  [self addChildViewController:segue.destinationViewController];
  UIView* destView = ((UIViewController *)segue.destinationViewController).view;
  destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  [self.view addSubview:destView];
  [segue.destinationViewController didMoveToParentViewController:self];
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
  toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  
  [fromViewController willMoveToParentViewController:nil];
  [self addChildViewController:toViewController];
  
  [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
    [fromViewController removeFromParentViewController];
    [toViewController didMoveToParentViewController:self];
    self.transitionInProgress = NO;
  }];
}

- (void)selectedGameSegmentIndex:(NSInteger)index;
{
  if (self.transitionInProgress) {
    return;
  }
  
  if ([self.segueIdentifiers objectAtIndex:index] == self.currentSegueIdentifier) {
    return;
  }
  
  self.transitionInProgress = YES;
  self.currentSegueIdentifier = [self.segueIdentifiers objectAtIndex:index];
  
  if (self.identifierToViewControllerMap[self.currentSegueIdentifier] != [NSNull null]) {
    [self swapFromViewController:[self _currentViewController] toViewController:self.identifierToViewControllerMap[self.currentSegueIdentifier]];
    return;
  }
  
  [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (UIViewController *)_currentViewController
{
  return (self.childViewControllers.count > 0) ? self.childViewControllers[0] : nil;
}

@end
