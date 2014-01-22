//
//  AuthorizeViewController.m
//  appbuildr
//
//  Created by Fawad Haider  on 5/17/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import "_SZLinkDialogViewController.h"
#import "SocializeAuthenticateService.h"
#import "UIButton+Socialize.h"
#import "UINavigationBarBackground.h"
#import "SocializeAuthTableViewCell.h"
#import "SocializeUser.h"
#import "SocializeAuthInfoTableViewCell.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeThirdPartyTwitter.h"
#import "SZFacebookUtils.h"
#import "SZTwitterUtils.h"
#import "SDKHelpers.h"
#import "SZUserUtils.h"
#import "socialize_globals.h"
#import "SZEventUtils.h"
#import "SZLinkDialogView.h"
#import "_SZLinkDialogViewControllerIOS6.h"
#import "UIDevice+VersionCheck.h"

#define LINK_DIALOG_BUCKET @"LINK_DIALOG"

static NSString *const kAuthTypeRowText = @"kAuthTypeRowText";
static NSString *const kAuthTypeRowImageName = @"kAuthTypeRowImageName";
static NSString *const kAuthTypeRowAction = @"kAuthTypeRowAction";

@interface _SZLinkDialogViewController() {
    dispatch_once_t _initToken;
}
-(SocializeAuthTableViewCell *)getAuthorizeTableViewCell;
-(SocializeAuthInfoTableViewCell*)getAuthorizeInfoTableViewCell;
-(id)getCellFromNibNamed:(NSString * )nibNamed withClass:(Class)klass;
-(NSArray *) getTopLevelViewsFromNib:(NSString *)nibName;
@property (nonatomic, retain) id<_SZLinkDialogViewControllerDelegate> delegate;
@property (nonatomic, retain) id<SocializeUser> user;
@property (nonatomic, retain) NSMutableArray *authTypeRowData;
@property (nonatomic, assign) SZSocialNetwork selectedNetwork;
@end


CGFloat SocializeAuthTableViewRowHeight = 56;

@implementation _SZLinkDialogViewController

@synthesize tableView;
@synthesize topImage;
@synthesize skipButton = skipButton_;
@synthesize delegate = _delegate;
@synthesize user = _user;
@synthesize authTypeRowData = authTypeRowData_;
@synthesize completionBlock = completionBlock_;
@synthesize selectedNetwork = selectedNetwork_;

+ (id)alloc {
    if([self class] == [_SZLinkDialogViewController class] &&
       [[UIDevice currentDevice] systemMajorVersion] < 7) {
        return [_SZLinkDialogViewControllerIOS6 alloc];
    }
    else {
        return [super alloc];
    }
}

-(void) dealloc {
    self.tableView = nil;
    self.topImage = nil;
    self.delegate = nil;
    self.user = nil;
    self.authTypeRowData = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutoAuthOnAppear {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_once(&_initToken, ^{
        [self trackEventWithAction:@"show" values:nil];
    });
}

+ (UINavigationController*)authViewControllerInNavigationController:(id<_SZLinkDialogViewControllerDelegate>)delegate {
    _SZLinkDialogViewController *authController 
    = [[[_SZLinkDialogViewController alloc] initWithDelegate:delegate] autorelease];
                                                                                                              
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:authController] autorelease];
    UIImage *navBarImage = [UIImage imageNamed:@"socialize-navbar-bg.png"];
    [navController.navigationBar setBackgroundImage:navBarImage];
    return navController;
}

- (id)initWithDelegate:(id<_SZLinkDialogViewControllerDelegate>)delegate {
    if( self = [super initWithNibName:@"_SZLinkDialogViewController" bundle:nil] ) {
        self.delegate = delegate;
        self.title = @"Authenticate";
    }
    return self;
}

- (id)init {
    return [self initWithDelegate:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _SZLinkDialogViewControllerNumSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SocializeAuthTableViewRowHeight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.view isKindOfClass:[SZLinkDialogView class]]) {
        SZLinkDialogView *linkDialogView = (SZLinkDialogView *)self.view;
        linkDialogView.topImageView = self.topImage;
        linkDialogView.topImageView.accessibilityLabel = @"topImageView";
    }
    //self.navigationItem.rightBarButtonItem = [self createSkipButton];
    self.view.backgroundColor = [UIColor colorWithRed:50/255.0f green:58/255.0f blue:67/255.0f alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:25/255.0f green:31/255.0f blue:37/255.0f alpha:1.0];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    if (![Socialize anonymousAllowed]) {
        self.skipButton.hidden = YES;
    }
    
    // Remove default gray background (iPad / http://stackoverflow.com/questions/2688007/uitableview-backgroundcolor-always-gray-on-ipad)
    [self.tableView setBackgroundView:nil];    
    
    //iOS 7 adjustments for nav bar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(IBAction)skipButtonPressed:(id)sender {
    [self trackEventWithAction:@"skip" values:nil];
    
    if (self.completionBlock != nil) {
        self.completionBlock(SZSocialNetworkNone);
    } else {
        if( [self.delegate respondsToSelector:@selector(authorizationSkipped)] ) {
            [self.delegate authorizationSkipped];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelButtonPressed:(id)button {
    [super cancelButtonPressed:button];
    
    [self trackEventWithAction:@"skip" values:nil];
}

// Dismiss any SocializeAction controllers non-animated
- (void)socializeObject:(id)object requiresDismissOfViewController:(UIViewController *)controller {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSDictionary*)authTypeRowForText:(NSString*)text imageName:(NSString*)imageName {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            text, kAuthTypeRowText,
            nil];
}

- (void)authenticateWithFacebook {
    self.selectedNetwork = SZSocialNetworkFacebook;

    SZFacebookLinkOptions *options = [SZFacebookLinkOptions defaultOptions];
    options.willSendLinkRequestToSocializeBlock = ^{
        [self startLoading];
    };
    
    [SZFacebookUtils linkWithOptions:options
                             success:^(id<SZFullUser> fullUser) {
        [self stopLoading];
        [self authenticationComplete];
    }
                          foreground:nil failure:^(NSError *error) {
        [self stopLoading];
        if (![error isSocializeErrorWithCode:SocializeErrorFacebookCancelledByUser]) {
            [self failWithError:error];
        }
    }];
}

- (void)authenticationComplete {
    if ([SZUserUtils userIsLinked]) {
        [self finish];
        self.user = [self.socialize authenticatedUser];
    }
}

- (void)authenticateWithTwitter {
    self.selectedNetwork = SZSocialNetworkTwitter;
    
    [SZTwitterUtils linkWithViewController:self
                                   success:^(id<SZFullUser> user) {
        [self authenticationComplete];
    }
                                   failure:^(NSError *error) {
        if (![error isSocializeErrorWithCode:SocializeErrorTwitterCancelledByUser]) {
            [self failWithError:error];
        }
    }];
}

- (NSMutableArray*)authTypeRowData {
    if (authTypeRowData_ == nil) {
        authTypeRowData_ = [[NSMutableArray alloc] init];
        
        WEAK(self) weakSelf = self;
        
        if ([SocializeThirdPartyFacebook available]) {
            [authTypeRowData_ addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              
              @"Facebook", kAuthTypeRowText,
              [self facebookIcon:YES], kAuthTypeRowImageName,
              [[^{ [weakSelf authenticateWithFacebook]; } copy] autorelease], kAuthTypeRowAction,
              nil]];
        }
        
        if ([SocializeThirdPartyTwitter available]) {
            [authTypeRowData_ addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              
              @"Twitter", kAuthTypeRowText,
              [self twitterIcon:YES], kAuthTypeRowImageName,
              [[^{ [weakSelf authenticateWithTwitter]; } copy] autorelease], kAuthTypeRowAction,
              nil]];
        }

    }
    
    return authTypeRowData_;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // return 1;
    NSInteger noOfRows = 0;
	switch (section) {
		case _SZLinkDialogViewControllerSectionAuthTypes:
            noOfRows = [self.authTypeRowData count];
            break;
        case _SZLinkDialogViewControllerSectionAuthInfo:
            noOfRows = 1;
            break;
    }
    return noOfRows;
}

-(SocializeAuthInfoTableViewCell *)getAuthorizeInfoTableViewCell {
	static NSString *authorizeInfoTableViewCellId = @"authorize_info_cell";
	SocializeAuthInfoTableViewCell *cell =(SocializeAuthInfoTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:authorizeInfoTableViewCellId];
    
	if (cell == nil) {
        cell = [self getCellFromNibNamed:@"SocializeAuthInfoTableViewCell" withClass:[SocializeAuthInfoTableViewCell class]];
	}
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(id)getCellFromNibNamed:(NSString * )nibNamed withClass:(Class)klass {
    id cell = nil;
    NSArray *topLevelViews = [self getTopLevelViewsFromNib:nibNamed];
    for (id topLevelView in topLevelViews) {
        if ([topLevelView isKindOfClass:klass] ) {
            cell = topLevelView;
        }
    }
    return cell;
}

-(NSArray *) getTopLevelViewsFromNib:(NSString *)nibName {
    return [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
}

- (void)trackEventWithAction:(NSString*)action values:(NSDictionary*)values {
    NSMutableDictionary *fullValues = [NSMutableDictionary dictionaryWithObject:action forKey:@"action"];
    if (values != nil) {
        [fullValues addEntriesFromDictionary:values];  
    }
    
    [SZEventUtils trackEventWithBucket:LINK_DIALOG_BUCKET values:fullValues success:nil failure:nil];
}
    
- (void)finish {
    Class<SocializeThirdParty> thirdParty = [SocializeThirdParty thirdPartyForSocialNetworkFlag:self.selectedNetwork];
    if (thirdParty != nil) {
        NSString *networkName = [[thirdParty thirdPartyName] uppercaseString];
        NSDictionary *values = [NSDictionary dictionaryWithObject:networkName forKey:@"network"];
        [self trackEventWithAction:@"auth" values:values];
    }
    
    if (self.completionBlock != nil) {
        self.completionBlock(self.selectedNetwork);
    } else {
        // Dismiss self
        [self dismissViewControllerAnimated:YES completion:nil];

        SEL didAuthSelector = @selector(socializeAuthViewController:didAuthenticate:);
        if ([self.delegate respondsToSelector:didAuthSelector] ) {
            [self.delegate socializeAuthViewController:self didAuthenticate:self.user];
        }
    }
}

// This is only called when finishing the Facebook flow (not twitter)
-(void)didAuthenticate:(id<SocializeUser>)user {
    [self authenticationComplete];
}

-(SocializeAuthTableViewCell *)getAuthorizeTableViewCell {
	static NSString *profileCellIdentifier = @"authorize_cell";
	SocializeAuthTableViewCell *cell =(SocializeAuthTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
	if (cell == nil) 
	{
        cell = [self getCellFromNibNamed:@"SocializeAuthTableViewCell" withClass:[SocializeAuthTableViewCell class]];
	}
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
	if(indexPath.section == _SZLinkDialogViewControllerSectionAuthTypes){
        
        // execute the action
        NSDictionary *data = [self.authTypeRowData objectAtIndex:indexPath.row];
        void (^action)() = [data objectForKey:kAuthTypeRowAction];
        action();
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    SocializeAuthTableViewCell* authCell = nil;
    SocializeAuthInfoTableViewCell* infoCell = nil;
	
	switch (indexPath.section) {
		case _SZLinkDialogViewControllerSectionAuthTypes:
			authCell = [self getAuthorizeTableViewCell];
			authCell.backgroundColor = [UIColor colorWithRed:61/255.0f green:70/255.0f blue:76/255.0f alpha:1.0] ;

            NSDictionary *data = [self.authTypeRowData objectAtIndex:indexPath.row];
            authCell.cellIcon.image = [data objectForKey:kAuthTypeRowImageName];
            authCell.cellLabel.text = [data objectForKey:kAuthTypeRowText];
            authCell.cellAccessoryIcon.image = [self callOutArrow];
            
            cell = authCell;
            break;
			
		case _SZLinkDialogViewControllerSectionAuthInfo:
		default:
			infoCell = [self getAuthorizeInfoTableViewCell];
			infoCell.backgroundColor = [UIColor colorWithRed:41/255.0f green:48/255.0f blue:54/255.0f alpha:1.0];
            infoCell.cellIcon.image = [self authorizeUserIcon];
            infoCell.cellLabel.text = @"You are currently anonymous.";
            infoCell.cellSubLabel.text = @"Authenticate with a service above";
            cell = infoCell;
			break;
	}
    
	return cell;
}

- (UIImage *)facebookIcon:(BOOL)enabled {
    return enabled ?
           [UIImage imageNamed:@"socialize-authorize-facebook-enabled-icon-ios7.png"] :
           [UIImage imageNamed:@"socialize-authorize-facebook-disabled-icon-ios7.png"];
}

- (UIImage *)twitterIcon:(BOOL)enabled {
    return enabled ?
           [UIImage imageNamed:@"socialize-authorize-twitter-enabled-icon-ios7.png"] :
           [UIImage imageNamed:@"socialize-authorize-twitter-disabled-icon-ios7.png"];
}

- (UIImage *)callOutArrow {
    return [UIImage imageNamed:@"socialize-activity-call-out-arrow.png"];
}

- (UIImage *)authorizeUserIcon {
    return [UIImage imageNamed:@"socialize-authorize-user-icon-ios7.png"];
}


@end
