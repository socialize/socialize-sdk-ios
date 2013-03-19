//
//  ASIdentifierManager+Utilities.h
//  Socialize
//
//  Created by Nate Griswold on 3/19/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <AdSupport/AdSupport.h>

@interface ASIdentifierManager (Utilities)

+ (NSString*)advertisingIdentifierString;
+ (NSString*)base64AdvertisingIdentifierString;

@end
