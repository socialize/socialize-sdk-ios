//
//  SZWhatsAppUtils.m
//  Socialize
//
//  Created by David Jedeikin on 4/7/14.
//  Copyright (c) 2014 Socialize. All rights reserved.
//

#import "SZWhatsAppUtils.h"

@implementation SZWhatsAppUtils

//operates purely on URL scheme
+ (BOOL)isAvailable {
    BOOL canOpenWhatsApp = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]];
    return canOpenWhatsApp;
}

@end
