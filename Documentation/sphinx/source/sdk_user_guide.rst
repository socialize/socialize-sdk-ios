.. include:: feedback_widget.rst

=============================================
SDK User Guide
=============================================

Introduction
------------
The Socialize SDK provides a simple set of classes and methods built upon the `Socialize REST API <http://www.getsocialize.com/docs/v1/>`_

App developers can elect to use either the pre-defined user interface controls provided in the Socialize UI 
framework, or "roll their own" using direct SDK calls.

ALL calls to the Socialize SDK are *asynchronous*, meaning that your application will not "block" while 
waiting for a response from the Socialize server.

You are notified of the outcome of calls to the Socialize service via a *SocializeServiceDelegate* 
passed into each call to the Socialize SDK.

The main class through which you will be interacting would be Socialize. You can authenticate, comment, like/unlike via Socialize instance and are detailed in the following section.

Initializing Socialize
----------------------

To start using the SDK. You need to create and initialize Socialize class and implement the SocializeServiceDelegate.

.. code-block:: objective-c

  // Allocate
  Socialize* socialize = [[Socialize alloc] initWithDelegate:self];


  // We need the implement the delegate methods, none of which are required, they are all optional

  #pragma mark SocializeServiceDelegate

  // this method is optional
  -(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{

  }

  // this method is optional
  -(void)service:(SocializeService*)service didUpdate:(id<SocializeObject>)object{

  }

  // this method is optional
  -(void)service:(SocializeService*)service didFail:(NSError*)error{

  }

  // this method is optional
  -(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{

  }

  // this method is optional
  -(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray{

  }

  // this method is optional
  -(void)didAuthenticate{

  }

  #pragma mark -


Authentication
--------------
Every call against the Socialize SDK MUST be authenticated.  

On the first successful call to "authenticate" the credentials are automatically cached in the 
application so subsequent calls are much faster.

Authenticating with Facebook
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
We recommend authenticating with 3rd parties (e.g. Facebook) as this provides a better user experience 
and ensures that user profiles and IDs are retained across app sessions and installs.  

There are 2 variants to achieve the same result. If you already have authenticated with facebook then you can pass the facebook access token to SocializeSDK or you can have the SocializeSDK perform facebook authentication for you.


.. code-block:: objective-c

  / invoke the call if you would like the SDK to receive a third party access token
  [socialize authenticateWithApiKey:@"Authenticating" apiSecret:@"ApiSecret" thirdPartyAppId:@"AppId" thirdPartyName:SocializeThirdPartyAuthTypeFacebook];

  // invoke the call if you already have the third party access token
  [socialize authenticateWithApiKey:@"ApiKey" apiSecret:@"ApiSecret" thirdPartyAuthToken: @"ThirdPartyToken" thirdPartyAppId:@"AppId" thirdPartyName:SocializeThirdPartyAuthTypeFacebook];

Authenticating with Twitter
~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Coming Soon!*
	
Anonymous Authentication
~~~~~~~~~~~~~~~~~~~~~~~~
We recommend authenticating with 3rd parties (e.g. Facebook) as this provides a better user experience 
and ensures that user profiles and IDs are retained across app sessions and installs, however if you just 
want anonymous authentication, simply call the **authenticate** method:

.. code-block:: objective-c

  #import <Socialize-iOS/Socialize.h>

  // invoke the call
  [socialize authenticateWithApiKey:@"YourApiKey" apiSecret:@"YourApiSecret"];

  #pragma mark SocializeServiceDelegate implementation
  // implement the delegate
  -(void)didAuthenticate:(id<SocializeUser>)user {
       NSLog(@"Authenticated");
  }

  // if the authentication fails the following method is called
  -(void)service:(SocializeService*)service didFail:(NSError*)error{
      NSLog(@"%@", error);
  }

Entities
--------
An entity is a single item of content in your app

Throughout the documentation and the code snippets we refer to an "entity".  This is simply a 
generic term for something that can be view, shared, liked or commented on.  Generally this will
correspond to a single item of content in your app.

Entity keys in Socialize are free form.  It is recommended that a *real* URL be
used (i.e. one that corresponds to an active web page)

Creating an Entity
~~~~~~~~~~~~~~~~~~
An entity consists of a **key** and a **name**.  The name should be descriptive and help you identify the 
entity when viewing reports on the Socialize dashboard.

Creating an entity explicitly in this manner is **optional but recommended**.
If you simply post a comment,view,share or like against an entity key that does
not currently exist, it will be automatically created for you, but will not
have a *name* associated with it.

To create an entity, simply invoke the **createEntity** message:

.. code-block:: objective-c

  [socialize createEntityWithKey:entityKey name:name]

  #pragma mark SocializeServiceDelegate

  // if the operation fails the following method is called
  -(void)service:(SocializeService*)service didFail:(NSError*)error{
      NSLog(@"%@", error);
  }

  //if the delete is successful
  -(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
      NSLog(@"entity created");
  }


Entity Meta Data, and Other Advanced Functionality
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Should you find that you need to store custom metadata on an entity, Socialize
will provide for this. Full customization of entity objects can be realized
through use of the createEntity: variant for creating your entity.

.. code-block:: objective-c

  SocializeEntity *entity = [[[SocializeEntity alloc] init] autorelease];
  entity.key = @"myKey";
  entity.name = @"My Name";
  entity.meta = @"some meta data about this entity";

  [socialize createEntity:entity];

  -(void)service:(SocializeService*)service didFail:(NSError*)error{
      NSLog(@"%@", error);
  }

  //if the delete is successful
  -(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
      NSLog(@"entity created");
  }

Retrieving Entity data
~~~~~~~~~~~~~~~~~~~~~~
An existing entity can be retrieved via the **getEntity** method.  Entities obtained in this way will also 
provide aggregate data on comments, likes, shares and views.  Refer to the `Entity object structure in the API Docs <http://www.getsocialize.com/docs/v1/#entity-object>`_.
for more detail on these aggregate values.

.. code-block:: objective-c

  [socialize getEntityByKey:@"www.techcrunch.com"];


  #pragma mark SocializeServiceDelegate

  //if the entity does not exist
  -(void)service:(SocializeService*)service didFail:(NSError*)error{

  }

  // if the entity is found, we can access it at the first index of the array.
  // The size will always be one when we are trying to get information about an entity.
  -(void)service:(SocializeService*)service didFetchElements:(NSArray*)dataArray {
      if ([dataArray count]){
          id<SocializeObject> object = [dataArray objectAtIndex:0];
          if ([object conformsToProtocol:@protocol(SocializeEntity)]){
              // do entity saving here.
              // All the entity related information can be fetched here ie stats or name.
          }
      }
  }

View
----
A 'view' is simply an event that records when a user views an entity.  Views are reported on the Socialize 
dashboard and provide an excellent way for you to determine which content items in your app are getting the 
most interest.

Creating a 'View'
~~~~~~~~~~~~~~~~~
To create a view, simply call the **viewEntity** method:

.. code-block:: objective-c

  // Allocate memory for the instance
  Socialize* socialize = [[Socialize alloc] initWithDelegate:self];

  // invoke the call (the latitude and the longitude can be nil)
  [socialize viewEntity:entity longitude:nil latitude:nil];

  // creating a view would invoke this callback and it would have an element of type id<SocializeView>
  -(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
      if ([object conformsToProtocol:@protocol(SocializeView)]){
          // do your magic/logic here
      }
  }

  //in case of error
  -(void)service:(SocializeService*)service didFail:(NSError*)error{

  }


Like
----
A 'like' represents a user's vote for an entity.  Likes are a way for you to determine which content items 
in your app are the most popular, and what is of most interest to your users.

Creating a 'Like'
~~~~~~~~~~~~~~~~~
To create a like, simply call the **like** method:

.. code-block:: objective-c

  // Allocate memory for the instance
  Socialize* socialize = [[Socialize alloc] initWithDelegate:self];

  // invoke the call (the latitude and the longitude can be nil)
  [socialize likeEntityWithKey:@"www.url.com" longitude:[NSNumber numberWithFloat:-37.256] latitude:[NSNumber numberWithFloat:122.452314]
  ];

  #pragma mark SocializeServiceDelegate

  //if the like fails this is called
  -(void)service:(SocializeService*)service didFail:(NSError*)error{

  }

  // if the like is created this is called
  -(void)service:(SocializeService*)service didCreate:(<id>SocializeObject)object{
          //_like is object level instance of type <SocializeLike>
          if ( [object conformsToProtocol:@protocol(SocializeLike)]){
             //_like = (id<SocializeLike>)object;
             // do your magic here
          }
  }
	
Removing a 'Like'
~~~~~~~~~~~~~~~~~
Removing a like (i.e. an 'unlike') is done via the **unlike** method.  In order to remove a like, you will 
need the ID of the like.  This is returned from the initial call to **like**

.. code-block:: objective-c

  // Allocate memory for the instance
  Socialize* socialize = [[Socialize alloc] initWithDelegate:self];

  //like is the id<SocializeLike> object which was returned as a result of liking the entity.
  [socialize unlikeEntity:like];

  // if the operation fails the following method is called
  -(void)service:(SocializeService*)service didFail:(NSError*)error{
      NSLog(@"%@", error);
  }

  //if the delete is successful
  -(void)service:(SocializeService*)service didDelete:(id<SocializeObject>)object{
      NSLog(@"entity unlike succeeded");
  }

Get likes for a user
---------------------

You can get all likes for a specific user using [Socialize
getLikesForUser:entity:first:last:]. If entity is non-nil, returned likes will
be limited to just that entity.

.. code-block:: objective-c

  - (void)getSomeLikes {
      id<SocializeEntity> entity = [SocializeEntity entityWithKey:@"mykey" name:@"My Like"];
      [self.socialize getLikesForUser:[self.socialize authenticatedUser] entity:entity first:nil last:[NSNumber numberWithInteger:1]];
  }

  - (void)service:(SocializeService *)service didFetchElements:(NSArray *)dataArray {
      id<SocializeLike> like = [dataArray objectAtIndex:0];
      NSLog(@"Now at %d likes", like.entity.likes);
  }

Comment
-------
Comments are a great way to build engagement in your app, and users love making comments!

Creating a Comment
~~~~~~~~~~~~~~~~~~
To create a comment on an entity, use the **createCommentForEntityWithKey:::** method:

.. code-block:: objective-c

  // longitude and latitude are optional
  [socialize createCommentForEntityWithKey:@"www.yourentityurl.com" comment:@"comment over here" longitude:nil latitude:nil];


  #pragma mark SocializeServiceDelegate implementation

  // if the operation fails the following method is called
  -(void)service:(SocializeService*)service didFail:(NSError*)error{
      NSLog(@"%@", error);
  }

  //if the comment was created successfully
  -(void)service:(SocializeService*)service didCreate:(id<SocializeObject>)object{
      if ([object conformsToProtocol:@protocol(SocializeComment)]){
           id<SocializeComment> comment = (id<SocializeComment>)object;
           // a comment represented by id<SocializeComment> has been created, so have at it
           // do your magic here
      }
  }

Listing Comments
~~~~~~~~~~~~~~~~
To list all comments for an entity use the **getCommentList** method. 

.. code-block:: objective-c

  // Allocate memory for the instance
  Socialize* socialize = [[Socialize alloc] initWithDelegate:self];

  /*Note
  Each request is limited to 100 items.
  If first = 0, last = 50, the API returns comments 0-49.
  If last - first > 100, then last is truncated to equal first + 100. For example, if first = 100, last = 250, then last is changed to last = 200.
  If only last = 150 is passed, then last is truncated to 100. If last = 25, then results 0...24 are returned.
  */

  [socialize getCommentList:@"urloftheentity" first:nil last:nil];

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



Share
-----
To register a share with the Socialize servers, use the **createShareForEntityWithKey:medium:text:** method.

.. code-block:: objective-c

  // Allocate memory for the instance
  Socialize* socialize = [[Socialize alloc] initWithDelegate:self];

  [self.socialize createShareForEntityWithKey:@"http://www.url.com" medium:SocializeShareMediumFacebook text:@"Check this out!"];

  // if the operation fails the following method is called
  -(void)service:(SocializeService*)service didFail:(NSError*)error{
      NSLog(@"%@", error);
  }

  //if the delete is successful
  -(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object{
      if ([object conformsToProtocol:@protocol(SocializeShare)]) {
          NSLog(@"create share succeeded");
      }
  }
