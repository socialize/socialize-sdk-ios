.. include:: feedback_widget.rst

=========================================
Likes
=========================================

Like UI Elements
----------------

Like Button
~~~~~~~~~~~

A standalone like button is provided. See the `like button section <like_button.html>`_ for more info.

.. image:: images/like_button_unliked.png	
.. image:: images/like_button_liked.png	

Working with Likes
-------------------------------

Liking
~~~~~~~

To create a like programmatically you simply call the **like** method on **SZLikeUtils**

As with comments and shares, you can also manually specify how the like is to
be propagated to 3rd party networks such as Facebook and Twitter

.. literalinclude:: snippets/likes.m
	:start-after: begin-create-like-snippet
	:end-before: end-create-like-snippet

Unliking
~~~~~~~~~

You can also remove a previous like from an entity

.. literalinclude:: snippets/likes.m
	:start-after: begin-delete-like-snippet
	:end-before: end-delete-like-snippet

Retreiving Likes
~~~~~~~~~~~~~~~~

You can retrieve existing likes by User or Entity

List likes by User

.. literalinclude:: snippets/likes.m
	:start-after: begin-get-by-user-snippet
	:end-before: end-get-by-user-snippet
	
Get the like for a user on a given an entity, if it exists
	
.. literalinclude:: snippets/likes.m
	:start-after: begin-get-by-user-and-entity-snippet
	:end-before: end-get-by-user-and-entity-snippet

Get likes by all users on a specific entity
	
.. literalinclude:: snippets/likes.m
	:start-after: begin-get-by-entity-snippet
	:end-before: end-get-by-entity-snippet

List all likes in the application
	
.. literalinclude:: snippets/likes.m
  :start-after: begin-list-by-application-snippet
  :end-before: end-list-by-application-snippet
