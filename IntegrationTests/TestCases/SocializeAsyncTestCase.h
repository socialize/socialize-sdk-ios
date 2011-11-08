//
//  SocializeTestCase.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/20/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <Socialize/Socialize.h>

@interface SocializeAsyncTestCase : GHAsyncTestCase <SocializeServiceDelegate>
@property (nonatomic, readonly) NSString *runID;
@property (nonatomic, retain) Socialize *socialize;
@property (nonatomic, retain) NSArray *fetchedElements;
@property (nonatomic, retain) id createdObject;
@property (nonatomic, retain) id updatedObject;
@property (nonatomic, retain) id deletedObject;

- (void)waitForStatus:(NSInteger)status;
- (NSString*)testURL:(NSString*)suffix;
- (void)createCommentWithURL:(NSString*)url text:(NSString*)text latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude;
- (void)createShareWithURL:(NSString*)url medium:(ShareMedium)medium text:(NSString*)text;
- (void)createLikeWithURL:(NSString*)url latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude;
- (void)createViewWithURL:(NSString*)url latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude;
- (void)getActivityForCurrentUser;
- (void)getActivityForApplication;
- (void)getLikesForURL:(NSString*)url;
- (void)deleteLike:(id<SocializeLike>)like;
- (void)createEntityWithURL:(NSString*)url name:(NSString*)name;
- (void)getEntityWithURL:(NSString*)url;
//- (void)getViewsForURL:(NSString*)url;
@end
