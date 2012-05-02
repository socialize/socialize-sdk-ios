.. include:: feedback_widget.rst

=========================================
Socialize Like Button
=========================================

Introduction
------------

In v1.7 of the Socialize SDK for iOS is a new stand-alone Like Button. This
is simply the “like” capablity of Socialize contained in a self-standing UI
element which can be easily customized to suit your app.

Displaying the Like Button
-------------------------

The Like Button is itself a view. To use the Like Button, simply instantiate it and
add it to your view hierarchy.

.. code-block:: objective-c

  - (void)viewDidLoad
  {
      [super viewDidLoad];
      // Do any additional setup after loading the view from its nib.
      
      SocializeLikeButton *likeButton = [[SocializeLikeButton alloc] initWithFrame:CGRectMake(120, 30, 0, 0) entity:self.entity viewController:self];

      // Turn of automatic sizing of the like button (default NO)
  // likeButton.autoresizeDisabled = YES;
      
      // Hide the count display
  // likeButton.hideCount = YES;

      [self.view addSubview:likeButton];
  }

Customizing the Like Button
-------------------------
All of the images on the like button can be changed. To do this, just set the appropriate property.
The full list of image properties is:

.. code-block:: objective-c

  @interface SocializeLikeButton : UIView <SocializeServiceDelegate>

  ...
  @property (nonatomic, retain) UIImage *disabledImage;

  @property (nonatomic, retain) UIImage *inactiveImage;
  @property (nonatomic, retain) UIImage *inactiveHighlightedImage;

  @property (nonatomic, retain) UIImage *activeImage;
  @property (nonatomic, retain) UIImage *activeHighlightedImage;

  @property (nonatomic, retain) UIImage *likedIcon;
  @property (nonatomic, retain) UIImage *unlikedIcon;

  @end

Responding to State Changes
-------------------------
You may find you would like to be notified when the like button changes state. You can accomplish
this by listening for the SocializeLikeButtonDidChangeStateNotification as follows:

.. code-block:: objective-c

  - (id)init {
  ...
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeButtonChanged:) name:SocializeLikeButtonDidChangeStateNotification object:nil];
  ...
  }

  - (void)likeButtonChanged:(NSNotification*)notification {
      // Update your views here
  }



Refreshing the Like Button
--------------------------
The Like Button has an explicit refresh call.

.. code-block:: objective-c

  - (void)someMethod {
      [likeButton refresh];
  }


Changing the Like Button's Entity
--------------------------
The Like Button's current entity can be changed by setting the entity property.

.. code-block:: objective-c

  - (void)someMethod {
      id<SocializeEntity> newEntity = [SocializeEntity entityWithKey:@"newEntity" name:@"New Entity"];
      likeButton.entity = newEntity;
  }


.. note:: An explicit refresh is not required when changing the entity

