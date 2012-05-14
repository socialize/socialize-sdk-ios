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

static NSString *CellIdentifier = @"CellIdentifier";

static NSString *kSectionIdentifier = @"kSectionIdentifier";
static NSString *kSectionTitle = @"kSectionTitle";
static NSString *kSectionRows = @"kSectionRows";

static NSString *kRowExecutionBlock = @"kRowExecutionBlock";
static NSString *kRowText = @"kRowText";
static NSString *kRowImage = @"kRowImage";
static NSString *kRowThirdParty = @"kRowThirdParty";

static NSString *kSocialNetworkSection = @"kSocialNetworkSection";
static NSString *kOtherSection = @"kOtherSection";

@interface SZShareDialogViewController ()
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *socialNetworkSection;
@end

@implementation SZShareDialogViewController
@synthesize continueButton = continueButton_;
@synthesize sections = sections_;
@synthesize socialNetworkSection = socializeNetworkSection_;

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.continueButton = nil;
    self.sections = nil;
    self.socialNetworkSection = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:25/255.0f green:31/255.0f blue:37/255.0f alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
//    self.continueButton.titleLabel.layer.shadowOpacity = 1.0;
//    self.continueButton.titleLabel.layer.shadowOffset = CGSizeMake(0, -1);
//    self.continueButton.titleLabel.layer.shadowRadius = 1.0;
//    self.continueButton.titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
}

#define COPIED_BLOCK(identifier) [[identifier copy] autorelease]

- (NSDictionary*)facebookRow {
    void (^executionBlock)() = ^{
        
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Facebook", kRowText,
            [UIImage imageNamed:@"socialize-authorize-facebook-enabled-icon.png"], kRowImage,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            [SocializeThirdPartyFacebook class], kRowThirdParty,
            nil];
}

- (NSDictionary*)twitterRow {
    void (^executionBlock)() = ^{
        
    };

    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Twitter", kRowText,
            [UIImage imageNamed:@"socialize-authorize-twitter-enabled-icon.png"], kRowImage,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            [SocializeThirdPartyTwitter class], kRowThirdParty,
            nil];
}

- (NSDictionary*)socialNetworkSection {
    NSArray *rows = [NSArray arrayWithObjects:[self facebookRow], [self twitterRow], nil];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kSocialNetworkSection, kSectionIdentifier,
            rows, kSectionRows,
            nil];
}

- (NSDictionary*)SMSRow {
    void (^executionBlock)() = ^{
        
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"SMS", kRowText,
            [UIImage imageNamed:@"socialize-selectnetwork-SMS-icon"], kRowImage,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            nil];
}

- (NSDictionary*)emailRow {
    void (^executionBlock)() = ^{
        
    };
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Email", kRowText,
            [UIImage imageNamed:@"socialize-selectnetwork-email-icon"], kRowImage,
            COPIED_BLOCK(executionBlock), kRowExecutionBlock,
            nil];
}

- (NSDictionary*)otherSection {
    NSArray *rows = [NSArray arrayWithObjects:[self emailRow], [self SMSRow], nil];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            kOtherSection, kSectionIdentifier,
            rows, kSectionRows,
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

- (NSDictionary*)rowForIndexPath:(NSIndexPath*)indexPath {
    NSArray *rows = [self rowsForSectionNumber:indexPath.section];
    return [rows objectAtIndex:indexPath.row];
}

- (NSDictionary*)sectionForSectionNumber:(NSInteger)sectionNumber {
    return [self.sections objectAtIndex:sectionNumber];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [self rowsForSectionNumber:section];
    return [rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionData = [self sectionForSectionNumber:indexPath.section];
    NSDictionary *rowData = [self rowForIndexPath:indexPath];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    if ([[sectionData objectForKey:kSectionIdentifier] isEqualToString:kSocialNetworkSection]) {
        if (![cell.accessoryView isKindOfClass:[UISwitch class]]) {
            cell.accessoryView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];            
        }
    } else {
        cell.accessoryView = nil;
    }

    cell.backgroundColor = [UIColor colorWithRed:41/255.0f green:48/255.0f blue:54/255.0f alpha:1.0];
    cell.imageView.image = [rowData objectForKey:kRowImage];
    cell.textLabel.text = [rowData objectForKey:kRowText];
    cell.textLabel.textColor = [UIColor whiteColor];

	return cell;
}

@end
