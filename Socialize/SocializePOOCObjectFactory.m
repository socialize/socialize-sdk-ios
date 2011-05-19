//
//  POOCObjectFactory.m
//  SocializeSDK
//
//  Created by William Johnson on 5/17/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializePOOCObjectFactory.h"
#import "SocializeActivity.h"
#import "SocializeConfiguration.h"

@interface SocializePOOCObjectFactory()

-(id)createObjectForClass:(Class)socializeClass;

//The following verify functions should be abstracted out as specifications.
//Objects must satisfy the specifications.  However, I put them here fore simplicity.

-(void)verifyClass:(Class)classToTest AndProtocol:(Protocol *)protocolToTest;
-(void)verifyClass:(Class)classToTest;
-(void)verifySupportForProtocol:(Protocol *)protocolToTest;
-(void)verifyClass:(Class)classToTest conformsToProtocol:(Protocol *)protocolToTest;
@end 

@implementation SocializePOOCObjectFactory

//The following verify functions should be abstracted out as specifications.
//Objects must satisfy the specifications.  However, I put it here fore simplicity.
-(void)verifyClass:(Class)classToTest
{
    //TODO: Create logic here for unsupported classes.
}

-(void)verifyClass:(Class)classToTest AndProtocol:(Protocol *)protocolToTest
{
    
    [self verifySupportForProtocol:protocolToTest];
    [self verifyClass:classToTest conformsToProtocol:protocolToTest];
    
    
}

-(void)verifyClass:(Class)classToTest conformsToProtocol:(Protocol *)protocolToTest
{
    NSAssert([classToTest conformsToProtocol:protocolToTest],@"class doesn't conform to protocol");
    
}

-(void)verifySupportForProtocol:(Protocol *)protocolToTest
{
    
    //TODO: Create logic here for unsupported protocols.
}


- (void)dealloc 
{
    [prototypeDictionary release];
    [super dealloc];
}

- (id)init 
{
   
    return [self initializeWithConfiguration:[[SocializeConfiguration new]autorelease]];
   
}

-(id)initializeWithConfiguration:(SocializeConfiguration*)configuration;
{
    
    
    self = [super init];
    if (self) 
    {
        prototypeDictionary = [[NSMutableDictionary dictionaryWithCapacity:10]retain]; 
    
        NSDictionary * prototypes = (NSDictionary *)[[configuration configurationInfo]objectForKey:kSocializeModuleConfigurationPrototypesKey];

        
        NSString * prototypeClassName = nil;
        for (NSString * prototypeProtocolName in [prototypes allKeys]) 
        {
            prototypeClassName = (NSString *)[prototypes objectForKey:prototypeProtocolName]; 
        
        
            Class prototypeClass = NSClassFromString(prototypeClassName);
            [self  addPrototype:prototypeClass forKey:prototypeProtocolName];
        }
    }
    return self;
    
}


-(void)addPrototype:(Class)prototypeClass forKey:(NSString *)prototypeProtocolName
{    
    Protocol * prototypeProtocol = NSProtocolFromString(prototypeProtocolName);
    [self verifyClass:prototypeClass AndProtocol:prototypeProtocol];
    [prototypeDictionary setObject:prototypeClass forKey:prototypeProtocolName];
}

-(id)createObject:(NSString *)prototypeProtocolName
{
    Class classToCreate = (Class) [prototypeDictionary objectForKey:prototypeProtocolName];
    NSAssert(classToCreate!=nil, @"%@ - prototype does not exist for this key. Please add prototype to the Factory", 
             prototypeProtocolName);
    
    return [self createObjectForClass:classToCreate];
}

-(id)createObjectForClass:(Class)socializeClass
{
    
    return [[socializeClass new ]autorelease];
}

@end
