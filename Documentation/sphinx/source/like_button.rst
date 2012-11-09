.. include:: feedback_widget.rst

=========================================
Socialize Like Button
=========================================

Introduction
------------

In v1.7 of the Socialize SDK for iOS is a new stand-alone Like Button. This
is simply the “like” capablity of Socialize contained in a self-standing UI
element which can be easily customized to suit your app.

.. image:: images/like_button_unliked.png	
.. image:: images/like_button_liked.png	

Displaying the Like Button
-------------------------

The Like Button is itself a view. To use the Like Button, simply instantiate it and
add it to your view hierarchy.

.. literalinclude:: snippets/create_like_button.h

.. literalinclude:: snippets/create_like_button.m
  :start-after: begin-snippet
  :end-before: end-snippet

Customizing the Like Button
-------------------------
All of the images on the like button can be changed. To do this, just set the appropriate property.
The full list of image properties is:

.. literalinclude:: Socialize/SZLikeButton.h
  :start-after: begin-image-properties
  :end-before: end-image-properties

Responding to State Changes
-------------------------
You may find you would like to be notified when the like button changes state. You can accomplish
this by listening for the SocializeLikeButtonDidChangeStateNotification as follows:

.. literalinclude:: snippets/create_like_button.m
  :start-after: begin-notification-snippet
  :end-before: end-notification-snippet

Refreshing the Like Button
--------------------------
The Like Button has an explicit refresh call.

.. literalinclude:: snippets/create_like_button.m
  :start-after: begin-refresh-snippet
  :end-before: end-refresh-snippet

Changing the Like Button's Entity
--------------------------
The Like Button's current entity can be changed by setting the entity property.

.. literalinclude:: snippets/create_like_button.m
  :start-after: begin-entity-snippet
  :end-before: end-entity-snippet

.. note:: An explicit refresh is not required when changing the entity

