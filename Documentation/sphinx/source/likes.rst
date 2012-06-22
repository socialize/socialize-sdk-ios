.. include:: feedback_widget.rst

=========================================
Likes
=========================================

Like UI Elements
----------------

Like Button
~~~~~~~~~~~

A standalone like button is provided. See the `like button section <like_button.html>`_ for more info.

.. image:: images/like_button.png	

Working with Likes
-------------------------------

Liking
~~~~~~~

To create a like programmatically you simply call the **like** method on **SZLikeUtils**

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

You can also manually specify how the like is to be propagated to 3rd party networks such as Facebook and Twitter

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Unliking
~~~~~~~~~

You can also remove a previous like from an entity

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Retreiving Likes
~~~~~~~~~~~~~~~~

You can retrieve existing likes by User or Entity

List likes by User

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
	
List likes by Entity
	
.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
