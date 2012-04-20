.. include:: feedback_widget.rst

=========================================
Socialize Like Button
=========================================

Introduction
------------

In v1.4 of the Socialize SDK for Android is a new stand-alone Like Button. This
is simply the “like” capablity of Socialize contained in a self-standing UI
element which can be easily customized to suit your app.

Displaying the Like Button
-------------------------

The Like Button is itself a view. To use the Like Button, simply instantiate it and
add it to your view hierarchy.

.. raw:: html

        <script src="https://gist.github.com/2432048.js?file=showLikeButton.m"></script>

Customizing the Like Button
-------------------------
All of the images on the like button can be changed. To do this, just set the appropriate property.
The full list of image properties is:

.. raw:: html

  <script src="https://gist.github.com/2432048.js?file=likeButtonCustomizableImageProperties.m"></script>

Responding to State Changes
-------------------------
You may find you would like to be notified when the like button changes state. You can accomplish
this by listening for the SocializeLikeButtonDidChangeStateNotification as follows:

.. raw:: html

  <script src="https://gist.github.com/2432048.js?file=likeButtonStateChangeNotification.m"></script>

Refreshing the Like Button
--------------------------
The Like Button has an explicit refresh call.

.. raw:: html

  <script src="https://gist.github.com/2432048.js?file=refreshLikeButton.m"></script>

Changing the Like Button's Entity
--------------------------
The Like Button's current can be changed.

.. raw:: html

  <script src="https://gist.github.com/2432048.js?file=changeEntity.m"></script>

.. note:: An explicit refresh is not required when changing the entity

