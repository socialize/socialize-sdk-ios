//
//  SocializeTestCase.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/20/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SZIntegrationTestCase.h"
#import "SocializePrivateDefinitions.h"

static NSString *UUIDString() {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

static NSString *SocializeAsyncTestCaseRunID = nil;

@implementation SZIntegrationTestCase
@synthesize socialize = socialize_;
@synthesize fetchedElements = fetchedElements_;
@synthesize createdObject = createdObject_;
@synthesize updatedObject = updatedObject_;
@synthesize deletedObject = deletedObject_;

- (void)dealloc {
    self.socialize = nil;
    self.fetchedElements = nil;
    self.createdObject = nil;
    self.updatedObject = nil;
    self.deletedObject = nil;
    
    [super dealloc];
}

+ (NSString*)runID {
    if (SocializeAsyncTestCaseRunID == nil) {
        NSString *uuid = UUIDString();
        NSString *sha1 = [uuid sha1];
        NSString *runID = [[sha1 substringToIndex:8] retain];
        
        SocializeAsyncTestCaseRunID = runID;
    }
    
    return SocializeAsyncTestCaseRunID;
}

+ (void)resetRunID {
    SocializeAsyncTestCaseRunID = nil;
}

+ (NSString*)testURL:(NSString*)suffix {
    return [NSString stringWithFormat:@"http://itest.%@/%@", [self runID], suffix];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setUpClass {
    [[self class] resetRunID];
}

- (void)authenticateAnonymously {
    [self prepare];
    [self.socialize authenticateAnonymously];
    [self waitForStatus:kGHUnitWaitStatusSuccess];    
}

- (void)authenticateAnonymouslyIfNeeded {
    if (![self.socialize isAuthenticated]) {
        [self authenticateAnonymously];
    }
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    
    return socialize_;
}

- (void)setUp {
    [self authenticateAnonymouslyIfNeeded];
}

- (void)tearDown {
}

- (NSString*)runID {
    return [[self class] runID];
}

- (NSString*)testURL:(NSString*)suffix {
    return [[self class] testURL:suffix];
}

- (void)waitForStatus:(NSInteger)status {
    [self waitForStatus:status timeout:10.0];
}

- (void)createEntity:(id<SocializeEntity>)entity {
    [self prepare];
    [self.socialize createEntity:entity];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)createEntityWithURL:(NSString*)url name:(NSString*)name {
    [self prepare];
    [self.socialize createEntityWithKey:url name:name];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)createComments:(NSArray*)comments {
    [self prepare];
    [self.socialize createComments:comments];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)createComment:(id<SocializeComment>)comment {
    [self createComments:[NSArray arrayWithObject:comment]];
}

- (void)getEntityWithURL:(NSString*)url {
    [self prepare];
    [self.socialize getEntityByKey:url];
    [self waitForStatus:kGHUnitWaitStatusSuccess];    
}

- (void)createCommentWithURL:(NSString*)url text:(NSString*)text latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude subscribe:(BOOL)subscribe {
    [self prepare];
    [self.socialize createCommentForEntityWithKey:url comment:text longitude:longitude latitude:latitude];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    NSLog(@"Created %@", url);
}

- (void)createCommentWithEntity:(id<SocializeEntity>)entity text:(NSString*)text latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude subscribe:(BOOL)subscribe {
    [self prepare];
    [self.socialize createCommentForEntity:entity comment:text longitude:longitude latitude:latitude];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    NSLog(@"Created %@ (%@)", entity.key, entity.name);
}

- (void)getCommentsForEntityWithKey:(NSString*)entityKey {
    [self prepare];
    [self.socialize getCommentList:entityKey first:nil last:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    NSLog(@"Fetched %d comments", [self.fetchedElements count]);
}

- (void)createShareWithURL:(NSString*)url medium:(SocializeShareMedium)medium text:(NSString*)text {
    [self prepare];
    [self.socialize createShareForEntityWithKey:url medium:medium text:text];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
    NSLog(@"Created %@", url);
}

- (void)createShare:(id<SocializeShare>)share {
    [self prepare];
    [self.socialize createShare:share];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)createLikeWithURL:(NSString*)url latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude {
    [self prepare];
    [self.socialize likeEntityWithKey:url longitude:longitude latitude:latitude];
    [self waitForStatus:kGHUnitWaitStatusSuccess];    
    NSLog(@"Created %@", url);
}

- (void)createLike:(id<SocializeLike>)like {
    [self prepare];
    [self.socialize createLike:like];
    [self waitForStatus:kGHUnitWaitStatusSuccess];    
    NSLog(@"Created %@", like.entity.key);
}


- (void)createViewWithURL:(NSString*)url latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude {
    [self prepare];
    [self.socialize viewEntityWithKey:url longitude:longitude latitude:latitude];
    [self waitForStatus:kGHUnitWaitStatusSuccess];    
    NSLog(@"Created %@", url);
}

- (void)getLikesForURL:(NSString*)url {
    [self prepare];
    [self.socialize getLikesForEntityKey:url first:nil last:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess];    
}

- (void)deleteLike:(id<SocializeLike>)like {
    [self prepare];
    [self.socialize unlikeEntity:like];
    [self waitForStatus:kGHUnitWaitStatusSuccess];    
}

/*
- (void)getViewsForURL:(NSString*)url {
    [self prepare];
    [self.socialize getViewsForEntityKey:url first:nil last:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess];    
}
 */

- (void)getActivityForApplication {
    [self prepare];
    [self.socialize getActivityOfCurrentApplicationWithFirst:[NSNumber numberWithInt:0] last:[NSNumber numberWithInt:10]];

    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)getActivityForCurrentUser {
    [self prepare];
    [self.socialize getActivityOfUser:[self.socialize authenticatedUser]];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)getLikesForCurrentUserWithEntity:(id<SocializeEntity>)entity {
    [self prepare];
    [self.socialize getLikesForUser:[self.socialize authenticatedUser] entity:entity first:nil last:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)getSubscriptionsForEntityKey:(NSString*)entityKey {
    [self prepare];
    [self.socialize getSubscriptionsForEntityKey:entityKey first:nil last:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)subscribeToCommentsOnEntity:(id<SocializeEntity>)entity {
    [self prepare];
    [self.socialize subscribeToCommentsForEntityKey:entity.key];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

// Wait for notify
- (void)service:(SocializeService *)request didFail:(NSError *)error {
    NSLog(@"Error happened: %@", [error description]);
    [self notify:kGHUnitWaitStatusFailure];
}

- (void)service:(SocializeService *)service didUpdate:(id<SocializeObject>)object {
    self.updatedObject = object;
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object {
    self.createdObject = object;
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    self.fetchedElements = dataArray;
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)service:(SocializeService *)service didDelete:(id<SocializeObject>)object {
    self.deletedObject = object;
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)didAuthenticate:(id<SocializeUser>)user {
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)fakeCurrentUserWithThirdParties:(NSArray*)thirdParties {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *fakeUser = [NSDictionary dictionaryWithObjectsAndKeys:
                              thirdParties, @"third_party_auth",
                              [NSNumber numberWithInteger:123], @"id",
                              nil];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:fakeUser];
    [userDefaults setObject:data forKey:kSOCIALIZE_AUTHENTICATED_USER_KEY];
    [userDefaults synchronize];
}

- (void)fakeCurrentUserAnonymous {
    [self fakeCurrentUserWithThirdParties:[NSArray array]];
}

- (void)fakeCurrentUserNotAuthed {
    [[Socialize sharedSocialize] removeAuthenticationInfo];
}



@end
