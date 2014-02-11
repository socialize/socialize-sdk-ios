//
//  TableBGInfoView.m
//  appbuildr
//
//  Created by Fawad Haider  on 2/9/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "SocializeTableBGInfoView.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel-Additions.h"

CGFloat SocializeTableBGInfoViewDefaultWidth = 140.f;
CGFloat SocializeTableBGInfoViewDefaultHeight = 140.f;

@implementation SocializeTableBGInfoView
@synthesize	errorLabel;

- (id)initWithFrame:(CGRect)frame bgImageName:(NSString*)bgImageName {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
		self.layer.cornerRadius = 10.0;
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		
		self.errorLabel = [[[UILabel alloc] init]autorelease];
		self.errorLabel.backgroundColor = [UIColor clearColor];
		self.errorLabel.textColor = [UIColor colorWithWhite:1 alpha:0.40];
		self.errorLabel.textAlignment = NSTextAlignmentCenter;
		self.errorLabel.font = [UIFont systemFontOfSize:12];
		self.errorLabel.hidden = YES;
		self.errorLabel.text = @"There is no activity at this time.";
		[self.errorLabel applyBlurAndShadow];
		
		CGSize labelSize = CGSizeMake(self.frame.size.width - 20, self.frame.size.height);
		labelSize = [self.errorLabel.text sizeWithFont:errorLabel.font constrainedToSize:labelSize];
		
		CGFloat labelXvalue = (self.frame.size.width - labelSize.width)/2;
		
        CGFloat labelYvalue = self.frame.size.height / 2.f - 12;
		CGRect  labelFrame = CGRectMake(labelXvalue, labelYvalue, labelSize.width, labelSize.height);
		self.errorLabel.frame = labelFrame;
		self.errorLabel.numberOfLines = 0;
		[self addSubview:self.errorLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	self.errorLabel = nil;
    [super dealloc];
}


@end
