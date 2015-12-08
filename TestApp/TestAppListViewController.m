//
//  SampleListViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 5/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestAppListViewController.h"
#import <Socialize/Socialize.h>
#import "ActionBarExampleViewController.h"
#import "ButtonExampleViewController.h"
//#import <BlocksKit/BlocksKit.h>
//#import <BlocksKit/BlocksKit+UIKit.h>

static NSString *CellIdentifier = @"CellIdentifier";

static NSString *kSectionIdentifier = @"kSectionIdentifier";
static NSString *kSectionTitle = @"kSectionTitle";
static NSString *kSectionRows = @"kSectionRows";

static NSString *kRowExecutionBlock = @"kRowExecutionBlock";
static NSString *kRowText = @"kRowText";
static NSString *kRowIdentifier = @"kRowIdentifier";

// Sections
NSString *kConfigSection = @"kConfigSection";
NSString *kUserSection = @"kUserSection";
NSString *kShareSection = @"kShareSection";
NSString *kCommentSection = @"kCommentSection";
NSString *kLikeSection = @"kLikeSection";
NSString *kFacebookSection = @"kFacebookSection";
NSString *kTwitterSection = @"kTwitterSection";
NSString *kSmartAlertsSection = @"kSmartAlertsSection";
NSString *kActionBarSection = @"kActionBarSection";
NSString *kButtonsExampleSection = @"kButtonsExampleSection";

// Rows
NSString *kShowLinkDialogRow = @"kShowLinkDialogRow";
NSString *kShowUserProfileRow = @"kShowUserProfileRow";
NSString *kShowCommentComposerRow = @"kShowCommentComposerRow";
NSString *kShowCommentsListRow = @"kShowCommentsListRow";
NSString *kLinkToFacebookRow = @"kLinkToFacebookRow";
NSString *kLinkToTwitterRow = @"kLinkToTwitterRow";
NSString *kPostToTwitterRow = @"kPostToTwitterRow";
NSString *kShareImageToTwitterRow = @"kShareImageToTwitterRow";
NSString *kLikeEntityRow = @"kLikeEntityRow";
NSString *kShowShareRow = @"kShowShareRow";
NSString *kHandleDirectURLSmartAlertRow = @"kHandleDirectURLSmartAlertRow";
NSString *kHandleDirectEntitySmartAlertRow = @"kHandleDirectEntitySmartAlertRow";
NSString *kShowActionBarExampleRow = @"kShowActionBarExampleRow";
NSString *kShowButtonsExampleRow = @"kShowButtonsExampleRow";

static TestAppListViewController *sharedSampleListViewController;

@interface TestAppListViewController ()
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UIViewController *twitterImageController;
@end

@implementation TestAppListViewController

@synthesize sections = sections_;
@synthesize entity = entity_;
@synthesize twitterImageController = twitterImageController_;

+ (TestAppListViewController*)sharedSampleListViewController {
    if (sharedSampleListViewController == nil) {
        sharedSampleListViewController = [[TestAppListViewController alloc] init];
    }
    
    return sharedSampleListViewController;
}

- (id<SZEntity>)entity {
    if (entity_ == nil) {
        
        // until tests are arc-enabled
#if __has_feature(objc_arc)
        entity_ = [SZEntity entityWithKey:@"http://www.sharethis.com" name:@"ShareThis"];
#else
        entity_ = [[SZEntity entityWithKey:@"http://www.sharethis.com" name:@"ShareThis"] retain];
#endif
        
    }
    
    return entity_;
}

- (NSArray*)createSections {
    
    // General
    NSMutableArray *configRows = [NSMutableArray array];
    
    [configRows addObject:[self rowWithText:@"Wipe Auth Data" executionBlock:^{
        [[Socialize sharedSocialize] removeAuthenticationInfo];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }]];

    // User Utilities
    NSMutableArray *userRows = [NSMutableArray array];
    
    [userRows addObject:[self rowWithIdentifier:kShowLinkDialogRow text:@"Show Link Dialog" executionBlock:^{
        [SZUserUtils showLinkDialogWithViewController:self completion:nil cancellation:nil];
    }]];

    [userRows addObject:[self rowWithIdentifier:kShowUserProfileRow text:@"Show User Profile" executionBlock:^{
        id<SocializeFullUser> user = [SZUserUtils currentUser];
        [SZUserUtils showUserProfileInViewController:self user:user completion:nil];
    }]];

    [userRows addObject:[self rowWithText:@"Show User Settings" executionBlock:^{
        [SZUserUtils showUserSettingsInViewController:self completion:nil];
    }]];
    
    // Share Utilities
    NSMutableArray *shareRows = [NSMutableArray array];
    
    [shareRows addObject:[self rowWithIdentifier:kShowShareRow text:@"Show Share Dialog" executionBlock:^{
        SZShareOptions *options = [[SZShareOptions alloc] init];
        options.willShowSMSComposerBlock = ^(SZSMSShareData *smsData) {
            NSLog(@"Sharing SMS");
        };
        
        options.willShowEmailComposerBlock = ^(SZEmailShareData *emailData) {
            NSLog(@"Sharing Email");            
        };
        
        options.willRedirectToPinterestBlock = ^(SZPinterestShareData *pinData) {
            NSLog(@"Sharing pin");
        };
        
        options.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
            NSLog(@"Posting to %d", network);
        };
        
        options.didSucceedPostingToSocialNetworkBlock = ^(SZSocialNetwork network, id result) {
            NSLog(@"Posted %@ to %d", result, network);
        };
        
        options.didFailPostingToSocialNetworkBlock = ^(SZSocialNetwork network, NSError *error) {
            NSLog(@"Failed posting to %d", network);
            
            if (network == SZSocialNetworkFacebook) {
                NSLog(@"%@", [SZFacebookUtils userMessageForError:error]);
                NSLog(@"%@", [SZFacebookUtils userTitleForError:error]);
            }
        };

        [SZShareUtils showShareDialogWithViewController:self options:options entity:self.entity completion:nil cancellation:nil];

    }]];
         

    [shareRows addObject:[self rowWithText:@"Share Via Email" executionBlock:^{
        
        SZShareOptions *options = [[SZShareOptions alloc] init];
        options.willShowEmailComposerBlock = ^(SZEmailShareData *emailData) {
            emailData.subject = @"What's up?";
            
            NSString *appURL = [emailData.propagationInfo objectForKey:@"application_url"];
            NSString *entityURL = [emailData.propagationInfo objectForKey:@"entity_url"];
            id<SZEntity> entity = emailData.share.entity;
            NSString *appName = emailData.share.application.name;

            emailData.messageBody = [NSString stringWithFormat:@"Hark! (%@/%@, shared from the excellent %@ (%@))", entity.name, entityURL, appName, appURL];
        };
        
        [SZShareUtils shareViaEmailWithViewController:self options:options entity:self.entity success:^(id<SZShare> share) {
//            [UIAlertView showAlertWithTitle:@"Share successful" message:nil buttonTitle:@"OK" handler:nil];
        } failure:^(NSError *error) {
            NSString *reason = [NSString stringWithFormat:@"Share failed: %@", [error localizedDescription]];
//            [UIAlertView bk_showAlertViewWithTitle:reason message:nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        }];
    }]];
    
    [shareRows addObject:[self rowWithText:@"Share Via SMS" executionBlock:^{
        SZShareOptions *options = [[SZShareOptions alloc] init];
        options.willShowSMSComposerBlock = ^(SZSMSShareData *smsData) {
            NSString *appURL = [smsData.propagationInfo objectForKey:@"application_url"];
            NSString *entityURL = [smsData.propagationInfo objectForKey:@"entity_url"];
            id<SZEntity> entity = smsData.share.entity;
            NSString *appName = smsData.share.application.name;
            
            smsData.body = [NSString stringWithFormat:@"Hark! (%@/%@, shared from the excellent %@ (%@))", entity.name, entityURL, appName, appURL];
        };

        [SZShareUtils shareViaSMSWithViewController:self options:options entity:self.entity success:^(id<SZShare> share) {
//            [UIAlertView bk_showAlertViewWithTitle:@"Share successful" message:nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
        } failure:^(NSError *error) {
            NSString *reason = [NSString stringWithFormat:@"Share failed: %@", [error localizedDescription]];
//            [UIAlertView bk_showAlertViewWithTitle:reason message:nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        }];
    }]];

    NSMutableArray *commentRows = [NSMutableArray array];
    [commentRows addObject:[self rowWithIdentifier:kShowCommentsListRow text:@"Show Comments List" executionBlock:^{
        SZCommentOptions* options = [SZCommentUtils userCommentOptions];
        options.text = @"Hello world";
    
        SZCommentsListViewController *comments = [[SZCommentsListViewController alloc] initWithEntity:self.entity];
        comments.completionBlock = ^{
            
            // Dismiss however you want here
            [self dismissViewControllerAnimated:NO completion:nil];
        };
        comments.commentOptions = options;
        
        // Present however you want here
        [self presentViewController:comments animated:NO completion:nil];
        
        
        
    }]];

    [commentRows addObject:[self rowWithIdentifier:kShowCommentComposerRow text:@"Show Comment Composer" executionBlock:^{
        [SZCommentUtils showCommentComposerWithViewController:self entity:self.entity completion:nil cancellation:nil];
    }]];

    NSMutableArray *likeRows = [NSMutableArray array];
    [likeRows addObject:[self rowWithIdentifier:kLikeEntityRow text:@"Like an Entity" executionBlock:^{
        SZLikeOptions *options = [SZLikeUtils userLikeOptions];
//        options.willAttemptPostToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
//            postData.path = @"me/feed";
//            [postData.params setObject:@"blah" forKey:@"description"];
//        };
//        
        [SZLikeUtils likeWithViewController:self options:options entity:self.entity success:nil failure:nil];
    }]];
    
    NSMutableArray *facebookRows = [NSMutableArray array];
    [facebookRows addObject:[self rowWithIdentifier:kLinkToFacebookRow text:@"Link to Facebook" executionBlock:^{
        [SZFacebookUtils linkWithOptions:nil success:^(id<SZFullUser> user) {
//            [UIAlertView bk_showAlertViewWithTitle:@"Facebook link successful" message:nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
        } foreground:^{
//            [UIAlertView bk_showAlertViewWithTitle:@"Facebook link foregrounded without success or failure" message:nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
            [SZFacebookUtils cancelLink];
        } failure:^(NSError *error) {
            if ([error isSocializeErrorWithCode:SocializeErrorFacebookCancelledByUser]) {
//                [UIAlertView bk_showAlertViewWithTitle:@"Facebook link cancelled by user" message:nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
            } else {
                NSString *message = [NSString stringWithFormat:@"Facebook link failed: %@", [error localizedDescription]];
//                [UIAlertView bk_showAlertViewWithTitle:message message:nil cancelButtonTitle:@"OK" otherButtonTitles:nil handler:nil];
            }
        }];
    }]];

    NSMutableArray *twitterRows = [NSMutableArray array];
    [twitterRows addObject:[self rowWithIdentifier:kLinkToTwitterRow
                                              text:@"Link to Twitter"
                                    executionBlock:^{
        [SZTwitterUtils linkWithViewController:self success:nil failure:nil];
    }]];
    
    [twitterRows addObject:[self rowWithIdentifier:kPostToTwitterRow
                                              text:@"Post to Twitter"
                                    executionBlock:^{
        NSDate *now = [NSDate date];
        NSTimeInterval epoch = [now timeIntervalSince1970];
        NSString *postText = [NSString stringWithFormat:@"Twitter test post: %f", epoch];
        NSDictionary *paramss = @{@"status": postText};
        [SZTwitterUtils postWithViewController:self
                                          path:@"1.1/statuses/update.json"
                                        params:paramss
                                     multipart:YES
                                       success:^(id result) {
                                           [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                                           UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                                           CGRect frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
                                           SZStatusView *status = [SZStatusView successStatusViewWithFrame:frame];
                                           [status showAndHideInKeyWindow];
                                           NSLog(@"Twitter Update Posted");
                                       }
                                       failure:^(NSError *error) {
                                           NSString *failureMessage = [NSString stringWithFormat:@"Twitter Post Failed %@", [error localizedDescription]];
//                                           [UIAlertView bk_showAlertViewWithTitle:@"Failure"
//                                                                          message:failureMessage
//                                                                cancelButtonTitle:@"OK"
//                                                                otherButtonTitles:nil
//                                                                          handler:nil];
                                           NSLog(@"Twitter Update Failed %@", [error localizedDescription]);
                                       }];
    }]];
     
    [twitterRows addObject:[self rowWithIdentifier:kShareImageToTwitterRow
                                              text:@"Post Image to Twitter"
                                    executionBlock:^{
        //use a known image in this bundle
        __block UIImage *image = [UIImage imageNamed:@"Smiley.png"];
        NSData *imageData = UIImagePNGRepresentation(image);
        NSDate *now = [NSDate date];
        NSTimeInterval epoch = [now timeIntervalSince1970];
        NSString *postText = [NSString stringWithFormat:@"Twitter test post: %f", epoch];
        
        NSDictionary *paramss = @{
                                  @"status": postText,
                                  @"media[]": imageData
                                  };
        [SZTwitterUtils postWithViewController:self
                                          path:@"1.1/statuses/update_with_media.json"
                                        params:paramss
                                     multipart:YES
                                       success:^(id result) {
                                           [self twitterImageShareSuccess:image];
                                           NSLog(@"Image Posted");
                                       }
                                       failure:^(NSError *error) {
                                           NSString *failureMessage = [NSString stringWithFormat:@"Image Post Failed %@", [error localizedDescription]];
//                                           [UIAlertView bk_showAlertViewWithTitle:@"Failure"
//                                                                          message:failureMessage
//                                                                cancelButtonTitle:@"OK"
//                                                                otherButtonTitles:nil
//                                                                          handler:nil];
                                           NSLog(@"Image Post Failed %@", [error localizedDescription]);
                                       }];
    }]];

    NSMutableArray *smartAlertsRows = [NSMutableArray array];
    [smartAlertsRows addObject:[self rowWithIdentifier:kHandleDirectURLSmartAlertRow text:@"Direct URL SmartAlert" executionBlock:^{
        NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"www.getsocialize.com", @"url",
                                       @"developer_direct_url", @"notification_type",
                                       nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
        
        [SZSmartAlertUtils openNotification:userInfo];
    }]];

    [smartAlertsRows addObject:[self rowWithIdentifier:kHandleDirectURLSmartAlertRow text:@"Comment SmartAlert" executionBlock:^{
        [SZCommentUtils getCommentsByApplicationWithFirst:nil last:[NSNumber numberWithInteger:1] success:^(NSArray *comments) {
            if ([comments count] > 0) {
                id<SZComment> comment = [comments objectAtIndex:0];
                NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @"new_comments", @"notification_type",
                                               @"comment", @"activity_type",
                                               [NSNumber numberWithInteger:[comment objectID]], @"activity_id",
                                               nil];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
                
                [SZSmartAlertUtils openNotification:userInfo];
            }
        } failure:nil];
    }]];

    [smartAlertsRows addObject:[self rowWithIdentifier:kHandleDirectEntitySmartAlertRow text:@"Entity SmartAlert" executionBlock:^{
        [SZEntityUtils getEntitiesWithFirst:nil last:[NSNumber numberWithInteger:1] success:^(NSArray *entities) {
            if ([entities count] > 0) {
                id<SZEntity> entity = [entities objectAtIndex:0];
                NSDictionary *socializeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @"developer_direct_entity", @"notification_type",
                                               @([entity objectID]), @"entity_id",
                                               nil];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:socializeInfo forKey:@"socialize"];
                
                [SZSmartAlertUtils openNotification:userInfo];
            }
        } failure:nil];
    }]];

    NSMutableArray *actionBarRows = [NSMutableArray array];
    [actionBarRows addObject:[self rowWithIdentifier:kShowActionBarExampleRow text:@"Show Action Bar Example" executionBlock:^{
        ActionBarExampleViewController *actionBarExample = [[ActionBarExampleViewController alloc] initWithEntity:self.entity];
        SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:actionBarExample];
        [self presentViewController:nav animated:YES completion:nil];
    }]];

    NSMutableArray *buttonsRows = [NSMutableArray array];
    [buttonsRows addObject:[self rowWithIdentifier:kShowButtonsExampleRow text:@"Show Button Examples" executionBlock:^{
        ButtonExampleViewController *buttonsExample = [[ButtonExampleViewController alloc] initWithEntity:self.entity];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:buttonsExample];
        [self presentViewController:nav animated:YES completion:nil];
    }]];

    NSArray *sections = [NSArray arrayWithObjects:
            [self sectionWithIdentifier:kConfigSection
                                  title:@"Configuration"
                                   rows:configRows],
            
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
                                  title:@"Twitter Utilities"
                                   rows:twitterRows],

            [self sectionWithIdentifier:kSmartAlertsSection
                                  title:@"Smart Alerts Utilities"
                                   rows:smartAlertsRows],

            [self sectionWithIdentifier:kActionBarSection
                                  title:@"Action Bar Utilities"
                                   rows:actionBarRows],
                         
            [self sectionWithIdentifier:kButtonsExampleSection
                               title:@"Buttons Example"
                                rows:buttonsRows],
                         
            nil];
    
    return sections;
}

//twitter image sharing logic
- (void)twitterImageTapped:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && self.twitterImageController != nil) {
        [self.twitterImageController dismissViewControllerAnimated:YES completion:nil];
    }
}

//twitter image sharing logic
- (void)twitterImageShareSuccess:(UIImage *)image {
    //bring up a bogus view controller with the image that was shared
    self.twitterImageController = [[UIViewController alloc] init];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.accessibilityLabel = @"twitterImageView";
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twitterImageTapped:)];
    [imageView addGestureRecognizer:tapImageRecognizer];
    self.twitterImageController.view = imageView;
    [self presentViewController:self.twitterImageController animated:YES completion:nil];
}

- (void)viewDidLoad {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"socialize_logo.png"]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.alpha = 0.25;
    self.tableView.backgroundView = imageView;
    self.tableView.accessibilityLabel = @"tableView";

    self.sections = [self createSections];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 20, 320, 460);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSUInteger)indexForSectionIdentifier:(NSString*)identifier {
    for (int i = 0; i < [self.sections count]; i++) {
        NSDictionary *section = [self.sections objectAtIndex:i];
        if ([[section objectForKey:kSectionIdentifier] isEqualToString:identifier]) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (NSIndexPath*)indexPathForRowIdentifier:(NSString*)identifier {
    for (int s = 0; s < [self.sections count]; s++) {
        NSDictionary *section = [self.sections objectAtIndex:s];
        
        NSArray *rows = [section objectForKey:kSectionRows];
        for (int r = 0; r < [rows count]; r++) {
            NSDictionary *row = [rows objectAtIndex:r];
            
            if ([[row objectForKey:kRowIdentifier] isEqualToString:identifier]) {
                return [NSIndexPath indexPathForRow:r inSection:s];
            }
        }
    }

    return nil;
}

- (NSDictionary*)sectionWithIdentifier:(NSString*)identifier title:(NSString*)title rows:(NSArray*)rows {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            identifier, kSectionIdentifier,
            title, kSectionTitle,
            rows, kSectionRows,
            nil];
}

- (NSDictionary*)rowWithText:(NSString*)text executionBlock:(void(^)())executionBlock {
    return [self rowWithIdentifier:@"undefined" text:text executionBlock:executionBlock];
}


- (NSDictionary*)rowWithIdentifier:(NSString*)identifier text:(NSString*)text executionBlock:(void(^)())executionBlock {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            identifier, kRowIdentifier,
            text, kRowText,
            [executionBlock copy], kRowExecutionBlock,
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
}

@end
