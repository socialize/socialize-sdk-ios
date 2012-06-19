//
//  NSString+QueryString.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/8/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QueryString)
- (NSArray*)parseQueryString;
@end
