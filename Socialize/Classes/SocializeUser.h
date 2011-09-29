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

-(NSNumber*)userIdForThirdPartyAuth:(ThirdPartyAuthName) auth;

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

@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* smallImageUrl;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* state;
@property (nonatomic, retain) NSString* meta;
@property (nonatomic, retain) NSArray* thirdPartyAuth;

-(NSNumber*)userIdForThirdPartyAuth:(ThirdPartyAuthName) auth;

@end
