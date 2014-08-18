//
//  SCCommentComposerViewController.h
//  football
//
//  Created by Andy Chen on 8/10/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCommentStore.h"

@class SCComment;

@interface SCCommentComposerViewController : UIViewController<SCCommentStoreDelegate>

@property (weak, nonatomic) IBOutlet UILabel *parentCommentPoints;
@property (weak, nonatomic) IBOutlet UILabel *parentCommentUsername;
@property (weak, nonatomic) IBOutlet UILabel *parentCommentCreatedTime;
@property (weak, nonatomic) IBOutlet UITextView *parentCommentText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parentCommentTextHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextView *inputText;

@property (strong, atomic) SCComment *comment;

@end
