//
//  SocializeTestCase.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/20/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SZIntegrationTestCase.h"
#import <Socialize/Socialize.h>
#import <UIKit/UIKit.h>
#import <OCMock/ClassMockRegistry.h>
#import "StringHelper.h"
#import <BlocksKit/BlocksKit.h>

static NSString *UUIDString() {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

static NSString *SocializeAsyncTestCaseRunID = nil;

typedef void (^ActionBlock1)(void(^actionSuccess)(id), void(^actionFailure)(NSError*));
typedef void (^ActionBlock1B)(void(^actionSuccess)(BOOL), void(^actionFailure)(NSError*));

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

- (void)handleException:(NSException *)exception {
    [ClassMockRegistry stopMockingAllClasses];
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

- (id)callAsync1WithAction:(ActionBlock1)action {
    __block id outerResult = nil;
    [self prepare];
    action(^(id result) {
        outerResult = [result retain];
        [self notify:kGHUnitWaitStatusSuccess];
    }, ^(NSError *error) {
        NSLog(@"Async call failed with error: %@", error);
        [self notify:kGHUnitWaitStatusFailure];
    });
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:20];
    return [outerResult autorelease];

}

- (BOOL)callAsync1BWithAction:(ActionBlock1B)action {
    __block BOOL outerResult;
    [self prepare];
    action(^(BOOL result) {
        outerResult = result;
        [self notify:kGHUnitWaitStatusSuccess];
    }, ^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    });
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return outerResult;
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
    SZAuthWrapper(^{
        [self.socialize createComments:comments];
    }, ^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    });
    
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)createComment:(id<SocializeComment>)comment {
    [self createComments:[NSArray arrayWithObject:comment]];
}

- (id<SZComment>)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options networks:(SZSocialNetwork)networks {
    __block id<SZComment> createdComment = nil;
    [self prepare];
    [SZCommentUtils addCommentWithEntity:entity text:text options:nil networks:SZSocialNetworkNone success:^(id<SZComment> comment) {
        createdComment = [comment retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [createdComment autorelease];
}

- (id<SZComment>)getCommentWithId:(NSNumber*)commentId {
    __block id<SZComment> fetchedComment = nil;
    [self prepare];
    [SZCommentUtils getCommentWithId:commentId success:^(id<SZComment> comment) {
        fetchedComment = [comment retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedComment autorelease];
}

- (NSArray*)utilGetCommentsForEntityWithKey:(NSString*)entityKey {
    __block NSArray *fetchedComments = nil;
    [self prepare];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey];
    [SZCommentUtils getCommentsByEntity:entity success:^(NSArray *comments) {
        fetchedComments = [comments retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedComments autorelease];
}

- (NSArray*)getCommentsByUser:(id<SZUser>)user {
    __block NSArray *fetchedComments = nil;
    [self prepare];
    [SZCommentUtils getCommentsByUser:user first:nil last:nil success:^(NSArray *comments) {
        fetchedComments = [comments retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedComments autorelease];
}

- (NSArray*)getCommentsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity {
    __block NSArray *fetchedComments = nil;
    [self prepare];
    [SZCommentUtils getCommentsByUser:user entity:entity first:nil last:nil success:^(NSArray *comments) {
        fetchedComments = [comments retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedComments autorelease];
}

- (NSArray*)getCommentsByApplication {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZCommentUtils getCommentsByApplicationWithFirst:nil last:nil success:actionSuccess failure:actionFailure];
    }];

}

- (id<SZLike>)likeWithEntity:(id<SZEntity>)entity options:(SZLikeOptions*)options networks:(SZSocialNetwork)networks {
    __block id<SZLike> fetchedLike = nil;
    [self prepare];
    [SZLikeUtils likeWithEntity:entity options:options networks:networks success:^(id<SZLike> like) {
        fetchedLike = [like retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedLike autorelease];
}

- (id<SZLike>)unlike:(id<SZEntity>)entity {
    __block id<SZLike> fetchedLike = nil;
    [self prepare];
    [SZLikeUtils unlike:entity success:^(id<SZLike> like) {
        fetchedLike = [like retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedLike autorelease];
}

- (BOOL)isLiked:(id<SZEntity>)entity {
    return [self callAsync1BWithAction:^(void(^actionSuccess)(BOOL), void(^actionFailure)(NSError*)) {
        [SZLikeUtils isLiked:entity success:actionSuccess failure:actionFailure];
    }];
}

- (id<SZLike>)getLike:(id<SZEntity>)entity {
    __block id<SZLike> fetchedLike = nil;
    [self prepare];
    [SZLikeUtils getLike:entity success:^(id<SZLike> like) {
        fetchedLike = [like retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedLike autorelease];
}

- (NSArray*)getLikesForUser:(id<SZUser>)user {
    __block NSArray *fetchedLikes = nil;
    [self prepare];
    [SZLikeUtils getLikesForUser:user start:nil end:nil success:^(NSArray *likes) {
        fetchedLikes = [likes retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedLikes autorelease];
}

- (NSArray*)getLikesByApplication {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZLikeUtils getLikesByApplicationWithFirst:nil last:nil success:actionSuccess failure:actionFailure];
    }];
    
}

- (NSArray*)getSharesByApplication {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZShareUtils getSharesByApplicationWithFirst:nil last:nil success:actionSuccess failure:actionFailure];
    }];
    
}

- (id<SZLike>)getLikeForUser:(id<SZUser>)user entity:(id<SZEntity>)entity {
    __block id<SZLike> fetchedLike = nil;
    [self prepare];
    [SZLikeUtils getLikeForUser:user entity:entity success:^(id<SZLike> like) {
        fetchedLike = [like retain];
        [self notify:kGHUnitWaitStatusSuccess];
    } failure:^(NSError *error) {
        [self notify:kGHUnitWaitStatusFailure];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10];
    return [fetchedLike autorelease];
}

- (NSArray*)getActionsForApplication {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZActionUtils getActionsByApplicationWithStart:nil end:nil success:actionSuccess failure:actionFailure];
    }];
}

- (NSArray*)getActionsForUser:(id<SZUser>)user {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZActionUtils getActionsByUser:user start:nil end:nil success:actionSuccess failure:actionFailure];
    }];
}

- (NSArray*)getActionsByEntity:(id<SZEntity>)entity {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZActionUtils getActionsByEntity:entity start:nil end:nil success:actionSuccess failure:actionFailure];
    }];
}

- (NSArray*)getActionsForUser:(id<SZUser>)user entity:(id<SZEntity>)entity {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZActionUtils getActionsByUser:user entity:entity start:nil end:nil success:actionSuccess failure:actionFailure];
    }];
}

- (id<SZEntity>)getEntityWithKey:(NSString*)entityKey {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZEntityUtils getEntityWithKey:entityKey success:actionSuccess failure:actionFailure];
    }];
}

- (NSArray*)getEntitiesWithSorting:(SZResultSorting)sorting {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZEntityUtils getEntitiesWithSorting:sorting first:nil last:[NSNumber numberWithInteger:20] success:actionSuccess failure:actionFailure];
    }];
}

- (NSArray*)getEntities {
    return [self getEntitiesWithSorting:SZResultSortingDefault];
}

- (NSArray*)getEntitiesWithIds:(NSArray*)ids {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZEntityUtils getEntitiesWithIds:ids success:actionSuccess failure:actionFailure];
    }];
}

- (id<SZEntity>)addEntity:(id<SZEntity>)entity {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZEntityUtils addEntity:entity success:actionSuccess failure:actionFailure];
    }];
}

- (id<SZView>)viewEntity:(id<SZEntity>)entity {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZViewUtils viewEntity:entity success:actionSuccess failure:actionFailure];
    }];
}

- (NSArray*)getViewsByUser:(id<SZUser>)user {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZViewUtils getViewsByUser:user start:nil end:nil success:actionSuccess failure:actionFailure];
    }];
}

- (NSArray*)getViewsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZViewUtils getViewsByUser:user entity:entity start:nil end:nil success:actionSuccess failure:actionFailure];
    }];
}

- (id<SZSubscription>)subscribeToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)subscriptionType {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZSubscriptionUtils subscribeToEntity:entity subscriptionType:subscriptionType success:actionSuccess failure:actionFailure];
    }];
}

- (id<SZSubscription>)unsubscribeFromEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)subscriptionType {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZSubscriptionUtils unsubscribeFromEntity:entity subscriptionType:subscriptionType success:actionSuccess failure:actionFailure];
    }];
}

- (NSArray*)getSubscriptionsForEntity:(id<SZEntity>)entity {
    return [self callAsync1WithAction:^(void(^actionSuccess)(id), void(^actionFailure)(NSError*)) {
        [SZSubscriptionUtils getSubscriptionsForEntity:entity subscriptionType:SZSubscriptionTypeNewComments start:nil end:nil success:actionSuccess failure:actionFailure];
    }];
}

- (BOOL)isSubscribedToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)subscriptionType {
    return [self callAsync1BWithAction:^(void(^actionSuccess)(BOOL), void(^actionFailure)(NSError*)) {
        [SZSubscriptionUtils isSubscribedToEntity:entity subscriptionType:subscriptionType success:actionSuccess failure:actionFailure];
    }];
}

- (id<SZObject>)findObjectWithId:(int)objectID inArray:(NSArray*)array {
    return [array match:^BOOL (id<SZObject> object) {
        return [object objectID] == objectID;
    }];   
}

- (void)assertObject:(id<SZObject>)object inCollection:(id)collection {
    id<SZObject> foundObject = (id<SZObject>)[self findObjectWithId:[object objectID] inArray:collection];
    GHAssertNotNil(foundObject, @"Should have object with id %@", [object objectID]);
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
    [userDefaults setObject:data forKey:@"SOCIALIZE_AUTHENTICATED_USER_KEY"];
    [userDefaults synchronize];
}

- (void)fakeCurrentUserAnonymous {
    [self fakeCurrentUserWithThirdParties:[NSArray array]];
}

- (void)fakeCurrentUserNotAuthed {
    [[Socialize sharedSocialize] removeAuthenticationInfo];
}



@end
