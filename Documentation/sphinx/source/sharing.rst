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

.. image:: images/2_0_share_default.png

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Working with Shares
-------------------

Programmatic Sharing
~~~~~~~~~~~~~~~~~~~~~~
Should you need to create a share programatically, you can do so

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Customizing the Content of Facebook Posts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Before your share is sent off to Facebook, you are given an opportunity to modify
the parameters used to post to the user's wall

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Directly Opening an SMS or Email Composer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you'd like to skip the share dialog and just present an email or SMS share dialog, you
can do so

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

You can retrieve information about what has been shared in your application.

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
