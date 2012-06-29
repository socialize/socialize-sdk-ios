//
//  SZUserSettings.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZUserSettings.h"

@implementation SZUserSettings
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize bio = _bio;
@synthesize dontShareLocation = _dontShareLocation;
@synthesize dontPostToFacebook = _dontPostToFacebook;
@synthesize dontPostToTwitter = _dontPostToTwitter;
@synthesize autopostEnabled = _autopostEnabled;
@synthesize profileImage = _profileImage;
@synthesize meta = _meta;

- (id)initWithFullUser:(id<SZFullUser>)fullUser {
    if (self = [super init]) {
        self.firstName = fullUser.firstName;
        self.lastName = fullUser.lastName;
        self.bio = fullUser.description;
        self.lastName = fullUser.lastName;
        self.meta = fullUser.meta;
    }
    
    return self;
}

- (void)populateFullUser:(id<SZFullUser>)fullUser {
    [fullUser setFirstName:self.firstName];
    [fullUser setLastName:self.lastName];
    [fullUser setDescription:self.bio];
    [fullUser setMeta:self.meta];
}

@end
