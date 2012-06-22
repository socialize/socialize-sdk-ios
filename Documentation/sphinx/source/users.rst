.. include:: feedback_widget.rst

=========================================
Users
=========================================

Introduction
------------

Every device running Socialize has a “User”, however Socialize automatically
manages this User for you so there is no need to explicitly create one.

A User has both Settings and Activity. The Settings correspond to the User’s
preferences while using Socialize whereas the Activity relates to their social
actions.

User UI Elements
----------------

User Profile
~~~~~~~~~~~
You can display a profile view for any user which includes their recent activity

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
 

User Settings
~~~~~~~~~~~
	
To allow a user to update their settings you can simply present them with the User Settings view:

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
	

Working with Users
-------------------------------

Getting a User
~~~~~~~~~~~~~~

To obtain a reference to the current user simply call the **getCurrentUser** method

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
	
To obtain a User object for a user other than the current user

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
	

If you want to build your own UI to update a User's settings you can simply call the *saveUserSettings* method

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
 
User Activity
~~~~~~~~~~~~~

`SZActionUtils <actions.html#working-with-actions>`_ provides for retrieval of
the activity stream for a given user.

