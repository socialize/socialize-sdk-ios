//
//  SZBaseShareViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZBaseShareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyFacebook.h"
#import "SZShareDialogView.h"
#import "SZShareUtils.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SDKHelpers.h"
#import "socialize_globals.h"
#import "SZLocationUtils.h"
#import <JSONKit/JSONKit.h>

static NSString *CellIdentifier = @"CellIdentifier";

static NSString *kSectionIdentifier = @"kSectionIdentifier";
static NSString *kSectionTitle = @"kSectionTitle";
static NSString *kSectionRows = @"kSectionRows";
static NSString *kSectionCellConfigurationBlock = @"kSectionCellConfigurationBlock";

static NSString *kRowExecutionBlock = @"kRowExecutionBlock";
static NSString *kRowCellConfigurationBlock = @"kRowCellConfigurationBlock";
static NSString *kRowIdentifier = @"kRowIdentifier";

static NSString *kFacebookRow = @"kRowFacebook";
static NSString *kTwitterRow = @"kTwitterRow";
static NSString *kSMSRow = @"kSMSRow";
static NSString *kEmailRow = @"kEmailRow";
static NSString *kAutopostRow = @"kAutopostRow";

static NSString *kSocialNetworkSection = @"kSocialNetworkSection";
static NSString *kOtherSection = @"kOtherSection";
static NSString *kAutopostSection = @"kAutopostSection";

@interface SZBaseShareViewController ()
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *socialNetworkSection;
@property (nonatomic, retain) NSMutableDictionary *facebookRow;
@property (nonatomic, retain) NSMutableDictionary *twitterRow;
@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) UISwitch *twitterSwitch;
@property (nonatomic, retain) UISwitch *autopostSwitch;
@end

@implementation SZBaseShareViewController
@synthesize shareDialogView = shareDialogView_;
@synthesize sections = sections_;
@synthesize socialNetworkSection = socializeNetworkSection_;
@synthesize entity = entity_;
@synthesize facebookRow = facebookRow_;
@synthesize twitterRow = twitterRow_;
@synthesize facebookSwitch = facebookSwitch_;
@synthesize twitterSwitch = twitterSwitch_;
@synthesize autopostSwitch = autopostSwitch_;
@synthesize selectedNetworks = selectedNetworks_;
@synthesize showOtherShareTypes = showOtherShareTypes_;
@synthesize disableAutopostSelection = disableAutopostSelection_;
@synthesize completionBlock = completionBlock_;
@synthesize hideUnlinkedNetworks = hideUnlinkedNetworks_;
@synthesize dontRequireNetworkSelection = dontRequireNetworkSelection_;
@synthesize createdShares = createdShares_;
@synthesize headerView = headerView_;

- (void)dealloc {
    self.shareDialogView = nil;
    self.sections = nil;
    self.socialNetworkSection = nil;
    self.entity = nil;
    self.twitterRow = nil;
    self.facebookRow = nil;
    self.autopostSwitch = nil;
    self.facebookSwitch = nil;
    self.twitterSwitch = nil;
    self.completionBlock = nil;
    
    [SZFacebookUtils cancelLink];

    [super dealloc];
}

- (void)setHeaderView:(UIView *)headerView {
    NonatomicRetainedSetToFrom(headerView_, headerView);
    [self.shareDialogView setHeaderView:headerView];
}

- (NSMutableArray*)createdShares {
    if (createdShares_ == nil) {
        createdShares_ = [[NSMutableArray alloc] init];
    }
    
    return createdShares_;
}

- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super initWithNibName:@"SZBaseShareViewController" bundle:nil]) {
        self.entity = entity;
    }
    
    return self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.shareDialogView = nil;
    self.sections = nil;
    self.socialNetworkSection = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Fire off a first-time location request as soon as this view shows
    if ([SZLocationUtils lastKnownLocation] == nil) {
        [SZLocationUtils getCurrentLocationWithSuccess:nil failure:nil];
    }
         
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    if (self.headerView != nil) {
        self.shareDialogView.headerView = self.headerView;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.navigationController.viewControllers count] >= 2) {
        [self.cancelButton changeTitleOnCustomButtonToText:@"Back"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self syncInterfaceWithThirdPartyState];

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath != nil) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#define COPIED_BLOCK(identifier) [[identifier copy] autorelease]

- (SZSocialNetwork)selectedNetworks {
    SZSocialNetwork networks = SZSocialNetworkNone;
    if ([SZTwitterUtils isAvailable] && self.twitterSwitch.on) {
        networks |= SZSocialNetworkTwitter;
    }
    
    if ([SZFacebookUtils isAvailable] && self.facebookSwitch.on) {
        networks |= SZSocialNetworkFacebook;
    }
    
    return networks;
}

- (void)syncInterfaceWithThirdPartyState {
    // Because of some API weirdness, it's possible for a third party to be unlinked when another is linked. Handle this.
    
    if (![SZTwitterUtils isLinked] && self.twitterSwitch.on) {
        [self.twitterSwitch setOn:NO animated:YES];
    }
    
    if (![SZFacebookUtils isLinked] && self.facebookSwitch.on) {
        [self.facebookSwitch setOn:NO animated:YES];
    }
    
    [self reloadRowWithIdentifier:kTwitterRow];
    [self reloadRowWithIdentifier:kFacebookRow];
}

- (UISwitch*)facebookSwitch {
    if (facebookSwitch_ == nil) {
        facebookSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        facebookSwitch_.accessibilityLabel = @"Facebook Switch";
        
        __block __typeof__(self) weakSelf = self;

        void (^controlChangedBlock)(UISwitch *sw) = ^(UISwitch *sw) {
            if (sw.on && ![SZFacebookUtils isLinked]) {
                
                // Switch just turned on
                // Attempt link
                
                SZShowLinkToFacebookAlertView(^{

                    [SZFacebookUtils linkWithOptions:nil success:^(id<SZFullUser> fullUser) {
                        // Successfully linked
                        [weakSelf syncInterfaceWithThirdPartyState];
                    } foreground:^{
                        [weakSelf syncInterfaceWithThirdPartyState];                        
                    } failure:^(NSError *error) {
                        
                        // Link failed
                        [weakSelf syncInterfaceWithThirdPartyState];
                        
                        if (![error isSocializeErrorWithCode:SocializeErrorFacebookCancelledByUser]) {
                            [weakSelf failWithError:error];
                        }
                    }];
                }, ^{
                    [weakSelf syncInterfaceWithThirdPartyState];
                });
            }
            
        };
        [facebookSwitch_ addEventHandler:controlChangedBlock forControlEvents:UIControlEventValueChanged];
        
        if ([SZFacebookUtils isAvailable]) {
            BOOL wantsFacebookPost = ![[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDontPostToFacebookKey] boolValue];
            BOOL facebookIsLinked = [SZFacebookUtils isLinked];
            [facebookSwitch_ setOn:wantsFacebookPost && facebookIsLinked animated:NO];
        }
    }
    
    return facebookSwitch_;
}

- (NSMutableDictionary*)facebookRow {
    if (facebookRow_ == nil) {
        
        __block __typeof__(self) weakSelf = self;

        void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
            if ([SZFacebookUtils isLinked]) {
                cell.imageView.image = [UIImage imageNamed:@"socialize-selectnetwork-facebook-icon.png"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"socialize-selectnetwork-facebook-dis-icon.png"];
            }
            cell.textLabel.text = @"Facebook";
            cell.accessoryView = weakSelf.facebookSwitch;
        };

        facebookRow_ = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
                         kFacebookRow, kRowIdentifier,
                         COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
                         nil] retain];
    }
    
    return facebookRow_;
}

- (UISwitch*)twitterSwitch {
    if (twitterSwitch_ == nil) {
        twitterSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        twitterSwitch_.accessibilityLabel = @"Twitter Switch";
        
        __block __typeof__(self) weakSelf = self;
        void (^controlChangedBlock)(UISwitch *sw) = ^(UISwitch *sw) {
            if (sw.on && ![SZTwitterUtils isLinked]) {
                
                // Switch just turned on, not already linked
                
                // Attempt link
                [SZTwitterUtils linkWithViewController:weakSelf success:^(id<SZFullUser> fullUser) {
                    
                    // Successfully linked
                    [weakSelf syncInterfaceWithThirdPartyState];
                } failure:^(NSError *error) {
                    
                    // Link failed
                    [weakSelf syncInterfaceWithThirdPartyState];
                    
                    if (![error isSocializeErrorWithCode:SocializeErrorTwitterCancelledByUser]) {
                        [weakSelf failWithError:error];
                    }
                }];
            }
        };
        
        if ([SZTwitterUtils isAvailable]) {
            BOOL wantsTwitterPost = ![[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDontPostToTwitterKey] boolValue];
            BOOL twitterIsLinked = [SZTwitterUtils isLinked];
            [twitterSwitch_ setOn:wantsTwitterPost && twitterIsLinked animated:NO];
        }

        [twitterSwitch_ addEventHandler:controlChangedBlock forControlEvents:UIControlEventValueChanged];
    }
    
    return twitterSwitch_;
}

- (NSDictionary*)twitterRow {
    if (twitterRow_ == nil) {

        __block __typeof__(self) weakSelf = self;

        void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
            if ([SZTwitterUtils isLinked]) {
                cell.imageView.image = [UIImage imageNamed:@"socialize-selectnetwork-twitter-icon.png"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"socialize-selectnetwork-twitter-dis-icon.png"];
            }
            cell.textLabel.text = @"Twitter";
            cell.accessoryView = weakSelf.twitterSwitch;
        };

        twitterRow_ = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
                        kTwitterRow, kRowIdentifier,
                        COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
                        nil] retain];
    }
    
    return twitterRow_;
}

- (BOOL)showFacebook {
    return [SZFacebookUtils isAvailable] && !(self.hideUnlinkedNetworks && ![SZFacebookUtils isLinked]);
}

- (BOOL)showTwitter {
    return [SZTwitterUtils isAvailable] && !(self.hideUnlinkedNetworks && ![SZTwitterUtils isLinked]);
}

                                              
- (NSDictionary*)socialNetworkSection {
    NSMutableArray *rows = [NSMutableArray array];

    if ([self showFacebook]) {
        [rows addObject:[self facebookRow]];
    }

    if ([self showTwitter]) {
        [rows addObject:[self twitterRow]];
    }

    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = [UIColor whiteColor];
    };

    return [NSDictionary dictionaryWithObjectsAndKeys:
            kSocialNetworkSection, kSectionIdentifier,
            COPIED_BLOCK(cellConfigurationBlock), kSectionCellConfigurationBlock,
            rows, kSectionRows,
            nil];
}

- (void)trackShareEventsForNetworkNames:(NSArray*)networkNames {
    if ([networkNames count]) {
        NSString *jsonNetworks = [networkNames JSONString];
        NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:@"share", @"action", jsonNetworks, @"networks", nil];
        [[Socialize sharedSocialize] trackEventWithBucket:SHARE_DIALOG_BUCKET values:values];
    }
}

- (void)trackShareEventsForNetworks:(SZSocialNetwork)networks {
    NSMutableArray *networkNames = [NSMutableArray array];
    for (Class<SocializeThirdParty> thirdParty in [SocializeThirdParty allThirdParties]) {
        if (networks & [thirdParty socialNetworkFlag]) {
            [networkNames addObject:[thirdParty thirdPartyName]];
        }
    }
    
    [self trackShareEventsForNetworkNames:networkNames];
}

- (NSDictionary*)SMSRow {
    
    __block __typeof__(self) weakSelf = self;

    void (^executionBlock)() = ^{
        [weakSelf trackShareEventsForNetworkNames:[NSArray arrayWithObject:@"SMS"]];
        
        [SZShareUtils shareViaSMSWithViewController:weakSelf entity:weakSelf.entity success:^(id<SZShare> share) {
            [weakSelf.createdShares addObject:share];
        } failure:^(NSError *error) {
            [weakSelf.tableView deselectRowAtIndexPath:weakSelf.tableView.indexPathForSelectedRow animated:YES];

            if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                [weakSelf failWithError:error];
            }
        }];
    };
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = [UIImage imageNamed:@"socialize-selectnetwork-SMS-icon"];
        cell.textLabel.text = @"SMS";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = [UIColor whiteColor];
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kSMSRow, kRowIdentifier,
            COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            nil];
}

- (NSDictionary*)emailRow {
    
    __block __typeof__(self) weakSelf = self;
    
    void (^executionBlock)() = ^{
        [weakSelf trackShareEventsForNetworkNames:[NSArray arrayWithObject:@"SMS"]];

        [SZShareUtils shareViaEmailWithViewController:weakSelf entity:weakSelf.entity success:^(id<SZShare> share) {
            [weakSelf.createdShares addObject:share];
        } failure:^(NSError *error) {
            [weakSelf.tableView deselectRowAtIndexPath:weakSelf.tableView.indexPathForSelectedRow animated:YES];

            if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                [weakSelf failWithError:error];
            }
        }];

    };
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = [UIImage imageNamed:@"socialize-selectnetwork-email-icon"];
        cell.textLabel.text = @"Email";
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kEmailRow, kRowIdentifier,
            COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            nil];
}

- (NSDictionary*)otherSection {
    NSMutableArray *rows = [NSMutableArray array];
    if ([SZShareUtils canShareViaEmail]) {
        [rows addObject:[self emailRow]];
    }

//    if ([SZShareUtils canShareViaSMS]) {
        [rows addObject:[self SMSRow]];
//    }
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        
        if (![cell.accessoryView isKindOfClass:[UIImageView class]]) {
            UIImage *arrowImage = [UIImage imageNamed:@"socialize-activity-call-out-arrow.png"];
            cell.accessoryView = [[[UIImageView alloc] initWithImage:arrowImage] autorelease];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = [UIColor whiteColor];
    };

    return [NSDictionary dictionaryWithObjectsAndKeys:
            kOtherSection, kSectionIdentifier,
            rows, kSectionRows,
            COPIED_BLOCK(cellConfigurationBlock), kSectionCellConfigurationBlock,
            nil];
}

- (UISwitch*)autopostSwitch {
    if (autopostSwitch_ == nil) {
        autopostSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        BOOL autopost = [[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeAutoPostToSocialNetworksKey] boolValue];
        [autopostSwitch_ setOn:autopost animated:NO];
    }
    
    return autopostSwitch_;
}

- (NSDictionary*)autopostRow {
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = self.autopostSwitch;
        cell.textLabel.text = @"Always post to selected networks";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.shadowOffset = CGSizeMake(0, -1);
        cell.textLabel.shadowColor = [UIColor blackColor];
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kAutopostRow, kRowIdentifier,
            COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
            nil];
}

- (NSDictionary*)autopostSection {
    NSArray *rows = [NSArray arrayWithObjects:[self autopostRow], nil];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kAutopostSection, kSectionIdentifier,
            rows, kSectionRows,
            nil];
}

- (BOOL)showSMS {
    return self.showOtherShareTypes && [SZShareUtils canShareViaSMS];
}

- (BOOL)showEmail {
    return self.showOtherShareTypes && [SZShareUtils canShareViaEmail];
}

- (BOOL)showOtherShareTypesSection {
    return [self showSMS] || [self showEmail];
}

- (BOOL)showAutopost {
    return !self.disableAutopostSelection;
}

- (NSMutableArray*)sections {
    if (sections_ == nil) {
        sections_ = [[NSMutableArray alloc] init];
        [sections_ addObject:[self socialNetworkSection]];
        if ([self showOtherShareTypes]) {
            [sections_ addObject:[self otherSection]];
        }
        if ([self showAutopost]) {
            [sections_ addObject:[self autopostSection]];
        }
    }
    
    return sections_;
    
//    if (sections_ == nil) {
////        sections_ = [[NSMutableArray alloc] init];
//        (void
//         if ([self showOtherShareTypes]) {
//             [[sections_ addObject:[self otherSection]];
//              }
//         [self socialNetworkSection], [self otherSection], [self autopostSection], nil];
//    }
//    return sections_;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSArray*)rowsForSectionNumber:(NSInteger)section {
    NSDictionary *sectionData = [self.sections objectAtIndex:section];
    NSArray *rows = [sectionData objectForKey:kSectionRows];
    return rows;
}

- (NSMutableDictionary*)rowDataForIndexPath:(NSIndexPath*)indexPath {
    NSArray *rows = [self rowsForSectionNumber:indexPath.section];
    return [rows objectAtIndex:indexPath.row];
}

- (NSDictionary*)sectionForSectionNumber:(NSInteger)sectionNumber {
    return [self.sections objectAtIndex:sectionNumber];
}

- (NSIndexPath*)indexPathForRowIdentifier:(NSString*)rowIdentifier {
    for (int section = 0; section < [self.tableView numberOfSections]; section++) {
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
            if ([[rowData objectForKey:kRowIdentifier] isEqualToString:rowIdentifier]) {
                return indexPath;
            }
        }
    }
    
    return nil;
}

- (UITableViewCell*)cellForRowIdentifier:(NSString*)identifier {
    NSIndexPath *path = [self indexPathForRowIdentifier:identifier];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    return cell;
}

- (UIControl*)controlForRowIdentifier:(NSString*)identifier {
    UITableViewCell *cell = [self cellForRowIdentifier:identifier];
    UIView *accessoryView = cell.accessoryView;
    if ([accessoryView isKindOfClass:[UIControl class]]) {
        return (UIControl*)accessoryView;
    }
    
    return nil;
}

- (void)reloadRowWithIdentifier:(NSString*)identifier {
    NSIndexPath *indexPath = [self indexPathForRowIdentifier:identifier];
    
    if (indexPath != nil) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (NSDictionary*)sectionDataForSection:(NSUInteger)section {
    return [self.sections objectAtIndex:section];
}

- (NSMutableDictionary*)rowDataForRowIdentifier:(NSString*)rowIdentifier {
    NSIndexPath *indexPath = [self indexPathForRowIdentifier:rowIdentifier];
    return [self rowDataForIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [self rowsForSectionNumber:section];
    return [rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 45;
    }
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
        
    cell.backgroundColor = [UIColor colorWithRed:41/255.0f green:48/255.0f blue:54/255.0f alpha:1.0];
    cell.textLabel.shadowOffset = CGSizeMake(0, 0);
    cell.textLabel.shadowColor = [UIColor clearColor];
    
    NSDictionary *sectionData = [self sectionForSectionNumber:indexPath.section];
    NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
    void (^sectionConfig)(UITableViewCell*) = [sectionData objectForKey:kSectionCellConfigurationBlock];
    void (^rowConfig)(UITableViewCell*) = [rowData objectForKey:kRowCellConfigurationBlock];
    BLOCK_CALL_1(sectionConfig, cell);
    BLOCK_CALL_1(rowConfig, cell);

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
    void (^executionBlock)() = [rowData objectForKey:kRowExecutionBlock];

    BLOCK_CALL(executionBlock);
}

- (void)persistSelection {
    SZSocialNetwork networks = [self selectedNetworks];

    if ([self showFacebook]) {
        BOOL postToFacebook = (networks & SZSocialNetworkFacebook);
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!postToFacebook] forKey:kSocializeDontPostToFacebookKey];
    }
    
    if ([self showTwitter]) {
        BOOL postToTwitter = (networks & SZSocialNetworkTwitter);
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!postToTwitter] forKey:kSocializeDontPostToTwitterKey];
    }
    
    if ([self showAutopost]) {
        BOOL autopost = self.autopostSwitch.isOn;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:autopost] forKey:kSocializeAutoPostToSocialNetworksKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)continueButtonPressed:(id)sender {
}

- (void)socializeWillStartLoadingWithMessage:(NSString *)message {
    [super startLoading];
    self.cancelButton.enabled = NO;
}

- (void)socializeWillStopLoading {
    [super stopLoading];
    self.cancelButton.enabled = YES;
}

@end
