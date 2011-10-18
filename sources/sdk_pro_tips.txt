.. include:: feedback_widget.rst

===============================
SDK Pro Tips
===============================

Building the SDK from source
--------------------------------
In the case you might need some changes done to the framework, after which you can build the framework using terminal command: "make build". The output of this command’s execution will be the embedded static framework. And to build the sample app use "build sample" command.

To get a successful build you have to change the provision credentials in the make file to your own which you can get from `Apple's Developer Portal <http://developer.apple.com/devcenter/ios/index.action>`_

* change the following properties to build sample application
	xcodebuild -target SampleSdkApp -configuration Distribution -sdk iphoneos PROVISIONING_PROFILE="User provision profile" CODE_SIGN_IDENTITY="iPhone Distribution: user identity" build*
	
If you don’t have a valid Apple provision, change the SDK type to the simulator. 
*xcodebuild -target SampleSdkApp -configuration Debug -sdk iphonesimulator build*
 
