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

ALL calls to the Socialize SDK are *asynchronous*, meaning that your application will not "block" while 
waiting for a response from the Socialize server.

You are notified of the outcome of calls to the Socialize service via a *SocializeServiceDelegate* 
passed into each call to the Socialize SDK.

The main class through which you will be interacting would be Socialize. You can authenticate, comment, like/unlike via Socialize instance and are detailed in the following section.

.. note:: * iOS 4.0 is the minimum version supported by this SDK
          * The UI views have not been optimized to work with the larger screens of the iPad
 
Installing the SDK
------------------
- Download and unzip the lastest iOS SDK release from the website.  You can find it here: http://www.getsocialize.com/sdk/
- Install the embedded static framework to your application. To do this just drag and drop Socialize.embeddedframework folder from the package to your framework section in your project. 
 	.. image:: images/drag_and_drop.png
 
- Add CoreGraphics.framework to your application target.
- Add CoreLocation.framework to your application target.
- Add MapKit.framework to your application target.
- Add QuartzCore.framework to your application target.
- Add MessageUI.framework to your application target.

*Additional Configuration*

- First of all, you should be sure that Socialize.framework and resources from the Resources folder were added as the dependence to the correct target.
- Add **-ObjC** and **-all_load** flag to the Other Linker Flags in the build settings of your application target. *Please use the flag exactly as it is—the most common mistake here tends to be misspelling or incorrect capitalization.*

	.. image:: images/image00.png
   			:width: 700
   			:height: 410


If you need more detail configuring the SDK in your app please see our `Getting Started Video`_.

    .. _Getting Started Video: http://vimeo.com/31403067

If you're having problems please let us know by clicking on the 'Feedback' tab on the right side of the page.   We're here to help.

Setting up your Socialize Keys
-------------------------------
To utilize the iOS SDK and views into your app we need to let the library know your app key and secret.  If you need to get a application key and secret you can get one at `http://www.getsocialize.com/apps <http://www.getsocialize.com/apps>`_ 

.. raw:: html

    <script src="https://gist.github.com/1274157.js?file=appDelegate.m"></script>

Adding the Socialize Action Bar
----------------------

v0.8.0 of the Socialize SDK introduced the "Action Bar", which allows your users to easily
comment, share and "like" entities

.. image:: images/action_bar_solo.png	

Using the SocializeActionBar is very simple. Instantiate a SocializeActionBar controller and add the view to your view controller:

.. raw:: html

        <script src="https://gist.github.com/1315113.js"> </script>

By default, the Action Bar will automatically place itself at the bottom of its
superview and adjust to rotation.  If you find that content is being hidden,
one option is to ensure that 44 pixels are left empty at the bottom of your
view. When using interface builder, this is as simple as sliding up the bottom
of any content.

If you still find you have problems, and you would like to disable the auto
layout feature completely, you can do so. The following example disables
autolayout and manually places the Action Bar at (0,400).

.. raw:: html

        <script src="https://gist.github.com/1374087.js"> </script>

If you need more detail on installing the action bar please see our `Adding the Socialize Action Bar Video`_.

    .. _Adding the Socialize Action Bar Video: http://vimeo.com/31403049


By now you should be able to see the Socialize Action Bar.  If you need any help please visit us at http://support.getsocialize.com
