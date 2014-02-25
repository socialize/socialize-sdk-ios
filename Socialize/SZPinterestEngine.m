//
//  SZPinterestEngine.m
//  Socialize
//
//  Created by Sergey Popenko on 6/24/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZPinterestEngine.h"
#import "StringHelper.h"

static SZPinterestEngine *sharedInstance;

@interface SZPinterestEngine()
@property(nonatomic, strong) id pinterest;
@property(nonatomic, copy) void (^success)(void);
@property(nonatomic, copy) void (^failure)(void);
@end

@implementation SZPinterestEngine

- (BOOL) isAvailable
{
    return self.pinterest ? (BOOL)[self.pinterest performSelector:@selector(canPinWithSDK) withObject:nil] : NO;
    return YES;
}

- (BOOL) handleOpenURL:(NSURL*)url
{
    if (![[url scheme] startsWith:@"pin"]) {
        return NO;
    }
    
    NSInteger index = [[url absoluteString] indexOf:@"pin_success=" from:0];
    NSString* paramsString = [[url absoluteString] substringFrom:index to:[url absoluteString].length];
    
    if ([paramsString isEqual:@"1"] && self.success) {
        self.success();
    }
    
    if ([paramsString isEqual:@"0"] && self.failure) {
        self.failure();
    }

    return YES;
}

- (void) setApplicationId: (NSString*) appID
{
    Class PinterestClass = NSClassFromString(@"Pinterest");
    if (PinterestClass) {
        self.pinterest = [[PinterestClass alloc] performSelector:@selector(initWithClientId:) withObject:appID];
    }
    else
        self.pinterest = nil;
}

- (void) share:(NSString*) message imageURL:(NSURL*) imageUrl sourceUrl:(NSURL*)sourceUrl
       success:(void(^)())success
       failure:(void(^)())failure
{
    if(![self isAvailable])
        return;

    self.success = success;
    self.failure = failure;
    
    NSMethodSignature *signature = [self.pinterest methodSignatureForSelector:@selector(createPinWithImageURL:sourceURL:description:)];
    if(signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:@selector(createPinWithImageURL:sourceURL:description:)];
        [invocation setArgument:&imageUrl atIndex:2];
        [invocation setArgument:&sourceUrl atIndex:3];
        [invocation setArgument:&message atIndex:4];
        [invocation setTarget:self.pinterest];
        [invocation invoke];
    }
}

+ (SZPinterestEngine*) sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[SZPinterestEngine alloc] init];
        }

        return sharedInstance;
    }
}

@end
