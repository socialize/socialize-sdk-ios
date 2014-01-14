//
//  SZActionBarIOS6.m
//  Socialize
//
//  Created by David Jedeikin on 1/14/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "SZActionBarIOS6.h"

@implementation SZActionBarIOS6

- (id)initWithFrame:(CGRect)frame entity:(id<SocializeEntity>)entity viewController:(UIViewController *)viewController {
    self = [super initWithFrame:frame entity:entity viewController:viewController];
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.backgroundImage = [[UIImage imageNamed:@"action-bar-bg.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5];
    }
    return self;
}

@end
