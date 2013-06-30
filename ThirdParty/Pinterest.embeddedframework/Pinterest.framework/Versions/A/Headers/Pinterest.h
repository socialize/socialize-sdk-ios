//
//  Pinterest.h
//  Pinterest
//
//  Created by Naveen Gavini on 2/15/13.
//  Copyright (c) 2013 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Pinterest : NSObject

- (id)initWithClientId:(NSString *)clientId;

- (id)initWithClientId:(NSString *)clientId
       urlSchemeSuffix:(NSString *)suffix;

- (BOOL)canPinWithSDK;

- (void)createPinWithImageURL:(NSURL *)imageURL
                    sourceURL:(NSURL *)sourceURL
                  description:(NSString *)descriptionText;

+ (UIButton *)pinItButton;

@end
