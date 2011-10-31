.. include:: feedback_widget.rst

=====================
Getting Started Guide
=====================

.. contents:: Table of contents

Minimum Requirements
--------------------

iOS 4 is minimum supported version by this SDK. 

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


Next Steps...
-------------
Once Socialize is installed, you'll want to start adding some user interaction. 

The quickest way to integrate Socialize in your app is by using the packaged UI views.  Get started with the :doc:`socialize_ui` 
