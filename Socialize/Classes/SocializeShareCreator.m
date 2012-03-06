//
//  SocializeShareCreator.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 2/21/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "SocializeShareCreator.h"
#import "_Socialize.h"
#import "SocializeShare.h"
#import "SocializeComposeMessageViewController.h"
#import "SocializeUIDisplayProxy.h"
#import "UINavigationController+Socialize.h"
#import "MFMessageComposeViewController+BlocksKit.h"
#import "MFMailComposeViewController+BlocksKit.h"
#import "UIActionSheet+BlocksKit.h"
#import "UIAlertView+BlocksKit.h"
#import "SocializeShareOptions.h"
#import "SocializeTwitterAuthenticator.h"
#import "SocializeFacebookAuthenticator.h"
#import "NSError+Socialize.h"
#import "SocializeFacebookWallPoster.h"
#import "SocializePreprocessorUtilities.h"

@interface SocializeShareCreator ()
- (void)showSMSComposer;
- (void)tryToFinishCreatingShare;
- (NSString*)entityNameOrKey;
@property (nonatomic, assign) BOOL finishedServerCreate;
@property (nonatomic, assign) BOOL selectedShareMedium;
@property (nonatomic, assign) BOOL postedToFacebookWall;
@end

@implementation SocializeShareCreator
@synthesize finishedServerCreate = finishedServerCreate_;
@synthesize selectedShareMedium = selectedShareMedium_;
@synthesize postedToFacebookWall = postedToFacebookWall_;
SYNTH_CLASS_GETTER(MFMessageComposeViewController, messageComposerClass)
SYNTH_CLASS_GETTER(MFMailComposeViewController, mailComposerClass)

@synthesize shareObject = shareObject;
@synthesize options = options_;
@synthesize application = application_;

- (void)dealloc {
    self.shareObject = nil;
    self.options = nil;
    self.application = nil;
    
    [super dealloc];
}

+ (void)createShareWithOptions:(SocializeShareOptions*)options
                       display:(id)display
                       success:(void(^)())success
                       failure:(void(^)(NSError *error))failure {
    
    SocializeShareCreator *share = [[[self alloc] initWithDisplayObject:nil display:display options:options success:success failure:failure] autorelease];
    [SocializeAction executeAction:share];
}

+ (void)createShareWithOptions:(SocializeShareOptions*)options
                  displayProxy:(SocializeUIDisplayProxy*)proxy
                       success:(void(^)())success
                       failure:(void(^)(NSError *error))failure {
    SocializeShareCreator *share = [[[self alloc] initWithDisplayObject:proxy.object display:proxy.display options:options success:success failure:failure] autorelease];
    [SocializeAction executeAction:share];
}

- (id)initWithDisplayObject:(id)displayObject
                    display:(id)display
                    options:(SocializeShareOptions*)options
                    success:(void(^)())success
                    failure:(void(^)(NSError *error))failure {
    
    if (self = [super initWithDisplayObject:displayObject display:display success:success failure:failure]) {
        self.shareObject = [[[SocializeShare alloc] init] autorelease];
        self.shareObject.entity = options.entity;
        self.options = options;
    }
    
    return self;
}

- (UIApplication*)application {
    if (application_ == nil) {
        application_ = [[UIApplication sharedApplication] retain];
    }
    return application_;
}

- (void)createShareOnSocializeServer {
    if (self.shareObject.medium == SocializeShareMediumTwitter) {
        [self.shareObject setTwitterText:[self.shareObject text]];
    }
    
    [self.socialize createShare:self.shareObject];
}

- (void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object {
    NSAssert([object conformsToProtocol:@protocol(SocializeShare)], @"bad object");
    self.shareObject = (id<SocializeShare>)object;
    self.finishedServerCreate = YES;
    [self tryToFinishCreatingShare];
}

- (void)service:(SocializeService *)service didFail:(NSError *)error {
    [self failWithError:error];
}

- (NSError*)defaultError {
    return [NSError defaultSocializeErrorForCode:SocializeErrorShareCreationFailed];
}

- (void)showMessageComposition {
    SocializeComposeMessageViewController *composition = [[[SocializeComposeMessageViewController alloc] initWithEntityUrlString:self.shareObject.entity.key] autorelease];
    composition.delegate = self;
    if (self.shareObject.medium == SocializeShareMediumTwitter) {
        composition.title = @"Twitter Share";
    } else if (self.shareObject.medium == SocializeShareMediumFacebook) {
        composition.title = @"Facebook Share";
    }
    UINavigationController *nav = [UINavigationController socializeNavigationControllerWithRootViewController:composition];
    [self.displayProxy presentModalViewController:nav];
}

- (BOOL)canSendText {
    return [self.messageComposerClass canSendText];
}

- (NSString*)defaultSMSMessage {
    id<SocializeEntity> e = self.shareObject.entity;
    NSString *description = [e.name length] > 0 ? e.name : e.key;
    
    return [NSString stringWithFormat: @"I thought you would find this interesting: %@", description];    
}

- (void)showSMSComposer {
    if (![self canSendText]) {
        [self failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorSMSNotAvailable]];
    }
    
    MFMessageComposeViewController *composer = [[[self.messageComposerClass alloc] init] autorelease];
    [composer setBody:[self defaultSMSMessage]];
    
    __block __typeof__(self) weakSelf = self;
    __block __typeof__(composer) weakComposer = composer;
    composer.completionBlock = ^(MessageComposeResult result) {
        [weakSelf.displayProxy dismissModalViewController:weakComposer];

        switch (result) {
            case MessageComposeResultFailed:
                [weakSelf failWithError:nil];
                break;
            case MessageComposeResultCancelled:
                [weakSelf failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]];
                break;
            case MessageComposeResultSent:
                weakSelf.shareObject.text = @"n/a";
                [weakSelf tryToFinishCreatingShare];
                break;
        }
    };
    
    [self.displayProxy presentModalViewController:composer];
}

- (void)showUnconfiguredEmailAlert {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Mail is not Configured" message:@"Please configure at least one mail account before sharing via email."] autorelease];
    
    __block __typeof__(self) weakSelf = self;
    [alert addButtonWithTitle:@"Add Account" handler:^{
        [weakSelf.application openURL:[NSURL URLWithString:@"prefs:root=ACCOUNT_SETTINGS"]];
        [weakSelf failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorEmailNotAvailable]];
    }];
    [alert setCancelButtonWithTitle:@"Cancel" handler:^{
        [weakSelf failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorEmailNotAvailable]];
    }];
    [weakSelf.displayProxy showAlertView:alert];
}

- (BOOL)canSendMail {
    return [self.mailComposerClass canSendMail];
}

- (NSString*)defaultEmailMessageBody {
    return [NSString stringWithFormat: @"I thought you would find this interesting: %@", [self entityNameOrKey]];
}

- (NSString*)defaultEmailSubject {
    return [self entityNameOrKey];
}

- (void)showEmailComposition {
    MFMailComposeViewController *composer = [[[self.mailComposerClass alloc] init] autorelease];
    
    __block __typeof__(self) weakSelf = self;
    __block __typeof__(composer) weakComposer = composer;
    composer.completionBlock = ^(MFMailComposeResult result, NSError *error)
    {
        [weakSelf.displayProxy dismissModalViewController:weakComposer];
        // Notifies users about errors associated with the interface
        switch (result)
        {
            case MFMailComposeResultCancelled:
            case MFMailComposeResultSaved:
                [weakSelf failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]];
                break;
            case MFMailComposeResultFailed:
                [weakSelf failWithError:nil];
                break;
            case MFMailComposeResultSent:
                weakSelf.shareObject.text = @"n/a";
                [weakSelf tryToFinishCreatingShare];
                break;
        }
    };
    [composer setSubject:[self entityNameOrKey]];
    [composer setMessageBody:[self defaultEmailMessageBody] isHTML:NO];
    
    [self.displayProxy presentModalViewController:composer];
}

-(void)tryToShowEmailComposition
{
    if ([self canSendMail]) {
        // Show an MFMailComposeViewController
        [self showEmailComposition];
    } else {
        // Direct user to settings
        [self showUnconfiguredEmailAlert];
    }
}

- (void)selectShareMedium:(SocializeShareMedium)shareMedium {
    self.selectedShareMedium = YES;
    self.shareObject.medium = shareMedium;
    [self tryToFinishCreatingShare];
}

- (void)showShareActionSheet {
    UIActionSheet *actionSheet = [UIActionSheet sheetWithTitle:nil];

    __block __typeof__(self) weakSelf = self;
    
    if([self.socialize twitterAvailable]) {
        [actionSheet addButtonWithTitle:@"Share via Twitter" handler:^{
            [weakSelf selectShareMedium:SocializeShareMediumTwitter];
        }];
    }

    if([self.socialize facebookAvailable]) {
        [actionSheet addButtonWithTitle:@"Share via Facebook" handler:^{
            [weakSelf selectShareMedium:SocializeShareMediumFacebook];
        }];
    }

    [actionSheet addButtonWithTitle:@"Share via Email" handler:^{
        [weakSelf selectShareMedium:SocializeShareMediumEmail];
    }];

    if ([self canSendText]) {
        [actionSheet addButtonWithTitle:@"Share via SMS" handler:^{
            [weakSelf selectShareMedium:SocializeShareMediumSMS];
        }];
    }
    
    [actionSheet setCancelButtonWithTitle:nil handler:^{
        [weakSelf failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]];
    }];
    
    [self.displayProxy showActionSheet:actionSheet];
}

- (NSString*)entityNameOrKey {
    NSString *title = self.shareObject.entity.name;
    if ([title length] == 0) {
        title = self.shareObject.entity.key;
    }
    
    return title;
}

- (void)showCompositionInterface {
    switch (self.shareObject.medium) {
        case SocializeShareMediumSMS:
            [self showSMSComposer];
            break;
        case SocializeShareMediumFacebook:
        case SocializeShareMediumTwitter:
            [self showMessageComposition];
            break;
        case SocializeShareMediumEmail:
            [self tryToShowEmailComposition];
            break;
            
        default:
            NSAssert(NO, @"Unsupported medium %@", [self.shareObject medium]);
            break;
    }

}

- (void)authenticateViaTwitter {
    [self.twitterAuthenticatorClass authenticateViaTwitterWithOptions:self.options.twitterAuthOptions
                                                        displayProxy:self.displayProxy
                                                             success:^{
                                                                 [self tryToFinishCreatingShare];
                                                             } failure:^(NSError *error) {
                                                                 if ([error isSocializeErrorWithCode:SocializeErrorTwitterCancelledByUser]) {
                                                                     [self failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]];
                                                                 } else {
                                                                     [self failWithError:error];
                                                                 }
                                                             }];
}

- (void)authenticateViaFacebook {
    [self.facebookAuthenticatorClass authenticateViaFacebookWithOptions:self.options.facebookAuthOptions
                                                          displayProxy:self.displayProxy
                                                               success:^{
                                                                   [self tryToFinishCreatingShare];
                                                               } failure:^(NSError* error) {
                                                                   if ([error isSocializeErrorWithCode:SocializeErrorFacebookCancelledByUser]) {
                                                                       [self failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]];
                                                                   } else {
                                                                       [self failWithError:error];
                                                                   }
                                                                   
                                                               }];
}

- (void)postToFacebookWall {
    SocializeFacebookWallPostOptions *options = [[[SocializeFacebookWallPostOptions alloc] init] autorelease];
    options.link = [Socialize applicationURL];
    options.caption = NSLocalizedString(@"Download the app now to join the conversation.", @"");
    options.name = [self entityNameOrKey];
    NSString *objectURL = [Socialize objectURL:self.shareObject.entity];
    
    NSMutableString* message = [NSMutableString stringWithFormat:@"%@:\n%@", self.shareObject.text, objectURL];
    [message appendFormat:@"\n\n Shared from %@ using Socialize for iOS. \n http://www.getsocialize.com/", self.shareObject.application.name];
    
    options.message = message;
    [self.facebookWallPosterClass postToFacebookWallWithOptions:options
                                                  displayProxy:self.displayProxy
                                                       success:^{
                                                           self.postedToFacebookWall = YES;
                                                           [self tryToFinishCreatingShare];
                                                       } failure:^(NSError *error) {
                                                           [self failWithError:error];
                                                       }];
}

- (void)tryToFinishCreatingShare {
    if (!self.selectedShareMedium) {
        [self showShareActionSheet];
        return;
    }
    
    // Twitter auth required, but we don't yet have it
    if (self.shareObject.medium == SocializeShareMediumTwitter && ![self.socialize isAuthenticatedWithTwitter]) {
        [self authenticateViaTwitter];
        return;
    }
    
    // Facebook auth required, but we don't yet have it
    if (self.shareObject.medium == SocializeShareMediumFacebook && ![self.socialize isAuthenticatedWithFacebook]) {
        [self authenticateViaFacebook];
        return;
    }

    // Get text
    if ([self.shareObject.text length] <= 0) {
        [self showCompositionInterface];
        return;
    }
    
    // Create on server
    if (!self.finishedServerCreate) {
        [self.displayProxy startLoading];
        
        [self createShareOnSocializeServer];
        return;
    }

    // Write to facebook wall
    if (self.shareObject.medium == SocializeShareMediumFacebook && !self.postedToFacebookWall) {
        [self postToFacebookWall];
        return;
    }

    [self succeed];
}

- (void)executeAction {
    [self tryToFinishCreatingShare];
}

- (void)baseViewControllerDidCancel:(SocializeBaseViewController *)baseViewController {
    [self.displayProxy dismissModalViewController:baseViewController];
    [self failWithError:[NSError defaultSocializeErrorForCode:SocializeErrorShareCancelledByUser]];
}

- (void)baseViewControllerDidFinish:(SocializeComposeMessageViewController *)composition {
    [self.displayProxy dismissModalViewController:composition];
    [self.shareObject setText:composition.commentTextView.text];
    [self tryToFinishCreatingShare];
}

@end