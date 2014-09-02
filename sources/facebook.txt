====================
Facebook Integration
====================

Introduction
------------

It is strongly recommended that users be able to authenticate with Facebook when using Socialize so as to 
maximize the exposure and promotion of your app.

This provides significant benefits to both your application and your users including:

  1. Improved user experience through personalized comments
  2. Automatic profile creation (user name and profile picture)
  3. Ability to automatically post user comments and likes to Facebook
  4. Promotes your app on Facebook by associating your app with comments

To add Facebook authentication, you'll need a Facebook App ID.  If you already have a Facebook app, 
you can skip this section.

Setting up Facebook
-------------------

Creating a Facebook Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

     1. First create a Facebook app.  Go to https://developers.facebook.com/apps and create a new app:
 
         .. image:: images/fb0.png

         .. image:: images/fb1.png
 
     2. Your newly created Facebook app will have an ID, which is the ID used in Socialize and can be found on your Facebook Developer page:
 
         For example, this is the Facebook App page for Socialize:
 
         .. image:: images/fb2.png
 
     3. Add the iOS "platform":
 
         .. image:: images/fb3.png

         .. image:: images/fb4.png

     4. Enable SSO (single sign-on) and disable deep linking:

         .. image:: images/fb5.png

         .. note:: Ensure **iOS Native Deep Linking is DISABLED** otherwise Facebook will bypass the Socialize SmartDownload process.

     5. Since "publish_actions" permission is required for Socialize to function correctly as of Facebook SDK 3.17.0 (which uses Facebook API v2.1), it is now **required** to complete the `app review process on Facebook <https://developers.facebook.com/docs/apps/review#submit>`_.

Configuring Facebook in Socialize
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Let Socialize know your Facebook App ID, as shown above.

.. literalinclude:: snippets/facebook.m
  :start-after: begin-configure-snippet
  :end-before: end-configure-snippet
  :emphasize-lines: 9

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

.. literalinclude:: snippets/facebook.m
  :start-after: begin-openurl-snippet
  :end-before: end-openurl-snippet
  :emphasize-lines: 4

.. note:: Standard Facebook configuration complete. Keep reading for special configuration

Handling Missing Permissions
----------------------------
When an app requests permissions, people may completely deny those permissions, not fully grant those permissions, or change them later. In order to provide a great experience, apps should be built to handle these situations.


To be more familiar with new FB API please read:

`Facebook missed permissions <https://developers.facebook.com/docs/facebook-login/permissions/v2.1#handling>`_

`Facebook login process <https://developers.facebook.com/docs/facebook-login/ios/v2.1#permissions-review>`_

Refer for example to  `Share section <sharing.html#custom-share-dialog-behavior>`_ for more details how to handle missing permissions error situation take a look at **didFailPostingToSocialNetworkBlock** callback.

Linking with Existing Facebook Credentials
------------------------------------------

If your app already authenticates with Facebook, you can let Socialize
know about the existing session. You can do this with the
**linkToFacebookWithAccessToken:expirationDate:** call.  For more information on
using FBConnect on your own, you can check the official Facebook tutorial at
`Facebook iOS SDK
<http://developers.facebook.com/docs/reference/iossdk/authentication/>`_.

.. literalinclude:: snippets/facebook.m
  :start-after: begin-link-snippet
  :end-before: end-link-snippet

.. note:: The "public_profile" and "publish_actions" permissions are required for Socialize to function correctly. For maximum
  compatibility you should merge your apps required permissions with the 'requiredPermissions' class method of SZFacebookUtils

Posting to Facebook on your own
------------------------------------------

Should you need to post to Facebook on your own, you can do so by using the
direct Facebook access methods on the utils classes

.. literalinclude:: snippets/facebook.m
  :start-after: begin-post-to-feed-snippet
  :end-before: end-post-to-feed-snippet

See http://developers.facebook.com/docs/reference/api/post/ for more info

Posting Images to Facebook
------------------------------------------

You can also post an image.

.. literalinclude:: snippets/facebook.m
  :start-after: begin-post-image-snippet
  :end-before: end-post-image-snippet

See http://developers.facebook.com/docs/reference/api/photo/ for more info