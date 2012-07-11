.. include:: feedback_widget.rst

=========================================
Sharing
=========================================

Introduction
------------

Socialize provides a complete set of helper functions to make sharing content
in your app as easy as possible.

UI Elements
-------------------------

Share Dialog
~~~~~~~~~~~~

The simplest way to allow users to share an entity (your content) is via the share dialog

.. literalinclude:: snippets/sharing.m
	:start-after: begin-show-share-dialog-snippet
	:end-before: end-show-share-dialog-snippet

.. image:: images/share_dialog.png

If you need to, you can directly instantiate the share dialog and manage its lifecycle on your own.

.. literalinclude:: snippets/sharing.m
	:start-after: begin-manual-show-share-dialog-snippet
	:end-before: end-manual-show-share-dialog-snippet

Working with Shares
-------------------

Programmatic Sharing
~~~~~~~~~~~~~~~~~~~~~~
Should you need to create a share programatically, you can do so. If you specify nil for
the share options, the default share options from the user profile will be used.

.. literalinclude:: snippets/sharing.m
	:start-after: begin-create-share-snippet
	:end-before: end-create-share-snippet

Customizing the Content of Facebook Posts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Before your share is sent off to Facebook, you are given an opportunity to modify
the parameters used to post to the user's wall

.. literalinclude:: snippets/sharing.m
	:start-after: begin-customize-facebook-share-snippet
	:end-before: end-customize-facebook-share-snippet

Directly Opening an SMS or Email Composer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you'd like to skip the share dialog and just present an email or SMS share dialog, you
can do so

.. literalinclude:: snippets/sharing.m
	:start-after: begin-show-sms-snippet
	:end-before: end-show-sms-snippet

.. literalinclude:: snippets/sharing.m
	:start-after: begin-show-email-snippet
	:end-before: end-show-email-snippet

You can retrieve information about what has been shared in your application.

.. literalinclude:: snippets/sharing.m
	:start-after: begin-get-shares-snippet
	:end-before: end-get-shares-snippet
