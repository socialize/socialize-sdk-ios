//
//  SocializeActionViewForTest.m
//  SocializeSDK
//
//  Created by Fawad Haider on 8/18/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActionViewForTest.h"


@implementation SocializeActionViewForTest


-(void)addSubview:(UIView *)view{

}

-(CGSize)getSizeOfString:(NSString*)string withFont:(UIFont*)font{
    CGSize size;
    size.width = 78;
    size.height = 468;
    return size;
}

// empty placeholders 
+ (void)beginAnimations:(NSString *)animationID context:(void *)context{

}  

+ (void)commitAnimations{

}                                                 // starts up any animations when the top level animation is commited


@end
