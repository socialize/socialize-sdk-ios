//
//  UIImage+Network.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/4/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "UIImage+Network.h"
#import "NSData+Base64.h"

@implementation UIImage (SocializeNetworkAdditions)

- (NSString*)base64PNGRepresentation {
    NSData *data = UIImagePNGRepresentation(self);
    NSString *base64 = [data base64Encoding];
    
    return base64;
}
                                    
@end
