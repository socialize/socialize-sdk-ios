//
//  SocializeTestCase.m
//  SocializeSDK
//
//  Created by Isaac Mosquera on 9/20/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeAsyncTestCase.h"

static NSString *UUIDString() {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

static NSString *SocializeAsyncTestCaseRunID = nil;

@implementation SocializeAsyncTestCase
@synthesize socialize = socialize_;
@synthesize fetchedElements = fetchedElements_;
@synthesize createdObject = createdObject_;
@synthesize updatedObject = updatedObject_;
@synthesize deletedObject = deletedObject_;

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

- (void)setUp {
    self.socialize = [[[Socialize alloc] initWithDelegate:self] autorelease];
}

- (void)tearDown {
    self.socialize.delegate = nil;
    self.socialize = nil;
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
    [self.socialize getActivityOfCurrentApplication];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)getActivityForCurrentUser {
    [self prepare];
    [self.socialize getActivityOfUser:[self.socialize authenticatedUser]];
    [self waitForStatus:kGHUnitWaitStatusSuccess];
}

- (void)getSubscriptionsForEntityKey:(NSString*)entityKey {
    [self prepare];
    [self.socialize getSubscriptionsForEntityKey:entityKey first:nil last:nil];
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


@end
