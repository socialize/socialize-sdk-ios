.. include:: feedback_widget.rst

=========================================
Activity (Social Actions)
=========================================

Introduction
------------

Socialize allows you to retrieve information about what's going on in your app. All
of the activity-related functionality can be found in the **SZActionUtils** class.

Working with Actions
-------------------------

To retrieve the raw list of actions performed by a user

.. literalinclude:: snippets/actions.m
	:start-after: begin-user-snippet
	:end-before: end-user-snippet
	
Or get the list of actions by a single user on a single entity

.. literalinclude:: snippets/actions.m
	:start-after: begin-user-entity-snippet
	:end-before: end-user-entity-snippet

Or get the list of actions by all users on a single entity

.. literalinclude:: snippets/actions.m
	:start-after: begin-entity-snippet
	:end-before: end-entity-snippet

Or list activity for the entire application

.. literalinclude:: snippets/actions.m
	:start-after: begin-application-snippet
	:end-before: end-application-snippet
