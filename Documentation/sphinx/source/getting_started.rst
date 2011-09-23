=====================
Getting Started Guide
=====================

.. contents:: Table of contents

Minimum Requirements
--------------------

iOS 4 is minimum supported version by this SDK. 

Installing the SDK
------------------

- Install the embedded static framework to your application. To do this just drag and drop Socialize-IOS.embeddedframework from project root (i.e. socialize-sdk-ios folder) to your framework section.

- Add CoreGraphics.framework to your application target.
- Add CoreLocation.framework to your application target.
- Add MapKit.framework to your application target.
- Add QuartzCore.framework to your application target.

*Additional Configuration*

- First of all, you should be sure that Socialize-iOS.framework and resources from the Resources folder were added as the dependence to the correct target.
- Add **-ObjC** and **-all_load** flag to the Other Linker Flags in the build settings of your application target. *Please use the flag exactly as it is—the most common mistake here tends to be misspelling or incorrect capitalization.*

	.. image:: images/image00.png
   			:width: 700
   			:height: 550


Building the SDK
----------------
In the case you might need some changes done to the framework, after which you can build the framework using terminal command: "make build". The output of this command’s execution will be the embedded static framework. And to build the sample app use "build sample" command.

To get a successful build you have to change the provision credentials in the make file to your own.

* build sample application
	xcodebuild -target SampleSdkApp -configuration Distribution -sdk iphoneos PROVISIONING_PROFILE="User provision profile" CODE_SIGN_IDENTITY="iPhone Distribution: user identity" build*
	
If you don’t have a valid Apple provision, change the SDK type to the simulator. 
*xcodebuild -target SampleSdkApp -configuration Debug -sdk iphonesimulator build*

Next Steps...
-------------
Once Socialize is installed, you have two options:

If you want the quickest way to integrate Socialize in your app:

Go to --> :doc:`socialize_ui` 

If you want full control over how your social interaction works:

Go to --> :doc:`sdk_user_guide` 
