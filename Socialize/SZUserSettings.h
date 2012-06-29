//
//  SZUserSettings.h
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUserSettings : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSNumber *dontShareLocation;
@property (nonatomic, copy) NSNumber *dontPostToFacebook;
@property (nonatomic, copy) NSNumber *dontPostToTwitter;
@property (nonatomic, copy) NSNumber *autopostEnabled;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, copy) NSString *meta;
@end
