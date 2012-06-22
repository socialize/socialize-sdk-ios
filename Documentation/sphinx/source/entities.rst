.. include:: feedback_widget.rst

=========================================
Entities
=========================================

Introduction
------------

An entity is a single item of content in your app

Throughout the documentation and the code snippets we refer to an “entity”.
This is simply a generic term for something that can be view, shared, liked or
commented on. Generally this will correspond to a single item of content in
your app.

Entities in Socialize MUST be associated with a unique key. It is recommended
that where possible an HTTP URL be used (i.e. one that corresponds to an active
web page).

Working with Entities
-------------------------

Creating an Entity
~~~~~~~~~~~~~~~~~~

.. note:: You generally do not need to create an entity on your own. The `Comment <comments.html#working-with-comments>`_, `Like <likes.html#working-with-likes>`_, and `Share <sharing.html#working-with-shares>`_ utility functions will automatically create any specified entities.


Retrieving Entity Data
~~~~~~~~~~~~~~~~~~~~~~

An existing entity can be retrieved via the getEntity method. Entities obtained
in this way will also provide aggregate data on comments, likes, shares and
views. Refer to the `Entity Object Structure <http://api.getsocialize.com/docs/v1/#entity-object>`_  in the API Docs. for more detail on
these aggregate values.

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

You can also retrieve several entities in one call:

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Entity Stats
~~~~~~~~~~~~~~~~~~~~~~

Each entity object retrieved from the server contains aggregate statistics
about the number of comments,likes,views and shares:

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Entity Metadata
~~~~~~~~~~~~~~~~~~~~~~

Entities stored in Socialize can optionally include meta data. This is for any
additional information you want to store about the entity.

Meta data is stored with the entity and returned then the entity is requested.

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

If you want a more complex data structure, we recommend using JSON as an object notation

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet

Entity Activity
~~~~~~~~~~~~~~~

All actions performed on an entity (comment,share,like) can be retrieved using `SZActionUtils <actions.html#working-with-actions>`_

.. literalinclude:: snippets/placeholder.m
	:start-after: begin-snippet
	:end-before: end-snippet
