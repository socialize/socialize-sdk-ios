//
//  SampleListViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SampleListViewController.h"
#import "SZUserUtils.h"
#import "SZShareUtils.h"
#import "SocializeEntity.h"
#import "UIAlertView+BlocksKit.h"
#import "SZCommentUtils.h"
#import "SZComposeCommentViewController.h"
#import "SZLikeUtils.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SampleSdkAppAppDelegate.h"

static NSString *CellIdentifier = @"CellIdentifier";

static NSString *kSectionIdentifier = @"kSectionIdentifier";
static NSString *kSectionTitle = @"kSectionTitle";
static NSString *kSectionRows = @"kSectionRows";

static NSString *kRowExecutionBlock = @"kRowExecutionBlock";
static NSString *kRowText = @"kRowText";

static NSString *kUserSection = @"kUserSection";
static NSString *kShareSection = @"kShareSection";
static NSString *kCommentSection = @"kCommentSection";
static NSString *kLikeSection = @"kLikeSection";
static NSString *kFacebookSection = @"kFacebookSection";
static NSString *kTwitterSection = @"kTwitterSection";

@interface SampleListViewController ()
@property (nonatomic, retain) NSArray *sections;
@end

@implementation SampleListViewController
@synthesize sections = sections_;

- (void)dealloc {
    self.sections = nil;
    
    [super dealloc];
}

- (NSArray*)createSections {
    
    // User Utilities
    NSMutableArray *userRows = [NSMutableArray array];
    
    [userRows addObject:[self rowWithText:@"Show Link Dialog" executionBlock:^{
        [SZUserUtils showLinkDialogWithDisplay:self success:nil failure:nil];
    }]];

    [userRows addObject:[self rowWithText:@"Show User Profile" executionBlock:^{
        id<SocializeFullUser> user = [SZUserUtils currentUser];
        [SZUserUtils showUserProfileWithDisplay:self user:user];
    }]];

    [userRows addObject:[self rowWithText:@"Show User Settings" executionBlock:^{
        [SZUserUtils showUserSettingsWithDisplay:self];
    }]];
    
    // Share Utilities
    NSMutableArray *shareRows = [NSMutableArray array];
    
    [shareRows addObject:[self rowWithText:@"Show Share Dialog" executionBlock:^{
        SZEntity *entity = [SZEntity entityWithKey:@"Something" name:@"Something"];
        [SZShareUtils showShareDialogWithViewController:self entity:entity success:nil failure:nil];
    }]];
         

    [shareRows addObject:[self rowWithText:@"Share Via Email" executionBlock:^{
        SZEntity *entity = [SZEntity entityWithKey:@"Something" name:@"Something"];
        [SZShareUtils shareViaEmailWithViewController:self entity:entity success:^(id<SZShare> share) {
            [UIAlertView showAlertWithTitle:@"Share successful" message:nil buttonTitle:@"OK" handler:nil];
        } failure:^(NSError *error) {
            NSString *reason = [NSString stringWithFormat:@"Share failed: %@", [error localizedDescription]];
            [UIAlertView showAlertWithTitle:reason message:nil buttonTitle:@"Ok" handler:nil];
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        }];
    }]];
    
    [shareRows addObject:[self rowWithText:@"Share Via SMS" executionBlock:^{
        SZEntity *entity = [SZEntity entityWithKey:@"Something" name:@"Something"];
        [SZShareUtils shareViaSMSWithViewController:self entity:entity success:^(id<SZShare> share) {
            [UIAlertView showAlertWithTitle:@"Share successful" message:nil buttonTitle:@"OK" handler:nil];
        } failure:^(NSError *error) {
            NSString *reason = [NSString stringWithFormat:@"Share failed: %@", [error localizedDescription]];
            [UIAlertView showAlertWithTitle:reason message:nil buttonTitle:@"Ok" handler:nil];
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        }];
    }]];

    NSMutableArray *commentRows = [NSMutableArray array];
    [commentRows addObject:[self rowWithText:@"Show Comments List" executionBlock:^{
        id<SZEntity> entity = [[SampleSdkAppAppDelegate sharedDelegate] globalEntity];
        [SZCommentUtils showCommentsListWithDisplay:self entity:entity completion:nil];
    }]];

    [commentRows addObject:[self rowWithText:@"Show Comment Composer" executionBlock:^{
        SZEntity *entity = [SZEntity entityWithKey:@"Something" name:@"Something"];
        [SZCommentUtils showCommentComposerWithDisplay:self entity:entity success:nil failure:nil];
//        SZComposeCommentViewController *compose = [[[SZComposeCommentViewController alloc] initWithEntity:entity] autorelease];
//        [self presentModalViewController:compose animated:YES];
    }]];

    NSMutableArray *likeRows = [NSMutableArray array];
    [likeRows addObject:[self rowWithText:@"Like an Entity" executionBlock:^{
        SZEntity *entity = [SZEntity entityWithKey:@"Something" name:@"Something"];
        [SZLikeUtils likeWithDisplay:self entity:entity success:nil failure:nil];
    }]];
    
    NSMutableArray *facebookRows = [NSMutableArray array];
    [facebookRows addObject:[self rowWithText:@"Link to Facebook" executionBlock:^{
        [SZFacebookUtils linkWithDisplay:self success:nil failure:nil];
    }]];

    NSMutableArray *twitterRows = [NSMutableArray array];
    [twitterRows addObject:[self rowWithText:@"Link to Twitter" executionBlock:^{
        [SZTwitterUtils linkWithDisplay:self success:nil failure:nil];
    }]];

    return [NSArray arrayWithObjects:
            [self sectionWithIdentifier:kUserSection
                                  title:@"User Utilities"
                                   rows:userRows],
            [self sectionWithIdentifier:kShareSection
                                  title:@"Share Utilities"
                                   rows:shareRows],
            [self sectionWithIdentifier:kCommentSection
                                  title:@"Comment Utilities"
                                   rows:commentRows],
            
            [self sectionWithIdentifier:kLikeSection
                                  title:@"Like Utilities"
                                   rows:likeRows],

            [self sectionWithIdentifier:kFacebookSection
                                  title:@"Facebook Utilities"
                                   rows:facebookRows],
            
            [self sectionWithIdentifier:kTwitterSection
                                  title:@"Twiter Utilities"
                                   rows:twitterRows],

            nil];
}

- (void)viewDidLoad {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"socialize_logo.png"]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.alpha = 0.25;
    self.tableView.backgroundView = imageView;
    self.tableView.accessibilityLabel = @"tableView";
}

- (NSArray*)sections {
    if (sections_ == nil) {
        sections_ = [[self createSections] retain];
    }
    
    return sections_;
}

- (NSDictionary*)sectionWithIdentifier:(NSString*)identifier title:(NSString*)title rows:(NSArray*)rows {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            identifier, kSectionIdentifier,
            title, kSectionTitle,
            rows, kSectionRows,
            nil];
}

- (NSDictionary*)rowWithText:(NSString*)text executionBlock:(void(^)())executionBlock {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            text, kRowText,
            [[executionBlock copy] autorelease], kRowExecutionBlock,
            nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.sections objectAtIndex:section] objectForKey:kSectionRows] count];
}

- (NSDictionary*)sectionDataForSection:(NSUInteger)section {
    return [self.sections objectAtIndex:section];
}

- (NSDictionary*)rowDataForIndexPath:(NSIndexPath*)indexPath {
    NSDictionary *section = [self sectionDataForSection:indexPath.section];
    NSDictionary *data = [[section objectForKey:kSectionRows] objectAtIndex:indexPath.row];
    
    return data;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
    cell.textLabel.text = [rowData objectForKey:kRowText];
//    cell.textLabel.textColor = [UIColor whiteColor];

    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionData = [self sectionDataForSection:section];
    return [sectionData objectForKey:kSectionTitle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
    void (^executionBlock)() = [rowData objectForKey:kRowExecutionBlock];
    executionBlock();
}

@end
