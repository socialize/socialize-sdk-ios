#import "api_client.h"

// begin-snippet

@implementation SampleAPIClient
@synthesize socialize = socialize_;
@synthesize like = like_;

- (void)dealloc {
    self.socialize = nil;
    
    [super dealloc];
}

- (Socialize*)socialize {
    if (socialize_ == nil) {
        socialize_ = [[Socialize alloc] initWithDelegate:self];
    }
    return socialize_;
}

// We need the implement the delegate methods, none of which are required, they are all optional

#pragma mark SocializeServiceDelegate

// this method is optional
- (void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    
}

// this method is optional
- (void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{
    
}

// this method is optional
- (void)service:(SocializeService*)service didFail:(NSError*)error{
    
}

// this method is optional
- (void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    
}

// this method is optional
- (void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    
}

// this method is optional
- (void)didAuthenticate{
    
}

#pragma mark -

@end

// end-snippet


@implementation SampleAPIClient (AuthenticateAnonymously)

// begin-authenticate-anonymously-snippet

// invoke the call
- (void)authenticateAnonymouslyWithSocialize {
    [self.socialize authenticateAnonymously];
}

#pragma mark SocializeServiceDelegate implementation
// implement the delegate
- (void)didAuthenticate:(id<SocializeUser>)user {
    NSLog(@"Authenticated");
}

// if the authentication fails the following method is called
- (void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"%@", error);
}

// end-authenticate-anonymously-snippet

@end

@implementation SampleAPIClient (CreateEntity)

// begin-create-entity-snippet

- (void)createEntityOnSocializeServer {
    SocializeEntity *entity = [SocializeEntity entityWithKey:@"key" name:@"An Entity"];
    [self.socialize createEntity:entity];
}

#pragma mark SocializeServiceDelegate

// if the operation fails the following method is called
- (void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"Entity create failed with error: %@", error);
}

//if the delete is successful
- (void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    NSLog(@"Entity created successfully");
}
// end-create-entity-snippet

@end

@implementation SampleAPIClient (CreateEntityWithMeta)

// begin-create-entity-meta-snippet

- (void)createEntityOnSocializeServer {
    SocializeEntity *entity = [SocializeEntity entityWithKey:@"another_key" name:@"An Entity With Some Metadata"];
    entity.meta = @"Optional metadata to be stored on the Socialize servers";
    [self.socialize createEntity:entity];
}

- (void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"%@", error);
}

//if the delete is successful
- (void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    NSLog(@"entity created");
}

// end-create-entity-meta-snippet

@end

@implementation SampleAPIClient (GetEntity)

// begin-get-entity-snippet

- (void)getEntityFromSocialize {
    [self.socialize getEntityByKey:@"www.techcrunch.com"];
}

#pragma mark SocializeServiceDelegate

//if the entity does not exist
- (void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"Service failure: %@", [error localizedDescription]);
}

// if the entity is found, we can access it at the first index of the array.
// The size will always be one when we are trying to get information about an entity.
- (void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray {
    if ([dataArray count]){
        id<SocializeObject> object = [dataArray objectAtIndex:0];
        if ([object isKindOfClass:[SocializeEntity class]]) {
            // do entity saving here.
            // All the entity related information can be fetched here ie stats or name.
        }
    }
}

// end-get-entity-snippet

@end

@implementation SampleAPIClient (RegisterView)

// begin-register-view-snippet

- (void)registerViewWithSocialize {
    // invoke the call (the latitude and the longitude can be nil)
    [self.socialize viewEntityWithKey:@"www.techcrunch.com" longitude:nil latitude:nil];
}

// creating a view would invoke this callback and it would have an element of type id<SocializeView>
- (void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    if ([object isKindOfClass:[SocializeView class]]) {
        id<SocializeView> view = (id<SocializeView>)object;
        NSLog(@"Created view for entity %@", view.entity.name);
        // do your magic/logic here
    }
}

//in case of error
- (void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"Service failure: %@", [error localizedDescription]);
}


// end-register-view-snippet

@end


@implementation SampleAPIClient (LikeEntity)

// begin-like-entity-snippet

- (void)likeEntity {
    // Allocate memory for the instance
    Socialize* socialize = [[Socialize alloc] initWithDelegate:self];
    
    // invoke the call (the latitude and the longitude can be nil)
    [socialize likeEntityWithKey:@"www.url.com" longitude:[NSNumber numberWithFloat:-37.256] latitude:[NSNumber numberWithFloat:122.452314]
     ];
}
    
#pragma mark SocializeServiceDelegate
    
//if the like fails this is called
- (void)service:(SocializeService*)service didFail:(NSError*)error{
    
}

// if the like is created this is called
- (void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
    if ([object isKindOfClass:[SocializeLike class]]) {
        id<SocializeLike> like = (id<SocializeLike>)object;
        self.like = like;
        NSLog(@"Created like for entity %@", like.entity.name);
        // do your magic here
    }
}
    

// end-like-entity-snippet

@end

@implementation SampleAPIClient (UnlikeEntity)

// begin-unlike-entity-snippet

- (void)unlikeEntity {
    // like is the id<SocializeLike> object which was returned as a result of liking the entity.
    
    [self.socialize unlikeEntity:self.like];
}

// if the operation fails the following method is called
- (void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"%@", error);
}

//if the delete is successful
- (void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
    NSLog(@"entity unlike succeeded");
}

// end-unlike-entity-snippet

@end

@implementation SampleAPIClient (GetLikesForUser)

// begin-get-likes-for-user-snippet

- (void)getSomeLikes {
    id<SocializeEntity> entity = [SocializeEntity entityWithKey:@"mykey" name:@"My Like"];
    [self.socialize getLikesForUser:[self.socialize authenticatedUser] entity:entity first:nil last:[NSNumber numberWithInteger:1]];
}

- (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
    id<SocializeLike> like = [dataArray objectAtIndex:0];
    NSLog(@"Now at %d likes", like.entity.likes);
}

// end-get-likes-for-user-snippet

@end


@implementation SampleAPIClient (CreateComment)

// begin-create-comment-snippet

- (void)createComment {
    // longitude and latitude are optional
    [self.socialize createCommentForEntityWithKey:@"www.yourentityurl.com" comment:@"comment over here" longitude:nil latitude:nil];
}

#pragma mark SocializeServiceDelegate implementation

// if the operation fails the following method is called
- (void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"%@", error);
}

//if the comment was created successfully
- (void)service:(SocializeService*)service didCreate:(id)object{
    if ([object isKindOfClass:[SocializeComment class]]) {
        id<SocializeComment> comment = (id<SocializeComment>)object;
        NSLog(@"Created comment for entity %@", comment.entity.name);
        // a comment represented by id<SocializeComment> has been created, so have at it
        // do your magic here
    }
}

// end-create-comment-snippet

@end

@implementation SampleAPIClient (GetComments)

// begin-get-comments-snippet

- (void)getComments {
    /*Note
     Each request is limited to 100 items.
     If first = 0, last = 50, the API returns comments 0-49.
     If last - first > 100, then last is truncated to equal first + 100. For example, if first = 100, last = 250, then last is changed to last = 200.
     If only last = 150 is passed, then last is truncated to 100. If last = 25, then results 0...24 are returned.
     */

    [self.socialize getCommentList:@"entity_key" first:nil last:nil];
}

/*
 Implementing the delegate methods
 getting/retrieving comments would invoke this callback and it would have elements of type id<SocializeComment>
 */
-(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{
    // the array will contain elements of type id<SocializeComment> from where further info could be retrieved
}

//in case of error
-(void)service:(SocializeService*)service didFail:(NSError*)error{
}

// end-get-comments-snippet

@end

@implementation SampleAPIClient (CreateShare)

// begin-create-share-snippet

- (void)createShare {
    [self.socialize createShareForEntityWithKey:@"http://www.url.com" medium:SocializeShareMediumFacebook text:@"Check this out!"];
}

//if the create is successful
-(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object{
    if ([object isKindOfClass:[SocializeShare class]]) {
        NSLog(@"create share succeeded");
    }
}

// if the operation fails the following method is called
-(void)service:(SocializeService*)service didFail:(NSError*)error{
    NSLog(@"Create share failed: %@", [error localizedDescription]);
}

// end-create-share-snippet

@end

