//
//  SocializeKeyboardListenerTests.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 12/12/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
@class SocializeKeyboardListener;

@interface SocializeKeyboardListenerTests : GHTestCase
@property (nonatomic, retain) SocializeKeyboardListener *keyboardListener;
@property (nonatomic, retain) id mockDelegate;

@end
