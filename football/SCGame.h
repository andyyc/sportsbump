//
//  SCGame.h
//  football
//
//  Created by Andy Chen on 8/16/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCGame : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dayOfWeek;
@property (strong, nonatomic) NSString *gamekey;
@property (strong, nonatomic) NSString *awayTeam;
@property (strong, nonatomic) NSString *homeTeam;
@property (strong, nonatomic) NSString *awayTeamIcon;
@property (strong, nonatomic) NSString *homeTeamIcon;
@property (assign, nonatomic) NSInteger week;
@property (assign, nonatomic) NSInteger gameId;
@property (assign, nonatomic) NSInteger postId;

- (instancetype)initWithJson:(NSDictionary *)json;

@end
