//
//  SZShareDialogViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/9/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SZShareDialogViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SocializeThirdPartyTwitter.h"
#import "SocializeThirdPartyFacebook.h"
#import "SZShareDialogView.h"
#import "SZShareUtils.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "UIControl+BlocksKit.h"

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

static NSString *kSocialNetworkSection = @"kSocialNetworkSection";
static NSString *kOtherSection = @"kOtherSection";

@interface SZShareDialogViewController ()
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *socialNetworkSection;
@property (nonatomic, retain) NSMutableDictionary *facebookRow;
@property (nonatomic, retain) NSMutableDictionary *twitterRow;
@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) UISwitch *twitterSwitch;
@end

@implementation SZShareDialogViewController
@synthesize shareDialogView = shareDialogView_;
@synthesize sections = sections_;
@synthesize socialNetworkSection = socializeNetworkSection_;
@synthesize entity = entity_;
@synthesize facebookRow = facebookRow_;
@synthesize twitterRow = twitterRow_;
@synthesize facebookSwitch = facebookSwitch_;
@synthesize twitterSwitch = twitterSwitch_;

- (void)dealloc {
    self.shareDialogView = nil;
    self.sections = nil;
    self.socialNetworkSection = nil;
    self.entity = nil;
    self.twitterRow = nil;
    self.facebookRow = nil;
    self.facebookSwitch = nil;
    self.twitterSwitch = nil;

    [super dealloc];
}
- (id)initWithEntity:(id<SZEntity>)entity {
    if (self = [super init]) {
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
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInterfaceToReflectSessionStatuses];
}

#define COPIED_BLOCK(identifier) [[identifier copy] autorelease]

- (void)setPostToFacebook:(BOOL)postToFacebook {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!postToFacebook] forKey:kSocializeDontPostToFacebookKey];    
}

- (void)setPostToTwitter:(BOOL)postToTwitter {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!postToTwitter] forKey:kSocializeDontPostToTwitterKey];    
}

- (void)updateFacebookSwitchIfNeeded {
    UISwitch *sw = self.facebookSwitch;

    BOOL wantsPost = ![[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDontPostToFacebookKey] boolValue];
    BOOL isLinked = [SZFacebookUtils isLinked];
    BOOL switchOn = wantsPost && isLinked;
    if (sw.on != switchOn) {
        [sw setOn:switchOn animated:YES];
    }
}

- (void)updateInterfaceToReflectFacebookSessionStatus {
    if (![SZFacebookUtils isAvailable]) {
        return;
    }
    
    [self updateFacebookSwitchIfNeeded];

    [self reloadRowWithIdentifier:kFacebookRow];
}

- (void)updateTwitterSwitchIfNeeded {
    UISwitch *sw = self.twitterSwitch;
    
    BOOL wantsPost = ![[[NSUserDefaults standardUserDefaults] objectForKey:kSocializeDontPostToTwitterKey] boolValue];
    BOOL isLinked = [SZTwitterUtils isLinked];
    BOOL switchOn = wantsPost && isLinked;
    if (sw.on != switchOn) {
        [sw setOn:switchOn animated:YES];
    }
}

- (void)updateInterfaceToReflectTwitterSessionStatus {
    if (![SZTwitterUtils isAvailable]) {
        return;
    }
    
    [self updateTwitterSwitchIfNeeded];
    
    [self reloadRowWithIdentifier:kTwitterRow];
}

- (void)updateInterfaceToReflectSessionStatuses {
    [self updateInterfaceToReflectTwitterSessionStatus];
    [self updateInterfaceToReflectFacebookSessionStatus];
}

- (UISwitch*)facebookSwitch {
    if (facebookSwitch_ == nil) {
        facebookSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        __block __typeof__(self) weakSelf = self;

        void (^controlChangedBlock)(UISwitch *sw) = ^(UISwitch *sw) {
            if (sw.on) {
                
                // Switch just turned on
                
                if ([SZFacebookUtils isLinked]) {
                    
                    // Already linked
                    [weakSelf setPostToFacebook:YES];
                } else {
                    
                    // Not linked -- Attempt link
                    [SZFacebookUtils linkWithViewController:weakSelf success:^(id<SZFullUser> fullUser) {
                        // Successfully linked
                        [weakSelf setPostToFacebook:YES];
                        [weakSelf reloadRowWithIdentifier:kFacebookRow];
                    } failure:^(NSError *error) {
                        
                        // Link failed
                        [sw setOn:NO animated:YES];
                        [weakSelf reloadRowWithIdentifier:kFacebookRow];
                        
                        if (![error isSocializeErrorWithCode:SocializeErrorFacebookCancelledByUser]) {
                            [weakSelf failWithError:error];
                        }
                    }];
                }
            } else {
                
                // Switch just turned off
                [weakSelf setPostToFacebook:NO];
            }
            
        };
        [facebookSwitch_ addEventHandler:controlChangedBlock forControlEvents:UIControlEventValueChanged];
    }
    
    return facebookSwitch_;
}

- (NSMutableDictionary*)facebookRow {
    if (facebookRow_ == nil) {
        
        void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
            if ([SZFacebookUtils isLinked]) {
                cell.imageView.image = [UIImage imageNamed:@"socialize-authorize-facebook-enabled-icon.png"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"socialize-authorize-facebook-disabled-icon.png"];
            }
            cell.textLabel.text = @"Facebook";
            cell.accessoryView = self.facebookSwitch;
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
        
        __block __typeof__(self) weakSelf = self;
        void (^controlChangedBlock)(UISwitch *sw) = ^(UISwitch *sw) {
            if (sw.on) {
                
                // Switch just turned on
                
                if ([SZTwitterUtils isLinked]) {
                    
                    // Already linked
                    [weakSelf setPostToTwitter:YES];
                } else {
                    
                    // Not linked -- Attempt link
                    [SZTwitterUtils linkWithViewController:weakSelf success:^(id<SZFullUser> fullUser) {
                        
                        // Successfully linked
                        [weakSelf setPostToTwitter:YES];
                        [weakSelf reloadRowWithIdentifier:kTwitterRow];
                    } failure:^(NSError *error) {
                        
                        // Link failed
                        [sw setOn:NO animated:YES];
                        [weakSelf reloadRowWithIdentifier:kTwitterRow];
                        
                        if (![error isSocializeErrorWithCode:SocializeErrorTwitterCancelledByUser]) {
                            [weakSelf failWithError:error];
                        }
                    }];
                }
            } else {
                
                // Switch just turned off
                [weakSelf setPostToTwitter:NO];
            }
            
        };
        
        [twitterSwitch_ addEventHandler:controlChangedBlock forControlEvents:UIControlEventValueChanged];
    }
    
    return twitterSwitch_;
}

- (NSDictionary*)twitterRow {
    if (twitterRow_ == nil) {
        void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
            if ([SZTwitterUtils isLinked]) {
                cell.imageView.image = [UIImage imageNamed:@"socialize-authorize-twitter-enabled-icon.png"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"socialize-authorize-twitter-disabled-icon.png"];
            }
            cell.textLabel.text = @"Twitter";
            cell.accessoryView = self.twitterSwitch;
        };

        twitterRow_ = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
                        kTwitterRow, kRowIdentifier,
                        COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
                        nil] retain];
    }
    
    return twitterRow_;
}

- (NSDictionary*)socialNetworkSection {
    NSArray *rows = [NSArray arrayWithObjects:[self facebookRow], [self twitterRow], nil];
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    };

    return [NSDictionary dictionaryWithObjectsAndKeys:
            kSocialNetworkSection, kSectionIdentifier,
            COPIED_BLOCK(cellConfigurationBlock), kSectionCellConfigurationBlock,
            rows, kSectionRows,
            nil];
}

- (NSDictionary*)SMSRow {
    void (^executionBlock)() = ^{
        [SZShareUtils shareViaSMSWithViewController:self entity:self.entity success:^(id<SZShare> share) {
            
        } failure:^(NSError *error) {
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];

            if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                [self failWithError:error];
            }
        }];
    };
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        cell.imageView.image = [UIImage imageNamed:@"socialize-selectnetwork-SMS-icon"];
        cell.textLabel.text = @"SMS";
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kSMSRow, kRowIdentifier,
            COPIED_BLOCK(cellConfigurationBlock), kRowCellConfigurationBlock,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            nil];
}

- (NSDictionary*)emailRow {
    void (^executionBlock)() = ^{
        [SZShareUtils shareViaEmailWithViewController:self entity:self.entity success:^(id<SZShare> share) {
            
        } failure:^(NSError *error) {
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];

            if (![error isSocializeErrorWithCode:SocializeErrorShareCancelledByUser]) {
                [self failWithError:error];
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
    NSArray *rows = [NSArray arrayWithObjects:[self emailRow], [self SMSRow], nil];
    
    void (^cellConfigurationBlock)(UITableViewCell*) = ^(UITableViewCell *cell) {
        
        if (![cell.accessoryView isKindOfClass:[UIImageView class]]) {
            UIImage *arrowImage = [UIImage imageNamed:@"socialize-activity-call-out-arrow.png"];
            cell.accessoryView = [[[UIImageView alloc] initWithImage:arrowImage] autorelease];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };

    return [NSDictionary dictionaryWithObjectsAndKeys:
            kOtherSection, kSectionIdentifier,
            rows, kSectionRows,
            COPIED_BLOCK(cellConfigurationBlock), kSectionCellConfigurationBlock,
            nil];
}

- (NSMutableArray*)sections {
    if (sections_ == nil) {
        sections_ = [[NSMutableArray alloc] initWithObjects:[self socialNetworkSection], [self otherSection], nil];
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
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    
    NSDictionary *sectionData = [self sectionForSectionNumber:indexPath.section];
    NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
    void (^sectionConfig)(UITableViewCell*) = [sectionData objectForKey:kSectionCellConfigurationBlock];
    void (^rowConfig)(UITableViewCell*) = [rowData objectForKey:kRowCellConfigurationBlock];
    BLOCK_CALL_1(sectionConfig, cell);
    BLOCK_CALL_1(rowConfig, cell);
    
    cell.backgroundColor = [UIColor colorWithRed:41/255.0f green:48/255.0f blue:54/255.0f alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
    void (^executionBlock)() = [rowData objectForKey:kRowExecutionBlock];

    BLOCK_CALL(executionBlock);
}

- (IBAction)continueButtonPressed:(id)sender {
}

@end
