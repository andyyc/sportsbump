//
//  SCCommentThread.m
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCCommentThread.h"

@interface SCCommentThread()

@property (strong, nonatomic) NSMutableDictionary *commentIdToDataMap;
@property (strong, nonatomic) NSMutableArray *roots;
@property (strong, nonatomic) NSMutableDictionary *edges;
@property (strong, nonatomic) NSMutableDictionary *commentIdToCommentIndexMap;

@end


@implementation SCCommentThread

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  if (self = [super init]) {
    [self _buildThread:dictionary];
  }
  
  return self;
}

/*
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
 @"1": @{@"username": @"andy", @"text": @"andy's comment"},
 @"2": @{@"username": @"bob", @"text": @"bob's comment"},
 @"3": @{@"username": @"charles", @"text": @"charles's comment"},
 @"4": @{@"username": @"david", @"text": @"david's comment"},
 @"5": @{@"username": @"emily", @"text": @"emily's comment"},
 @"6": @{@"username": @"frank", @"text": @"frank's comment"},
 @"7": @{@"username": @"grace", @"text": @"grace's comment"},
 }
 };
*/
- (void)_buildThread:(NSDictionary *)dictionary
{
  _commentIdToDataMap = [[NSMutableDictionary alloc] init];
  [dictionary[@"comment_id_to_data"] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
    SCComment *comment = [[SCComment alloc] initWithCommentId:value[@"comment_id"]
                                                     username:value[@"username"]
                                                         text:value[@"text"]];
    _commentIdToDataMap[value[@"comment_id"]] = comment;
  }];
  
  _roots = [[NSMutableArray alloc] init];
  for (NSString *rootId in dictionary[@"comment_id_tree"][@"roots"]) {
    [_roots addObject:_commentIdToDataMap[rootId]];
  }
  
  _edges = [[NSMutableDictionary alloc] init];
  [dictionary[@"comment_id_tree"][@"edges"] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
    if(!_edges[key]) {
      _edges[key] = [[NSMutableArray alloc] init];
    }
    
    for (NSString *destId in value) {
      [_edges[key] addObject:_commentIdToDataMap[destId]];
    }
  }];
  
  _commentIndex = [[NSMutableArray alloc] init];
  _commentIdToCommentIndexMap = [[NSMutableDictionary alloc] init];
  [self _buildThreadRecursively:_roots depth:0];
}

- (void)_buildThreadRecursively:(NSArray *)comments
                          depth:(NSUInteger)depth
{
  for (SCComment *comment in comments) {
    [_commentIndex addObject:comment];
    self.commentIdToCommentIndexMap[comment.commentId] = [NSNumber numberWithInt:_commentIndex.count-1];
    comment.depth = depth;
    [self _buildThreadRecursively:_edges[comment.commentId] depth:depth+1];
  }
}

- (NSArray *)toggleCommentStartingAtIndex:(NSInteger)index collapsedComments:(NSMutableArray *)collapsedComments
{
  NSMutableArray *toggledComments = [[NSMutableArray alloc] init];
  
  [self _allCommentsStartingFromComment:@[self.commentIndex[index]]
                       commentsArrayOut:toggledComments];
  
  NSMutableArray *toggledIndices = [[NSMutableArray alloc] init];
  BOOL shouldCollapse = ![collapsedComments[index] boolValue];

  for (SCComment *comment in toggledComments) {
    NSNumber *commentIndexToToggle = self.commentIdToCommentIndexMap[comment.commentId];
    [toggledIndices addObject:commentIndexToToggle];
    collapsedComments[[commentIndexToToggle integerValue]] = [NSNumber numberWithBool:shouldCollapse];
  }
  
  return [toggledIndices copy];
}

- (void) _allCommentsStartingFromComment:(NSArray *)comments commentsArrayOut:(NSMutableArray *)commentsArrayOut
{
  for (SCComment *comment in comments) {
    [commentsArrayOut addObject:comment];
    [self _allCommentsStartingFromComment:_edges[comment.commentId] commentsArrayOut:commentsArrayOut];
  }
}

- (void)_toggleCommentStartingAtIndex:(NSArray *)indexes
                    collapsedComments:(NSMutableArray *)collapsedComments
                       shouldCollapse:(BOOL)shouldCollapse
                       toggledIndices:(NSMutableArray *)toggledIndices
{
  for (NSNumber *index in indexes) {
    collapsedComments[[index intValue]] = [NSNumber numberWithBool:shouldCollapse];
    [toggledIndices addObject:index];
    NSArray *childComments = _edges[self.commentIndex[[index integerValue]]];
    NSMutableArray *childIndices = [[NSMutableArray alloc] init];
    
    for (SCComment *comment in childComments) {
      [childIndices addObject:self.commentIdToCommentIndexMap[comment.commentId]];
    }
                                    
    [self _toggleCommentStartingAtIndex:childIndices
                      collapsedComments:collapsedComments
                         shouldCollapse:shouldCollapse
                         toggledIndices:toggledIndices];
  }
}

@end
