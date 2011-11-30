.. include:: feedback_widget.rst

=========================================
Implementing the UI 
=========================================

Introduction
------------
As of v0.4.0 of the Socialize SDK we are providing pre-built UI views that can 
quickly and easily be dropped in to your app, saving you the time of building 
these views yourself!

Adding Facebook Support
-------------------------
To add Facebook support in Socialize, you'll need to perform three steps:

Let Socialize know your Facebook app id.  You can register or find your Facebook app id here: https://developers.facebook.com/apps

.. raw:: html

        <script src="https://gist.github.com/1375443.js?file=gistfile1.m"></script>

You must register your app to open with your facebook app id url by adding a URL Types array to your Application's <MyApp>-Info.plist.
The string is a lowercase fb followed by your app id. The example app is configured as below:

.. image:: images/facebook_urltypes.png	

You must also be sure to call [Socialize handleOpenURL:url] from your UIApplicationDelegate's application:handleOpenURL: method. Socialize will take care of handing off the openURL request to the underlying `Facebook iOS SDK <http://developers.facebook.com/docs/reference/iossdk/authentication/>`_. This completes the authentication flow.

.. raw:: html

        <script src="https://gist.github.com/1375464.js?file=appDelegate.m"></script>
 
Comment View
----------------------
v0.4.0 of the Socialize SDK introduced the "Comment View" which provides the creation and viewing 
of comments associated with an entity (URL).  

.. image:: images/comment_list.png	
.. image:: images/new_comment.png	
.. image:: images/comment_detail.png	

Displaying the Comment View
~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you want to launch the comment view, simply instantiate and present the commentViewController :

.. raw:: html

        <script src="https://gist.github.com/1293791.js"> </script>
