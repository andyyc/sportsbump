//
//  SCComment.m
//  football
//
//  Created by Andy Chen on 7/26/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCComment.h"
#import "SCDateHelpers.h"

@implementation SCComment

-(instancetype) initWithJson:(NSDictionary *)json
{
  if (self = [super init]) {
    _commentId = json[@"id"];
    _username = json[@"author_name"];
    _text = json[@"text"];
    _points = [json[@"points_derived"] integerValue];
    _postId = [json[@"post"] integerValue];
    _createdAt = stringToDate(json[@"created_at"]);
    _hasBumped = [json[@"has_bumped"] boolValue];
  }
  
  return self;
}

@end
