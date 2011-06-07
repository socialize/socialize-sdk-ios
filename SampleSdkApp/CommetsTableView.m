//
//  CommetsTableView.m
//  SocializeSDK
//
//  Created by Sergey Popenko on 6/7/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "CommetsTableView.h"


@implementation CommetsTableView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
	[super touchesBegan:touches withEvent:event];
	[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)dealloc {
    [super dealloc];
}

@end
