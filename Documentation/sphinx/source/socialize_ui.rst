=========================================
Socialize UI 
=========================================

Introduction
------------
As of v0.4.0 of the Socialize SDK we are providing pre-built UI views that can 
quickly and easily be dropped in to your app, saving you the time of building 
these views yourself!

Initialize the Socialize UI System
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
To incorporate the Socialize UI views into your app you need to be authenticated. 


Socialize Comment View
----------------------
v0.4.0 of the Socialize SDK introduced the "Comment View" which provides the creation and viewing 
of comments associated with an entity (URL).  

.. image:: images/comment_list.png	
.. image:: images/new_comment.png	
.. image:: images/comment_detail.png	

Currently this supports only anonymous users, but future releases will incorporate 
additional authentication systems such as Facebook and Twitter.

Displaying the Comment View
~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you want to launch the comment view, simply instantiate and push the commentViewController :

.. raw:: html

	<script src="https://gist.github.com/1204768.js?file=CommentUI.m"></script>


Socialize Action Bar
--------------------
*Coming Soon!*