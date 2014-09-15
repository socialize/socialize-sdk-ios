=========
Pinterest
=========

Installation
------------

As of release 3.0.2, Pinterest is included with the Socialize SDK by default if installing with CocoaPods.

Installation with CocoaPods (3.0.2 and later)
---------------------------------------------

To install Pinterest with CocoaPods, simply add the following to your Podfile:

::

            pod 'Pinterest-iOS', '~> 2.3'


The Pinterest SDK will install automatically during a CocoaPods install or update. **There is no need to add the Pinterest SDK manually. If you already have the Pinterest.embeddedframework installed from an older version and are now using CocoaPods to install Socialize, please delete the Pinterest.embeddedframework from your Xcode Workspace and from your file system.**

Non-CocoaPods Installation
--------------------------

The Pinterest.embeddedframework can be found in the Socialize SDK distribution archive. Simply drag it to the framework section of your project.

Configuring Pinterest in Socialize (SDK)
----------------------------------------

Let Socialize know your Pinterest app id.  You can register or find your Pinterest app id here: http://developers.pinterest.com/manage/

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
