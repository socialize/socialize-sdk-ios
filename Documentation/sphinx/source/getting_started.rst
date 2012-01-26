.. include:: feedback_widget.rst

=====================
Getting Started Guide
=====================

.. contents:: Table of contents
 

Introduction
------------
The Socialize SDK provides a simple set of classes and methods built upon the `Socialize REST API <http://www.getsocialize.com/docs/v1/>`_

App developers can elect to use either the pre-defined user interface controls provided in the Socialize UI 
framework, or "roll their own" using direct SDK calls.

All calls to the Socialize SDK are *asynchronous*, meaning that your application will not "block" while 
waiting for a response from the Socialize server.

You are notified of the outcome of calls to the Socialize service via a *SocializeServiceDelegate* 
passed into each call to the Socialize SDK.

The main class through which you will be interacting would be Socialize. 

.. note:: * iOS 4.0 is the minimum version supported by this SDK
 
Installing the SDK
------------------

Step 1: Add the Socialize Framework to Your Project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Download and unzip the lastest iOS SDK release from the website.**  
  You can find it here: http://www.getsocialize.com/sdk/
- **Install the embedded static framework to your application.**
  To do this just drag and drop Socialize.embeddedframework folder from the package to your framework section in your project. Note that this is a directory that includes both Socialize.framework and our bundled Resources.

 	.. image:: images/drag_and_drop.png

- When prompted, check "Copy items into destination group's folder (if needed)" and click finish

 	.. image:: images/check_copy_items.png
 

Step 2: Add Required Frameworks to Your Project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Add the following frameworks to your application target:

::

           CoreLocation.framework
           MapKit.framework
           MessageUI.framework
           QuartzCore.framework
           CoreGraphics.framework

.. image:: images/add_frameworks.png

Step 3: Set Project Linker Flags
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Add **-ObjC** and **-all_load** flag to the Other Linker Flags in the build settings of your application target. *Please use the flag exactly as it is—the most common mistake here tends to be misspelling or incorrect capitalization.*

	.. image:: images/image00.png
   			:width: 700
   			:height: 410


If you need more detail configuring the SDK in your app please see our `Getting Started Video`_.

    .. _Getting Started Video: http://vimeo.com/31403067

If you're having problems please let us know by clicking on the 'Feedback' tab on the right side of the page.   We're here to help.

You can also search or post on our `support forums`_

  .. _support forums: http://support.getsocialize.com

Step 4: Import Header and Set up your Socialize Keys
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To utilize the iOS SDK and views into your app, we need to import the Socialize.h header and let the library know your app key and secret.  Your application key and secret can be found 
at `http://www.getsocialize.com/apps <http://www.getsocialize.com/apps>`_.  Click your app and look for the 'oAuth Keys' module on the right-hand column.

.. note:: Make sure to import the Socialize header in the code snippet below

.. raw:: html

    <script src="https://gist.github.com/1678336.js?file=appDelegate.m"></script>

Step 5: Include Socialize in your App!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now that you have your environment all setup, it’s time to include Socialize.

The core component of the Socialize SDK is the “Action Bar”

.. image:: images/action_bar_solo.png	

This is a general purpose toolbar that sits at the bottom of your app and provides a central "one-stop-shop" of social features for your users.  Remember if you want to use 
components individually please go see the SDK user guide.

.. note:: Each Action Bar instance in your app is bound to an Entity. An Entity is simply an item of content in your app. Each Socialize action (comment, share, like etc.) is associated with an Entity.
An entity can be any item of content like a website, photo or person but MUST be given a unique key within your app.
It is not necessary to explicitly create an Entity object when rendering the Action bar as this will be done for you, however entities can be created manually.


Using the SocializeActionBar is very simple. Instantiate a SocializeActionBar controller and add the view to your view controller.  

In your View controller's header file place the following code:

.. raw:: html

        <script src="https://gist.github.com/1315113.js"> </script>

By default, the Action Bar will automatically place itself at the bottom of its
superview and adjust to rotation.  If you find that content is being hidden,
one option is to ensure that 44 pixels are left empty at the bottom of your
view. When using interface builder, this is as simple as sliding up the bottom
of any content.

If you need more detail on installing the action bar please see our `Adding the Socialize Action Bar Video`_.

    .. _Adding the Socialize Action Bar Video: http://vimeo.com/31403049


By now you should be able to see the Socialize Action Bar.  If you need any help please visit us at http://support.getsocialize.com

Optional: Configure Your App for Facebook
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is strongly recommended that users be able to authenticate with Facebook when using Socialize so as to maximize the exposure, and promotion of your app.

Let Socialize know your Facebook app id.  You can register or find your
Facebook app id here: https://developers.facebook.com/apps

You should also store your app's iTunes link. This will be included in
any Facebook wall posts sent from Socialize.

.. raw:: html

        <script src="https://gist.github.com/1375443.js?file=gistfile1.m"></script>

If your app already authenticates with Facebook and stores credentials to the
user defaults (as documented in the official Facebook tutorial at
https://developers.facebook.com/docs/mobile/ios/build/), then there is nothing
more you need to do. Socialize will automatically configure itself to use
existing Facebook authentication. 

If your app is not already configured for facebook authentication, then you'll
need to perform two more steps:

First, you must register your app to open with your facebook app id url by
adding a URL Types array to your Application's <MyApp>-Info.plist.  The string
is a lowercase fb followed by your app id. The example app is configured as
below:

.. image:: images/facebook_urltypes.png	

And lastly, you must be sure to call [Socialize handleOpenURL:url] from your
UIApplicationDelegate's application:openURL:sourceApplication: method. Socialize will take
care of handing off the openURL request to the underlying `Facebook iOS SDK
<http://developers.facebook.com/docs/reference/iossdk/authentication/>`_. This
completes the authentication flow.

.. raw:: html

        <script src="https://gist.github.com/1529163.js?file=appDelegate.m"></script>
 
Next Steps
-----------------------------------------------------------------------------------------
Run the app in your simulator or device, have fun with the action bar, add comments, likes and shares. Then you can visit the app dashboard on the Socialize website to see new user actions show up in the analytics charts.  You can also enable additional features like Push Notifications.


http://www.getsocialize.com/apps/
