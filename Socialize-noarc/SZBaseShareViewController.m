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
#import <SZJSONKit/JSONKit.h>
#import "SZEventUtils.h"
#import "SZPinterestUtils.h"
#import "SZWhatsAppUtils.h"
#import "SZNetworkImageProvider.h"
#import "UIDevice+VersionCheck.h"
#import <SZBlocksKit/BlocksKit+UIKit.h>

static NSString *CellIdentifier = @"CellIdentifier";

static NSString *kSectionIdentifier = @"kSectionIdentifier";
static NSString *kSectionRows = @"kSectionRows";
static NSString *kSectionCellConfigurationBlock = @"kSectionCellConfigurationBlock";

static NSString *kRowExecutionBlock = @"kRowExecutionBlock";
static NSString *kRowCellConfigurationBlock = @"kRowCellConfigurationBlock";
static NSString *kRowIdentifier = @"kRowIdentifier";

static NSString *kFacebookRow = @"kRowFacebook";
static NSString *kTwitterRow = @"kTwitterRow";
static NSString *kPinterestRow = @"kPinterestRow";
static NSString *kWhatsAppRow = @"kWhatsAppRow";
static NSString *kSMSRow = @"kSMSRow";
static NSString *kEmailRow = @"kEmailRow";
static NSString *kAutopostRow = @"kAutopostRow";

static NSString *kSocialNetworkSection = @"kSocialNetworkSection";
static NSString *kOtherSection = @"kOtherSection";
static NSString *kAutopostSection = @"kAutopostSection";

@interface SZBaseShareViewController () {
    dispatch_once_t _initToken;
}

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *socialNetworkSection;
@property (nonatomic, retain) NSMutableDictionary *facebookRow;
@property (nonatomic, retain) NSMutableDictionary *twitterRow;
@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) UISwitch *twitterSwitch;
@property (nonatomic, retain) UISwitch *autopostSwitch;
@end

@implementation SZBaseShareViewController
@synthesize createdShares = createdShares_;
@synthesize entity = entity_;
@synthesize shareDialogView = shareDialogView_;
@synthesize selectedNetworks = selectedNetworks_;
@synthesize showOtherShareTypes = showOtherShareTypes_;
@synthesize disableAutopostSelection = disableAutopostSelection_;
@synthesize hideUnlinkedNetworks = hideUnlinkedNetworks_;
@synthesize dontRequireNetworkSelection = dontRequireNetworkSelection_;
@synthesize headerView = headerView_;
@synthesize footerView = footerView_;
@synthesize continueText = continueText_;
@synthesize shareOptions = shareOptions_;

@synthesize sections = sections_;
@synthesize socialNetworkSection = socializeNetworkSection_;
@synthesize facebookRow = facebookRow_;
@synthesize twitterRow = twitterRow_;
@synthesize facebookSwitch = facebookSwitch_;
@synthesize twitterSwitch = twitterSwitch_;
@synthesize autopostSwitch = autopostSwitch_;

- (void)dealloc {
    self.createdShares = nil;
    self.entity = nil;
    self.shareDialogView = nil;
    self.headerView = nil;
    self.footerView = nil;
    self.continueText = nil;
    self.shareOptions = nil;
    
    self.sections = nil;
    self.socialNetworkSection = nil;
    self.facebookRow = nil;
    self.twitterRow = nil;
    self.facebookSwitch = nil;
    self.twitterSwitch = nil;
    self.autopostSwitch = nil;
    
    [SZFacebookUtils cancelLink];

    [super dealloc];
}

- (void)setHeaderView:(UIView *)headerView {
    NonatomicRetainedSetToFrom(headerView_, headerView);
    [self.shareDialogView setHeaderView:headerView];
}

- (void)setFooterView:(UIView *)footerView {
    NonatomicRetainedSetToFrom(footerView_, footerView);
    [self.shareDialogView setFooterView:footerView];
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
    if ([SZLocationUtils lastKnownLocation] == nil && ![Socialize locationSharingDisabled] && !self.shareOptions.dontShareLocation) {
        [SZLocationUtils getCurrentLocationWithSuccess:nil failure:nil];
    }
         
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    WEAK(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem blueSocializeBarButtonWithTitle:@"Continue" handler:^(id sender) {
        [weakSelf continueButtonPressed:nil];
    }];
    
    if ([self.continueText length]) {
        [self.navigationItem.rightBarButtonItem changeTitleOnCustomButtonToText:self.continueText];
    }
                                              
    if (self.headerView != nil) {
        self.shareDialogView.headerView = self.headerView;
    }
    
    if (self.footerView != nil) {
        self.shareDialogView.footerView = self.footerView;
    }
    
    //iOS 7 adjustments for nav bar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)updateContinueButtonState {
    SZSocialNetwork selectedNetworks = [self selectedNetworks];
    self.navigationItem.rightBarButtonItem.enabled = self.dontRequireNetworkSelection || selectedNetworks != SZSocialNetworkNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.navigationController.viewControllers count] >= 2) {
        [self.cancelButton changeTitleOnCustomButtonToText:@"Back"];
    }
    
    dispatch_once(&_initToken, ^{
        [self updateContinueButtonState];
    });
}

- (void)deselectSelectedRow {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath != nil) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self syncInterfaceWithThirdPartyState];

    [self deselectSelectedRow];
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
    [self updateContinueButtonState];
}

- (UISwitch*)facebookSwitch {
    if (facebookSwitch_ == nil) {
        facebookSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        facebookSwitch_.accessibilityLabel = @"Facebook Switch";
        
        WEAK(self) weakSelf = self;

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
            } else {
                [weakSelf syncInterfaceWithThirdPartyState];
            }
            
        };
        [facebookSwitch_ bk_addEventHandler:controlChangedBlock forControlEvents:UIControlEventValueChanged];
        
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
        
        WEAK(self) weakSelf = self;

        void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
            cell.imageView.image = [SZNetworkImageProvider facebookSelectNetworkImage:[SZFacebookUtils isLinked]];
            cell.textLabel.text = @"Facebook";
            UIView* holder = [[[UIView alloc] initWithFrame:CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.x, weakSelf.facebookSwitch.frame.size.width, weakSelf.facebookSwitch.frame.size.height)] autorelease];
            [holder addSubview:weakSelf.facebookSwitch];
            cell.accessoryView = holder;
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
        
        WEAK(self) weakSelf = self;
        void (^controlChangedBlock)(UISwitch *sw) = ^(UISwitch *sw) {
            if (sw.on && ![SZTwitterUtils isLinked]) {
                
                // Switch just turned on, not already linked
                
                // Attempt link
                [SZTwitterUtils linkWithViewController:weakSelf.SZPresentationTarget success:^(id<SZFullUser> fullUser) {
                    
                    // Successfully linked
                    [weakSelf syncInterfaceWithThirdPartyState];
                } failure:^(NSError *error) {
                    
                    // Link failed
                    [weakSelf syncInterfaceWithThirdPartyState];
                    
                    if (![error isSocializeErrorWithCode:SocializeErrorTwitterCancelledByUser]) {
                        [weakSelf failWithError:error];
                    }
                }];
            } else {
                [weakSelf syncInterfaceWithThirdPartyState];
            }
        };
        
        if ([SZTwitterUtils isAvailable]) {
            BOOL wantsTwitterPost = ![[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDontPostToTwitterKey] boolValue];
            BOOL twitterIsLinked = [SZTwitterUtils isLinked];
            [twitterSwitch_ setOn:wantsTwitterPost && twitterIsLinked animated:NO];
        }

        [twitterSwitch_ bk_addEventHandler:controlChangedBlock forControlEvents:UIControlEventValueChanged];
    }
    
    return twitterSwitch_;
}

- (NSDictionary*)twitterRow {
    if (twitterRow_ == nil) {

        WEAK(self) weakSelf = self;

        void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
            cell.imageView.image = [SZNetworkImageProvider twitterSelectNetworkImage:[SZTwitterUtils isLinked]];
            cell.textLabel.text = @"Twitter";
            UIView* holder = [[[UIView alloc] initWithFrame:CGRectMake(cell.accessoryView.frame.origin.x,
                                                                       cell.accessoryView.frame.origin.x,
                                                                       weakSelf.facebookSwitch.frame.size.width,
                                                                       weakSelf.facebookSwitch.frame.size.height)] autorelease];
            [holder addSubview:weakSelf.twitterSwitch];
            cell.accessoryView = holder;
        };

        twitterRow_ = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
                        kTwitterRow, kRowIdentifier,
                        COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
                        nil] retain];
    }
    
    return twitterRow_;
}

- (BOOL)showFacebook {
    return [SZFacebookUtils isAvailable] && !(self.hideUnlinkedNetworks && ![SZFacebookUtils isLinked]) && !self.hideFacebook;
}

- (BOOL)showTwitter {
    return [SZTwitterUtils isAvailable] && !(self.hideUnlinkedNetworks && ![SZTwitterUtils isLinked]) && !self.hideTwitter;
}

- (BOOL)showSocialNetworkSection {
    return [self showFacebook] || [self showTwitter];
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
        [SZEventUtils trackEventWithBucket:SHARE_DIALOG_BUCKET values:values success:nil failure:nil];
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

- (SZShareOptions*)optionsForShare {
    SZShareOptions *shareOptions = self.shareOptions;
    if (shareOptions == nil) shareOptions = [SZShareUtils userShareOptions];
    
    return shareOptions;
}

- (NSDictionary*)PinterestRow {
    
    WEAK(self) weakSelf = self;
    
    void (^executionBlock)() = ^{
        [weakSelf trackShareEventsForNetworkNames:[NSArray arrayWithObject:@"Pinterest"]];
        [SZPinterestUtils shareViaPinterestWithViewController:weakSelf.SZPresentationTarget options:[weakSelf shareOptions] entity:weakSelf.entity success:^(id<SocializeShare> share) {
            [weakSelf deselectSelectedRow];
            [weakSelf.createdShares addObject:share];
        } failure:^(NSError *error) {
            [weakSelf deselectSelectedRow];
            
            if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                [weakSelf failWithError:error];
            };
        }];
    };
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = [SZNetworkImageProvider pinterestSelectImage];
        cell.textLabel.text = @"Pinterest";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = [UIColor whiteColor];
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kPinterestRow, kRowIdentifier,
            COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            nil];
}

- (NSDictionary*)WhatsAppRow {
    
    WEAK(self) weakSelf = self;
    
    void (^executionBlock)() = ^{
        [weakSelf trackShareEventsForNetworkNames:[NSArray arrayWithObject:@"WhatsApp"]];
        [SZWhatsAppUtils shareViaWhatsAppWithViewController:weakSelf.SZPresentationTarget
                                                    options:[weakSelf shareOptions]
                                                     entity:weakSelf.entity
                                                    success:^(id<SocializeShare> share) {
                                                        [weakSelf deselectSelectedRow];
                                                        [weakSelf.createdShares addObject:share];
                                                    }
                                                    failure:^(NSError *error) {
                                                        [weakSelf deselectSelectedRow];
                                                        
                                                        if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                                                            [weakSelf failWithError:error];
                                                        };
                                                    }];
    };
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = [SZNetworkImageProvider whatsAppSelectImage];
        cell.textLabel.text = @"WhatsApp";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = [UIColor whiteColor];
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kWhatsAppRow, kRowIdentifier,
            COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            nil];
}

- (NSDictionary*)SMSRow {
    
    WEAK(self) weakSelf = self;

    void (^executionBlock)() = ^{
        [weakSelf trackShareEventsForNetworkNames:[NSArray arrayWithObject:@"SMS"]];
        
        [SZShareUtils shareViaSMSWithViewController:weakSelf.SZPresentationTarget options:[self optionsForShare] entity:weakSelf.entity success:^(id<SZShare> share) {
            [weakSelf deselectSelectedRow];
            [weakSelf.createdShares addObject:share];
        } failure:^(NSError *error) {
            [weakSelf deselectSelectedRow];

            if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                [weakSelf failWithError:error];
            }
        }];
    };
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = [SZNetworkImageProvider smsSelectImage];//[UIImage imageNamed:@"socialize-selectnetwork-SMS-icon"];
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
    
    WEAK(self) weakSelf = self;
    
    void (^executionBlock)() = ^{
        [weakSelf trackShareEventsForNetworkNames:[NSArray arrayWithObject:@"SMS"]];

        [SZShareUtils shareViaEmailWithViewController:weakSelf.SZPresentationTarget options:[weakSelf optionsForShare] entity:weakSelf.entity success:^(id<SZShare> share) {
            [weakSelf deselectSelectedRow];

            [weakSelf.createdShares addObject:share];
        } failure:^(NSError *error) {
            [weakSelf deselectSelectedRow];

            if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                [weakSelf failWithError:error];
            }
        }];

    };
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = [SZNetworkImageProvider emailSelectImage];//[UIImage imageNamed:@"socialize-selectnetwork-email-icon"];
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
    if ([self showEmail]) {
        [rows addObject:[self emailRow]];
    }

    if ([self showSMS]) {
        [rows addObject:[self SMSRow]];
    }
    
    if ([self showPinterest]) {
        [rows addObject:[self PinterestRow]];
    }
    
    if ([self showWhatsApp]) {
        [rows addObject:[self WhatsAppRow]];
    }
    
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
    
    WEAK(self) weakSelf = self;
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = weakSelf.autopostSwitch;
        cell.textLabel.text = @"Remember Selection";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        //different text shadow rules for different versions
        if([[UIDevice currentDevice] systemMajorVersion] < 7) {
            cell.textLabel.shadowOffset = CGSizeMake(0, -1);
            cell.textLabel.shadowColor = [UIColor blackColor];
        }
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
    return self.showOtherShareTypes && [SZShareUtils canShareViaSMS] && !self.hideSMS;
}

- (BOOL)showEmail {
    return self.showOtherShareTypes && [SZShareUtils canShareViaEmail] && !self.hideEmail;
}

- (BOOL)showPinterest {
    return self.showOtherShareTypes && [SZPinterestUtils isAvailable] && !self.hidePinterest;
}

- (BOOL)showWhatsApp {
    return self.showOtherShareTypes && [SZWhatsAppUtils isAvailable] && !self.hideWhatsApp;
}

- (BOOL)showOtherShareTypesSection {
    return self.showOtherShareTypes && ([self showSMS] || [self showEmail]);
}

- (BOOL)showAutopost {
    return !self.disableAutopostSelection;
}

- (NSMutableArray*)sections {
    if (sections_ == nil) {
        sections_ = [[NSMutableArray alloc] init];
        
        if ([self showSocialNetworkSection]) {
            [sections_ addObject:[self socialNetworkSection]];
        }
        
        if ([self showOtherShareTypesSection]) {
            [sections_ addObject:[self otherSection]];
        }
        if ([self showAutopost]) {
            [sections_ addObject:[self autopostSection]];
        }
    }
    
    return sections_;
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
