//
//  CommentsTableViewCell.m
//  appbuildr
//
//  Created by Fawad Haider  on 11/30/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import	"CommentsTableViewCell.h"

@implementation CommentsTableViewCell

@synthesize headlineLabel;
@synthesize	summaryLabel;
@synthesize	dateLabel;
@synthesize	userProfileImage;
@synthesize bgImage;
@synthesize btnViewProfile;
@synthesize locationPin;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
		// Initialization code
		self.autoresizesSubviews = YES;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)awakeFromNib{
	self.bgImage.image = [[UIImage imageNamed:@"comments-cell-bg-borders.png"]  stretchableImageWithLeftCapWidth:0 topCapHeight:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    [super setSelected:NO animated:animated];
}

-(void)layoutSubviews{
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

-(void)setComment:(NSString*)mytext{
	
    summaryLabel.numberOfLines = 0;
    summaryLabel.textAlignment = UITextAlignmentLeft;
    summaryLabel.lineBreakMode = UILineBreakModeWordWrap;
	mycomment = mytext;	
	
	[self setNeedsLayout];
}

+(CGFloat)getCellHeightForString:(NSString*)comment{

    CGSize expectedLabelSize = [comment sizeWithFont:[UIFont boldSystemFontOfSize:12.0] 
								  constrainedToSize:CGSizeMake(250, CGFLOAT_MAX) 
									  lineBreakMode:UILineBreakModeWordWrap];

	if (expectedLabelSize.height > 200)
		expectedLabelSize.height = 200;
	
	return expectedLabelSize.height;
}

-(void)drawRect:(CGRect)rect{

	[super drawRect:rect];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,CGSizeMake(55,55)}, [[UIImage imageNamed:@"comment-cell-bg-tile.png"] CGImage]);

}

- (void)dealloc {
	self.bgImage = nil;
	self.userProfileImage = nil;
	self.headlineLabel = nil;
	self.summaryLabel = nil;
	self.dateLabel = nil;
	[super dealloc];
}

@end
