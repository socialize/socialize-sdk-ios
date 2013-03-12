//
//  SZUnitTestAppHack.h
//  Socialize
//
//  Created by Nate Griswold on 3/11/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZUnitTestAppHack : UIApplication

+ (void)setDelegateClassName:(NSString*)className;
+ (NSString*)delegateClassName;

@end
