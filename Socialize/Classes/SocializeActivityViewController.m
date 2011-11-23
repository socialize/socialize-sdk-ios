//
//  SocializeActivityViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/22/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeActivityViewController.h"
#import "SocializeActivityTableViewCell.h"
#import "SocializeActivityService.h"
#import "SocializeProfileViewController.h"

static NSInteger SocializeActivityViewControllerPageSize = 10;

@interface SocializeActivityViewController ()
@property (nonatomic, assign) BOOL waitingForActivity;
@property (nonatomic, assign) BOOL loadedAllActivity;
@end

@implementation SocializeActivityViewController
@synthesize activityTableViewCell = activityTableViewCell_;
@synthesize bundle = bundle_;
@synthesize activityArray = activityArray_;
@synthesize currentUser = currentUser_;
@synthesize waitingForActivity = waitingForActivity_;
@synthesize loadedAllActivity = loadedAllActivity_;
@synthesize delegate = delegate_;
@synthesize tableBackgroundView = tableBackgroundView_;
@synthesize activityLoadingActivityIndicatorView = activityLoadingActivityIndicatorView_;
@synthesize tableFooterView = tableFooterView_;

- (void)dealloc {
    self.activityTableViewCell = nil;
    self.bundle = nil;
    self.activityArray = nil;
    self.tableBackgroundView = nil;
    self.activityLoadingActivityIndicatorView = nil;
    self.tableFooterView = nil;
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.activityTableViewCell = nil;
    self.tableBackgroundView = nil;
    self.activityLoadingActivityIndicatorView = nil;
    self.tableFooterView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = self.tableBackgroundView;
    self.tableView.tableFooterView = self.tableFooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.activityArray count];
}

- (NSBundle*)bundle {
    if (bundle_ == nil) {
        bundle_ = [[NSBundle mainBundle] retain];
    }
    return bundle_;
}

- (SocializeActivityTableViewCell*)createActivityTableViewCell {
    [self.bundle loadNibNamed:@"SocializeActivityTableViewCell" owner:self options:nil];
    SocializeActivityTableViewCell *cell = [[self.activityTableViewCell retain] autorelease];
    self.activityTableViewCell = nil;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SocializeActivityTableViewCellHeight;
}

- (void)loadActivityForUserID:(NSInteger)userID position:(NSInteger)position {
    [self.activityLoadingActivityIndicatorView startAnimating];
    [self.delegate activityViewControllerDidStartLoadingActivity:self];
    self.waitingForActivity = YES;
    [self.socialize getActivityOfUserId:userID
                                  first:[NSNumber numberWithInteger:position]
                                   last:[NSNumber numberWithInteger:position + SocializeActivityViewControllerPageSize]
                               activity:SocializeAllActivity];
}

- (void)loadActivityForNextPage {
    NSInteger offset = [self.activityArray count];
    [self loadActivityForUserID:self.currentUser position:offset];
}

- (void)stopLoadingActivity {
    [self.activityLoadingActivityIndicatorView stopAnimating];
    self.waitingForActivity = NO;
    [self.delegate activityViewControllerDidStopLoadingActivity:self];
}

- (void)setCurrentUser:(NSInteger)currentUser {
    currentUser_ = currentUser;
    self.activityArray = nil;
    [self loadActivityForUserID:currentUser position:0];
}

- (NSMutableArray*)activityArray {
    if (activityArray_ == nil) {
        activityArray_ = [[NSMutableArray alloc] init];
    }
    return activityArray_;
}

- (NSArray*)indexPathsForSectionRange:(NSRange)sectionRange rowRange:(NSRange)rowRange {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:sectionRange.length*rowRange.length];
    for (int s = sectionRange.location; s < sectionRange.location + sectionRange.length; s++) {
        for (int r = rowRange.location; r < rowRange.location + rowRange.length; r++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:r inSection:s]];
        }
    }
    return indexPaths;
}

- (void)receiveNewActivity:(NSArray*)activity {
    [self stopLoadingActivity];
    
    if ([activity count] > 0) {
        [self.tableView beginUpdates];
        NSRange rowRange = NSMakeRange([self.activityArray count], [activity count]);
        NSArray *paths = [self indexPathsForSectionRange:NSMakeRange(0, 1) rowRange:rowRange];
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.activityArray addObjectsFromArray:activity];
        [self.tableView endUpdates];
    }
    
    if ([activity count] < SocializeActivityViewControllerPageSize) {
        self.loadedAllActivity = YES;
    }
}

- (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    [super service:service didFetchElements:dataArray];
    if ([service isKindOfClass:[SocializeActivityService class]]) {
        [self receiveNewActivity:dataArray];
    }
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    if ([service isKindOfClass:[SocializeActivityService class]]) {
        [self stopLoadingActivity];
    }
    [super service:service didFail:error];
}

- (UIImage*)iconForActivity:(SocializeActivity*)activity {
    UIImage *image = nil;
    
    if ([activity isMemberOfClass:[SocializeLike class]]) {
        image = [UIImage imageNamed:@"socialize-activity-cell-icon-like.png"];
    } else if ([activity isMemberOfClass:[SocializeComment class]]) {
        image = [UIImage imageNamed:@"socialize-activity-cell-icon-comment.png"];
    } else if ([activity isMemberOfClass:[SocializeShare class]]) {
        switch ([(SocializeShare*)activity medium]) {
            case SocializeShareMediumFacebook:
                image = [UIImage imageNamed:@"socialize-activity-cell-icon-facebook.png"];
                break;
            case SocializeShareMediumTwitter:
                image = [UIImage imageNamed:@"socialize-activity-cell-icon-twitter.png"];
                break;
            case SocializeShareMediumOther:
                image = [UIImage imageNamed:@"socialize-activity-cell-icon-share.png"];
                break;
        }
    }
    
    return image;
}

- (NSString*)commentTextForActivity:(SocializeActivity*)activity {
    NSString *commentText = nil;
    if ([activity isMemberOfClass:[SocializeComment class]]) {
        commentText = [(SocializeComment*)activity text];
    } else if ([activity isMemberOfClass:[SocializeShare class]]) {
        commentText = [(SocializeShare*)activity text];
    }
    
    return commentText;
}

- (NSString*)titleTextForActivity:(SocializeActivity*)activity {
    NSString *titleText = nil;
    NSString *entityName = activity.entity.name;
    if ([entityName length] == 0) {
        entityName = activity.entity.key;
    }
    
    if ([activity isMemberOfClass:[SocializeComment class]]) {
        titleText = [NSString stringWithFormat:@"Commented on %@", entityName];
    } else if ([activity isMemberOfClass:[SocializeShare class]]) {
        titleText = [NSString stringWithFormat:@"Shared %@", entityName];
    } else if ([activity isMemberOfClass:[SocializeLike class]]) {
        titleText = [NSString stringWithFormat:@"Likes %@", entityName];
    }
    
    return titleText;
}

-(NSString *) timeString:(NSDate *)date {
	NSString * formatString = @"%i%@";
	
	NSInteger timeInterval = (NSInteger) ceil(fabs([date timeIntervalSinceNow]));
	
	
	NSInteger daysHoursMinutesOrSeconds = timeInterval/(24*3600);
	if (daysHoursMinutesOrSeconds > 0) 
	{
		return [NSString stringWithFormat:formatString,daysHoursMinutesOrSeconds, @"d"]; 
	}
	
	daysHoursMinutesOrSeconds = timeInterval/3600;
	
	if (daysHoursMinutesOrSeconds > 0) 
	{
		return [NSString stringWithFormat:formatString,daysHoursMinutesOrSeconds, @"h"]; 
	}
	
	daysHoursMinutesOrSeconds = timeInterval/60;
	
	if (daysHoursMinutesOrSeconds > 0) 
	{
		return [NSString stringWithFormat:formatString,daysHoursMinutesOrSeconds, @"m"]; 
	}
	
	return [NSString stringWithFormat:formatString,timeInterval, @"s"];
}

- (NSString*)nameStringForActivity:(id<SocializeActivity>)activity {
    NSString *nameString;
    if ([activity.user.firstName length] > 0 && [activity.user.lastName length] > 0) {
        nameString = [NSString stringWithFormat:@"%@ %@", activity.user.firstName, activity.user.lastName];
    } else {
        nameString = activity.user.userName;
    }
    return nameString;
}

- (void)stopAnimatingProfileInCellAtIndexPath:(NSIndexPath*)indexPath {
    SocializeActivityTableViewCell *cell = (SocializeActivityTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.profileImageActivity stopAnimating];    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SocializeActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SocializeActivityTableViewCellReuseIdentifier];
    if (cell == nil) {
        cell = [self createActivityTableViewCell];
    }
    
    SocializeActivity *activity = [self.activityArray objectAtIndex:indexPath.row];
    cell.activityIcon.image = [self iconForActivity:activity];
    
    // FIXME +1 why?
    UIImage * backgroundImage = [UIImage imageNamed:@"socialize-cell-bg.png"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect backgroundImageFrame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height+1);
    imageView.frame = backgroundImageFrame;
    cell.backgroundView = imageView;
    [imageView release];
    
    NSString *nameString = [self nameStringForActivity:activity];
    NSString *timeString = [self timeString:activity.date];
    NSString * nameAndHourString = [NSString stringWithFormat:@"%@ about %@ ago", nameString, timeString];
	cell.nameLabel.text = nameAndHourString;
    
    // Allows us to associate activity with button when press event happens
	cell.btnViewProfile.tag = indexPath.row;
    
    // Commented on, shared, likes
	cell.activityTextLabel.text = [self titleTextForActivity:activity];
    
    // Populate comment text label for (comments and shares)
	cell.commentTextLabel.text = [self commentTextForActivity:activity];

    // Ensure activity indicator off for cells reused mid-load
    [cell.profileImageActivity stopAnimating];
    
    NSString *imageURL = activity.user.smallImageUrl;
    if (imageURL != nil) {
        [self loadImageAtURL:imageURL
                startLoading:^{
                    [cell.profileImageActivity startAnimating];
                } stopLoading:^{
                    // Reference indexPath instead of cell to stay resilient to cell reuse
                    [self stopAnimatingProfileInCellAtIndexPath:indexPath];
                } completion:^(UIImage *image) {
                    cell.profileImageView.image = image;
                }];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
    
    CGFloat offset = scrollView.contentOffset.y + scrollView.bounds.size.height;
    if (offset >= scrollView.contentSize.height && !self.waitingForActivity && !self.loadedAllActivity) {
        [self loadActivityForNextPage];
    }
}

- (IBAction)viewProfileButtonTouched:(UIButton*)button {
    SocializeActivity *activity = [self.activityArray objectAtIndex:button.tag];
    [self.delegate activityViewController:self profileTappedForUser:activity.user];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
