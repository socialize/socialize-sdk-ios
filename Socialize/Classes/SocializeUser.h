//
//  SocializeUser.h
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObject.h"

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

-(void) setDescription: (NSString*)description;
-(NSString*)description;

-(void) setLocation: (NSString*) location;
-(NSString*)location;

-(void)setMedium_image_uri: (NSString*)mediumImageUrl;
-(NSString*)medium_image_uri;

-(void)setLarge_image_uri: (NSString*) largeImageUrl;
-(NSString*)large_image_uri;

-(void) setViews: (int) views;
-(int)views;

-(void) setLikes: (int) likes;
-(int)likes;

-(void) setComments: (int) comments;
-(int)comments;

-(void)setShare: (int) share;
-(int)share;

@end

@interface SocializeUser : SocializeObject<SocializeUser> 
{
    @private
        NSString* _firstName;
        NSString* _lastName;
        NSString* _userName;
        NSString* _smallInageUrl;
        NSString* _city;
        NSString* _state;
    
        NSString* _description;
        NSString* _location;
        NSString* _medium_image_uri;
        NSString* _large_image_uri;
    
        int _views;
        int _likes;
        int _comments;
        int _share;
}

@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* smallImageUrl;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* state;

@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* location;
@property (nonatomic, retain) NSString* medium_image_uri;
@property (nonatomic, retain) NSString* large_image_uri;

@property (nonatomic, assign) int views;
@property (nonatomic, assign) int likes;
@property (nonatomic, assign) int comments;
@property (nonatomic, assign) int share;


@end
