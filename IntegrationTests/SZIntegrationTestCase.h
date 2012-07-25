//
//  SocializeTestCase.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/20/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <Socialize/Socialize.h>

@interface SZIntegrationTestCase : GHAsyncTestCase <SocializeServiceDelegate>
@property (nonatomic, readonly) NSString *runID;
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) NSArray *fetchedElements;
@property (nonatomic, retain) id createdObject;
@property (nonatomic, retain) id updatedObject;
@property (nonatomic, retain) id deletedObject;

- (void)waitForStatus:(NSInteger)status;
- (NSString*)testURL:(NSString*)suffix;
- (void)createCommentWithURL:(NSString*)url text:(NSString*)text latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude subscribe:(BOOL)subscribe;
- (void)createCommentWithEntity:(id<SocializeEntity>)entity text:(NSString*)text latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude subscribe:(BOOL)subscribe;
- (id<SZComment>)addCommentWithEntity:(id<SZEntity>)entity text:(NSString*)text options:(SZCommentOptions*)options networks:(SZSocialNetwork)networks;
- (id<SZComment>)getCommentWithId:(NSNumber*)commentId;
- (void)getCommentsForEntityWithKey:(NSString*)entityKey;
- (void)createShareWithURL:(NSString*)url medium:(SocializeShareMedium)medium text:(NSString*)text;
- (void)createShare:(id<SocializeShare>)share;
- (void)createLikeWithURL:(NSString*)url latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude;
- (void)createLike:(id<SocializeLike>)like;
- (void)createViewWithURL:(NSString*)url latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude;
- (void)getActivityForCurrentUser;
- (void)getActivityForApplication;
- (void)getLikesForURL:(NSString*)url;
- (void)getLikesForCurrentUserWithEntity:(id<SocializeEntity>)entity;
- (void)deleteLike:(id<SocializeLike>)like;
- (void)createEntityWithURL:(NSString*)url name:(NSString*)name;
- (void)createEntity:(id<SocializeEntity>)entity;
- (void)getEntityWithURL:(NSString*)url;
- (void)getSubscriptionsForEntityKey:(NSString*)entityKey;
- (void)createComments:(NSArray*)comments;
- (void)createComment:(id<SocializeComment>)comment;
- (void)subscribeToCommentsOnEntity:(id<SocializeEntity>)entity;
- (void)authenticateAnonymouslyIfNeeded;
- (void)authenticateAnonymously;
- (void)fakeCurrentUserWithThirdParties:(NSArray*)thirdParties;
- (void)fakeCurrentUserAnonymous;
- (void)fakeCurrentUserNotAuthed;
- (NSArray*)utilGetCommentsForEntityWithKey:(NSString*)entityKey;
- (NSArray*)getCommentsByUser:(id<SZUser>)user;
- (NSArray*)getCommentsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity;
- (NSArray*)getCommentsByApplication;
- (id<SZLike>)likeWithEntity:(id<SZEntity>)entity options:(SZLikeOptions*)options networks:(SZSocialNetwork)networks;
- (id<SZLike>)unlike:(id<SZEntity>)entity;
- (BOOL)isLiked:(id<SZEntity>)entity;
- (id<SZLike>)getLike:(id<SZEntity>)entity;
- (NSArray*)getLikesForUser:(id<SZUser>)user;
- (NSArray*)getLikesByApplication;
- (id<SZLike>)getLikeForUser:(id<SZUser>)user entity:(id<SZEntity>)entity;
- (NSArray*)getActionsForApplication;
- (NSArray*)getActionsForUser:(id<SZUser>)user;
- (NSArray*)getActionsByEntity:(id<SZEntity>)entity;
- (NSArray*)getActionsForUser:(id<SZUser>)user entity:(id<SZEntity>)entity;
- (id<SZObject>)findObjectWithId:(int)objectID inArray:(NSArray*)array;
- (void)assertObject:(id<SZObject>)object inCollection:(id)collection;
- (id<SZEntity>)getEntityWithKey:(NSString*)entityKey;
- (NSArray*)getEntities;
- (NSArray*)getEntitiesWithIds:(NSArray*)ids;
- (id<SZEntity>)addEntity:(id<SZEntity>)entity;
- (id<SZView>)viewEntity:(id<SZEntity>)entity;
- (NSArray*)getViewsByUser:(id<SZUser>)user;
- (NSArray*)getViewsByUser:(id<SZUser>)user entity:(id<SZEntity>)entity;
- (id<SZSubscription>)subscribeToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)subscriptionType;
- (id<SZSubscription>)unsubscribeFromEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)subscriptionType;
- (NSArray*)getSubscriptionsForEntity:(id<SZEntity>)entity;
- (BOOL)isSubscribedToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)subscriptionType;
- (NSArray*)getSharesByApplication;

//- (void)getViewsForURL:(NSString*)url;
@end
