.. include:: feedback_widget.rst

=========================================
Comments
=========================================

UI Elements
----------------------

Comments List
~~~~~~~~~~~~~

The standard Socialize Comment List UI is included with the Socialize Action
Bar however if you wanted to create your own ActionBar or simply want to launch
the Comment List from elsewhere in your app this can simply be done with a few
lines of code

.. literalinclude:: snippets/show_comments_list.m
  :start-after: begin-snippet
  :end-before: end-snippet

.. image:: images/comment_list.png	
.. image:: images/new_comment.png	
.. image:: images/comment_detail.png	

Comment Composer
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Although the comments list opens a composer, a standalone comment composition
controller is also provided:

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Working with comments
----------------------

Creating Comments
~~~~~~~~~~~~~~~~~

To create a comment programmatically you simply call the **addComment** method
on **CommentUtils**

You can also manually specify how the comment is to be propagated to 3rd party
networks (currently, customization is only possible for Facebook)

Retrieving Comments
~~~~~~~~~~~~~~~~~~~

You can retrieve existing comments by User, Entity or directly using an ID

List comments by User

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
	
List comments by Entity
	
.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
	
List comments by ID	
	
.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
