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
@synthesize subscribe = _subscribe;

-(void)dealloc
{
    [_text release];
    [super dealloc];
}

-(NSString *) displayText {
    return self.text;
}

+ (SocializeComment*)commentWithEntity:(id<SocializeEntity>)entity text:(NSString*)text {
    SocializeComment *comment = [[[self alloc] init] autorelease];
    comment.entity = entity;
    comment.text = text;
    return comment;
}

@end
