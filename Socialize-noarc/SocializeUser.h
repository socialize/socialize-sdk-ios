//
//  SocializeUser.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"
#import "SocializeCommonDefinitions.h"


/**Protocol for socialize user representation.*/
@protocol SocializeUser<SocializeObject>

@required

-(void) setFirstName: (NSString*) firstName;
-(NSString*) firstName;

-(void) setLastName: (NSString*) lastName;
-(NSString*) lastName;

-(void) setUserName: (NSString*) userName;
-(NSString*) userName;

-(NSString*) displayName;

-(void) setSmallImageUrl: (NSString*) smallImageUrl;
-(NSString*)smallImageUrl;

-(void) setCity: (NSString*) city;
-(NSString*) city;

-(void) setState: (NSString*) state;
-(NSString*) state;

-(void) setMeta: (NSString*)meta;
-(NSString*) meta;

-(void)setThirdPartyAuth:(NSArray*)auth;
-(NSArray*)thirdPartyAuth;

@end

/**Private implementation of <SocializeUser> protocol*/
@interface SocializeUser : SocializeObject<SocializeUser> 
{
    @private
        NSString* _firstName;
        NSString* _lastName;
        NSString* _userName;
        NSString* _smallInageUrl;
        NSString* _city;
        NSString* _state;
        NSString* _meta;
        NSArray* _thirdPartyAuth;
}

@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, copy) NSString* smallImageUrl;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* state;
@property (nonatomic, copy) NSString* meta;
@property (nonatomic, copy) NSArray* thirdPartyAuth;

@end
