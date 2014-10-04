//
//  SCPlay.m
//  football
//
//  Created by Andy Chen on 8/17/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCPlay.h"
#import "SCDateHelpers.h"

@implementation SCPlay

- (instancetype)initWithJson:(NSDictionary *)jsonDict
{
  if (self = [super init]) {
    _playId = jsonDict[@"id"];
    _gamekey = jsonDict[@"gamekey"];
    _down = jsonDict[@"down"];
    _text = jsonDict[@"text"];
    _points = [jsonDict[@"points"] intValue];
    _quarter = jsonDict[@"quarter"];
    _time = jsonDict[@"time"];
    _postId = jsonDict[@"post"] != [NSNull null] ? jsonDict[@"post"] : nil;
    NSString *teamString = jsonDict[@"team"];
    
    if (teamString.length > 0) {
      _team = teamString;
    }
    
    NSString *teamIconString = jsonDict[@"team_icon"];
    
    if (teamIconString && teamIconString.length > 0) {
      _teamIcon = teamIconString;
    }
    
    NSString *videoUrlString = jsonDict[@"mp4_url"];
    if (videoUrlString && videoUrlString.length > 0) {
      _videoUrl = [NSURL URLWithString:videoUrlString];
    }
    
    NSString *gfyUrlString = jsonDict[@"gfy_url"];
    if (gfyUrlString && gfyUrlString.length > 0) {
      _gfyUrl = [NSURL URLWithString:gfyUrlString];
    }
    
    _createdAt = stringToDate(jsonDict[@"created_at"]);
    _createdAtRaw = jsonDict[@"created_at"];
  }
  
  return self;
}

@end
