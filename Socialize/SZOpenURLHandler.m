//
//  SZSmartDownloadHandler.m
//  Socialize
//
//  Created by Nathaniel Griswold on 9/17/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOpenURLHandler.h"
#import "socialize_globals.h"
#import "SZDisplayUtils.h"
#import "SZEntityUtils.h"
#import "SZSmartAlertUtils.h"

@implementation NSURL (QueryParameters)

- (NSDictionary*)queryParameters {
    NSArray *parameters = [[self query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [parameters count]; i=i+2) {
        [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
    }
    
    return keyValueParm;
}

@end


static SZOpenURLHandler *sharedOpenURLHandler;

@implementation SZOpenURLHandler

+ (NSString*)defaultSmartDownloadURLPath {
    return @"smart_url";
}

+ (SZOpenURLHandler*)sharedOpenURLHandler {
    if (sharedOpenURLHandler == nil) {
        sharedOpenURLHandler = [[SZOpenURLHandler alloc] init];
    }
    
    return sharedOpenURLHandler;
}

- (id<SZDisplay>)display {
    if (_display == nil) {
        _display = [SZDisplayUtils globalDisplay];
    }
    
    return _display;
}

- (BOOL)handleOpenURL:(NSURL*)url {
    if (![[url scheme] startsWith:@"sz"]) {
        return NO;
    }
        
    NSString *path = [[url path] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    
    // In case the dev forgets the third slash in szXXX:///
    if ([path length] == 0) {
        path = [url host];
    }
    
    //  --- Smart Downloads URL ---
    if ([path isEqualToString:[[self class] defaultSmartDownloadURLPath]]) {
        
        NSDictionary *params = [url queryParameters];
        NSString* entityKey = [[params objectForKey:@"entity_key"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (![SZEntityUtils canLoadEntity:[SZEntity entityWithKey:entityKey]]) {
            NSLog(@"Socialize Warning: Smart Download open, but cannot load entity. Doing Nothing.");
            return YES;
        }
        
        if ([entityKey length] == 0) {
            NSLog(@"Socialize Warning: Smart Download open, but missing url parameters. Doing Nothing.");
            return YES;
        }
        
        [self.display socializeDidStartLoadingForContext:SZLoadingContextFetchingEntityForSmartDownloadsURLOpen];
        
        [SZEntityUtils fetchEntityAndShowEntityLoaderForEntityWithKey:entityKey
                                                              success:^(id<SocializeEntity> entity) {
                                                                  [self.display socializeDidStopLoadingForContext:SZLoadingContextFetchingEntityForSmartDownloadsURLOpen];
                                                                  
                                                              } failure:^(NSError *error) {
                                                                  [self.display socializeDidStopLoadingForContext:SZLoadingContextFetchingEntityForSmartDownloadsURLOpen];
                                                                  [self.display socializeRequiresIndicationOfFailureForError:error];
                                                                  
                                                              }];
        return YES;
        
    } else {
        NSLog(@"Socialize Warning: Unrecognized path in URL %@, ignoring", url);
        return NO;
    }
}

@end
