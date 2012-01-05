//
//  SocializeComment.m
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeComment.h"


@implementation SocializeComment

@synthesize text = _text;

-(void)dealloc
{
    [_text release];
    [super dealloc];
}

-(NSString *) displayText {
    return self.text;
}

@end
