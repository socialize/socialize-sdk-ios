//
//  SocializeEntity.m
//  SocializeSDK
//
//  Created by William Johnson on 5/12/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeEntity.h"
#import "SocializeObjectFactory.h"
#import "StringHelper.h"

@implementation SocializeEntity


@synthesize  key   = _key;
@synthesize  name  = _name;
@synthesize  views = _views; 
@synthesize  likes = _likes;
@synthesize  comments = _comments;
@synthesize  shares = _shares;
@synthesize  meta = _meta;
@synthesize  userActionSummary = _userActionSummary;
@synthesize  type = _type;

-(void)dealloc
{
    [_key release];
    [_name release];
    [_meta release];
    [_userActionSummary release];
    [_type release];
    
    [super dealloc];
}

+ (SocializeEntity*)entityWithKey:(NSString*)key {
    return [self entityWithKey:key name:nil];
}

+ (SocializeEntity*)entityWithKey:(NSString*)key name:(NSString*)name {
    SocializeEntity *entity = [[[self alloc] init] autorelease];
    
    entity.key = key;
    entity.name = name;
    return entity;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[SZEntity class]] && [[object key] isEqualToString:[self key]];
}

- (BOOL)keyIsURL {
    return [self.key isURLString];
}

- (NSUInteger)hash {
    return [self.key hash];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@/%@, %d/%d/%d, %@", [self key], [self name], [self comments], [self likes], [self shares], [self userActionSummary]];
}

- (NSString*)displayName {
    NSString *displayName;
    if ([[self name] length] > 0) {
        displayName = [self name];
    } else {
        displayName = [self key];
    }
    
    return displayName;
}

@end

NSDictionary *SZServerParamsForEntity(id<SZEntity> entity) {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([[entity name] length] > 0) {
        NSDictionary *subParams = [[SocializeObjectFactory sharedObjectFactory] createDictionaryRepresentationOfObject:entity];
        [params setObject:subParams forKey:@"entity"];
    } else {
        [params setObject:[entity key] forKey:@"entity_key"];
    }
    
    return params;
}

BOOL SZEntityIsLiked(id<SZEntity> entity) {
    return [[[entity userActionSummary] objectForKey:@"likes"] integerValue] > 0;
}

