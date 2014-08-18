//
//  SCPlay.m
//  football
//
//  Created by Andy Chen on 8/17/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import "SCPlay.h"

@implementation SCPlay

- (instancetype)initWithJson:(NSDictionary *)jsonDict
{
  if (self = [super init]) {
    _gamekey = jsonDict[@"gamekey"];
    _down = jsonDict[@"down"];
    _text = jsonDict[@"text"];
    _points = [jsonDict[@"points"] intValue];
    _quarter = jsonDict[@"quarter"];
    _time = jsonDict[@"time"];
    
    NSString *videoUrlString = jsonDict[@"video_url"];
    if (videoUrlString && videoUrlString.length > 0) {
       _videoUrl = [NSURL URLWithString:videoUrlString];
    }
  }
  
  return self;
}

@end
