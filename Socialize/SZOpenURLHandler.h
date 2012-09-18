//
//  SZOpenURLHandler.h
//  Socialize
//
//  Created by Nathaniel Griswold on 9/17/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZDisplay.h"

@interface SZOpenURLHandler : NSObject

+ (SZOpenURLHandler*)sharedOpenURLHandler;
+ (NSString*)defaultSmartDownloadURLPath;

- (BOOL)handleOpenURL:(NSURL*)url;

@property (nonatomic, strong) id<SZDisplay> display;

@end
