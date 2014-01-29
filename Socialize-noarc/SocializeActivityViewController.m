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
#import "_SZUserProfileViewController.h"
#import "SocializeTableBGInfoView.h"
#import "_Socialize.h"
#import "socialize_globals.h"
#import "UIDevice+VersionCheck.h"

@implementation SocializeActivityViewController
@synthesize activityTableViewCell = activityTableViewCell_;
@synthesize currentUser = currentUser_;
@synthesize delegate = delegate_;
@synthesize dontShowNames = dontShowNames_;
@synthesize dontShowDisclosure = dontShowDisclosure_;

- (void)dealloc {
    self.activityTableViewCell = nil;
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.activityTableViewCell = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.informationView.errorLabel.text = @"No Activity to Show";
    
    //iOS 7 adjustments for nav bar and cell separator
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (SocializeActivityTableViewCell*)createActivityTableViewCell {
    [[NSBundle mainBundle] loadNibNamed:[SocializeActivityViewController tableViewCellNibName] owner:self options:nil];
    SocializeActivityTableViewCell *cell = [[self.activityTableViewCell retain] autorelease];
    self.activityTableViewCell = nil;
    
    return cell;
}


//separate nibs for iOS 6/7 compatibility
//necessary as iOS 7 tables have "flat" look and legacy NIB displays artifacts in iOS 7
+ (NSString *)tableViewCellNibName {
    if([[UIDevice currentDevice] systemMajorVersion] < 7) {
        return @"SocializeActivityTableViewCell";
    }
    else {
        return @"SocializeActivityTableViewCellIOS7";
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SocializeActivityTableViewCellHeight;
}

- (void)loadActivityForUserID:(NSInteger)userID position:(NSInteger)position {
    [self.socialize getActivityOfUserId:userID
                                  first:[NSNumber numberWithInteger:position]
                                   last:[NSNumber numberWithInteger:position + self.pageSize]
                               activity:SocializeAllActivity];
}

- (void)loadContentForNextPageAtOffset:(NSInteger)offset {
    [self loadActivityForUserID:self.currentUser position:offset];
}

- (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    if ([service isKindOfClass:[SocializeActivityService class]]) {
        [self receiveNewContent:dataArray];
    }
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    if ([service isKindOfClass:[SocializeActivityService class]]) {
        [self failLoadingContent];
    }
    [super service:service didFail:error];
}

- (UIImage*)iconForActivity:(SocializeActivity*)activity {
    UIImage *image = nil;
    
    if ([activity isMemberOfClass:[SocializeLike class]]) {
        image = [UIImage imageNamed:@"socialize-activity-cell-icon-like.png"];
    }
    else if ([activity isMemberOfClass:[SocializeComment class]]) {
        image = [UIImage imageNamed:@"socialize-activity-cell-icon-comment.png"];
    }
    else if ([activity isMemberOfClass:[SocializeShare class]]) {
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
            default:
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

- (void)userSettingsChanged:(id<SocializeFullUser>)updatedSettings {
    id<SZFullUser> fullUser = updatedSettings;
    for (SocializeActivity *activity in self.content) {
        if (activity.user.objectID == fullUser.objectID) {
            activity.user.smallImageUrl = fullUser.smallImageUrl;
        }
    }
    [self.tableView reloadData];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SocializeActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SocializeActivityTableViewCellReuseIdentifier];
    if (cell == nil) {
        cell = [self createActivityTableViewCell];
    }
    
    SocializeActivity *activity = [self.content objectAtIndex:indexPath.row];
    cell.activityIcon.image = [self iconForActivity:activity];
    
    // FIXME +1 why?
    UIImage * backgroundImage = [UIImage imageNamed:@"socialize-activity-details-back-entry-x"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect backgroundImageFrame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height+1);
    imageView.frame = backgroundImageFrame;
    cell.backgroundView = imageView;
    [imageView release];
    
    NSString *nameString = [self nameStringForActivity:activity];
    NSString *timeString = [NSString stringWithHumanReadableIntegerAndSuffixSinceDate:activity.date];
    
    NSString *nameAndHourString;
    if (self.dontShowNames) {
        nameAndHourString = [NSString stringWithFormat:@"about %@ ago", timeString];
    } else {
        nameAndHourString = [NSString stringWithFormat:@"%@ about %@ ago", nameString, timeString];
    }
	cell.nameLabel.text = nameAndHourString;
    
    // Allows us to associate activity with button when press event happens
	cell.btnViewProfile.tag = indexPath.row;
    
    // Commented on, shared, likes
	cell.activityTextLabel.text = [self titleTextForActivity:activity];
    
    // Populate comment text label for (comments and shares)
	cell.commentTextLabel.text = [self commentTextForActivity:activity];

    // Ensure activity indicator off for cells reused mid-load
    [cell.profileImageActivity stopAnimating];
    
    BOOL noEntityLoader = [Socialize entityLoaderBlock] == nil;
    
    if (noEntityLoader) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.disclosureImage.hidden = noEntityLoader;
    
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

- (IBAction)viewProfileButtonTouched:(UIButton*)button {
    SocializeActivity *activity = [self.content objectAtIndex:button.tag];
    [self.delegate activityViewController:self profileTappedForUser:activity.user];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<SocializeActivity> activity = [self.content objectAtIndex:indexPath.row];
    [self.delegate activityViewController:self activityTapped:activity];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
