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

//- (void)getViewsForURL:(NSString*)url;
@end
