//
//  SocializeObjectFactory.m
//  SocializeSDK
//
//  Created by William M. Johnson on 5/30/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeObjectFactory.h"
#import "SocializeActivity.h"
#import "SocializeConfiguration.h"


@interface SocializeObjectFactory()

-(id)createObjectForClass:(Class)socializeClass;
-(void)configureFactory:(SocializeConfiguration*)configuration;
//The following verify functions should be abstracted out as specifications.
//Objects must satisfy the specifications.  However, I put them here fore simplicity.

-(void)verifyClass:(Class)classToTest AndProtocol:(Protocol *)protocolToTest;
//-(void)verifyClass:(Class)classToTest;
-(void)verifySupportForProtocol:(Protocol *)protocolToTest;
-(void)verifyClass:(Class)classToTest conformsToProtocol:(Protocol *)protocolToTest;
@end 

@implementation SocializeObjectFactory
/*The following Verify Methods should be placed in a "PrivateHeader"*/


//The following verify functions should be abstracted out as specifications.
//Objects must satisfy the specifications.  However, I put it here fore simplicity.
//-(void)verifyClass:(Class)classToTest
//{
//    //TODO: Create logic here for unsupported classes.
//}

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
    //Change to accept default configuration of default Socialize Objects.
    return [self initializeWithConfiguration:[[SocializeConfiguration new]autorelease]];
    
}

-(id)initializeWithConfiguration:(SocializeConfiguration*)configuration;
{
    
    
    self = [super init];
    if (self) 
    {
        prototypeDictionary = [[NSMutableDictionary dictionaryWithCapacity:10]retain]; 
        [self configureFactory:configuration];
    }
    return self;
    
}

-(void)configureFactory:(SocializeConfiguration*)configuration
{
    NSDictionary * prototypes = (NSDictionary *)[[configuration configurationInfo]objectForKey:kSocializeModuleConfigurationPrototypesKey];
    
    NSAssert((prototypes!=nil && ([prototypes count] >0)), @"Prototype configuration is nil or Empty");
    
    NSString * prototypeClassName = nil;
    for (NSString * prototypeProtocolName in [prototypes allKeys]) 
    {
        prototypeClassName = (NSString *)[prototypes objectForKey:prototypeProtocolName]; 
        
        
        Class prototypeClass = NSClassFromString(prototypeClassName);
        [self  addPrototype:prototypeClass forKey:prototypeProtocolName];
    }
}

-(void)addPrototype:(Class)prototypeClass forKey:(NSString *)prototypeProtocolName
{    
    Protocol * prototypeProtocol = NSProtocolFromString(prototypeProtocolName);
    [self verifyClass:prototypeClass AndProtocol:prototypeProtocol];
    [prototypeDictionary setObject:prototypeClass forKey:prototypeProtocolName];
}

#pragma mark Object creation methods
//-(id)createObjectFromString:(NSString *)stringRepresentation forProtocol:(Protocol *)protocol
//{
//    //Note: Don't try to convert format String and pass to function below.  Because we want the formatter
//    //To handle the string.  This keeps the JSON parsing implementation out of the factory.
//
//    //  id<SocializeObject> socializeObject = [self createObjectForProtocol:protocol];
//  
//    //Look-up formatter in formatter dictionary 
//        
//    return socializeObject;
//}

//-(id)createObjectFromDictionary:(NSDictionary *)dictionaryRepresentation forProtocol:(Protocol *)protocol
//{
//    id<SocializeObject> socializeObject = [self createObjectForProtocol:protocol];
//    
//    //Look-up formatter in formatter dictionary
//    return socializeObject;
//    
//}

//-(NSString *)createStringRepresentationOfObject:(id<SocializeObject>)socializeObject
//{
//    return  nil;
//    
//}

-(id)createObjectForProtocolName:(NSString *)prototypeProtocolName
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


-(id)createObjectForProtocol:(Protocol *)protocol
{
    return [self createObjectForProtocolName:NSStringFromProtocol(protocol)];
}
@end
