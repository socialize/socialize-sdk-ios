//
//  CommentsTableViewCell.m
//  appbuildr
//
//  Created by Fawad Haider  on 11/30/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import	"CommentsTableViewCell.h"
#import "UIDevice+VersionCheck.h"
#import "CommentsTableViewCellIOS6.h"

@implementation CommentsTableViewCell

@synthesize headlineLabel;
@synthesize	summaryLabel;
@synthesize	dateLabel;
@synthesize	userProfileImage;
@synthesize bgImage;
@synthesize btnViewProfile;
@synthesize locationPin;

//class cluster for iOS 6 compatibility
+ (id)alloc {
    if([self class] == [CommentsTableViewCell class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [CommentsTableViewCellIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

//separate nibs for iOS 6/7 compatibility
//necessary as iOS 7 tables have "flat" look and legacy NIB displays artifacts in iOS 7
+ (NSString *)nibName {
    if([[UIDevice currentDevice] systemMajorVersion] < 7) {
        return @"CommentsTableViewCell";
    }
    else {
        return @"CommentsTableViewCellIOS7";
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.autoresizesSubviews = YES;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    //does nothing in this impl
}

- (UIImage *)defaultBackgroundImage {
    return nil;
}

- (UIImage *)defaultProfileImage {
    return [UIImage imageNamed:@"socialize-cell-image-default-ios7.png"];
}

//selected is not supported in this table cell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

-(void)layoutSubviews {
	[super layoutSubviews];

	CGFloat totalHeightForCell = [CommentsTableViewCell getCellHeightForString:mycomment]; 
	
	CGRect newFrame = summaryLabel.frame;
    newFrame.size.height = totalHeightForCell;
	summaryLabel.text = mycomment;
    summaryLabel.frame = newFrame;
	
	CGRect cellFrame = self.frame;
	cellFrame.size.height = newFrame.size.height + 50;
	self.frame = cellFrame;
}

-(void)setComment:(NSString*)mytext {
    summaryLabel.numberOfLines = 0;
    summaryLabel.textAlignment = NSTextAlignmentLeft;
    summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
	mycomment = mytext;	
	
	[self setNeedsLayout];
}

+(CGFloat)getCellHeightForString:(NSString*)comment {
    CGSize expectedLabelSize = [comment sizeWithFont:[UIFont boldSystemFontOfSize:12.0]
                                   constrainedToSize:CGSizeMake(250, CGFLOAT_MAX)
                                       lineBreakMode:NSLineBreakByWordWrapping];

	if (expectedLabelSize.height > 200)
		expectedLabelSize.height = 200;
	
	return expectedLabelSize.height;
}

- (void)dealloc {
	self.headlineLabel = nil;
	self.summaryLabel = nil;
	self.dateLabel = nil;
	self.userProfileImage = nil;
	self.bgImage = nil;
    self.btnViewProfile = nil;
    self.locationPin = nil;
    
	[super dealloc];
}

@end
