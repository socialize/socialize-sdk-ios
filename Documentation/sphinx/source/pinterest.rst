=========
Pinterest
=========

Installation
------------

To avoid duplication issues the Socialize SDK doesn't include Pinterest SDK by default. To use the Pinterest sharing feature make sure to add Pinterest.embeddedframework in your project and link to appropriate target.

Installation with CocoaPods (3.0.1)
-----------------------------------

**The Pinterest SDK is not yet included as a dependent CocoaPod for the Socialize SDK.** 

To use the version of Pinterest SDK that is compatible with Socialize, `download the framework here <https://s3.amazonaws.com/socialize-sdk-distribution/Pinterest.embeddedframework.zip>`_ and install it by uncompressing and dragging it to the framework section of your project. If you already have the Pinterest SDK installed from a recent Socialize SDK version (2.8.8 or newer) you do not need to install it again.

Non-CocoaPods Installation
--------------------------

The Pinterest.embeddedframework can be found in the Socialize SDK distribution archive. Simply drag it to the framework section of your project.

Let Socialize know your Pinterest app id.  You can register or find your
Pinterest app id here: http://developers.pinterest.com/manage/

Configuring Pinterest in Socialize (SDK)
----------------------------------------

Once you have a pinterest application, simply tell Socialize about your application id:

.. literalinclude:: snippets/pinterest-snippets.m
  :start-after: begin-configure-snippet
  :end-before: end-configure-snippet
  :emphasize-lines: 9

Note that the Pinterest app must be installed on a device for Pinterest sharing to display in the Share dialog. This functionality works on devices only, not in Simulator.

Posting to Pinterest on your own
---------------------------------

Should you need to post to Pinterest on your own, you can do so by using the
direct Pintrest access methods on the utils classes.

.. literalinclude:: snippets/pinterest-snippets.m
  :start-after: begin-share-snippet
  :end-before: end-share-snippet
