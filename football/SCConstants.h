//
//  SCConstants.h
//  football
//
//  Created by Andy Chen on 9/27/14.
//  Copyright (c) 2014 sportschub. All rights reserved.
//

#ifndef football_SCConstants_h
#define football_SCConstants_h

#if !DEBUG

#define kBaseURL @"http://localhost:8888"

#else

#define kBaseURL @"http://www.sportschub.com"

#endif

#define kFormatBaseURL kBaseURL @"%@"

#endif
