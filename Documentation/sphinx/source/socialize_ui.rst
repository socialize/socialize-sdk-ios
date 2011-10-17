.. include:: feedback_widget.rst

=========================================
Implementing the UI 
=========================================

Introduction
------------
As of v0.4.0 of the Socialize SDK we are providing pre-built UI views that can 
quickly and easily be dropped in to your app, saving you the time of building 
these views yourself!

Initialize the Socialize UI System
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
To incorporate the Socialize UI views into your app you need to be authenticated.

.. raw:: html

    <script src="https://gist.github.com/1274157.js?file=appDelegate.m"></script>

In the next release we will add anonymous authentication in the UI stuff.


Comment View
----------------------
v0.4.0 of the Socialize SDK introduced the "Comment View" which provides the creation and viewing 
of comments associated with an entity (URL).  

.. image:: images/comment_list.png	
.. image:: images/new_comment.png	
.. image:: images/comment_detail.png	

Displaying the Comment View
~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you want to launch the comment view, simply instantiate and push the commentViewController :

.. raw:: html

        <script src="https://gist.github.com/1266199.js?file=MyCustomViewController.m"></script>

Socialize Action Bar
----------------------

First you'll want to instantiate a SocializeActionBar controller and add the view to your view controller:

.. raw:: html

        <script src="https://gist.github.com/1274308.js?file=controller.m"></script>

Once that action bar is in your view you'll want to make a call to increment the view on your entity.  This will send back a view count on the entity as well as refresh the comment counter

.. raw:: html

        <script src="https://gist.github.com/1274308.js?file=viewController.m"></script> 

Adding Facebook Support
-------------------------
To add Facebook support in Socialize you'll just need to let Socialize know your Facebook app id.  You can register or find your Facebook app id here: https://developers.facebook.com/apps

.. raw:: html

        <script src=https://gist.github.com/1276197.js?file=appDelegate.m"></script>
