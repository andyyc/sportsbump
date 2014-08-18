//
//  SCPlay.h
//  football
//
//  Created by Andy Chen on 8/17/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCPlay : NSObject

@property (strong, nonatomic) NSString *gamekey;
@property (strong, nonatomic) NSString *down;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSURL *videoUrl;
@property (strong, nonatomic) NSString *quarter;
@property (strong, nonatomic) NSString *time;
@property (assign, nonatomic) NSInteger points;

- (instancetype)initWithJson:(NSDictionary *)jsonDict;

@end
