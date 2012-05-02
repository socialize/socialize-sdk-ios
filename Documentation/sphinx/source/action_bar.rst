.. include:: feedback_widget.rst

=========================================
Socialize Action Bar
=========================================

Introduction
------------

v0.5.0 of the Socialize SDK introduced the "Action Bar" which provides a single
entry point into the entire set of Socialize features.

Displaying the Action Bar
-------------------------

Using the SocializeActionBar is very simple. Instantiate a SocializeActionBar controller and add the view to your view controller:

.. code-block:: objective-c

  // Header

  #import <Socialize/Socialize.h>

  @interface Controller : UIViewController
  @property (nonatomic, retain) SocializeActionBar *actionBar;
  @end

.. code-block:: objective-c

  // Implementation

  - (void)viewDidLoad
  {
      [super viewDidLoad];

      self.actionBar = [SocializeActionBar actionBarWithKey:@"http://www.example.com/object/1234" presentModalInController:self];
      [self.view addSubview:self.actionBar.view];
  }

By default, the Action Bar will automatically place itself at the bottom of its
superview and adjust to rotation.  If you find that content is being hidden,
one option is to ensure that 44 pixels are left empty at the bottom of your
view. When using interface builder, this is as simple as sliding up the bottom
of any content.

Advanced Layout Configuration
-----------------------------

*Optional Configuration with no Automatic Layout*

If you  find you have problems with the Action Bar Automatic Layout, and you
would like to disable the auto layout feature completely, you can do so. The
following example disables autolayout and manually places the Action Bar at
(0,400).

.. code-block:: objective-c

  - (void)viewDidLoad
  {
      [super viewDidLoad];

      self.actionBar = [SocializeActionBar actionBarWithKey:@"http://www.example.com/object/1234" presentModalInController:self];
      self.actionBar.noAutoLayout = YES;
      self.actionBar.view.frame = CGRectMake(0, 400, 320, SOCIALIZE_ACTION_PANE_HEIGHT)
      [self.view addSubview:self.actionBar.view];
  }

If you need more detail on installing the action bar please see our `Adding the Socialize Action Bar Video`_.

    .. _Adding the Socialize Action Bar Video: http://vimeo.com/31403049

Delegate
--------

Defining a SocializeActionBarDelegate will allow you to customize some behavior of the
action bar.

Showing Action Sheets
~~~~~~~~~~~~~~~~~~~~~

If you wish, you can customize the way the Action Bar shows action sheets. To do this,
just implement actionBar:wantsDisplayActionSheet:, as below

.. code-block:: objective-c

  // Header

  //import the socialize header
  #import <Socialize/Socialize.h>

  @interface Controller : UIViewController <SocializeActionBarDelegate>
  @property (nonatomic, retain) SocializeActionBar *actionBar;
  @end

.. code-block:: objective-c

  // Implementation

  - (void)viewDidLoad
  {
      [super viewDidLoad];

      self.actionBar = [SocializeActionBar actionBarWithKey:@"http://www.example.com/object/1234" presentModalInController:self];
      self.actionBar.delegate = self
      [self.view addSubview:self.actionBar.view];
  }

  - (void)actionBar:(SocializeActionBar*)actionBar wantsDisplayActionSheet:(UIActionSheet*)actionSheet {
      [actionSheet showFromRect:CGRectMake(50, 50, 50, 50) inView:self.view animated:YES];
  }

More Info
-----------------------

If you need more detail on installing the action bar please see our `Adding the Socialize Action Bar Video`_.

    .. _Adding the Socialize Action Bar Video: http://vimeo.com/31403049


