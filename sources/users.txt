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

.. literalinclude:: snippets/users.m
	:start-after: begin-show-profile-snippet
	:end-before: end-show-profile-snippet

.. image:: images/user_profile.png
  :align: center

User Settings
~~~~~~~~~~~
	
To allow a user to update their settings you can simply present them with the User Settings view:

.. literalinclude:: snippets/users.m
	:start-after: begin-show-settings-snippet
	:end-before: end-show-settings-snippet

.. image:: images/user_settings.png
  :align: center

You can manually show the settings for further customization

.. literalinclude:: snippets/users.m
	:start-after: begin-manual-show-settings-snippet
	:end-before: end-manual-show-settings-snippet

Link Dialog
~~~~~~~~~~~
	
If you'd like to prompt the user to link to a third party on your own, you can do so:

.. literalinclude:: snippets/users.m
	:start-after: begin-show-link-dialog-snippet
	:end-before: end-show-link-dialog-snippet

.. image:: images/link_dialog.png
  :align: center

Working with Users
-------------------------------

Getting a User
~~~~~~~~~~~~~~

To obtain a reference to the current user simply call the **getCurrentUser** method

.. literalinclude:: snippets/users.m
	:start-after: begin-current-user-snippet
	:end-before: end-current-user-snippet
	
To obtain a User object users other than the current user

.. literalinclude:: snippets/users.m
	:start-after: begin-other-user-snippet
	:end-before: end-other-user-snippet
	

If you want to build your own UI to update a User's settings you can simply call the *saveUserSettings* method

.. literalinclude:: snippets/users.m
	:start-after: begin-save-settings-snippet
	:end-before: end-save-settings-snippet
 
User Activity
~~~~~~~~~~~~~

`SZActionUtils <actions.html#working-with-actions>`_ provides for retrieval of
the activity stream for a given user.

