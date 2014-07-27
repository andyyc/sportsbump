//
//  SCComment.m
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCComment.h"

@implementation SCComment

-(instancetype) initWithCommentId:(NSString *)commentId
                         username:(NSString *)username
                             text:(NSString *)text
{
  if (self = [super init]) {
    _commentId = commentId;
    _username = username;
    _text = text;
  }
  
  return self;
}

@end
